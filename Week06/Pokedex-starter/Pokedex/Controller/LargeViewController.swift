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

class LargeViewController: UIViewController {
  
  // MARK: - Constants
  enum Section {
     case main
   }
  
  // MARK: IBOutlet
   @IBOutlet weak private var largePokemonCollectionView: UICollectionView!
   
   private let pokemons = PokemonGenerator.shared.generatePokemons()
   private var dataSource: UICollectionViewDiffableDataSource<Section, Pokemon>!
   
   override func viewDidLoad() {
     super.viewDidLoad()
     largePokemonCollectionView.register(UINib(nibName: LargeCollectionViewCell.reuseIdentifier, bundle: nil),
                                         forCellWithReuseIdentifier: LargeCollectionViewCell.reuseIdentifier)
     largePokemonCollectionView.collectionViewLayout = configureLayout()
     configureDataSource()
   }
   
  // MARK: - UICollectionViewCompositionalLayout

   func configureLayout() -> UICollectionViewCompositionalLayout {
     viewRespectsSystemMinimumLayoutMargins = false
     let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                          heightDimension: .fractionalHeight(1.0))
     let item = NSCollectionLayoutItem(layoutSize: itemSize)
     item.contentInsets = NSDirectionalEdgeInsets(top: view.bounds.height * 0.1, leading: 16, bottom: 0, trailing: 8)
     
     let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.8), heightDimension: .fractionalHeight(0.9))
     let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
     
     let section = NSCollectionLayoutSection(group: group)
     section.orthogonalScrollingBehavior = .continuousGroupLeadingBoundary
     return UICollectionViewCompositionalLayout(section: section)
  }
   
  // MARK: - ConfigureDataSource

   func configureDataSource() {
     dataSource = UICollectionViewDiffableDataSource<Section, Pokemon>(collectionView: largePokemonCollectionView, cellProvider: { (collectionView, indexPath, pokemon) -> UICollectionViewCell? in
         
       guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: LargeCollectionViewCell.reuseIdentifier, for: indexPath) as? LargeCollectionViewCell else {
             fatalError("Unable to dequeue cell")
       }
       cell.populateView(with: pokemon)
       return cell
     })
     var initialSnapshot = NSDiffableDataSourceSnapshot<Section, Pokemon>()
     initialSnapshot.appendSections([.main])
     initialSnapshot.appendItems(pokemons)
     
     dataSource.apply(initialSnapshot, animatingDifferences: false)
   }
   
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
      let flowLayout = collectionViewLayout as! UICollectionViewFlowLayout
           let totalSpace = flowLayout.sectionInset.left + flowLayout.sectionInset.right
           let size = Int((collectionView.bounds.width - totalSpace) / CGFloat(cellsPerRow))
           return CGSize(width: size, height: size)
  }

  override func viewWillLayoutSubviews() {
    super.viewWillLayoutSubviews()
  }
}
