//
//  RecordManager.swift
//  Yat
//
//  Created by Pengfei Wu on 2024/7/24.
//

import Foundation
import SwiftUI
import SwiftData

@Observable
class RecordManager{
    public static let shared = RecordManager()
    
    private var modelContext: ModelContext?
    
    init() {
        // 当文章改变时，重置当前记录
        ArticleManager.registerCallback {
            RecordManager.shared.currentRecord = Record()
            RecordManager.shared.currentRecord.articleId = ArticleManager.shared.article.id
        }
        currentRecord = Record()
    }
    
    static func save(){
        // 将成绩放到剪贴板
        let recordStr = RecordUtil.genRecordStr(record: shared.currentRecord, article: ArticleManager.shared.article)
        NSPasteboard.general.clearContents()
        NSPasteboard.general.setString(recordStr, forType: .string)
        // 保存
        shared.modelContext?.insert(shared.currentRecord)
        // 非潜水模式下，发送到QQ窗口
        if !StateManager.shared.silent{
            let recordStr = RecordUtil.genRecordStr(record: shared.currentRecord, article: ArticleManager.shared.article)
            QQAuxiliaryTool.shared.sendMsgToActiveWindow(message:recordStr)
        }
    }
    
    static func inject(modelContext: ModelContext) {
        shared.modelContext = modelContext
    }
    
    public var currentRecord: Record
    
    public func reset() {
        currentRecord.reset()
    }
    
}
