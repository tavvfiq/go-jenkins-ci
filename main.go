package main

import (
	"fmt"
)

func counter(ch chan int) {
	val := 2
	ch <- val
	ch <- val + 1
	ch <- val + 2
}

func main() {
	ch := make(chan int)
	go counter(ch)
	fmt.Println(<-ch, <-ch, <-ch)
	fmt.Println("test jenkins")
}
