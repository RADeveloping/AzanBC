//
//  ViewController.swift
//  AzanBC
//
//  Created by Charlie on 2020-06-16.
//  Copyright © 2020 RADeveloping. All rights reserved.
//

import UIKit
import Foundation

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UICollectionViewDelegate, UICollectionViewDataSource {
    
    let array = [#imageLiteral(resourceName: "azLogo"),#imageLiteral(resourceName: "mymLogo"),#imageLiteral(resourceName: "ghadirLogo"),#imageLiteral(resourceName: "imamZamanLogo")];
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return array.count;
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! ImageCollectionViewCell
        
        cell.imageView.image = array[indexPath.row];
        
        
        return cell
    }
    
    @IBOutlet weak var tableView: UITableView!
    
    var prayerTimeResult : [PrayerTime] = []
    var diffInDays : Int = 0
    
    class PrayerTime: Codable {
        let d_date: String
        let fajr_begins: String
        let sunrise: String
        let zuhr_begins: String
        let asr_mithl_1: String
        let maghrib_begins: String
        let isha_begins: String


        
        init(d_date: String, fajr_begins: String, sunrise: String,zuhr_begins: String,asr_mithl_1: String,maghrib_begins: String, isha_begins: String) {
            self.d_date = d_date;
            self.fajr_begins = fajr_begins;
            self.sunrise = sunrise;
            self.zuhr_begins = zuhr_begins;
            self.asr_mithl_1 = asr_mithl_1;
            self.maghrib_begins = maghrib_begins;
            self.isha_begins = isha_begins;
        }
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? PrayerCell else {
            fatalError("The cell is not an instance of PrayerCell")
        }
        
        switch indexPath.row {
        case 0:
                   cell.nameLabel.text = "Imsaak"
                   cell.timeLabel.text = timeConversion12(time24: prayerTimeResult[diffInDays].fajr_begins);
        case 1:
            cell.nameLabel.text = "Fajr"
            cell.timeLabel.text = timeConversion12(time24:prayerTimeResult[diffInDays].fajr_begins);
        case 2:
            cell.nameLabel.text = "Sunrise"
            cell.timeLabel.text = timeConversion12(time24:prayerTimeResult[diffInDays].zuhr_begins);
        case 3:
            cell.nameLabel.text = "Zuhr"
            cell.timeLabel.text = timeConversion12(time24:prayerTimeResult[diffInDays].asr_mithl_1);
        case 4:
            cell.nameLabel.text = "Sunset"
            cell.timeLabel.text = timeConversion12(time24:prayerTimeResult[diffInDays].maghrib_begins);
        case 5:
            cell.nameLabel.text = "Maghrib"
            cell.timeLabel.text = timeConversion12(time24:prayerTimeResult[diffInDays].isha_begins);
        default:
            cell.nameLabel.text = ""
        }
        
       


        return cell;
    }

    func timeConversion12(time24: String) -> String {
        let dateAsString = time24
        let df = DateFormatter()
        df.dateFormat = "HH:mm:ss"

        let date = df.date(from: dateAsString)
        df.dateFormat = "hh:mm a"

        let time12 = df.string(from: date!)
        return time12
    }
    

    func setupTableView(){
        tableView.delegate = self;
        tableView.dataSource = self;
    }
    
  
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupTableView();
        
        let prayerTimeDecoder = JSONDecoder();

        if let filepath = Bundle.main.path(forResource: "yearly-prayer-time", ofType: "json") {
            do {
                let prayerJSON = try String(contentsOfFile: filepath).data(using: .utf8)!

                do{
                        prayerTimeResult = try prayerTimeDecoder.decode([PrayerTime].self, from: prayerJSON)
                   
                    let formatter = DateFormatter()
                    formatter.dateFormat = "yyyy/MM/dd"
                    let firstDate = formatter.date(from: "2019/01/01")!;
                    let currentDateTime = Date();


                     diffInDays = Calendar.current.dateComponents([.day], from: firstDate, to: currentDateTime).day! - 1
                
                   

                    }catch{
                        print("Failed to decode")
                    }
                
            } catch {
                print("Something went wrong, content could not be loaded");
            }
        } else {
            print("JSON file not found");
        }
        

    }

}

