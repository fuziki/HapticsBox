package main

import (
	"bufio"
	"fmt"
	"log"
	"net/http"
	"os"

	"github.com/fuziki/tanuroom"
	"github.com/gorilla/websocket"
)

var upgrader = websocket.Upgrader{
	ReadBufferSize:  1024,
	WriteBufferSize: 1024,
	CheckOrigin: func(r *http.Request) bool {
		return true
	},
}

var room tanuroom.TanuRoom

func main() {
	fmt.Println("start tanu room")
	room = tanuroom.NewPeerRoom()
	http.HandleFunc("/tanu", func(w http.ResponseWriter, r *http.Request) {
		fmt.Println("access tanu, req: ", r)
		conn, err := upgrader.Upgrade(w, r, nil)
		if err != nil {
			fmt.Println("failed upgrade error: ", err)
			return
		}
		tanu := tanuroom.NewTanusan(r, conn)
		room.AppendNewTanusan(tanu)
	})
	http.HandleFunc("/webclient/", func(w http.ResponseWriter, r *http.Request) {
		http.ServeFile(w, r, r.URL.Path[1:])
	})
	go func() {
		err := http.ListenAndServe(":8080", nil)
		if err != nil {
			log.Fatal("ListenAndServe: ", err)
		}
	}()
	log.Println("web client: http://localhost:8080/webclient")
	scanner := bufio.NewScanner(os.Stdin)
	for {
		scanner.Scan()
		t := scanner.Text()
		if t == "close" || t == "c" || t == "i" || t == "" {
			break
		}
	}
	log.Println("wait m(_ _)m close room")
	room.Dispose()
	log.Println("finish tanu room ﾉｼ")
}
