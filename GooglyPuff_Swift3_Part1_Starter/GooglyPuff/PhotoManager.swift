/*
 * Copyright (c) 2016 Razeware LLC
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

import Foundation

// Notification when new photo instances are added
let photoManagerContentAddedNotification = "com.raywenderlich.GooglyPuff.PhotoManagerContentAdded"
// Notification when content updates (i.e. Download finishes)
let photoManagerContentUpdatedNotification = "com.raywenderlich.GooglyPuff.PhotoManagerContentUpdated"

// Photo Credit: Devin Begley, http://www.devinbegley.com/
let overlyAttachedGirlfriendURLString = "http://i.imgur.com/UvqEgCv.png"
let successKidURLString = "http://i.imgur.com/dZ5wRtb.png"
let lotsOfFacesURLString = "http://i.imgur.com/tPzTg7A.jpg"

typealias PhotoProcessingProgressClosure = (_ completionPercentage: CGFloat) -> Void
typealias BatchPhotoDownloadingCompletionClosure = (_ error: NSError?) -> Void

private let _sharedManager = PhotoManager()

class PhotoManager {
  class var sharedManager: PhotoManager {
    return _sharedManager
  }
  
  fileprivate var _photos: [Photo] = []
  fileprivate let concurrentPhotoQueue =
        DispatchQueue(
            label: "com.raywenderlich.GooglyPuff.photoQueue", // 1
            attributes: .concurrent) // 2
  var photos: [Photo] {
    var photocopy: [Photo]!
    concurrentPhotoQueue.sync(flags: DispatchWorkItemFlags.barrier) { 
      photocopy = self._photos
    }
    return photocopy
  }
  
  func addPhoto(_ photo: Photo) {
    concurrentPhotoQueue.async(group: nil, qos: .default, flags: DispatchWorkItemFlags.barrier) {
      self._photos.append(photo)
      DispatchQueue.main.async {
            self.postContentAddedNotification()
      }
    }
  }
  
  func downloadPhotosWithCompletion(_ completion: BatchPhotoDownloadingCompletionClosure?) {
    // make a new GCD Queue
    DispatchQueue.global(qos: .userInitiated).async {
        var storedError: NSError?
        let downloadsGroup = DispatchGroup()
        for address in [overlyAttachedGirlfriendURLString,
                        successKidURLString,
                        lotsOfFacesURLString] {
                            let url = URL(string: address)
                            downloadsGroup.enter()
                            let photo = DownloadPhoto(url: url!) {
                                _, error in
                                if error != nil {
                                    storedError = error
                                }
                                downloadsGroup.leave()
                            }
                            PhotoManager.sharedManager.addPhoto(photo)
        }
        
        downloadsGroup.wait()
        DispatchQueue.main.async {
            completion?(storedError)
        }
        
    }
  }
    
    func downloadPhotosWithCompletion2(_ completion: BatchPhotoDownloadingCompletionClosure?) {
        // make a new GCD Queue
            var storedError: NSError?
            let downloadsGroup = DispatchGroup()
            for address in [overlyAttachedGirlfriendURLString,
                            successKidURLString,
                            lotsOfFacesURLString] {
                                let url = URL(string: address)
                                downloadsGroup.enter()
                                let photo = DownloadPhoto(url: url!) {
                                    _, error in
                                    if error != nil {
                                        storedError = error
                                    }
                                    downloadsGroup.leave()
                                }
                                PhotoManager.sharedManager.addPhoto(photo)
            }
            
            downloadsGroup.notify(queue: DispatchQueue.main) {
                completion?(storedError)
            }
        
    }
  
  fileprivate func postContentAddedNotification() {
    NotificationCenter.default.post(name: Notification.Name(rawValue: photoManagerContentAddedNotification), object: nil)
  }
    
}
