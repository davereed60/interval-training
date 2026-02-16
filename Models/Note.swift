import Foundation

enum Note: String, CaseIterable, Identifiable {
    case C = "C"
    case CSharp = "C#/Db"
    case D = "D"
    case DSharp = "D#/Eb"
    case E = "E"
    case F = "F"
    case FSharp = "F#/Gb"
    case G = "G"
    case GSharp = "G#/Ab"
    case A = "A"
    case ASharp = "A#/Bb"
    case B = "B"

    var id: String { rawValue }

    var frequency: Double {
        let baseFrequencies: [Note: Double] = [
            .C: 261.63,
            .CSharp: 277.18,
            .D: 293.66,
            .DSharp: 311.13,
            .E: 329.63,
            .F: 349.23,
            .FSharp: 369.99,
            .G: 392.00,
            .GSharp: 415.30,
            .A: 440.00,
            .ASharp: 466.16,
            .B: 493.88
        ]
        return baseFrequencies[self] ?? 440.0
    }

    static func note(fromSemitones semitones: Int, above root: Note) -> Note {
        let rootIndex = Note.allCases.firstIndex(of: root) ?? 0
        let targetIndex = (rootIndex + semitones) % 12
        return Note.allCases[targetIndex]
    }
}
