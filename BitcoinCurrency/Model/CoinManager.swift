//
//  CoinModel.swift
//  BitcoinCurrency
//
//  Created by Nijat Naghiyev on 20.01.25.
//

import Foundation

protocol CoinManagerDelegate {
    func didUpdatePrice(price: String, currency: String)
    func didFailWithError(error: Error)
}

struct CoinManager {
    var delegate: CoinManagerDelegate?
    
    
    let baseURL = "https://rest.coinapi.io/v1/exchangerate/BTC"
    let apiKey = "your-api-key-here"
    
    let currencyArray = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]

    
    func getCoinPrice(for currency: String) -> Void {
        
        // Final URL
        let urlString = baseURL + "/\(currency)?apikey=\(apiKey)"
        
        // Convert to URL
        if let url = URL(string: urlString){
            
            // URL Session
            let session = URLSession(configuration: .default)
            
            // Data Task
            let task = session.dataTask(with: url) { data, response, error in
                if error != nil{
                    print("Error: \(String(describing: error))")
                    return
                }
                
               
                if  data != nil {
                    print("Data: \(String(describing: data))")
                 let rate = parseJSONToData(data!)
                    
                    self.delegate?.didUpdatePrice(price: String(format: "%.2f", rate), currency: currency)
                } else {
                    return
                }

                
            }//: Data Task
            
            //Start task to fetch data from bitcoin average's servers.
            task.resume()
        }//: URL
        
    }//: getCoinPrice
    
    
    // MARK: - Parse data from JSON

    func parseJSONToData(_ data: Data) -> Double {
        // Json Decoder
        let decoder = JSONDecoder()
        
        do {
            // Get [CoinModel] from Data
            let coinModel = try decoder.decode(CoinModel.self, from: data)
            
            dump(coinModel)
            
            return coinModel.rate
        } catch {
            delegate?.didFailWithError(error: error)
            return 0.0
        }
    }
}
