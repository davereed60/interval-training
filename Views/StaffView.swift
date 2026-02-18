import SwiftUI

struct StaffView: View {
    let selectedNote: Note?
    let displayedNotes: [Note]?
    let isScaleMode: Bool

    init(selectedNote: Note? = nil, displayedNotes: [Note]? = nil, isScaleMode: Bool = false) {
        self.selectedNote = selectedNote
        self.displayedNotes = displayedNotes
        self.isScaleMode = isScaleMode
    }

    private let staffLineSpacing: CGFloat = 20
    private let staffWidth: CGFloat = 300

    // Bass clef note reference (from md file):
    // Lines (bottom to top): G, B, D, F, A
    // Spaces (bottom to top): A, C, E, G (mnemonic: "All Cows Eat Grass")
    // Sequential: G(line) - A(space) - B(line) - C(space) - D(line) - E(space) - F(line) - G(space) - A(line)

    var body: some View {
        ZStack {
            // Background
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.white.opacity(0.9))
                .frame(width: staffWidth + 40, height: 200)

            VStack(spacing: 0) {
                Spacer()

                // Bass clef staff (5 lines)
                ZStack(alignment: .leading) {
                    // Staff lines
                    VStack(spacing: staffLineSpacing) {
                        ForEach(0..<5) { _ in
                            Rectangle()
                                .fill(Color.black)
                                .frame(width: staffWidth, height: 2)
                        }
                    }

                    // Bass clef symbol
                    Text("𝄢")
                        .font(.system(size: 80))
                        .offset(x: 10, y: -10)

                    // Display multiple notes if provided (for scale mode)
                    if let notes = displayedNotes {
                        let positions = isScaleMode ? calculateScalePositions(notes) : notes.map { yOffsetForNote($0) }

                        ForEach(Array(notes.enumerated()), id: \.offset) { index, note in
                            let xOffset: CGFloat = 60 + CGFloat(index) * 25
                            let position = positions[index]
                            let accidental = accidentalForNote(note)

                            // Accidental (sharp or flat)
                            if let acc = accidental {
                                Text(acc)
                                    .font(.system(size: 16))
                                    .offset(x: xOffset - 8, y: position)
                            }

                            Circle()
                                .fill(Color.black)
                                .frame(width: 20, height: 15)
                                .offset(x: xOffset, y: position)

                            // Ledger lines if needed
                            ForEach(ledgerLinesForPosition(position), id: \.self) { lineY in
                                Rectangle()
                                    .fill(Color.black)
                                    .frame(width: 30, height: 2)
                                    .offset(x: xOffset - 10, y: lineY)
                            }
                        }
                    }
                    // Single note if selected (for interval mode)
                    else if let note = selectedNote {
                        let position = yOffsetForNote(note)
                        let accidental = accidentalForNote(note)

                        // Accidental (sharp or flat)
                        if let acc = accidental {
                            Text(acc)
                                .font(.system(size: 16))
                                .offset(x: 112, y: position)
                        }

                        Circle()
                            .fill(Color.black)
                            .frame(width: 20, height: 15)
                            .offset(x: 120, y: position)

                        // Ledger lines if needed
                        ForEach(ledgerLinesForPosition(position), id: \.self) { lineY in
                            Rectangle()
                                .fill(Color.black)
                                .frame(width: 30, height: 2)
                                .offset(x: 110, y: lineY)
                        }

                        // Note name label
                        Text(note.rawValue)
                            .font(.headline)
                            .foregroundColor(.blue)
                            .offset(x: 200, y: position)
                    }
                }
                .frame(width: staffWidth, height: staffLineSpacing * 4)

                Spacer()
            }
        }
        .frame(height: 200)
    }

    // Calculate Y offset for note position on staff
    // Bass clef from md file:
    // Lines (bottom to top): G, B, D, F, A
    // Spaces (bottom to top): A, C, E, G
    // Using D (middle line, 3rd line) as reference point (position 0)
    private func yOffsetForNote(_ note: Note) -> CGFloat {
        let notePositions: [Note: CGFloat] = [
            .C: 1.0,      // C - space 2 (between B line and D line) "All Cows Eat Grass"
            .CSharp: 0.5, // C# - between C space and D line
            .D: 0.0,      // D - middle line (3rd line)
            .DSharp: -0.5, // D# - between D line and E space
            .E: -1.0,     // E - space 3 (between D line and F line)
            .F: -2.0,     // F - 4th line
            .FSharp: -2.5, // F# - between F line and G space
            .G: -3.0,     // G - space 4 (top space, between F line and A line)
            .GSharp: -3.5, // G# - between G space and A line
            .A: -4.0,     // A - line 5 (top line)
            .ASharp: -4.5, // A# - between A line and B ledger
            .B: -5.0,     // B - ledger line above staff
        ]

        let position = notePositions[note] ?? 0.0
        let spacing = staffLineSpacing / 2.0

        // Convert position to Y offset (positive = down, negative = up)
        return position * spacing
    }

    // Get lowest possible position for a note letter
    // E is the lowest drawable note per specs
    private func lowestPositionForNote(_ note: Note) -> CGFloat {
        let baseLetter = baseNoteLetter(note)
        let spacing = staffLineSpacing / 2.0

        // Lowest positions (highest Y values / furthest down)
        // E is the absolute lowest drawable note
        let lowestPositions: [String: CGFloat] = [
            "E": -1.0,    // E - space 3 (lowest drawable per specs)
            "F": -2.0,    // F - 4th line
            "G": 4.0,     // G - bottom line (not top space)
            "A": 3.0,     // A - 1st space (not top line)
            "B": 2.0,     // B - 2nd line
            "C": 1.0,     // C - 2nd space
            "D": 0.0      // D - middle line
        ]

        let position = lowestPositions[baseLetter] ?? 0.0
        return position * spacing
    }

    // Determine if ledger lines are needed for notes above the staff
    private func ledgerLinesForNote(_ note: Note) -> [CGFloat] {
        var ledgerLines: [CGFloat] = []

        // B sits on a ledger line above the staff (above A which is the top line)
        if note == .B {
            ledgerLines.append(-staffLineSpacing * 2.5) // Position of B ledger line
        }
        // A# is between A (top line) and B (ledger), might need ledger for reference
        if note == .ASharp {
            ledgerLines.append(-staffLineSpacing * 2.5) // Show B ledger line for reference
        }

        return ledgerLines
    }

    // Generate ledger lines based on Y position
    private func ledgerLinesForPosition(_ yPosition: CGFloat) -> [CGFloat] {
        var ledgerLines: [CGFloat] = []

        // Check if note is above the staff (negative Y values)
        if yPosition <= -staffLineSpacing * 2.5 {
            // B ledger line
            ledgerLines.append(-staffLineSpacing * 2.5)
        }

        return ledgerLines
    }

    // Get accidental symbol for a note (sharp or flat)
    private func accidentalForNote(_ note: Note) -> String? {
        switch note {
        case .CSharp, .DSharp, .FSharp, .GSharp, .ASharp:
            return "#"
        default:
            return nil
        }
    }

    // Get the base note letter (C, D, E, F, G, A, or B)
    private func baseNoteLetter(_ note: Note) -> String {
        let noteString = note.rawValue
        return String(noteString.prefix(1))
    }

    // Calculate positions for all notes in scale ensuring ascending order
    // Rule: Start as low as possible (E is lowest), always go up
    private func calculateScalePositions(_ notes: [Note]) -> [CGFloat] {
        var positions: [CGFloat] = []

        for (index, note) in notes.enumerated() {
            var position: CGFloat

            if index == 0 {
                // First note: use lowest possible position
                position = lowestPositionForNote(note)
            } else {
                // Subsequent notes: try standard position, then ensure ascending
                position = yOffsetForNote(note)

                let prevPosition = positions[index - 1]
                // If current position is not higher than previous, adjust it
                if position >= prevPosition {
                    // Move up by at least 0.5 step (half space)
                    position = prevPosition - 0.5
                }
            }

            positions.append(position)
        }

        return positions
    }
}

#Preview {
    VStack(spacing: 20) {
        StaffView(selectedNote: .C)
        StaffView(selectedNote: .G)
        StaffView(selectedNote: nil)
    }
    .padding()
    .background(Color.gray.opacity(0.2))
}
