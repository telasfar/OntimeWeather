//
//  DetailsView.swift
//  OnTime Weather App
//
//  Created by Tariq Maged on 26/11/2021.
//  Copyright © 2021 Tariq. All rights reserved.
//

import UIKit

protocol DetailsViewDelegate {
    func btnLastShowPressed(_ sender: UIButton)
}

class DetailsView:UIView{
    
    //vars
    var weather:WeatherModel
    var delegate:DetailsViewDelegate?
    
    //outlets
    @IBOutlet var mainView: UIView!
    @IBOutlet weak var btnShowLast: UIButton!
    @IBOutlet weak var mainStackView: UIStackView!
    @IBOutlet weak var lblTempMAx: UILabel!
    @IBOutlet weak var lblRain: UILabel!
    @IBOutlet weak var lblWend: UILabel!
    @IBOutlet weak var lblTempMin: UILabel!
    @IBOutlet weak var lblHumedity: UILabel!
    @IBOutlet weak var lblTemp: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
    
    init(weather:WeatherModel,delegate:DetailsViewDelegate){
        self.weather = weather
        self.delegate = delegate
        super.init(frame: CGRect.zero)
        initView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initView(){
   Bundle.main.loadNibNamed("DetailsView", owner: self, options: nil)
       mainView.frame = bounds
       addSubview(mainView)
        setupViews(weather: weather)

    }
    
    
    func setupViews(weather:WeatherModel){
        let temp = String(format: "%.2f", weather.temp)
        let tempMax = String(format: "%.2f", weather.tempMax)
        let tempMin = String(format: "%.2f", weather.tempMin)
        self.lblTemp.text = "Tempreture is \(temp) \((isCelsius ?? true) ? "C":"F")"
        self.lblTempMAx.text = "MAX Temp. is \(tempMax) \((isCelsius ?? true) ? "C":"F")"
        self.lblTempMin.text = "MIN Temp is \(tempMin) \((isCelsius ?? true) ? "C":"F")"
        self.lblWend.text = "Wind Speed is \(weather.wendSpeed ?? 0) m/s"
        self.lblHumedity.text = "Humidity is \(weather.humidity) %"
        self.lblDescription.text = "Weather is \(weather.description)"
        if weather.rainVolume == 0.0 {
            self.lblRain.text = "No Chance For Rain"
        }else {
            self.lblRain.text = "Rain Volume \(weather.rainVolume ?? 0) mm"
            
        }
        btnShowLast.addTarget(self, action: #selector(btnShowLastPressed(_:)), for: .touchUpInside)
    }
    
    @objc func btnShowLastPressed(_ btn:UIButton){
        delegate?.btnLastShowPressed(btn)
    }
}
 
