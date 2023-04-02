import UIKit

class HabitDetailsViewController: UIViewController {
    
    //создаю переменную для передачи данных "привычки" с HabitsViewController
    public var currentHabit: Habit?
    
    private lazy var tableView: UITableView = {
        
        let tableView = UITableView.init (frame: .zero, style: .plain)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = UIColor(named: "appGray")
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.dataSource = self
        tableView.delegate = self
        
        return tableView
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        title = currentHabit!.name
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Править", style: .plain, target: self, action: #selector(editHabit))
        navigationItem.largeTitleDisplayMode = .never
        view.addSubview(tableView)
        setupConstraints()
        
    }
    
    private func setupConstraints() {
        let safeAreaGuide = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: safeAreaGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: safeAreaGuide.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: safeAreaGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: safeAreaGuide.trailingAnchor)
        ])
    }
    
    @objc private func editHabit() {
        
        let vc = HabitViewController()
        let habitViewController = UINavigationController(rootViewController: vc)
        vc.isCreatingType = false
        vc.currentHabit = currentHabit
        //определяю completionHandler чтобы возвращать с экрана правки в текущий title название привычки
        vc.completionHandler = { text in
            self.title = text
        }
        habitViewController.modalPresentationStyle = .fullScreen
        present(habitViewController, animated: true)
    }
    
}

extension HabitDetailsViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let header = view as! UITableViewHeaderFooterView
        header.textLabel?.textColor = .systemGray
        header.textLabel?.font = UIFont.systemFont(ofSize: 13)
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "АКТИВНОСТЬ"
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return HabitsStore.shared.dates.count - 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let formatter = DateFormatter()
        formatter.dateFormat = "d MMMM yyyy"
        cell.textLabel?.text = HabitsStore.shared.trackDateString(forIndex: HabitsStore.shared.dates.count - indexPath.row - 2)
        
        if HabitsStore.shared.habit(currentHabit!, isTrackedIn: HabitsStore.shared.dates [HabitsStore.shared.dates.count - indexPath.row - 2]) {
            cell.accessoryView = UIImageView(image: UIImage(systemName: "checkmark", withConfiguration: .none))
        }
        return cell
    }
    
}

extension HabitDetailsViewController: UITableViewDelegate {
    
}
