import Foundation

struct Question: Codable, Identifiable, Hashable {
    let questionId: Int
    let title: String
    let body: String?
    let score: Int
    let answerCount: Int
    let isAnswered: Bool
    let viewCount: Int
    let creationDate: Date
    let lastActivityDate: Date
    let owner: User?
    
    var id: Int {
            return questionId
        }
}
