import Foundation

enum NetworkError: Error {
    case badURL
    case invalidResponse
    case decodingError
    case quotaExceeded
    case unknown
    
    // Описание ошибки для вывода на экран
    var localizedDescription: String {
        switch self {
        case .badURL:
            return "Неверно сформирован адрес запроса."
        case .invalidResponse:
            return "Сервер вернул некорректный ответ."
        case .decodingError:
            return "Не удалось обработать полученные данные."
        case .quotaExceeded:
            return "Исчерпан суточный лимит запросов к API."
        case .unknown:
            return "Произошла неизвестная ошибка."
        }
    }
}

struct StackExchangeError: Codable {
    let errorId: Int
    let errorMessage: String
    let errorName: String
    
    enum CodingKeys: String, CodingKey {
        case errorId = "error_id"
        case errorMessage = "error_message"
        case errorName = "error_name"
    }
}
