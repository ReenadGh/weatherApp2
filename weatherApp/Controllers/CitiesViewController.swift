//
//  CitiesViewController.swift
//  weatherApp
//
//  Created by Reenad gh on 18/10/1443 AH.
//

import UIKit
import MBProgressHUD
import IBAnimatable
import CoreData

class CitiesViewController: UIViewController {
    @IBOutlet var citiesCollectionView: UICollectionView!
    
    //enter city code Card View propilires
    @IBOutlet var enterCityCodeCard: AnimatableView!
    @IBOutlet var cityCodeTf: AnimatableTextField!
    @IBOutlet var errorMessagelbl: UILabel!
    
    //core data
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    let saveContext = (UIApplication.shared.delegate as! AppDelegate).saveContext
    var userCities = [CityInfo]()
    var defultCities = defultCitisDataArr
    //city delegate
    var delegate : CityDataDelegate?
    
    // exit the enter code card
    @IBAction func dissmisCodeCityCardTapped(_ sender: UIButton) {
        enterCityCodeCard.animate(.slide(way: .out, direction: .down ))
    }
    
    
    //if user click on enter button --> to add new city
    @IBAction func enterCityCodeTapped(_ sender: UIButton) {
                
        guard let cityCode = cityCodeTf.text,
              !cityCode.isEmpty else {
            return
        }
 
        if citiesInfArr.contains(where: { $0.cityWOEIDs == cityCode }) {
          showErrorMessage(message: "the city is already exists !")
        } else {
            //fetch the city info from api
            fetchCityInfoApi(cityCode : cityCode )
            //save it to the storage 
            addNewCity(cityCode: cityCode)
        }
        
     
        
    }
    
    
    
    var citiesInfArr = [WeatherCity]()
    private var indexOfSelectedCity : IndexPath =  [0,0]

    override func viewDidLoad() {
        super.viewDidLoad()

        //adding defults cities to core data if the app lunched for first time
        if !isAppAlreadyLaunchedOnce() {
            for city in defultCities {
                addNewCity(cityCode: city.cityCode)
            }
        }


        citiesCollectionView.dataSource = self
        citiesCollectionView.delegate = self
        
        
        fetchCitiesData()
        for city in userCities {
            fetchCityInfoApi(cityCode : city.code!)
            print( city.code!)
        }
     
     

    }
    

}


// MARK: -  :  cities collection view
extension CitiesViewController : UICollectionViewDelegate , UICollectionViewDataSource , UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return citiesInfArr.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
          
        if indexPath.item != citiesInfArr.count  {
            
            let cell = citiesCollectionView.dequeueReusableCell(withReuseIdentifier: "cityCell" , for: indexPath) as! CityCollectionViewCell
            cell.cityNamelbl.text = citiesInfArr[indexPath.item].cityName
            cell.templbl.text = citiesInfArr[indexPath.item].temp
            cell.weatherImg.image = citiesInfArr[indexPath.item].weatherImg
            cell.sunriselbl.text = citiesInfArr[indexPath.item].citySunrise
            cell.sunsetlbl.text = citiesInfArr[indexPath.item].citySunsit

            
            if(indexPath == indexOfSelectedCity ){
            }else{
                
            }
            return cell
            
        }else{
            
            let cell = citiesCollectionView.dequeueReusableCell(withReuseIdentifier: "addCityCell" , for: indexPath) as! addCityCollectionViewCell
            
            return cell
            
        }

      // layout functions for citiesCollectionView
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width * 0.485 , height:view.frame.width * 0.54 )
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0.4
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0.3
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        indexOfSelectedCity = indexPath
  
        if(indexPath.row <  citiesInfArr.count ){
            delegate?.ChangecityCode(cityCode: citiesInfArr[indexPath.row].cityWOEIDs)
            self.navigationController?.popViewController(animated: true)

            // pass the city code to the main controller
//            let mainController = self.navigationController?.viewControllers.first as! ViewController
//            mainController.currentCityCode =
//            self.navigationController?.popViewController(animated: true)
  
        }
        else{
            // if the user click on last cell ( + )
            enterCityCodeCard.isHidden = false
            enterCityCodeCard.animate(.slide(way: .in, direction: .up))
            
            
        }
    }
    
 
    
    
    
    
    
}



// MARK: - Data   :  Data fetching from API and present it to the view

extension CitiesViewController {
    
    // fetch city data from api then add it to cities Array
    func fetchCityInfoApi(cityCode : String ){
        
        
        let jsonURLstring = "http://api.openweathermap.org/data/2.5/forecast?zip=\(cityCode)&appid=553626bed26b25f56af0d6fa3890d1c5"
        guard let url = URL(string : jsonURLstring) else {return }
        MBProgressHUD.showAdded(to: self.view, animated: true)
        URLSession.shared.dataTask(with: url) { [self] data , response, errur in
            guard let data = data else {return }
                        
            do {
                let watherData = try JSONDecoder().decode( CityWeather.self ,from: data )
               
                 // get city Info from api then  append it into city array
                  self.citiesInfArr.append(WeatherCity(cityName: watherData.city.name , cityWOEIDs: cityCode , citySunsit: self.convertDtToformatedDate(dt: Double(watherData.city.sunset) , foramt : "h:mm a" ) , citySunrise: self.convertDtToformatedDate(dt: Double(watherData.city.sunrise) , foramt : "h:mm a" ), temp: "\(self.ConvertKivToC(temperature: watherData.list[0].main.temp))", weatherImg: getWeatherStateIcon(weatherState: watherData.list[0].weather[0].icon) ))

                DispatchQueue.main.async {
                    citiesCollectionView.reloadData()
                    enterCityCodeCard.animate(.slide(way: .out, direction:.down))
                    MBProgressHUD.hide(for: self.view, animated: true)

                }
            }catch let jsonErr{
                print("Error :" ,jsonErr )
                DispatchQueue.main.async {
                    // if the user enter wrong city code :
                 showErrorMessage(message: "invalid city code ")
                    MBProgressHUD.hide(for: self.view, animated: true)

                }

            }
            
        }.resume()
    }
    
    // take the weather icon name and get the image from the api
    func getWeatherStateIcon(weatherState : String )->UIImage{
        
        let url = URL(string: "https://openweathermap.org/img/wn/\(weatherState)@2x.png")
        let data = try? Data(contentsOf: url!)
        
        return UIImage(data: data!)!
    }
    
    
    // onvert the value from fahrenheit to celsius dgree
    func ConvertKivToC(temperature : Double)->String {
       return  "\(String(format: "%.0f", temperature - 273.15))°"
    }
    
    
    
    
    
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
    //show error message if the user enter valid value
    func showErrorMessage(message : String ){
        
        errorMessagelbl.isHidden = false
        errorMessagelbl.text = message
        enterCityCodeCard.animate(.shake(repeatCount: 1),duration: 0.4 )
    }
    
  // check if its run for first time  --> to add defults cities to coredata
    func isAppAlreadyLaunchedOnce()->Bool{
            let defaults = UserDefaults.standard
            
            if defaults.bool(forKey: "isAppAlreadyLaunchedOnce"){
                print("App already launched : \(String(describing: isAppAlreadyLaunchedOnce))")
                return true
            }else{
                defaults.set(true, forKey: "isAppAlreadyLaunchedOnce")
                print("App launched first time")
                return false
            }
        }
    
    
    
}


// MARK: - CoreData
extension CitiesViewController {

    func fetchCitiesData(){
 
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "CityInfo")
                do {
                    
                    let results = try context.fetch(fetchRequest)
                    // add the result as an array of this entity
                    userCities = results as! [CityInfo]
                } catch {
                    print("\(error)")
                }
        
    

    }
    
    func addNewCity(cityCode : String )
     {
         
         //create new object
         let newCity = CityInfo(context: self.context)
         newCity.code = cityCode
         saveContext()

     }

    
    
}
