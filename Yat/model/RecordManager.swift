//
//  RecordManager.swift
//  Yat
//
//  Created by Pengfei Wu on 2024/7/24.
//

import Foundation
import SwiftUI
import SwiftData

@Observable
class RecordManager{
    public static let shared = RecordManager()
    
    private var modelContext: ModelContext?
    
    init() {
    }
    
    static func inject(modelContext: ModelContext) {
        shared.modelContext = modelContext
    }
}
