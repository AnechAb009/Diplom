import UIKit
import MagicalRecord
import SwiftRandom

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        MagicalRecord.setupAutoMigratingCoreDataStack()
//        for index in 1..<5 {
//            fakeData()
//        }
//        MagicalRecord.save(blockAndWait: { (context) in
//            let user = User.mr_createEntity(in: context)
//            user?.name = "kek"
//            user?.lastname = "kek"
//            user?.patronymic = "kek"
//            user?.address = "kek"
//            user?.mail = "kek"
//            user?.phone = "kek"
//            user?.organization = "kek"
//        })
        window = UIWindow(frame: UIScreen.main.bounds)
        
//        window?.rootViewController = CardsViewController()
    
        let nav1 = CardViewController()//UINavigationController(rootViewController: CardViewController())

        let vc2 = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateInitialViewController()
        vc2?.tabBarItem = UITabBarItem(tabBarSystemItem: UITabBarItem.SystemItem.contacts, tag: 2)

//        let nav2 = UINavigationController(rootViewController: vc2!)

        let tab = TabBarController()
        tab.viewControllers = [nav1, vc2!]
        tab.selectedIndex = 0
        window?.rootViewController = tab

        window?.makeKeyAndVisible()
        // Override point for customization after application launch.
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
}
