import Foundation

struct APIResponse<T: Codable>: Codable {
    let items: [T]
    let hasMore: Bool
    let quotaMax: Int
    let quotaRemaining: Int
    
}
