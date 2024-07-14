//
//  SpeedometerView.swift
//  Yat
//
//  Created by Pengfei Wu on 2024/7/12.
//

import Foundation
import SwiftUI

struct SpeedometerleView: View {
    @Environment(ArticleContainer.self) private var currentArticleCon: ArticleContainer
    
    @Environment(Record.self) private var currentRecord: Record
    
    private var currentArticle: Article {
        currentArticleCon.article
    }
    
    // timer by 100ms
    @State private var timer: Timer?
    var body: some View {
        VStack {
            Text("速度：\(currentRecord.characterPerMin)")
        }
        .onAppear(perform: {
            print("speedometer正在使用的record是\(currentRecord.id)")
            self.timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true, block: { _ in
                currentRecord.timeConsumedInSec += 0.1
            })
        })
    }
}
