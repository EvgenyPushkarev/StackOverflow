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
                        NavigationLink(value: question) {
                            VStack(alignment: .leading, spacing: 8) {
                                Text(question.title)
                                    .font(.headline)
                                    .foregroundColor(.primary)
                                
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
            .navigationDestination(for: Question.self) { question in
                AnswersView(question: question)
            }
            .task { await viewModel.fetchQuestions()
            }
        }
    }
}

// MARK: - Preview
#Preview {
    QuestionsView()
}
