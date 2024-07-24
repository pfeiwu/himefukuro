//
//  LocalPostingView.swift
//  Yat
//
//  Created by Pengfei Wu on 2024/7/15.
//

import SwiftUI
import SwiftData

struct LocalPostingView: View {
    
    @State private var selectedFile: URL?
    

    
    var body: some View {
        NavigationView {
            List(BookManager.shared.allBooks) { book in
                NavigationLink(destination: PostingDetailView(book: book)) {
                    Text(book.title)
                }
            }
            .listStyle(SidebarListStyle())
            .navigationTitle("Books")
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button(action: openFile) {
                        Image(systemName: "plus")
                    }
                }
            }
            PostingDetailView(book: BookManager.shared.allBooks.first)
        }.onAppear(){
            BookManager.loadAllBooks()
        }
    }
    
    
    // 点+号时，让用户定位到文件
    // Function to handle file opening
    private func openFile() {
        let panel = NSOpenPanel()
        panel.canChooseFiles = true
        panel.canChooseDirectories = false
        panel.allowsMultipleSelection = false
        if panel.runModal() == .OK {
            self.selectedFile = panel.url
            if let book = BookUtil.readFromURL(panel.url!){
                BookManager.saveBook(book: book)
            }
        }
    }
}

#Preview {
    LocalPostingView()
}
