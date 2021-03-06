//
//  DayTableViewCell.swift
//  weatherApp
//
//  Created by Reenad gh on 17/10/1443 AH.
//

import UIKit
import MBProgressHUD
class DayTableViewCell: UITableViewCell {

    @IBOutlet var dayDatelbl: UILabel!
    @IBOutlet var weatherStatuslbl: UILabel!
    @IBOutlet var weatherImg: UIImageView!
    @IBOutlet var lowTemplbl: UILabel!
    @IBOutlet var highTemplbl: UILabel!
    
    
    
    
    func setDayWeatherData (dayDate : String , watherStatus : String , lowTemp : String , highTemp : String , weatherImg : UIImage){
        dayDatelbl.text = dayDate
        weatherStatuslbl.text = watherStatus
        lowTemplbl.text = lowTemp
        highTemplbl.text = highTemp
        self.weatherImg.image = weatherImg


    }
    
    
    
    func changeCellToSelected (){
        
        dayDatelbl.textColor = UIColor(red: 0.24, green: 0.52, blue: 0.87, alpha: 1.00)

        lowTemplbl.textColor = UIColor(red: 0.24, green: 0.52, blue: 0.87, alpha: 1.00)
        weatherStatuslbl.textColor = UIColor(red: 0.24, green: 0.52, blue: 0.87, alpha: 1.00)
        

        highTemplbl.textColor = UIColor(red: 0.24, green: 0.52, blue: 0.87, alpha: 1.00)
        



    }
    func changeCellToUnSelected (){
        
   
        dayDatelbl.textColor = .white
        lowTemplbl.textColor = .white
        weatherStatuslbl.textColor = .white
        highTemplbl.textColor = .white


    }

}

