import SwiftUI

struct ResultsView: View {
    @EnvironmentObject var viewModel: SessionViewModel

    var body: some View {
        ZStack {
            LinearGradient(colors: [.green.opacity(0.3), .blue.opacity(0.3)],
                          startPoint: .topLeading,
                          endPoint: .bottomTrailing)
                .ignoresSafeArea()

            VStack(spacing: 30) {
                Text("Session Complete!")
                    .font(.largeTitle)
                    .fontWeight(.bold)

                VStack(spacing: 20) {
                    ResultCard(
                        title: "Correct",
                        value: "\(viewModel.session.correctCount)",
                        color: .green
                    )

                    ResultCard(
                        title: "Errors",
                        value: "\(viewModel.session.errorCount)",
                        color: .red
                    )

                    ResultCard(
                        title: "Duration",
                        value: formatTime(viewModel.session.sessionDuration),
                        color: .blue
                    )

                    if viewModel.session.correctCount + viewModel.session.errorCount > 0 {
                        let accuracy = Double(viewModel.session.correctCount) / Double(viewModel.session.correctCount + viewModel.session.errorCount) * 100
                        ResultCard(
                            title: "Accuracy",
                            value: String(format: "%.1f%%", accuracy),
                            color: .purple
                        )
                    }
                }
                .padding()

                Spacer()

                Button(action: {
                    viewModel.newSession()
                }) {
                    Text("New Session")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(15)
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

    private func formatTime(_ timeInterval: TimeInterval) -> String {
        let minutes = Int(timeInterval) / 60
        let seconds = Int(timeInterval) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
}

struct ResultCard: View {
    let title: String
    let value: String
    let color: Color

    var body: some View {
        HStack {
            Text(title)
                .font(.title3)
                .fontWeight(.medium)

            Spacer()

            Text(value)
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(color)
        }
        .padding()
        .background(Color.white.opacity(0.9))
        .cornerRadius(10)
    }
}

#Preview {
    ResultsView()
        .environmentObject(SessionViewModel())
}
