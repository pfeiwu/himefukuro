//
//  RecordUtil.swift
//  Yat
//
//  Created by Pengfei Wu on 2024/7/14.
//

import Foundation


class RecordUtil {
    
    
    static public func genRecordStr(record: Record, article: Article) ->String{
//        print("我是\(record.id)")
//        print("我正在使用的文章是\(article.title)")
        let timeFormatted = String(format: "%02d:%02d", Int(record.timeConsumedInSec) / 60, Int(record.timeConsumedInSec) % 60)
        return "第\(article.paraNum)段 速度\(String(format: "%.2f", record.characterPerMin)) 击键\(String(format: "%.2f", record.keystrokePerSec)) 码长\(String(format: "%.2f", record.averageCodeLength)) 字数\(article.content.count) 时间\(timeFormatted) 回改\(record.revision) 退格\(record.backspace) 打词\(String(format: "%.2f", record.wordRate))% 鸺鹠 dev"
    }
    
}

