//
//  ViewController.swift
//  FromBitcoin
//
//  Created by Аркадий Рожков on 13.03.2022.
//

import UIKit

class ViewController: UIViewController {

    var coinManager = CoinManager()
    
    @IBOutlet weak var bitcoinLabel: UILabel!
    @IBOutlet weak var currencyLabel: UILabel!
    @IBOutlet weak var currencyPicker: UIPickerView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        currencyPicker.dataSource = self
        currencyPicker.delegate = self
        coinManager.delegate = self
        
        coinManager.getCoinPrice(for: "RUB")
    }
}

//MARK: - Picker Data Source

extension ViewController: UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return coinManager.currencyArray.count
    }
    
}
//MARK: - Picker Delegate

extension ViewController: UIPickerViewDelegate{
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return coinManager.currencyArray[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        coinManager.getCoinPrice(for: coinManager.currencyArray[row])
    }
}

//MARK: - For When Info Updated

extension ViewController: didInfoUpdate{
    func updateBitcoinLabel(_ newInfo: String, _ currentCurrency: String) {
        DispatchQueue.main.async {
            self.bitcoinLabel.text = newInfo
            self.currencyLabel.text = currentCurrency
        }
    }
}
