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
import QuartzCore


class HomeViewController: UIViewController{
  
  //MARK: - IBOutlets
  @IBOutlet weak var view1: UIView!
  @IBOutlet weak var view2: UIView!
  @IBOutlet weak var view3: UIView!
  @IBOutlet weak var view4: UIView!
  @IBOutlet weak var view5: UIView!
  @IBOutlet weak var headingLabel: UILabel!
  @IBOutlet weak var view1TextLabel: UILabel!
  @IBOutlet weak var view2TextLabel: UILabel!
  @IBOutlet weak var view3TextLabel: UILabel!
  @IBOutlet weak var themeSwitch: UISwitch!
  @IBOutlet weak var mostRisingLabel: UILabel!
  @IBOutlet weak var mostFallingLabel: UILabel!
  @IBOutlet weak var mostFallingHeading: UILabel!
  @IBOutlet weak var mostRisingHeading: UILabel!
  
  //MARK: - Initializer
  let cryptoData = DataGenerator.shared.generateData()
  let commaSeperatedCryptoNames: (String, CryptoCurrency) -> String = {
      return ($0 != "") ? "\($0), \($1.name)" : $1.name
  }
  
  enum Currency {
    case all
    case increased
    case decreased
  }
  
  //MARK: - UIViewController Methods
  override func viewDidLoad() {
    super.viewDidLoad()
    setupViewTheme()
    setupLabels()
    setView1Data()
    setView2Data()
    setView3Data()
    setFallingView()
    setRisingView()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    registerForTheme()
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    unregisterForTheme()
  }

  //MARK:- functions - Update UI
  func setupViewTheme() {
    ThemeManager.shared.currentTheme = LightTheme()
  }
  
  func setupLabels() {
    headingLabel.font = Font.header
    view1TextLabel.font = Font.textLabel
    view2TextLabel.font = Font.textLabel
  }
  
  func setView1Data() {//every currency you own.
    guard let cryptoData = cryptoData else { return }
    let allOwenedCurrencyNames = cryptoData.reduce("", commaSeperatedCryptoNames)
    view1TextLabel.text = ":: All Owened Currency :: \n \(allOwenedCurrencyNames)"
  }
  
  func setView2Data() {//every currency which increased from its previous value
    guard let cryptoData = cryptoData else { return }
    let increasedCurrencyNames = cryptoData.filter { $0.currentValue > $0.previousValue }.reduce("", commaSeperatedCryptoNames)
    view2TextLabel.text =  ":: Increased Currency :: \n \(increasedCurrencyNames)"
  }
  
  func setView3Data() {// every currency which decreased from its previous value
    guard let cryptoData = cryptoData else { return }
    let decreasedCurrencyNames = cryptoData.filter { $0.currentValue < $0.previousValue }.reduce("", commaSeperatedCryptoNames)
    view3TextLabel.text = ":: Decreased Currency :: \n \(decreasedCurrencyNames)"
  }
  
  func setFallingView(){
    guard let cryptoData = cryptoData else { return }
    let mostFalling = cryptoData.min { $0.difference < $1.difference }
    mostFallingLabel.text = "\(mostFalling!.difference)"
  }
  
  func setRisingView(){
    guard let cryptoData = cryptoData else { return }
    let mostRising = cryptoData.max { $0.difference < $1.difference }
    mostRisingLabel.text = "\(mostRising!.difference)"
  }
  
  
  func setViewData(Label: UILabel) -> String {
    var textLabel = ""
    guard let cryptoData = cryptoData else { return ""}
    textLabel = cryptoData.reduce("", commaSeperatedCryptoNames)
    return textLabel
  }
  
  //MARK:- IBAction Events
  @IBAction func switchPressed(_ sender: Any) {
    ThemeManager.shared.set(theme: themeSwitch.isOn ? DarkTheme() : LightTheme())
  }
}

//MARK:- Extension
extension HomeViewController: Themeable {

  func registerForTheme() {
    NotificationCenter.default.addObserver(self, selector: #selector(themeChanged), name: type(of: ThemeManager.themeChangeNotification).init("themeChanged"), object: nil)
  }
  
  func unregisterForTheme() {
    NotificationCenter.default.removeObserver(self)
  }
  
  @objc func themeChanged() {
    
    guard let theme = ThemeManager.shared.currentTheme else { return }
    
    let views = [view1, view2, view3, view4, view5]
    _ = views.map { $0?.backgroundColor = theme.widgetBackgroundColor }
    _ = views.map { $0?.layer.borderColor = theme.borderColor.cgColor }
    
    let viewTextLabels = [view1TextLabel, view2TextLabel, view3TextLabel, mostRisingLabel, mostFallingLabel, mostRisingHeading, mostFallingHeading ]
    _ = viewTextLabels.map { $0?.textColor = theme.textColor }
    headingLabel.textColor = theme.textColor
    
    self.view.backgroundColor = ThemeManager.shared.currentTheme?.backgroundColor

  }
}
