//
//  AboutApp.swift
//  NotePad MVC Pattern
//
//  Created by Ainura Kerimkulova on 19/8/22.
//

import UIKit

class AboutApp: UIViewController {
    
    private var versionsTableView: UITableView = {
       let table = UITableView()
       table.translatesAutoresizingMaskIntoConstraints = false
       table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
       return table
    }()
        
    private var versions: [String] = ["Версия 1.0"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view = UIView()
        view.backgroundColor = .white
        
        let aboutLabel = UILabel()
        aboutLabel.translatesAutoresizingMaskIntoConstraints = false
        aboutLabel.text = "О приложении"
        aboutLabel.font = UIFont.boldSystemFont(ofSize: 20)
        view.addSubview(aboutLabel)
        
        let logoView = UIView()
        logoView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(logoView)
        
        let logoImage = UIImageView()
        logoImage.translatesAutoresizingMaskIntoConstraints = false
        logoImage.image = UIImage(named: "ServiceActivator")
        logoView.addSubview(logoImage)
        
        let description = UITextView()
        description.translatesAutoresizingMaskIntoConstraints = false
        description.isUserInteractionEnabled = false
        description.text = getDescriptionText()
        description.textAlignment = .center
        description.textColor = UIColor(red: 139/255, green: 138/255, blue: 142/255, alpha: 1.0)
        logoView.addSubview(description)
        
        versionsTableView.dataSource = self
        versionsTableView.delegate = self
        view.addSubview(versionsTableView)
        
        let currentVersion = UILabel()
        currentVersion.translatesAutoresizingMaskIntoConstraints = false
        currentVersion.text = getCurrentVersion()
        currentVersion.textColor = UIColor(red: 139/255, green: 138/255, blue: 142/255, alpha: 1.0)
        currentVersion.textAlignment = .center
        currentVersion.font = UIFont.systemFont(ofSize: 12)
        currentVersion.backgroundColor = .white
        view.addSubview(currentVersion)
        
        
        
        NSLayoutConstraint.activate([
            aboutLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 50),
            aboutLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            logoView.topAnchor.constraint(equalTo: aboutLabel.bottomAnchor),
            logoView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoView.widthAnchor.constraint(equalTo: view.widthAnchor),
            logoView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 1/3),
            
            logoImage.centerXAnchor.constraint(equalTo: logoView.centerXAnchor),
            logoImage.widthAnchor.constraint(equalToConstant: 120),
            logoImage.heightAnchor.constraint(equalToConstant: 120),
            logoImage.topAnchor.constraint(equalTo: logoView.topAnchor),
            
            description.topAnchor.constraint(equalTo: logoImage.bottomAnchor),
            description.widthAnchor.constraint(equalTo: logoView.widthAnchor),
            description.bottomAnchor.constraint(equalTo: logoView.bottomAnchor),
            description.centerXAnchor.constraint(equalTo: logoView.centerXAnchor),
                 
            versionsTableView.topAnchor.constraint(equalTo: logoView.bottomAnchor),
            versionsTableView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.5),
            versionsTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            versionsTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            versionsTableView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            currentVersion.topAnchor.constraint(equalTo: versionsTableView.bottomAnchor, constant: 20),
            currentVersion.widthAnchor.constraint(equalTo: view.widthAnchor),
            currentVersion.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20)
        ])
        print(UIScreen.main.bounds.width)
        print(UIScreen.main.bounds.height)


        if (UIScreen.main.bounds.width <= 380) {

            aboutLabel.font = UIFont.systemFont(ofSize: 16)
            NSLayoutConstraint.activate([
                aboutLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 20),
                logoView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 1/2),

                versionsTableView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.3)
            ])

        }
    
        updatingToNewVersion()
    }
    
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
        let currentVersion = "Версия 1.0"
        var versionDescription = defaults.string(forKey: currentVersion)
        if versionDescription == nil{
            versionDescription = "Добавили возможность печати файлов, вставлять дату автоматически при выборе пункта из меню, настроили дизайн всех страниц"
        }
        defaults.setValue(versionDescription, forKey: currentVersion)
        if !versions.contains(currentVersion){
            versions.append(currentVersion)
        }
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




