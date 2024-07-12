//
//  UserInput.swift
//  Yat
//
//  Created by Pengfei Wu on 2024/7/12.
//

import Foundation
import SwiftData
@Model
class UserInput {
    var timestamp: Date
    var code: String
    var text: String
    
    init(timestamp: Date=Date(),code:String="",text:String="") {
        self.timestamp = timestamp
        self.code = code
        self.text = text
    }
}
