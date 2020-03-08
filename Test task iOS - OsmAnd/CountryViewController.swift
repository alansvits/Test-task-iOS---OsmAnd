//
//  ViewController.swift
//  Test task iOS - OsmAnd
//
//  Created by Stas Shetko on 2/03/20.
//  Copyright © 2020 Stas Shetko. All rights reserved.
//

import UIKit

class CountryViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var dataProvider: DataProvider?
    
    @IBOutlet weak var freeGbLabel: UILabel!
    @IBOutlet weak var freeMemoryProgressView: UIProgressView!
    @IBOutlet weak var memoryUIView: UIView!
    @IBOutlet weak var tableViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setColorStatusBar()
        setDataProvider()
        setMemoryProgressView()
        setFreeGbLabel()

        if memoryUIView.isHidden == true {
            tableViewTopConstraint = tableView.topAnchor.constraint(equalTo: view.topAnchor)
            tableViewTopConstraint.isActive = true
        }
        
        dataProvider?.counties.forEach({ (c) in
            if let r = c.regions {
                print(c.name)
                for i in r {
                    print(i)
                }
            } else {
                print(c)
            }
        })

    }
    
//    override func layoutSubviews() {
//        super.layoutSubviews()
////
////        let maskLayerPath = UIBezierPath(roundedRect: bounds, cornerRadius: 4.0)
////        let maskLayer = CAShapeLayer()
////        maskLayer.frame = self.bounds
////        maskLayer.path = maskLayerPath.cgPath
////        layer.mask = maskLayer
//    }

}


//MARK: - UITableViewDelegate, UITableViewDataSource
extension CountryViewController {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        dataProvider!.regions.parsedCountries!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MainTableViewCellIdentifier", for: indexPath) as? MainTableViewCell else { return UITableViewCell() }
        cell.countryNameLabel.text = dataProvider!.regions.parsedCountries![indexPath.row].name
        cell.isDownloading = dataProvider!.regions.parsedCountries![indexPath.row].isDownloading
        if dataProvider?.regions.parsedCountries![indexPath.row].rawRegions.count == 1 {
            cell.downloadImageView.image = UIImage(named: "ic_custom_dowload")
        } else {
            cell.downloadImageView.image = UIImage(named: "ic_custom_chevron")
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if dataProvider!.regions.parsedCountries![indexPath.row].regionNames.count != 1 {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "RegionsViewControllerStoryboardID") as! RegionsViewController
            vc.dataProvider = dataProvider
            vc.selectedCountryName = dataProvider!.regions.parsedCountries![indexPath.row].name
            navigationController?.pushViewController(vc, animated: true)
        } else {
            let cell = tableView.cellForRow(at: indexPath) as! MainTableViewCell
            dataProvider?.selectedCountry = dataProvider?.getCountryWith((dataProvider?.regions.parsedCountries![indexPath.row].name)!)
            dataProvider?.selectedCountry?.isDownloading = true
            cell.toggleDownloanProgressView()
        }


    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Europe".uppercased()
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int)
    {
        let headerView = view as! UITableViewHeaderFooterView
        headerView.textLabel?.textColor = UIColor(hexString: "#978FA3")
        headerView.backgroundColor = UIColor(hexString: "#E5E5E5")
        headerView.textLabel?.font = UIFont.systemFont(ofSize: 13.00)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 1 {
            return 44.0
        } else {
            return 44.0
        }
    }
}

//MARK: - Helpers
extension CountryViewController {
    private func setColorStatusBar() {
        let app = UIApplication.shared
        let statusBarHeight: CGFloat = app.statusBarFrame.size.height
        let statusbarView = UIView()
//        statusbarView.backgroundColor = UIColor(red:1.00, green:0.53, blue:0.00, alpha:1.0)
                statusbarView.backgroundColor = UIColor(hexString: "#FF8800")
        view.addSubview(statusbarView)
        
        statusbarView.translatesAutoresizingMaskIntoConstraints = false
        statusbarView.heightAnchor
            .constraint(equalToConstant: statusBarHeight).isActive = true
        statusbarView.widthAnchor
            .constraint(equalTo: view.widthAnchor, multiplier: 1.0).isActive = true
        statusbarView.topAnchor
            .constraint(equalTo: view.topAnchor).isActive = true
        statusbarView.centerXAnchor
            .constraint(equalTo: view.centerXAnchor).isActive = true
    }
    
    private func setDataProvider() {
        if let path = Bundle.main.path(forResource: "region_json", ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .alwaysMapped)
                let decoder = JSONDecoder()
                let root = try decoder.decode(RootRegion.self, from: data)
                dataProvider = DataProvider(root)
            } catch let error {
                print("parse error: \(error.localizedDescription)")
            }
        } else {
            print("Invalid filename/path.")
        }
    }
    
    fileprivate func setMemoryProgressView() {
        freeMemoryProgressView.setProgress(UIDevice.current.getUsedDiskSpaceInPercentage(), animated: true)
    }
    
    fileprivate func setFreeGbLabel() {
        freeGbLabel.text = "Free " + UIDevice.current.freeDiskSpaceInGB.lowerCaseLastLetter()
    }
}
