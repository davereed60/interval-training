import Foundation

enum Interval: String, CaseIterable, Identifiable {
    case minorSecond = "Minor 2nd"
    case majorSecond = "Major 2nd"
    case minorThird = "Minor 3rd"
    case majorThird = "Major 3rd"
    case fourth = "Fourth"
    case augFourthDimFifth = "Aug 4th/Dim 5th"
    case fifth = "Fifth"
    case minorSixth = "Minor 6th"
    case majorSixth = "Major 6th"
    case minorSeventh = "Minor 7th"
    case majorSeventh = "Major 7th"

    var id: String { rawValue }

    var semitones: Int {
        switch self {
        case .minorSecond: return 1
        case .majorSecond: return 2
        case .minorThird: return 3
        case .majorThird: return 4
        case .fourth: return 5
        case .augFourthDimFifth: return 6
        case .fifth: return 7
        case .minorSixth: return 8
        case .majorSixth: return 9
        case .minorSeventh: return 10
        case .majorSeventh: return 11
        }
    }
}
