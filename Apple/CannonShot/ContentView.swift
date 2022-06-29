//
//  ContentView.swift
//  CannonShot
//
//  Created by Anthony on 28/06/2022.
//

import SwiftUI
import AVFoundation

enum runtimeErrors: Error{
    case invalid
    case wrongcharacters
    case length
}

struct ContentView: View {
    @State private var play = true
    @State private var hours: String = ""
    @State private var minutes: String = ""
    @State private var seconds: String = ""
    @State private var sound: String = ""
    @State private var time:Int = 0
    @State private var timelabel = "00:00:00"
    @State private var playsequencestate = false
    @State private var player: AVAudioPlayer!
    
    @State private var hourss:Int = 0
    @State private var minutess:Int = 0
    @State private var secondss:Int = 0
    
    @State private var errorlabel:String = ""


    
    var body: some View {
        VStack {
            Text(timelabel)
            Text("Interval")
                .padding(.vertical, 10.0)
            TextField("hours", text: $hours)
                .padding(.vertical, 10.0)
                .keyboardType(.asciiCapableNumberPad)
            TextField("minutes", text: $minutes)
                .padding(.vertical, 10.0)
                .keyboardType(.asciiCapableNumberPad)
            TextField("seconds", text: $seconds)
                .padding(.vertical, 10.0)
                .keyboardType(.asciiCapableNumberPad)
            Text("Sound:")
                .padding(.vertical, 10.0)
            TextField("0", text: $sound)
                .padding(.vertical, 10.0)
                .keyboardType(.asciiCapableNumberPad)
                .padding(.vertical, 10.0)
            
            Button("Start") {
                var ok = true
                print("press")
                do{
                    try check()
                } catch{
                    ok = false
                    errorlabel = String(error.localizedDescription)
                }
                if(ok){
                    playSequence()
                }
            }
            .padding(.vertical, 10.0).frame(maxWidth: .infinity).background(/*@START_MENU_TOKEN@*//*@PLACEHOLDER=View@*/Color.blue/*@END_MENU_TOKEN@*/).foregroundColor(/*@START_MENU_TOKEN@*/.white/*@END_MENU_TOKEN@*/)
            
            Button("Stop") {
                play = false;
            }
            .padding(.vertical, 10.0).frame(maxWidth: .infinity).background(/*@START_MENU_TOKEN@*//*@PLACEHOLDER=View@*/Color.blue/*@END_MENU_TOKEN@*/).foregroundColor(/*@START_MENU_TOKEN@*/.white/*@END_MENU_TOKEN@*/)
            Text(errorlabel)
                .padding(.vertical, 10.0)
                .foregroundColor(/*@START_MENU_TOKEN@*/.red/*@END_MENU_TOKEN@*/)
        }
        
    }
    
    func check() throws{
        if(sound.count != 1){
            throw runtimeErrors.invalid
        }
        if(hours.count == 0 || minutes.count == 0 || seconds.count == 0){
            throw runtimeErrors.length
        }
        minutess = Int(minutes)!
        hourss = Int(hours)!
        secondss = Int(seconds)!
        if(minutess >= 60 || secondss >= 60 || hourss >= 60){
            throw runtimeErrors.invalid
        }
        if(minutess <= 0 && secondss <= 0 && hourss <= 0){
            throw runtimeErrors.invalid
        }
    }

    func playSequence(){
        if(playsequencestate == true){
            return
        }
        play = true
        let sounds:Int = Int(sound)!
        let totalseconds:Int = hourss * 3600 + minutess * 60 + secondss
        
        DispatchQueue.global().async {
            playsequencestate = true
            while(play){
                playSound(sound: sounds)
                sleep(UInt32(totalseconds))
            }
            playsequencestate = false
        }
        
        DispatchQueue.global().async {
            var uur:Int = hourss
            var minuten:Int = minutess
            var seconden:Int = secondss
            while(play){
                if (seconden == 0){
                    if(minuten == 0){
                        if(uur == 0){
                            uur = hourss
                            minuten = minutess
                            seconden = secondss
                        } else {
                            uur -= 1
                            minuten = 59
                            seconden = 59
                        }
                    } else {
                        minuten -= 1
                        seconden = 59
                    }
                } else {
                    seconden -= 1
                }
                timelabel = "\(uur):\(minuten):\(seconden)"
                sleep(1)
            }
            timelabel = "00:00:00"
        }
    }
    
    func playSound(sound: Int){
        var file:String = ""
        switch(sound){
        case 2: file = "gun2"
        case 3: file = "gun3"
        case 4: file = "gun4"
        case 5: file = "gun5"
        default: file = "gun1"
        }
        let url = Bundle.main.url(forResource: file, withExtension: "mp3")
        guard url != nil else{
            return
        }
        do{
            errorlabel = ""
            player = try AVAudioPlayer(contentsOf: url!)
            player?.play()
        } catch {
            errorlabel = String(error.localizedDescription)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}


