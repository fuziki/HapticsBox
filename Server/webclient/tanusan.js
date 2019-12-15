
class Tanusan {
    constructor() {
        this.receiveMsgHandler = function(e) {}
        this.wsLogHandler = function(e) {}
    }

    connectWs(url) {
        var self = this
        if (this.ws != null && this.ws.readyState != WebSocket.CLOSED) {
            self.wsLogHandler(`<font color="#FF0000">ws is opened</font> `)
            return
        }
        this.ws = new WebSocket(url);
        this.ws.onmessage = function(e) {
            self.receiveMsgHandler(e.data)
        }
        this.ws.onopen = function(e) {
            self.wsLogHandler(`<font color="#000000">open ws event = ` + e + "</font>")
        }
        this.ws.onclose = function(e) {
            self.wsLogHandler(`<font color="#000000">close ws event = ` + e + "</font>")
        }
    }

    wsLog(handler) {
        this.wsLogHandler = handler
    }

    sendMsg(msg) {
        var self = this
        if (this.ws != null && this.ws.readyState != WebSocket.OPEN) {
            self.wsLogHandler(`<font color="#FF0000">ws is not open</font>`)
            return
        }
        this.ws.send(msg)
    }

    onMsg(handler) {
        this.receiveMsgHandler = handler
    }

    closeWs() {
        var self = this
        if (this.ws != null && this.ws.readyState != WebSocket.OPEN) {
            self.wsLogHandler(`<font color="#FF0000">ws is not open</font>`)
            return
        }
        this.ws.close()
    }

    isClosed() {
        return (this.ws != null && this.ws.readyState == WebSocket.CLOSED)
    }
}
