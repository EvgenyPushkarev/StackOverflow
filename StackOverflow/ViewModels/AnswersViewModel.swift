import Foundation

@Observable
final class AnswersViewModel {
    
    // MARK: - Properties
    private(set) var answers: [Answer] = []
    private(set) var isLoading = false
    var errorMessage: String?
    
    private let networkManager = NetworkManager.shared
    private let questionId: Int
    
    // MARK: - Init
    init(questionId: Int) {
        self.questionId = questionId
    }
    
    // MARK: - Network Intent
    @MainActor
        func fetchAnswers() async {
            guard !isLoading else { return }
            
            isLoading = true
            errorMessage = nil
            
            do {
                let fetchedAnswers = try await networkManager.getAnswers(for: questionId)
                
                // Мапим ответы на фоновом/асинхронном уровне, заранее подготавливая HTML
                let parsedAnswers = fetchedAnswers.map { rawAnswer -> Answer in
                    var updatedAnswer = rawAnswer
                    // Вызываем наше расширение строки и сохраняем результат
                    updatedAnswer.formattedBody = (rawAnswer.body ?? "Текст ответа отсутствует").htmlToAttributedString
                    return updatedAnswer
                }
                
                // Передаем в UI уже полностью готовые, отпарсенные данные
                self.answers = parsedAnswers
                self.isLoading = false
                
            } catch let error as NetworkError {
                self.errorMessage = error.localizedDescription
                self.isLoading = false
            } catch {
                self.errorMessage = "Что-то пошло не так: \(error.localizedDescription)"
                self.isLoading = false
            }
        }
}
