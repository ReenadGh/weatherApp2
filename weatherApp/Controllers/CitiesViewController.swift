//
//  CitiesViewController.swift
//  weatherApp
//
//  Created by Reenad gh on 18/10/1443 AH.
//

import UIKit

class CitiesViewController: UIViewController {
    @IBOutlet var citiesCollectionView: UICollectionView!
    
    let citiesNames : [WeatherCity] = citisDataArr
    private var indexOfSelectedCity : IndexPath =  [0,0]

    override func viewDidLoad() {
        super.viewDidLoad()

        citiesCollectionView.dataSource = self
        citiesCollectionView.delegate = self
        
    }
    

}


// MARK: - HEADER  :  cities collection view
extension CitiesViewController : UICollectionViewDelegate , UICollectionViewDataSource , UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return citiesNames.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
          
        if indexPath.item != citiesNames.count  {
            
            let cell = citiesCollectionView.dequeueReusableCell(withReuseIdentifier: "cityCell" , for: indexPath) as! CityCollectionViewCell
            cell.cityNamelbl.text = citiesNames[indexPath.item].cityName
            if(indexPath == indexOfSelectedCity ){
            }else{
                
            }
            return cell
            
        }else{
            
            let cell = citiesCollectionView.dequeueReusableCell(withReuseIdentifier: "addCityCell" , for: indexPath) as! addCityCollectionViewCell
            
            return cell
            
        }
        
        
   
        
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
        
        if(indexPath.row <  citiesNames.count ){
//            getDataFromApi(zipCode : citiesNames[indexOfSelectedCity.item].cityWOEIDs )
//            collectionView.reloadData()
        }
        else{
            
            
            
        }
    }
    
 
    
    
    
    
    
}
