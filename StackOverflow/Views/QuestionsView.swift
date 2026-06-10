import SwiftUI

struct QuestionsView: View {
    // MARK: - Properties
    // Экран снаружи дергает init() и начинает наблюдать за ViewModel
    @State private var viewModel = QuestionsViewModel()
    
    // MARK: - Body
    var body: some View {
        NavigationStack {
            Group {
                if viewModel.isLoading {
                    // 1. Состояние загрузки
                    ProgressView("Загрузка вопросов...")
                        .scaleEffect(1.5)
                } else if let errorMessage = viewModel.errorMessage {
                    // 2. Состояние ошибки
                    ContentUnavailableView(
                        "Ошибка загрузки",
                        systemImage: "wifi.exclamationmark",
                        description: Text(errorMessage)
                    )
                } else {
                    // 3. Основной контент (Список вопросов)
                    List(viewModel.questions) { question in
                        // Ссылка для перехода:
                        NavigationLink {
                            AnswersView(question: question)
                        } label: {
                            VStack(alignment: .leading, spacing: 8) {
                                // Заголовок вопроса
                                Text(question.title)
                                    .font(.headline)
                                    .foregroundColor(.primary)
                                
                                // Подвал с информацией (Автор и счетчик ответов)
                                HStack {
                                    Label("\(question.answerCount)", systemImage: "bubble.right")
                                        .font(.caption)
                                        .foregroundColor(question.isAnswered ? .green : .secondary)
                                        .bold(question.isAnswered)
                                    
                                    Spacer()
                                    
                                    Text("Автор: \(question.owner?.displayName ?? "Неизвестен")")
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                }
                            }
                        }
                        .padding(.vertical, 4)
                    }
                    .listStyle(.plain)
                }
            }
            .navigationTitle("StackOverflow")
            
        }
    }
}

// MARK: - Preview
#Preview {
    QuestionsView()
}
