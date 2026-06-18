import Foundation

@Observable
final class QuestionsViewModel {
    
    // MARK: - Свойства (Данные для экрана)
    
    // Список вопросов, который покажем в таблице
    private(set) var questions: [Question] = []
    
    // Статус загрузки, чтобы показывать индикатор (Spinner)
    private(set) var isLoading = false
    
    // Текст ошибки, если что-то пойдет не так
    var errorMessage: String?
    
    // Сетевой слой (используем Singleton)
    private let networkManager = NetworkManager.shared
    
    init() {}
        
        func fetchQuestions() async {
            // Проверка загрузки чтобы избежать лишних перерисовок UI
            guard !isLoading else { return }
            
            isLoading = true
            errorMessage = nil
            
            do {
                let fetchedQuestions = try await networkManager.getQuestions()
                self.questions = fetchedQuestions
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

