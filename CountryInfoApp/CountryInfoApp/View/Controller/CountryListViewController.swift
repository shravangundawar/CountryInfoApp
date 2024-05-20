//
//  CountryListViewController.swift
//  CountryInfoApp
//
//  Created by Shravan Gundawar on 18/05/24.
//

import UIKit

class CountryListViewController: UIViewController {
    
    //MARK: IBOutlet
    @IBOutlet weak var dateTimeLabel: UILabel!
    @IBOutlet weak var countrySearchBar: UISearchBar!
    @IBOutlet weak var countryListTableView: UITableView!
    
    //MARK: Property
    var countryListVM: CountryListViewModel?
    let reuseIdentifier = "CountryListTableViewCell"
    var filteredCountries: [CountryDataModel] = []
    var isSearching = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialDependancyInjectionSetup()
        networkAlertHandling()
        getCountryListData()
        dateTimeSetup()
        tableViewSetup()
    }
    
    //MARK: IBaction
    @IBAction func filterButtonTapped(_ sender: Any) {
        showFilterSheet()
    }
    
    //MARK: Methods
    func initialDependancyInjectionSetup() {
        let networkManager = NetworkManager()
        let countryDataRepository = CountryDataRepository(apiClient: networkManager)
        let countryListUseCase = CountryListUseCase(repository: countryDataRepository)
        countryListVM = CountryListViewModel(countryListUseCase: countryListUseCase)
    }
    
    func dateTimeSetup() {
        dateTimeLabel.text = String.formattedDateWithTimeZone()
    }
    
    func tableViewSetup() {
        countryListTableView.register(UINib(nibName: reuseIdentifier, bundle: Bundle.main), forCellReuseIdentifier: reuseIdentifier)
    }
    
    func networkAlertHandling() {
        countryListVM?.networkError = { [weak self] errorMessage in
            DispatchQueue.main.async {
                let alert = UIAlertController(title: AppConstants.UIConstants.noInternetTitle, message: errorMessage, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: AppConstants.UIConstants.ok, style: .default))
                self?.present(alert, animated: true)
            }
        }
    }
    
    func getCountryListData() {
        countryListVM?.fetchCountryList { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let data):
                    debugPrint("Country data: \(data)")
                    self?.filteredCountries = self?.countryListVM?.countryListArray ?? []
                    self?.countryListTableView.reloadData()
                case .failure(let error):
                    debugPrint("Error fetching country data: \(error)")
                }
                //                self?.hideLoader()
            }
        }
    }
    
    func showFilterSheet() {
        let actionSheet = UIAlertController(title: "", message: AppConstants.UIConstants.countryFilterTitle, preferredStyle: .actionSheet)
        //Create Options
        let oneMillion = UIAlertAction(title: AppConstants.UIConstants.oneMillion, style: .default) { [weak self] action in
            self?.updateFilterData(filter: .lessThan1Million)
        }
        
        let fiveMillion = UIAlertAction(title: AppConstants.UIConstants.fiveMillion, style: .default) { [weak self] action in
            self?.updateFilterData(filter: .lessThan5Million)
        }
        
        let tenMillion = UIAlertAction(title: AppConstants.UIConstants.tenMillion, style: .default) { [weak self] action in
            self?.updateFilterData(filter: .lessThan10Million)
        }
        
        let twentyMillion = UIAlertAction(title: AppConstants.UIConstants.twentyMillion, style: .default) { [weak self] action in
            self?.updateFilterData(filter: .lessThan20Million)
        }
        
        let clear = UIAlertAction(title: AppConstants.UIConstants.clear, style: .destructive) { [weak self] action in
            self?.updateFilterData(filter: .removeFilter)
        }
        
        let cancel = UIAlertAction(title: AppConstants.UIConstants.cancel, style: .cancel) { action in
            print("Action Cancel")
        }
        
        //Add actions
        actionSheet.addAction(oneMillion)
        actionSheet.addAction(fiveMillion)
        actionSheet.addAction(tenMillion)
        actionSheet.addAction(twentyMillion)
        actionSheet.addAction(clear)
        actionSheet.addAction(cancel)
        
        present(actionSheet, animated: true)
    }
    
    func updateFilterData(filter: PopulationFilter) {
        filteredCountries.removeAll()
        filteredCountries = countryListVM?.filterCountries(by: filter) ?? []
        countryListTableView.reloadData()
    }
    
}


//MARK: TableView DataSource
extension CountryListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredCountries.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as? CountryListTableViewCell else {
            return UITableViewCell()
        }
        
        let countryInfo = filteredCountries[indexPath.row]
        cell.nameLabel.text = countryInfo.name
        if !countryInfo.capital.isEmpty {
            cell.capitalLabel.text = "Cpital: " + countryInfo.capital
        } else {
            cell.capitalLabel.text = "Cpital: Not Available"
        }
        cell.currencyLabel.text = "Currency: " + countryInfo.currency
        if let population = countryInfo.population {
            cell.populationLabel.text = "Population: " + String(describing: population)
        } else {
            cell.populationLabel.text = "Population: Not Available"
        }
        
        guard let viewModel = countryListVM else { return UITableViewCell() }
        cell.setImage(with: countryInfo, viewModel: viewModel)
        
        return cell
    }
}

//MARK: TableView Delegate
extension CountryListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100.0
    }
}

//MARK: Search Bar Delegate
extension CountryListViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            isSearching = false
            filteredCountries.removeAll()
            filteredCountries = countryListVM?.countryListArray ?? []
        } else {
            isSearching = true
            filteredCountries = countryListVM?.searchCountryByName(searchText: searchText) ?? []
        }
        countryListTableView.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}
