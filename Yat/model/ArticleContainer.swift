//
//  ArticleContainer.swift
//  Yat
//
//  Created by Pengfei Wu on 2024/7/14.
//

import Foundation
import SwiftUI

@Observable
class ArticleContainer {
    public var article:Article
    
    init(article:Article) {
        self.article = article
    }
}
