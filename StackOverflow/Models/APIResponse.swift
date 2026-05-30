//
//  APIResponse.swift
//  StackOverflow
//
//  Created by Evgeny on 28.05.2026.
//

import Foundation

struct APIResponse<T: Decodable>: Decodable {
    let items: [T]
    let hasMore: Bool
    let quotaMax: Int
    let quotaRemaining: Int
    
    enum CodingKeys: String, CodingKey {
        case items
        case hasMore = "has_more"
        case quotaMax = "quota_max"
        case quotaRemaining = "quota_remaining"
    }
}
