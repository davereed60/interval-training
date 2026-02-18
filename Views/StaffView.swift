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
    // Notes are C4-B4 (middle C octave), displayed above bass clef staff
    // Using A3 (top line) as reference point (position 0)
    private func yOffsetForNote(_ note: Note) -> CGFloat {
        let notePositions: [Note: CGFloat] = [
            .C: -2.0,      // C4 - middle C, first ledger line above staff
            .CSharp: -2.5, // C#4/Db4
            .D: -3.0,      // D4 - above ledger line
            .DSharp: -3.5, // D#4/Eb4
            .E: -4.0,      // E4 - second ledger line above
            .F: -5.0,      // F4 - above second ledger line
            .FSharp: -5.5, // F#4/Gb4
            .G: -6.0,      // G4 - third ledger line above
            .GSharp: -6.5, // G#4/Ab4
            .A: -7.0,      // A4 - above third ledger line
            .ASharp: -7.5, // A#4/Bb4
            .B: -8.0,      // B4 - fourth ledger line above
        ]

        let position = notePositions[note] ?? 0.0
        let spacing = staffLineSpacing / 2.0

        // Convert position to Y offset (positive = down, negative = up)
        return position * spacing
    }

    // Determine if ledger lines are needed for notes above the staff
    private func ledgerLinesForNote(_ note: Note) -> [CGFloat] {
        var ledgerLines: [CGFloat] = []

        // All notes C4-B4 are above the staff and need ledger lines
        switch note {
        case .C, .CSharp:
            // C4: first ledger line above staff
            ledgerLines.append(-staffLineSpacing)
        case .D, .DSharp:
            // D4: above C4, still needs C4 ledger line
            ledgerLines.append(-staffLineSpacing)
        case .E:
            // E4: second ledger line
            ledgerLines.append(-staffLineSpacing)
            ledgerLines.append(-staffLineSpacing * 2)
        case .F, .FSharp:
            // F4: above E4
            ledgerLines.append(-staffLineSpacing)
            ledgerLines.append(-staffLineSpacing * 2)
        case .G, .GSharp:
            // G4: third ledger line
            ledgerLines.append(-staffLineSpacing)
            ledgerLines.append(-staffLineSpacing * 2)
            ledgerLines.append(-staffLineSpacing * 3)
        case .A, .ASharp, .B:
            // A4-B4: need all ledger lines up to fourth
            ledgerLines.append(-staffLineSpacing)
            ledgerLines.append(-staffLineSpacing * 2)
            ledgerLines.append(-staffLineSpacing * 3)
            if note == .B {
                ledgerLines.append(-staffLineSpacing * 4)
            }
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
