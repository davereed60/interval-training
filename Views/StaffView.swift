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
    // Bass clef: Lines from bottom to top are G2, B2, D3, F3, A3
    // Spaces from bottom to top are A2, C3, E3, G3
    // Position 0 = A3 (top line), increasing numbers go down
    private func yOffsetForNote(_ note: Note) -> CGFloat {
        let notePositions: [Note: CGFloat] = [
            .C: 5.0,      // C3 - second space
            .CSharp: 4.5, // C#3/Db3
            .D: 4.0,      // D3 - middle line
            .DSharp: 3.5, // D#3/Eb3
            .E: 3.0,      // E3 - third space
            .F: 2.0,      // F3 - fourth line
            .FSharp: 1.5, // F#3/Gb3
            .G: 1.0,      // G3 - top space
            .GSharp: 0.5, // G#3/Ab3
            .A: 0.0,      // A3 - top line
            .ASharp: -0.5, // A#3/Bb3 - above staff
            .B: -1.0,     // B3 - ledger line above
        ]

        let position = notePositions[note] ?? 0.0
        let spacing = staffLineSpacing / 2.0

        // Convert position to Y offset (positive = down)
        return position * spacing
    }

    // Determine if ledger lines are needed
    private func ledgerLinesForNote(_ note: Note) -> [CGFloat] {
        var ledgerLines: [CGFloat] = []

        // Add ledger lines for notes above the staff
        if note == .B {
            // B3 needs one ledger line above A3
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
