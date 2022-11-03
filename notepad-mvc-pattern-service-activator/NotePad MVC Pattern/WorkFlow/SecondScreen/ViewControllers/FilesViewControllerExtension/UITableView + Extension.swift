//
//  FilesViewController + Extension.swift
//  NotePad MVC Pattern
//
//  Created by Sabir Myrzaev on 23.08.2022.
//

import UIKit

extension FilesViewController: UITableViewDelegate {
    func setUpTableView() {
        foldersTableView.delegate = self
        foldersTableView.dataSource = self
        filteredFiles = manager.elements
        foldersTableView.allowsMultipleSelection = true
        foldersTableView.register(UINib(nibName: "CustomTableViewCell", bundle: nil),
                                  forCellReuseIdentifier: CustomTableViewCell.id)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        handleCellTap(indexPath: indexPath)
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        handleCellTap(indexPath: indexPath)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}

extension FilesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredFiles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let element = filteredFiles.isEmpty ? manager.elements[indexPath.row] : filteredFiles[indexPath.row]
        let tableViewCell = getDirectoryCell(tableView, element: element)
        return tableViewCell
    }
    
    private func getDirectoryCell(_ tableView: UITableView, element: Element) -> UITableViewCell {
        guard let tableViewCell = tableView.dequeueReusableCell(withIdentifier: CustomTableViewCell.id) as? CustomTableViewCell else {
            return UITableViewCell()
        }
        tableViewCell.updateData(element: element, selected: manager.selectedElements.contains(element))
        return tableViewCell
    }
}

