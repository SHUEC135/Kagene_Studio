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
    
    @EnvironmentObject var viewModel: ProjectListViewModel
    var onFileSaved: (URL) -> Void

    func makeCoordinator() -> Coordinator {
        Coordinator(onFileSaved: onFileSaved, viewModel: viewModel)
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
        var viewModel: ProjectListViewModel

        init(onFileSaved: @escaping (URL) -> Void, viewModel: ProjectListViewModel) {
            self.onFileSaved = onFileSaved
            self.viewModel = viewModel
        }

        func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
            guard let selectedURL = urls.first else { return }
            
            guard selectedURL.startAccessingSecurityScopedResource() else {
                print("❌ Couldn't access security scoped resource")
                return
            }

            defer {
                selectedURL.stopAccessingSecurityScopedResource()
            }

            // Ask for project name using an alert
            let alert = UIAlertController(title: "プロジェクト名を入力", message: nil, preferredStyle: .alert)
            alert.addTextField { textField in
                textField.placeholder = "プロジェクト名"
            }

            let saveAction = UIAlertAction(title: "保存", style: .default) { _ in
                guard let projectName = alert.textFields?.first?.text, !projectName.isEmpty else { return }

                // Get Documents directory
                let documents = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
                let projectFolder = documents.appendingPathComponent(projectName, isDirectory: true)
                let editedFolder = projectFolder.appendingPathComponent("Edited", isDirectory: true)


                do {
                    // Create main project folder
                    try FileManager.default.createDirectory(at: projectFolder, withIntermediateDirectories: true)

                    // Create subfolder for edited audio
                    try FileManager.default.createDirectory(at: editedFolder, withIntermediateDirectories: true)

                    // Copy original file into project folder (not in Edited)
                    let destination = projectFolder.appendingPathComponent("\(projectName).mp3")
                    try FileManager.default.copyItem(at: selectedURL, to: destination)

                    print("✅ Original file saved to: \(destination)")
                    print("📁 Edited folder created at: \(editedFolder)")

                    // Send the final saved URL back to SwiftUI if needed
                    self.onFileSaved(destination)

                } catch {
                    print("❌ Error saving file: \(error.localizedDescription)")
                }
            }
            
            alert.addAction(saveAction)
            alert.addAction(UIAlertAction(title: "キャンセル", style: .cancel))

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
