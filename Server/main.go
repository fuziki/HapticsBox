package main

import (
	"log"
	"net/http"
)

func main() {
	http.HandleFunc("/webclient/", func(w http.ResponseWriter, r *http.Request) {
		http.ServeFile(w, r, r.URL.Path[1:])
	})

	err := http.ListenAndServe(":8080", nil)
	if err != nil {
		log.Fatal("ListenAndServe: ", err)
	}
	log.Println("web client: http://localhost:8080/webclient")
}
