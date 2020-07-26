//
//  SandwichViewController.swift
//  SandwichSaturation
//
//  Created by Jeff Rames on 7/3/20.
//  Copyright © 2020 Jeff Rames. All rights reserved.
//

import UIKit
protocol SandwichDataSource {
  func saveSandwich(_: SandwichData)
}

class SandwichViewController: UITableViewController, SandwichDataSource {
//  var selectedFilterIndex : Int
  let searchController = UISearchController(searchResultsController: nil)
  var sandwiches = [SandwichData]()
  var filteredSandwiches = [SandwichData]()

  required init?(coder: NSCoder) {
    super.init(coder: coder)
    readJSON()
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
        
    let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(presentAddView(_:)))
    navigationItem.rightBarButtonItem = addButton
    
    // Setup Search Controller
    searchController.searchResultsUpdater = self
    searchController.obscuresBackgroundDuringPresentation = false
    searchController.searchBar.placeholder = "Filter Sandwiches"
    navigationItem.searchController = searchController
    definesPresentationContext = true
    searchController.searchBar.scopeButtonTitles = SauceAmount.allCases.map { $0.rawValue }
    searchController.searchBar.delegate = self
    
    let selectedFilterIndex = UserDefaults.standard.integer(forKey: "selectedFilterIndex")
    print(selectedFilterIndex)
    searchController.searchBar.selectedScopeButtonIndex = selectedFilterIndex

  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
  }
    
  private func refresh() {
    self.tableView.reloadData()
  }

  func parseSandwiches() {
    let url = Bundle.main.url(forResource:"sandwiches", withExtension: "json")!
        do{
          let jsonData = try Data(contentsOf: url)
          self.sandwiches = try! JSONDecoder().decode([SandwichData].self, from: jsonData)
            print(self.sandwiches)
        }catch let error {
          print(error.localizedDescription)
        }
        self.tableView.reloadData()
        
    }
    
    func decodeData(pathName: URL){
        do{
            let jsonData = try Data(contentsOf: pathName)
            let decoder = JSONDecoder()
            sandwiches = try decoder.decode([SandwichData].self, from: jsonData)
        } catch {}
    }
    
    func loadFile(mainPath: URL, subPath: URL){
        let fm = FileManager.default
        if fm.fileExists(atPath: subPath.path){
            decodeData(pathName: subPath)
            
            if sandwiches.isEmpty{
                decodeData(pathName: mainPath)
            }
            
        }else{
            decodeData(pathName: mainPath)
        }
        
//        self.tableView.reloadData()
    }
    
    func readJSON(){
        let fm = FileManager.default

        guard let mainUrl = Bundle.main.url(forResource: "sandwiches", withExtension: "json") else { return }
                
        do {
            let documentDirectory = try fm.url(for: .documentDirectory, in: .userDomainMask, appropriateFor:nil, create:false)
            let subUrl = documentDirectory.appendingPathComponent("sandwiches.json")
            loadFile(mainPath: mainUrl, subPath: subUrl)
        } catch {
            print(error)
        }
    }


  func saveSandwich(_ sandwich: SandwichData) {
    sandwiches.append(sandwich)
    tableView.reloadData()
  }

  @objc
  func presentAddView(_ sender: Any) {
    performSegue(withIdentifier: "AddSandwichSegue", sender: self)
  }
  
  // MARK: - Search Controller
  var isSearchBarEmpty: Bool {
    return searchController.searchBar.text?.isEmpty ?? true
  }
  
  func filterContentForSearchText(_ searchText: String,
                                  sauceAmount: SauceAmount? = nil) {
    
    filteredSandwiches = sandwiches.filter { (sandwhich: SandwichData) -> Bool in
      let doesSauceAmountMatch = sauceAmount == .any || sandwhich.sauceAmount == sauceAmount

      if isSearchBarEmpty {
        return doesSauceAmountMatch
      } else {
        return doesSauceAmountMatch && sandwhich.name.lowercased()
          .contains(searchText.lowercased())
      }
    }
    
    tableView.reloadData()
  }
  
  var isFiltering: Bool {
    let searchBarScopeIsFiltering = searchController.searchBar.selectedScopeButtonIndex != 0
    return searchController.isActive && (!isSearchBarEmpty || searchBarScopeIsFiltering)
  }
  
  // MARK: - Table View
  override func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }

  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return isFiltering ? filteredSandwiches.count : sandwiches.count
  }

  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: "sandwichCell", for: indexPath) as? SandwichCell
      else { return UITableViewCell() }
    
    let sandwich = isFiltering ?
      filteredSandwiches[indexPath.row] :
      sandwiches[indexPath.row]

    cell.thumbnail.image = UIImage.init(imageLiteralResourceName: sandwich.imageName)
    cell.nameLabel.text = sandwich.name
    cell.sauceLabel.text = sandwich.sauceAmount.description

    return cell
  }
}

// MARK: - UISearchResultsUpdating
extension SandwichViewController: UISearchResultsUpdating {
  func updateSearchResults(for searchController: UISearchController) {
    let searchBar = searchController.searchBar
    let sauceAmount = SauceAmount(rawValue:
      searchBar.scopeButtonTitles![searchBar.selectedScopeButtonIndex])

    filterContentForSearchText(searchBar.text!, sauceAmount: sauceAmount)
  }
}

// MARK: - UISearchBarDelegate
extension SandwichViewController: UISearchBarDelegate {
  func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
    let sauceAmount = SauceAmount(rawValue: searchBar.scopeButtonTitles![selectedScope])
    UserDefaults.standard.set(selectedScope, forKey: "selectedFilterIndex")
    filterContentForSearchText(searchBar.text!, sauceAmount: sauceAmount)
  }
}

