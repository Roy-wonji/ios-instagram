//
//  ProfileHeader.swift
//  instagram
//
//  Created by 서원지 on 2022/05/06.
//

import UIKit
import Then

final class ProfileHeader: UICollectionReusableView {
    //MARK:  - Properties
    private lazy var profileImageView = UIImageView().then { imageView  in
        imageView.image = UIImage(named: "venom-7")
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
    }
    
    private lazy var nameLabel = UILabel().then { label in
        label.text = ProfileUIText.nameLabelText
        label.font = UIFont.boldSystemFont(ofSize: 14)
    }
    
    
    private lazy var editProfileFollowButton = UIButton(type: .system).then { button in
        button.setTitle(ProfileUIText.editProfileFollowButtonText, for: .normal)
        button.layer.cornerRadius = 3
        button.clipsToBounds = true
        button.layer.borderColor = UIColor.lightGray.cgColor
        button.layer.borderWidth = 0.5
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.setTitleColor(.black, for: .normal)
        button.addTarget(self, action: #selector(handleEditProfileFollowTapped), for: .touchUpInside)
    }
    
    private lazy var postLabel = UILabel().then { label in
        label.numberOfLines = .zero
        label.textAlignment = .center
        label.attributedText = attributedStatText(value: 1, label: ProfileUIText.postLabelText)
    }
    
    private lazy var followersLabel = UILabel().then { label in
        label.numberOfLines = .zero
        label.textAlignment = .center
        label.attributedText = attributedStatText(value: 2, label: ProfileUIText.followerLabelText)
    }
    
    private lazy var followingLabel = UILabel().then { label in
        label.numberOfLines = .zero
        label.textAlignment = .center
        label.attributedText = attributedStatText(value: 1, label: ProfileUIText.followingLabelText)
    }
    
    private lazy var gridButton = UIButton(type: .system).then { button in
        button.setImage(UIImage(named: "grid"), for: .normal)
    }
    
    private lazy var listButton = UIButton(type: .system).then { button in
        button.setImage(UIImage(named: "list"), for: .normal)
        button.tintColor = UIColor(white: .zero, alpha: 0.2)
    }
    private lazy var bookmarkButton = UIButton(type: .system).then { button in
        button.setImage(UIImage(named: "ribbon"), for: .normal)
        button.tintColor = UIColor(white: .zero, alpha: 0.2)
    }
    
    //MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        updateUI()
    }
    
    private func updateUI() {
        backgroundColor = .white
        configureUI()
        
    }
    
    private func configureUI() {
        setPostImageView()
        setNameLabel()
        setEditProfileFollowButton()
        setFollowingStackView()
        setBottomStackView()
    }
    
    private func setPostImageView() {
        addSubview(profileImageView)
        profileImageView.anchor(top: topAnchor, left: leftAnchor, paddingTop: 16, paddingLeft: 12)
        profileImageView.setDimensions(height: 80, width: 80)
        profileImageView.layer.cornerRadius = 80 / 2
    }
    
    private func setNameLabel() {
        addSubview(nameLabel)
        nameLabel.anchor(top: profileImageView.bottomAnchor, left: leftAnchor, paddingTop: 12,
                         paddingLeft: 12)
    }
    
    private func setEditProfileFollowButton() {
        addSubview(editProfileFollowButton)
        editProfileFollowButton.anchor(top: nameLabel.bottomAnchor, left: leftAnchor,
                                       right: rightAnchor, paddingTop: 16,
                                       paddingLeft: 24, paddingRight: 24)
    }
    
    private func setFollowingStackView() {
        let stackView = UIStackView(arrangedSubviews: [postLabel, followersLabel, followingLabel])
        stackView.distribution = .fillEqually
        
        addSubview(stackView)
        stackView.centerY(inView: profileImageView)
        stackView.anchor(left: profileImageView.rightAnchor, right: rightAnchor,
                         paddingLeft: 12, paddingRight: 12, height: 50)
    }
    
    private func setBottomStackView() {
        let topDivider = UIView()
        topDivider.backgroundColor = .lightGray
        
        let bottomDivider = UIView()
        bottomDivider.backgroundColor = .lightGray
        
        let bottomStackView = UIStackView(arrangedSubviews: [gridButton, listButton, bookmarkButton])
        bottomStackView.distribution = .fillEqually
        
        addSubview(bottomStackView)
        addSubview(topDivider)
        addSubview(bottomDivider)
        
        bottomStackView.anchor(left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, height: 50)
        topDivider.anchor(top: bottomStackView.bottomAnchor, left: leftAnchor, right: rightAnchor, height: 0.5)
        bottomDivider.anchor(top: bottomStackView.bottomAnchor, left: leftAnchor, right: rightAnchor, height: 0.5)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK:  - Actions
    @objc func handleEditProfileFollowTapped( ) {
        print("DEBUG: handle edit profile tapped")
    }
    
    //MARK: - label 관련 함수
    func attributedStatText(value: Int, label: String) -> NSAttributedString {
        let attributedText = NSMutableAttributedString(string: "\(value)\n", attributes: [.font: UIFont.boldSystemFont(ofSize: 14)])
        attributedText.append(NSAttributedString(string: label, attributes:  [.font: UIFont.boldSystemFont(ofSize: 14), .foregroundColor: UIColor.lightGray]))
        return attributedText
    }
}
