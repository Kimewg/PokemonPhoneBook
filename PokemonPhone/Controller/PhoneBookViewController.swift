import UIKit
import SnapKit
import CoreData

class PhoneBookViewController: UIViewController {
    // Core Data에서 사용할 NSPersistentContainer
    var container: NSPersistentContainer!
    // 랜덤 이미지 생성 후 이미지 URL을 저장할 변수
    private var imageURLString: String?
    
    private let addButton: UIBarButtonItem = {
        return UIBarButtonItem(title: "적용", style: .plain, target: self, action: #selector(didTapSaveButton))
    }()
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "연락처 추가"
        label.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        return label
    }()
    private let phoneImage: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .white
        imageView.layer.borderColor = UIColor.gray.cgColor
        imageView.layer.borderWidth = 2
        imageView.layer.cornerRadius = 70
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    private let randomButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("랜덤 이미지 생성", for: .normal)
        button.setTitleColor(.gray, for: .normal)
        button.addTarget(self, action: #selector(didTapRandomButton), for: .touchUpInside)
        return button
    }()
    private let nameTextField: UITextField = {
        let textField = UITextField()
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor.gray.cgColor
        textField.layer.cornerRadius = 8
        return textField
    }()
    private let phoneNumberTextField: UITextField = {
        let textField = UITextField()
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor.gray.cgColor
        textField.layer.cornerRadius = 8
        return textField
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        self.container = appDelegate.persistentContainer
        
    }
    // 서버 데이터를 불러오는 메서드
    private func fetchData<T: Decodable>(url: URL, completion: @escaping (T?) -> Void) {
        // 세션 준비
        let session = URLSession(configuration: .default)
        // 네트워크 통신 시작
        session.dataTask(with: URLRequest(url: url)) {
            data, response, error in
            guard let data = data, error == nil else {
                print("데이터 로드 실패")
                completion(nil)
                return
            }
            // http status code 성공 범위.
            let successRange = 200..<300
            if let response = response as? HTTPURLResponse, successRange.contains(response.statusCode) {
                guard let decodedData = try? JSONDecoder().decode(T.self, from: data) else{
                    print("JSON 디코딩 실패")
                    completion(nil)
                    return
                }
                completion(decodedData)
            } else {
                print("응답 오류")
                completion(nil)
            }
        }.resume()
    }
    
    private func configureUI() {
        view.backgroundColor = .white
        self.navigationItem.rightBarButtonItem = addButton
        [
            titleLabel,
            phoneImage,
            randomButton,
            nameTextField,
            phoneNumberTextField
        ].forEach { view.addSubview($0) }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).inset(0)
            $0.centerX.equalToSuperview()
        }
        phoneImage.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(titleLabel.snp.bottom).offset(30)
            $0.width.height.equalTo(140)
        }
        randomButton.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(phoneImage.snp.bottom).offset(10)
        }
        nameTextField.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(randomButton.snp.bottom).offset(20)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(44)
        }
        phoneNumberTextField.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(nameTextField.snp.bottom).offset(10)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(44)
        }
    }

    @objc private func didTapRandomButton() {
        let randomID = Int.random(in: 1...1000)
        let urlString = "https://pokeapi.co/api/v2/pokemon/\(randomID)" // Pokémon API URL
        guard let url = URL(string: urlString) else { return }
        // 서버에서 데이터를 받아오기 위한 fetchData 호출
        fetchData(url: url) { [weak self] (pokemon: Pokemon?) in
            guard let self, let pokemon = pokemon else { return }
            
            // 이미지 URL 가져오기
            let imageURLString = pokemon.sprites.frontDefault
            
            guard let imageURL = URL(string: imageURLString) else { return }
            // 이미지 데이터 가져오기
            if let imageData = try? Data(contentsOf: imageURL),
               let image = UIImage(data: imageData) {
                DispatchQueue.main.async {
                    self.phoneImage.image = image
                }
            }
        }
    }
    
    @objc private func didTapSaveButton() {
        guard let name = nameTextField.text, !name.isEmpty, let phoneNumber = phoneNumberTextField.text, !phoneNumber.isEmpty else {
            return
        }
        
        // 이미지가 선택된 경우 Base64로 변환
        var imageString: String?
        if let image = phoneImage.image, let imageData = image.pngData() {
            imageString = imageData.base64EncodedString()
        }
        // Core Data에 새로운 연락처 데이터 저장
        guard let entity = NSEntityDescription.entity(forEntityName: "PhoneBook", in: container.viewContext) else { return }
        let newPhoneBook = NSManagedObject(entity: entity, insertInto: container.viewContext)
        newPhoneBook.setValue(name, forKey: "name")
        newPhoneBook.setValue(phoneNumber, forKey: "phoneNumber")
        newPhoneBook.setValue(imageString, forKey: "image")
        
        do {
            try container.viewContext.save()
            print("저장 성공")
            
            // 데이터 저장 후 ViewController에 알리기
            if let viewController = navigationController?.viewControllers.first(where: { $0 is ViewController }) as? ViewController {
                viewController.readAllData()  // 테이블 뷰 갱신
            }
            navigationController?.popViewController(animated: true)
        } catch {
            print("저장 실패")
        }
    }
    
}
