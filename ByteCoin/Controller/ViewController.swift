//
//  ViewController.swift
//  ByteCoin
//
//  Created by Angela Yu on 11/09/2019.
//  Copyright © 2019 The App Brewery. All rights reserved.
//

import UIKit

protocol CoinManagerDelegate: UIPickerViewDelegate {
    func didUpdatePrice(_ coinPrice: String?,currency: String?)
    func didFailWithError(error: Error)
    func didUpdateList(_ symbolArray: [String]?)
}


class ViewController: UIViewController {
    
    var coinManager = CoinManager()
    var currencyArray: [String] = ["BTC"]
    var rankTo: Int = 22
    
    @IBOutlet var priceLabel: UILabel!
    @IBOutlet var currencyLabel: UILabel!
    @IBOutlet var currencyPicker: UIPickerView!
    @IBOutlet var myView: UIView!
    @IBOutlet var myView2: UIView!
    @IBOutlet var titleBackground: UILabel!
    @IBOutlet var subTitleBackground: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        currencyPicker.dataSource = self // Set VC as datasource for picker
        currencyPicker.delegate = self
        coinManager.delegate = self
    

        // Do any additional setup after loading the view.
        // View design
        myView.layer.cornerRadius = 10
        myView.layer.masksToBounds = true
        myView2.layer.cornerRadius = 10
        myView2.layer.masksToBounds = true
        currencyPicker.layer.cornerRadius = 10.0
        priceLabel.adjustsFontSizeToFitWidth = true
        priceLabel.minimumScaleFactor = 0.5
        titleBackground.layer.cornerRadius = 25
        titleBackground.layer.masksToBounds = true
        subTitleBackground.layer.cornerRadius = 22
        subTitleBackground.layer.masksToBounds = true
        
        // Fetch rank list
        coinManager.getCoinList()
    }
}

//MARK: - UIPicker

extension ViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    

    // Decide number of columns
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    // Decide number of rows
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return currencyArray.count
    }
    
    // Title of each row
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? { // will call this method to retrieve the title for each row
        return currencyArray[row]
    }
    
    // Record the row number being selected
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) { // will call this method everytime user scroll picker
        coinManager.getCoinPrice(row)
    }
    
    // UI
    // Change color
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        let title = currencyArray[row]
        let attributedString = NSAttributedString(string: title, attributes: [NSAttributedString.Key.foregroundColor: UIColor(named: "Color 2nd") ?? UIColor.white]) // Replace UIColor.red with the desired text color
        return attributedString
    }
    // Change row height
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 35.0 // Replace with the desired row height
    }

    

}

//MARK: - CoinManager

extension ViewController: CoinManagerDelegate {
    // Update UI
    // Decode data success update list
    
    // Decode data success
    func didUpdatePrice(_ coinPrice: String?,currency: String?) {
        // Get decoded CoinData model ?Make sure is CoinData Model
        if let safePrice = coinPrice, let safeCurrency = currency {
            // Get hold of the main thread to update the UI
            DispatchQueue.main.async {
                self.priceLabel.text = safePrice
                self.currencyLabel.text = safeCurrency
            }
        }
    }
    
    // Update list of symbols rank
    func didUpdateList(_ symbolArray: [String]?) {
        if let list = symbolArray {
            DispatchQueue.main.async {
                self.currencyArray = list
                // Reload the picker view to update the titles
                self.currencyPicker.reloadAllComponents()
            }
        }
    }
    
    // If fail to decode data
    func didFailWithError(error: Error) {
        print(error)
    }
}


