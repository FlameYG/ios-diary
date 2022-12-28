//
//  DiaryFormViewController.swift
//  Diary
//  Created by inho, dragon on 2022/12/21.
//

import UIKit
import CoreData

final class DiaryFormViewController: UIViewController, CoreDataProcessable {
    // MARK: - Properties
    
    private let diaryFormView = DiaryFormView()
    private let selectedDiary: Diary?
    private let alertControllerManager = AlertControllerManager()
    private let activityControllerManager = ActivityControllerManager()
    
    // MARK: - Initializer
    
    init(diary: Diary? = nil) {
        selectedDiary = diary
        
        if let diary = diary {
            diaryFormView.diaryTextView.text = diary.totalText
        }
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        configureDiaryViewLayout()
        configureNavigationBar()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        selectSaveOrUpdate()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        diaryFormView.diaryTextView.becomeFirstResponder()
    }
    
    // MARK: - Internal Methods
    
    func selectSaveOrUpdate() {
        let diary = createDiary()
        
        if selectedDiary != nil {
            updateCoreData(diary: diary)
        } else {
            if !diary.title.isEmpty, !diary.body.isEmpty {
                saveCoreData(diary: diary)
            }
        }
    }
    
    // MARK: - Private Methods
    
    private func configureDiaryViewLayout() {
        view.addSubview(diaryFormView)
        
        NSLayoutConstraint.activate([
            diaryFormView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            diaryFormView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            diaryFormView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            diaryFormView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private func configureNavigationBar() {
        navigationItem.title = DateFormatter.koreanDateFormatter.string(from: Date())
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "ellipsis.circle"),
            style: .plain,
            target: self,
            action: #selector(showActionSheet)
        )
    }
    
    private func createDiary() -> Diary {
        var components = diaryFormView.diaryTextView.text.components(separatedBy: "\n")
        let title = components.removeFirst()
        let body = components.filter { !$0.isEmpty }.first ?? ""
        var uuid = UUID()
        if let id = selectedDiary?.id {
            uuid = id
        }
        
        let diary = Diary(title: title,
                          body: body,
                          createdAt: Int(Date().timeIntervalSince1970),
                          totalText: diaryFormView.diaryTextView.text,
                          id: uuid)

        return diary
    }
    
    private func showDeleteAlert() {
        guard let diary = selectedDiary else { return }
        
        present(alertControllerManager.createDeleteAlert({
            self.deleteCoreData(diary: diary)
        }), animated: true)
    }
    
    private func showActivityController() {
        if let totalText = diaryFormView.diaryTextView.text, !totalText.isEmpty {
            present(activityControllerManager.showActivity(textToShare: totalText),
                    animated: true,
                    completion: nil)
        }
    }
    
    // MARK: - Action Methods
    
    @objc private func showActionSheet() {
        present(alertControllerManager.createActionSheet(showActivityController, showDeleteAlert),
                animated: true,
                completion: nil)
    }
}
