
import UIKit

protocol CoinManagerDelegate {
    func didUpdatePrice(price: String, currency: String)
    func didFailWithError(error: Error)
}

struct CoinManager {
    
    var delegate: CoinManagerDelegate?
    
    let baseURL = "https://rest.coinapi.io/v1/exchangerate"
    let apiKey = "(Enter your CoinAPI api key here)" // important
    
    let currencyArray = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]
    
    let coinArray = ["BTC","ETC","ETH","SHIB","DOGE","XRP","BNB"]
    
    let coinImage = [#imageLiteral(resourceName: "bitcoin-btc-logo"),#imageLiteral(resourceName: "ethereum-classic-etc-logo"),#imageLiteral(resourceName: "ethereum-eth-logo"),#imageLiteral(resourceName: "shiba-inu-shib-logo"),#imageLiteral(resourceName: "dogecoin-doge-logo"),#imageLiteral(resourceName: "xrp-xrp-logo"),#imageLiteral(resourceName: "binance-coin-bnb-logo")]
    
    func getCoinPrice(for currency: String, coin: String){
        let urlString = "\(baseURL)/\(coin)/\(currency)?apikey=\(apiKey)"
        if let url = URL(string: urlString){
            let session = URLSession(configuration: .default)
            
            let task = session.dataTask(with: url) { data, response, error in
                if error != nil{
                    self.delegate?.didFailWithError(error: error!)
                    return
                }
                if let safeData = data{
                    if let BTCPrice = self.parseJSON(coinData: safeData){
                        var price = ""
                        if BTCPrice < 1.0{
                            price = String(format: "%.5f", BTCPrice)
                        }
                        else {
                            price = String(format: "%.2f", BTCPrice)
                        }
                        self.delegate?.didUpdatePrice(price: price, currency: currency)
                    }
                }
            }
            task.resume()
        }
        
    }
    
            
    
    
    func parseJSON(coinData: Data)-> Double?{
        let decoder = JSONDecoder()
        do{
            let decodedData = try decoder.decode(CoinData.self, from: coinData)
            let lastPrice = decodedData.rate
            return lastPrice
            
        }
        catch{
            print(error)
            return nil
        }
    }
    
}
