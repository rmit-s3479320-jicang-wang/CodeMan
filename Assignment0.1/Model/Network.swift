
import Foundation

// MARK: - network
func queryWeather(latitude: Double, longitude: Double, callback: @escaping (NSDictionary?)->Void) {
    let session = URLSession.shared
    let urlStr = "https://api.openweathermap.org/data/2.5/weather?lat=\(latitude)&lon=\(longitude)&appid=c2dcd320ee861647528ab7c9d7af7326"
    let url = URL(string: urlStr)
    let request = URLRequest(url: url!,
                             cachePolicy:.useProtocolCachePolicy,
                             timeoutInterval:20)
    let dataTask = session.dataTask(with: request as URLRequest) { (data, response, error) -> Void in
        DispatchQueue.main.async(execute: {
            if (error != nil) {
                callback(nil)
            }else {
                let json: Any = try! JSONSerialization.jsonObject(with: data!, options: [])
                callback(json as? NSDictionary)
            }
        })
    }
    dataTask.resume()
}
