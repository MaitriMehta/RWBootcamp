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

// MARK: - Constants

enum UIUserInterfaceIdiom : Int {
    case unspecified
    case phone // iPhone
    case pad   // iPad
}

let margin: CGFloat = 10
var cellsPerRow = 3

class CompactPokemonViewController: UIViewController {
  
  @IBOutlet weak private var pokemonCollectionView: UICollectionView!
  
  private let pokemons = PokemonGenerator.shared.generatePokemons()
  
  // MARK: - ViewDidLoad
  override func viewDidLoad() {
    super.viewDidLoad()
    setupCollectionView()
  }
  
  // MARK: - Setup CollectionView
  private func setupCollectionView() {
    //cellsPerRow = deviceAndOrientationCheck()
  guard let collectionView = pokemonCollectionView, let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout else { return }
    flowLayout.minimumInteritemSpacing = margin
    flowLayout.minimumLineSpacing = margin
    flowLayout.sectionInset = UIEdgeInsets(top: margin, left: margin, bottom: margin, right: margin)
    collectionView.contentInsetAdjustmentBehavior = .always
    collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
    
    collectionView.delegate = self
    collectionView.dataSource = self

    collectionView.register(
        UINib(nibName: CompactCollectionViewCell.reuseIdentifier, bundle: nil),
        forCellWithReuseIdentifier: CompactCollectionViewCell.reuseIdentifier)
  }
  
}

// MARK: - UICollectionViewDataSource, UICollectionViewDelegate
extension CompactPokemonViewController: UICollectionViewDataSource, UICollectionViewDelegate {
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return pokemons.count
  }
  
  func collectionView(_ collectionView: UICollectionView,
                      cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    
    guard let cell = collectionView.dequeueReusableCell(
      withReuseIdentifier: CompactCollectionViewCell.reuseIdentifier,
                      for: indexPath) as? CompactCollectionViewCell else
      { fatalError("Unable to dequeue cell") }
    cell.populateCellData(with: pokemons[indexPath.row])
    return cell
  }
    
  override func viewWillLayoutSubviews() {
//    cellsPerRow = deviceAndOrientationCheck()
    guard let collectionView = pokemonCollectionView, let flowLayout = pokemonCollectionView.collectionViewLayout as? UICollectionViewFlowLayout else { return }
    let marginsAndInsets = flowLayout.sectionInset.left + flowLayout.sectionInset.right + collectionView.safeAreaInsets.left + collectionView.safeAreaInsets.right + flowLayout.minimumInteritemSpacing * CGFloat(cellsPerRow - 1)
    let itemWidth = ((collectionView.bounds.size.width - marginsAndInsets) / CGFloat(cellsPerRow)).rounded(.down)
    flowLayout.itemSize =  CGSize(width: itemWidth, height: itemWidth)
   
  }

  override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        pokemonCollectionView?.collectionViewLayout.invalidateLayout()
        
        super.viewWillTransition(to: size, with: coordinator)
     }
  
//    func deviceAndOrientationCheck() -> Int{
//      switch UIDevice.current.userInterfaceIdiom {
//         case .phone:
//           cellsPerRow = 3
//         case .pad:
//           cellsPerRow = 3
//         case .unspecified:
//           cellsPerRow = 3
//         case .tv:
//           cellsPerRow = 3
//         case .carPlay:
//           cellsPerRow = 3
//         @unknown default:
//           cellsPerRow = 3
//       }
//      if UIDevice.current.orientation.isLandscape {
//       cellsPerRow = 3
//      } else {
//       cellsPerRow = 3
//      }
//      return cellsPerRow
//    }
  
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout:
      UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
      return 10.0
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout:
      UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
      return 10.0
    }
}


 //MARK: - UICollectionViewDelegateFlowLayout
extension CompactPokemonViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
      let flowLayout = collectionViewLayout as! UICollectionViewFlowLayout
      let totalSpace = flowLayout.sectionInset.left
           + flowLayout.sectionInset.right
           + (flowLayout.minimumInteritemSpacing * CGFloat(cellsPerRow - 1))
      let size = Int((collectionView.bounds.width - totalSpace) / CGFloat(cellsPerRow))
      return CGSize(width: size, height: size)
    }
}


extension UICollectionView {
}
