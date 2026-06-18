import SwiftUI

struct AnswersView: View {
    // MARK: - Properties
    // Приём вопроса с предыдущего экрана
    let question: Question
    
    // Инициализация ViewModel с передачей ID текущего вопроса
    @State private var viewModel: AnswersViewModel
    
    init(question: Question) {
        self.question = question
        self._viewModel = State(initialValue: AnswersViewModel(questionId: question.questionId))
    }
    
    // MARK: - Body
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                
                // 1. Отображение блока самого вопроса
                VStack(alignment: .leading, spacing: 12) {
                    Text(question.title)
                        .font(.title2)
                        .bold()
                        .foregroundColor(.primary)
                    
                    HStack {
                        Text("Автор: \(question.owner?.displayName ?? "Неизвестен")")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        
                        Spacer()
                        
                        Label("\(question.answerCount)", systemImage: "bubble")
                            .font(.caption)
                            .bold()
                            .foregroundColor(question.isAnswered ? .green : .secondary)
                    }
                }
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(12)
                
                Divider()
                
                // 2. Отображение блока ответов
                Text("Ответы")
                    .font(.title3)
                    .bold()
                    .padding(.horizontal)
                
                // Проверка состояний загрузки ответов
                if viewModel.isLoading {
                    // Отображение индикатора загрузки в зоне ответов
                    HStack {
                        Spacer()
                        ProgressView("Загрузка ответов...")
                            .scaleEffect(1.2)
                            .padding(.top, 40)
                        Spacer()
                    }
                } else if let errorMessage = viewModel.errorMessage {
                    // Отображение ошибки сетевого запроса
                    ContentUnavailableView(
                        "Ошибка",
                        systemImage: "exclamationmark.triangle",
                        description: Text(errorMessage)
                    )
                    .padding(.top, 20)
                } else if viewModel.answers.isEmpty {
                    // Отображение заглушки при отсутствии ответов
                    ContentUnavailableView(
                        "Нет ответов",
                        systemImage: "text.bubble",
                        description: Text("На этот вопрос ещё никто не ответил.")
                    )
                    .padding(.top, 20)
                } else {
                    // Итерация и вывод списка полученных ответов
                    LazyVStack(alignment: .leading, spacing: 12) {
                        ForEach(viewModel.answers) { answer in
                            VStack(alignment: .leading, spacing: 6) {
                                Text(answer.formattedBody)
                                    .font(.body)
                                
                                HStack {
                                    Text("Ответил: \(answer.owner?.displayName ?? "Неизвестен")")
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                    Spacer()
                                    if answer.isAccepted {
                                        Image(systemName: "checkmark.circle.fill")
                                            .foregroundColor(.green)
                                    }
                                }
                                Divider()
                            }
                            .padding(.horizontal)
                        }
                    }
                }
            }
            .padding()
        }
        .navigationTitle("Вопрос")
        .navigationBarTitleDisplayMode(.inline)
        // Запуск триггера сетевого запроса
        .task {
            await viewModel.fetchAnswers()
        }
    }
    
    
    
    // MARK: - Preview
    #Preview {
        // Тестовый вопрос для рендеринга интерфейса в Canvas
        let mockQuestion = Question(
            questionId: 1,
            title: "Как передать данные между экранами в SwiftUI?",
            body: "Пытаюсь понять, как работает навигация...",
            score: 10,
            answerCount: 3,
            isAnswered: true,
            viewCount: 100,
            creationDate: Date(),
            lastActivityDate: Date(),
            owner: User(userId: 1, displayName: "SwiftCoder", profileImage: nil, reputation: 42)
        )
        // Оборачиваем в NavigationStack, чтобы модификаторы навигации (.navigationTitle) корректно отображались в превью
        NavigationStack {
            AnswersView(question: mockQuestion)
        }
    }
}

