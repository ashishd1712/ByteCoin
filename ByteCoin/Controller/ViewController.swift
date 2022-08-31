

import UIKit

class ViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, CoinManagerDelegate {
    
    @IBOutlet weak var currencyLabel: UILabel!
    @IBOutlet weak var bitcoinLabel: UILabel!
    @IBOutlet weak var currencyPicker: UIPickerView!
    @IBOutlet weak var crypto: UIImageView!
    
    var coinManager = CoinManager()
    var cryptoImage = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        currencyPicker.dataSource = self
        currencyPicker.delegate = self
        coinManager.delegate = self
        crypto.image = coinManager.coinImage[cryptoImage]
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 0{
            return coinManager.currencyArray.count
        }
        else{
            return coinManager.coinArray.count
        }
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if component == 0{
            return coinManager.currencyArray[row]
        }
        else {
            return coinManager.coinArray[row]
        }
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let selectedCurrency = coinManager.currencyArray[pickerView.selectedRow(inComponent: 0)]
        let selectedCoin = coinManager.coinArray[pickerView.selectedRow(inComponent: 1)]
        cryptoImage = pickerView.selectedRow(inComponent: 1)
        coinManager.getCoinPrice(for: selectedCurrency,coin: selectedCoin)
    }
    func didUpdatePrice(price: String, currency: String) {
        DispatchQueue.main.async {
            self.currencyLabel.text = currency
            self.bitcoinLabel.text = price
            self.crypto.image = self.coinManager.coinImage[self.cryptoImage]
            
        }
    }
    
    func didFailWithError(error: Error) {
        print(error)
    }
    
}

