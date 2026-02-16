import SwiftUI

@main
struct IntervalTrainingApp: App {
    @StateObject private var sessionViewModel = SessionViewModel()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(sessionViewModel)
        }
    }
}
