import SwiftUI

struct ScaleView: View {
    @EnvironmentObject var viewModel: SessionViewModel

    var body: some View {
        ZStack {
            viewModel.feedbackColor.opacity(0.2)
                .ignoresSafeArea()
                .animation(.easeInOut(duration: 0.3), value: viewModel.feedbackColor)

            VStack(spacing: 20) {
                // Header with scale info and stats
                VStack(spacing: 10) {
                    HStack {
                        VStack(alignment: .leading) {
                            Text("Scale: \(viewModel.session.scaleType?.rawValue ?? "")")
                                .font(.headline)
                            Text("Root: \(viewModel.session.rootNote?.rawValue ?? "")")
                                .font(.headline)
                        }

                        Spacer()

                        VStack(alignment: .trailing) {
                            Text("Time: \(Int(viewModel.elapsedTime))s")
                                .font(.headline)
                            Text("✓ \(viewModel.session.correctCount)  ✗ \(viewModel.session.errorCount)")
                                .font(.headline)
                        }
                    }
                    .padding()
                    .background(Color.white.opacity(0.9))
                    .cornerRadius(10)

                    // Scale pattern display
                    if let scaleType = viewModel.session.scaleType {
                        Text("Pattern: \(scaleType.pattern)")
                            .font(.title3)
                            .fontWeight(.semibold)
                            .padding(.vertical, 8)
                            .padding(.horizontal, 16)
                            .background(Color.orange.opacity(0.2))
                            .cornerRadius(8)
                    }
                }
                .padding(.horizontal)

                Text("Input the scale notes in order")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .padding(.top)

                Text("Next note: #\(viewModel.session.currentScaleIndex + 1)")
                    .font(.headline)
                    .foregroundColor(.secondary)

                // Bass clef staff display - only show if note is correct
                StaffView(selectedNote: viewModel.lastSelectedNote)
                    .padding(.horizontal)

                Spacer()

                // Note selection buttons
                VStack(spacing: 15) {
                    Text("Select a note:")
                        .font(.headline)

                    LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 4), spacing: 12) {
                        ForEach(Note.allCases) { note in
                            Button(action: {
                                viewModel.selectNote(note)
                            }) {
                                Text(note.rawValue)
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(Color.blue)
                                    .foregroundColor(.white)
                                    .cornerRadius(10)
                            }
                        }
                    }
                }
                .padding()

                Spacer()

                // Control buttons
                HStack(spacing: 20) {
                    Button(action: {
                        viewModel.stopSession()
                    }) {
                        Text("Stop")
                            .font(.title2)
                            .fontWeight(.semibold)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.orange)
                            .foregroundColor(.white)
                            .cornerRadius(15)
                    }

                    Button(action: {
                        viewModel.exitApp()
                    }) {
                        Text("Exit")
                            .font(.title2)
                            .fontWeight(.semibold)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.red.opacity(0.7))
                            .foregroundColor(.white)
                            .cornerRadius(15)
                    }
                }
                .padding(.horizontal)
                .padding(.bottom)
            }
        }
    }
}

#Preview {
    ScaleView()
        .environmentObject(SessionViewModel())
}
