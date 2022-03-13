//
//  CoinManager.swift
//  FromBitcoin
//
//  Created by Аркадий Рожков on 13.03.2022.
//

import Foundation

protocol didInfoUpdate {
    func updateBitcoinLabel(_ newInfo: String, _ currentCurrency: String)
}

struct CoinManager {
    let currencyArray: [String] = ["RUB", "USD", "EUR"]
    let baseURL: String = "https://rest.coinapi.io/v1/exchangerate/BTC/"
    let apiKey: String = "62A88385-032A-4829-A418-A33C32CDEC75"
    
    var currentCurrency = "RUB"
    
    var delegate: didInfoUpdate?
    
    mutating func getCoinPrice(for currency: String){
        currentCurrency = currency
        performRequest(with: baseURL+"\(currency)?apikey=\(apiKey)")
    }
    
    func performRequest(with urlString: String){
        guard let urlString = URL(string: urlString) else {return}
        let urlSession = URLSession(configuration: .default)
        let task = urlSession.dataTask(with: urlString){
            (data, response, error) in
            if(error != nil){
                print(error!)
                return
            }
            guard let safeData = data else {return}
            guard let parsedData = self.parseJson(safeData) else {return}
            self.delegate?.updateBitcoinLabel(parsedData, currentCurrency)
        }
        task.resume()
    }
    
    func parseJson(_ currencyInfo: Data) -> String? {
        let jsonDecoder = JSONDecoder()
        do{
            let decodedJson = try jsonDecoder.decode(CourseModel.self, from: currencyInfo)
            return String(format: "%.3f", decodedJson.rate as CVarArg)
        }catch{
            print(error)
        }
        return nil
    }
}
