//
//  DayTableViewCell.swift
//  weatherApp
//
//  Created by Reenad gh on 17/10/1443 AH.
//

import UIKit

class DayTableViewCell: UITableViewCell {

    @IBOutlet var dayDatelbl: UILabel!
    @IBOutlet var weatherStatuslbl: UILabel!
    @IBOutlet var weatherImg: UIImageView!
    @IBOutlet var lowTemplbl: UILabel!
    @IBOutlet var highTemplbl: UILabel!
    
    
    
    
    func setDayWatherData (dayDate : String , watherStatus : String , lowTemp : String , highTemp : String , weatherImg : UIImage){
        dayDatelbl.text = dayDate
        weatherStatuslbl.text = watherStatus
        lowTemplbl.text = lowTemp
        highTemplbl.text = highTemp
        self.weatherImg.image = weatherImg
    }

}

