//
//  Question.swift
//  StackOverflow
//
//  Created by Evgeny on 28.05.2026.
//
import Foundation

struct Question: Decodable, Identifiable {
    let id: Int
    let title: String
    let body: String?
    let score: Int
    let answerCount: Int
    let isAnswered: Bool
    let viewCount: Int
    let creationDate: Date
    let lastActivityDate: Date
    let owner: User?
    
    enum CodingKeys: String, CodingKey {
        case id = "question_id"
        case title
        case body
        case score
        case answerCount = "answer_count"
        case isAnswered = "is_answered"
        case viewCount = "view_count"
        case creationDate = "creation_date"
        case lastActivityDate = "last_activity_date"
        case owner
    }
}

struct User: Decodable {
    let displayName: String
    let profileImage: String?
    let reputation: Int?
    
    enum CodingKeys: String, CodingKey {
        case displayName = "display_name"
        case profileImage = "profile_image"
        case reputation
    }
}
