import UIKit
import SnapKit

class TableViewCell: UITableViewCell {
    
    static let id = "TableViewCell"
    
    private let sprites: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .white
        imageView.layer.borderColor = UIColor.gray.cgColor
        imageView.layer.borderWidth = 2
        imageView.layer.cornerRadius = 30
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let name: UILabel = {
        let label = UILabel()
        label.backgroundColor = .white
        label.textColor = .black
        label.font = .systemFont(ofSize: 18, weight: .regular)
        return label
    }()
    
    private let phoneNumber: UILabel = {
        let label = UILabel()
        label.backgroundColor = .white
        label.textColor = .black
        label.font = .systemFont(ofSize: 18, weight: .regular)
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureUI()
    }
    
    private func configureUI() {
        contentView.backgroundColor = .white
        [
            sprites,
            name,
            phoneNumber
        ].forEach { contentView.addSubview($0) }
        sprites.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(20)
            $0.centerY.equalToSuperview()
            $0.width.height.equalTo(60)
        }
        name.snp.makeConstraints {
            $0.leading.equalTo(sprites.snp.trailing).offset(20)
            $0.trailing.lessThanOrEqualTo(phoneNumber.snp.leading).offset(-10)
            $0.centerY.equalToSuperview()
        }
        phoneNumber.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(20)
            $0.centerY.equalToSuperview()
            $0.width.greaterThanOrEqualTo(120)
        }
    }
    
    public func configureCell(nameText: String, phoneNumberText: String, image: UIImage?) {
           name.text = nameText
           phoneNumber.text = phoneNumberText
           sprites.image = image
       }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
