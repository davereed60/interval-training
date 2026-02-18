import Foundation

struct Session {
    var scaleType: ScaleType?
    var rootNote: Note?
    var correctCount: Int = 0
    var errorCount: Int = 0
    var startTime: Date?
    var endTime: Date?
    var currentScaleIndex: Int = 0
    var isInputtingScale: Bool = true
    var currentInterval: Interval?
    var currentIntervalRootNote: Note?
    var correctScaleNotes: [Note] = []

    var sessionDuration: TimeInterval {
        guard let start = startTime, let end = endTime else { return 0 }
        return end.timeIntervalSince(start)
    }

    var scale: [Note] {
        guard let scaleType = scaleType, let rootNote = rootNote else { return [] }
        return scaleType.notes(from: rootNote)
    }

    mutating func reset() {
        correctCount = 0
        errorCount = 0
        startTime = nil
        endTime = nil
        currentScaleIndex = 0
        isInputtingScale = true
        currentInterval = nil
        currentIntervalRootNote = nil
        correctScaleNotes = []
    }
}
