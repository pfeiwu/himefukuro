//
//  AppDelegate.swift
//  Yat
//
//  Created by Pengfei Wu on 2024/7/15.
//

import Foundation
import AppKit


class AppDelegate: NSObject, NSApplicationDelegate {
    func applicationDidFinishLaunching(_ notification: Notification) {
        setupMenu()
        PermissionsService.acquireAccessibilityPrivileges()
    }
    
    func setupMenu() {
        // 创建一个全新的主菜单
        let mainMenu = NSMenu()
        
        // 创建应用菜单（App的名字那个菜单）
        let appMenu = NSMenu()
        let appName = ProcessInfo.processInfo.processName
        let appMenuItem = NSMenuItem(title: appName, action: nil, keyEquivalent: "")
        appMenuItem.submenu = appMenu
        
        // 添加"关于"菜单项到应用菜单
        let aboutMenuItem = NSMenuItem(title: "关于 \(appName)", action: #selector(NSApplication.orderFrontStandardAboutPanel(_:)), keyEquivalent: "")
        appMenu.addItem(aboutMenuItem)
        
        // 添加分隔符
        appMenu.addItem(NSMenuItem.separator())
        
        // 添加"退出"菜单项到应用菜单
        let quitMenuItem = NSMenuItem(title: "退出 \(appName)", action: #selector(NSApplication.terminate(_:)), keyEquivalent: "q")
        appMenu.addItem(quitMenuItem)
        
        // 将应用菜单添加到主菜单
        mainMenu.addItem(appMenuItem)
        
        // 创建"载文"菜单
        let postMenu = NSMenu(title: "载文")
        let postMenuItem = NSMenuItem(title: "载文", action: nil, keyEquivalent: "")
        postMenuItem.submenu = postMenu
        
        // 创建"本地载文"菜单项
        let sendTextItem = NSMenuItem(title: "本地载文", action: #selector(openLocalPosting), keyEquivalent: "5")
        
        // 创建“从剪贴板载文”菜单项
        let sendClipboardItem = NSMenuItem(title: "从剪贴板载文", action: #selector(NSText.paste(_:)), keyEquivalent: "v")
     
        // 创建“从QQ载文“菜单项
        let sendQQItem = NSMenuItem(title: "从QQ载文", action: #selector(loadFromQQ), keyEquivalent: "4")
        
        postMenu.addItem(sendQQItem)
        postMenu.addItem(sendTextItem)
        postMenu.addItem(sendClipboardItem)
        
        
        let functionMenu = NSMenu(title: "功能")
        let functionMenuItem = NSMenuItem(title: "功能", action: nil, keyEquivalent: "")
        
        functionMenuItem.submenu = functionMenu
        
        // 创建重打菜单项
        let resetMenuItem = NSMenuItem(title: "重打", action: #selector(retype), keyEquivalent: "3")
        
        // 创建乱序菜单项
        let shuffleMenuItem = NSMenuItem(title:"乱序", action: #selector(shuffle), keyEquivalent: "l")
        
        functionMenu.addItem(resetMenuItem)
        functionMenu.addItem(shuffleMenuItem)
        
        // 将"载文"菜单添加到主菜单
        mainMenu.addItem(postMenuItem)
        
        // 将"功能"菜单添加到主菜单
        mainMenu.addItem(functionMenuItem)
        
        // 设置应用程序的主菜单
        NSApplication.shared.mainMenu = mainMenu
    }
    
    @objc func openLocalPosting() {
        WindowManager.shared.showLocalPostingWindow()
    }
    
    @objc func loadFromQQ(){
        ActionManager.shared.loadFromQQ()
    }
    
    @objc func retype(){
        ActionManager.shared.retype()
    }
    
    @objc func shuffle(){
        ActionManager.shared.shuffle()
    }
}
