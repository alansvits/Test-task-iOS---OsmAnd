//
//  NetworkManager.swift
//  Test task iOS - OsmAnd
//
//  Created by Stas Shetko on 2/03/20.
//  Copyright © 2020 Stas Shetko. All rights reserved.
//

import Foundation

//class NetworkManager {
//
//    let RESTUrl = "http://download.osmand.net/download.php?standard=yes&file="
//    let session = URLSession.shared
//
//    static let shared = NetworkManager()
//
//    private init() {
//
//    }
//
//    func download(<#parameters#>) -> <#return type#> {
//        <#function body#>
//    }
//    let task = session.dataTask(with: url, completionHandler: { data, response, error in
//
//        // Do something...
//    })
//
//}
//let urls = [
//    URL(string: "https://github.com/fluffyes/AppStoreCard/archive/master.zip")!,
//    URL(string: "https://github.com/fluffyes/currentLocation/archive/master.zip")!,
//    URL(string: "https://github.com/fluffyes/DispatchQueue/archive/master.zip")!,
//    URL(string: "https://github.com/fluffyes/dynamicFont/archive/master.zip")!,
//    URL(string: "https://github.com/fluffyes/telegrammy/archive/master.zip")!
//]
//
//func downloadSequentially(_ urls: [URL], completion: @escaping (URL?, URLResponse?, Error?) -> Void) {
//    // Queues are automatically retained until all operations are completed
//    // (see https://developer.apple.com/documentation/foundation/operationqueue)
//    let queue = OperationQueue()
//    queue.maxConcurrentOperationCount = 1
//    
//    for url in urls {
//        queue.addOperation {
//            let semaphore = DispatchSemaphore(value: 0)
//            
//            URLSession.shared.downloadTask(with: url, completionHandler: { (tempURL, response, error) in
//                completion(tempURL, response, error)
//                semaphore.signal()
//            }).resume()
//            
//            semaphore.wait()
//        }
//    }
//}
//
//downloadSequentially(urls) { (tempUrl, response, error) -> Void in
//    print("Downloaded to: \(tempUrl)")
//}
