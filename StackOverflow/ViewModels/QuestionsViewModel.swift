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
    
    // Наш сетевой слой (используем Singleton)
    private let networkManager = NetworkManager.shared
    
    // MARK: - Инициализатор
    
    init() {
        // Скачиваем вопросы сразу при возникновении ViewModel
        // Используем Task, так как init не может быть асинхронным сам по себе
        Task {
            await fetchQuestions()
        }
    }
    
    // MARK: - Логика (Сетевой запрос)
    
    /// Загружает вопросы через NetworkManager и обрабатывает результат
    func fetchQuestions() async {
        // 1. Включаем индикатор загрузки и сбрасываем старые ошибки
        isLoading = true
        errorMessage = nil
        
        // 2. Блок do-catch для отлова сетевых ошибок
        do {
            let fetchedQuestions = try await networkManager.getQuestions()
            
            // Если всё успешно, сохраняем вопросы в наше свойство
            self.questions = fetchedQuestions
            self.isLoading = false
            
        } catch let error as NetworkError {
            // Если прилетела наша понятная NetworkError, переводим её для пользователя
            self.errorMessage = error.localizedDescription
            self.isLoading = false
            
        } catch {
            // На случай непредвиденных системных ошибок
            self.errorMessage = "Что-то пошло не так: \(error.localizedDescription)"
            self.isLoading = false
        }
    }
}

