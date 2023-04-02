import UIKit

class ProgressCollectionViewCell: UICollectionViewCell {
    
    static let id = "progressCollectionViewCell_id"
    
    public lazy var habitText: UILabel = {
        let label = UILabel ()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 13)
        label.text = "Все получится!"
        label.textColor = .systemGray
        return label
    }()
    
    public lazy var habitProgress: UILabel = {
        let label = UILabel ()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 13)
        label.textColor = .systemGray
        return label
    }()
    
    public lazy var habitProgressView: UIProgressView = {
        let progressView = UIProgressView ()
        progressView.translatesAutoresizingMaskIntoConstraints = false
        progressView.progressViewStyle = .default
        return progressView
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        contentView.backgroundColor = .white
        contentView.layer.cornerRadius = 10
        contentView.addSubview(habitText)
        contentView.addSubview(habitProgress)
        contentView.addSubview(habitProgressView)
        setupConstraints()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupConstraints() {
        
        NSLayoutConstraint.activate([
            habitText.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            habitText.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            
            habitProgress.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            habitProgress.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            
            habitProgressView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            habitProgressView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            habitProgressView.topAnchor.constraint(equalTo: habitProgress.bottomAnchor, constant: 10)
            
            ])
        }
    
}
