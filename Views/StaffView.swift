import SwiftUI

struct StaffView: View {
    let selectedNote: Note?

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

                    // Note head if a note is selected
                    if let note = selectedNote {
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
    // Bass clef: Lines are G2, B2, D3, F3, A3 (bottom to top)
    // Spaces are A2, C3, E3, G3 (bottom to top)
    private func yOffsetForNote(_ note: Note) -> CGFloat {
        let notePositions: [Note: Int] = [
            .C: 6,      // C2 - below staff
            .CSharp: 5,  // C#2/Db2
            .D: 5,      // D2
            .DSharp: 4,  // D#2/Eb2
            .E: 4,      // E2
            .F: 3,      // F2
            .FSharp: 2,  // F#2/Gb2
            .G: 2,      // G2 - bottom line
            .GSharp: 1,  // G#2/Ab2
            .A: 1,      // A2 - first space
            .ASharp: 0,  // A#2/Bb2
            .B: 0,      // B2 - second line
        ]

        let position = notePositions[note] ?? 0
        let spacing = staffLineSpacing / 2.0

        // Convert position to Y offset (positive = down)
        return CGFloat(position) * spacing
    }

    // Determine if ledger lines are needed
    private func ledgerLinesForNote(_ note: Note) -> [CGFloat] {
        var ledgerLines: [CGFloat] = []

        // Add ledger lines for notes outside the staff
        // Middle C (C3) needs a ledger line above the staff
        if note == .C {
            ledgerLines.append(-staffLineSpacing * 2 - staffLineSpacing / 2)
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
