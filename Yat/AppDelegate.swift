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
        
        // 创建"发文"菜单
        let postMenu = NSMenu(title: "发文")
        let postMenuItem = NSMenuItem(title: "发文", action: nil, keyEquivalent: "")
        postMenuItem.submenu = postMenu
        
        // 创建"本地发文"菜单项
        let sendTextItem = NSMenuItem(title: "本地发文", action: #selector(openLocalPosting), keyEquivalent: ",")
        postMenu.addItem(sendTextItem)
        
        // 将"发文"菜单添加到主菜单
        mainMenu.addItem(postMenuItem)
        
        // 设置应用程序的主菜单
        NSApplication.shared.mainMenu = mainMenu
    }
    
    @objc func openLocalPosting() {
        WindowManager.shared.showLocalPostingWindow()
    }
}
