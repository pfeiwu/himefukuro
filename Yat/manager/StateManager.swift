//
//  AttributeManager.swift
//  Yat
//
//  Created by Pengfei Wu on 2024/7/24.
//

import Foundation


import Foundation
import SwiftUI

@Observable
class StateManager {
    public static let shared = StateManager()
    
    public var typingState:TypingState = .ready
    
    public var silent: Bool  = true
    
    
    public var titleString:String {
        let artTitle = ArticleManager.shared.article.title
        let ifSilent = silent ? "[潜水中]" : ""
        return "当前文章: \(artTitle) \(ifSilent)"
    }
    
}

enum TypingState {
    case ready
    case typing
    case pause
    case finished
}
