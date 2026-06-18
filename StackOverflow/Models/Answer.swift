import Foundation

struct Answer: Codable, Identifiable {
    let answerId: Int
    let score: Int
    let isAccepted: Bool
    let body: String?
    let creationDate: Date
    let owner: User?
    
    var id: Int { answerId }
    
    // готовое свойство, хранящее текст
    var formattedBody: AttributedString = AttributedString("")
    
    // Перечисление, определяющее, какие именно поля декодировать из JSON
        enum CodingKeys: String, CodingKey {
            case answerId
            case score
            case isAccepted
            case body
            case creationDate
            case owner
            // Свойство formattedBody здесь отсутствует. Это исключит его из парсинга!
        }
}
