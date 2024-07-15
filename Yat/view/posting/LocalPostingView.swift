//
//  LocalPostingView.swift
//  Yat
//
//  Created by Pengfei Wu on 2024/7/15.
//

import SwiftUI

struct LocalPostingView: View {
    
    @State private var selectedFile: URL?
    
    
    var body: some View {
        VStack {
            if let selectedFile = selectedFile {
                Text("Selected file: \(selectedFile.path)")
            } else {
                Text("No file selected")
            }
            Button("Open File") {
                openFile()
            }
            .padding()
        }
    }
    
    
    // Function to handle file opening
    private func openFile() {
        let panel = NSOpenPanel()
        panel.canChooseFiles = true
        panel.canChooseDirectories = false
        panel.allowsMultipleSelection = false
        
        if panel.runModal() == .OK {
            self.selectedFile = panel.url
        }
    }
}

#Preview {
    LocalPostingView()
}
