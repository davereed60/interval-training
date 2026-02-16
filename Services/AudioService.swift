import Foundation
import AVFoundation

class AudioService {
    private var audioEngine = AVAudioEngine()
    private var playerNode = AVAudioPlayerNode()

    init() {
        setupAudioEngine()
    }

    private func setupAudioEngine() {
        audioEngine.attach(playerNode)
        audioEngine.connect(playerNode, to: audioEngine.mainMixerNode, format: nil)

        do {
            try audioEngine.start()
        } catch {
            print("Error starting audio engine: \(error.localizedDescription)")
        }
    }

    func playNote(_ note: Note) {
        let sampleRate = 44100.0
        let duration = 0.5
        let amplitude: Float = 0.3
        let frequency = note.frequency

        let frameCount = AVAudioFrameCount(sampleRate * duration)
        guard let buffer = AVAudioPCMBuffer(pcmFormat: audioEngine.mainMixerNode.outputFormat(forBus: 0),
                                            frameCapacity: frameCount) else { return }

        buffer.frameLength = frameCount

        guard let floatData = buffer.floatChannelData else { return }

        for frame in 0..<Int(frameCount) {
            let value = sin(2.0 * .pi * frequency * Double(frame) / sampleRate)
            let envelope = 1.0 - (Double(frame) / Double(frameCount))
            floatData[0][frame] = Float(value * envelope) * amplitude
            if buffer.format.channelCount > 1 {
                floatData[1][frame] = floatData[0][frame]
            }
        }

        playerNode.scheduleBuffer(buffer, completionHandler: nil)

        if !playerNode.isPlaying {
            playerNode.play()
        }
    }
}
