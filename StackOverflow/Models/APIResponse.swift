import Foundation

// Модель для декодирования корневого JSON-ответа API
struct APIResponse<T: Codable>: Codable {
    // Массив полученных объектов основной модели
    let items: [T]
    
    // Флаг наличия следующих страниц с данными
    let hasMore: Bool?
    
    // Максимально доступное количество запросов в сутки
    let quotaMax: Int?
    
    // Количество оставшихся запросов в текущие сутки
    let quotaRemaining: Int?
}
