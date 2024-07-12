//
//  Record.swift
//  Yat
//
//  Created by Pengfei Wu on 2024/7/12.
//

import Foundation
import SwiftData

@Model
class Record {
    // when the record was created
    var timestamp: Date
    
    // time consumed in seconds
    var timeConsumedInSec: Int
    
    // the article that was typed
    @Relationship(inverse: \Article.records) var article: Article
    
    // the input code from user in raw, _ for space, ⌫ for backspace
    var inputCode: String
    
    // the input char from user, but record revision as '⌫' while keeping the deleted char
    var inputChar: [String]
    
    // AKA 速度
    var characterPerMin: Double {
        guard timeConsumedInSec > 0 else { return 0 }
        return Double(contentLength) / Double(timeConsumedInSec) * 60
    }
    
    // AKA 码长
    var averageCodeLength: Double {
        guard timeConsumedInSec > 0 else { return 0 }
        return Double(keystrokeTotal) / Double(contentLength)
    }
    
    // AKA 击键
    var keystrokePerSec: Double {
        guard timeConsumedInSec > 0 else { return 0 }
        return Double(keystrokeTotal) / Double(timeConsumedInSec)
    }
    
    // AKA 打词率
    var wordRate: Double {
        return Double(inputChar.filter{$0.count > 1}.count) / Double(contentLength) * 100
    }
    
    // AKA 字数
    var contentLength: Int{
        article.content.count
    }
    
    // AKA 总键数
    var keystrokeTotal: Int{
        inputCode.count
    }
    
    // AKA 退格
    var backspace: Int {
        return inputCode.filter { $0 == "⌫" }.count
    }
    
    // AKA 回改
    var revision: Int {
        return inputChar.filter{$0.contains("⌫")}.count
    }
    
    var realInput: String
    
    
    init(
        timestamp: Date = Date(),
        timeConsumedInSec: Int = 0,
        article: Article,
        inputCode: String = "",
        inputChar: [String] = [],
        realInput: String = ""
    ) {
        self.article = article
        self.timeConsumedInSec = timeConsumedInSec
        self.timestamp = timestamp
        self.inputCode = inputCode
        self.inputChar = inputChar
        self.realInput = realInput
    }
    
    public func addKeystroke(key: String) {
        inputCode.append(key)
    }
    
    
    public func addChar(char: String) {
        inputChar.append(char)
        if(char == "⌫" && !realInput.isEmpty){
            realInput.removeLast()
        }
    }
    
    public func stringify() -> String {
        let timeFormatted = String(format: "%02d:%02d.%03d", timeConsumedInSec / 60, timeConsumedInSec % 60, (Int(Double(timeConsumedInSec) * 1000) % 1000))
        return "第\(article.paraNum)段 速度\(String(format: "%.2f", characterPerMin)) 击键\(String(format: "%.2f", keystrokePerSec)) 码长\(String(format: "%.2f", averageCodeLength)) 字数\(contentLength) 时间\(timeFormatted) 回改\(revision) 退格\(backspace) 打词\(String(format: "%.2f", wordRate))% yat v0.1a"
    }
    
    public var isActive: Bool = false
    public var isInactive: Bool {
        return !isActive
    }
    public func activate() {
        isActive = true
    }
    public func inactivate() {
        isActive = false
    }
    public func toggle() {
        isActive.toggle()
    }
    
}
