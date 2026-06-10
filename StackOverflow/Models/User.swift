import Foundation

struct User: Codable, Identifiable {
    let userId: Int?
    let displayName: String
    let profileImage: String?
    let reputation: Int?
    
    var id: Int {
            return userId ?? 0
        }
}
