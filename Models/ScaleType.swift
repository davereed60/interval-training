import Foundation

enum ScaleType: String, CaseIterable, Identifiable {
    case ionian = "Ionian"
    case dorian = "Dorian"
    case phrygian = "Phrygian"
    case lydian = "Lydian"
    case mixolydian = "Mixolydian"
    case aeolian = "Aeolian"
    case locrian = "Locrian"

    var id: String { rawValue }

    var pattern: String {
        let steps = zip(intervals, intervals.dropFirst()).map { current, next in
            (next - current) == 2 ? "W" : "H"
        }
        return steps.joined(separator: "-")
    }

    var intervals: [Int] {
        switch self {
        case .ionian:     return [0, 2, 4, 5, 7, 9, 11]  // Major scale
        case .dorian:     return [0, 2, 3, 5, 7, 9, 10]
        case .phrygian:   return [0, 1, 3, 5, 7, 8, 10]
        case .lydian:     return [0, 2, 4, 6, 7, 9, 11]
        case .mixolydian: return [0, 2, 4, 5, 7, 9, 10]
        case .aeolian:    return [0, 2, 3, 5, 7, 8, 10]  // Natural minor
        case .locrian:    return [0, 1, 3, 5, 6, 8, 10]
        }
    }

    func notes(from root: Note) -> [Note] {
        return intervals.map { semitones in
            Note.note(fromSemitones: semitones, above: root)
        }
    }
}
