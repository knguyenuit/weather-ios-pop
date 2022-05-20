//
//  HomeViewController.swift
//  WeatherApp
//
//  Created by Nguyen Tran on 17/05/2022.
//

import UIKit

class HomeViewController: BaseVC, Navigatable {
    // MARK: - Outlets
    @IBOutlet private weak var searchBar: UISearchBar!
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var emptyView: UIView!
    
    // MARK: - Properties
    private var viewModel: HomeViewModel = HomeViewModel(api: API())
    private var weatherLocations: [SearchWeatherCityModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        bindingData()
        viewModel.checkDataLocal()
    }

    // MARK: - Methods
    private func setup() {
        navigationItem.title = "Home"
        searchBar.delegate = self
        
        tableView.registerNib(aClass: HomeCityCell.self)
        tableView.separatorStyle = .none
        tableView.tableFooterView = UIView()
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    private func clear() {
        self.emptyView.isHidden = false
        self.weatherLocations = []
        self.tableView.reloadData()
    }
}

// MARK: - Binding Data
private extension HomeViewController {
    func bindingData() {
        viewModel.onGetListSearchSuccess = { models in
            self.emptyView.isHidden = !models.isEmpty
            self.weatherLocations = models
            self.tableView.reloadData()
        }
        
        viewModel.onGetListSearchFail = { errorMessage in
            print("errorMessage === \(errorMessage)")
            self.clear()
        }
    }
}

// MARK: - UITableView Datasource + Delegate
extension HomeViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return weatherLocations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard indexPath.row < weatherLocations.count else { return UITableViewCell() }
        let cell = tableView.dequeue(aClass: HomeCityCell.self)
        cell.configure(model: weatherLocations[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard indexPath.row < weatherLocations.count else { return }
        var localWeather = DataManager.shared.getWeatherLocations()
        if localWeather.isEmpty {
            localWeather.append(weatherLocations[indexPath.row])
        } else {
            localWeather.insert(weatherLocations[indexPath.row], at: 0)
        }
        DataManager.shared.saveWeatherLocations(localWeather)
        push(to: LocalWeatherViewController(city: weatherLocations[indexPath.row].getAreaName()), animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}

// MARK: - UISearchBar Delegate
extension HomeViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard !searchText.isEmpty else {
            viewModel.checkDataLocal()
            return
        }
        viewModel.searchWeather(with: searchText)
    }
}
