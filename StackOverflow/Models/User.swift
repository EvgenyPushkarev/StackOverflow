import Foundation

struct User: Codable, Identifiable {
    let id: Int
    let displayName: String
    let profileImage: String?
    let reputation: Int?
    
    enum CodingKeys: String, CodingKey {
        case id = "user_id"
        case displayName = "display_name"
        case profileImage = "profile_image"
        case reputation
    }
}
