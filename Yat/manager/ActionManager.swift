//
//  ActionManager.swift
//  Yat
//
//  Created by Pengfei Wu on 2024/7/24.
//

import Foundation

@objc
class ActionManager:NSObject{
    public static let shared = ActionManager()
    
    @objc func openLocalPosting() {
        WindowManager.shared.showLocalPostingWindow()
    }
    
    @objc func loadFromQQ(){
        let articleStr = QQAuxiliaryTool.shared.readFromActiveWindow()
        let article = ArticleUtil.articleFromRaw(raw: articleStr)
        ArticleManager.loadArticle(article: article)
    }
    
    @objc func retype(){
        ArticleManager.shared.retype()
        print("recordManager.currentRecord.realInput:\(RecordManager.shared.currentRecord.realInput)")
    }
    
    @objc func shuffle(){
        
    }
    
    @objc func paste(){
    }
}
