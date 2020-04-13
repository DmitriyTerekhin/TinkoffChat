//
//  MultipeerCommunicator.swift
//  TinkoffChat
//
//  Created by Dmitriy Terekhin on 05/04/2018.
//  Copyright © 2018 Dmitriy Terekhin. All rights reserved.
//

import Foundation
import MultipeerConnectivity

protocol ICommunicator: class {
    func sendMessage(string: String, to userId: String, completionHandler: ((_ success: Bool,_ error: Error?) ->())?)
    var delegate: ICommunicationService? {get set}
    var online: Bool {get set}
}

class MultipeerCommunicator: NSObject, ICommunicator {
    
    func sendMessage(string: String, to userId: String, completionHandler: ((Bool, Error?) -> ())?) {
        
        guard let session = getSessionForDisplayName(peerDisplayName: userId) else {
            if let ch = completionHandler {
                ch(false,NSError(domain: "MCSession", code: 0, userInfo: [NSLocalizedDescriptionKey : "Сессия не найдена"]))
            }
            return
        }
        
        if session.connectedPeers.count > 0 {
            do {
                try session.send(string.data(using: .utf8)!, toPeers: session.connectedPeers, with: .reliable)
                if let ch = completionHandler {
                    ch(true, nil)
                }
            } catch {
                if let ch = completionHandler {
                    ch(false, error)
                }
            }
        }
    }
    
    func getSessionForDisplayName(peerDisplayName: String) -> MCSession? {
        for session in sessions {
            if session.connectedPeers.contains(where: {$0.displayName == peerDisplayName}) {
                return session
            }
        }
        return nil
    }
    
    func generateMessageId() -> String {
        let string = "\(arc4random_uniform(UINT32_MAX)) + \(Date.timeIntervalSinceReferenceDate) + \(arc4random_uniform(UINT32_MAX))".data(using: .utf8)?.base64EncodedString()
        return string!
    }
    
    weak var delegate: ICommunicationService?
    var online: Bool = false
    
    private let chatServiceType = "tinkoff-chat"
    private let myPeerId = MCPeerID(displayName: UIDevice.current.identifierForVendor!.uuidString)
    private let serviceAdvertiser : MCNearbyServiceAdvertiser
    private let serviceBrowser : MCNearbyServiceBrowser
    
    private var sessions = [MCSession]()
    
    private func getSession(for peerId: MCPeerID) -> MCSession {
        for session in sessions {
            if session.connectedPeers.contains(where: {$0 == peerId}) {
                return session
            }
        }
        
        let newSession = MCSession(peer: self.myPeerId, securityIdentity: nil, encryptionPreference: .none)
        sessions.append(newSession)
        newSession.delegate = self
        return newSession
    }
    
    override init() {
        self.serviceAdvertiser = MCNearbyServiceAdvertiser(peer: myPeerId, discoveryInfo: ["userName": UIDevice.current.name], serviceType: chatServiceType)
        self.serviceBrowser = MCNearbyServiceBrowser(peer: myPeerId, serviceType: chatServiceType)
        super.init()
        self.serviceAdvertiser.delegate = self
        self.serviceAdvertiser.startAdvertisingPeer()
        
        self.serviceBrowser.delegate = self
        self.serviceBrowser.startBrowsingForPeers()
    }
    
    deinit {
        self.serviceAdvertiser.stopAdvertisingPeer()
        self.serviceBrowser.stopBrowsingForPeers()
    }
    
}

//MARK: - Advertiser delegates
extension MultipeerCommunicator: MCNearbyServiceAdvertiserDelegate {
    
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didNotStartAdvertisingPeer error: Error) {
        delegate?.failedToStartAdvertising(error: error)
    }
    
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didReceiveInvitationFromPeer peerID: MCPeerID, withContext context: Data?, invitationHandler: @escaping (Bool, MCSession?) -> Void) {
        invitationHandler(true, self.getSession(for: peerID))
    }
    
}

//MARK: - Browser delegates
extension MultipeerCommunicator: MCNearbyServiceBrowserDelegate {
    
    func browser(_ browser: MCNearbyServiceBrowser, didNotStartBrowsingForPeers error: Error) {
        delegate?.failedToStartBrowsingForUsers(error: error)
    }
    
    func browser(_ browser: MCNearbyServiceBrowser, foundPeer peerID: MCPeerID, withDiscoveryInfo info: [String : String]?) {
        delegate?.didFoundUser(userId: peerID.displayName, userName: info?["userName"])
        browser.invitePeer(peerID, to: self.getSession(for: peerID), withContext: nil, timeout: 20)
    }
    
    func browser(_ browser: MCNearbyServiceBrowser, lostPeer peerID: MCPeerID) {
        delegate?.didLostUser(userId: peerID.displayName)
    }
    
}

//MARK:- Session delegates
extension MultipeerCommunicator: MCSessionDelegate {
    
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        switch state {
        case .connecting:
            print("connecting")
        case .connected:
            print("connected")
        case .notConnected:
            print("notConnected")
        }
    }
    
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        delegate?.didRecieveMessage(text: String(data: data, encoding: .utf8)!, fromUser: peerID.displayName, toUser: myPeerId.displayName)
    }
    
    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
        NSLog("%@", "didReceiveStream")
    }
    
    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {
        NSLog("%@", "didStartReceivingResourceWithName")
    }
    
    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) {
        NSLog("%@", "didFinishReceivingResourceWithName")
    }
    
}
