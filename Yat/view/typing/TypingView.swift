//
//  TypingView.swift
//  Yat
//
//  Created by Pengfei Wu on 2024/7/12.
//

import Foundation
import SwiftUI
import UniformTypeIdentifiers
import AppKit
struct TypingView: NSViewRepresentable {
    
    public var currentArticle: Article
    
    public var currentRecord: Record
    
   
    
    @Environment(\.modelContext) private var modelContext
    
    func makeNSView(context: Context) -> NSTextView {
        let textView = YatNSTextView()
        textView.delegate = context.coordinator
        return textView
    }
    func updateNSView(_ nsView: NSTextView, context: Context) {
        
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    public func keyDown(with event: NSEvent){
        if let characters = event.characters {
            var convertedCode = "☒"
            if characters == " " {
                convertedCode = "_"
            } else if event.keyCode == 51 { // 51 是退格键的键码
                convertedCode = "⌫"
            } else {
                convertedCode = characters
            }
            currentRecord.addKeystroke(key: convertedCode)
            print("keystrokes: \(currentRecord.inputCode)")
        }
    }
    public func paste(_ sender: Any?){
        if let pasteboard = NSPasteboard.general.string(forType: .string) {
            let pasteboardText = pasteboard
            if let utf8Data = pasteboard.data(using: .utf8) {
                if let textFromUTF8 = String(data: utf8Data, encoding: .utf8) {
                    print("Text from UTF-8 data: \(textFromUTF8)")
                }
            }
            let newArticle = ArticleUtil.articleFromRaw(raw: pasteboardText)
            newArticle.activate()
            currentArticle.deactivate()
            modelContext.insert(newArticle)
        }
    }
    
    class Coordinator: NSObject, NSTextViewDelegate {
        var parent: TypingView
        
        init(_ parent: TypingView) {
            self.parent = parent
        }
        
        public func keyDown(with event: NSEvent){
            parent.keyDown(with: event)
        }
        
        public func paste(_ sender: Any?){
            parent.paste(sender)
        }
        
    }
}




