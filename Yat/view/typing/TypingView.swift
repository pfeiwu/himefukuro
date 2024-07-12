//
//  TypingView.swift
//  Yat
//
//  Created by Pengfei Wu on 2024/7/12.
//

import Foundation
import SwiftUI
import UniformTypeIdentifiers
import AppKit
struct TypingView: NSViewRepresentable {
    
    public var currentRecord: Record
    
    func makeNSView(context: Context) -> NSTextView {
        let textView = YatNSTextView()
        return textView
    }
    func updateNSView(_ nsView: NSTextView, context: Context) {
        
    }
    
    public func keyDown(with event: NSEvent){
    }
    
    public func paste(_ sender: Any?){
    }
    
}
    
    


