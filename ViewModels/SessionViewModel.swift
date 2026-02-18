import Foundation
import SwiftUI

enum Screen {
    case input
    case scale
    case interval
    case results
}

enum TrainingMode {
    case scale
    case interval
}

class SessionViewModel: ObservableObject {
    @Published var session = Session()
    @Published var currentScreen: Screen = .input
    @Published var feedbackColor: Color = .blue
    @Published var elapsedTime: TimeInterval = 0
    @Published var lastSelectedNote: Note?
    @Published var trainingMode: TrainingMode = .scale

    private var timer: Timer?
    private let audioService = AudioService()

    func selectScaleType(_ scaleType: ScaleType) {
        session.scaleType = scaleType
    }

    func selectRootNote(_ note: Note) {
        session.rootNote = note
    }

    func startScaleTraining() {
        guard session.scaleType != nil && session.rootNote != nil else { return }
        session.reset()
        session.startTime = Date()
        trainingMode = .scale
        currentScreen = .scale
        startTimer()
    }

    func startIntervalTraining() {
        guard session.scaleType != nil && session.rootNote != nil else { return }
        session.reset()
        session.startTime = Date()
        trainingMode = .interval
        session.isInputtingScale = false
        generateRandomInterval()
        currentScreen = .interval
        startTimer()
    }

    func selectNote(_ note: Note) {
        audioService.playNote(note)

        if trainingMode == .scale {
            handleScaleInput(note)
        } else {
            handleIntervalInput(note)
        }
    }

    func selectNoteForInterval(_ note: Note) {
        guard let rootNote = session.currentIntervalRootNote else { return }
        audioService.playNoteSequence([rootNote, note])
        handleIntervalInput(note)
    }

    private func handleScaleInput(_ note: Note) {
        let expectedNote = session.scale[session.currentScaleIndex]

        if note == expectedNote {
            lastSelectedNote = note
            session.correctCount += 1
            feedbackColor = .green
            session.currentScaleIndex += 1

            if session.currentScaleIndex >= session.scale.count {
                // Scale complete - reset for next round
                session.currentScaleIndex = 0
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
            lastSelectedNote = note
            session.correctCount += 1
            feedbackColor = .green
        } else {
            session.errorCount += 1
            feedbackColor = .red
            lastSelectedNote = nil
        }

        resetFeedbackColor()

        // Generate next interval after a delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.lastSelectedNote = nil
            self.generateRandomInterval()
        }
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
