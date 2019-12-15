
class TanuConsole {
    static shared = new TanuConsole()
    create(urlId, statusLabel) {
        if (this.ts != null && !this.ts.isClosed()) return
        this.ts = new Tanusan()
        this.ts.wsLog(function(e) {
            document.getElementById(statusLabel).innerHTML = e
        })
        var value = document.getElementById(urlId).value
        this.ts.connectWs(value)
    }

    sendMsg(inputId) {
        var value = document.getElementById(inputId).value
        if (this.ts == null) { return }
        this.ts.sendMsg(value)
    }

    closeWsa() {
        if (this.ts == null) { return }
        this.ts.closeWs()
    }
}

