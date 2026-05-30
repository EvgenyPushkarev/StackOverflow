//
//  Answer.swift
//  StackOverflow
//
//  Created by Evgeny on 29.05.2026.
//
import Foundation

struct Answer: Decodable, Identifiable {
    let id: Int
    let score: Int
    let isAccepted: Bool
    let body: String?
    let creationDate: Date
    let owner: User?
    
    enum CodingKeys: String, CodingKey {
        case id = "answer_id"
        case score
        case isAccepted = "is_accepted"
        case body
        case creationDate = "creation_date"
        case owner
    }
}
