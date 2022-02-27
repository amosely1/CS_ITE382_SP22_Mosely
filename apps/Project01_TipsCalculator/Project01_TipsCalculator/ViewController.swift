//
//  ViewController.swift
//  Project01_TipsCalculator
//
//  Created by Alyson Mosely on 2/23/22.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var input_BillAmount: UITextField!
    @IBOutlet weak var CalucateTipBttn: UIButton!
    @IBOutlet weak var tipAmountLbl: UILabel!
    @IBOutlet weak var input_TipPerc: UITextField!
    @IBOutlet weak var billAmountLbl: UILabel!
    
    @IBAction func calculateTip(_ sender: Any) {
        let tipAmount: Double = (Double(input_TipPerc.text!)! / 100) * Double(input_BillAmount.text!)!
        tipAmountLbl.text = "\(tipAmount)"
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }


}

