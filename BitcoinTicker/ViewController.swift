//
//  ViewController.swift
//  BitcoinTicker
//
//  Created by Angela Yu on 23/01/2016.
//  Copyright © 2016 London App Brewery. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire

class ViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    
    
    let baseURL = "https://apiv2.bitcoinaverage.com/indices/global/ticker/BTC"
    let currencyArray = ["USD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","AUD","ZAR"]
    var finalURL = ""
    let currencySymbolArray = ["$", "R$", "$", "¥", "€", "£", "$", "Rp", "₪", "₹", "¥", "$", "kr", "$", "zł", "lei", "₽", "kr", "$", "$", "R"]

    //Pre-setup IBOutlets
    @IBOutlet weak var bitcoinPriceLabel: UILabel!
    @IBOutlet weak var currencyPicker: UIPickerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        currencyPicker.delegate = self
        currencyPicker.dataSource = self
        
        //  load USD price on startup
        getBtcData(url: baseURL + "USD", symbolRow: 0)
    }

    
    //TODO: Place your 3 UIPickerView delegate methods here
    
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return currencyArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return currencyArray[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        //print(currencyArray[row])
        finalURL = baseURL + currencyArray[row]
        getBtcData(url: finalURL, symbolRow: row)
    }

    
    
    
//    
//    //MARK: - Networking
//    /***************************************************************/
    
    func getBtcData(url: String, symbolRow : Int) {
        
        Alamofire.request(url, method: .get)
            .responseJSON { response in
                if response.result.isSuccess {

                    print("Success!")
                    let BtcJSON : JSON = JSON(response.result.value!)

                    self.updateBtcPrice(json: BtcJSON, symbolRow : symbolRow)

                } else {
                    print("Error: \(String(describing: response.result.error))")
                    self.bitcoinPriceLabel.text = "Connection Issues"
                }
            }

    }

    
    
    
    
//    //MARK: - JSON Parsing
//    /***************************************************************/
    
    func updateBtcPrice(json : JSON, symbolRow : Int) {
        if let BtcPrice = json["ask"].double {
            bitcoinPriceLabel.text = currencySymbolArray[symbolRow] + String(BtcPrice)
        }else {
            bitcoinPriceLabel.text = "Price Unavailiable"
        }
        
    }
    




}

