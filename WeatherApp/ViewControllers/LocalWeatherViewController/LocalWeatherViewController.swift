//
//  LocalWeatherViewController.swift
//  WeatherApp
//
//  Created by Nguyen Tran on 19/05/2022.
//

import UIKit

class LocalWeatherViewController: BaseVC {

    // MARK: - Outlets
    @IBOutlet private weak var weatherImageView: UIImageView!
    @IBOutlet private weak var cityLabel: UILabel!
    @IBOutlet private weak var humidityLabel: UILabel!
    @IBOutlet private weak var temperatureLabel: UILabel!
    @IBOutlet private weak var weatherLabel: UILabel!
    
    // MARK: - Properties
    private var viewModel: LocalWeatherViewModel
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Local Weather"
        addBackButton()
        bindingData()
        showLoading()
        viewModel.getLocalWeather()
    }
    
    // MARK: - Methods
    init(city: String) {
        viewModel = LocalWeatherViewModel(api: API(), city: city)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func loadImage(url: URL) {
        if let imageData = try? Data(contentsOf: url) {
            if let loadedImage = UIImage(data: imageData) {
                self.weatherImageView.image = loadedImage
            }
        }
    }
}

// MARK: - Binding Data
private extension LocalWeatherViewController {
    func bindingData() {
        viewModel.onGetLocalWeatherSuccess = { [weak self] weather in
            guard let self = self else { return }
            self.hideLoading()
            if let humidity = weather.data.currentCondition.first?.humidity {
                self.humidityLabel.text = "Humidity: \(humidity)"
            }
            
            if let city = weather.data.request.first?.query {
                self.cityLabel.text = "City: \(city)"
            }
            
            if let temperature = weather.data.currentCondition.first?.tempC {
                self.temperatureLabel.text = "Temperature: \(temperature)"
            }
            
            if let weatherDesc = weather.data.currentCondition.first?.weatherDesc.first?.value {
                self.weatherLabel.text = "Weather: \(weatherDesc)"
            }
            
            if let url = URL(string: weather.data.currentCondition.first?.weatherIconURL.first?.value ?? "") {
                self.loadImage(url: url)
            }
        }
        
        viewModel.onGetLocalWeatherFail = { errorMessage in
            self.hideLoading()
            print("errorMessage === \(errorMessage)")
            
        }
    }
}
