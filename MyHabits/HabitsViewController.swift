import UIKit

class HabitsViewController: UIViewController {

    //кнопка создания новой привычки на navigation bar
    private lazy var newHabitImage: UIImageView = {[unowned self] in
        let myImage  = UIImageView ()
        myImage.contentMode = .scaleAspectFit
        myImage.image = UIImage(systemName: "plus")
        myImage.bounds = CGRect(x: 0, y: 0, width: 22, height: 22)
        myImage.isUserInteractionEnabled = true
        let tapX = UITapGestureRecognizer( target: self, action: #selector(didTapX))
        myImage.addGestureRecognizer(tapX)
        return myImage
    }()
    
    private let collectionView: UICollectionView = {
        let viewLayout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: viewLayout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = UIColor(named: "appGray")
            
        collectionView.register(HabitCollectionViewCell.self, forCellWithReuseIdentifier: HabitCollectionViewCell.id)
        collectionView.register(ProgressCollectionViewCell.self, forCellWithReuseIdentifier: ProgressCollectionViewCell.id)
        return collectionView
    }()
    
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        collectionView.collectionViewLayout.invalidateLayout()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        navigationItem.hidesBackButton = true
        collectionView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Сегодня"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.backgroundColor = .white
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: newHabitImage)
        view.backgroundColor = .white
        view.addSubview(collectionView)
        setupConstraints()
        collectionView.dataSource = self
        collectionView.delegate = self

    }
    
    private func setupConstraints() {
        let safeAreaGuide = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: safeAreaGuide.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: safeAreaGuide.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: safeAreaGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: safeAreaGuide.trailingAnchor)
        ])
    }
    
    
    //функция добавления новой привычки
    @objc private func didTapX() {
        let vc = HabitViewController()
        let habitViewController = UINavigationController(rootViewController: vc)
        vc.isCreatingType = true
        habitViewController.modalPresentationStyle = .fullScreen
        present(habitViewController, animated: true)
        
    }
    
}
extension HabitsViewController: UICollectionViewDataSource {
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0: return 1
        case 1: do {
            let store = HabitsStore.shared
            return store.habits.count
        }
        default: break
        }
        return 0
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.section {
            
            case 0:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProgressCollectionViewCell.id, for: indexPath) as? ProgressCollectionViewCell else {
                fatalError("could not dequeueReusableCell")
            }
            let store = HabitsStore.shared
            cell.habitProgress.text = String (format: "%.0f", store.todayProgress*100) + "%"
            cell.habitProgressView.progress = store.todayProgress
            return cell
            
            
             case 1:
             guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HabitCollectionViewCell.id, for: indexPath) as? HabitCollectionViewCell else {
             fatalError("could not dequeueReusableCell")
             }
             let store = HabitsStore.shared
             let habit = store.habits[indexPath.row]
             cell.habitTitle.text = habit.name
             cell.habitTitle.textColor = habit.color
             cell.habitCheckBox.tintColor = habit.color
             cell.habitTime.text = habit.dateString
             //настройка отображения checkBox
             if habit.isAlreadyTakenToday {
             cell.habitCheckBox.setImage(UIImage(systemName: "checkmark.circle.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: 40)), for: .normal)
             } else {
             cell.habitCheckBox.setImage(UIImage(systemName: "circle", withConfiguration: UIImage.SymbolConfiguration(pointSize: 40)), for: .normal)
             }
             cell.habitCounter.text = "Счетчик: \(habit.trackDates.count)"
             //определяю замыкание - обновляет collectionView при нажатии на кнопку checkBox
             cell.completionHandler = {
             collectionView.reloadData()
             }
             return cell
             
             default: break
             }
             return UICollectionViewCell ()
        }
}

extension HabitsViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
           
       switch indexPath.section {
           
       case 0: return CGSize(width: view.safeAreaLayoutGuide.layoutFrame.width-30, height: 60)
       case 1: return CGSize(width: view.safeAreaLayoutGuide.layoutFrame.width-30, height: 150)
       default: break
       }
       return CGSize(width: 0, height: 0)
    }
       
    
    func collectionView(_ collectionView: UICollectionView,layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        switch section {
        case 0: return UIEdgeInsets(top: 20, left: 0, bottom: 10, right: 0)
        case 1: return UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
        default: break
        }
        return UIEdgeInsets ()
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if indexPath.section == 1 {
            let habitDetailsViewController = HabitDetailsViewController()
            navigationController?.pushViewController(habitDetailsViewController, animated: true)
            let store = HabitsStore.shared
            habitDetailsViewController.currentHabit = store.habits [indexPath.row]
        }
    }
    

}
