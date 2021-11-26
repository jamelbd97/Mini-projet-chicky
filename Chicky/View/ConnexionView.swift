//
//  Connexion.swift
//  Chicky
//
//  Created by Mac2021 on 15/11/2021.
//

import UIKit
import Alamofire
import GoogleSignIn

class ConnexionView: UIViewController {
    
    // VAR
    let signInConfig = GIDConfiguration	.init(clientID: "1068988633012-o3ncrfkpu7veivr731s4lco8ok11fl47.apps.googleusercontent.com")
    let utilisateurViewModel = UtilisateurViewModel()
    let spinner = SpinnerViewController()
    
    var email: String?
    
    
    // WIDGET
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var motDePasseTextField: UITextField!
    
    // PROTOCOLS
    
    
    // LIFECYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        
        emailTextField.text = email
    }
    
    // METHODS
    func startSpinner() {
        addChild(spinner)
        spinner.view.frame = view.frame
        view.addSubview(spinner.view)
        spinner.didMove(toParent: self)
    }
    
    func stopSpinner() {
        spinner.willMove(toParent: nil)
        spinner.view.removeFromSuperview()
        spinner.removeFromParent()
    }
    
    func verifierEmail(email: String?) {
        utilisateurViewModel.verifierConfirmationEmail(email: email!, completed: { (success) in
            if success {
                self.performSegue(withIdentifier: "connexionSegue", sender: nil)
            } else {
                let action = UIAlertAction(title: "Réenvoyer", style: .cancel) { UIAlertAction in
                    self.reEnvoyerEmail(email: email)
                }
                self.present(Alert.makeActionAlert(titre: "Notice", message: "Voulez vous re envoyer l'email de confirmation a " + email!, action: action),animated: true)
                self.reEnvoyerEmail(email: email)
            }
        })
    }
    
    func reEnvoyerEmail(email: String?) {
        utilisateurViewModel.reEnvoyerConfirmationEmail(email: email!, completed: { (success) in
            if success {
                self.present(Alert.makeAlert(titre: "Succés", message: "Email de confirmation envoyé a " + email!), animated: true)
            } else {
                self.present(Alert.makeAlert(titre: "Erreur", message: "Echec d'envoi de l'email de confirmation"), animated: true)
            }
        })
    }
    
    // ACTIONS
    @IBAction func connexion(_ sender: Any) {
        
        startSpinner()
        
        utilisateurViewModel.connexion(email: emailTextField.text!, mdp: motDePasseTextField.text!,completed: { [self] (success) in
            
            self.stopSpinner()
            
            if success {
                verifierEmail(email: emailTextField.text)
            } else {
                self.present(Alert.makeAlert(titre: "Alerte", message: "Email ou mot de passe incorrect."), animated: true)
            }
        })
    }
    
    @IBAction func connexionGoogle(_ sender: Any) {
        GIDSignIn.sharedInstance.signIn(with: signInConfig, presenting: self) { user, error in
            guard error == nil else { return }
            guard let user = user else { return }
            
            //let emailAddress = user.profile?.email
            
            // If sign in succeeded, display the app's main content View.
        }
    }
}