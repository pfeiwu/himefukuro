//
//  QQAuxiliaryTool.swift
//  Yat
//
//  Created by Pengfei Wu on 2024/7/23.
//

import Foundation
import AppKit
import ApplicationServices
import Cocoa

class QQAuxiliaryTool{
    
    public static let shared = QQAuxiliaryTool()
    
    private let appName = "QQ"
    
    private var pid:Int32 = 0
    
    init(){
        findQQWindow()
    }
    
    private func findQQWindow() {
        if let app = NSWorkspace.shared.runningApplications.first(where: { $0.localizedName == appName }) {
            pid = app.processIdentifier
            print("PID of \(appName): \(pid)")
            let appElement = AXUIElementCreateApplication(pid)
            AXUIElementSetAttributeValue(appElement, "AXManualAccessibility" as CFString, kCFBooleanTrue)
        }
    }
    
    // 从当前QQ激活窗口读取文本
    func readFromActiveWindow(retry:Bool = false)->String{
        let appElement = AXUIElementCreateApplication(pid)
        var windowElement: AnyObject?
        let err = AXUIElementCopyAttributeValue(appElement, kAXFocusedWindowAttribute as CFString, &windowElement)
        var articleRawTextCandidates:[String] = []
        if err == .success {
            exploreElement(level:0,windowElement as! AXUIElement) { element,level in
                var roleValue: AnyObject?
                AXUIElementCopyAttributeValue(element, kAXRoleDescriptionAttribute as CFString, &roleValue)
                let role = getRole(element: element)
                if role == "text" {
                    var valueValue: AnyObject?
                    AXUIElementCopyAttributeValue(element, kAXValueAttribute as CFString, &valueValue)
                    let value = getValue(element: element)
                    print("Text From QQ: (\(level)) : \(value)")
                    // 目前发现激活窗口的聊天记录在第19级，QQ更新后，可能会变化
                    if  level >= 19 && value.contains("-第") && value.split(separator: "\n").count == 3 {
                        articleRawTextCandidates.append(value)
                    }
                }
            }
            print("发现了\(articleRawTextCandidates.count)个疑似赛文文本")
            print(articleRawTextCandidates)
            if articleRawTextCandidates.isEmpty{
                return "已读取了QQ窗口，但未发现发文"
            }else{
                return articleRawTextCandidates[0]
            }
        }else{
            if retry{
                return "未发现QQ窗口或无法读取，请确认QQ窗口是否正常运行，且给本应用赋予了辅助功能权限"
            }
            findQQWindow()
            return readFromActiveWindow(retry: true)
        }
    }
    
    
    
    // 向当前QQ激活窗口发送文本
    func sendMsgToActiveWindow(message: String){
        print("向QQ发送文本：\(message)")
        NSPasteboard.general.clearContents()
        NSPasteboard.general.setString(message, forType: .string)
        let appElement = AXUIElementCreateApplication(pid)
        AXUIElementSetAttributeValue(appElement, kAXFrontmostAttribute as CFString, true as CFTypeRef)
        // 模拟键盘事件来执行粘贴操作
        let keyDownEvent = CGEvent(keyboardEventSource: nil, virtualKey: 0x09, keyDown: true)
        keyDownEvent?.flags = .maskCommand
        keyDownEvent?.post(tap: .cghidEventTap)
        
        let keyUpEvent = CGEvent(keyboardEventSource: nil, virtualKey: 0x09, keyDown: false)
        keyUpEvent?.flags = .maskCommand
        keyUpEvent?.post(tap: .cghidEventTap)
        
        usleep(100000) // 暂停100毫秒
        // 模拟回车键的按下和释放
        let enterKeyDownEvent = CGEvent(keyboardEventSource: nil, virtualKey: 0x24, keyDown: true)
        
        let enterKeyUpEvent = CGEvent(keyboardEventSource: nil, virtualKey: 0x24, keyDown: false)
        
        enterKeyDownEvent?.flags = .maskNonCoalesced
        enterKeyUpEvent?.flags = .maskNonCoalesced
        
        
        enterKeyDownEvent?.post(tap: .cghidEventTap)
        usleep(100000) // 暂停100毫秒
        enterKeyUpEvent?.post(tap: .cghidEventTap)
        
        enterKeyDownEvent?.post(tap: .cghidEventTap)
        usleep(100000) // 暂停100毫秒
        enterKeyUpEvent?.post(tap: .cghidEventTap)
        
        enterKeyDownEvent?.post(tap: .cghidEventTap)
        usleep(100000) // 暂停100毫秒
        enterKeyUpEvent?.post(tap: .cghidEventTap)
        
        // 获取当前应用程序的进程标识符 (PID)
        let currentAppPID = NSRunningApplication.current.processIdentifier
        
        usleep(500000) // 暂停100毫秒
        // 使用 Accessibility API 将当前应用程序重新置为前台
        let currentProcess = AXUIElementCreateApplication(currentAppPID)
        AXUIElementSetAttributeValue(currentProcess, kAXFrontmostAttribute as CFString, true as CFTypeRef)
    }
    
    private func exploreElement(level: Int, _ element: AXUIElement, _ processElement: (AXUIElement, Int) -> Void) {
        // 处理当前元素
        processElement(element, level)
        let newLevel: Int = level + 1
        let children = getChildren(element: element)
        for child in children {
            // 递归处理子元素
            exploreElement(level: newLevel, child, processElement)
        }
        
    }
    
    
    private func getRole(element:AXUIElement)->String {
        var roleValue: AnyObject?
        AXUIElementCopyAttributeValue(element, kAXRoleDescriptionAttribute as CFString, &roleValue)
        if let role = roleValue as? String {
            return role
        }
        return ""
    }
    
    private func getValue(element:AXUIElement)->String {
        var valueValue: AnyObject?
        AXUIElementCopyAttributeValue(element, kAXValueAttribute as CFString, &valueValue)
        if let value = valueValue as? String {
            return value
        }
        return ""
    }
    
    private func getChildren(element:AXUIElement)->[AXUIElement] {
        var childrenValue: AnyObject?
        let err = AXUIElementCopyAttributeValue(element, kAXChildrenAttribute as CFString, &childrenValue)
        if err == .success, let children = childrenValue as? [AXUIElement] {
            return children
        }
        return []
    }
     
    
}


