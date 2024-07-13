//
//  SpeedometerView.swift
//  Yat
//
//  Created by Pengfei Wu on 2024/7/12.
//

import Foundation
import SwiftUI

struct SpeedometerleView: View {
    public var currentRecord: Record
    
    // timer by 100ms
    @State private var timer: Timer?
    var body: some View {
        VStack {
            Text(self.currentRecord.stringify())
        }
        .onAppear(perform: {
            self.timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true, block: { _ in
                self.currentRecord.timeConsumedInSec += 0.1
            })
        })
    }
}
