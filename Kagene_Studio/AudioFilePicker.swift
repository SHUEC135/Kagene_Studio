//
//  AudioFilePicker.swift
//  Kagene_Studio
//
//  Created by 本多真一朗 on 2025/06/06.
//

import Foundation
import UIKit
import UniformTypeIdentifiers
import SwiftUI

struct DocumentPicker: UIViewControllerRepresentable {
    func makeCoordinator() -> Coordinator {
        Coordinator()
    }

    func makeUIViewController(context: Context) -> UIDocumentPickerViewController {
        let supportedTypes: [UTType] = [.audio]
        let picker = UIDocumentPickerViewController(forOpeningContentTypes: supportedTypes)
        picker.delegate = context.coordinator
        return picker
    }

    func updateUIViewController(_ uiViewController: UIDocumentPickerViewController, context: Context) {}

    class Coordinator: NSObject, UIDocumentPickerDelegate {
        func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
            guard let selectedURL = urls.first else { return }
            // Copy file to app’s local directory
            let destination = FileManager.default.temporaryDirectory.appendingPathComponent(selectedURL.lastPathComponent)
            try? FileManager.default.copyItem(at: selectedURL, to: destination)
            print("Copied file to:", destination)
        }
    }
}
