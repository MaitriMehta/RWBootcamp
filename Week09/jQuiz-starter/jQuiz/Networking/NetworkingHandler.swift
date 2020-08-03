//
//  NetworkingHandler.swift
//  jQuiz
//
//  Created by Jay Strawn on 7/17/20.
//  Copyright © 2020 Jay Strawn. All rights reserved.
//

import Foundation

class Networking {
    static let sharedInstance = Networking()
//    let session = URLSession(configuration: .default)
    var dataTask: URLSessionDataTask?

    enum APIRouter {
       static let baseUrl = "http://www.jservice.io/api"
       case question
       case cluesCategory(Clue)
       
       var urlString: String {
           switch self {
           case .question:
               return APIRouter.baseUrl + "/random"
           case .cluesCategory(let clue):
               return APIRouter.baseUrl + "/clues?category=\(clue.categoryId)&offset=\(clue.category.numOfClues - 4)"
           }
       }
        var url: URL {
            return URL(string: urlString)!
        }
    }

    
    func getRandomCategory(completion: @escaping (Clue?, Error?) -> Void) {
        getRequest(url: APIRouter.question.url) { (response, error) in
            if let clue = response?.last {
                completion(clue, nil)
            } else {
                completion(nil, nil)
            }
        }
    }
    
    func getClues(clue: Clue, completion: @escaping ([Clue], Error?) -> Void) {
        getRequest(url: APIRouter.cluesCategory(clue).url) { (response, error) in
            print(APIRouter.cluesCategory(clue).url)
            if let response = response {
                completion(response, nil)
            } else {
                completion([], nil)
            }
        }
    }
}
