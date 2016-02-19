import Foundation

/**计算字符串长度**/
func stringlen(str: String) -> Int {
    var len = 0
    for _ in str.characters {
        len++
    }
    return len
}

/**判断是否登录**/
func islogin() -> Bool {
    let datapath = NSHomeDirectory() + "/Library/Caches/login.txt"
    if NSFileManager.defaultManager().fileExistsAtPath(datapath) {
        return true
    } else {
        return false
    }
}

/**获取用户登录key值**/
func getkey() -> String {
    var key = "null"
    let datapath = NSHomeDirectory() + "/Library/Caches/login.txt"
    if NSFileManager.defaultManager().fileExistsAtPath(datapath) {
        let data = NSFileManager.defaultManager().contentsAtPath(datapath)!
        key = NSString(data: data, encoding: NSUTF8StringEncoding)! as String
    }
    return key
}

/**判断是否登录**/
func allow_camera() -> Bool {
    let datapath = NSHomeDirectory() + "/Library/Caches/allowcamera.txt"
    if NSFileManager.defaultManager().fileExistsAtPath(datapath) {
        return true
    } else {
        return false
    }
}