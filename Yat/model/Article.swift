//
//  Article.swift
//  Yat
//
//  Created by Pengfei Wu on 2024/7/12.
//

import Foundation
import SwiftData

@Model
class Article {
    
    // when the article was recognized
    var timestamp: Date

    // the content of the article
    @Attribute(.externalStorage) var content: String
    
    // the title of the article
    var title: String
    
    // the paragraph number of the article
    var paraNum: Int
    
    // the typing records of this article
    @Relationship(deleteRule: .cascade, inverse: \Record.article) var records: [Record] = []
    
    // hash of the content
    var contentHash: Int {
        return content.hashValue
    }
    
    // create a new article
    init(timestamp: Date=Date(),
         content:String="暂无赛文",
         title:String="暂无赛文",
         paraNum:Int=1
    ) {
        self.timestamp = timestamp
        self.content = content
        self.title=title
        self.paraNum=paraNum
    }
    
    // get label of this article for display
    func label() -> String {
        return self.title + " 第\(paraNum)段"
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

