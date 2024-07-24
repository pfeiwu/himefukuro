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
    
    
    @State  private var stateManager: StateManager = StateManager.shared
    
    @State  private var articleManager: ArticleManager = ArticleManager.shared
    
    @State  private var recordManager: RecordManager = RecordManager.shared
    
    
    private var currentArticle: Article {
        articleManager.article
    }
    
    private var currentRecord: Record {
        recordManager.currentRecord
    }
    
    var body: some View {
        VStack(spacing: 0) {
            ArticleView()
                .frame(maxHeight: .infinity)
                .padding()
            Spacer()
            SpeedometerView()
                .frame(minHeight: 10, maxHeight: 10)
            TypingView()
                .frame(minHeight: 50, maxHeight: 50)
                .padding()
        }.onAppear(){
            ArticleManager.inject(modelContext: modelContext)
            ArticleManager.loadArticleFromHistory()
            
            RecordManager.inject(modelContext: modelContext)
        }
    }
}





