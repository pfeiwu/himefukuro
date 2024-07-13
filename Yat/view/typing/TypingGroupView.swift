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
        sort: \Article.timestamp
    ) private var activeArticles: [Article]
    
    @Query(
        filter: #Predicate<Record> { $0.isActive == true },
        sort: \Record.timestamp
    ) private var activeRecords: [Record]
    
    private var currentArticle: Article {
        activeArticles.last ?? Article()
    }
    
    private var currentRecord: Record {
        if let record = activeRecords.last {
            return record
        }
        let newRecord = Record(article: currentArticle)
        newRecord.activate()
//        currentArticle.records.append(newRecord)
        modelContext.insert(newRecord)
        return newRecord
    }
    
    
    @State private var typingState: TypingState = .ready
    
    var body: some View{
        VStack(spacing: 0){
            ArticleView(currentArticle: currentArticle, currentRecord: currentRecord)
                .padding()
            SpeedometerleView(currentRecord: currentRecord)
            TypingView(currentArticle: currentArticle, currentRecord: currentRecord)
                .padding()
            
            
        }
    }
}



enum TypingState {
    case ready
    case typing
    case finished
    case dropped
}

