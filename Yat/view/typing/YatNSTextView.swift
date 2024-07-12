//
//  YatNSTextView.swift
//  Yat
//  overwrite NSTextView to change the behaviors like pasting, key down, etc.
//  Created by Pengfei Wu on 2024/7/12.
//

import Foundation
import AppKit
 class YatNSTextView: NSTextView {
    
    // for delegate
    override func keyDown(with event: NSEvent){
        if let delegate = self.delegate as? TypingView.Coordinator{
            delegate.keyDown(with: event)
        }
        super.keyDown(with: event)
    }
    
    // for delegate
    override func paste(_ sender: Any?){
        if let delegate = self.delegate as? TypingView.Coordinator{
            delegate.paste(sender)
        }
        // do not need to trigger the original paste method here.
    }
}
