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
            print("convertedCode：\(convertedCode), keystrokes: \(currentRecord.inputCode)")
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
            let newRecord = Record(article: newArticle)
            newRecord.activate()
            currentRecord.deactivate()
            // crashed because of relationship need to delve deeper
          //  newArticle.records.append(newRecord)
            modelContext.insert(newArticle)
            modelContext.insert(newRecord)
            
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
        
        func textView(_ textView: NSTextView, shouldChangeTextIn affectedCharRange: NSRange, replacementString: String?) -> Bool {
            print("affectedCharRange.locatiom: \(affectedCharRange.location), affectedCharRange.length: \(affectedCharRange.length), replacementString: \(replacementString ?? "nil")")
            if let replacementString = replacementString {
                if replacementString.isEmpty {
                    if affectedCharRange.length == 1 {
                        //if the last char replaced by empty string, then it is a revision, notice that ime conversion acts like the last one or several chars are replaced by the new char(s)
                        parent.currentRecord.revision += 1
                    }
                }else if replacementString.count > 1 && containsNonASCIICharacters(replacementString){
                    // if replacementString is not empty and has more than one char, then it is a word input
                    print("word input: \(replacementString)")
                    parent.currentRecord.wordCount += replacementString.count
                }
            }
            // update the input content with the new textview string
            parent.currentRecord.realInput = textView.string
            print(parent.currentRecord.stringify())
            return true
        }
        
        func containsNonASCIICharacters(_ string: String) -> Bool {
            return string.unicodeScalars.contains { $0.value > 127 }
        }
    }
}




