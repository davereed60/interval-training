import Foundation
import SwiftUI

enum Screen {
    case input
    case play
    case results
}

class SessionViewModel: ObservableObject {
    @Published var session = Session()
    @Published var currentScreen: Screen = .input
    @Published var feedbackColor: Color = .blue
    @Published var elapsedTime: TimeInterval = 0
    @Published var lastSelectedNote: Note?

    private var timer: Timer?
    private let audioService = AudioService()

    func selectScaleType(_ scaleType: ScaleType) {
        session.scaleType = scaleType
    }

    func selectRootNote(_ note: Note) {
        session.rootNote = note
    }

    func startSession() {
        guard session.scaleType != nil && session.rootNote != nil else { return }
        session.reset()
        session.startTime = Date()
        currentScreen = .play
        startTimer()
    }

    func selectNote(_ note: Note) {
        lastSelectedNote = note
        audioService.playNote(note)

        if session.isInputtingScale {
            handleScaleInput(note)
        } else {
            handleIntervalInput(note)
        }
    }

    private func handleScaleInput(_ note: Note) {
        let expectedNote = session.scale[session.currentScaleIndex]

        if note == expectedNote {
            session.correctCount += 1
            feedbackColor = .green
            session.currentScaleIndex += 1

            if session.currentScaleIndex >= session.scale.count {
                session.isInputtingScale = false
                generateRandomInterval()
            }
        } else {
            session.errorCount += 1
            feedbackColor = .red
        }

        resetFeedbackColor()
    }

    private func handleIntervalInput(_ note: Note) {
        guard let interval = session.currentInterval,
              let rootNote = session.currentIntervalRootNote else { return }

        let expectedNote = Note.note(fromSemitones: interval.semitones, above: rootNote)

        if note == expectedNote {
            session.correctCount += 1
            feedbackColor = .green
        } else {
            session.errorCount += 1
            feedbackColor = .red
        }

        resetFeedbackColor()
        generateRandomInterval()
    }

    private func generateRandomInterval() {
        session.currentInterval = Interval.allCases.randomElement()
        session.currentIntervalRootNote = session.scale.randomElement()
    }

    private func resetFeedbackColor() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.feedbackColor = .blue
        }
    }

    func stopSession() {
        session.endTime = Date()
        stopTimer()
        currentScreen = .results
    }

    func newSession() {
        currentScreen = .input
        session = Session()
        elapsedTime = 0
        lastSelectedNote = nil
    }

    func exitApp() {
        exit(0)
    }

    private func startTimer() {
        elapsedTime = 0
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            self?.elapsedTime += 1
        }
    }

    private func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
}
