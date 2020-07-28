//
//  ImageCache.swift
//  jQuiz
//
//  Created by Jay Strawn on 7/19/20.
//  Copyright © 2020 Jay Strawn. All rights reserved.
//

import UIKit


extension UIImageView {
    func load(url: URL) {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
    }
}
