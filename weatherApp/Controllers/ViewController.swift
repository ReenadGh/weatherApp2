//
//  ViewController.swift
//  weatherApp
//
//  Created by Reenad gh on 16/10/1443 AH.
//

import UIKit
import IBAnimatable
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
    @IBOutlet var weatherCardView: AnimatableView!
    
    private var indexOfSelectedDay : IndexPath =  [0,0]
    
    var dailyWeatherArr = [List]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //welcome animation 
        weatherCardView.animate(.slide(way: .in, direction:.down),duration: 1.5)

        DaysTableView.delegate = self
        DaysTableView.dataSource = self
        
        
        
        getDataFromApi(cityCode : "12521" )
    }
    
  
 
    
    
}








// MARK: - Content  :  Dayes table view
extension ViewController : UITableViewDataSource , UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dailyWeatherArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
     
        let cell = DaysTableView.dequeueReusableCell(withIdentifier: "dayCell", for: indexPath) as! DayTableViewCell
        
        
        cell.setDayWeatherData(dayDate: convertDtToformatedDate(dt: Double(dailyWeatherArr[indexPath.row].dt), foramt: "h:mm a")
                              
                              , watherStatus: convertDtToformatedDate(dt: Double(dailyWeatherArr[indexPath.row].dt), foramt: "EEE"), lowTemp:"↓ \( ConvertKivToC(temperature: dailyWeatherArr[indexPath.row].main.tempMin))", highTemp: "↑ \(ConvertKivToC(temperature: dailyWeatherArr[indexPath.row].main.tempMax))", weatherImg: getWeatherStateIcon(weatherState:   dailyWeatherArr[indexPath.row].weather[0].icon) )
        
        
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
               // self.dailyWeatherArr.removeAll()
            
                for i in 0...20{
                    self.dailyWeatherArr.append(watherData.list[i])
                }
         print( self.dailyWeatherArr.count)

                DispatchQueue.main.async {
                    self.updateWeatherCardViewInfo()
                    self.DaysTableView.reloadData()
                }
            }catch let jsonErr{
                print("Error :" ,jsonErr )
            }
            
        }.resume()
    }
    
    // take the weather icon name and get the image from the api
    func getWeatherStateIcon(weatherState : String )->UIImage{
        
        let url = URL(string: "https://openweathermap.org/img/wn/\(weatherState)@2x.png")
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
    
    
    
    // convert the value from fahrenheit to celsius dgree
    func ConvertKivToC(temperature : Double)->String {
       return  "\(String(format: "%.0f", temperature - 273.15))°"
    }
    
    
}


// MARK: - Update View FUNCTIONS
extension ViewController {
    
    // update the view depends on the index of selected time  * 0 for defult
    func updateWeatherCardViewInfo(){
        datelbl.text = convertDtToformatedDate(dt: Double(dailyWeatherArr[indexOfSelectedDay.row].dt), foramt: "MMM d, h:mm a")
        weekDaylbl.text = convertDtToformatedDate(dt: Double(dailyWeatherArr[indexOfSelectedDay.row].dt), foramt: "EEEE")
        weatherTemplbl.text = "\(ConvertKivToC(temperature: dailyWeatherArr[indexOfSelectedDay.row].main.temp))"

        humlbl.text = "\( dailyWeatherArr[indexOfSelectedDay.row].main.humidity)"
        pressurelbl.text = "\(dailyWeatherArr[indexOfSelectedDay.row].main.pressure)"
        windlbl.text = "\( dailyWeatherArr[indexOfSelectedDay.row].wind.speed)"
        visibiltylbl.text = "\(dailyWeatherArr[indexOfSelectedDay.row].visibility.description)"
        selectedWeatherImg.image = getWeatherStateIcon(weatherState:   dailyWeatherArr[indexOfSelectedDay.row].weather[0].icon)
//
    }
 
    
    
}
