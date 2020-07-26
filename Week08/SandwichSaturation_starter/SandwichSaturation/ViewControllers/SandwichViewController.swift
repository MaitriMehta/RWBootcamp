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
  // MARK: - appDelegate variables
  let appDelegate = AppDelegate.shared
  private let context = AppDelegate.shared.persistentContainer.viewContext
  private var fetchedResultsController: NSFetchedResultsController<SandwichModel>!
  let searchController = UISearchController(searchResultsController: nil)
  var sandwiches = [SandwichData]()
  var filteredSandwiches = [SandwichData]()
  let defaults = UserDefaults.standard
  let selectedScopeKey = "selectedFilterIndex"
  var searchString: String = ""
  var selectedScopeIndex: Int {
    get {
      return defaults.integer(forKey: selectedScopeKey)
    }
  }

  required init?(coder: NSCoder) {
    super.init(coder: coder)
    ////    readJSON()
    loadSandwiches()
  }
    
    // MARK: - ViewController Life Cycle
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
      searchController.searchBar.selectedScopeButtonIndex = selectedFilterIndex
    }

    override func viewWillAppear(_ animated: Bool) {
      super.viewWillAppear(animated)
      searchController.searchBar.selectedScopeButtonIndex = selectedScopeIndex
    }

    // MARK: - Parse JSON
//    func readJSON(){
//      let fm = FileManager.default
//      guard let mainUrl = Bundle.main.url(forResource: "sandwiches", withExtension: "json") else { return }
//      do {
//        let documentDirectory = try fm.url(for: .documentDirectory, in: .userDomainMask, appropriateFor:nil, create:false)
//        let subUrl = documentDirectory.appendingPathComponent("sandwiches.json")
//        loadFile(mainPath: mainUrl, subPath: subUrl)
//      } catch {
//        print(error)
//      }
//    }
//
//    func decodeData(pathName: URL){
//      do{
//        let jsonData = try Data(contentsOf: pathName)
//        let decoder = JSONDecoder()
//        sandwiches = try decoder.decode([SandwichData].self, from: jsonData)
//      } catch {}
//    }
//
//    func loadFile(mainPath: URL, subPath: URL){
//      let fm = FileManager.default
//      if fm.fileExists(atPath: subPath.path){
//        decodeData(pathName: subPath)
//        if sandwiches.isEmpty{
//          decodeData(pathName: mainPath)
//        }
//      }else{
//        decodeData(pathName: mainPath)
//      }
//      self.tableView.reloadData()
//    }

    func loadSauceAmounts() {
      do {
        let request = SauceAmountModel.fetchRequest() as NSFetchRequest<SauceAmountModel>
        let results = try context.fetch(request)
          if results.count == 0 {
            for sauceAmount in SauceAmount.allCases {
              if sauceAmount == .any { continue }
                addSauceAmount(sauceAmount)
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
//        readJSON()
      guard let sandwichesJSONURL = Bundle.main.url(forResource: "sandwiches", withExtension: "json") else { return }
      let decoder = JSONDecoder()
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
        
        switch selectedScopeIndex {
            case 1:
              let sauceAmount = SauceAmount(rawValue: SauceAmount.none.rawValue)
              reload(query: "", sauceAmount: sauceAmount)
            case 2:
              let sauceAmount = SauceAmount(rawValue: SauceAmount.tooMuch.rawValue)
              reload(query: "", sauceAmount: sauceAmount)
            default:
              reload()
            }
        } catch let error {
            print("Error: \(error.localizedDescription)")
        }
    }

    private func getPredicate(for sauceAmount: SauceAmount) -> NSPredicate {
      let serachFormat = "sauceAmount.sauceAmountString == %@"
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

    private func reload(query: String = "", sauceAmount: SauceAmount? = nil) {
        let request = SandwichModel.fetchRequest() as NSFetchRequest<SandwichModel>
        var predicates: [NSPredicate] = []
        if let sauce = sauceAmount {
            predicates.append(getPredicate(for: sauce))
        }

        if !query.isEmpty {
            predicates.append(NSPredicate(format: "name CONTAINS[cd] %@", query))
        }
        switch predicates.count {
          case 1:
            request.predicate = predicates.first
          case 2:
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: predicates)
          default:
            print("Filtered data not available.")
        }

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

    func sauceAmountModel(by sauceAmount: SauceAmount) -> SauceAmountModel? {
      do {
        let request = SauceAmountModel.fetchRequest() as NSFetchRequest<SauceAmountModel>
        request.predicate = NSPredicate(format: "sauceAmountString == %@", sauceAmount.rawValue)
        let results = try context.fetch(request)
        if let result = results.first {
          return result
        }
        else {
          return nil
        }
      }
      catch let error {
        print(error)
      }
      return nil
    }

    func addSauceAmount(_ sauceAmount: SauceAmount) {
        let entity = SauceAmountModel(entity: SauceAmountModel.entity(), insertInto: context)
        entity.sauceAmountString = sauceAmount.rawValue
    }

    func addSandwich(_ sandwich: SandwichData) {
        let entity = SandwichModel(entity: SandwichModel.entity(), insertInto: context)
        entity.imageName = sandwich.imageName
        entity.name = sandwich.name
        if let sauceAmount = sauceAmountModel(by: sandwich.sauceAmount) {
            entity.sauceAmount = sauceAmount
        }
    }

    func saveSandwich(_ sandwich: SandwichData) {
        ////    sandwiches.append(sandwich)
        ////    tableView.reloadData()
        addSandwich(sandwich)
        appDelegate.saveContext()
        let sauceAmount = SauceAmount(rawValue: searchController.searchBar.scopeButtonTitles![selectedScopeIndex])
        reload(query: searchString, sauceAmount: sauceAmount)
    }

    @objc
    func presentAddView(_ sender: Any) {
        performSegue(withIdentifier: "AddSandwichSegue", sender: self)
    }
    
    // MARK: - Search Controller
    var isSearchBarEmpty: Bool {
      return searchController.searchBar.text?.isEmpty ?? true
    }

    var isFiltering: Bool {
      let searchBarScopeIsFiltering = searchController.searchBar.selectedScopeButtonIndex != 0
      return searchController.isActive && (!isSearchBarEmpty || searchBarScopeIsFiltering)
    }

    func filterContentForSearchText(_ searchText: String, sauceAmount: SauceAmount? = nil) {
        reload(query: searchText, sauceAmount: sauceAmount)
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

    // MARK: - Table View
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchedResultsController.fetchedObjects?.count ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "sandwichCell", for: indexPath) as? SandwichCell
            else { return UITableViewCell() }

        let sandwich = fetchedResultsController.object(at: indexPath)

        cell.thumbnail.image = UIImage.init(imageLiteralResourceName: sandwich.imageName ?? "")
        cell.nameLabel.text = sandwich.name
        cell.sauceLabel.text = sandwich.sauceAmount!.sauceAmount.rawValue

        return cell
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let entity = fetchedResultsController.object(at: indexPath)
            context.delete(entity)
            appDelegate.saveContext()
            let sauceAmount = SauceAmount(rawValue: searchController.searchBar.scopeButtonTitles![selectedScopeIndex])
            reload(query: searchString, sauceAmount: sauceAmount)
            tableView.deleteRows(at: [indexPath], with: .right)
        }
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

// MARK: - UISearchResultsUpdating
extension SandwichViewController: UISearchResultsUpdating {
  func updateSearchResults(for searchController: UISearchController) {
    let searchBar = searchController.searchBar
    let sauceAmount = SauceAmount(rawValue:searchBar.scopeButtonTitles![searchBar.selectedScopeButtonIndex])
    searchString = searchBar.text!
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
//  func parseSandwiches() {
//    let url = Bundle.main.url(forResource:jsonFileName, withExtension: "json")!
//    do{
//      let jsonData = try Data(contentsOf: url)
//      self.sandwiches = try! JSONDecoder().decode([SandwichData].self, from: jsonData)
//        print(self.sandwiches)
//      }catch let error {
//        print(error.localizedDescription)
//      }
//    }
//
