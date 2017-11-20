//
//  ViewController.swift
//  Multi-RTMP
//
//  Created by Daniel de Albuquerque on 20/11/17.
//  Copyright © 2017 Daniel de Albuquerque. All rights reserved.
//

import Cocoa


let text: String = """
#user  nobody;
worker_processes  1;

error_log  logs/error.log;
error_log  logs/error.log  notice;
error_log  logs/error.log  info;

events {
    worker_connections  1024;
}

rtmp {
    server {
        listen 1935;
        chunk_size 4096;

        application live {
            live on;
            record off;
            push rtmp://a.rtmp.youtube.com/live2/YOUTUBECODE;
            push rtmp://live-api-a.facebook.com:80/rtmp/FACEBOOKCODE;
        }
    }
}

"""

let nginxFile = "nginx"
let youtubeFile = "youtube"
let facebookFile = "facebook"
let DocumentDirURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)

let nginxURL = DocumentDirURL.appendingPathComponent(nginxFile).appendingPathExtension("conf")
let youtubeURL = DocumentDirURL.appendingPathComponent(youtubeFile).appendingPathExtension("code")
let facebookURL = DocumentDirURL.appendingPathComponent(facebookFile).appendingPathExtension("code")

class ViewController: NSViewController {
    
    @IBOutlet weak var ButtonSet: NSButton!
    @IBOutlet weak var ButtonClose: NSButton!
    @IBOutlet weak var YouTubeCode: NSTextFieldCell!
    @IBOutlet weak var messageText: NSTextFieldCell!
    @IBOutlet weak var FaceBookCode: NSTextFieldCell!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        // reading youtube code
        do {
            YouTubeCode.stringValue = try String(contentsOf: youtubeURL, encoding: .utf8)
        }
        catch {
            messageText.stringValue = "Error reading Youtube Code setup file!"
        }
        
        // reading facebook code
        do {
            FaceBookCode.stringValue = try String(contentsOf: facebookURL, encoding: .utf8)
        }
        catch {
            messageText.stringValue = "Error reading Facebook Code setup file!"
        }
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }

    @IBAction func Set(_ sender: NSButtonCell) {
        let proc = Process()
        proc.launchPath = "/Applications/StartNginx.app/Contents/MacOS/applet user name 'daniel' password '0tucamis' with administrator privileges"
        proc.launch()
        
        
        // writing nginx config file
        do {
            var replaced = text.replacingOccurrences(of: "YOUTUBECODE", with: YouTubeCode.stringValue)
            replaced = replaced.replacingOccurrences(of: "FACEBOOKCODE", with: FaceBookCode.stringValue)
            try replaced.write(to: nginxURL, atomically: true, encoding: String.Encoding.utf8)
            //messageText.stringValue =  facebookURL.absoluteString
            messageText.stringValue = "Done."
    
            
        }
        catch {
            messageText.stringValue = "Error!"
        }
        
        // writing youtube code
        do {
            let youtubeCode = YouTubeCode.stringValue
            try youtubeCode.write(to: youtubeURL, atomically: true, encoding: String.Encoding.utf8)
        }
        catch {
            messageText.stringValue = "Error writing Youtube Code setup file!"
        }
        
        // writing facebook code
        do {
            let facebookCode = FaceBookCode.stringValue
            try facebookCode.write(to: facebookURL, atomically: true, encoding: String.Encoding.utf8)
        }
        catch {
            messageText.stringValue = "Error writing Facebook Code setup file!"
        }

    }
    
    
    @IBAction func Close(_ sender: NSButton) {
        exit(0)
    }
    
}

