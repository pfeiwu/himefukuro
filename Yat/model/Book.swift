//
//  Book.swift
//  Yat
//
//  Created by Pengfei Wu on 2024/7/24.
//

import Foundation
import SwiftUI
import SwiftData

@Model
class Book {
    
    var id:UUID = UUID()
    
    var bookmark: Int
    
    var content: String
    
    var title: String
    
    var paramLength: Int
    
    var lastAccess: Date = Date()
    
    var paramNum:Int {
        get {
            return bookmark / paramLength + 1
        }
    }
    
    var maxParamNum:Int {
        get {
            return content.count / paramLength + 1
        }
    }
    
    func maxParamNumByParamLength(paramLength:Int) -> Int {
        return content.count / paramLength + 1
    }
    
    
    init(bookmark: Int=0, content: String="", title: String="",paramLength:Int=500) {
        self.bookmark = bookmark
        self.content = content
        self.title = title
        self.paramLength = paramLength
    }
    
    func access() {
        lastAccess = Date()
    }
}
