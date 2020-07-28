//
//  RESTAPICall.swift
//  jQuiz
//
//  Created by Maitri Mehta on 7/26/20.
//  Copyright © 2020 Jay Strawn. All rights reserved.
//

import UIKit

func getRequest(url: URL, completion: @escaping([Clue]?, Error?) -> Void) {
      let task = URLSession.shared.dataTask(with: url) { data, response, error in
          
          guard let data = data else {
              DispatchQueue.main.async {
                  completion(nil, error)
              }
              return
          }
          let decoder = JSONDecoder()
          do {
              let responseObject = try decoder.decode([Clue].self, from: data)
              DispatchQueue.main.async {
                  completion(responseObject, nil)
              }
          } catch {
              print(error)
              DispatchQueue.main.async {
                  completion(nil, error)
              }
          }
      }
      task.resume()
  }
