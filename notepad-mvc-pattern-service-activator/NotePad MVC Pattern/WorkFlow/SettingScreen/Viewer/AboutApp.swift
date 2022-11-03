//
//  AboutApp.swift
//  NotePad MVC Pattern
//
//  Created by Ainura Kerimkulova on 24/8/22.
//

import UIKit

class AboutApp: UIViewController {
    
    // MARK: - Views
    
    private var versionsTableView: UITableView = {
       let table = UITableView()
       table.translatesAutoresizingMaskIntoConstraints = false
       table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
       return table
    }()
    
    private var buttonsView: UIView = {
        let buttonsView = UIView()
        buttonsView.translatesAutoresizingMaskIntoConstraints = false
        return buttonsView
    }()
    
    private var aboutLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "О приложении"
        label.font = UIFont.systemFont(ofSize: 20)
        return label
    }()
    
    private lazy var doneButton: UIButton = {
        let doneButton = UIButton(type: .system)
        doneButton.translatesAutoresizingMaskIntoConstraints = false
        doneButton.setTitle("Назад", for: .normal)
        doneButton.setTitleColor(.black, for: .normal)
        doneButton.addTarget(self, action: #selector(doneButtonPressed), for: .touchUpInside)
        return doneButton
    }()
    
    private var logoView: UIView = {
        let logoView = UIView()
        logoView.translatesAutoresizingMaskIntoConstraints = false
        return logoView
    }()
    
    private var logoImage: UIImageView = {
        let logoImage = UIImageView()
        logoImage.translatesAutoresizingMaskIntoConstraints = false
        logoImage.image = UIImage(named: "Logo")
        return logoImage
    }()
    
    private lazy var descriptionTextView: UITextView = {
        let description = UITextView()
        description.translatesAutoresizingMaskIntoConstraints = false
        description.isUserInteractionEnabled = false
        description.text = getDescriptionText()
        description.textAlignment = .center
        description.textColor = UIColor(red: 139/255, green: 138/255, blue: 142/255, alpha: 1.0)
        return description
    }()
    
    private lazy var currentVersion: UILabel = {
        let currentVersion = UILabel()
        currentVersion.translatesAutoresizingMaskIntoConstraints = false
        currentVersion.text = getCurrentVersion()
        currentVersion.textColor = UIColor(red: 139/255, green: 138/255, blue: 142/255, alpha: 1.0)
        currentVersion.textAlignment = .center
        currentVersion.font = UIFont.systemFont(ofSize: 12)
        return currentVersion
    }()
    
    // MARK: - Property
        
    private var versions: [String] = ["Версия 1.0"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        updatingToNewVersion()
    }
    
    // MARK: - ConfigureUI
    
    private func configureUI() {
        setViews()
        setConstraints()
    }
    
    private func setViews() {
        view.backgroundColor = .white
        configureUI()
        view.addSubview(buttonsView)
        buttonsView.addSubview(aboutLabel)
        buttonsView.addSubview(doneButton)
        view.addSubview(logoView)
        logoView.addSubview(logoImage)
        logoView.addSubview(descriptionTextView)
        versionsTableView.dataSource = self
        versionsTableView.delegate = self
        view.addSubview(versionsTableView)
        view.addSubview(currentVersion)
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            buttonsView.topAnchor.constraint(equalTo: view.topAnchor, constant: 15),
            buttonsView.widthAnchor.constraint(equalTo: view.widthAnchor),
            buttonsView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.05),
            
            aboutLabel.topAnchor.constraint(equalTo: buttonsView.topAnchor),
            aboutLabel.centerXAnchor.constraint(equalTo: buttonsView.centerXAnchor),
            
            doneButton.topAnchor.constraint(equalTo: buttonsView.topAnchor),
            doneButton.trailingAnchor.constraint(equalTo: buttonsView.trailingAnchor, constant: -14),
            
            logoView.topAnchor.constraint(equalTo: buttonsView.bottomAnchor),
            logoView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoView.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -10),
            logoView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 1/3),
            
            logoImage.centerXAnchor.constraint(equalTo: logoView.centerXAnchor),
            logoImage.widthAnchor.constraint(equalToConstant: 100),
            logoImage.heightAnchor.constraint(equalToConstant: 100),
            logoImage.topAnchor.constraint(equalTo: logoView.topAnchor),
            
            descriptionTextView.topAnchor.constraint(equalTo: logoImage.bottomAnchor),
            descriptionTextView.widthAnchor.constraint(equalTo: logoView.widthAnchor, constant: -14),
            descriptionTextView.bottomAnchor.constraint(equalTo: logoView.bottomAnchor),
            descriptionTextView.centerXAnchor.constraint(equalTo: logoView.centerXAnchor),
                 
            versionsTableView.topAnchor.constraint(equalTo: logoView.bottomAnchor),
            versionsTableView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.5),
            versionsTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            versionsTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            versionsTableView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            currentVersion.topAnchor.constraint(equalTo: versionsTableView.bottomAnchor),
            currentVersion.widthAnchor.constraint(equalTo: view.widthAnchor),
            currentVersion.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.07),
            currentVersion.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20)
        ])
        
        if (UIScreen.main.bounds.width <= 380) {

            aboutLabel.font = UIFont.systemFont(ofSize: 16)
            NSLayoutConstraint.activate([
                aboutLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 20),
                logoView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 1/2),

                versionsTableView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.3)
            ])
        }
    }
    
    // MARK: - Helpers
    
    func getDescriptionText() -> String{
        let text = """
        NotePad MVC - текстовый редактор, который позволяет пользователям создавать новые документы, читать
        и редактировать файлы с расширением: java, kt, swift, ntp, а также распечатывать файлы.
        \n Приложение разработано командой ServiceActivator: Улан Бейшекулов, Айсулуу Арстанбаева, Сабир Мырзаев, Павел Епанешников, Айнура Керимкулова, Бексултан Сапаралиев, Алексей Култыгин
        """
        return text
    }
    
    func getCurrentVersion() -> String{
        let text = "Текущая версия: 1.0"
        return text
    }
    
    func updatingToNewVersion(){
        let defaults = UserDefaults.standard
        let newVersion = "Версия 1.0"
        var versionDescription = defaults.string(forKey: newVersion)
        if versionDescription == nil{
            versionDescription = "Добавили возможность печати файлов, вставлять дату автоматически при выборе пункта из меню, настроили дизайн страниц"
        }
        defaults.setValue(versionDescription, forKey: newVersion)
        
        let savedVersions = defaults.object(forKey: "savedVersions") as? [String] ?? [String]()
        versions = savedVersions
        if !versions.contains("Версия 1.0"){
            versions.append("Версия 1.0")
        }
        defaults.set(versions, forKey: "savedVersions")
    }
    
    @objc func doneButtonPressed(_ sender: UIButton){
        dismiss(animated: true)
    }
}
    
    // MARK: - UITableViewDataSource

extension AboutApp: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        "Версии:"
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return versions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let versionsReverse: [String] = versions.reversed()
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        var content = cell.defaultContentConfiguration()
        content.text = versionsReverse[indexPath.row]
        let defaults = UserDefaults.standard
        let descriptionForVersion = defaults.string(forKey: versionsReverse[indexPath.row])
        content.secondaryText = descriptionForVersion
        cell.backgroundColor = .cyan
        cell.contentConfiguration = content
    
        return cell
    }
    
}
