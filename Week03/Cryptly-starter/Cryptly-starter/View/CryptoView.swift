/// Copyright (c) 2020 Razeware LLC
/// 
/// Permission is hereby granted, free of charge, to any person obtaining a copy
/// of this software and associated documentation files (the "Software"), to deal
/// in the Software without restriction, including without limitation the rights
/// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
/// copies of the Software, and to permit persons to whom the Software is
/// furnished to do so, subject to the following conditions:
/// 
/// The above copyright notice and this permission notice shall be included in
/// all copies or substantial portions of the Software.
/// 
/// Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
/// distribute, sublicense, create a derivative work, and/or sell copies of the
/// Software in any work that is designed, intended, or marketed for pedagogical or
/// instructional purposes related to programming, coding, application development,
/// or information technology.  Permission for such use, copying, modification,
/// merger, publication, distribution, sublicensing, creation of derivative works,
/// or sale is expressly withheld.
/// 
/// This project and source code may use libraries or frameworks that are
/// released under various Open-Source licenses. Use of those libraries and
/// frameworks are governed by their own individual licenses.
///
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
/// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
/// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
/// THE SOFTWARE.

import UIKit

protocol Roundable: UIView {
  var cornerRadius: CGFloat { get }
  func round()
}

extension Roundable where Self: CryptoView {
  var cornerRadius: CGFloat {
    return layer.bounds.height / 2 //Default value
  }
  
  func round() {
    layer.cornerRadius = cornerRadius
  }
}

extension CryptoView: Roundable { }

class CryptoView: UIView {
  
  //initWithCode to init view from xib or storyboard
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    setupView(cornerRadius: cornerRadius)
  }
  
  //common func to init our view
  private func setupView(cornerRadius : CGFloat) {
    backgroundColor = .systemGray6
    layer.borderColor = UIColor.lightGray.cgColor
    layer.borderWidth = 1.0
    layer.shadowColor = UIColor.black.withAlphaComponent(0.2).cgColor
    layer.shadowOffset = CGSize(width: 0, height: 2)
    layer.shadowRadius = 4
    layer.shadowOpacity = 0.8
    //layer.cornerRadius = 10
    round()
  }
  
  func initSubviews() {
    //Add Label
  }
}

