//
//  SaveAsViewer.swift
//  NotePad MVC Pattern
//
//  Created by Masaie on 23/8/22.
//

import UIKit

class SaveAsController: UIViewController {

    @IBOutlet var fileNameTextField: UITextField!
    @IBOutlet var tableView: UITableView!
    @IBOutlet var extensionPicker: UIPickerView!
    
    var fileName: String!
    var fileFont: UIFont!
    var fileColor: UIColor!
    var contentOfFile: String!
    var selectedExtension: ElementType = .ntp
    var selectedPath: URL?
    var extensionsList: [ElementType]!
    var manager = FilesManager()
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        extensionsList = fetchFileExtensionList()
        selectedPath = manager.currentDirectory
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        manager.filesInSelectedFolder = manager.elements
        initialSettings()
        setUpTableView()
        setUpPicker()
    }
    
    @IBAction func saveButtonPressed(_ sender: UIButton) {
        guard let path = selectedPath else { return }
        
        manager.save(
            text: contentOfFile ?? "Не удалось загрузить содержимое файла",
            name: fileNameTextField.text ?? "",
            fileExtension: selectedExtension.rawValue,
            path: path
        )
        
        let savingName = "\(fileNameTextField.text!)\(selectedExtension.rawValue)"
        UserDefaultsService.shared.saveTextAttributes(fileName: savingName, color: fileColor, font: fileFont)
        
        dismiss(animated: true)
    }
    
    private func initialSettings() {
        // если файл уже сохранен под другим расширением, старое расширение в записи названия стрирается
        // и записывается под новым расширением
        
        if fileName != "" && (fileName.contains(".ntp") || fileName.contains(".swift") || fileName.contains(".kt") || fileName.contains(".java")){
            var nameOfFile: String = ""
            for char in fileName{
                if char != "."{
                    nameOfFile += String(char)
                }else{
                    break
                }
            }
            fileNameTextField.text = nameOfFile
        }else{
            fileNameTextField.text = fileName
        }
        setNavigationBar()
    }

    private func setNavigationBar() {
        let cancelButton = UIBarButtonItem(
            title: "Отменить",
            style: .done,
            target: self,
            action: #selector(cancelOfSaving)
        )
        navigationItem.rightBarButtonItem = cancelButton
    }
    
    @objc private func cancelOfSaving() {
        dismiss(animated: true)
    }
    
    private func fetchFileExtensionList() -> [ElementType] {
        var extensions: [ElementType] = []
        
        for fileExtension in ElementType.allCases {
            if fileExtension != .folder {
                extensions.append(fileExtension)
            }
        }
        return extensions
    }
    
    func folderCellTapped(indexPath: IndexPath) {
        let element = manager.filesInSelectedFolder[indexPath.row]
        let selectedFolderOrFile = element.path
        selectedPath = selectedFolderOrFile
        var filesInSelectedFolder = [Element]()
        
        guard let fileUrls = try? FileManager.default.contentsOfDirectory(
            at: selectedFolderOrFile,
            includingPropertiesForKeys: nil
        ) else { return }
        
        
        filesInSelectedFolder = fileUrls.map {
            let name = $0.lastPathComponent
            var type: ElementType = .folder
            
            if name.contains(".ntp") {
                type = .ntp
            } else if name.contains(".swift") {
                type = .swift
            } else if name.contains(".kt") {
                type = .kt
            } else if name.contains(".java") {
                type = .java
            }
              else if !name.contains("."){
                type = .folder
            }
            else {
                type = .unknown
            }

            return Element(name: name,
                           path: $0,
                           type: type)
        }.sorted {
            $0.type.sortPriority < $1.type.sortPriority
        }
        
        manager.filesInSelectedFolder = filesInSelectedFolder
        tableView.reloadData()
    }
    
    private func navigateToNextFolder(_ url: URL) {
        guard let viewController = UIStoryboard(name: "SaveAsStoryboard", bundle: nil).instantiateViewController(
            withIdentifier: "saveAsViewer"
        ) as? SaveAsController else {
            return
        }
        
        viewController.manager.currentDirectory = url
        navigationController?.pushViewController(viewController, animated: true)
    }
}

// MARK: - UITableViewDelegate

extension SaveAsController: UITableViewDelegate {
    func setUpTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.allowsMultipleSelection = true
        tableView.register(UINib(nibName: "CustomTableViewCell", bundle: nil),
                           forCellReuseIdentifier: CustomTableViewCell.id
        )
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        folderCellTapped(indexPath: indexPath)
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        folderCellTapped(indexPath: indexPath)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        40
    }
}

// MARK: - UITableViewDataSource

extension SaveAsController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return manager.filesInSelectedFolder.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let element = manager.filesInSelectedFolder[indexPath.row]
        switch element.type {
        default:
            let tableViewCell = getDirectoryCell(tableView, element: element)
            return tableViewCell
        }
    }
    
    private func getDirectoryCell(_ tableView: UITableView, element: Element) -> UITableViewCell {
        guard let tableViewCell = tableView.dequeueReusableCell(withIdentifier: CustomTableViewCell.id) as? CustomTableViewCell else {
            return UITableViewCell()
        }
        
        tableViewCell.updateData(element: element, selected: manager.selectedElements.contains(element))
        
        return tableViewCell
    }
}

// MARK: - UIPickerViewDataSource

extension SaveAsController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return ElementType.allCases.count - 1
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedExtension = extensionsList[row]
    }
}

// MARK: - UIPickerViewDelegate

extension SaveAsController: UIPickerViewDelegate {
    func setUpPicker() {
        extensionPicker.delegate = self
        extensionPicker.dataSource = self
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return "Расширение \(extensionsList[row].rawValue)"
    }
}
