//
//  ViewController.swift
//  modul_19
//
//  Created by Admin on 21/05/24.
//

import SnapKit
import UIKit
import Alamofire

class ViewController: UIViewController {
    
    var titleString: String = "text hello"
    
    let searchTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "send a request"
        textField.borderStyle = .roundedRect
        textField.text = "Enter title"
        return textField
    }()
    
    
    
    lazy var alomafireButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Send Request", for: .normal)
        //button.setTitleColor(.blue, for: .normal)
        button.backgroundColor = .systemBlue
        button.setTitleColor(.white, for: .normal)
        button.addTarget(nil, action: #selector(alomafireButtonTaped), for: .touchUpInside)
        button.layer.cornerRadius = 6
        
        return button
    }()
    
    
//    lazy var buttonThertyFour: UIButton = {
//        let button = UIButton(type: .system)
//        button.setTitle(".", for: .normal)
//        button.backgroundColor = .green
//        button.setTitleColor(.black, for: .normal)
//        button.addTarget(self, action: #selector(singButtonComma), for: .touchUpInside)
//        button.titleLabel?.font = UIFont.systemFont(ofSize: 42, weight: .medium)
//        button.layer.cornerRadius = 5
//        return button
//    }()
    
    let resultTextView: UITextView = {
        let textView = UITextView()
        textView.isEditable = false
        textView.isScrollEnabled = true
        textView.backgroundColor = .systemGray6
        textView.layer.borderWidth = 1.0
        textView.layer.borderColor = UIColor.black.cgColor
        textView.layer.cornerRadius = 8.0
        textView.font = .systemFont(ofSize: 14, weight: .medium)
        return textView
    }()
    
    
    let textLabel: UILabel = {
        let label = UILabel()
        label.text = "тут результат:"
        label.textColor = UIColor.black
        label.font = .systemFont(ofSize: 14)
        return label
    }()
    
    let result: UILabel = {
        let label = UILabel()
        label.text = "result:"
        label.textColor = UIColor.black
        label.font = .systemFont(ofSize: 34, weight: .medium)
        label.textAlignment = .center
        return label
    }()
    
    let  activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.style = .large
        activityIndicator.color = .red
        return activityIndicator
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //view.backgroundColor = .systemGreen
        //jsonSwiftBaseApi()
        
        setupUI()
        
        // Добавление цели для события Editing Did End
        searchTextField.addTarget(self, action: #selector(editingDidEnd), for: .editingDidEnd)
    }
    
    @objc private func editingDidEnd() {
        // Code to handle the event when editing ends
        print("Editing did end. Text: \(searchTextField.text ?? "")")
    }
    
    func setupUI() {
        view.addSubview(searchTextField)
        view.addSubview(alomafireButton)
        view.addSubview(resultTextView)
        view.addSubview(textLabel)
        view.addSubview(result)
        view.addSubview(activityIndicator)
        
        searchTextField.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(30)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.height.equalTo(40)
        }
        
        
        alomafireButton.snp.makeConstraints { make in
            make.top.equalTo(searchTextField.snp.bottom).offset(70)
            //make.leading.equalTo(urlSessionButton.snp.trailing).offset(70)
            //make.trailing.equalTo(-40)
            make.centerX.equalToSuperview()
            make.height.equalTo(40)
            make.width.equalTo(130)
        }
        
        resultTextView.snp.makeConstraints{ make in
            make.top.equalTo(searchTextField.snp.bottom).offset(130)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-20)
        }
        
        textLabel.snp.makeConstraints{ make in
            make.top.equalTo(searchTextField.snp.bottom).offset(140)
            //make.trailing.equalToSuperview().offset(-90)
            make.leading.equalTo(result.snp.trailing).offset(30)
        }
        
        result.snp.makeConstraints{ make in
            make.top.equalTo(searchTextField.snp.bottom).offset(130)
            make.leading.equalToSuperview().offset(30)
            //make.centerX.equalToSuperview()
        }
        
        activityIndicator.snp.makeConstraints { make in
            make.top.equalTo(searchTextField.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
            //make.bottom.equalTo(resultTextView.snp.top).offset(-3)
        }
    }
    
    
    
    @objc func alomafireButtonTaped() {
        
        // создаем модель
        let item = Item(id: 0, title: titleString)
        
        AF.request(
            "https://jsonplaceholder.typicode.com/posts",
            method: .post,
            parameters: item,
            encoder: JSONParameterEncoder.default
        ).response {[weak self] response in
            guard response.error == nil else {
                return
            }
            
            self?.displaySuccess()
            
            
            debugPrint(response)
        }
        
    }
    
    
    //private func jsonSwiftBaseApi(jsonData: Data)
    private func jsonSwiftBaseApi() {
        
        // создаем модель
        let model1 = JsonSwiftBase(id: 1, title: "Title One")
        let model2 = JsonSwiftBase(id: 2, title: "Title Two")
        let model3 = JsonSwiftBase(id: 3, title: "Title Three")
        
        // преврашаем в Json
        let jsonData = try? JSONSerialization.data(
            withJSONObject: [
                model1.dictionaryRepresentation(),
                model2.dictionaryRepresentation(),
                model3.dictionaryRepresentation()
            ]
        )
        
        // настроиваем запрос
        var request = URLRequest(url: URL(string: "https://jsonplaceholder.typicode.com/posts")!)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData
        
        activityIndicator.startAnimating() // Запуск индикатора загрузки
        
        // делаем запрос и обработываем ответ
        URLSession.shared.dataTask(with: request) { [weak self] (data, response, error) in
            DispatchQueue.main.async {
                self?.activityIndicator.stopAnimating() // Остановка индикатора загрузки
            }
            
            guard let data = data, error == nil else {
                DispatchQueue.main.async {
                    self?.displayFailure()
                }
                return
            }
            
            DispatchQueue.main.async {
                self?.displaySuccess()
                
            }
            
//            if let jsonString = String(data: data, encoding: .utf8) {
//                DispatchQueue.main.async {
//                    self?.resultTextView.text = jsonString
//                }
//            }
            
            let responseJson = try? JSONSerialization.jsonObject(with: data, options: [])
            if let responseJson = responseJson as? [String: Any] {
                print(responseJson)
            }
        }.resume()
    }
    
    
    
    
    private func displaySuccess() {
        textLabel.textColor = .systemGreen
        textLabel.text = "Success: it's OK! "
        textLabel.font = .systemFont(ofSize: 24, weight: .medium)
    }
    
    private func displayFailure() {
        textLabel.textColor = .systemRed
        textLabel.text = "Success: it's not OK!"
        textLabel.font = .systemFont(ofSize: 24, weight: .medium)
    }
    
    
}



