//
//  UISearchBar + Extension.swift
//  NotePad MVC Pattern
//
//  Created by Masaie on 27/8/22.
//

import UIKit

extension FilesViewController: UISearchBarDelegate {
    func setupSearchBar() {
            searchBar.delegate = self
            searchBar.placeholder = "Введите название..."
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filteredFiles = []
        
        if searchText == "" {
            filteredFiles = manager.elements
        }

        for file in manager.elements {
            if file.name.uppercased().contains(searchText.uppercased()) {
                filteredFiles.append(file)
            }
        }
        reloadData()
    }
}
