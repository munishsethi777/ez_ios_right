//
//  LocalStorage.swift
//  Whatsapp
//
//  Created by Rafael Castro on 7/24/15. / Swift Version by Breno Oliveira on 02/18/16.
//  Copyright (c) 2015 HummingBird. All rights reserved.
//

import UIKit

class LocalStorage {
    private var mapChatToMessages:[String:[MessageDetail]] = [String:[MessageDetail]]()

    func storeMessage(message:MessageDetail) {
        self.storeMessages(messages: [message])
    }
    
    func storeMessages(messages:[MessageDetail]) {
        if messages.count == 0 {
            return
        }
        
        let message = messages[0]
        let chatId = message.chatId
        
        var array = self.queryMessagesForChatId(chatId: chatId)
        if array != nil  {
            array!.append(contentsOf: messages)
        }
        else {
            array = messages
        }
        
        self.mapChatToMessages[chatId] = array
    }
    
    func queryMessagesForChatId(chatId:String) -> [MessageDetail]?
    {
        return self.mapChatToMessages[chatId]
    }

    func storeChat(chat:Chat) {
        //TODO
    }
    
    func storeChats(chats:[Chat]) {
        //TODO
    }
    
    func storeContact(contact:Contact) {
        //TODO
    }
    
    func storeContacts(contacts:[Contact]) {
        //TODO
    }
    
    func refreshStorage(){
        self.mapChatToMessages.removeAll()
    }
    
    static let sharedInstance = LocalStorage()
    private init() {}
}
