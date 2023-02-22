//
//  ToDoInteractor.swift
//  M1HW7_EgorSaushkin
//
//  Created by Egor SAUSHKIN on 22.02.2023.
//  Copyright (c) 2023 ___ORGANIZATIONNAME___. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

protocol ToDoBusinessLogic {
	func prepareTableWithTasks(request: ToDo.Model.Request)
}

protocol ToDoDataStore {
	//
}

class ToDoInteractor: ToDoBusinessLogic, ToDoDataStore {
	var presenter: ToDoPresentationLogic?
	var worker: ToDoWorker?
	private var taskManager: ITaskManager?
	private var repository: ITaskRepository?
	private var adapter: ISectionAdapter?
	
	// MARK: Do something
	
	func prepareTableWithTasks(request: ToDo.Model.Request) {
		worker = ToDoWorker()
		worker?.doSomeWork()
		
		taskManager = TaskManager()
		repository = TaskRepositoryStub()
		guard let tasks = repository?.getTasks() else { return }
		taskManager?.add(tasks)
		
		adapter = SectionAdapter(taskManager: taskManager!)
		guard let tasksForSection = adapter?.getTasksForSection(section: request.section) else { return }
		guard let sectionsTitles = adapter?.getSectionsTitles(section: request.section) else { return }
		guard let sectionNumberOfRow = adapter?.getSectionsNumberOfRows(section: request.section) else { return }
		
		let response = ToDo.Model.Response(
			section: request.section,
			tasks: tasksForSection,
			title: sectionsTitles,
			numberOfRows: sectionNumberOfRow)
		presenter?.present(response: response)
	}
}