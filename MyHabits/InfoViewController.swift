import UIKit

class InfoViewController: UIViewController {

    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = true
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.backgroundColor = .white
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private lazy var contentView: UIView = {
        var contentView = UIView()
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.backgroundColor = .white
        return contentView
    }()
    
    private lazy var infoTitle: UILabel = {
        let label = UILabel ()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textColor = .black
        label.text = "Привычка за 21 день"
        return label
    }()
    
    private lazy var infoText: UILabel = {
        let label = UILabel ()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = label.font.withSize(17)
        label.textColor = .black
        label.numberOfLines = 0
        label.text = """
Прохождение этапов, за которые за 21 день вырабатывается привычка, подчиняется следующему алгоритму:
        
1. Провести один день без обращения к старым привычкам, стараться вести себя так, как будто цель, загаданная в перкспективу, находится на расстоянии шага.

2. Выдержать 2 дня в прежнем состоянии самоконтроля.

3. Отметить в дневнике первую неделю изменений и подвести первые итоги - что оказалось тяжело, что - легче, с чем еще предстоит серьезно бороться.

4. Поздравить себя с прохождением первого серьезного порога в 21 день. За это время отказ от дурных наклонностей уже примет форму осознанного преодоления и человек сможет больше работать в сторону принятия положительных качеств.

5. Держать планку 40 дней. Практикующий методику уже чувствует себя освободившимся от прошлого негатива и двигается в нужном направлении с хорошей динамикой.

6. На 90-й день соблюдения техники все лишнее из "прошлой жизни" перестает напоминать о себе, и человек, оглянувшись назад, осознает себя полностью обновимшимся.

Источник: psychbook.ru

"""
        return label
    }()
    
    
  override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGray6
        title = "Информация"
        navigationController?.navigationBar.backgroundColor = .systemGray6
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(infoTitle)
        contentView.addSubview(infoText)
        setupConstraints()

    }
    
private func setupConstraints() {
        let safeAreaGuide = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: safeAreaGuide.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: safeAreaGuide.trailingAnchor),
            scrollView.topAnchor.constraint(equalTo: safeAreaGuide.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: safeAreaGuide.bottomAnchor),
            
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            
            infoTitle.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            infoTitle.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            
            infoText.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            infoText.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            infoText.topAnchor.constraint(equalTo: infoTitle.bottomAnchor, constant: 20),
            infoText.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20)
            ])
        }
    
}
