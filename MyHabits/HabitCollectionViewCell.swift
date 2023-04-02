import UIKit

class HabitCollectionViewCell: UICollectionViewCell {
   
    static let id = "habitCollectionViewCell_id"
    
    //замыкание для обновления collectionView в HabbitsViewController при нажатии на habitCheckBox
    var completionHandler: (() -> Void)?
    
    public lazy var habitTitle: UILabel = {
        let label = UILabel ()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.numberOfLines = 2
        return label
    }()
    
    public lazy var habitTime: UILabel = {
        let label = UILabel ()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 13)
        label.textColor = .systemGray2
        return label
    }()
    
    public lazy var habitCounter: UILabel = {
        let label = UILabel ()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 13)
        label.textColor = .gray
        return label
    }()
    
    public lazy var habitCheckBox: UIButton = {
        let button = UIButton ()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(didTapCheckBox), for:.touchUpInside)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        contentView.backgroundColor = .white
        contentView.layer.cornerRadius = 10
        contentView.addSubview(habitTitle)
        contentView.addSubview(habitTime)
        contentView.addSubview(habitCheckBox)
        contentView.addSubview(habitCounter)
        setupConstraints()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupConstraints() {
    
        NSLayoutConstraint.activate([
            
            habitTitle.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 15),
            habitTitle.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
            habitTitle.trailingAnchor.constraint(equalTo: habitCheckBox.leadingAnchor, constant: -20),
            
            habitTime.topAnchor.constraint(equalTo: habitTitle.bottomAnchor, constant: 10),
            habitTime.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
            
            habitCheckBox.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            habitCheckBox.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -30),
            habitCheckBox.widthAnchor.constraint(equalToConstant: 40),
            habitCheckBox.heightAnchor.constraint(equalToConstant: 40),
            
            habitCounter.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
            habitCounter.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20),
            ])
        }
    
    //функция нажатия на checkBox
    @objc private func didTapCheckBox() {
        
        let store = HabitsStore.shared
        for habit in store.habits {
            if habitTitle.text == habit.name && habit.isAlreadyTakenToday == false {
                store.track(habit)
            }
        }
        //вызов замыкания (тело замыкания обновляет collectionView на HabitsViewController) при нажатии на checkBox
        completionHandler?()
        
    }
    
}
