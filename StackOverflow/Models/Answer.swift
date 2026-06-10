import Foundation

struct Answer: Codable, Identifiable {
    let answerId: Int
    let score: Int
    let isAccepted: Bool
    let body: String?
    let creationDate: Date
    let owner: User?
    
    var id: Int {
            return answerId
        }
}
