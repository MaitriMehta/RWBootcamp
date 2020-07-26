//
//  QuestionCodable.swift
//  jQuiz
//
//  Created by Jay Strawn on 7/17/20.
//  Copyright © 2020 Jay Strawn. All rights reserved.
//

import Foundation

// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let welcome = try? newJSONDecoder().decode(Welcome.self, from: jsonData)

import Foundation

// MARK: - WelcomeElement
struct Clue: Codable {
    let id: Int
    let answer, question: String
    let value: Int
    let airdate, createdAt, updatedAt: String
    let categoryID: Int
    let gameID, invalidCount: JSONNull?
    let category: Category

    enum CodingKeys: String, CodingKey {
        case id, answer, question, value, airdate
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case categoryID = "category_id"
        case gameID = "game_id"
        case invalidCount = "invalid_count"
        case category
    }
}

// MARK: - Category
struct Category: Codable {
    let id: Int
    let title, createdAt, updatedAt: String
    let cluesCount: Int

    enum CodingKeys: String, CodingKey {
        case id, title
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case cluesCount = "clues_count"
    }
}


// MARK: - Encode/decode helpers

class JSONNull: Codable, Hashable {

    public static func == (lhs: JSONNull, rhs: JSONNull) -> Bool {
        return true
    }

    public var hashValue: Int {
        return 0
    }

    public init() {}

    public required init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if !container.decodeNil() {
            throw DecodingError.typeMismatch(JSONNull.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for JSONNull"))
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encodeNil()
    }
}


/*
 
 [
     {
         "id": 110811,
         "answer": "Australia",
         "question": "The MacDonnell Ranges cross the Red Centre, a sprawling area in this country's Northern Territory",
         "value": 600,
         "airdate": "2012-04-10T12:00:00.000Z",
         "created_at": "2014-02-14T02:40:59.653Z",
         "updated_at": "2014-02-14T02:40:59.653Z",
         "category_id": 15043,
         "game_id": null,
         "invalid_count": null,
         "category": {
             "id": 15043,
             "title": "center field",
             "created_at": "2014-02-14T02:40:59.070Z",
             "updated_at": "2014-02-14T02:40:59.070Z",
             "clues_count": 10
         }
     }
 ]
 
 */
