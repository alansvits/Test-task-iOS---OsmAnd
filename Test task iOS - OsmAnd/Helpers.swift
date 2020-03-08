import Foundation

struct RootRegion : Codable {
    
    let region : [Region]?
    
    private(set) var coutnries: [String]?
    
    private(set) var parsedCountries: [Country]?
    
    enum CodingKeys: String, CodingKey {
        case region = "region"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        region = try values.decodeIfPresent([Region].self, forKey: .region)
        setCountryNames()
        parsedCountries = getParsedCountries()
    }
    
    var europe: [Region]? {
        let tmp = region?.filter { $0.name == "europe" }
        return tmp?[0].region
    }
    
    private mutating func setCountryNames() {
        guard let eu = europe else { coutnries = nil; return }
        var countryList = [String]()
        for country in eu {
            if country.type != nil {
                continue
            } else {
                guard let name = country.name else { continue }
                if name == "gb" {
                    countryList.append(contentsOf: parseGB(country))
                } else {
                    countryList.append(name)
                }
            }
            
        }
        coutnries = countryList.sorted()
        //        coutnries!.forEach{print($0)}
    }
    
    private func getURL() -> [String:String]? {
        guard let eu = europe else { return nil }
        var tmpR = [String:String]()
        
        for c in eu {//gb
            
            if hasMap(c) {
                //                print(c.name!)
                
                let url = createURLString(nil, for: c.name!)
                tmpR["\(c.name!)"] = url
                //                print(tmpR)
            }
            //            print(c.name!)
            
            if let r = c.region {
                //                print("r \(r.count)")
                for subR in r {//sub england
                    //                    print("subR \(subR)")
                    if let subSubR = subR.region {
                        //                        print("subSubR \(subSubR.count)")
                        
                        for subSubSubR in subSubR { //channel-islands
                            if let subSubSubSubR = subSubSubR.region {
                                for sub5R in subSubSubSubR { //jersey
                                    if hasMap(sub5R) {
                                        let url = createURLString(subSubSubR.name!, for: sub5R.name!)
                                        tmpR["\(sub5R.name!)"] = url
                                    } else {continue}
                                }
                            } else {
                                if hasMap(subSubSubR) {
                                    let url = createURLString(subR.innerDownloadPrefix!, for: subSubSubR.name!)
                                    tmpR["\(subSubSubR.name!)"] = url
                                }
                            }
                        }
                    } else {
                        //                        print("subR.name \(subR.name)")
                        
                        if hasMap(subR) {
                            //                            print("subR.name \(subR.name)")
                            let url = createURLString(c.name!, for: subR.name!)
                            tmpR["\(subR.name!)"] = url
                        }
                    }
                }
            } else {
                //                print("c.name \(c.name)")
                if hasMap(c) {
                    
                    let url = createURLString(nil, for: c.name!)
                    tmpR["\(c.name!)"] = url
                }
            }
        }
        return tmpR
    }
    
    
    //MARK: -
    
    struct Country {
        let name: String
        var rawRegions: [String:String]
        
        var isDownloading = false
        
        var regionNames: [String] {
            var res = [String]()
            for i in rawRegions {
                res.append(i.key)
            }
            return res.sorted()
        }
        
        func getURLString(_ name: String) -> String? {
            var res: String?
            for r in rawRegions {
                if r.key == name {
                    res = r.value
                } else {
                    res = nil
                }
            }
            return res
        }
    
    }
    
    private func getParsedCountries() -> [Country] {
        let countries = coutnries!
        let urls = getURL()!
        var result = [Country]()
        var regions = [String:String]()
        for c in countries {
            for url in urls {
                if url.value.lowercased().contains(c) {
                    regions[url.key] = url.value
                }
            }
            result.append(Country(name: c, rawRegions: regions))
            
            regions = [String:String]()
        }
        return result
    }
    
    private func parseGB(_ region: Region) -> [String] {
        var gb = [String]()
        for i in region.region! {
            gb.append(i.name!)
        }
        return gb
    }
    
    private func createURLString(_ prefix: String?, for name: String) -> String {
        let end = "_2.obf.zip"
        let suffix = "europe"
        if let prefix = prefix {
            return  prefix.capitalizingFirstLetter() + "_" + name + "_" + suffix + end
        } else {
            return name.capitalizingFirstLetter() + "_" + suffix + end
        }
    }
    
    private func hasMap(_ region: Region) -> Bool {
        if region.type == nil {
            guard let map = region.map else { return true }
            if map == "yes" {
                return true
            } else {
                return false
            }
        } else {
            return false
        }
    }
    
}

struct Region : Codable {
    
    let type : String?
    let innerDownloadSuffix : String?
    
    let boundary : String?
    let hillshade : String?
    let innerDownloadPrefix : String?
    
    let joinMapFiles : String?
    let joinRoadFiles : String?
    let lang : String?
    let leftHandNavigation : String?
    let map : String?
    let metric : String?
    let name : String?
    let polyExtract : String?
    let roads : String?
    let srtm : String?
    let translate : String?
    let region : [Region]?
    
    enum CodingKeys: String, CodingKey {
        case type = "_type"
        case innerDownloadSuffix = "_inner_download_suffix"
        
        case boundary = "_boundary"
        case hillshade = "_hillshade"
        case innerDownloadPrefix = "_inner_download_prefix"
        case joinMapFiles = "_join_map_files"
        case joinRoadFiles = "_join_road_files"
        case lang = "_lang"
        case leftHandNavigation = "_left_hand_navigation"
        case map = "_map"
        case metric = "_metric"
        case name = "_name"
        case polyExtract = "_poly_extract"
        case roads = "_roads"
        case srtm = "_srtm"
        case translate = "_translate"
        case region = "region"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        type = try values.decodeIfPresent(String.self, forKey: .type)
        innerDownloadSuffix = try values.decodeIfPresent(String.self, forKey: .innerDownloadSuffix)
        
        boundary = try values.decodeIfPresent(String.self, forKey: .boundary)
        hillshade = try values.decodeIfPresent(String.self, forKey: .hillshade)
        innerDownloadPrefix = try values.decodeIfPresent(String.self, forKey: .innerDownloadPrefix)
        joinMapFiles = try values.decodeIfPresent(String.self, forKey: .joinMapFiles)
        joinRoadFiles = try values.decodeIfPresent(String.self, forKey: .joinRoadFiles)
        lang = try values.decodeIfPresent(String.self, forKey: .lang)
        leftHandNavigation = try values.decodeIfPresent(String.self, forKey: .leftHandNavigation)
        map = try values.decodeIfPresent(String.self, forKey: .map)
        metric = try values.decodeIfPresent(String.self, forKey: .metric)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        polyExtract = try values.decodeIfPresent(String.self, forKey: .polyExtract)
        roads = try values.decodeIfPresent(String.self, forKey: .roads)
        srtm = try values.decodeIfPresent(String.self, forKey: .srtm)
        translate = try values.decodeIfPresent(String.self, forKey: .translate)
        region = try values.decodeIfPresent([Region].self, forKey: .region)
    }
    
    
    
}


//if let path = Bundle.main.path(forResource: "region_json", ofType: "json") {
//    do {
//        let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .alwaysMapped)
//        let decoder = JSONDecoder()
//        let root = try decoder.decode(RootRegion.self, from: data)
//        //        print("\(root.region![0].type)")
//        //        print(root.coutnries?.count)
//
//        root.parsedCountries!.forEach{ print($0.getURLString($0.name)) }
//
//    } catch let error {
//        print("parse error: \(error.localizedDescription)")
//    }
//} else {
//    print("Invalid filename/path.")
//}



