import SwiftUI

struct StaffView: View {
    let selectedNote: Note?
    let displayedNotes: [Note]?

    init(selectedNote: Note? = nil, displayedNotes: [Note]? = nil) {
        self.selectedNote = selectedNote
        self.displayedNotes = displayedNotes
    }

    private let staffLineSpacing: CGFloat = 20
    private let staffWidth: CGFloat = 300

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
                        ForEach(Array(notes.enumerated()), id: \.offset) { index, note in
                            let xOffset: CGFloat = 60 + CGFloat(index) * 25

                            Circle()
                                .fill(Color.black)
                                .frame(width: 20, height: 15)
                                .offset(x: xOffset, y: yOffsetForNote(note))

                            // Ledger lines if needed
                            ForEach(ledgerLinesForNote(note), id: \.self) { lineY in
                                Rectangle()
                                    .fill(Color.black)
                                    .frame(width: 30, height: 2)
                                    .offset(x: xOffset - 10, y: lineY)
                            }
                        }
                    }
                    // Single note if selected (for interval mode)
                    else if let note = selectedNote {
                        Circle()
                            .fill(Color.black)
                            .frame(width: 20, height: 15)
                            .offset(x: 120, y: yOffsetForNote(note))

                        // Ledger lines if needed
                        ForEach(ledgerLinesForNote(note), id: \.self) { lineY in
                            Rectangle()
                                .fill(Color.black)
                                .frame(width: 30, height: 2)
                                .offset(x: 110, y: lineY)
                        }

                        // Note name label
                        Text(note.rawValue)
                            .font(.headline)
                            .foregroundColor(.blue)
                            .offset(x: 200, y: yOffsetForNote(note))
                    }
                }
                .frame(width: staffWidth, height: staffLineSpacing * 4)

                Spacer()
            }
        }
        .frame(height: 200)
    }

    // Calculate Y offset for note position on staff
    // Bass clef staff lines (bottom to top): G2, B2, D3, F3, A3
    // Staff spaces (bottom to top): A2, C3, E3, G3
    // Using A3 (top line) as reference point (position 0)
    private func yOffsetForNote(_ note: Note) -> CGFloat {
        let notePositions: [Note: CGFloat] = [
            .C: 5.0,      // C3 - space above 2nd line (B2)
            .CSharp: 4.5, // C#3/Db3
            .D: 4.0,      // D3 - middle line (3rd line)
            .DSharp: 3.5, // D#3/Eb3
            .E: 3.0,      // E3 - space above middle line
            .F: 2.0,      // F3 - 4th line
            .FSharp: 1.5, // F#3/Gb3
            .G: 1.0,      // G3 - top space
            .GSharp: 0.5, // G#3/Ab3
            .A: 0.0,      // A3 - top line (5th line)
            .ASharp: -0.5, // A#3/Bb3
            .B: -1.0,     // B3 - ledger line above staff
        ]

        let position = notePositions[note] ?? 0.0
        let spacing = staffLineSpacing / 2.0

        // Convert position to Y offset (positive = down, negative = up)
        return position * spacing
    }

    // Determine if ledger lines are needed for notes above the staff
    private func ledgerLinesForNote(_ note: Note) -> [CGFloat] {
        var ledgerLines: [CGFloat] = []

        // Only B3 needs a ledger line above the staff
        if note == .B || note == .ASharp {
            ledgerLines.append(-staffLineSpacing)
        }

        return ledgerLines
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
