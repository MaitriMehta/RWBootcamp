//
//  RESTAPICall.swift
//  jQuiz
//
//  Created by Maitri Mehta on 7/26/20.
//  Copyright © 2020 Jay Strawn. All rights reserved.
//

import UIKit

//let configuration = URLSessionConfiguration.default
//let session = URLSession(configuration: configuration)
//
//class RESTAPICall {
//
//    guard let url = URL(string: "https://itunes.apple.com/search?media=music&entity=song&term=cohen") else {
//      fatalError()
//    }
//
//    let task = session.dataTask(with: url) { data, response, error in
//      guard let httpResponse = response as? HTTPURLResponse,
//            (200..<300).contains(httpResponse.statusCode) else {
//        return
//      }
//      guard let data = data else {
//        return
//      }
//      if let result = String(data: data, encoding: .utf8) {
//        print(result)
//      }
//    }
//    task.resume()
//}
