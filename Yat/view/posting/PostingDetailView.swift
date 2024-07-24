//
//  PostingDetailView.swift
//  Yat
//
//  Created by Pengfei Wu on 2024/7/24.
//

import SwiftUI

struct PostingDetailView: View {
    
    let book: Book?
    
    @State private var articleManager: ArticleManager = ArticleManager.shared
    
    @State private var paramLengthDouble = 500.0
    
    @State private var paramNumDouble = 1.0
    
    private var paramLength:Int{
        get{
            Int(paramLengthDouble)
        }
    }
    
    private var paramNum:Int{
        get{
            Int(paramNumDouble)
        }
    }
    
    //
    //    GeometryReader { geometry in
    //        ScrollView {
    //            ScrollViewReader { scrollView in
    //                VStack(alignment: .leading, spacing: 8) {
    //                    ForEach(Array(articleManager.renderWithInput(userInput: recordManager.currentRecord.realInput).enumerated()), id: \.offset) { _, line in
    //                        Text(AttributedString(line.text))
    //                            .font(.custom(articleManager.fontName, size: articleManager.fontSize))
    //                            .padding(.leading, 0)
    //                            .frame(maxWidth: .infinity, alignment: .leading)
    //                            .id(line.isTypingLine ? "typingLine" : nil)
    //                    }
    //                }
    //                .frame(maxWidth: .infinity)
    //                .onAppear {
    //                    articleManager.render(containerWidth:geometry.size.width - 20)
    //                }
    //                .onChange(of: geometry.size.width) { newWidth,_ in
    //                    articleManager.render(containerWidth:geometry.size.width - 20)
    //                }
    //                .onChange(of: articleManager.article) { newWidth,_ in
    //                    articleManager.render(containerWidth:geometry.size.width - 20)
    //                }
    //                .onChange(of: recordManager.currentRecord.realInput) {
    //                    withAnimation {
    //                        scrollView.scrollTo("typingLine", anchor: .center)
    //                    }
    //                }
    //            }
    //        }
    //        .frame(maxWidth: .infinity, maxHeight: .infinity)
    var body: some View {
        GeometryReader { geometry in
            VStack {
                
                HStack{
                    
                    
                    HStack {
                        Text("段落长度:")
                        TextField("", value: $paramLengthDouble, formatter: NumberFormatter())
                            .frame(width: 80)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                        Stepper("", value: $paramLengthDouble, in: 1...1000000, step: 10)
                    }
                    
                    HStack {
                        Text("开始段落:")
                        TextField("", value: $paramNumDouble, formatter: NumberFormatter())
                            .frame(width: 80)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                        Stepper("", value: $paramNumDouble, in: 1...Double(book?.maxParamNumByParamLength(paramLength: paramLength) ?? 1), step: 1).disabled(book == nil  || book?.maxParamNum == 1)
                    }
                    
                    // 总字数
                    
                    Text("总字数: \(book?.content.count ?? 0)")
                    
                    // 总段数
                    Text("总段数: \(book?.maxParamNumByParamLength(paramLength: paramLength) ?? 0)")
                }
                Divider()
                
                Button("发文") {
                    if let book = book {
                        let tagertArt = BookUtil.getArticle(book: book, paramNum: paramNum, paramLength: paramLength) ?? Article()
                        ArticleManager.loadArticle(article: tagertArt)
                        if !StateManager.shared.silent {
                            let post = BookUtil.genPost(book: book, article: tagertArt, paramLength: paramLength)
                            QQAuxiliaryTool.shared.sendMsgToActiveWindow(message: post)
                        }
                    }
                }.disabled(book == nil)
                    .accentColor(Color.blue)
                
                Spacer()
                
                ScrollView {
                    VStack(alignment: .leading) {
                        Text(book.map { book in
                            BookUtil.getArticle(book: book, paramNum: paramNum, paramLength: paramLength)?.content ?? ""
                        } ?? "") .textFieldStyle(RoundedBorderTextFieldStyle())
                        .font(.custom(articleManager.fontName, size: articleManager.fontSize/1.4))
                        .padding(.leading, 0)
                        
                        Spacer()
                    } .frame(width:geometry.size.width,height:geometry.size.height / 2, alignment: .topLeading).background(Color.gray)
                }.frame(width:  geometry.size.width,height: geometry.size.height / 2,alignment: .bottom).padding( 7)
                
            }.onAppear {
                if let book = book {
                    paramNumDouble = Double(book.paramNum)
                    paramLengthDouble = Double(book.paramLength)
                }
            }
        }
        
        //            HStack {
        
        //
        //                VStack {
        //                    Text("paramNum: \(paramNum)")
        //                    Slider(value: Binding(
        //                        get: { Double(paramNum) },
        //                        set: { paramNum = Int($0) }
        //                    ), in: 1...max(Double(book?.maxParamNum ?? 1), 2), step: 1)
        //                }
        //            }
        //            .padding()
    }
                
                struct ImportantButtonStyle: ButtonStyle {
                    func makeBody(configuration: Configuration) -> some View {
                        configuration.label
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .font(.headline)
                            .cornerRadius(10)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color.blue, lineWidth: 2)
                            )
                            .shadow(color: .gray, radius: 4, x: 0, y: 2)
                            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
                            .animation(.easeOut(duration: 0.2), value: configuration.isPressed)
                    }
                }
    
    
    
}


