//
//  QuestionCodable.swift
//  jQuiz
//
//  Created by Jay Strawn on 7/17/20.
//  Copyright © 2020 Jay Strawn. All rights reserved.
//

import Foundation

// MARK: - Clue
struct Clue: Decodable {
    var id: Int
    var answer: String
    var question: String
    var value: Int?
    var categoryId: Int
    var category: Category
    
    enum CodingKeys: String, CodingKey {
        case id
        case answer
        case question
        case value
        case categoryId = "category_id"
        case category
    }
}

// MARK: - Category
struct Category: Decodable {
    var id, numOfClues: Int
    var title: String
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case numOfClues = "clues_count"
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
