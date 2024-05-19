//
//  CountryListViewController.swift
//  CountryInfoApp
//
//  Created by Shravan Gundawar on 18/05/24.
//

import UIKit

class CountryListViewController: UIViewController {

    var countryListVM: CountryListViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initialDependancyInjectionSetup()
        getCountryListData()
    }
    
    func initialDependancyInjectionSetup() {
        let networkManager = NetworkManager()
        let countryDataRepository = CountryDataRepository(apiClient: networkManager)
        let countryListUseCase = CountryListUseCase(repository: countryDataRepository)
        countryListVM = CountryListViewModel(countryListUseCase: countryListUseCase)
    }
    
    func getCountryListData() {
        countryListVM?.fetchCountryList { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let data):
                    debugPrint("Country data: \(data)")

//                    self?.userListTableView.reloadData()
                case .failure(let error):
                    debugPrint("Error fetching country data: \(error)")
                }
//                self?.hideLoader()
            }
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
