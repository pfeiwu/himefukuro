//
//  RecordUtil.swift
//  Yat
//
//  Created by Pengfei Wu on 2024/7/14.
//

import Foundation


class RecordUtil {
    
    
    static public func genRecordStr(record: Record, article: Article) ->String{
        return "第\(article.paraNum)段 \(genRecordSegStr(record: record, article: article))"
    }
    
    static public func genRecordSegStr(record: Record, article: Article) ->String {
        return "\(speedSegment(record: record)) \(keystrokePerSecSegment(record: record)) \(typoSegment(record: record)) \(averageCodeLengthSegment(record: record)) \(accuracySegment(record: record)) \(contentLengthSegment(article: article)) \(timeConsumedSegment(record: record)) \(revisionSegment(record: record)) \(backspaceSegment(record: record)) \(wordRateSegment(record: record)) \(retypeSegment(article: article)) \(verSegment())"
    }
    
    static public func speedSegment(record: Record) -> String {
        let cpm = record.characterPerMin
        let cpmm5 = record.characterPerMinWithTypoTimes5
        if(cpmm5>0){
            return "速度\(String(format: "%.2f", cpmm5))/\(String(format: "%.2f", cpm))"
        }else{
            return "速度\(String(format: "%.2f", cpm))"
        }
    }
    
    static public func keystrokePerSecSegment(record: Record) -> String {
        return "击键\(String(format: "%.2f", record.keystrokePerSec))"
    }
    
    static public func averageCodeLengthSegment(record: Record) -> String {
        return "码长\(String(format: "%.2f", record.averageCodeLength))"
    }
    
    static public func accuracySegment(record: Record) -> String {
        return "键准\(String(format: "%.2f%%", record.accuracy * 100))"
    }
    

    
    static public func contentLengthSegment(article: Article) -> String {
        return "字数\(article.content.count)"
    }
    
    static public func timeConsumedSegment(record: Record) -> String {
        let timeFormatted = String(format: "%02d:%02d", Int(record.timeConsumedInSec) / 60, Int(record.timeConsumedInSec) % 60)
        return "时间\(timeFormatted)"
    }
    
    static public func revisionSegment(record: Record) -> String {
        return "回改\(record.revision)"
    }
    
    static public func backspaceSegment(record: Record) -> String {
        return "退格\(record.backspace)"
    }
    
    static public func wordRateSegment(record: Record) -> String {
        return "打词\(String(format: "%.2f", record.wordRate))%"
    }
    
    static public func typoSegment(record: Record) -> String {
        return "错字\(record.typo)"
    }
    
    static public func retypeSegment(article: Article) -> String {
        return "重打\(article.retype)"
    }
    
    static public func verSegment() -> String {
        return "鸺鹠v"+(Bundle.main.infoDictionary?["CFBundleShortVersionString"] as! String)
    }
    
    
}

