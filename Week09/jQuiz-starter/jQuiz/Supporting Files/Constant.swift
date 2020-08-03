
//
//  Constant.swift
//  jQuiz
//
//  Created by Maitri Mehta on 7/26/20.
//  Copyright © 2020 Jay Strawn. All rights reserved.
//

let logoImageURL = "https://cdn1.edgedatg.com/aws/v2/abc/ABCUpdates/blog/2900129/8484c3386d4378d7c826e3f3690b481b/1600x900-Q90_8484c3386d4378d7c826e3f3690b481b.jpg"
//let baseURL = "h​ttp://www.jservice.io/api/"
let soundFileName = "Jeopardy-theme-song.mp3"

enum State{
    case on
    case off
}

enum Apirouter {
    case randomQuestion
//    case cluesWithCategory(clue)
    case forgotPasswordRequest
}
//https://www.tothenew.com/blog/basics-of-swift-enumeration-for-constructing-rest-web-service-request/
enum APIRouter {
   static let baseUrl = "http://www.jservice.io/api"
   case question
   case cluesCategory(Clue)
   case logoImage
   
   var urlString: String {
       switch self {
       case .question:
           return "/(APIRouter.baseUrl)/random"
       case .cluesCategory(let clue):
           return "/(APIRouter.baseUrl)/clues?category=\(clue.categoryId)&offset=\(clue.category.numOfClues - 4)"
       case .logoImage:
           return logoImageURL
       }
   }
}

/*
 /Clues

 Url: /api/clues
 Options All options are optional:
 value(int): the value of the clue in dollars
 category(int): the id of the category you want to return
 min_date(date): earliest date to show, based on original air date
 max_date(date): latest date to show, based on original air date
 offset(int): offsets the returned clues. Useful in pagination
 /Random

 Url: /api/random
 Options:
 count(int): amount of clues to return, limited to 100 at a time
 /Categories

 Url: /api/categories
 Options:
 count(int): amount of categories to return, limited to 100 at a time
 offset(int): offsets the starting id of categories returned. Useful in pagination.
 /Category

 Url: /api/category
 Options:
 id(int): Required the ID of the category to return.
 /Invalid

 Url: /api/invalid
 Options:
 id(int): Required the ID of the clue to mark as invalid.
 Please mark a clue as invalid when the needed information is not present in the clue. This sometimes happens when clues rely on images or sounds to be answered. When useing jService, you may want to check the invalid_count attribute on clues before using them.
 */
