//
//  SandwichViewController.swift
//  SandwichSaturation
//
//  Created by Jeff Rames on 7/3/20.
//  Copyright © 2020 Jeff Rames. All rights reserved.
//

import UIKit
import CoreData

protocol SandwichDataSource {
  func saveSandwich(_: SandwichData)
}

class SandwichViewController: UITableViewController, SandwichDataSource {
//  var selectedFilterIndex : Int
    
  // MARK: - Variables
  let searchController = UISearchController(searchResultsController: nil)
  var sandwiches = [SandwichData]()
  var filteredSandwiches = [SandwichData]()
  let selectedScopeKey = "selectedFilterIndex"
  let appDelegate = AppDelegate.shared
  let defaults = UserDefaults.standard
  let jsonFileName = "sandwiches"
    
  private let context = AppDelegate.shared.persistentContainer.viewContext
  private var fetchedResultsController: NSFetchedResultsController<SandwichModel>!
//  var searchString: String = ""
    var serachFormat = ""
  //let seaachFormat = "sauceAmountString == %@"
  
  var selectedFilterIndex: Int {
    get {
      return defaults.integer(forKey: selectedScopeKey)
    }
  }
    
  required init?(coder: NSCoder) {
    super.init(coder: coder)
    //readJSON()
      loadSandwiches()
  }
    
  // MARK: - ViewController LifeCycle
  override func viewDidLoad() {
    super.viewDidLoad()
        
    let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(presentAddView(_:)))
    navigationItem.rightBarButtonItem = addButton
    navigationItem.leftBarButtonItem = editButtonItem

    // Setup Search Controller
    searchController.searchResultsUpdater = self
    searchController.obscuresBackgroundDuringPresentation = false
    searchController.searchBar.placeholder = "Filter Sandwiches"
    navigationItem.searchController = searchController
    definesPresentationContext = true
    searchController.searchBar.scopeButtonTitles = SauceAmount.allCases.map { $0.rawValue }
    searchController.searchBar.delegate = self
    
    let selectedFilterIndex = UserDefaults.standard.integer(forKey: selectedScopeKey)
    print(selectedFilterIndex)
    searchController.searchBar.selectedScopeButtonIndex = selectedFilterIndex
    
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    searchController.searchBar.selectedScopeButtonIndex = selectedFilterIndex
  }

  // MARK: - Parse JSON
  func readJSON(){
   
  }
    
  // MARK: - Methods to filter and load data
  func loadSauceAmounts() {
    do {
      let request = SauceAmountModel.fetchRequest() as NSFetchRequest<SauceAmountModel>
      let results = try context.fetch(request)
      if results.count == 0 {
        for sauceAmount in SauceAmount.allCases {
          if sauceAmount == .any { continue }
            let entity = SauceAmountModel(entity: SauceAmountModel.entity(), insertInto: context)
              entity.sauceAmountString = sauceAmount.rawValue
             }
             appDelegate.saveContext()
           }
         }
         catch let error {
            print("Error: \(error.localizedDescription)")
         }
    }

    func loadSandwiches() {
       loadSauceAmounts()
       guard let sandwichesJSONURL = Bundle.main.url(forResource: "sandwiches", withExtension: "json")else { return }

       let decoder = JSONDecoder()
       do {
       let sandwichData = try Data(contentsOf: sandwichesJSONURL)
         sandwiches = try decoder.decode([SandwichData].self, from: sandwichData)
       } catch let error {
         print(error)
       }
       do {
         let request = SandwichModel.fetchRequest() as NSFetchRequest<SandwichModel>
         let results = try context.fetch(request)

         if results.count == 0 {
           let sandwichesData = try Data(contentsOf: sandwichesJSONURL)
           sandwiches = try decoder.decode([SandwichData].self, from: sandwichesData)
           for sandwich in sandwiches {
             addSandwich(sandwich)
           }
           appDelegate.saveContext()
         }
         reload(sauceAmount: ( selectedFilterIndex == 1 ) ? SauceAmount(rawValue: SauceAmount.none.rawValue) : SauceAmount(rawValue: SauceAmount.tooMuch.rawValue))
         }
         catch let error {
           print("Error: \(error)")
         }
  }
    
    func addSandwich(_ sandwich: SandwichData) {
        let entity = SandwichModel(entity: SandwichModel.entity(), insertInto: context)
        entity.imageName = sandwich.imageName
        entity.name = sandwich.name
        if let sauceAmount = fetchSauceAmountModel(by: sandwich.sauceAmount) {
            entity.sauceAmount = sauceAmount
        }
    }

    private func getPredicate(for sauceAmount: SauceAmount) -> NSPredicate {
      serachFormat = "sauceAmount.sauceAmountString == %@"
      let none = NSPredicate(format: serachFormat, SauceAmount.none.rawValue)
      let tooMuch = NSPredicate(format: serachFormat, SauceAmount.none.rawValue)
      switch sauceAmount {
        case .any:
          return NSCompoundPredicate(orPredicateWithSubpredicates: [none, tooMuch])
        case .none:
          return none
        case .tooMuch:
          return tooMuch
        }
    }
    
  private func reload(sauceAmount: SauceAmount? = nil) {
      serachFormat = "name CONTAINS[cd] %@"
      let request = SandwichModel.fetchRequest() as NSFetchRequest<SandwichModel>
      var predicates: [NSPredicate] = []
      if let sauce = sauceAmount {
          predicates.append(getPredicate(for: sauce))
      }
      predicates.append(NSPredicate(format: serachFormat, ""))
      request.predicate = (predicates.count == 1) ? predicates.first : NSCompoundPredicate(andPredicateWithSubpredicates: predicates)
      let sort = NSSortDescriptor(key: #keyPath(SandwichModel.name), ascending: true, selector: #selector(NSString.caseInsensitiveCompare(_:)))
      request.sortDescriptors = [sort]
      do {
          fetchedResultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
          fetchedResultsController.delegate = self
          try fetchedResultsController.performFetch()
      } catch let error as NSError {
          print("Could not fetch. \(error), \(error.userInfo)")
      }
  }

  func fetchSauceAmountModel(by sauceAmount: SauceAmount) -> SauceAmountModel? {
    serachFormat = "sauceAmountString == %@"
    do {
      let request = SauceAmountModel.fetchRequest() as NSFetchRequest<SauceAmountModel>
      request.predicate = NSPredicate(format: serachFormat, sauceAmount.rawValue)

      let results = try context.fetch(request)
      if let result = results.first {
        return result
      }
      else {
        return nil
      }
    }
    catch let error {
        print(error.localizedDescription)
    }
    return nil
  }


  private func refresh() {
    self.tableView.reloadData()
  }

  func parseSandwiches() {
    let url = Bundle.main.url(forResource:jsonFileName, withExtension: "json")!
    do{
      let jsonData = try Data(contentsOf: url)
      self.sandwiches = try! JSONDecoder().decode([SandwichData].self, from: jsonData)
        print(self.sandwiches)
      }catch let error {
        print(error.localizedDescription)
      }
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
     refresh()
    }
    

    
  func saveSandwich(_ sandwich: SandwichData) {
//    sandwiches.append(sandwich)
//    tableView.reloadData()
    addSandwich(sandwich)
    appDelegate.saveContext()
    let sauceAmount = SauceAmount(rawValue: searchController.searchBar.scopeButtonTitles![selectedFilterIndex])
    reload(sauceAmount: sauceAmount)
}
    
  @objc
  func presentAddView(_ sender: Any) {
    performSegue(withIdentifier: "AddSandwichSegue", sender: self)
  }


    
  // MARK: - Search Controller
  var isSearchBarEmpty: Bool {
    return searchController.searchBar.text?.isEmpty ?? true
  }
  
  func filterContentForSearchText(_ searchText: String, sauceAmount: SauceAmount? = nil) {
    
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
    let sandwich = isFiltering ? filteredSandwiches[indexPath.row] : sandwiches[indexPath.row] //fetchedResultsController.object(at: indexPath)
    cell.thumbnail.image = UIImage.init(imageLiteralResourceName: sandwich.imageName)
    cell.nameLabel.text = sandwich.name
    cell.sauceLabel.text = sandwich.sauceAmount.description //sandwich.sauceAmount!.sauceAmount.rawValue
    return cell
  }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let entity = fetchedResultsController.object(at: indexPath)
            context.delete(entity)
            appDelegate.saveContext()
            let sauceAmount = SauceAmount(rawValue: searchController.searchBar.scopeButtonTitles![selectedFilterIndex])
            reload(sauceAmount: sauceAmount)
            tableView.deleteRows(at: [indexPath], with: .right)
        }
    }
}

// MARK: - UISearchResultsUpdating
extension SandwichViewController: UISearchResultsUpdating {
  func updateSearchResults(for searchController: UISearchController) {
    let searchBar = searchController.searchBar
    let sauceAmount = SauceAmount(rawValue:searchBar.scopeButtonTitles![searchBar.selectedScopeButtonIndex])
//    searchString = searchBar.text!
    filterContentForSearchText(searchBar.text!, sauceAmount: sauceAmount)
  }
}

// MARK: - UISearchBarDelegate
extension SandwichViewController: UISearchBarDelegate {
  func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
    let sauceAmount = SauceAmount(rawValue: searchBar.scopeButtonTitles![selectedScope])
    UserDefaults.standard.set(selectedScope, forKey: selectedScopeKey)
    filterContentForSearchText(searchBar.text!, sauceAmount: sauceAmount)
  }
}

// MARK: - NSFetchedResultsControllerDelegate
extension SandwichViewController: NSFetchedResultsControllerDelegate {
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
      let index = indexPath ?? (newIndexPath ?? nil)
      guard let rowIndex = index else {
        return
      }
      if type == .insert {
        tableView.insertRows(at: [rowIndex], with: .automatic)
      }
    }
  }
