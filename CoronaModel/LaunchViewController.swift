//
//  LaunchViewController.swift
//  CoronaModel
//
//  Created by Jonathan Julius Kampf on 4/28/20.
//  Copyright © 2020 CarolineEvans. All rights reserved.
//

import UIKit

class LaunchViewController: UIViewController {
    
    /*
     ViewController for the launch screen. 
     */
    
    @IBOutlet var distanceLabel: UILabel!
    @IBOutlet weak var populationLabel: UITextField!
    @IBOutlet weak var sickLabel: UITextField!
    @IBOutlet weak var durationLabel: UITextField!
    
    var distance = ""
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        populationLabel.delegate = self
        sickLabel.delegate = self
        durationLabel.delegate = self

        // Do any additional setup after loading the view.
    }
    
    /*
     Listener for the slider
     and sets text accordingly
     */
    @IBAction func distanceSlider(_ sender: UISlider) {
        distanceLabel.text = String(Int(sender.value))
    }

    // Makes the number pad go away when the user
    // touches the screen signaling that they
    // are done entering input
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        populationLabel.resignFirstResponder()
        sickLabel.resignFirstResponder()
        durationLabel.resignFirstResponder()
    }
    
    /*
     Segues into the main view
     */
    @IBAction func runSimulation(_ sender: UIButton) {
        self.distance = distanceLabel.text!
        performSegue(withIdentifier: "launch", sender: self)
        
    }
    
    // Passes in input information to the main ViewController
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "launch") {
            
            if var vc = segue.destination as? ViewController {
                vc.modalPresentationStyle = .fullScreen
                vc.socialDistance = Int(self.distance) ?? 50
                vc.initialCases = Int(populationLabel.text!) ?? 100
                vc.initialSick = Int(sickLabel.text!) ?? 2
                vc.duration = Int(durationLabel.text!) ?? 30
            }
            
            self.populationLabel.text! = ""
            self.sickLabel.text! = ""
            self.durationLabel.text! = ""
        }
        
    }
    
}

/*
 Extension to handle text field input and move with the keyboard
 */
extension LaunchViewController : UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        moveTextField(textField, moveDistance: -250, up: true)
    }
    

    func textFieldDidEndEditing(_ textField: UITextField) {
        moveTextField(textField, moveDistance: -250, up: false)
    }
    
    func moveTextField(_ textField: UITextField, moveDistance: Int, up: Bool) {
        let moveDuration = 0.3
        let movement: CGFloat = CGFloat(up ? moveDistance : -moveDistance)
        UIView.animate(withDuration: moveDuration, animations: {
            self.view.frame = self.view.frame.offsetBy(dx: 0, dy: movement)
        })
    }
    
   
}
