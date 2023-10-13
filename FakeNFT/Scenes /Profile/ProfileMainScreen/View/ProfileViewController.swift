import UIKit
import Kingfisher
import SafariServices

final class ProfileViewController: UIViewController {
    private let viewModel: ProfileViewModelProtocol

    private lazy var editButton: UIBarButtonItem = {
        let button = UIButton(type: .system)
        button.frame = CGRect(x: 0, y: 0, width: 42, height: 42)
        button.setImage(.NavigationBar.edit, for: .normal)
        button.addTarget(self, action: #selector(editButtonTapped), for: .touchUpInside)
        button.tintColor = .Themed.black
        let barButton = UIBarButtonItem(customView: button)
        return barButton
    }()

    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 20, right: 0)
        return scrollView
    }()

    private lazy var profileImage: UIImageView = {
        let image = UIImageView()
        image.backgroundColor = .Themed.lightGray
        image.contentMode = .scaleAspectFill
        image.layer.cornerRadius = 35
        image.clipsToBounds = true
        return image
    }()

    private lazy var profileName: UILabel = {
        let label = UILabel()
        label.font = .Bold.size22
        label.textColor = .Themed.black
        label.numberOfLines = 2
        label.lineBreakMode = .byWordWrapping
        return label
    }()

    private lazy var profileDescription: UILabel = {
        let label = UILabel()
        label.isUserInteractionEnabled = true
        label.textColor = .Themed.black
        label.font = .Regular.size13
        let tappedOnText = UITapGestureRecognizer(target: self, action: #selector(textTapped))
        label.addGestureRecognizer(tappedOnText)
        return label
    }()

    private lazy var profileWebsite: UITextView = {
        let text = UITextView()
        text.backgroundColor = .Themed.white
        text.isEditable = false
        text.isScrollEnabled = false
        text.textColor = .Universal.blue
        text.linkTextAttributes = [.foregroundColor: UIColor.Universal.blue ?? .blue]
        text.font = .Regular.size15
        text.textContainer.lineFragmentPadding = 0
        text.textContainerInset = .zero
        text.dataDetectorTypes = .link
        text.delegate = self
        return text
    }()

    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.separatorStyle = .none
        tableView.isScrollEnabled = false
        tableView.register(ProfileTableViewCell.self)
        tableView.dataSource = self
        tableView.delegate = self
        return tableView
    }()

    init(viewModel: ProfileViewModelProtocol = ProfileViewModel()) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        viewModel.profileObservable.bind { [weak self] profile in
            guard let self = self else { return }
            self.setProfile(profile)
            self.showLoader(false)
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        profileDescriptionExpand(false)
        showLoader(true)
        viewModel.fetchProfile()
    }

    private func setupView() {
        navigationItem.rightBarButtonItem = editButton
        navigationController?.navigationBar.isTranslucent = false

        view.addSubview(scrollView)

        [profileImage, profileName, profileDescription, profileWebsite, tableView].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            scrollView.addSubview($0)
        }

        setConstraints()
    }

    private func setConstraints() {
        NSLayoutConstraint.activate([
            // scrollView
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),

            // profileImage
            profileImage.topAnchor.constraint(equalTo: scrollView.topAnchor),
            profileImage.heightAnchor.constraint(equalToConstant: 70),
            profileImage.widthAnchor.constraint(equalToConstant: 70),
            profileImage.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),

            // profileName
            profileName.leadingAnchor.constraint(equalTo: profileImage.trailingAnchor, constant: 16),
            profileName.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            profileName.centerYAnchor.constraint(equalTo: profileImage.centerYAnchor),

            // profileDescription
            profileDescription.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            profileDescription.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            profileDescription.topAnchor.constraint(equalTo: profileImage.bottomAnchor, constant: 20),
            profileDescription.bottomAnchor.constraint(equalTo: profileWebsite.topAnchor, constant: -12),

            // profileWebsite
            profileWebsite.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            profileWebsite.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            profileWebsite.topAnchor.constraint(equalTo: profileDescription.bottomAnchor, constant: 12),
            profileWebsite.bottomAnchor.constraint(equalTo: tableView.topAnchor, constant: -44),

            // tableView
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.topAnchor.constraint(equalTo: profileWebsite.bottomAnchor, constant: 44),
            tableView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            tableView.heightAnchor.constraint(equalToConstant: 162)
            ])
    }

    private func showLoader(_ isShow: Bool) {
        switch isShow {
        case true:
            UIBlockingProgressHUD.show()
        case false:
            UIBlockingProgressHUD.dismiss()
        }
    }

    private func setProfile(_ profile: Profile) {
        let url = URL(string: profile.avatar)
        profileImage.kf.indicatorType = .activity
        profileImage.kf.setImage(with: url)

        profileName.text = profile.name

        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 1.16
        paragraphStyle.lineBreakMode = .byTruncatingTail
        profileDescription.attributedText = NSAttributedString(string: profile.description,
            attributes: [.paragraphStyle: paragraphStyle])

        profileWebsite.text = profile.website

        tableView.reloadData()
    }

    @objc
    private func editButtonTapped() {
        let profile = ProfileEdited(name: profileName.text ?? "",
            description: profileDescription.text ?? "",
            website: profileWebsite.text ?? "")
        let vc = ProfileEditViewController(ProfileEditViewModel(profile), profileImage.image)
        vc.completionHandler = { [weak self] profile in
            guard let self = self else { return }
            self.setProfile(profile)
        }
        present(vc, animated: true)
    }

    @objc
    func textTapped() {
        if profileDescription.numberOfLines == 0 {
            profileDescriptionExpand(false)
        } else {
            profileDescriptionExpand(true)
        }
    }

    private func profileDescriptionExpand(_ isExpand: Bool) {
        switch isExpand {
        case true:
            profileDescription.numberOfLines = 0
        case false:
            profileDescription.numberOfLines = 4
        }
    }

    private func openWebView(with url: URL) {
        let vc = SFSafariViewController(url: url)
        present(vc, animated: true)
    }
}

extension ProfileViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: ProfileTableViewCell = tableView.dequeueReusableCell()

        let nfts = viewModel.profile.nfts.count
        let likes = viewModel.profile.likes.count

        switch indexPath.row {
        case 0:
            cell.setLabelText(.ProfileTable.myNFTs + "(\(nfts))")
        case 1:
            cell.setLabelText(.ProfileTable.myLikes + "(\(likes))")
        case 2:
            cell.setLabelText(.ProfileTable.about)
        default:
            break
        }

        return cell
    }
}

extension ProfileViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 54
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            break
        case 1:
            break
        case 2:
            guard let url = URL(string: viewModel.profile.website) else { return }
            openWebView(with: url)
        default:
            break
        }
    }
}

extension ProfileViewController: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        openWebView(with: URL)
        return false
    }
}
