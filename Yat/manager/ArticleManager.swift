////
////  ArticleManager.swift
////  Yat
////
////  Created by Pengfei Wu on 2024/7/12.
////
//
//import Foundation
//import SwiftUI
//import SwiftData
//
//@Observable
//class ArticleManager{
//    @Published var articles: [Article] = []
//    @Query private var query: Article
//    func fetchAll(){
//        articles = try! Query<Article>(sort:\.timestamp).fetch()
//    }
//    
//    func add(article: Article){
//        articles.append(article)
//        try! article.save()
//    }
//}
