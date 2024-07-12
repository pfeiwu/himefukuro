//
//  YatNSTextView.swift
//  Yat
//  overwrite NSTextView to change the behaviors like pasting, key down, etc.
//  Created by Pengfei Wu on 2024/7/12.
//

import Foundation
import AppKit
 class YatNSTextView: NSTextView {
    
   
    
    // let parent to delegate the key down event.
    override func keyDown(with event: NSEvent){
//        parent.keyDown(with: event)
//        super.keyDown(with: event)
    }
    
    // let parent to delegate the paste event
    override func paste(_ sender: Any?){
//        parent.paste(sender)
        // do not need to trigger the original paste method here.
    }
}
