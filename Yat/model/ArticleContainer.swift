//
//  ArticleContainer.swift
//  Yat
//
//  Created by Pengfei Wu on 2024/7/14.
//

import Foundation
import SwiftUI

@Observable
class ArticleContainer {
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
    
    public func reset(){
        lastInput = ""
        typingLine = 0
    }
    
    
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
            
                        print("cuurentLineIndex: \(currentLineIndex), currentLineOffset: \(currentLineOffset), lineCharIndex: \(lineCharIndex) i：\(i)")
            // paint the char
            if i < lastInput.count {
                
                if lastInput[lastInput.index(lastInput.startIndex, offsetBy: i)] == article.content[article.content.index(article.content.startIndex, offsetBy: i)] {
                    // typed
                    rendered[currentLineIndex].addAttributes(ArticleContainer.typedAttributes, range: NSRange(location: lineCharIndex, length: 1))
                } else {
                    // typo
                    rendered[currentLineIndex].addAttributes(ArticleContainer.typoAttributes, range: NSRange(location: lineCharIndex, length: 1))
                }
                typingLine = currentLineIndex
            } else {
                // untyped
                rendered[currentLineIndex].addAttributes(ArticleContainer.untypedAttributes, range: NSRange(location: lineCharIndex, length: 1))
            }
        }
        // update typingLine mark
        
    }
    
    public func render(containerWidth: CGFloat) {
        reset()
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
