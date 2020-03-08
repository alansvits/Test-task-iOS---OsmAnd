//
//  DataProvider.swift
//  Test task iOS - OsmAnd
//
//  Created by Stas Shetko on 2/03/20.
//  Copyright © 2020 Stas Shetko. All rights reserved.
//

import Foundation



class DataProvider {
    
    let continent = "Europe"
    
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
        counties = tmp.sorted(by: { (c1, c2) -> Bool in
            c1.name < c2.name
        })
    }
    
    func getCountry(_ name: String) -> Country? {
        for c in counties {
            if c.name == name.lowercased() {
                return c
            }
        }
        return nil
    }
    
    func updateCoutries(_ country: Country) {
        for i in 0..<counties.count {
            if counties[i].name == country.name {
                counties[i].updateRegions(country.regions!)
            }
        }
    }
  
}

struct Area {
    let name: String
    var isDownloading = false
    let urlStr: String
    
    mutating func toggleDownloading() {
        isDownloading = !isDownloading
    }
}

struct Country {
    let name: String
    var isDownloading = false
    var urlStr: String?
    var regions: [Area]? {
        didSet {
            regions!.sort { (a, b) -> Bool in
                a.name > b.name
            }
        }
    }
    var isDownloaded = false
    
    var hasArea: Bool {
        regions == nil ? false: true
    }
    
    
    mutating func toggleDownloading() {
        isDownloading = !isDownloading
    }
    
    mutating func updateRegions(_ regions: [Area]) {
        for i in 0..<self.regions!.count {
            self.regions![i].isDownloading = regions[i].isDownloading
        }
    }
    
}

