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
  let serachFormat1 = "sauceAmount.sauceAmountString == %@"
  let serachFormat2 = "name CONTAINS[cd] %@"
  let seaachFormat3 = "sauceAmountString == %@"
    
  var selectedFilterIndex: Int {
    get {
      return defaults.integer(forKey: selectedScopeKey)
    }
  }
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
    loadSandwiches()
  }
  
    // MARK: - ViewController Life Cycle
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
    }
    
    override func viewWillAppear(_ animated: Bool) {
      super.viewWillAppear(animated)
      searchController.searchBar.selectedScopeButtonIndex = selectedFilterIndex
      showEditButton()
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
            print("Error: \(error)")
        }
    }
    
    func loadSandwiches() {
      loadSauceAmounts()
      guard let sandwichesJSONURL = Bundle.main.url(forResource: "sandwiches", withExtension: "json")else {
        return
      }
        
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
      switch selectedFilterIndex {
        case 1:
          let sauceAmount = SauceAmount(rawValue: SauceAmount.none.rawValue)
          reload(query: searchString, sauceAmount: sauceAmount)
        case 2:
          let sauceAmount = SauceAmount(rawValue: SauceAmount.tooMuch.rawValue)
          reload(query: searchString, sauceAmount: sauceAmount)
        default:
          reload()
      }
    }
    catch let error {
      print("Error: \(error)")
    }
  }
    
    private func getPredicate(for sauceAmount: SauceAmount) -> NSPredicate {
      let none = NSPredicate(format: serachFormat1, SauceAmount.none.rawValue)
      let tooMuch = NSPredicate(format: serachFormat1, SauceAmount.none.rawValue)
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
            predicates.append(NSPredicate(format: serachFormat2, query))
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
    
    func fetchSauceAmountModel(by sauceAmount: SauceAmount) -> SauceAmountModel? {
      do {
        let request = SauceAmountModel.fetchRequest() as NSFetchRequest<SauceAmountModel>
        request.predicate = NSPredicate(format: seaachFormat3, sauceAmount.rawValue)
        
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
    

    func addSandwich(_ sandwich: SandwichData) {
        let entity = SandwichModel(entity: SandwichModel.entity(), insertInto: context)
        entity.imageName = sandwich.imageName
        entity.name = sandwich.name
        if let sauceAmount = fetchSauceAmountModel(by: sandwich.sauceAmount) {
            entity.sauceAmount = sauceAmount
        }
    }
    
    func saveSandwich(_ sandwich: SandwichData) {
        addSandwich(sandwich)
        appDelegate.saveContext()
        let sauceAmount = SauceAmount(rawValue: searchController.searchBar.scopeButtonTitles![selectedFilterIndex])
        reload(query: searchString, sauceAmount: sauceAmount)
    }
    
    @objc
    func presentAddView(_ sender: Any) {
        performSegue(withIdentifier: "AddSandwichSegue", sender: self)
    }
    
    // MARK: - Edit Button
    private func showEditButton() {
        guard let objs = fetchedResultsController.fetchedObjects else {
            return
        }
        if objs.count > 0 {
            navigationItem.leftBarButtonItem = editButtonItem
        }
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
            let sauceAmount = SauceAmount(rawValue: searchController.searchBar.scopeButtonTitles![selectedFilterIndex])
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
        defaults.set(selectedScope, forKey: selectedScopeKey)
        let sauceAmount = SauceAmount(rawValue: searchBar.scopeButtonTitles![selectedScope])
        filterContentForSearchText(searchBar.text!, sauceAmount: sauceAmount)
    }
}
