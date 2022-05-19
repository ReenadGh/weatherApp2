//
//  CityCollectionViewCell.swift
//  weatherApp
//
//  Created by Reenad gh on 16/10/1443 AH.
//

import UIKit
import IBAnimatable
class CityCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet var cityNamelbl: UILabel!
    @IBOutlet var cardView: AnimatableView!
    
    
    func changeCellToSelected (){
        
        cityNamelbl.textColor = .black
        cardView.fillColor = .white


    }
    func changeCellToUnSelected (){
        
        cityNamelbl.textColor = .white
        cardView.fillColor = .black
      

    }

}
