import UIKit

final class ProfileEditViewController: UIViewController {
    var completionHandler: ((Profile) -> Void)?

    private var viewModel: ProfileEditViewModelProtocol

    private lazy var closeButton: UIButton = {
        let button = UIButton(type: .system)
        button.frame = CGRect(x: 0, y: 0, width: 42, height: 42)
        button.setImage(.NavigationBar.close, for: .normal)
        button.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
        button.tintColor = .Themed.black
        return button
    }()

    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
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

    private lazy var changePhotoLabel: UILabel = {
        let label = UILabel()
        label.font = .Medium.size10
        label.textColor = .Universal.white
        label.text = .ProfileEdit.changePhoto
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 2
        label.textAlignment = .center
        label.layer.cornerRadius = 35
        label.clipsToBounds = true
        label.backgroundColor = .Universal.black?.withAlphaComponent(0.6)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var profileNameTitle: UILabel = {
        return defaultLabel(.ProfileEdit.name)
    }()

    private lazy var profileDescriptionTitle: UILabel = {
        return defaultLabel(.ProfileEdit.description)
    }()

    private lazy var profileWebsiteTitle: UILabel = {
        return defaultLabel(.ProfileEdit.website)
    }()

    private lazy var profileName: UITextView = {
        return defaultTextView(viewModel.profileEdited.name)
    }()

    private lazy var profileDescription: UITextView = {
        return defaultTextView(viewModel.profileEdited.description)
    }()

    private lazy var profileWebsite: UITextView = {
        return defaultTextView(viewModel.profileEdited.website)
    }()

    init(_ viewModel: ProfileEditViewModelProtocol, _ image: UIImage?) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        self.profileImage.image = image
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        viewModel.profileObservable.bind { [weak self] profile in
            guard let self = self else { return }
            self.showLoader(false)
            self.completionHandler?(profile)
            self.dismiss(animated: true)
        }
    }

    private func defaultLabel(_ text: String) -> UILabel {
        let label = UILabel()
        label.font = .Bold.size22
        label.textColor = .Themed.black
        label.text = text
        return label
    }

    private func defaultTextView(_ profileText: String) -> UITextView {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 1.08
        paragraphStyle.lineBreakMode = .byWordWrapping
        let text = UITextView()
        text.attributedText = NSAttributedString(
            string: profileText,
            attributes: [.paragraphStyle: paragraphStyle]
        )
        text.backgroundColor = .Themed.lightGray
        text.layer.cornerRadius = 12
        text.isEditable = true
        text.isScrollEnabled = false
        text.textColor = .Themed.black
        text.font = .Regular.size17
        text.textContainer.lineFragmentPadding = 16
        text.textContainerInset = UIEdgeInsets(top: 11, left: 0, bottom: 11, right: 0)
        return text
    }

    private func setupView() {
        view.backgroundColor = .Themed.white

        [closeButton, scrollView].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }

        [profileImage, profileNameTitle, profileName, profileDescriptionTitle, profileDescription, profileWebsiteTitle, profileWebsite].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            scrollView.addSubview($0)
        }

        profileImage.addSubview(changePhotoLabel)

        setConstraints()
        hideKeyboardWhenTappedAround()
    }

    private func setConstraints() {
        NSLayoutConstraint.activate([
            // closeButton
            closeButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30),
            closeButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),

            // scrollView
            scrollView.topAnchor.constraint(equalTo: closeButton.bottomAnchor, constant: 2),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),

            // profileImage
            profileImage.topAnchor.constraint(equalTo: scrollView.topAnchor),
            profileImage.heightAnchor.constraint(equalToConstant: 70),
            profileImage.widthAnchor.constraint(equalToConstant: 70),
            profileImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            // changePhotoLabel
            changePhotoLabel.centerXAnchor.constraint(equalTo: profileImage.centerXAnchor),
            changePhotoLabel.centerYAnchor.constraint(equalTo: profileImage.centerYAnchor),
            changePhotoLabel.heightAnchor.constraint(equalToConstant: 70),
            changePhotoLabel.widthAnchor.constraint(equalToConstant: 70),

            // profileNameTitle
            profileNameTitle.topAnchor.constraint(equalTo: profileImage.bottomAnchor, constant: 24),
            profileNameTitle.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            profileNameTitle.bottomAnchor.constraint(equalTo: profileName.topAnchor, constant: -8),

            // profileName
            profileName.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            profileName.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            profileName.topAnchor.constraint(equalTo: profileNameTitle.bottomAnchor, constant: 8),
            profileName.bottomAnchor.constraint(equalTo: profileDescriptionTitle.topAnchor, constant: -24),

            // profileDescriptionTitle
            profileDescriptionTitle.topAnchor.constraint(equalTo: profileName.bottomAnchor, constant: 24),
            profileDescriptionTitle.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            profileDescriptionTitle.bottomAnchor.constraint(equalTo: profileDescription.topAnchor, constant: -8),

            // profileDescription
            profileDescription.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            profileDescription.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            profileDescription.topAnchor.constraint(equalTo: profileDescriptionTitle.bottomAnchor, constant: 8),
            profileDescription.bottomAnchor.constraint(equalTo: profileWebsiteTitle.topAnchor, constant: -24),

            // profileWebsiteTitle
            profileWebsiteTitle.topAnchor.constraint(equalTo: profileDescription.bottomAnchor, constant: 24),
            profileWebsiteTitle.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            profileWebsiteTitle.bottomAnchor.constraint(equalTo: profileWebsite.topAnchor, constant: -8),

            // profileWebsite
            profileWebsite.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            profileWebsite.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            profileWebsite.topAnchor.constraint(equalTo: profileWebsiteTitle.bottomAnchor, constant: 8),
            profileWebsite.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            ])
    }

    @objc
    private func closeButtonTapped() {
        setProfileEdited()
    }

    private func setProfileEdited() {
        let profile = ProfileEdited(name: profileName.text,
            description: profileDescription.text,
            website: profileWebsite.text)
        if profile != viewModel.profileEdited {
            showLoader(true)
            viewModel.setProfileEdited(profile)
        } else {
            dismiss(animated: true)
        }
    }

    private func showLoader(_ isShow: Bool) {
        switch isShow {
        case true:
            UIBlockingProgressHUD.show()
        case false:
            UIBlockingProgressHUD.dismiss()
        }
    }
}
