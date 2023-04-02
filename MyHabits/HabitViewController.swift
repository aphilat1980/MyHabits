import UIKit

class HabitViewController: UIViewController {
    
    //переменная для передачи данных привычки на данный контроллер. Поскольку никогда не равна nil при переходе на данный контроллер, для извлечения данных далее везде использовал force unwrapping
    public var currentHabit: Habit?
    
    //создаю замыкание, чтобы передавать с данного экрана новое имя привычки в случае редактирования на экран HabitDetailsViewController
    var completionHandler: ((String) -> Void)?
    
    //переменная для определения типа экрана: редактирование или создание привычки
    public var  isCreatingType: Bool = true
    
    //переменная для определения цвета при открытии UIColorPicker
    var selectedColorInColorPicker = UIColor.white
    
    private lazy var formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm a"
        return formatter
    } ()
    
    private lazy var habitTitleTitle: UILabel = {
        let label = UILabel ()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 13)
        label.textColor = .black
        label.text = "НАЗВАНИЕ"
        return label
    }()
    
    private lazy var habitColorTitle: UILabel = {
        let label = UILabel ()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 13)
        label.textColor = .black
        label.text = "ЦВЕТ"
        return label
    }()
    
    private lazy var habitTimeTitle: UILabel = {
        let label = UILabel ()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 13)
        label.textColor = .black
        label.text = "ВРЕМЯ"
        return label
    }()
    
    private lazy var habitTitleTextField: UITextField = {
        let textField = UITextField ()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Бегать по утрам, спать 8 часов и т.п."
        textField.font = UIFont.systemFont(ofSize: 16)
        textField.textColor = .black
        textField.autocorrectionType = UITextAutocorrectionType.no
        textField.keyboardType = UIKeyboardType.default
        textField.returnKeyType = UIReturnKeyType.done
        textField.clearButtonMode = UITextField.ViewMode.whileEditing
        textField.contentVerticalAlignment = UIControl.ContentVerticalAlignment.center
        textField.tintColor = UIColor(named: "AccentColor")
        textField.autocapitalizationType = .none
        textField.delegate = self
        return textField
    }()
    
    private lazy var habitColor: UIView = {
        let view = UIView ()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = selectedColorInColorPicker
        view.layer.borderWidth = 0.5
        view.layer.borderColor = UIColor.lightGray.cgColor
        view.layer.cornerRadius = 15
        view.isUserInteractionEnabled = true
        let tapColor = UITapGestureRecognizer( target: self, action: #selector(didTapColor))
        view.addGestureRecognizer(tapColor)
        return view
    }()
    
    //целесообразней было сделать просто переменную и для view добавлять ее к habitDateText, по пришлось  делать отдельный UILabel, так как не нашел инструмента чтобы выделить отд цветом часть текста habitDateText.text
    private lazy var habitDate: UILabel = {
        let label = UILabel ()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = .white
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = UIColor(named: "AccentColor")
        return label
    }()
    
    private lazy var habitDateText: UILabel = {
        let label = UILabel ()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = label.font.withSize(16)
        label.textColor = .black
        label.text = "Каждый день в "
        return label
    }()
    
    private lazy var datePicker: UIDatePicker = {
        let datePicker = UIDatePicker ()
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        datePicker.datePickerMode = .time
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.addTarget(self, action: #selector(habitDateChanged), for: .valueChanged)
        return datePicker
    }()
    
    private lazy var deleteHabit: UILabel = {
        let label = UILabel ()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 17)
        label.textColor = .systemRed
        label.isUserInteractionEnabled = true
        let tapLabel = UITapGestureRecognizer( target: self, action: #selector(didDeleteHabit))
        label.addGestureRecognizer(tapLabel)
        label.text = "Удалить привычку"
        return label
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(habitTitleTitle)
        view.addSubview(habitColorTitle)
        view.addSubview(habitTimeTitle)
        view.addSubview(datePicker)
        view.addSubview(habitTitleTextField)
        view.addSubview(habitColor)
        view.addSubview(habitDate)
        view.addSubview(habitDateText)
        setupConstraints()
        navBarSetup()
        
        if isCreatingType {
            habitDate.text = formatter.string(from: datePicker.date)
        } else {
            habitTitleTextField.text = currentHabit!.name
            habitTitleTextField.textColor = currentHabit!.color
            habitColor.backgroundColor = currentHabit!.color
            selectedColorInColorPicker = currentHabit!.color
            habitDate.text = formatter.string(from: currentHabit!.date)
            view.addSubview(deleteHabit)
            setupConstraintsDeleteButton()
        }
            
    }
    
    private func setupConstraints() {
        
        let safeAreaGuide = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            
            habitTitleTitle.leadingAnchor.constraint(equalTo: safeAreaGuide.leadingAnchor, constant: 20),
            habitTitleTitle.topAnchor.constraint(equalTo: safeAreaGuide.topAnchor, constant: 25),
            
            habitColorTitle.topAnchor.constraint(equalTo: habitTitleTitle.bottomAnchor, constant: 60),
            habitColorTitle.leadingAnchor.constraint(equalTo: habitTitleTitle.leadingAnchor),
            
            habitTimeTitle.topAnchor.constraint(equalTo: habitColorTitle.bottomAnchor, constant: 60),
            habitTimeTitle.leadingAnchor.constraint(equalTo: habitTitleTitle.leadingAnchor),
            
            habitTitleTextField.topAnchor.constraint(equalTo: habitTitleTitle.bottomAnchor, constant: 15),
            habitTitleTextField.leadingAnchor.constraint(equalTo: habitTitleTitle.leadingAnchor),
            habitTitleTextField.trailingAnchor.constraint(equalTo: safeAreaGuide.trailingAnchor, constant: -20),
            
            habitColor.topAnchor.constraint(equalTo: habitColorTitle.bottomAnchor, constant: 15),
            habitColor.leadingAnchor.constraint(equalTo: habitTitleTitle.leadingAnchor),
            habitColor.widthAnchor.constraint(equalToConstant: 30),
            habitColor.heightAnchor.constraint(equalToConstant: 30),
            
            habitDate.leadingAnchor.constraint(equalTo: habitDateText.trailingAnchor, constant: 5),
            habitDate.bottomAnchor.constraint(equalTo: habitDateText.bottomAnchor),
            
            
            habitDateText.leadingAnchor.constraint(equalTo: habitTitleTitle.leadingAnchor),
            habitDateText.topAnchor.constraint(equalTo: habitTimeTitle.centerYAnchor, constant: 25),
            
            datePicker.centerXAnchor.constraint(equalTo: safeAreaGuide.centerXAnchor),
            datePicker.topAnchor.constraint(equalTo: habitDateText.bottomAnchor, constant: 10)
        ])
    }
    
    private func setupConstraintsDeleteButton() {
        
        NSLayoutConstraint.activate([
            deleteHabit.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            deleteHabit.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -30)
        ])
    }
    
    //чтобы не загромождать viewDidLoad, вынес настройку nav bar'а в отдельную функцию
    private func navBarSetup () {
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Отменить", style: .plain, target: self, action: #selector(dismissNewHabit))
        navigationController?.navigationBar.backgroundColor = .systemGray6
        if isCreatingType {
            title = "Cоздать"
            navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Сохранить", style: .done, target: self, action: #selector(createNewHabit))
        } else {
            title = "Править"
            navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Сохранить", style: .done, target: self, action: #selector(saveEdittedHabit))
        }
        
    }
    
   
    //функция при нажатии "отмена"
    @objc private func dismissNewHabit() {
        dismiss(animated: true)
    }
    
   //создать новую привычку
    @objc private func createNewHabit() {
        //поскольку цвет и дата установлены по умолчанию, добавил только проверку на наличие у привычки имени
        if self.habitTitleTextField.text! != "" {
            let newHabit = Habit(name: self.habitTitleTextField.text!,
                                 date: formatter.date(from: self.habitDate.text!)!,
                                 color: self.habitColor.backgroundColor!)
            let store = HabitsStore.shared
            store.habits.append(newHabit)
            dismiss(animated: true)
        } else {
            //решил сделать всплывающее окно, предупреждающее что привычка не сохранится
            let alert = UIAlertController(title: "Привычка не сохранена", message: "Не введено имя привычки", preferredStyle: .alert)
            let action1 = UIAlertAction(title: "Продолжить редактирование", style: .default, handler: {action in })
            alert.addAction(action1)
            present(alert, animated: true)
        }
    }
    
    //удаление привычки
    @objc private func didDeleteHabit() {
        
        let store = HabitsStore.shared
        let alert = UIAlertController(title: "Удалить привычку", message: "Вы хотите удалить привычку \"\(currentHabit!.name)\"", preferredStyle: .alert)
        let action1 = UIAlertAction(title: "Отмена", style: .cancel, handler: {
            action in
        })
        let action2 = UIAlertAction(title: "Удалить", style: .destructive, handler: {action in
            for (index, habit) in store.habits.enumerated() {
                if habit == self.currentHabit {
                    store.habits.remove(at: index)
                }
            }
            let habitVC = HabitsViewController()
            self.navigationController?.pushViewController(habitVC, animated: true)
        })
        alert.addAction(action1)
        alert.addAction(action2)
        present(alert, animated: true)
        
    }
    
    
    //функция нажатия на круг выбора цвета
    @objc private func didTapColor() {

        let colorPickerVC = UIColorPickerViewController()
        colorPickerVC.selectedColor = selectedColorInColorPicker
        colorPickerVC.delegate = self
        present(colorPickerVC, animated: true)
    }
    
    
   //функция реагирования на изменние даты на UIDatePicker
    @objc private func habitDateChanged() {
       
        habitDate.text = formatter.string(from: datePicker.date)
    }
    
    //функция сохранения отредактированной привычки
    @objc private func saveEdittedHabit() {
        
        let store = HabitsStore.shared
        for habit in store.habits {
            if habit == currentHabit {
                habit.name = self.habitTitleTextField.text!
                habit.date = formatter.date(from: self.habitDate.text!)!
                habit.color = self.habitColor.backgroundColor!
                store.save()
                //передаю в HabitDetailsViewController отредактированное имя привычки
                completionHandler?(self.habitTitleTextField.text!)
            }
        }
        dismiss(animated: true)
    }


}

//расширение для скрытия клавиатуры с экрана
extension HabitViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

extension HabitViewController: UIColorPickerViewControllerDelegate {
    
    func colorPickerViewControllerDidFinish(_ viewController: UIColorPickerViewController) {
        let color = viewController.selectedColor
        habitColor.backgroundColor = color
        selectedColorInColorPicker = color
    }
    
    func colorPickerViewController(_ viewController: UIColorPickerViewController, didSelect color: UIColor, continuously: Bool) {
        let color = viewController.selectedColor
        habitColor.backgroundColor = color
    }
}

