//
//  SettinsTableViewController.swift
//  NotePad MVC Pattern
//
//  Created by Masaie on 19/8/22.
//

import UIKit

class SettingsViewer: UITableViewController {
    
    private let settingsList: [String] = ["Шрифт и размер", "Вид и цвет", "О программе!"]
    
    // MARK: - Public Properties
    
    var color: UIColor!
    var delegate: SettingsDelegate!
    var font: UIFont!

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settingsList.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Setting", for: indexPath)
        var content = cell.defaultContentConfiguration()
        content.text = settingsList[indexPath.row].description
        cell.contentConfiguration = content
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            performSegue(withIdentifier: "font", sender: nil)
        } else if indexPath.row == 1 {
            performSegue(withIdentifier: "color", sender: nil)
        } else {
            let vc = AboutApp()
            self.present(vc, animated: true)
        }
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let nav = segue.destination as? UINavigationController else { return }
        if segue.identifier == "color" {
            guard let colorVC = nav.topViewController as? ColorController else { return }
            colorVC.delegate = delegate
            colorVC.color = color
        } else if segue.identifier == "font" {
            guard let colorVC = nav.topViewController as? FontAndSizeViewer else { return }
            colorVC.textViewFont = font
            colorVC.delegate = delegate
        }
    }
    
    @IBAction func doneButtonPressed(_ sender: UIBarButtonItem) {
        dismiss(animated: true)
    }
}
