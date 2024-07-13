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
    var timeConsumedInSec: Double
    
    // the article that was typed
    @Relationship() var article: Article
    
    // the input code from user in raw, _ for space, ⌫ for backspace
    var inputCode: String
    
    var realInput: String
    
    var wordCount: Int = 0
    
    // AKA 回改
    var revision: Int = 0
    

    
    // AKA 速度
    var characterPerMin: Double {
        guard timeConsumedInSec > 0 else { return 0 }
        return Double(realInput.count) / Double(timeConsumedInSec) * 60
    }
    
    // AKA 码长
    var averageCodeLength: Double {
        guard timeConsumedInSec > 0 else { return 0 }
        return Double(keystrokeTotal) / Double(realInput.count)
    }
    
    // AKA 击键
    var keystrokePerSec: Double {
        guard timeConsumedInSec > 0 else { return 0 }
        return Double(keystrokeTotal) / Double(timeConsumedInSec)
    }
    
    // AKA 打词率
    var wordRate: Double {
        return Double(wordCount) / Double(inputCode.count) * 100
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
    
  
    
    
    init(
        timestamp: Date = Date(),
        timeConsumedInSec: Double = 0.0,
        article: Article,
        inputCode: String = "",
        realInput: String = ""
    ) {
        self.article = article
        self.timeConsumedInSec = timeConsumedInSec
        self.timestamp = timestamp
        self.inputCode = inputCode
        self.realInput = realInput
    }
    
    public func addKeystroke(key: String) {
        inputCode.append(key)
    }
    
    
    public func stringify() -> String {
        // (mm:ss)
        let timeFormatted = String(format: "%02d:%02d", Int(timeConsumedInSec) / 60, Int(timeConsumedInSec) % 60)
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
