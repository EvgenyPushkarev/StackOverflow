import Foundation

final class NetworkManager {
    
    // Статическое свойство для доступа к менеджеру из любой точки приложения (паттерн Singleton)
    static let shared = NetworkManager()
    
    // Приватный инициализатор, чтобы никто не мог создать еще один экземпляр класса со стороны
    private init() {}
    
    // Базовый URL для StackExchange API
    private let baseURL = "https://api.stackexchange.com/2.3"
    
    /// 1. Универсальный метод для загрузки данных с сервера
    /// - Parameter endpoint: Относительный путь к нужному запросу (например, "/questions")
    /// - Returns: Раскодированный объект нужного типа T
    func fetch<T: Codable>(endpoint: String) async throws -> T {
        // 1.1 Собираем полный URL
        guard let url = URL(string: baseURL + endpoint) else {
            throw NetworkError.badURL
        }
        
        print("--- СЕТЕВОЙ ЗАПРОС УЛЕТАЕТ СЮДА: \(url.absoluteString) ---")
        
        // 1.2. Делаем сетевой запрос через URLSession
        let (data, response) = try await URLSession.shared.data(from: url)
        // 1.3. Проверяем ответ сервера (HTTP статус-код)
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.invalidResponse
        }
        // Если статус-код плохой (например, 400)
        guard (200...299).contains(httpResponse.statusCode) else {
            // Пытаемся заглянуть внутрь ответа сервера и прочитать JSON ошибки
            if let serverError = try? JSONDecoder().decode(StackExchangeError.self, from: data) {
                // Теперь мы знаем ТОЧНЫЙ код ошибки от StackExchange API
                switch serverError.errorId {
                case 503: // Код throttle_violation по документации API
                    throw NetworkError.quotaExceeded
                default:
                    throw NetworkError.invalidResponse
                }
            }
            
            // Если сервер прислал ошибку, но JSON внутри не распознался
            throw NetworkError.invalidResponse
        }
        
        // 1.4. Декодируем полученный JSON в наши Swift-модели
        do {
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            decoder.dateDecodingStrategy = .secondsSince1970
            return try decoder.decode(T.self, from: data)
        } catch let decodingError as DecodingError {
                    // Детальный анализ ошибки декодирования
                    print("❌❌❌ ОШИБКА ДЕКОДИРОВАНИЯ В ТИПЕ: \(T.self)")
                    switch decodingError {
                    case .keyNotFound(let key, let context):
                        print("Ключ '\(key.stringValue)' не найден. Путь: \(context.codingPath.map { $0.stringValue }.joined(separator: "."))")
                    case .typeMismatch(let type, let context):
                        print("Несоответствие типов для \(type). Путь: \(context.codingPath.map { $0.stringValue }.joined(separator: "."))")
                    case .valueNotFound(let type, let context):
                        print("Значение типа \(type) не найдено. Путь: \(context.codingPath.map { $0.stringValue }.joined(separator: "."))")
                    case .dataCorrupted(let context):
                        print("Данные повреждены: \(context.debugDescription)")
                    @unknown default:
                        print("Неизвестная ошибка декодирования: \(decodingError)")
                    }
                    throw NetworkError.decodingError
        } catch {
            print("❌ ДРУГАЯ ОШИБКА: \(error.localizedDescription)")
            throw error
        }
    }
    
    /// 2. Метод для загрузки вопросов со StackOverflow
    /// - Returns: Массив объектов Question
        func getQuestions() async throws -> [Question] {
            // 2.1. Формируем эндпоинт с параметрами фильтрации
            // site=stackoverflow — ищем именно на этом сайте
            // order=desc&sort=activity — сортируем от самых свежих/активных к старым
            let endpoint = "/questions?order=desc&sort=activity&site=stackoverflow"
            // 2.2. Вызываем наш универсальный fetch
            // Явно указываем, что хотим получить обертку APIResponse, внутри которой лежит массив [Question]
            let response: APIResponse<Question> = try await fetch(endpoint: endpoint)
            // 2.3. Возвращаем наружу только сам массив вопросов, очищенный от служебных полей JSON
            return response.items
        }
    
    /// 3. Метод для загрузки списка ответов, относящихся к определённому вопросу
    /// - Parameter questionId: Уникальный ID вопроса, ответы на который хотим получить
    /// - Returns: Массив объектов Answer
    func getAnswers(for questionId: Int) async throws -> [Answer] {
        // 3.1. Формируем динамический эндпоинт, подставляя ID вопроса прямо в строку
        let endpoint = "/questions/\(questionId)/answers?order=desc&sort=activity&site=stackoverflow&filter=withbody"
        
        // 3.2. Вызываем универсальный fetch и просим его вернуть APIResponse с массивом [Answer]
        let response: APIResponse<Answer> = try await fetch(endpoint: endpoint)
        
        // 3.3. Возвращаем чистый массив ответов наружу
        return response.items
    }
}

