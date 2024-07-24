import SwiftUI

struct ArticleView: View {
    @State  private var articleManager: ArticleManager = ArticleManager.shared
    
    @State  private var recordManager: RecordManager = RecordManager.shared
    
    var body: some View {
        GeometryReader { geometry in
            ScrollView {
                ScrollViewReader { scrollView in
                    VStack(alignment: .leading, spacing: 8) {
                        ForEach(Array(articleManager.renderWithInput(userInput: recordManager.currentRecord.realInput).enumerated()), id: \.offset) { _, line in
                            Text(AttributedString(line.text))
                                .font(.custom(articleManager.fontName, size: articleManager.fontSize))
                                .padding(.leading, 0)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .id(line.isTypingLine ? "typingLine" : nil)
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .onAppear {
                        articleManager.render(containerWidth:geometry.size.width - 20)
                    }
                    .onChange(of: geometry.size.width) { newWidth,_ in
                        articleManager.render(containerWidth:geometry.size.width - 20)
                    }
                    .onChange(of: articleManager.article) { newWidth,_ in
                        articleManager.render(containerWidth:geometry.size.width - 20)
                    }
                    .onChange(of: recordManager.currentRecord.realInput) {
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
