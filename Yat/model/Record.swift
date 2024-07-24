//
//  Record.swift
//  Yat
//
//  Created by Pengfei Wu on 2024/7/12.
//

import Foundation
import SwiftData
import SwiftUI

@Model
class Record {
    
    // the unique identifier
    var id: UUID
    
    // whether record the entire typing process
    var finished: Bool
    
    // when the record was created
    var timestamp: Date
    
    // time consumed in seconds
    var timeConsumedInSec: Double
    
    // the article that was typed
    var articleId: UUID
    
    // the input code from user in raw, _ for space, ⌫ for backspace
    var inputCode: String
    
    // the actual content that user input
    var realInput: String
    
    // AKA 打词
    var wordCount: Int = 0
    
    // AKA 回改
    var revision: Int = 0
    
    // AKA 错字
    var typo: Int = 0
    
    var maxSpeed : Double = 0
    
    var maxKeystroke : Double = 0   
    
    var minaverageCodeLength: Double = 100
    
    
    // AKA 速度
    var characterPerMin: Double {
        guard timeConsumedInSec > 0 else { return 0 }
        return Double(realInput.count) / Double(timeConsumedInSec) * 60
    }
    
    // AKA 错一罚五
    var characterPerMinWithTypoTimes5 :Double {
        guard typo > 0 && timeConsumedInSec > 0 else { return 0 }
        return Double(realInput.count - typo * 5) / Double(timeConsumedInSec) * 60
    }
    
    // AKA 键准
    var accuracy: Double {
        guard keystrokeTotal > 0 else { return 0 }
        return (Double(keystrokeTotal - backspace) - Double(revision + typo) * averageCodeLength)/Double(keystrokeTotal)
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
        return Double(wordCount) / Double(realInput.count) * 100
    }
    
    // AKA 字数
    var contentLength: Int{
        realInput.count
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
        let id = UUID()
        self.id = id
        self.articleId = article.id
        self.finished = false
        self.timeConsumedInSec = timeConsumedInSec
        self.timestamp = timestamp
        self.inputCode = inputCode
        self.realInput = realInput
    }
    
    
    
    public func reset(){
        timestamp = Date()
        timeConsumedInSec = 0.0
        inputCode = ""
        realInput = ""
        wordCount = 0
        revision = 0
    }
    
    public func addKeystroke(key: String) {
        inputCode.append(key)
    }
    
    
    public var isActive: Bool = false
    public var isInactive: Bool {
        return !isActive
    }
    public func activate() {
        isActive = true
    }
    public func deactivate() {
        isActive = false
    }
    public func toggle() {
        isActive.toggle()
    }
    
}
