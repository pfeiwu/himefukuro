//
//  QQAuxiliaryTool.swift
//  Yat
//
//  Created by Pengfei Wu on 2024/7/23.
//

import Foundation
import AppKit

class QQAuxiliaryTool{
    
    public static let shared = QQAuxiliaryTool()
    
    private let appName = "QQ"
    
    private var pid:Int32 = 0
    
    init(){
        findQQWindow()
    }
    
    private func findQQWindow(){
        if let app = NSWorkspace.shared.runningApplications.first(where: { $0.localizedName == appName }) {
            pid = app.processIdentifier
            print("PID of \(appName): \(pid)")
        }
    }
    
    // 从当前QQ激活窗口读取文本
    func readFromActiveWindow()->String{
        let appElement = AXUIElementCreateApplication(pid)
        var windowElement: AnyObject?
        let err = AXUIElementCopyAttributeValue(appElement, kAXFocusedWindowAttribute as CFString, &windowElement)
        var articleRawTextCandidates:[String] = []
        if err == .success {
            exploreElement(level:0,windowElement as! AXUIElement) { element,level in
                var roleValue: AnyObject?
                              AXUIElementCopyAttributeValue(element, kAXRoleDescriptionAttribute as CFString, &roleValue)
                              if let role = roleValue as? String {
                                  if role == "text" {
                                      var valueValue: AnyObject?
                                      AXUIElementCopyAttributeValue(element, kAXValueAttribute as CFString, &valueValue)
                                      if let value = valueValue as? String {
                                          // 目前发现激活窗口的聊天记录在第19级，QQ更新后，可能会变化
                                          if value.contains("-第") && level >= 19{
                                                articleRawTextCandidates.append(value)
                                          }
                                      }
                                  }
                              }
            }
            print("发现了\(articleRawTextCandidates.count)个疑似赛文文本")
            print(articleRawTextCandidates)
            if articleRawTextCandidates.isEmpty{
                print("未找到赛文文本")
                return ""
            }else{
                return articleRawTextCandidates[0]
            }
        }else{
            print("未发现QQ窗口或无法读取，请确认QQ窗口是否正常运行，且给本应用赋予了辅助功能权限")
        }
        return ""
    }
    
    // 向当前QQ激活窗口发送文本
    func sendMsgToActiveWindow(message: String){
        print("向QQ发送文本：\(message)")
    }
    
   
    
    private func exploreElement(level: Int,_ element: AXUIElement, _ processElement: (AXUIElement,Int) -> Void) {
        // 处理当前元素
        processElement(element,level)
        let newlevel:Int = level+1
        // 获取子元素
        var childrenValue: AnyObject?
        let err = AXUIElementCopyAttributeValue(element, kAXChildrenAttribute as CFString, &childrenValue)
        if err == .success, let children = childrenValue as? [AXUIElement] {
            for child in children {
                // 递归处理子元素
                exploreElement(level:newlevel, child, processElement)
            }
        }
    }
}
