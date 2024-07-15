import SwiftUI

struct ArticleView: View {
    @Environment(ArticleContainer.self) private var currentArticleCon: ArticleContainer
    @Environment(Record.self) private var currentRecord: Record
    
    
    @State private var containerWidth: CGFloat = 0
    
    @State private var fontSize: CGFloat = 30
    
    @State private var fontName: String = "LXGW Wenkai"
    
    private var ruler = NSTextField(labelWithString: "")
    
    private var currentArticle: Article {
        currentArticleCon.article
    }
    
    var formattedTextLines: [(text: AttributedString, isTypingLine: Bool)] {
        let articleText = currentArticle.content
        var result :[(text: AttributedString, isTypingLine: Bool)] = []
        var strResult :[String] = []
        let userInputText = currentRecord.realInput
        
        var currentLine = AttributedString("")
        var currentLineStr = ""
        var approximateSize = 0
        var hasInput = false
        var hasUninput = false
        for (articleIndex, articleChar) in articleText.enumerated() {
            if currentLineStr.count >= approximateSize {
                let currentLineWith = measureTextWidth(text: currentLineStr, font: NSFont(name: fontName, size: fontSize)!)
                if  currentLineWith >= containerWidth * 0.97   {
                    result.append((text : currentLine, isTypingLine : hasInput&&hasUninput))
                    strResult.append(currentLineStr)
                    approximateSize = currentLineStr.count-5
                    currentLine = AttributedString("")
                    currentLineStr = ""
                }
            }
            var newChar = AttributedString(String(articleChar))
            if articleIndex < userInputText.count {
                hasInput = true
                let userInputChar = userInputText[userInputText.index(userInputText.startIndex, offsetBy: articleIndex)]
                if articleChar == userInputChar {
                    newChar.backgroundColor = .lightGray
                } else {
                    newChar.backgroundColor = .red
                }
            } else {
                hasUninput = true
                newChar.backgroundColor = .clear
            }
            currentLine.append(newChar)
            currentLineStr.append(articleChar)
        }
        result.append((text : currentLine, isTypingLine : hasInput&&hasUninput))
        strResult.append(currentLineStr)
        return result
    }
    
    func measureTextWidth(text: String, font: NSFont) -> CGFloat {
        let textField = ruler
        textField.stringValue = text
        textField.font = font
        textField.sizeToFit()
        let width = textField.frame.width
        return width
    }
    
    var body: some View {
        GeometryReader { geometry in
            ScrollView {
                ScrollViewReader { scrollView in
                    VStack(alignment: .leading, spacing: 8) {
                        ForEach(Array(formattedTextLines.enumerated()), id: \.offset) { _, line in
                            Text(line.text)
                                .font(.custom(fontName, size: fontSize))
                                .padding(.leading, 0)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .id(line.isTypingLine ? "typingLine" : nil) // 根据条件设置 id
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .onAppear {
                        containerWidth = geometry.size.width - 20
                    }.onChange(of: geometry.size.width) { newWidth in
                        containerWidth = newWidth - 20
                    }.onChange(of: currentRecord.realInput) { _ in
                        withAnimation {
                            scrollView.scrollTo("typingLine", anchor: .center)
                        }
                    }
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
    
}
