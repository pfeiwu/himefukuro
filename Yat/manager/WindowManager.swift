//
//  WindowManager.swift
//  Yat
//
//  Created by Pengfei Wu on 2024/7/15.
//

import Foundation
import SwiftUI
import AppKit


class WindowManager {
    
    static let shared = WindowManager()
    
    var localPostingWindow: NSWindow?
    
    
    private init() {
        
    }
    
    func showLocalPostingWindow() {
        if localPostingWindow == nil {
            let  contentView = LocalPostingView()
            let hostingController = NSHostingController(rootView: contentView)
            let window = NSWindow(contentViewController: hostingController)
            window.center()
            window.setContentSize(NSSize(width: 800, height: 600))
            window.title = "本地发文"
            localPostingWindow = window
        }
        localPostingWindow?.makeKeyAndOrderFront(nil)
    }
}
