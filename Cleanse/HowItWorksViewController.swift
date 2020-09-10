//
//  HowItWorksViewController.swift
//  Cleanse
//
//  Created by Alek Matthiessen on 6/7/20.
//  Copyright © 2020 The Matthiessen Group, LLC. All rights reserved.
//

import UIKit

class HowItWorksViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
      func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
                
                return 1

            }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Works", for: indexPath) as! HOwitWorksTableViewCell
        
        return cell
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func tapBack(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
