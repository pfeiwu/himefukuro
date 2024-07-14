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
    
    @Environment(Article.self) private var currentArticle: Article
    
    @Environment(Record.self) private var currentRecord: Record
    
    var formattedText: AttributedString {
        let articleText = currentArticle.content
        var result = AttributedString(articleText)
        let userInputText = currentRecord.realInput
        for (articleIndex, articleChar) in articleText.enumerated() {
            if let range = result.range(of: String(articleChar)) {
                if articleIndex < userInputText.count {
                    let userInputChar = userInputText[userInputText.index(userInputText.startIndex, offsetBy: articleIndex)]
                    if articleChar == userInputChar {
                        // 正确的输入
                        result[range].backgroundColor = .gray
                    } else {
                        // 错误的输入
                        result[range].backgroundColor = .red
                    }
                } else {
                    // 用户输入比文章短,剩余部分显示为未输入
                    result[range].backgroundColor = .clear
                }
            }
        }
        return result
    }
    
    var body: some View{
        VStack(spacing: 0){
            Text(formattedText)
                .font(.custom("LXGW Wenkai", size: 30))
                .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
    
}
