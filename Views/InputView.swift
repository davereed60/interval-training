import SwiftUI

struct InputView: View {
    @EnvironmentObject var viewModel: SessionViewModel

    var body: some View {
        ZStack {
            LinearGradient(colors: [.blue.opacity(0.3), .purple.opacity(0.3)],
                          startPoint: .topLeading,
                          endPoint: .bottomTrailing)
                .ignoresSafeArea()

            VStack(spacing: 30) {
                Text("Interval Training")
                    .font(.largeTitle)
                    .fontWeight(.bold)

                VStack(alignment: .leading, spacing: 15) {
                    Text("Select Scale Type")
                        .font(.headline)

                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                        ForEach(ScaleType.allCases) { scaleType in
                            Button(action: {
                                viewModel.selectScaleType(scaleType)
                            }) {
                                Text(scaleType.rawValue)
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(viewModel.session.scaleType == scaleType ? Color.blue : Color.gray.opacity(0.3))
                                    .foregroundColor(.white)
                                    .cornerRadius(10)
                            }
                        }
                    }
                }
                .padding()

                VStack(alignment: .leading, spacing: 15) {
                    Text("Select Root Note")
                        .font(.headline)

                    LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 4), spacing: 12) {
                        ForEach(Note.allCases) { note in
                            Button(action: {
                                viewModel.selectRootNote(note)
                            }) {
                                Text(note.rawValue)
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(viewModel.session.rootNote == note ? Color.green : Color.gray.opacity(0.3))
                                    .foregroundColor(.white)
                                    .cornerRadius(10)
                            }
                        }
                    }
                }
                .padding()

                Spacer()

                // Training mode selection buttons
                HStack(spacing: 15) {
                    Button(action: {
                        viewModel.startScaleTraining()
                    }) {
                        VStack {
                            Text("Scale")
                                .font(.title2)
                                .fontWeight(.semibold)
                            Text("Training")
                                .font(.caption)
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(viewModel.session.scaleType != nil && viewModel.session.rootNote != nil ? Color.blue : Color.gray)
                        .foregroundColor(.white)
                        .cornerRadius(15)
                    }
                    .disabled(viewModel.session.scaleType == nil || viewModel.session.rootNote == nil)

                    Button(action: {
                        viewModel.startIntervalTraining()
                    }) {
                        VStack {
                            Text("Interval")
                                .font(.title2)
                                .fontWeight(.semibold)
                            Text("Training")
                                .font(.caption)
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(viewModel.session.scaleType != nil && viewModel.session.rootNote != nil ? Color.green : Color.gray)
                        .foregroundColor(.white)
                        .cornerRadius(15)
                    }
                    .disabled(viewModel.session.scaleType == nil || viewModel.session.rootNote == nil)
                }
                .padding(.horizontal)

                Button(action: {
                    viewModel.exitApp()
                }) {
                    Text("Exit")
                        .font(.title3)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.red.opacity(0.7))
                        .foregroundColor(.white)
                        .cornerRadius(15)
                }
                .padding(.horizontal)
                .padding(.bottom)
            }
            .padding()
        }
    }
}

#Preview {
    InputView()
        .environmentObject(SessionViewModel())
}
