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
    // This callback will send the picked file URL and project name back to SwiftUI
    var onFileSaved: (URL) -> Void

    func makeCoordinator() -> Coordinator {
        Coordinator(onFileSaved: onFileSaved)
    }

    func makeUIViewController(context: Context) -> UIDocumentPickerViewController {
        let supportedTypes: [UTType] = [.audio]
        let picker = UIDocumentPickerViewController(forOpeningContentTypes: supportedTypes)
        picker.delegate = context.coordinator
        return picker
    }

    func updateUIViewController(_ uiViewController: UIDocumentPickerViewController, context: Context) {}

    class Coordinator: NSObject, UIDocumentPickerDelegate {
        var onFileSaved: (URL) -> Void

        init(onFileSaved: @escaping (URL) -> Void) {
            self.onFileSaved = onFileSaved
        }

        func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
            guard let selectedURL = urls.first else { return }

            // Ask for project name using an alert
            let alert = UIAlertController(title: "Enter Project Name", message: nil, preferredStyle: .alert)
            alert.addTextField { textField in
                textField.placeholder = "Project name"
            }

            let saveAction = UIAlertAction(title: "Save", style: .default) { _ in
                guard let projectName = alert.textFields?.first?.text, !projectName.isEmpty else { return }

                // Create directory inside app's Documents folder
                let documents = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
                let projectFolder = documents.appendingPathComponent(projectName, isDirectory: true)

                do {
                    try FileManager.default.createDirectory(at: projectFolder, withIntermediateDirectories: true)

                    // Copy selected file into the project folder
                    let destination = projectFolder.appendingPathComponent(selectedURL.lastPathComponent)
                    try FileManager.default.copyItem(at: selectedURL, to: destination)

                    print("Saved file to:", destination)

                    // Send the final saved URL back to SwiftUI if needed
                    self.onFileSaved(destination)

                } catch {
                    print("❌ Error saving file: \(error.localizedDescription)")
                }
            }

            alert.addAction(saveAction)
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))

            // Present the alert
//            controller.present(alert, animated: true)
            if let rootVC = UIApplication.shared.connectedScenes
                .compactMap({ $0 as? UIWindowScene })
                .first?.windows
                .first(where: { $0.isKeyWindow })?.rootViewController {
                rootVC.present(alert, animated: true)
            }
        }
    }
}
