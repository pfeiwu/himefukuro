//
//  TextWidthRuler.swift
//  Yat
//
//  Created by Pengfei Wu on 2024/7/17.
//

import Foundation
import AppKit

class TextWidthRuler {
    private var cache: [String: CGFloat] = [:]
    private var ruler: NSTextField

    init() {
        ruler = NSTextField(labelWithString: "")
        ruler.isBordered = false
        ruler.isEditable = false
        ruler.isSelectable = false
    }

    func measureTextWidth(text: String, font: NSFont) -> CGFloat {
        let cacheKey = "\(text)-\(font.fontName)-\(font.pointSize)"
        
        if let cachedWidth = cache[cacheKey] {
            return cachedWidth
        }
        
        ruler.stringValue = text
        ruler.font = font
        ruler.sizeToFit()
        let width = ruler.frame.width
        
        cache[cacheKey] = width
        return width
    }
}
