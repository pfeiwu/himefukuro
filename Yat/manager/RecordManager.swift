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
        shared.modelContext?.insert(shared.currentRecord)
    }
    
    static func inject(modelContext: ModelContext) {
        shared.modelContext = modelContext
    }
    
    public var currentRecord: Record
    
    public func reset() {
        currentRecord.reset()
    }
    
}
