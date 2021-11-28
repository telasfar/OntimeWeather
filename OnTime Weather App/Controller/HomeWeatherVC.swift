//
//  HomeWeatherVC.swift
//  OnTime Weather App
//
//  Created by Tariq Maged on 11/25/18.
//  Copyright © 2018 Tariq. All rights reserved.
//

import UIKit
import MapKit
import CoreData

class HomeWeatherVC: UIViewController {
    
    //MARK:- vars
    var mkPointAnnotation:MKPointAnnotation?
    var isMenuOpened = false
    var isCityValid = false
    var isCountryValid = false
    var locationDB: LocationDB?
    var isChecked = false
    var newCordinate:CLLocationCoordinate2D?
    var showSearchView = false{
        didSet{
            showORHideSearchView(showSearchView)
        }
    }
    

    //MARK:- outlets
    @IBOutlet weak var imgCountry: UIImageView!
    @IBOutlet weak var imgCity: UIImageView!
    @IBOutlet weak var menuView: UIView!
    @IBOutlet weak var btnSearch: ButtonRounded!
    @IBOutlet weak var txtFieldCountry: CustomTextField!
    @IBOutlet weak var txtFieldCity: CustomTextField!
    @IBOutlet weak var mapKit: MKMapView!
    @IBOutlet weak var bottomConstraintMenu: NSLayoutConstraint!
    
    @IBOutlet weak var searchView: RoundedShadowView!
    @IBOutlet weak var searchViewHeight: NSLayoutConstraint!
    @IBOutlet weak var txtFieldBookMark: CustomTextField!
    @IBOutlet weak var lblSearchName: UILabel!
    @IBOutlet weak var checkBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.modalPresentationStyle = .fullScreen
        let value =  UIInterfaceOrientation.portrait.rawValue
        UIDevice.current.setValue(value, forKey: "orientation")
        handleAllGestures()
        setupViews()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        isMenuOpened = false
    }
    
    func setupViews(){
        checkBtn.addTarget(self, action: #selector(checkBtnPressed(_:)), for: .touchUpInside)
        searchView.isHidden = true
        searchViewHeight.constant = 0
        showORHideBookmark(false)
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action:#selector(handleTap(_:)) ))
    }
    
    func showORHideBookmark(_ show:Bool){
        checkBtn.setImage(isChecked ? #imageLiteral(resourceName: "checkedBlue"):#imageLiteral(resourceName: "unCheckedBlue") , for: .normal)
        [txtFieldBookMark,lblSearchName].forEach{
            $0?.isHidden = !show
        }
    }
    
    override var shouldAutorotate: Bool{
        return false
    }
    
    private func handleAllGestures(){
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(self.swipeRightAction))
         swipeRight.direction = UISwipeGestureRecognizerDirection.right
         view.addGestureRecognizer(swipeRight)

         let longPress = UILongPressGestureRecognizer(target: self, action: #selector(handleLongGesture))
         longPress.minimumPressDuration = 1.0
        mapKit.addGestureRecognizer(longPress)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        bottomConstraintMenu.constant = -180
        let allAnnotations = self.mapKit.annotations
        self.mapKit.removeAnnotations(allAnnotations)
        isChecked = false
        showSearchView = false
        showORHideBookmark(isChecked)
        [txtFieldCity,txtFieldCountry,txtFieldBookMark].forEach{
            $0.text = nil
        }
    }
    
    func openCloseMenu(){
        isMenuOpened = !isMenuOpened
        view.bringSubview(toFront: menuView)
        if (isMenuOpened){
            bottomConstraintMenu.constant = 0
            animateMenu(viewMwnu: menuView, moveDirect: kCATransitionFromRight)
        }else{
            bottomConstraintMenu.constant = -180
            animateMenu(viewMwnu: menuView, moveDirect: kCATransitionFromLeft)
        }
    }
    
    func showORHideSearchView(_ show:Bool){
        searchViewHeight.constant = show ? 150:0
        UIView.animate(withDuration: 0.4) {
            self.searchView.isHidden = !show
            self.view.layoutIfNeeded()
        }
        mapKit.reloadInputViews()
    }
    
    @objc func swipeRightAction(){
        bottomConstraintMenu.constant = -180
        animateMenu(viewMwnu: menuView, moveDirect: kCATransitionFromLeft)
        isMenuOpened = false
    }
    
    @objc func handleLongGesture (_ gesture : UIGestureRecognizer) {
        showSearchView = true
        let touchPoint = gesture.location(in: self.mapKit)
         newCordinate = mapKit.convert(touchPoint, toCoordinateFrom: mapKit)
        mkPointAnnotation = makeAnnotation(loc: newCordinate!)
        mapKit.addAnnotation(mkPointAnnotation!)
    }
 
    @objc func handleTap (_ gesture : UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    
    func makeAnnotation(loc:CLLocationCoordinate2D  )-> MKPointAnnotation? {
        let annotation = MKPointAnnotation()
        annotation.coordinate = loc
        return annotation
    }
    
    func searchByTextFields(city:String,country:String){
        shouldPresentLoadingView(true)
        DataService.instance.getWeatherByCity(city: city, country: country) { (success, weather) in
            if success{
                guard let weatherVC = self.storyboard?.instantiateViewController(withIdentifier: "WeatherVC") as? WeatherVC else {return}
                weatherVC.isFromMap = false
                weatherVC.weatherResource = weather
                let _ = self.saveLocations(latitude: weather?.coord?.lat ?? 0, longitude: weather?.coord?.lon ?? 0)
                self.presentDetail(weatherVC)
            }else{
                self.alertUser(message: "Connection Error")
            }
            self.shouldPresentLoadingView(false)
        }
    }
    func saveLocations(latitude:Double ,longitude:Double)->LocationDB?{
        guard let manageContext = appDelegate?.persistentContainer.viewContext else {return nil}
        var title = txtFieldBookMark.text ?? ""
        if title.isEmpty {title = "N/A"}
        locationDB = LocationDB(context: manageContext)
        locationDB!.latitude = latitude
        locationDB!.longitude = longitude
        locationDB!.locationname = title
        do {
            try     manageContext.save()
            
        }catch  {
            debugPrint(error.localizedDescription)
            
        }
       return locationDB
    }
    
    
    
    
    
    //MARK:- Actions
    @IBAction func btnMenuPressed(_ sender: UIButton) {
        openCloseMenu()
    }
    
    @objc func checkBtnPressed(_ btn:UIButton){
        isChecked = !isChecked
        showORHideBookmark(isChecked)
        if isChecked{
            txtFieldBookMark.becomeFirstResponder()
        }
    }
    
    @IBAction func btnSettingPressed(_ sender: UIButton) {
        guard let categorySB = self.storyboard?.instantiateViewController(withIdentifier: "BookMarkedVC") as? BookMarkedVC else {return}
        
        self.presentDetail(categorySB)
    }
    
    @IBAction func txtFieldCountryChanged(_ sender: CustomTextField) {
          isCountryValid = sender.text?.count ?? 0 >= 2
          imgCountry.image = isCountryValid ? #imageLiteral(resourceName: "PRGVFValid"):#imageLiteral(resourceName: "PRGVFInvalid")
        showSearchView = isCountryValid && isCityValid
      }
      
      @IBAction func txtFieldCityChanged(_ sender: CustomTextField) {
          isCityValid = sender.text?.count ?? 0 >= 3
          imgCity.image = isCityValid ? #imageLiteral(resourceName: "PRGVFValid"):#imageLiteral(resourceName: "PRGVFInvalid")
        showSearchView = isCountryValid && isCityValid
      }
      
      @IBAction func btnSearchPressded(_ sender: ButtonRounded) {
        if let _ = mkPointAnnotation{
            guard let weatherVC = self.storyboard?.instantiateViewController(withIdentifier: "WeatherVC") as? WeatherVC,let newCordinate = newCordinate else {return}
            locationDB = self.saveLocations(latitude: newCordinate.latitude, longitude: newCordinate.longitude)
            weatherVC.isFromMap = true
            if let location = locationDB {
            weatherVC.initLocation(loc: location)
            self.presentDetail(weatherVC)
            }
            return
        }
        if let city = txtFieldCity.text ,let country = txtFieldCountry.text,!city.isEmpty,!country.isEmpty{
        searchByTextFields(city: city, country: country)
        }
       
      }
}

