//
//  FilesViewController.swift
//  NotePad MVC Pattern
//
//  Created by Sabir Myrzaev on 23.08.2022.
//

import UIKit
import PhotosUI

protocol ElementsManagerDelegate {
    func handleModeChange()
    func reloadData()
}

class FilesViewController: UIViewController {
    
    @IBOutlet weak var foldersTableView: UITableView!
    @IBOutlet weak var filesCollectionView: UICollectionView!
    @IBOutlet var searchBar: UISearchBar!
    var errorForNaming = "Ошибка #001"
    
    let segmentControl: UISegmentedControl = UISegmentedControl(items: ["Таблица", "Коллекция"])
    var filteredFiles: [Element] = []
    var manager = FilesManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        manager.delegate = self
        
        updateNavigationButtons()
        setupSearchBar()
        setUpTableView()
        setUpCollectionView()
        changingViewCell()
        navigationController?.navigationBar.barTintColor = UIColor.white
        readFromFileManager()
    }
    
    func readFromFileManager() {
        let documentDirectoryPath: String = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        let myFilesPath = "\(documentDirectoryPath)"
        let filemanager = FileManager.default
        let files = filemanager.enumerator(atPath: myFilesPath)
        
        print(documentDirectoryPath)
        while let file = files?.nextObject() {
            print(file)
        }
    }
    func checkNameInFilesList(name: String) -> String {
        let documentDirectoryPath: String = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        let myFilesPath = "\(documentDirectoryPath)"
        let filemanager = FileManager.default
        let files = filemanager.enumerator(atPath: myFilesPath)
        var namesList = [String]()
        var newName = name
        
        while let file = files?.nextObject() {
            namesList.append("\(file)".getName())
            print(namesList)
        }
        
        if namesList.contains(newName) {
            newName = "Ошибка #001"
            print(newName)
            return newName
        } else {
            return newName
        }
    }
    
    private func updateNavigationButtons() {
        switch manager.mode {
        case .edit:
            addEditModeRightButtons()
            
        case .view:
            setUpNavigationBar()
        }
    }
    
    private func addEditModeRightButtons() {
        let selectButton = UIBarButtonItem(title: "Отменить",
                                           primaryAction: UIAction(handler: { _ in
            self.manager.switchMode(.view)
        }))
        
        let deleteButton = UIBarButtonItem(systemItem: .trash,
                                           primaryAction: UIAction(handler: { _ in
            self.manager.deleteSelectedElements()
        }))
        
        navigationItem.rightBarButtonItems = [selectButton, deleteButton]
    }
    
    func setUpNavigationBar() {
        let selectButton = UIBarButtonItem(systemItem: .compose, primaryAction: UIAction(handler: { _ in
            self.manager.switchMode(.edit)
        }))
        
        var menuItems: [UIAction] {
            return [
                addAlertMessage(title: "Добавить папку",
                                imageName: "folder.fill.badge.plus",
                                titleText: "Пожалуйста, дайте имя папке!",
                                messageText: "Ты можешь написать имя папки в поле ниже.",
                                elementType: .folder),
                addAlertMessage(title: "Добавить файл .ntp",
                                imageName: "doc.fill.badge.plus",
                                titleText: "Пожалуйста, дайте имя файлу .ntp!",
                                messageText: "Ты можешь написать имя папки в поле ниже.",
                                elementType: .ntp),
                addAlertMessage(title: "Добавить файл .swift",
                                imageName: "doc.fill.badge.plus",
                                titleText: "Пожалуйста, дайте имя файлу .swift!",
                                messageText: "Ты можешь написать имя Swift в поле ниже.",
                                elementType: .swift),
                addAlertMessage(title: "Добавить файл .kt",
                                imageName: "doc.fill.badge.plus",
                                titleText: "Пожалуйста, дайте имя файлу .kt!",
                                messageText: "Ты можешь написать имя Kotlin в поле ниже.",
                                elementType: .kt),
                addAlertMessage(title: "Добавить файл .java",
                                imageName: "doc.fill.badge.plus",
                                titleText: "Пожалуйста, дайте имя файлу .java!",
                                messageText: "Ты можешь написать имя Java в поле ниже.",
                                elementType: .java),
            ]
        }
        
         func addAlertMessage(title: String, imageName: String, titleText: String, messageText: String, elementType: ElementType) -> UIAction {
             return UIAction(title: title, image: UIImage(systemName: imageName)) { _ in
                 self.showCreateAlert(titleText: titleText, messageText: messageText, elementType: elementType)
             }
        }
        
        var demoMenu: UIMenu {
            return UIMenu(title: "Выберите подходящую опицию!", image: nil, identifier: nil, options: [], children: menuItems)
        }
        
        segmentControl.sizeToFit()
        segmentControl.selectedSegmentIndex = UserDefaults.standard.integer(forKey: UserDefaultsKey.indexOfDisplayMode.rawValue)
        segmentControl.addTarget(self, action: #selector(FilesViewController.indexChanged(_:)), for: .valueChanged)
        
        self.navigationItem.titleView = segmentControl
        let plusButton = UIBarButtonItem(systemItem: .add, primaryAction: nil, menu: demoMenu)
        self.navigationItem.rightBarButtonItems = [selectButton, plusButton]
    }
    
    @objc func indexChanged(_ sender: UISegmentedControl) {
        UserDefaults.standard.set(segmentControl.titleForSegment(at: segmentControl.selectedSegmentIndex), forKey: UserDefaultsKey.displayMode.rawValue)
        
        UserDefaultsService.shared.saveSegmentControl(segmentControlIndex: segmentControl.selectedSegmentIndex)
        
        changingViewCell()
    }
    
    func changingViewCell() {
        foldersTableView.isHidden = UserDefaults.standard.bool(forKey: UserDefaultsKey.tableViewSegment.rawValue)
        filesCollectionView.isHidden = UserDefaults.standard.bool(forKey: UserDefaultsKey.collectionViewSegment.rawValue)
    }
    
    func showCreateAlert(titleText: String, messageText: String, elementType: ElementType) {
        let messageAlert = UIAlertController(title: titleText,
                                             message: messageText,
                                             preferredStyle: .alert)
        messageAlert.addTextField()
        let createAction = UIAlertAction(title: "Создать",
                                         style: .default) { _ in
            guard let fileName = messageAlert.textFields?.first?.text,
                  !fileName.isEmpty else {
                self.showCreateAlert(titleText: "ошибка", messageText: "Ошибка", elementType: elementType)
                
                return
            }
            if fileName.latinCharactersAndNumbersOnly {
                let newName = self.checkNameInFilesList(name: fileName)
                if newName != self.errorForNaming {
                    self.manager.createElement(type: elementType, name: newName, query: "\(elementType.rawValue)")
                    self.filteredFiles = self.manager.elements
                    
                } else {
                    self.showCreateAlert(titleText: "Ошибка", messageText: "Хозяин, В недрах Вашей библиотеки, я узрел такой же манускрипт \n (Файл с таким названием уже существует)", elementType: elementType)
                }
            } else {
                self.showCreateAlert(titleText: "Ошибка", messageText: "Только Латиница и цифры", elementType: elementType)
            }
        }
        
        let cancelAction = UIAlertAction(title: "Отменить",
                                         style: .cancel)
        
        messageAlert.addAction(createAction)
        messageAlert.addAction(cancelAction)
        
        present(messageAlert, animated: true)
    }
    
    // MARK: Cells manipulation
    
    func handleCellTap(indexPath: IndexPath) {
        let element = manager.elements[indexPath.row]
        
        switch manager.mode {
        case .edit:
            manager.selectElement(element)
        case .view:
            handleViewModeCellTap(element: element)
        }
    }
    
    private func handleViewModeCellTap(element: Element) {
        switch element.type {
        case .folder:
            navigateToNextFolder(element.path)
        case .ntp, .java, .kt, .swift:
            fileSizeIsValid(element) ? navigateToTextEditView(element) :
                showAlert(message: "Данный файл слишком тяжелый, Эркин байке сказал такой не открывать!")
        default:
            showAlert(message: "NotePad не поддерживает файл с таким расширением")
        }
    }
    
    private func navigateToNextFolder(_ url: URL) {
        guard let viewController = UIStoryboard(name: "FileManager",
                                                bundle: nil).instantiateViewController(
                                                    withIdentifier: "FilesViewController") as? FilesViewController else {
            return
        }
        viewController.manager.currentDirectory = url
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    private func navigateToTextEditView(_ element : Element) {
        let fileName = element.name
        guard let viewController = UIStoryboard(name: "Main",
                                                bundle: nil).instantiateViewController(
                                                    withIdentifier: "TextEditViewer") as? TextEditViewer else {
            return
        }
        viewController.manager.currentDirectory = element.path
        viewController.isFileExist = true
        viewController.fileName = fileName
        if let attributes = UserDefaultsService.shared.getTextAtributes(fileName: fileName) as? [String: Any] {
            if let color = attributes["color"] as? UIColor, let font = attributes["font"] as? UIFont {
                viewController.setColor(color)
                viewController.setFont(font)
            }
        }
        
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    private func fileSizeIsValid(_ element : Element) -> Bool {
        let maximumAllowFileSizeInBytes = 5_629_273
        let resources = try? element.path.resourceValues(forKeys:[.fileSizeKey])
        let fileSize = (resources?.fileSize ?? 0)
        return fileSize <= maximumAllowFileSizeInBytes ? true : false
    }
    
    func showAlert(_ titleText : String = "Внимание!", message : String){
        let alert = UIAlertController(title: titleText, message: message,preferredStyle: .alert)
        let okButton = UIAlertAction(title: "OK", style: .default)
        alert.addAction(okButton)
        present(alert, animated: true)
    }
}

extension FilesViewController: ElementsManagerDelegate {
    func reloadData() {
        DispatchQueue.main.async {
            self.foldersTableView.reloadData()
            self.filesCollectionView.reloadData()
        }
    }
    
    func handleModeChange() {
        updateNavigationButtons()
        reloadData()
    }
}
