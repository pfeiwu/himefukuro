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
    
    var formattedTextLines: [AttributedString] {
        let articleText = currentArticle.content
        var result :[AttributedString] = []
        var strResult :[String] = []
        let userInputText = currentRecord.realInput
        
        var currentLine = AttributedString("")
        var currentLineStr = ""
        var approximateSize = 0
        var measureCount = 0
        var unmeasureCount = 0
        for (articleIndex, articleChar) in articleText.enumerated() {
            if currentLineStr.count >= approximateSize {
                let currentLineWith = measureTextWidth(text: currentLineStr, font: NSFont(name: fontName, size: fontSize)!)
                measureCount += 1
                if  currentLineWith >= containerWidth * 0.97   {
                    result.append(currentLine)
                    strResult.append(currentLineStr)
                    approximateSize = currentLineStr.count-5
                    currentLine = AttributedString("")
                    currentLineStr = ""
                    
                }
            }else {
                unmeasureCount += 1
            }
            var newChar = AttributedString(String(articleChar))
            if articleIndex < userInputText.count {
                let userInputChar = userInputText[userInputText.index(userInputText.startIndex, offsetBy: articleIndex)]
                if articleChar == userInputChar {
                    newChar.backgroundColor = .lightGray
                } else {
                    newChar.backgroundColor = .red
                }
            } else {
                newChar.backgroundColor = .clear
            }
            currentLine.append(newChar)
            currentLineStr.append(articleChar)
        }
        result.append(currentLine)
        strResult.append(currentLineStr)
        print("measureCount: \(measureCount), unmeasureCount: \(unmeasureCount)")
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
                            Text(line)
                                .font(.custom(fontName, size: fontSize))
                                .padding(.leading, 0)
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .onAppear {
                        containerWidth = geometry.size.width - 20
                    }.onChange(of: geometry.size.width) { newWidth in
                        containerWidth = newWidth - 20
                    }
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
    
}
