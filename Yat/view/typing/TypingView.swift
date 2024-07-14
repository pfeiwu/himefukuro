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
    
    @Environment(Record.self) private var currentRecord: Record
    
    public var nsView = YatNSTextView()
    
    
    @Environment(\.modelContext) private var modelContext
    
    func makeNSView(context: Context) -> NSTextView {
        nsView.delegate = context.coordinator
        nsView.font = NSFont(name: "LXGW Wenkai", size: 30)
        return nsView
    }
    func updateNSView(_ nsView: NSTextView, context: Context) {
        
    }
    
    func textDidChange(){
        print("typing正在使用的文章是\(currentArticle.id), 记录是\(currentRecord.id)")
        // update the input content with the new textview string
        currentRecord.realInput = getConfirmedText(from: nsView)
        print("realInput: \(currentRecord.realInput)")
        print(RecordUtil.genRecordStr(record: currentRecord, article: currentArticle))
    }
    
    
    func getConfirmedText(from textView: NSTextView) -> String {
        let imeMarkedRange = textView.markedRange()
        let string = textView.string
        print("imeMarkedRange: \(imeMarkedRange), string: \(string)")
        
        if imeMarkedRange.length > 0 {
            // 存在输入法未确定的编码部分
            let confirmedRange = NSRange(location: 0, length: imeMarkedRange.location)
            let confirmedText = string.substring(with: Range(confirmedRange, in: string)!)
            return confirmedText
        } else {
            // 没有输入法未确定的编码部分，返回完整的文本内容
            return string
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    public func keyDown(with event: NSEvent){
        print("keyDown: \(event.keyCode)")
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
            //            let newRecord = Record(article: newArticle)
            // crashed because of relationship, need to delve deeper
            //  newArticle.records.append(newRecord)
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
        
        func textDidChange(_ notification: Notification) {
            parent.textDidChange()
        }
        
        func textView(_ textView: NSTextView, shouldChangeTextIn affectedCharRange: NSRange, replacementString: String?) -> Bool {
            print("affectedCharRange.locatiom: \(affectedCharRange.location), affectedCharRange.length: \(affectedCharRange.length), replacementString: \(replacementString ?? "nil")")
            let currentRecord = parent.currentRecord
            if let replacementString = replacementString {
                if replacementString.isEmpty {
                    if affectedCharRange.length == 1 {
                        //if the last char replaced by empty string, then it is a revision, notice that ime conversion acts like the last one or several chars are replaced by the new char(s)
                        currentRecord.revision += 1
                    }
                }else if replacementString.count > 1 && containsNonASCIICharacters(replacementString){
                    // if replacementString is not empty and has more than one char, then it is a word input
                    print("word input: \(replacementString)")
                    currentRecord.wordCount += replacementString.count
                }
            }
            
            return true
        }
        
        
        
        func containsNonASCIICharacters(_ string: String) -> Bool {
            return string.unicodeScalars.contains { $0.value > 127 }
        }
    }
}




