//
//  DataProvider.swift
//  Test task iOS - OsmAnd
//
//  Created by Stas Shetko on 2/03/20.
//  Copyright © 2020 Stas Shetko. All rights reserved.
//

import Foundation

class DataProvider: NSObject, URLSessionDownloadDelegate {
    
    let continent = "Europe"
    let regions: RootRegion
    var counties = [Country]()
    
    var downloadQueue = [Country]()
    
    let session = URLSession.shared
    let RESTUrl = "http://download.osmand.net/download.php?standard=yes&file="
    
    init(_ data: RootRegion) {
        regions = data
        super.init()
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
    
    func setCountries(_ root: RootRegion) {
        var tmp = [Country]()
        for i in root.parsedCountries! {
            if i.rawRegions.count == 1 {
                tmp.append(Country(name: i.name, isInQueue: false, urlStr: i.rawRegions.first?.value, regions: nil))
            } else {
                var areas = [Area]()
                for r in i.rawRegions {
                    areas.append(Area(name: r.key, isInQueue: false, urlStr: r.value))
                }
                tmp.append(Country(name: i.name, regions: areas))
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
                counties[i] = country
                //                counties[i].updateRegions(country.regions!)
            }
        }
    }
    
    func findCountry(_ with: URL) -> Country! {
        for c in counties {
            if with == c.url {
                return c
            }
        }
        return nil
    }
    
    func addToQueue(_ country: Country) {
        var tmp = country
        tmp.isInQueue = true
        updateCoutries(country)
        downloadQueue.append(country)
    }
    
    func downloadSequentially(_ countries: [Country], completion: @escaping (Country, URL?, URLResponse?, Error?) -> Void) {
        
        let queue = OperationQueue()
        queue.maxConcurrentOperationCount = 1
        let session = URLSession(configuration: .default, delegate: self, delegateQueue: nil)
        for c in countries {
            var tmp = c
            queue.addOperation {
                let semaphore = DispatchSemaphore(value: 0)
                tmp.isDownloading = true
                self.updateCoutries(tmp)
                
                session.downloadTask(with: c.url!, completionHandler: { (tempURL, response, error) in
                    tmp.isDownloaded = true
                    tmp.isDownloading = false
                    tmp.isInQueue = false
                    self.updateCoutries(tmp)
                    completion(tmp, tempURL, response, error)
                    semaphore.signal()
                }).resume()
                
                semaphore.wait()
            }
        }
    }
    
    //    downloadSequentially(urls) { (tempUrl, response, error) -> Void in
    //        print("Downloaded to: \(tempUrl)")
    //    }
    
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        print(#function)
        print("totalBytesExpectedToWrite")
        print(totalBytesExpectedToWrite)
        print("totalBytesWritten")
        
        print(totalBytesWritten)
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        print(#function)
        
    }
    
}
//MARK: - AREA
struct Area {
    let name: String
    var isInQueue = false
    let urlStr: String
    
    let RESTUrl = "http://download.osmand.net/download.php?standard=yes&file="
    var isDownloading = false
    var downloadingProgress: Float = 0.0
    var isDownloaded = false
    var url: URL? {
        return URL(string: RESTUrl + urlStr)
    }
    
    mutating func toggleDownloading() {
        isInQueue = !isInQueue
    }
}
//MARK: - COUNTRY
struct Country {
    let RESTUrl = "http://download.osmand.net/download.php?standard=yes&file="
    let name: String
    var isInQueue = false
    var isDownloading = false
    var downloadingProgress: Float = 0.0
    var urlStr: String?
    var url: URL? {
        return URL(string: RESTUrl + urlStr!)
    }
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
        isInQueue = !isInQueue
    }
    
    mutating func updateRegions(_ regions: [Area]) {
        for i in 0..<self.regions!.count {
            self.regions![i].isInQueue = regions[i].isInQueue
        }
    }
    
}
