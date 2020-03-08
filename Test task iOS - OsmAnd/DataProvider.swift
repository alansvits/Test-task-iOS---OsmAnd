//
//  DataProvider.swift
//  Test task iOS - OsmAnd
//
//  Created by Stas Shetko on 2/03/20.
//  Copyright © 2020 Stas Shetko. All rights reserved.
//

import Foundation

class DataProvider {
    
    let regions: RootRegion
    
    init(_ data: RootRegion) {
        regions = data
        setCountries(data)
    }
    func getCountryWith(_ name: String) -> RootRegion.Country? {
        for i in regions.parsedCountries! {
            if i.name == name {
                return i
            }
        }
        return nil
    }
    var selectedCountry: RootRegion.Country?
    
    var counties = [Country]()
    
    func setCountries(_ root: RootRegion) {
        var tmp = [Country]()
        for i in root.parsedCountries! {
            if i.rawRegions.count == 1 {
                var c = Country(name: i.name, isDownloading: false, urlStr: i.rawRegions.first?.value, regions: nil)
                tmp.append(c)
            } else {
                var areas = [Area]()
                for r in i.rawRegions {
                    var a = Area(name: r.key, isDownloading: false, urlStr: r.value)
                    areas.append(a)
                }
                var c = Country(name: i.name, regions: areas)
                tmp.append(c)
            }
        }
        counties = tmp
    }
    
    
}

struct Area {
    let name: String
    var isDownloading = false
    let urlStr: String
}

struct Country {
    let name: String
    var isDownloading = false
    var urlStr: String?
    let regions: [Area]?
    var isDownloaded = false
    
}

