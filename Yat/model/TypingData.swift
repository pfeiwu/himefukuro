//
//  TypingData.swift
//  Yat
//
//  Created by Pengfei Wu on 2024/7/12.
//

import Foundation
import SwiftData


@Model
final class TypingData{
    var article: Article
    var userInput: UserInput 
    init(article: Article = Article(), userInput: UserInput = UserInput()) {
        self.article = article
        self.userInput = userInput
    }
}
