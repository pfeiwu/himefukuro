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
    
    @Environment(AttributeContainer.self) private var attributeCon
    
    @State private var currentRecord: Record = Record(article : Article())
    
    @State private var currentArticleCon: ArticleContainer = ArticleContainer.shared
    
    @State private var typingState: TypingState = .ready
    
    
    var body: some View {
        VStack(spacing: 0) {
            ArticleView()
                .environment(currentRecord)
                .environment(currentArticleCon)
                .environment(attributeCon)
                .frame(maxHeight: .infinity)
                .padding()
            Spacer()
            SpeedometerView()
                .environment(currentRecord)
                .environment(currentArticleCon)
                .environment(attributeCon)
                .frame(minHeight: 10, maxHeight: 10)
            TypingView()
                .environment(currentRecord)
                .environment(currentArticleCon)
                .environment(attributeCon)
                .frame(minHeight: 50, maxHeight: 50)
                .padding()
        }.onAppear(){
            ArticleContainer.inject(modelContext: modelContext)
            ArticleContainer.loadArticleFromHistory()
        }
        .onChange(of:typingState){
            print("typingState变为\(typingState)")
        }
    }
}





