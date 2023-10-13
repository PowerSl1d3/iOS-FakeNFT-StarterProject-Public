import UIKit

final class ProfileTableViewCell: UITableViewCell, ReuseIdentifying {

    private lazy var label: UILabel = {
        let label = UILabel()
        label.font = .Bold.size17
        label.textColor = .Themed.black
        return label
    }()

    private lazy var chevronImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = .ProfileTable.chevron
        imageView.tintColor = .Themed.black
        imageView.contentMode = .center
        return imageView
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupContentView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupContentView() {
        selectionStyle = .none
        backgroundColor = .Themed.white

        [label, chevronImage].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview($0)
        }

        setConstraints()
    }

    private func setConstraints() {
        NSLayoutConstraint.activate([
            // stackView
            label.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            label.trailingAnchor.constraint(equalTo: chevronImage.leadingAnchor, constant: -16),

            // chevronImageView
            chevronImage.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            chevronImage.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
            ])
    }

    func setLabelText(_ text: String) {
        label.text = text
    }
}
