//
//  ViewController.swift
//  BitcoinCurrency
//
//  Created by Nijat Naghiyev on 20.01.25.
//

import UIKit

class ViewController: UIViewController {
    
    var coinManager = CoinManager()
    

    @IBOutlet weak var currencyPicker: UIPickerView!
    @IBOutlet weak var currencyLabel: UILabel!
    @IBOutlet weak var bitcoinCurrencyLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        coinManager.delegate = self
        currencyPicker.dataSource = self
        currencyPicker.delegate = self
        
        initialRequest()

    }



    // MARK: - Initial Request
    
    func initialRequest() {
        if let selectedCurrency = coinManager.currencyArray.first{
            coinManager.getCoinPrice(for: selectedCurrency)
            
        } else {
            print("No Currency Data")
        }
    }

}

// MARK: - Extension UIPickerViewDataSource, UIPickerViewDelegate

extension ViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    // MARK: - Picker Column

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // MARK: - Picker Row

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return coinManager.currencyArray.count
    }
    
    // MARK: - Picker Items Label

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return coinManager.currencyArray[row]
    }
    
    // MARK: - When Change Picker Item

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let selectedCurrency=coinManager.currencyArray[row]
       coinManager.getCoinPrice(for: selectedCurrency)
    }
    
}

// MARK: - Extension CoinManagerDelegate


extension ViewController: CoinManagerDelegate {
    
    func didUpdatePrice(price: String, currency: String) {
        
        DispatchQueue.main.async {
            self.bitcoinCurrencyLabel.text = price
            self.currencyLabel.text = currency
        }
    }
    
    func didFailWithError(error: Error) {
        print(error)
    }
}
