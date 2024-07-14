//
//  TypingGroupView.swift
//  Yat
//
//  Created by Pengfei Wu on 2024/7/12.
//

import Foundation

import SwiftUI
import SwiftData

struct TypingGroupView: View {
    
    @Environment(\.modelContext) private var modelContext
    
    @Query(
        filter: #Predicate<Article> { $0.isActive == true },
        sort: \Article.timestamp,
        order: .reverse
    ) private var activeArticles: [Article]
    
    private var currentArticle: Article {
        activeArticles.last ?? Article()
    }
    
    @State private var currentRecord: Record = Record(article : Article())
    
    @State private var typingState: TypingState = .ready
    
    var body: some View {
        VStack(spacing: 0) {
            ArticleView(currentArticle: currentArticle, currentRecord: currentRecord)
                .padding()
                          SpeedometerleView(currentRecord: currentRecord)
            TypingView(currentArticle: currentArticle)
                .environment(currentRecord)
                .padding()
        }
        .onChange(of: activeArticles){
            currentRecord.articleId = currentArticle.id
        }.onAppear(){
            currentRecord.articleId = currentArticle.id
        }
    }
}



enum TypingState {
    case ready
    case typing
    case finished
    case dropped
}

