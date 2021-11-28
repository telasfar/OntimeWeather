//
//  DataService.swift
//  OnTime Weather App
//


import Foundation
import Alamofire
import SwiftyJSON

class DataService{
    
    //vars
    static let instance = DataService()
    var weather:WeatherModel?
    var weatherArr = [WeatherModel]()
    
    func getWeatherByCity(city:String,country:String,complition: @escaping complitionHandlerWeather){
        let urlCity = getURLByCity(city: city, country: country).addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        Alamofire.request(urlCity, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).responseJSON { (response) in
            
            let jsonDecoder = JSONDecoder()
            
            
            if response.result.error == nil {
            //case let .success(value):
           
                do{
                    let rsponseModel = try jsonDecoder.decode(WeatherResource.self, from: response.data!)
                    complition(true,rsponseModel)
                }catch{
                    debugPrint(error.localizedDescription)
                }
                
            }else{
                complition(false,nil)
                
        }
        }
    }
    
    func getWeatherToday(long:Double,lat:Double,complition: @escaping complitionHandlerMessage){
        let apiURL = getMapURL(lat: lat, long: long, mode: "weather")
        Alamofire.request(apiURL, method: HTTPMethod.get, parameters: nil, encoding: JSONEncoding.default, headers: nil).responseJSON { (response) in
            if response.result.error == nil {
                guard let dataJson = response.data else {return}

                self.getTodayTemp(data: dataJson)

                complition(true, self.weather!)
            }else{
                complition(false, nil)
            }
        }
    }
    
    func getTodayTemp(data:Data){
        do{
            
            let json = try JSON(data: data).dictionary
            let jsonArray = json!["weather"]?.array
            let desc = jsonArray?.first?["description"].stringValue
            let mainDect = json!["main"]?.dictionary
            let temp = mainDect!["temp"]?.doubleValue
            let tempMax = mainDect!["temp_max"]?.doubleValue
            let tempMin = mainDect!["temp_min"]?.doubleValue
            let humidity = mainDect!["humidity"]?.doubleValue
            let wendDect = json!["wind"]?.dictionary
            let wendSpeed = wendDect!["speed"]?.doubleValue
            let rainDect = json?["rain"]?.dictionary ?? ["3h":0.0]
            let rainVolume = rainDect["3h"]?.double ?? 0.0
            let rainIcon = jsonArray?.first?["icon"].stringValue ?? ""
            //come from api   "rain": {"3h": 6.3425}
            self.weather = WeatherModel(description: desc!, temp: temp!, humidity: humidity!, tempMin: tempMin!, tempMax: tempMax!, wendSpeed: wendSpeed!, rainVolume: rainVolume, icon: rainIcon)
            
        }catch{
            debugPrint(error.localizedDescription)

        }
       
    }
    
    func getWeatherLastDays(long:Double,lat:Double,complition: @escaping complitionHandlerArray){
         let apiURL = getMapURL(lat: lat, long: long, mode: "forecast")
        Alamofire.request(apiURL, method: HTTPMethod.get, parameters: nil, encoding: JSONEncoding.default, headers: nil).responseJSON { (response) in
            if response.result.error == nil {
                guard let dataJson = response.data else {return}
                self.getFiveDaysTemp(data: dataJson)
                complition(true, self.weatherArr)
            }else{
                complition(false, nil)
            }
        }
    }
    
    func getFiveDaysTemp(data:Data){
        do{
            let json = try JSON(data: data).dictionary
            let jsonArray = json!["list"]?.array
            for item in jsonArray!{
                if weatherArr.count <= 14 {
                    let mainDect = item["main"].dictionary
                    let temp = mainDect!["temp"]?.doubleValue
                    let tempMax = mainDect!["temp_max"]?.doubleValue
                    let tempMin = mainDect!["temp_min"]?.doubleValue
                    let humidity = mainDect!["humidity"]?.doubleValue
                    let jsonArray = item["weather"].array
                    let desc = jsonArray?.first?["description"].stringValue
                    let rainIcon = jsonArray?.first?["icon"].stringValue ?? ""
                    let dt_txt = item["dt_txt"].string ?? ""
                    let weather = WeatherModel(description: desc!, temp: temp!, humidity: humidity!, tempMin: tempMin!, tempMax: tempMax!, wendSpeed: nil, rainVolume: nil,dt_txt:dt_txt, icon: rainIcon)
                    self.weatherArr.append(weather)
                }
            }
            
        }catch{
            debugPrint(error.localizedDescription)

        }
       
    }
    
    
    
}
