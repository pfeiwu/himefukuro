//
//  TypingSharedData.swift
//  Yat
//
//  Created by Pengfei Wu on 2024/7/12.
//

import Foundation

class TypingSharedData : ObservableObject{
    @Published var currentArticle: Article = Article()
    @Published var currentUserInput: UserInput = UserInput()
    
    public func updateArticle(article: Article){
        self.currentArticle = article
    }
    
    public func updateUserInput(userInput: UserInput){
        self.currentUserInput = userInput
    }
}
