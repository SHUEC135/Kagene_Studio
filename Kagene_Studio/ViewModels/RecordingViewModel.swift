//
//  RecordingViewModel.swift
//  Kagene_Studio
//
//  Created by 本多真一朗 on 2025/06/05.
//

import Foundation
import AVFoundation

class RecordingViewModel: ObservableObject {
    private var audioRecorder: AVAudioRecorder?
    private func getAudioFileURL() -> URL {
        let tempDir = FileManager.default.temporaryDirectory
        return tempDir.appendingPathComponent("recording.m4a")
    }
    private func deleteRecordingFile() {
        let url = getAudioFileURL()
        if FileManager.default.fileExists(atPath: url.path) {
            try? FileManager.default.removeItem(at: url)
        }
    }
    
    @Published var isRecording = false
    
    init() {
        setupAudioSession()
    }
    
    private func setupAudioSession() {
        do {
            let session = AVAudioSession.sharedInstance()
            try session.setCategory(.playAndRecord, mode: .spokenAudio, options: [.defaultToSpeaker])
            try session.setActive(true)
            
            // iOS 17 and later
            if #available(iOS 17.0, *) {
                AVAudioApplication.requestRecordPermission { allowed in
                    DispatchQueue.main.async {
                        if !allowed {
                            print("Microphone access denied (iOS 17+).")
                        }
                    }
                }
            } else {
                // Fallback for iOS 16 and earlier
                session.requestRecordPermission { allowed in
                    DispatchQueue.main.async {
                        if !allowed {
                            print("Microphone access denied (iOS <17).")
                        }
                    }
                }
            }
        } catch {
            print("Failed to set up audio session: \(error)")
        }
    }
    
    func startRecording() {
        let audioFilename = getAudioFileURL()
        
        let settings: [String: Any] = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 12000,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]

        do {
            audioRecorder = try AVAudioRecorder(url: audioFilename, settings: settings)
            audioRecorder?.prepareToRecord()
            audioRecorder?.record()
            isRecording = true
        } catch {
            print("Failed to start recording: \(error)")
        }
    }
    
    func stopRecording() {
        audioRecorder?.stop()
        isRecording = false
    }
}
