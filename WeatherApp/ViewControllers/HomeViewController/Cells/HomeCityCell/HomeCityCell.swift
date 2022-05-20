//
//  HomeCityCell.swift
//  WeatherApp
//
//  Created by Nguyen Tran on 18/05/2022.
//

import UIKit

class HomeCityCell: UITableViewCell {
    @IBOutlet private weak var cityLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }
    
    func configure(model: SearchWeatherCityModel) {
        cityLabel.text = model.getAreaName()
    }
}
