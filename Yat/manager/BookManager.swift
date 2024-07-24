//
//  BookManager.swift
//  Yat
//
//  Created by Pengfei Wu on 2024/7/24.
//

import Foundation
import SwiftUI
import SwiftData


@Observable
class BookManager {
    
     public static let shared = BookManager()
    
    public var allBooks: [Book] = []
    
    static func inject(modelContext: ModelContext) {
        shared.modelContext = modelContext
    }
    
    public var currentBook: Book?
    
    private var modelContext: ModelContext?
    
    
    static func loadAllBooks() {
        let books = try! shared.modelContext?.fetch(FetchDescriptor<Book>())
        shared.allBooks = books ?? []
    }
    
    static func saveBook(book: Book) {
        shared.modelContext?.insert(book)
        shared.allBooks.append(book)
        loadBookFromHistory()
    }
    
    static func loadBookFromHistory() {
        var historyArticlesDescr = FetchDescriptor<Book>(
            sortBy: [
                .init(\Book.lastAccess, order: .reverse)
            ]
        )
        historyArticlesDescr.fetchLimit = 1
        shared.currentBook = try! shared.modelContext?.fetch(historyArticlesDescr).first
    }
    
    static func getArticleFromCurrentBook()->Article{
        if let book = shared.currentBook{
            return BookUtil.getNextArticle(book: book) ?? Article()
        }
        return Article()
    }
    
    

}

