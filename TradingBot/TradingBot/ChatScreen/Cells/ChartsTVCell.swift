//
//  ChartsTVCell.swift
//  TradingBot
//
//  Created by VINIT PAWAR on 20/06/19.
//  Copyright © 2019 Tradesocio. All rights reserved.
//

import UIKit
import Charts
class ChartsTVCell: UITableViewCell {

    @IBOutlet weak var chartView: PieChartView!
    @IBOutlet weak var viewParent: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        viewParent.layer.borderColor = UIColor.black.cgColor
        viewParent.layer.borderWidth = 1.0
        viewParent.layer.cornerRadius = viewParent.frame.height / 2
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func updateChartData(arrDataSets : [ObjPortfolioModel])  {
    
        // 2. generate chart data entries
        var track = [String]()
        var money = [Float]()
        arrDataSets.forEach { (objProtfolio) in
            track.append(objProtfolio.symbol ?? "")
            money.append(objProtfolio.percAlloc ?? 0.0)
        }
        var entries = [PieChartDataEntry]()
        for (index, value) in money.enumerated() {
            let entry = PieChartDataEntry()
            entry.y = Double(value)
            entry.label = track[index]
            entries.append( entry)
        }
        
        // 3. chart setup
        let set = PieChartDataSet( entries: entries, label: "Pie Chart")
        // this is custom extension method. Download the code for more details.
        var colors: [UIColor] = []
        
        for _ in 0..<money.count {
            let red = Double(arc4random_uniform(256))
            let green = Double(arc4random_uniform(256))
            let blue = Double(arc4random_uniform(256))
            let color = UIColor(red: CGFloat(red/255), green: CGFloat(green/255), blue: CGFloat(blue/255), alpha: 1)
            colors.append(color)
        }
        set.colors = colors
        let data = PieChartData(dataSet: set)
        chartView.data = data
        chartView.noDataText = "No data available"
        // user interaction
        chartView.isUserInteractionEnabled = true
        
        let d = Description()
        d.text = "Tradesocio"
        chartView.chartDescription = d
        chartView.centerText = "Portfolio"
        chartView.holeRadiusPercent = 0.2
        chartView.transparentCircleColor = UIColor.clear
        
    }
    
}
