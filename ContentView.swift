import SwiftUI

struct ContentView: View {
    @EnvironmentObject var viewModel: SessionViewModel

    var body: some View {
        switch viewModel.currentScreen {
        case .input:
            InputView()
        case .play:
            PlayView()
        case .results:
            ResultsView()
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(SessionViewModel())
}
