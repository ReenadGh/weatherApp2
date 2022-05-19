//
//  ViewController.swift
//  weatherApp
//
//  Created by Reenad gh on 16/10/1443 AH.
//

import UIKit

class ViewController: UIViewController {
    
    
    // weather card Properties
    
    @IBOutlet var pressurelbl: UILabel!
    @IBOutlet var datelbl: UILabel!
    @IBOutlet var selectedWeatherImg: UIImageView!
    @IBOutlet var weatherTemplbl: UILabel!
    @IBOutlet var visibiltylbl: UILabel!
    @IBOutlet var windlbl: UILabel!
    @IBOutlet var weekDaylbl: UILabel!
    @IBOutlet var humlbl: UILabel!
    @IBOutlet var DaysTableView: UITableView!
    @IBOutlet var citiesCollectionView: UICollectionView!
    
    private var indexOfSelectedDay : IndexPath =  [0,0]
    private var indexOfSelectedCity : IndexPath =  [0,0]
    
    let citiesNames : [WeatherCity] = citisDataArr
    var dailyWeatherArr = [List]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        citiesCollectionView.dataSource = self
        citiesCollectionView.delegate = self
        
        DaysTableView.delegate = self
        DaysTableView.dataSource = self
        
        
        
        getDataFromApi(cityCode : "12521" )
    }
    
    
}






// MARK: - HEADER  :  cities collection view
extension ViewController : UICollectionViewDelegate , UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return citiesNames.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
        
        
        if indexPath.item != citiesNames.count  {
            
            let cell = citiesCollectionView.dequeueReusableCell(withReuseIdentifier: "cityCell" , for: indexPath) as! CityCollectionViewCell
            cell.cityNamelbl.text = citiesNames[indexPath.item].cityName
            if(indexPath == indexOfSelectedCity ){
                cell.changeCellToSelected()
            }else{
                cell.changeCellToUnSelected()
                
            }
            return cell
            
        }else{
            
            let cell = citiesCollectionView.dequeueReusableCell(withReuseIdentifier: "addCityCell" , for: indexPath) as! addCityCollectionViewCell
            
            return cell
            
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        indexOfSelectedCity = indexPath
        
        if(indexPath.row <  citiesNames.count ){
//            getDataFromApi(zipCode : citiesNames[indexOfSelectedCity.item].cityWOEIDs )
//            collectionView.reloadData()
        }
        else{
            
            
            
        }
    }
    
    
    
    
    
}



// MARK: - Content  :  Dayes table view
extension ViewController : UITableViewDataSource , UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dailyWeatherArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = DaysTableView.dequeueReusableCell(withIdentifier: "dayCell", for: indexPath) as! DayTableViewCell
        
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        indexOfSelectedDay = indexPath
        updateWeatherCardViewInfo()
    }
    
    
    
    
}

// MARK: - Data   :  Data fetching from API and present it to the view

extension ViewController {
    
    
    func getDataFromApi(cityCode : String ){
        
        
        let jsonURLstring = "http://api.openweathermap.org/data/2.5/forecast?zip=\(cityCode)&appid=553626bed26b25f56af0d6fa3890d1c5"
        guard let url = URL(string : jsonURLstring) else {return }
        URLSession.shared.dataTask(with: url) { data , response, errur in
            guard let data = data else {return }
            
            let dataAsString = String(data: data , encoding: .utf8)
            
            do {
                let watherData = try JSONDecoder().decode( CityWeather.self ,from: data )
                print(watherData.list[0].weather[0].icon)
               
                self.dailyWeatherArr = watherData.list
                
                DispatchQueue.main.async {
                    self.updateWeatherCardViewInfo()
                    
                }
            }catch let jsonErr{
                print("Error :" ,jsonErr )
            }
            
        }.resume()
    }
    
    // take the weather icon name and get the image from the api
    
    func getWeatherStateIcon(weatherState : String )->UIImage{
        
        
        let url = URL(string: "https://openweathermap.org/img/w\(weatherState).png")
        let data = try? Data(contentsOf: url!)
        
        return UIImage(data: data!)!
    }
    
    
}


// MARK: - FUNCTIONS
extension ViewController {
    
    
    
    
    // date formatting converting functions
    
    func convertDtToformatedDate(dt: Double, foramt : String ) -> String {
        
//        Wednesday, Sep 12, 2018           --> EEEE, MMM d, yyyy
//        09/12/2018                        --> MM/dd/yyyy
//        09-12-2018 14:11                  --> MM-dd-yyyy HH:mm
//        Sep 12, 2:11 PM                   --> MMM d, h:mm a
//        September 2018                    --> MMMM yyyy
//        Sep 12, 2018                      --> MMM d, yyyy
//        Wed, 12 Sep 2018 14:11:54 +0000   --> E, d MMM yyyy HH:mm:ss Z
//        2018-09-12T14:11:54+0000          --> yyyy-MM-dd'T'HH:mm:ssZ
//        12.09.18                          --> dd.MM.yy
//        10:41:02.112                      --> HH:mm:ss.SSS
        
          let date = Date(timeIntervalSince1970: dt)
        let dateFormatter = DateFormatter()
          dateFormatter.dateFormat = foramt
          return dateFormatter.string(from: date)
      }
    
    
    
}


// MARK: - Update View FUNCTIONS
extension ViewController {
    
    // update the view depends on the index of selected day  * 0 for defult
    
    func updateWeatherCardViewInfo(){
  
        datelbl.text = convertDtToformatedDate(dt: Double(dailyWeatherArr[indexOfSelectedDay.row].dt), foramt: "MMM d, h:mm a")
        weekDaylbl.text = convertDtToformatedDate(dt: Double(dailyWeatherArr[indexOfSelectedDay.row].dt), foramt: "EEEE")
//        weatherTemplbl.text = "\(Int(dailyWeatherArr[indexOfSelectedDay.row].theTemp))°"
//        pressurelbl.text = "\(Int(dailyWeatherArr[indexOfSelectedDay.row].airPressure))"
//        humlbl.text = "\(Int(dailyWeatherArr[indexOfSelectedDay.row].humidity))"
//        windlbl.text = "\(Int(dailyWeatherArr[indexOfSelectedDay.row].windSpeed))"
//        visibiltylbl.text = "\(Int(dailyWeatherArr[indexOfSelectedDay.row].visibility))"
//        selectedWeatherImg.image = getWeatherStateIcon(weatherState:   dailyWeatherArr[indexOfSelectedDay.row].weatherStateAbbr)
//
    }
    
    
}
