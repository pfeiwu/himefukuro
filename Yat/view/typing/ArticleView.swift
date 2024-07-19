import SwiftUI

struct ArticleView: View {
    @Environment(ArticleContainer.self) private var currentArticleCon: ArticleContainer
    @Environment(Record.self) private var currentRecord: Record
    
    
    var body: some View {
        GeometryReader { geometry in
            ScrollView {
                ScrollViewReader { scrollView in
                    VStack(alignment: .leading, spacing: 8) {
                        ForEach(Array(currentArticleCon.renderWithInput(userInput: currentRecord.realInput).enumerated()), id: \.offset) { _, line in
                            Text(AttributedString(line.text))
                                .font(.custom(currentArticleCon.fontName, size: currentArticleCon.fontSize))
                                .padding(.leading, 0)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .id(line.isTypingLine ? "typingLine" : nil)
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .onAppear {
                        currentArticleCon.render(containerWidth:geometry.size.width - 20)
                    }
                    .onChange(of: geometry.size.width) { newWidth in
                        currentArticleCon.render(containerWidth:geometry.size.width - 20)
                    }
                    .onChange(of: currentArticleCon.article) { newWidth in
                        currentArticleCon.render(containerWidth:geometry.size.width - 20)
                    }
                    .onChange(of: currentRecord.realInput) { _ in
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
