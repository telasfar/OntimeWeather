//
//  Constants.swift
//  OnTime Weather App

//  Copyright © 2018 Tariq. All rights reserved.


import Foundation
import UIKit
//vars
let appDelegate = UIApplication.shared.delegate as? AppDelegate

//typealias
typealias complitionHandlerMessage = (_ status:Bool,_ weather:WeatherModel?)->()
typealias complitionHandlerArray = (_ status:Bool,_ weather:[WeatherModel]?)->()
typealias complitionHandlerWeather = (_ status:Bool,_ weather:WeatherResource?)->()


//API
 let API_KEY:String="67fe775b50280a120a0df434ca75059f"

func getMapURL (lat:Double,long:Double,mode:String)->String{
    return "http://api.openweathermap.org/data/2.5/\(mode)?lat=\(lat)&lon=\(long)&appid=\(API_KEY)&units=\(TemperatureType.tempType)"
}

func getURLByCity(city:String,country:String)->String{
    return "http://api.openweathermap.org/data/2.5/weather?q=\(city),\(country)&appid=\(API_KEY)&units=\(TemperatureType.tempType)"
}

func getImgUrl(iconName:String)->String{
    return "http://openweathermap.org/img/wn/\(iconName)@2x.png"
}

enum TemperatureType:String{
    case celsius = "metric"
    case fahrenheit = "imperial"
    
    static var tempType:String{
        get{
            (isCelsius ?? true) ? self.celsius.rawValue:self.fahrenheit.rawValue
        }
    }
}

var latitude: Double? {
        get {
            return UserDefaults.standard.double(forKey: "applatitude")
        } set {
            UserDefaults.standard.set(newValue, forKey: "applatitude")
            UserDefaults.standard.synchronize()
        }
    }

var longitude: Double? {
        get {
            return UserDefaults.standard.double(forKey: "applongitude")
        } set {
            UserDefaults.standard.set(newValue, forKey: "applongitude")
            UserDefaults.standard.synchronize()
        }
    }

var isCelsius: Bool? {
        get {
            return UserDefaults.standard.bool(forKey: "isCelsius")
        } set {
            UserDefaults.standard.set(newValue, forKey: "isCelsius")
            UserDefaults.standard.synchronize()
        }
    }
