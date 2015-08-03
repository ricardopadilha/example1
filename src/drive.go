package main

import (
	"fmt"

	"github.com/syndtr/goleveldb/leveldb"
)

func main() {
	db, err := leveldb.OpenFile("db/example", nil)
	check(err)

	err = db.Put([]byte("key"), []byte("value"), nil)
	check(err)

	data, err2 := db.Get([]byte("key"), nil)
	check(err2)

	fmt.Printf("Got: %s\n", string(data))
	defer db.Close()
}

func check(err error) {
	if err != nil {
		panic(err)
	}

}
