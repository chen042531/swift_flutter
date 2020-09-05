//
//  Datalistener.swift
//  Runner
//
//  Created by ycchen on 2020/9/5.
//

class Datalistener:Dlistener{
    public var observer:sensor2
    init(obs:sensor2) {
        self.observer = obs
    }
    
    func onReceived(item: Double) {
        observer.notify(item:item)
    }
}
