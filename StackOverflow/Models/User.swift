import Foundation

struct User: Codable, Identifiable, Hashable {
    let userId: Int?
    let displayName: String
    let profileImage: String?
    let reputation: Int?
    
    // Соответствие протоколу Identifiable с генерацией уникального UUID при отсутствии userId
        var id: String {
            if let userId = userId {
                return String(userId)
            }
            return UUID().uuidString
        }
}
