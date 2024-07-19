//
//  TextView.swift
//  Yat
//
//  Created by Pengfei Wu on 2024/7/19.
//

import Foundation
import SwiftUI

struct TextView: NSViewRepresentable {
    var attributedText: NSMutableAttributedString
    
    func makeNSView(context: Context) -> NSTextView {
        let textView = NSTextView()
        textView.isEditable = false
        textView.isSelectable = false
        textView.backgroundColor = .clear
        textView.drawsBackground = false
        return textView
    }
    
    func updateNSView(_ nsView: NSTextView, context: Context) {
        nsView.textStorage?.setAttributedString(attributedText)
    }
}
