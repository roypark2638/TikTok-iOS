//
//  SettingsViewController.swift
//  TikTok
//
//  Created by Roy Park on 3/18/21.
//

import UIKit
import SafariServices


class SettingsViewController: UIViewController {
    
    private let tableView: UITableView = {
        // grouped will allow us to get the default look of that group table
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.register(UITableViewCell.self,
                           forCellReuseIdentifier: "cell")
        tableView.register(SwitchTableViewCell.self,
                           forCellReuseIdentifier: SwitchTableViewCell.identifier)
        return tableView
    }()
    
    private var sections = [SettingsSection]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sections = [
            SettingsSection(
                title: "Preferences", option: [
                    SettingsOption(title: "Save Videos", handler: {})
                ]
            ),
            SettingsSection(
                title: "Information", option: [
                    
                    SettingsOption(title: "Terms of Service", handler: { [weak self] in
                        DispatchQueue.main.async {
                            guard let url = URL(string: "https://www.tiktok.com/legal/terms-of-service") else { return }
                            
                            let vc = SFSafariViewController(url: url)
                            self?.present(vc, animated: true, completion: nil)
                        }
                    }),
                    SettingsOption(title: "Privacy Policy", handler: { [weak self] in
                        DispatchQueue.main.async {
                            guard let url = URL(string: "https://www.tiktok.com/legal/privacy-policy") else { return }
                            
                            let vc = SFSafariViewController(url: url)
                            self?.present(vc, animated: true, completion: nil)
                        }
                    })
                    
                ]
            )
        ]
        
        view.backgroundColor = .systemBackground
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        createFooter()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    
    func createFooter() {
        let footer = UIView(frame: CGRect(x: 0, y: 0, width: view.width, height: 100))
        let button = UIButton(frame: CGRect(x: (view.width-200)/2, y: 25, width: 200, height: 50))
        button.setTitle("Sign Out", for: .normal)
        button.setTitleColor(.systemRed, for: .normal)
        button.addTarget(self, action: #selector(didTapSignOut), for: .touchUpInside)
        footer.addSubview(button)
        tableView.tableFooterView = footer
    }


    @objc private func didTapSignOut() {
        let actionSheet = UIAlertController(title: "Sign Out", message: "Would you like to sign out?", preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        actionSheet.addAction(UIAlertAction(title: "Sign Out", style: .destructive, handler: { _ in
            AuthManager.shared.signOut { [weak self] (success) in
                if success {
                    // signed out, show the onboarding page
                    print("signed out")
                    DispatchQueue.main.async {
                        UserDefaults.standard.string(forKey: "username")
                        UserDefaults.standard.string(forKey: "profile_picture_url")
                        let vc = SignInViewController()
                        let navVC = UINavigationController(rootViewController: vc)
                        navVC.modalPresentationStyle = .fullScreen
                        self?.present(navVC, animated: true, completion: nil)
                        self?.navigationController?.popToRootViewController(animated: true)
                        self?.tabBarController?.selectedIndex = 0
                            
                    }
                }
                else {
                    // error
                    let alert = UIAlertController(title: "Error", message: "Something went wrong signing out. Please try again.", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "dismiss", style: .cancel, handler: nil))
                    self?.present(alert, animated: true, completion: nil)
                }
            }
        }))
        present(actionSheet, animated: true, completion: nil)
    }
}

extension SettingsViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].option.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = sections[indexPath.section].option[indexPath.row]
        
        if model.title == "Save Videos" {
            guard let cell = tableView.dequeueReusableCell(
                    withIdentifier: SwitchTableViewCell.identifier,
                    for: indexPath
            ) as? SwitchTableViewCell else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
                cell.accessoryType = .disclosureIndicator
                cell.textLabel?.text = model.title
                return cell
            }
            
            cell.delegate = self
            cell.configure(view: SwitchCellViewModel(title: model.title, isOn: UserDefaults.standard.bool(forKey: "save_video")))
            return cell
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.accessoryType = .disclosureIndicator
        cell.textLabel?.text = model.title
        return cell
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {

    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let model = sections[indexPath.section].option[indexPath.row]
        model.handler()
        
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section].title
    }
}

extension SettingsViewController: SwitchTableViewCellDelegate {
    func switchTableViewCell(_ cell: SwitchTableViewCell, didUpdateSwitchTo isOn: Bool) {
        print(isOn)
        
        UserDefaults.standard.setValue(isOn, forKey: "save_video")
    }
    
}
