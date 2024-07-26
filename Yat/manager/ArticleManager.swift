//
//  ArticleContainer.swift
//  Yat
//
//  Created by Pengfei Wu on 2024/7/14.
//

import Foundation
import SwiftUI
import SwiftData

@Observable
class ArticleManager {
    
    public static let shared = ArticleManager(article: Article())
    
    
    private var modelContext: ModelContext?
    
    
    static func inject(modelContext: ModelContext) {
        shared.modelContext = modelContext
    }
    
    static func loadArticle(article: Article) {
        shared.article = article
//        shared.reset()
        shared.modelContext?.insert(article)
    }
    
    static func loadArticleFromHistory() {
        var historyArticlesDescr = FetchDescriptor<Article>(
            sortBy: [
                .init(\Article.timestamp, order: .reverse)
            ]
        )
        historyArticlesDescr.fetchLimit = 1
        shared.article = try! shared.modelContext?.fetch(historyArticlesDescr).first ?? Article()
        shared.reset()
    }
    
    static func welcomeArticle() {
        shared.article = Article(content:"⌘+v从剪切板载文，⌘+4从QQ载文，⌘+3重打；文本区域右键打开上下文菜单",title: "鸺鹠跟打器使用说明")
        shared.reset()
    }
    
    public typealias Callback = () -> Void
    
    private var callbacks: [Callback] = []
    
    private var currentContainerWidth:CGFloat = 0.0
     
    public static func registerCallback(_ callback: @escaping Callback) {
        shared.callbacks.append(callback)
    }
    
    
    public func reset() {
           lastInput = ""
           typingLine = 0
           callbacks.forEach { $0() }
       }
    
    public func retype() {
        article.retype += 1
        render(containerWidth:currentContainerWidth)
    }
    
    public var article:Article
    
    public var rendered:[NSMutableAttributedString]=[]
    
    public func renderWithInput(userInput:String)->[(text: NSMutableAttributedString, isTypingLine: Bool)]{
        
        updateInput(userInput: userInput)
        
        return rendered.enumerated().map { (index, element) in
            return (element, index == typingLine)
        }
    }
    
    private var ruler = TextWidthRuler()
    
    public var fontSize: CGFloat = 30
    
    public var fontName: String = "LXGW Wenkai"
    
    private var lastInput:String = ""
    
    private var typingLine: Int = 0
    
  
    
    
    // update the style of rendered article in response to user input
    public func updateInput(userInput:String){
        if userInput == lastInput || userInput.count > article.content.count{
            return
        }
        
        var len = 0
        var loc = 0
        if userInput.starts(with: lastInput) || lastInput.isEmpty {
            // if chars add to the last input, just paint the new portion
            len = userInput.count-lastInput.count
            loc = lastInput.count
        }else if lastInput.starts(with: userInput){
            //revision occured, paint the revision part to clear
            len = lastInput.count - userInput.count
            loc = lastInput.count - len
        }
        else{
            // re-paint the whole text
            len = userInput.count
            loc = 0
        }
        lastInput = userInput
        paint(range: NSRange(location: loc, length: len))
        
    }
    
    private static let typoAttributes: [NSAttributedString.Key: Any] = [.backgroundColor: NSColor.red]
    private static let typedAttributes: [NSAttributedString.Key: Any] = [.backgroundColor: NSColor.lightGray]
    private static let untypedAttributes: [NSAttributedString.Key: Any] = [.backgroundColor: NSColor.clear]
    
    
    // paint the text with diff color according to user input
    private func paint(range: NSRange) {
        
        let startIndex = range.location
        let endIndex = range.location + range.length
        
        var currentLineIndex = 0
        var currentLineOffset = 0
        
        for i in startIndex..<endIndex {
            // locate the current line and char index
            while i >= currentLineOffset + rendered[currentLineIndex].length  {
                currentLineOffset += rendered[currentLineIndex].length
                currentLineIndex += 1
                if currentLineIndex >= rendered.count - 1 {
//                    currentLineOffset += rendered[currentLineIndex - 1].length - 1
                    break
                }
            }
            
            
            
            let lineCharIndex = i - currentLineOffset
            
            // paint the char
            if i < lastInput.count {
                
                if lastInput[lastInput.index(lastInput.startIndex, offsetBy: i)] == article.content[article.content.index(article.content.startIndex, offsetBy: i)] {
                    // typed
                    rendered[currentLineIndex].addAttributes(ArticleManager.typedAttributes, range: NSRange(location: lineCharIndex, length: 1))
                } else {
                    // typo
                    rendered[currentLineIndex].addAttributes(ArticleManager.typoAttributes, range: NSRange(location: lineCharIndex, length: 1))
                }
                typingLine = currentLineIndex
            } else {
                // untyped
                rendered[currentLineIndex].addAttributes(ArticleManager.untypedAttributes, range: NSRange(location: lineCharIndex, length: 1))
            }
        }
        // update typingLine mark
        
    }
    
   
    
    public func render(containerWidth: CGFloat) {
        reset()
        currentContainerWidth = containerWidth
        let articleText = article.content
        var result: [NSMutableAttributedString] = []
        var currentLineStr = ""
        var approximateSize = 0
        let clearAttributes: [NSAttributedString.Key: Any] = [.backgroundColor: NSColor.clear, .font: NSFont(name: fontName, size: fontSize)!]
        let font = NSFont(name: fontName, size: fontSize)!
        
        func addCurrentLineToResult() {
            let currentLine = NSMutableAttributedString(string: currentLineStr, attributes: clearAttributes)
            result.append(currentLine)
        }
        
        for articleChar in articleText {
            if currentLineStr.count >= approximateSize {
                let currentLineWidth = ruler.measureTextWidth(text: currentLineStr, font: font)
                if currentLineWidth >= containerWidth * 0.97 {
                    addCurrentLineToResult()
                    // update approximateSize
                    approximateSize = currentLineStr.count - 5
                    // reset currentLine
                    currentLineStr.removeAll()
                }
            }
            currentLineStr.append(articleChar)
        }
        
        if !currentLineStr.isEmpty {
            addCurrentLineToResult()
        }
        rendered = result
    }
    
    init(article:Article) {
        self.article = article
    }
}
