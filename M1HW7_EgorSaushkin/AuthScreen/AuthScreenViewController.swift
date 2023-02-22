//
//  AuthScreenViewController.swift
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

protocol AuthScreenDisplayLogic: AnyObject {
	func displayView(viewModel: AuthScreen.Model.ViewModel)
}

class AuthScreenViewController: UIViewController, AuthScreenDisplayLogic {
	var interactor: AuthScreenBusinessLogic?
	var router: (NSObjectProtocol & AuthScreenRoutingLogic & AuthScreenDataPassing)?
	
	override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
		super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
		setup()
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		setup()
	}
	
	private func setup() {
		let viewController = self
		let interactor = AuthScreenInteractor()
		let presenter = AuthScreenPresenter()
		let router = AuthScreenRouter()
		viewController.interactor = interactor
		viewController.router = router
		interactor.presenter = presenter
		presenter.viewController = viewController
		router.viewController = viewController
		router.dataStore = interactor
	}
	
	// MARK: Routing
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?)
	{
		if let scene = segue.identifier {
			let selector = NSSelectorFromString("routeTo\(scene)WithSegue:")
			if let router = router, router.responds(to: selector) {
				router.perform(selector, with: segue)
			}
		}
	}
	
	// MARK: View lifecycle
	
	override func viewDidLoad() {
		super.viewDidLoad()
	}

	// MARK: Outlets
	
	@IBOutlet weak var loginTextField: UITextField!
	
	@IBOutlet weak var passTextField: UITextField!

	@IBAction func logInButton(_ sender: Any) {
		let request = AuthScreen.Model.Request(
			login: loginTextField.text!,
			pass: passTextField.text!
		)
		interactor?.processAuthorisation(request: request)
		
		performSegue(withIdentifier: "mySegueID", sender: nil)
		
	}
	
	// MARK: Methods
	func displayView(viewModel: AuthScreen.Model.ViewModel) {
		let alert = UIAlertController(
			title: viewModel.message,
			message: "",
			preferredStyle: UIAlertController.Style.alert
			)
		let action = UIAlertAction(title: "Ok", style: .default)
		alert.addAction(action)
		present(alert, animated: true, completion: nil)
	}
}