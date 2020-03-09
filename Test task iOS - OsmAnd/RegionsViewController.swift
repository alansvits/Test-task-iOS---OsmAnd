//
//  RegionsViewController.swift
//  Test task iOS - OsmAnd
//
//  Created by Stas Shetko on 2/03/20.
//  Copyright © 2020 Stas Shetko. All rights reserved.
//

import UIKit

protocol RegionsViewControllerDelegate: class {
    func regionsViewController(update country: Country)
}

class RegionsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var tableView: UITableView!
    
    weak var delegate: RegionsViewControllerDelegate?
    
    var downloadQueue = [Area]()
    
    var selectedCountry: Country! {
        didSet {
            selectedCountry.regions?.sort(by: { (a1, a2) -> Bool in
                a1.name > a2.name
            })
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setColorStatusBar()
        title = selectedCountry?.name.capitalized
        navigationController?.navigationBar.topItem?.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
}

//MARK: - UITableViewDataSource
extension RegionsViewController {
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return selectedCountry.regions!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MainTableViewCellIdentifier", for: indexPath) as? MainTableViewCell else { return UITableViewCell()
        }
        let strName = selectedCountry.regions![indexPath.row].name.components(separatedBy: "-").joined(separator: " ").capitalized
        cell.countryNameLabel.text = strName
        if selectedCountry.regions![indexPath.row].isDownloaded {
            cell.downloadImageView.image = UIImage(named: "ic_custom_dowload_green")
        } else {
            cell.downloadImageView.image = UIImage(named: "ic_custom_dowload")
        }
        cell.isDownloading = selectedCountry.regions![indexPath.row].isInQueue
        cell.downloadProgressView.progress = selectedCountry.regions![indexPath.row].downloadingProgress
        return cell
    }
    
//MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! MainTableViewCell
        selectedCountry.regions![indexPath.row].toggleDownloading()
        cell.toggleDownloanProgressView()
        delegate?.regionsViewController(update: selectedCountry)
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
    
}


