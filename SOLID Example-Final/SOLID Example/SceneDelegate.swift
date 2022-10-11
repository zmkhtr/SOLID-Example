//
//  SceneDelegate.swift
//  SOLID Example
//
//  Created by PT.Koanba on 22/09/22.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let scene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: scene)
        let url = URL(string: "https://ghibliapi.herokuapp.com/films")!
        let httpClient = URLSessionHTTPClient(session: URLSession(configuration: .default))
        let loader = LocalMovieLoader()
        window?.rootViewController = makeMovieListViewController(with: MainQueueDispatchDecorator(decoratee: loader))
        window?.makeKeyAndVisible()
    }
    
    private func makeMovieListViewController(with loader: MovieLoader) -> MovieListViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let movieViewController = storyboard.instantiateInitialViewController() as! MovieListViewController
        movieViewController.loader = loader
        return movieViewController
    }
    

}

final class MainQueueDispatchDecorator<T> {
    private let decoratee: T
    
    init(decoratee: T) {
        self.decoratee = decoratee
    }
    
    func dispatch(completion: @escaping () -> Void) {
        guard Thread.isMainThread else {
            return  DispatchQueue.main.async(execute: completion)
        }
        
        completion()
    }
}

extension MainQueueDispatchDecorator: MovieLoader where T == MovieLoader {
    func get(completion: @escaping (MovieLoader.Result) -> Void) {
        decoratee.get { [weak self] result in
            self?.dispatch {
                completion(result)
            }
        }
    }
}
