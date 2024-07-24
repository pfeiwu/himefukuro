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
    
    @State  private var stateManager: StateManager = StateManager.shared
    
    @State private var articleManager: ArticleManager = ArticleManager.shared
    
    @State private var recordManager: RecordManager = RecordManager.shared
    
    private var currentArticle: Article {
        articleManager.article
    }
    
    private var currentRecord: Record {
        recordManager.currentRecord
    }
    
    private var lastArticleHash: Int = 0
    
    public var nsView = YatNSTextView(frame: .zero)
    
    
    @Environment(\.modelContext) private var modelContext
    
    func makeNSView(context: Context) -> NSScrollView {
        let scrollView = NSScrollView()
        
        // 配置 NSTextView
        nsView.delegate = context.coordinator
        nsView.font = NSFont(name: "LXGW Wenkai", size: 30)
        nsView.isEditable = true
        nsView.isRichText = false
        nsView.importsGraphics = false
        nsView.isVerticallyResizable = true
        nsView.isHorizontallyResizable = false  // 设置为 false，以便视图不会水平扩展
        nsView.autoresizingMask = [.width]  // 自动调整宽度
        
        // 设置 NSTextView 的容器视图 NSScrollView
        scrollView.documentView = nsView
        scrollView.hasVerticalScroller = true
        scrollView.autohidesScrollers = true
        
        nsView.becomeFirstResponder()
        
        // 设置 NSTextView 的文本容器以支持换行
        nsView.textContainer?.containerSize = NSMakeSize(scrollView.bounds.width, CGFloat.infinity)
        nsView.textContainer?.widthTracksTextView = true  // 宽度跟踪文本视图的宽度
        nsView.textContainer?.heightTracksTextView = false  // 高度不跟踪文本视图的高度
        
        // 当文章变化时，重置输入
        ArticleManager.registerCallback{
            reset()
        }
        return scrollView
    }
    func updateNSView(_ nsView: NSScrollView, context: Context) {
        
    }
    
    @State public var lastConfirmedText:String = ""
    
    func textDidChange(){
        if stateManager.typingState == .finished {
            nsView.string = String(currentRecord.realInput.prefix(currentArticle.content.count))
            print("已经结束辣！")
            RecordManager.save()
            return
        }
        // update the input content with the new textview string
        let currentConfirmedText = getConfirmedText(from: nsView)
        let countDiff = currentConfirmedText.count - lastConfirmedText.count
        if countDiff < 0 {
            currentRecord.revision -= countDiff
        }else {
            let newInput = currentConfirmedText.suffix(countDiff)
            let trimmedString = newInput.trimmingCharacters(in: .punctuationCharacters)
            if trimmedString.count > 1 {
                currentRecord.wordCount += trimmedString.count
            }
        }
        
        currentRecord.realInput = currentConfirmedText
        lastConfirmedText = currentConfirmedText
        
        // 当用户输入长度和文章长度相同且最后一个字符相同时，判断输入结束
        if currentRecord.realInput.count == currentArticle.content.count {
            if currentRecord.realInput.last == currentArticle.content.last {
                
                var typo = 0
                for (inputChar, contentChar) in zip(currentRecord.realInput, currentArticle.content) {
                    if inputChar != contentChar {
                        typo += 1
                    }
                }
                stateManager.typingState = .finished
                currentRecord.typo = typo
                // 将成绩放到剪贴板
                let recordStr = RecordUtil.genRecordStr(record: currentRecord, article: currentArticle)
                NSPasteboard.general.clearContents()
                NSPasteboard.general.setString(recordStr, forType: .string)
            }
        }
    }
    
    
    func getConfirmedText(from textView: NSTextView) -> String {
        let imeMarkedRange = textView.markedRange()
        let string = textView.string
        
        if imeMarkedRange.length > 0 {
            // 存在输入法未确定的编码部分
            let confirmedRange = NSRange(location: 0, length: imeMarkedRange.location)
            return string.substring(with: Range(confirmedRange, in: string)!)
        } else {
            // 没有输入法未确定的编码部分，返回完整的文本内容
            return string
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    public func keyDown(with event: NSEvent){
        switch stateManager.typingState {
        case .finished:
            return
        case .pause, .ready:
            stateManager.typingState = .typing
            break
        case .typing:
            break
        }
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
        }
    }
    public func reset(){
        nsView.string=""
        lastConfirmedText = ""
        stateManager.typingState = .ready
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
            ArticleManager.loadArticle(article: newArticle)
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
        
        func containsNonASCIICharacters(_ string: String) -> Bool {
            return string.unicodeScalars.contains { $0.value > 127 }
        }
    }
}




