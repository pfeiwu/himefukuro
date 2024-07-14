//
//  AttributeContainer.swift
//  Yat
//
//  Created by Pengfei Wu on 2024/7/14.
//

import Foundation
import SwiftUI

@Observable
class AttributeContainer {
    public var state:TypingState = .ready
    
}

enum TypingState {
    case ready
    case typing
    case pause
    case finished
}
