import UIKit
import SnapKit
import CoreData

class ViewController: UIViewController {
    // 연락처 데이터를 저장할 배열
    var tableData: [PhoneBook] = []
    // Core Data 컨테이너
    var container: NSPersistentContainer!
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "친구 목록"
        label.textColor = .black
        label.font = .systemFont(ofSize: 20, weight: .bold)
        return label
    }()
    private let addButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("추가", for: .normal)
        button.setTitleColor(.gray, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 18, weight: .regular)
        button.addTarget(self, action: #selector(tappedaddButton), for: .touchUpInside)
        return button
    }()
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(TableViewCell.self, forCellReuseIdentifier: TableViewCell.id)
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        tableView.delegate = self
        tableView.dataSource = self
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        self.container = appDelegate.persistentContainer
        
        readAllData()
    }
    // Core Data에서 연락처 데이터를 읽고 테이블 뷰를 갱신하는 메서드
    func readAllData() {
        // 이름순으로 테이블뷰 정리
        let request = NSFetchRequest<PhoneBook>(entityName: "PhoneBook")
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        request.sortDescriptors = [sortDescriptor]
        
        do {
            // Core Data에서 PhoneBook 엔티티를 가져옴
            let phoneBooks = try self.container.viewContext.fetch(request)
            self.tableData = phoneBooks // 읽은 데이터를 tableData에 저장
            self.tableView.reloadData() // 테이블 뷰 갱신
        } catch {
            print("데이터 읽기 실패")
        }
    }

    private func configureUI() {
        view.backgroundColor = .white
        [
            titleLabel,
            addButton,
            tableView
        ].forEach { view.addSubview($0) }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).inset(0) 
            $0.centerX.equalToSuperview()
        }
        
        addButton.snp.makeConstraints {
            $0.centerY.equalTo(titleLabel)
            $0.trailing.equalToSuperview().inset(20)
        }
        
        tableView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(30)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.bottom.equalToSuperview().inset(20)
        }
    }
    
    @objc func tappedaddButton() {
        let nextVC = PhoneBookViewController()
        nextVC.view.backgroundColor = .systemBackground
        self.navigationController?.pushViewController(nextVC, animated: true)
    }

}
// 테이블 뷰의 델리게이트 및 데이터 소스 구현
extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return tableData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCell.id , for: indexPath) as? TableViewCell else { return UITableViewCell() }
        
        let data = tableData[indexPath.row]
        // 이미지 데이터 처리 (Base64로 인코딩된 이미지를 UIImage로 변환)
        var image: UIImage? = nil
        if let imageString = data.image as? String,
           let imageData = Data(base64Encoded: imageString) {
            image = UIImage(data: imageData)
        }
        
        cell.configureCell(nameText: data.name ?? "", phoneNumberText: data.phoneNumber ?? "", image: image)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
}
