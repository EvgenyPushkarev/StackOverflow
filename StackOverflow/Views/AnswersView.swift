import SwiftUI

struct AnswersView: View {
    // MARK: - Properties
    // Принимаем вопрос с предыдущего экрана
    let question: Question
    
    // MARK: - Body
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                
                // 1. Блок самого вопроса
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
                        
                        Label("\(question.answerCount)", systemImage: "bubble.right")
                            .font(.caption)
                            .bold()
                            .foregroundColor(question.isAnswered ? .green : .secondary)
                    }
                }
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(12)
                
                Divider()
                
                // 2. Блок для будущих ответов
                Text("Ответы")
                    .font(.title3)
                    .bold()
                    .padding(.horizontal)
                
                // Пока мы не загрузили ответы из сети, покажем временную заглушку
                ContentUnavailableView(
                    "Нет ответов",
                    systemImage: "text.bubble",
                    description: Text("Здесь будут отображаться ответы на этот вопрос.")
                )
                .padding(.top, 20)
                
            }
            .padding()
        }
        .navigationTitle("Вопрос")
        .navigationBarTitleDisplayMode(.inline) // Компактный заголовок по центру
    }
}

// MARK: - Preview
#Preview {
    // Для работы превью нам нужно передать фейковый (тестовый) вопрос
    AnswersView(question: Question(
        questionId: 1,
        title: "Как передать данные между экранами в SwiftUI?",
        body: "Я пытаюсь понять, как работает навигация...",
        score: 10,
        answerCount: 3,
        isAnswered: true,
        viewCount: 100,
        creationDate: Date(),
        lastActivityDate: Date(),
        owner: User(userId: 1, displayName: "SwiftCoder", profileImage: nil, reputation: 42)
    ))
}
