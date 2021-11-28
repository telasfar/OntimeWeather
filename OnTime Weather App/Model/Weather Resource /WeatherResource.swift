//
//  WeatherResource.swift
//  Arkan
//
//  Created by BinaryCase on 1/2/19.
//  Copyright © 2019 Tariq. All rights reserved.
//

import Foundation
struct WeatherResource : Codable {
	let coord : Coord?
	let weather : [Weather]?
	let base : String?
	let main : MainWeather?
	let visibility : Int?
	let wind : Wind?
	let clouds : Clouds?
	let dt : Int?
	let sys : WeatherSys?
	let timezone : Int?
	let id : Int?
	let name : String?
	let cod : Int?

	enum CodingKeys: String, CodingKey {

		case coord = "coord"
		case weather = "weather"
		case base = "base"
		case main = "main"
		case visibility = "visibility"
		case wind = "wind"
		case clouds = "clouds"
		case dt = "dt"
		case sys = "sys"
		case timezone = "timezone"
		case id = "id"
		case name = "name"
		case cod = "cod"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		coord = try values.decodeIfPresent(Coord.self, forKey: .coord)
		weather = try values.decodeIfPresent([Weather].self, forKey: .weather)
		base = try values.decodeIfPresent(String.self, forKey: .base)
		main = try values.decodeIfPresent(MainWeather.self, forKey: .main)
		visibility = try values.decodeIfPresent(Int.self, forKey: .visibility)
		wind = try values.decodeIfPresent(Wind.self, forKey: .wind)
		clouds = try values.decodeIfPresent(Clouds.self, forKey: .clouds)
		dt = try values.decodeIfPresent(Int.self, forKey: .dt)
		sys = try values.decodeIfPresent(WeatherSys.self, forKey: .sys)
		timezone = try values.decodeIfPresent(Int.self, forKey: .timezone)
		id = try values.decodeIfPresent(Int.self, forKey: .id)
		name = try values.decodeIfPresent(String.self, forKey: .name)
		cod = try values.decodeIfPresent(Int.self, forKey: .cod)
	}

}
