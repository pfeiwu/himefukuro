//
//  ArticleView.swift
//  Yat
//
//  Created by Pengfei Wu on 2024/7/12.
//

import Foundation
import SwiftUI
import SwiftData

struct ArticleView: View {
    
    public var currentArticle: Article
    
    public var currentRecord: Record
    
    var formattedText: Text{
        let articleText = currentArticle.content
        let userInputText = currentRecord.realInput
        var result = Text("")  // 空的Text对象作为起始
        for index in articleText.indices {
            let articleChar = articleText[index]
            let userInputExists = index < userInputText.endIndex
            let userInputChar = userInputExists ? userInputText[index] : nil
            
            if let userInputChar = userInputChar {
                if articleChar == userInputChar {
                    // 正确的输入
                    result = result + Text(String(userInputChar)).foregroundColor(.green)
                } else {
                    // 错误的输入
                    result = result + Text(String(userInputChar)).foregroundColor(.red)
                }
            } else {
                // 用户还没有输入这个字符
                result = result + Text(String(articleChar)).foregroundColor(.gray)
            }
        }
        
        return result
    }
    
    var body: some View{
        VStack(spacing: 0){
            formattedText
        }
    }
    
}
