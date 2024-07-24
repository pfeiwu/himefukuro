//
//  SpeedometerView.swift
//  Yat
//
//  Created by Pengfei Wu on 2024/7/12.
//

import Foundation
import SwiftUI

struct SpeedometerView: View {
    
    @State private var articleManager: ArticleManager = ArticleManager.shared
    
    @State private var recordManager: RecordManager = RecordManager.shared
    
    @State  private var stateManager: StateManager = StateManager.shared
    
    private var currentArticle: Article {
        articleManager.article
    }
    
    private var currentRecord: Record {
        recordManager.currentRecord
    }
    
    private var progress: Double {
        Double(currentRecord.realInput.count) / Double(currentArticle.content.count)
    }
    
    private var barColor: Color {
        let maxCPM: Double = 250
        let cpmPercentage = min(currentRecord.characterPerMin / maxCPM, 1.0)
        
        // Define custom gradient colors: Yellow -> Green -> Blue -> Purple
        let gradientColors: [(red: Double, green: Double, blue: Double)] = [
            (red: 1.0, green: 1.0, blue: 0.0),   // Yellow
            (red: 0.0, green: 1.0, blue: 0.0),   // Green
            (red: 0.0, green: 0.0, blue: 1.0),   // Blue
            (red: 0.5, green: 0.0, blue: 0.5)    // Purple
        ]
        
        // Calculate interpolation factor
        let index = cpmPercentage * Double(gradientColors.count - 1)
        let startIndex = Int(index)
        let endIndex = min(startIndex + 1, gradientColors.count - 1)
        let fraction = index - Double(startIndex)
        
        // Perform linear interpolation between colors
        let startColor = gradientColors[startIndex]
        let endColor = gradientColors[endIndex]
        
        let red = startColor.red + fraction * (endColor.red - startColor.red)
        let green = startColor.green + fraction * (endColor.green - startColor.green)
        let blue = startColor.blue + fraction * (endColor.blue - startColor.blue)
        
        let interpolatedColor = Color(red: red, green: green, blue: blue)
        
        return interpolatedColor
    }


   
    
    // timer by 100ms
    @State private var timer: Timer?
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                Rectangle()
                    .fill(barColor)
                    .frame(width: geometry.size.width * CGFloat(progress), height: 6)
                    .cornerRadius(3)
                    .animation(.easeInOut(duration: 0.5), value: progress)
            }
            .frame(height: 6)
            .onAppear(perform: {
                self.timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true, block: { _ in
                    if (stateManager.typingState == .typing){
                        currentRecord.timeConsumedInSec += 0.1
                    }
                    
                })
            })
            .padding()
        }
        
    }
}
