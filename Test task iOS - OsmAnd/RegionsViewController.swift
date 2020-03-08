//
//  RegionsViewController.swift
//  Test task iOS - OsmAnd
//
//  Created by Stas Shetko on 2/03/20.
//  Copyright © 2020 Stas Shetko. All rights reserved.
//

import UIKit

class RegionsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var dataProvider: DataProvider?
    var selectedCountryName = ""
    
    
    @IBOutlet weak var tableViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setColorStatusBar()
        setDataProvider()
        title = dataProvider?.selectedCountry?.name
        //        memoryUIView.isHidden = true
        //        dataProvider?.regions.parsedCountries?.forEach { print($0.rawRegions)}
        navigationController?.navigationBar.topItem?.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        dataProvider?.selectedCountry = dataProvider!.getCountryWith(selectedCountryName)
    }
}

//MARK: - UITableViewDelegate, UITableViewDataSource
extension RegionsViewController {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataProvider!.selectedCountry!.regionNames.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MainTableViewCellIdentifier", for: indexPath) as? MainTableViewCell else { return UITableViewCell() }
        cell.countryNameLabel.text = dataProvider!.selectedCountry?.regionNames[indexPath.row]
        cell.downloadImageView.image = UIImage(named: "ic_custom_dowload")
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! MainTableViewCell
        cell.toggleDownloanProgressView()
        
        
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Regions".uppercased()
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
extension RegionsViewController {
    private func setColorStatusBar() {
        let app = UIApplication.shared
        let statusBarHeight: CGFloat = app.statusBarFrame.size.height
        let statusbarView = UIView()
        statusbarView.backgroundColor = UIColor(red:1.00, green:0.53, blue:0.00, alpha:1.0)
        //        statusbarView.backgroundColor = UIColor(hexString: "#FF8800")
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
}
