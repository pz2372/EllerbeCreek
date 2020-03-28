// GCHelper.swift (v. 0.3.2)
//
// Copyright (c) 2016 Jack Cook
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

import GameKit

/// Custom delegate used to provide information to the application implementing GCHelper.
public protocol GCHelperDelegate: class {
    
    /// Method called when a match has been initiated.
    func matchStarted()
    
    /// Method called when the device received data about the match from another device in the match.
    func match(_ match: GKMatch, didReceiveData: Data, fromPlayer: String)
    
    /// Method called when the match has ended.
    func matchEnded()
}

/// A GCHelper instance represents a wrapper around a GameKit match.
public class GCHelper: NSObject, GKMatchmakerViewControllerDelegate, GKGameCenterControllerDelegate, GKMatchDelegate, GKLocalPlayerListener {
    
    /// An array of retrieved achievements. `loadAllAchievements(completion:)` must be called in advance.
    public var achievements = [String: GKAchievement]()
    
    /// The match object provided by GameKit.
    public var match: GKMatch!
    public var playersDict = [String: AnyObject]()
    
    fileprivate weak var delegate: GCHelperDelegate?
    fileprivate var invite: GKInvite!
    fileprivate var invitedPlayer: GKPlayer!
    fileprivate weak var presentingViewController: UIViewController!
    let defaults = UserDefaults.standard
    
    fileprivate var authenticated = false {
        didSet {
            print("Authentication changed: player\(authenticated ? " " : " not ")authenticated")
            if authenticated { NotificationCenter.default.post(name: NSNotification.Name(rawValue: "PlayerAuthenticated"), object: nil) }
        }
    }
    
    fileprivate var matchStarted = false
    
    /// The shared instance of GCHelper, allowing you to access the same instance across all uses of the library.
    public class var sharedInstance: GCHelper {
        struct Static {
            static let instance = GCHelper()
        }
        return Static.instance
    }
    
    override init() {
        super.init()
//        NotificationCenter.default.addObserver(self, selector: #selector(GCHelper.authenticationChanged), name: GKPlayerAuthenticationDidChangeNotificationName, object: nil)
//        print(GKPlayerAuthenticationDidChangeNotificationName.name)
    }
    
    // MARK: Private functions
    
    @objc fileprivate func authenticationChanged() {
        if GKLocalPlayer.local.isAuthenticated && !authenticated {
            authenticated = true
        } else {
            authenticated = false
        }
    }
    
    fileprivate func lookupPlayers() {
        let playerIDs = match.players.map { $0.playerID }
        
        GKPlayer.loadPlayers(forIdentifiers: playerIDs) { (players, error) in
            guard error == nil else {
                print("Error retrieving player info: \(String(describing: error?.localizedDescription))")
                self.matchStarted = false
                self.delegate?.matchEnded()
                return
            }
            
            guard let players = players else {
                print("Error retrieving players; returned nil")
                return
            }
            
            for player in players {
                print("Found player: \(player.alias))")
                self.playersDict[player.playerID] = player
            }
            
            self.matchStarted = true
            GKMatchmaker.shared().finishMatchmaking(for: self.match)
            self.delegate?.matchStarted()
        }
    }
    
    // MARK: User functions
    
    /// Authenticates the user with their Game Center account if possible
    public func authenticateLocalUser() {
        print("Authenticating local user...")
        
        if GKLocalPlayer.local.isAuthenticated == false {
            GKLocalPlayer.local.authenticateHandler = { (view, error) in
                guard error == nil else {
                    print("Authentication error: \(String(describing: error?.localizedDescription))")
                    return
                }
                
                self.authenticated = true
            }
        } else {
            print("Already authenticated")
        }
    }
    
    public func getLocalUser() -> String {
        guard GKLocalPlayer.local.isAuthenticated else { return "No User" }
        return GKLocalPlayer.local.alias
    }
    
    public func getHighScore() {
        
    }
    
    /**
     Attempts to pair up the user with other users who are also looking for a match.
     
     :param: minPlayers The minimum number of players required to create a match.
     :param: maxPlayers The maximum number of players allowed to create a match.
     :param: viewController The view controller to present required GameKit view controllers from.
     :param: delegate The delegate receiving data from GCHelper.
     */
    public func findMatchWithMinPlayers(_ minPlayers: Int, maxPlayers: Int, viewController: UIViewController, delegate theDelegate: GCHelperDelegate) {
        matchStarted = false
        match = nil
        presentingViewController = viewController
        delegate = theDelegate
        presentingViewController.dismiss(animated: false, completion: nil)
        
        let request = GKMatchRequest()
        request.minPlayers = minPlayers
        request.maxPlayers = maxPlayers
        
        let sharedMatchMaker: GKMatchmaker! = GKMatchmaker()
        sharedMatchMaker.findMatch(for: request, withCompletionHandler: { (match, error) in
            if error != nil {
                print(error ?? "Error when attempting to find a match")
            } else if match != nil {
                self.match = match
                self.match.delegate = self
                
                if !self.matchStarted && self.match.expectedPlayerCount == 0 {
                    self.lookupPlayers()
                }
            }
        })
    }
    
    /**
     Reports progress on an achievement to GameKit if the achievement has not been completed already
     
     :param: identifier A string that matches the identifier string used to create an achievement in iTunes Connect.
     :param: percent A percentage value (0 - 100) stating how far the user has progressed on the achievement.
     */
    public func reportAchievementIdentifier(_ identifier: String, percent: Double, showsCompletionBanner banner: Bool = true) {
        let achievement = GKAchievement(identifier: identifier)
        
        if !achievementIsCompleted(identifier) {
            achievement.percentComplete = percent
            achievement.showsCompletionBanner = banner
            
            GKAchievement.report([achievement]) { (error) in
                guard error == nil else {
                    print("Error in reporting achievements: \(String(describing: error))")
                    return
                }
            }
        }
    }
    
    /**
     Loads all achievements into memory
     
     :param: completion An optional completion block that fires after all achievements have been retrieved
     */
    public func loadAllAchievements(_ completion: (() -> Void)? = nil) {
        GKAchievement.loadAchievements { (achievements, error) in
            guard error == nil, let achievements = achievements else {
                print("Error in loading achievements: \(String(describing: error))")
                return
            }
            
            for achievement in achievements {
                self.achievements[achievement.identifier] = achievement
            }
            
            completion?()
        }
    }
    
    /**
     Checks if an achievement in allPossibleAchievements is already 100% completed
     
     :param: identifier A string that matches the identifier string used to create an achievement in iTunes Connect.
     */
    public func achievementIsCompleted(_ identifier: String) -> Bool {
        if let achievement = achievements[identifier] {
            return achievement.percentComplete == 100
        }
        
        return false
    }
    
    /**
     Resets all achievements that have been reported to GameKit.
     */
    public func resetAllAchievements() {
        GKAchievement.resetAchievements { (error) in
            guard error == nil else {
                print("Error resetting achievements: \(String(describing: error))")
                return
            }
        }
    }
    
    /**
     Reports a high score eligible for placement on a leaderboard to GameKit.
     
     :param: identifier A string that matches the identifier string used to create a leaderboard in iTunes Connect.
     :param: score The score earned by the user.
     */
    public func reportLeaderboardIdentifier(_ identifier: String, score: Int) {
        let scoreObject = GKScore(leaderboardIdentifier: identifier)
        scoreObject.value = Int64(score)
        GKScore.report([scoreObject]) { (error) in
            guard error == nil else {
                print("Error in reporting leaderboard scores: \(String(describing: error))")
                return
            }
        }
    }
    
    /**
     Presents the game center view controller provided by GameKit.
     
     :param: viewController The view controller to present GameKit's view controller from.
     :param: viewState The state in which to present the new view controller.
     */
    public func showGameCenter(_ viewController: UIViewController, viewState: GKGameCenterViewControllerState) {
        presentingViewController = viewController
        
        let gcvc = GKGameCenterViewController()
        
        #if os(iOS)
            gcvc.viewState = viewState
            gcvc.leaderboardIdentifier = "com.ryan_anderson.Ocean_Catch_Leaderboard"
        #endif
        
        gcvc.gameCenterDelegate = self
        presentingViewController.present(gcvc, animated: true, completion: nil)
    }
    
    // MARK: GKGameCenterControllerDelegate
    
    public func gameCenterViewControllerDidFinish(_ gameCenterViewController: GKGameCenterViewController) {
        presentingViewController.dismiss(animated: true, completion: nil)
    }
    
    // MARK: GKMatchmakerViewControllerDelegate
    
    public func matchmakerViewControllerWasCancelled(_ viewController: GKMatchmakerViewController) {
        presentingViewController.dismiss(animated: true, completion: nil)
    }
    
    public func matchmakerViewController(_ viewController: GKMatchmakerViewController, didFailWithError error: Error) {
        presentingViewController.dismiss(animated: true, completion: nil)
        print("Error finding match: \(error.localizedDescription)")
    }
    
    public func matchmakerViewController(_ viewController: GKMatchmakerViewController, didFind theMatch: GKMatch) {
        presentingViewController.dismiss(animated: true, completion: nil)
        match = theMatch
        match.delegate = self
        if !matchStarted && match.expectedPlayerCount == 0 {
            print("Ready to start match!")
            self.lookupPlayers()
        }
    }
}
