//
//  ArticleUtil.swift
//  yat
//
//  Created by Pengfei Wu on 2024/7/11.
//

import Foundation

/// A utility class for formatting articles.
class ArticleUtil {
    
    /// Formats a given date using the specified format string.
    ///
    /// - Parameters:
    ///   - raw: raw string of article, typically 3 lines, example:
    ///   水文100篇合辑  本段难度:0.5(易)
    ///  ，智者常乐。并不是因为所爱的一切他都拥有了，而是所拥有的一切他都爱。人不可能把钱带进棺材，但钱能把人带进棺材。当你觉得保守一个秘密比传播一个秘密更有价值时，你就成熟了。女人应该注意这些信号：他殷勤，那
    ///  -----第93114段-sha1(34680)-发文:@【八六】真心 155800/222674(69.97%)
    ///      title is "水文100篇合辑"
    ///      paraNum is "93114"
    ///      content is "，智者常乐。并不是因为所爱的一切他都拥有了，而是所拥有的一切他都爱。人不可能把钱带进棺材，但钱能把人带进棺材。当你觉得保守一个秘密比传播一个秘密更有价值时，你就成熟了。女人应该注意这些信号：他殷勤，那"
    ///      how to find title : in the first line, find string before the first \s
    ///      how to find content: if you can find the title and the paraNum, the content should be between them
    ///      how to find paraNum: in the last line , find -第[\d+]]段-
    ///      if title and paraNum can't not be found , title set to '自由发文' paraNum set to 1, content set to raw
    /// - Returns: Article
    static func articleFromRaw(raw: String) -> Article {
        let paraNum = findParaNum(raw: raw)
        let title = findTitle(raw: raw)
        let content = findContent(raw: raw, title: title, paraNum: paraNum)
        return Article(content: content,title: title, paraNum: paraNum)
    }
    
    private static func findParaNum(raw: String) -> Int {
        let pattern = "-第(\\d+)段"
        let regex = try? NSRegularExpression(pattern: pattern)
        if let match = regex?.firstMatch(in: raw, range: NSRange(raw.startIndex..., in: raw)),
           let range = Range(match.range(at: 1), in: raw) {
            let paraNumStr = raw[range]
            return Int(paraNumStr) ?? 1
        }
        return 1
    }
    
    private static func findTitle(raw: String) -> String {
        let lines = raw.components(separatedBy: .newlines)
        if let firstLine = lines.first {
            if let startIndex = firstLine.firstIndex(of: "《"),
               let endIndex = firstLine.firstIndex(of: "》"),
               startIndex < endIndex {
                return String(firstLine[firstLine.index(after: startIndex)..<endIndex])
            } else if let range = firstLine.range(of: " ") {
                return String(firstLine[..<range.lowerBound])
            }
            if(lines.count>2){
                return lines[0]
            }
        }
        return "自由发文"
    }
    
    private static func findContent(raw: String, title: String, paraNum: Int) -> String {
        let pattern = "\(title).*?-第\(paraNum)段"
        let regex = try? NSRegularExpression(pattern: pattern, options: .dotMatchesLineSeparators)
        if let match = regex?.firstMatch(in: raw, range: NSRange(raw.startIndex..., in: raw)),
           let range = Range(match.range, in: raw) {
            let matchedString = String(raw[range])
            let components = matchedString.components(separatedBy: .newlines)
            if components.count > 1 {
                return components[1].trimmingCharacters(in: .whitespacesAndNewlines)
            }
        }
        return raw
    }
    
    
 
}
