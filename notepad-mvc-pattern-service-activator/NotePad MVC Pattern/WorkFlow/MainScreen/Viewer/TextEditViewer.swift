//
//  TextEditViewer.swift
//  NotePad MVC Pattern
//
//  Created by inputlagged on 8/11/22.
//

import UIKit

protocol SettingsDelegate {
    func setColor(_ color: UIColor)
    func setFont(_ font: UIFont)
}

final class TextEditViewer: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var folderButton: ButtonsFragmentView!
    @IBOutlet weak var textView: UITextView!
    
    // MARK: - Property
    
    public var textEditController: TextEditController?
    var manager = FilesManager()
    public var searchText: String?
    public var originalReplacingText: String?
    public var replacingText: String?
    private var TopFileName = "New File"
    public var goToText: String?
    private var findRanges: [NSRange] = []
    private var standardBar: UIToolbar?
    private var currentFind = 0
    var isFileExist : Bool = false
    var fileName: String = ""
    var saveNameForSettings: String?
    var errorForNaming = "Ошибка #001"
    
    
    // MARK: - Views
    
    var settingsButton: UIBarButtonItem = {
        UIBarButtonItem()
    }()
    
    var threePointButton: UIBarButtonItem = {
        UIBarButtonItem()
    }()

    
    var fileNameTextField : UITextField = {
        UITextField()
        
    }()

    
    // MARK: - Init
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.textEditController = TextEditController(viewer: self)
    }
    
    // MARK: - Lifecycle VC
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.textView.delegate = self
        self.addToolbar(textView: self.textView)
        configure()
        
        if isFileExist {
            readFromFile()
        }
    }
    
    // MARK: - Reading from a file
    
    private func readFromFile(){
        textEditController?.readFromFile()
        textView.textColor = UIColor(red: 0.0/255.0, green: 0.0/255.0, blue: 0.0/255.0, alpha: 1.0)
        fileNameTextField.text = fileName
        fileNameTextField.isUserInteractionEnabled = false
        TopFileName = fileName
        
        if let attributes = UserDefaultsService.shared.getTextAtributes(fileName: fileName) as? [String: Any] {
            if let color = attributes["color"] as? UIColor, let font = attributes["font"] as? UIFont {
                setColor(color)
                setFont(font)
            }
        }
    }
    
    //MARK: - Keyboard
    
    func addToolbar(textView: UITextView) {
        let toolbar = UIToolbar()
        toolbar.barStyle = UIBarStyle.default
        toolbar.isTranslucent = true
        toolbar.tintColor = UIColor.darkGray
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(title: "X", style: UIBarButtonItem.Style.done, target: self, action: #selector(TextEditViewer.donePressed))
        toolbar.setItems([spaceButton, doneButton], animated: false)
        toolbar.isUserInteractionEnabled = true
        toolbar.sizeToFit()
        
        textView.delegate = self
        textView.inputAccessoryView = toolbar
    }
    
    @objc func donePressed() {
        self.view.endEditing(true)
    }
    
    //MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "setting" {
            guard let nav = segue.destination as? UINavigationController else { return }
            guard let settingVC = nav.topViewController as? SettingsViewer else { return }
            settingVC.delegate = self
            settingVC.color = view.backgroundColor
            settingVC.font = textView.font
        }
    }
    
    // MARK: - Selectors
    
    
    @objc
    private func folderAction() {
        let backItem = UIBarButtonItem()
        backItem.title = "Назад"
        navigationItem.backBarButtonItem = backItem
        
        let storyboard = UIStoryboard(name: "FileManager", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "FilesViewController") as! FilesViewController
        navigationController?.pushViewController(controller, animated: true)
    }
    
    @objc
    private func saveAction() {
        if fileName == ""{
            showCreateAlert(titleText: "Пожалуйста, дайте имя файлу", messageText: "В названии допустимы: Латиница и цифры")
        }else{
            let fileManager = FilesManager()
            let text = textView.text
            let saveName = fileName
            let path = fileManager.currentDirectory!
            
            do {
                try text?.write(to: path.appendingPathComponent(saveName), atomically: true, encoding: .utf16)
            } catch {
                print("Ошибка")
            }

        }
        
    }
    
    @objc private func regenerateContextMenu() {
        threePointButton.menu = createMenu() // Пересоздает меню чтобы обновлять состояние кнопок.
    }
    
    @objc private func settingsScreenOpened() {
        performSegue(withIdentifier: "setting", sender: nil)
    }
    
    // MARK: - Configure
    
    func showCreateAlert(titleText: String, messageText: String) {
        let messageAlert = UIAlertController(title: titleText,
                                             message: messageText,
                                             preferredStyle: .alert)
        messageAlert.addTextField()
        
        //если файлу задали изначально заголовок,то оно уже будет в textField в алерте при сохранении
        if TopFileName != "New File"{
            messageAlert.textFields?.first?.text = TopFileName
        }
        
        let createAction = UIAlertAction(title: "Сохранить",
                                         style: .default) { [self] _ in
            guard let fileName = messageAlert.textFields?.first?.text,
                  !fileName.isEmpty else {
                self.showCreateAlert(titleText: "Ошибка", messageText: "Введите название...")
    
                return
            }
            

            if fileName.latinCharactersAndNumbersOnly {
                
                    let fileManager = FilesManager()
                    let text = textView.text
                    let newName = checkNameInFilesList(name: fileName)
                    print(newName)
                    if newName != errorForNaming {
                    let saveName = "\(newName).ntp"
                    self.saveNameForSettings = saveName
                    self.textEditController?.performAction(command: "saveAttributes")
                    let path = fileManager.currentDirectory!
                    
                    do {
                        try text?.write(to: path.appendingPathComponent(saveName), atomically: true, encoding: .utf16)
                        
                        self.fileName = saveName
                        TopFileName = saveName
                        fileNameTextField.text = TopFileName
                    }
                    catch {
                        print("Ошибка")
                    }
                    }
            else {
                    showCreateAlert(titleText: "Ошибка", messageText: "Хозяин, В недрах Вашей библиотеки, я узрел такой же манускрипт \n (Файл с таким названием уже существует)")
                    }
                }
                 else {
                    showCreateAlert(titleText: "Ошибка", messageText: "Только Латиница и цифры. Все! Всякие там Кирриллица и Иероглифы оставь себе! Я тоже так умею 仅限拉丁文和数字.")
                }
            }

        
        let cancelAction = UIAlertAction(title: "Отменить",
                                         style: .cancel)
        
        messageAlert.addAction(createAction)
        messageAlert.addAction(cancelAction)
        
        present(messageAlert, animated: true)
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
    
    private func configure() {
        setupViews()
        setupConstraints()
        setupNotificationTarget()
        setUpFileName()
    
        
    
        let imageConfiguration = UIImage.SymbolConfiguration(pointSize: 24, weight: .bold, scale: .medium)

        settingsButton.image = UIImage(systemName: "gear")
        settingsButton.tintColor = UIColor(red: 99/255, green: 135/255, blue: 135/255, alpha: 1.0)
        settingsButton.style = .done
        settingsButton.target = self
        settingsButton.action = #selector(settingsScreenOpened)

        threePointButton.image = UIImage(systemName: "ellipsis", withConfiguration: imageConfiguration)
        threePointButton.menu = createMenu()
        threePointButton.tintColor = UIColor(red: 99/255, green: 135/255, blue: 135/255, alpha: 1.0)

//        let imageConfiguration = UIImage.SymbolConfiguration(pointSize: 24, weight: .bold, scale: .medium)
//        let image = UIImage(systemName: "ellipsis", withConfiguration: imageConfiguration)
//        threePointButton.contentEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 25)
//        threePointButton.setImage(image, for: .normal)
//        threePointButton.addTarget(self, action: #selector(regenerateContextMenu), for: .menuActionTriggered)
//        threePointButton.showsMenuAsPrimaryAction = true
//        threePointButton.menu = createMenu()
//        threePointButton.tintColor = UIColor(red: 99/255, green: 135/255, blue: 135/255, alpha: 1.0)
//        navigationItem.setRightBarButton(.init(customView: threePointButton), animated: true)

        navigationItem.rightBarButtonItems = [threePointButton, settingsButton]
        
        textView.delegate = self
        textView.text = "Введите текст"
        textView.textColor = .gray
    }
    
    private func setUpFileName(){
        fileNameTextField.delegate = self
        fileNameTextField.text =  "New File"
        fileNameTextField.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        fileNameTextField.textColor = .black
        fileNameTextField.adjustsFontSizeToFitWidth = true
        navigationItem.setLeftBarButton(.init(customView: fileNameTextField), animated: true)
        
    }
    
    private func setupViews() {
        
    }
    
    private func setupConstraints() {
        
    }
    
    private func setupNotificationTarget() {
        folderButton.openFolder.addTarget(self, action: #selector(folderAction), for: .touchUpInside)
        folderButton.saveButton.addTarget(self, action: #selector(saveAction), for: .touchUpInside)
    }
    
    // MARK: - Helpers
    
    public func replaceAlert() {
        let alert = UIAlertController(title: "Замена", message: "Уточните, что вы хотите заменить.", preferredStyle: .alert)
        
        alert.addTextField { (textField) in
            textField.placeholder = "Это"
            
        }
        
        alert.addTextField { (textField) in
            textField.placeholder = "Этим"
        }
        
        alert.addAction(UIAlertAction(title: "Отмена", style: .cancel, handler: nil))
        
        alert.addAction(UIAlertAction(title: "Готово", style: .default, handler: { _ in
            let textField1 = alert.textFields![0]
            let textField2 = alert.textFields![1]
            if textField1.text != nil && textField1.text! != "" && textField2.text != nil && textField2.text! != "" {
                self.originalReplacingText = textField1.text
                self.replacingText = textField2.text
                self.textEditController?.performAction(command: "replace")
            }
        }))
        
        
        self.present(alert, animated: true, completion: nil)
    }
    
    public func goToAlert() {
        
        let alert = UIAlertController(title: "Перейти к", message: "Укажите текст, куда вы хотите перейти", preferredStyle: .alert)
        
        alert.addTextField { (textField) in
            textField.placeholder = "Введите текст"
            
        }
        
        alert.addAction(UIAlertAction(title: "Отмена", style: .cancel, handler: nil))
        
        alert.addAction(UIAlertAction(title: "Готово", style: .default, handler: { _ in
            let textField = alert.textFields![0]
            if textField.text != nil && textField.text != "" {
                self.goToText = textField.text
                self.textEditController?.performAction(command: "goTo")
            }
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    public func customAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Готово", style: .default)
        alertController.addAction(okAction)
        present(alertController, animated: true)
    }
    
    public func hokuAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Аригато!", style: .default, handler: { action in
            //run your function here
            self.goToExit()
        }))
        present(alertController, animated: true)
    }
    
    func goToExit() {
        Darwin.exit(0)
    }
    
    public func getTextFromTextView() -> String {
        return textView.text
    }
    
    public func prepareForPrint()  {
        let text = getTextFromTextView()
        let font = self.textView.font!
        let printDocument = PrintDocument(content: text, font: font)
        let data = printDocument.prepareData()
        let pdfPreview = PDFPreviewViewer()
        pdfPreview.documentData = data
        self.navigationController?.pushViewController(pdfPreview, animated: true)
    }
    
    public func activateFind() {
        let bar = UIToolbar()
        let up = UIBarButtonItem(title: "/\\", style: .plain, target: self, action: #selector(upButtonPressed))
        let down = UIBarButtonItem(title: "\\/", style: .plain, target: self, action: #selector(downButtonPressed))
        let searchField = UISearchBar(frame: CGRect(x: 0, y: 0, width: 150, height: 20))
        searchField.searchBarStyle = .minimal
        searchField.delegate = self
        searchField.autocapitalizationType = .none
        let search = UIBarButtonItem(customView: searchField)
        let done = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(searchBarDoneButtonPressed))
        let space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        done.tintColor = .black
        up.tintColor = .black
        down.tintColor = .black
        searchField.tintColor = .black
        bar.items = [up, down, space, search, done]
        bar.sizeToFit()
        textView.inputAccessoryView = bar
        textView.reloadInputViews()
    }
    
    
    
    
    
    private func createMenu() -> UIMenu {
        
        let undoAction = UIAction(title: "Назад", image: UIImage(systemName: "arrowshape.turn.up.left.fill"), handler: { _ in
            self.textEditController?.performAction(command: "undo")
        })
        
        let redoAction = UIAction(title: "Вперед", image: UIImage(systemName: "arrowshape.turn.up.right.fill"), handler: { _ in
            self.textEditController?.performAction(command: "redo")
        })
       
        let cutAction = UIAction(title: "Вырезать", image: UIImage(systemName: "scissors"), handler: { _ in
            self.textEditController?.performAction(command: "cut")
        })
        
        let copyAction = UIAction(title: "Копировать", image: UIImage(systemName: "doc.on.clipboard"), handler: { _ in
            self.textEditController?.performAction(command: "copy")
        })
        
        let pasteAction = UIAction(title: "Вставить", image: UIImage(systemName: "doc.on.clipboard.fill"), handler: { _ in
            self.textEditController?.performAction(command: "paste")
        })
        
        let saveAsAction = UIAction(title: "Сохранить как...", image: UIImage(systemName: "folder.badge.gearshape"), handler: { _ in
            self.textEditController?.performAction(command: "saveAs")
        })
        
        let removeAction = UIAction(title: "Удалить", image: UIImage(systemName: "trash.slash.fill"), handler: { _ in
            self.textEditController?.performAction(command: "remove")
        })
        
        let findAction = UIAction(title: "Найти", image: UIImage(systemName: "magnifyingglass"), handler: { _ in self.textEditController?.performAction(command: "find")
            
        })
        
        let replaceAction = UIAction(title: "Заменить", image: UIImage(systemName: "arrow.2.squarepath"), handler: { (_) in
            self.textEditController?.performAction(command: "replaceAlert")
        })
        
        let goToAction = UIAction(title: "Перейти к...", image: UIImage(systemName: "goforward"), handler: { (_) in
            self.textEditController?.performAction(command: "goToAlert")
        })
        
        let selectAllAction = UIAction(title: "Выбрать всё", image: UIImage(systemName: "checkmark.circle.fill"), handler: { _ in
            self.textEditController?.performAction(command: "selectAll")
        })
        
        let timeAndDateAction = UIAction(title: "Время и дата", image: UIImage(systemName: "calendar"),   handler: { _ in
            self.textEditController?.performAction(command: "timeAndDate")
        })
        
        let printDocumentAction = UIAction(title: "Печать", image: UIImage(systemName: "printer"),   handler: { _ in
            self.textEditController?.performAction(command: "printDocument")
        })
        
        let exitAction = UIAction(title: "Выход", image: UIImage(systemName: "x.circle"),   handler: { _ in
            self.textEditController?.performAction(command: "exit")
        })
        
        let hokuAction = UIAction(title: "Уйти красиво!", image: UIImage(systemName: "mouth.fill"),   handler: { _ in
            self.textEditController?.performAction(command: "hoku")
        })
        
        let menuActions = [undoAction, redoAction, cutAction, copyAction, pasteAction, removeAction, findAction, replaceAction, goToAction, selectAllAction, timeAndDateAction, printDocumentAction, saveAsAction, exitAction, hokuAction]
        
        let menu = UIMenu(title: "Выберите операцию", image: nil, identifier: nil, options: [], children: menuActions)
        
        return menu
    }
    
    // MARK: - SearchBar Logic
    
    @objc private func upButtonPressed() {
        if let bar = textView.inputAccessoryView as? UIToolbar {
            for item in bar.items ?? [] {
                if let searchBar = item.customView as? UISearchBar {
                    searchBar.resignFirstResponder()
                }
            }
        }
        
        if currentFind == 0 {
            currentFind = findRanges.count - 1
        } else {
            currentFind -= 1
        }
        
        if findRanges != [] {
            textView.selectedRange = findRanges[currentFind]
            textView.setNeedsLayout()
            textView.scrollRangeToVisible(findRanges[currentFind])
        }
    }
    
    @objc private func downButtonPressed(){
        if let bar = textView.inputAccessoryView as? UIToolbar {
            for item in bar.items ?? [] {
                if let searchBar = item.customView as? UISearchBar {
                    searchBar.resignFirstResponder()
                }
            }
        }
        
        if currentFind == findRanges.count - 1 {
            currentFind = 0
        } else {
            currentFind += 1
        }
        
        if findRanges != [] {
            textView.selectedRange = findRanges[currentFind]
            textView.setNeedsLayout()
            textView.scrollRangeToVisible(findRanges[currentFind])
        }
    }
    
    @objc private func searchBarDoneButtonPressed() {
        findRanges = []
        currentFind = 0
        
        if let bar = textView.inputAccessoryView as? UIToolbar {
            for item in bar.items ?? [] {
                if let search = item.customView as? UISearchBar {
                    search.resignFirstResponder()
                }
            }
        }
        textView.inputAccessoryView = standardBar
        textView.reloadInputViews()
    }
    
    private func didHighlight(_ range: NSRange, success: Bool) {
        if let bar = textView.inputAccessoryView as? UIToolbar {
            for item in bar.items ?? [] {
                if let searchBar = item.customView as? UISearchBar {
                    
                    findRanges = []
                    currentFind = 0
                    
                    let searchString = searchBar.text ?? ""
                    let baseString = textView.text ?? ""
                    
                    if baseString == "" || searchString == "" {
                        return
                    }
                    
                    var searchIndex = 0
                    for i in 0..<baseString.count {
                        if baseString[i] == searchString[searchIndex] {
                            searchIndex += 1
                            if searchIndex == searchString.count {
                                findRanges.append(NSRange(location: i - searchIndex + 1, length: searchString.count))
                                searchIndex = 0
                            }
                        } else {
                            searchIndex = 0
                        }
                    }
                }
            }
        }
    }
}

// MARK: - TextEditViewer
    
extension TextEditViewer: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        didHighlight(NSRange(location: 0, length: textView.text.count), success: false)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}


// MARK: - TextView delegate for add placeholder
extension TextEditViewer: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == "Введите текст" {
            textView.text = ""
            textView.textColor = UIColor(red: 0.0/255.0, green: 0.0/255.0, blue: 0.0/255.0, alpha: 1.0)
        }
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Введите текст"
            textView.textColor = UIColor(red: 196.0/255.0, green: 196.0/255.0, blue: 198.0/255.0, alpha: 0.96)
        }
    }
    
}

// MARK: - ColorDelegate
extension TextEditViewer: SettingsDelegate {
    
    func setColor(_ color: UIColor) {
        view.backgroundColor = color
        folderButton.backgroundColor = color
        textView.backgroundColor = color
    }
    
    func setFont(_ font: UIFont) {
        textView.font = font
    }
    
}

// MARK: - TextView delegate methods to change the file name

extension  TextEditViewer : UITextFieldDelegate {
    
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        if  fileNameTextField.text!.isEmpty {
            TopFileName = "New File"
            fileNameTextField.text! = TopFileName
            textField.isUserInteractionEnabled = true
        }
        else if fileNameTextField.text!.latinCharactersAndNumbersOnly{
            TopFileName = fileNameTextField.text!
            textField.isUserInteractionEnabled = false
        }
        
        else{
            TopFileName = "New File"
            fileNameTextField.text = "\(TopFileName)"
            showCreateAlert(titleText: "Ошибка", messageText: "Только Латиница и цифры. Все! Всякие там Кирриллица и Иероглифы оставь себе! Я тоже так умею 仅限拉丁文和数字.")
            }
        }
    
    
    func textFieldDidBeginEditing(_ textField : UITextField){
        fileNameTextField.text = ""
    }
}
