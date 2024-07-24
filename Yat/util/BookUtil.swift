//
//  BookUtil.swift
//  Yat
//
//  Created by Pengfei Wu on 2024/7/24.
//

import Foundation


class BookUtil{
    
    static func readFromURL(_ url: URL) -> Book? {
        do {
            // open url to read
            let content = try String(contentsOf: url, encoding: .utf8)
            
            // 获取文件名作为书名
            let fileName = url.lastPathComponent
            
            
            // 去掉所有的换行符
            let filteredContent = filterAndConvertString(content)
            
            return Book( content: filteredContent,title: fileName)
        } catch {
            print("Error: \(error)")
        }
        return nil
    }
    
    static func getNextArticle(book:Book) -> Article?{
        let bookmark = book.bookmark
        let paramLength = book.paramLength
        let content = book.content
        let contentLength = content.count
        
        if(bookmark >= contentLength){
            return nil
        }
        
        // 从content的第bookmark个字符截取paramLength个字符,如果不满paramLength个字符,取完即可
        let start = content.index(content.startIndex, offsetBy: bookmark)
        var end = content.index(start, offsetBy: paramLength)
        if end > content.endIndex {
            end = content.endIndex
        }
        
        let range = start..<end
        let articleContent = String(content[range])
        
        // 计算当前文章在按paramLength切割的文章列表中的位置
        let paramNum = bookmark / paramLength
        
        
        book.bookmark = bookmark + articleContent.count
        
        return Article(content: articleContent,title:book.title, paraNum: paramNum + 1)
    }
    
    static func getArticle(book:Book,paramNum:Int,paramLength:Int) -> Article?{
        let bookmark = (paramNum-1) * paramLength
        let content = book.content
        let contentLength = content.count
        
        if(bookmark >= contentLength){
            return nil
        }
        
        // 从content的第bookmark个字符截取paramLength个字符,如果不满paramLength个字符,取完即可
        let start = content.index(content.startIndex, offsetBy: bookmark)
        var end = content.index(start, offsetBy: paramLength)
        if end > content.endIndex {
            end = content.endIndex
        }
        
        let range = start..<end
        let articleContent = String(content[range])
        
        // 计算当前文章在按paramLength切割的文章列表中的位置
        let paramNum = bookmark / paramLength + 1
        
        return Article(content: articleContent,title:book.title, paraNum: paramNum)
    }
    
    
    static func genPost(book:Book, article:Article,paramLength:Int) -> String{
        let titleLine = "《\(book.title)》"
        let contentLine = article.content
        let paraNumLine = "-----第\(article.paraNum)段-- 共\(book.maxParamNumByParamLength(paramLength: paramLength))段----- 本段字数:\(contentLine.count) post with 🦉"
        return "\(titleLine)\n\(contentLine)\n\(paraNumLine)"
    }
    
    static func filterAndConvertString(_ input: String) -> String {
        // 定义需要保留的字符集
        let allowedCharacterSet = CharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789")
            .union(CharacterSet(charactersIn: "ａｂｃｄｅｆｇｈｉｊｋｌｍｎｏｐｑｒｓｔｕｖｗｘｙｚＡＢＣＤＥＦＧＨＩＪＫＬＭＮＯＰＱＲＳＴＵＶＷＸＹＺ１２３４５６７８９０"))
            .union(CharacterSet(charactersIn: "，。、！？：；（）【】《》“”‘’"))
            .union(CharacterSet(charactersIn: "\u{4E00}"..."\u{9FA5}")) // 汉字范围
        
        // 定义半角标点符号及其全角对应关系
        let punctuationMap: [Character: Character] = [
            ",": "，",
            ".": "。",
            "!": "！",
            "?": "？",
            ":": "：",
            ";": "；",
            "(": "（",
            ")": "）",
            "[": "【",
            "]": "】",
            "<": "《",
            ">": "》",
            "\"": "“",
            "'": "‘",
            "\\": "＼",
            "/": "／"
        ]
        
        var result = ""
        
        for char in input {
            if let uniscalar = Unicode.Scalar(String(char)){
                if allowedCharacterSet.contains(uniscalar){
                    result.append(char)
                }else if let fullWidthChar = punctuationMap[char] {
                    result.append(fullWidthChar)
                }
            }
        }
        
        return result
    }
    
}

extension Character {
    var isNumber: Bool {
        return "0"..."9" ~= self
    }
    
    var isLetter: Bool {
        return "a"..."z" ~= self || "A"..."Z" ~= self
    }
    
    var isWhitespace: Bool {
        return self == " " || self == "\n" || self == "\r" || self == "\t"
    }
    
    var isChineseCharacter: Bool {
        let scalars = self.unicodeScalars
        return scalars.count == 1 && scalars.first!.properties.isIDSBinaryOperator
    }
    
    var isFullwidthPunctuation: Bool {
        let scalars = self.unicodeScalars
        guard let scalar = scalars.first else { return false }
        return (0x3000...0x303F).contains(scalar.value)
    }
    
    var isHalfwidthPunctuation: Bool {
        let characterSet = CharacterSet.punctuationCharacters
        return characterSet.contains(self.unicodeScalars.first!)
    }
    
    var fullwidthEquivalent: Character? {
        guard self.isHalfwidthPunctuation else { return nil }
        let offset = 65248
        let unicodeScalar = self.unicodeScalars.first!
        let fullwidthScalar = Unicode.Scalar(unicodeScalar.value + UInt32(offset))
        return fullwidthScalar.map(Character.init)
    }
}
