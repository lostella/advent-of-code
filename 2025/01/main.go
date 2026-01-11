package main

import (
	"fmt"
	"os"
	"strings"
	"strconv"
)

func check(e error) {
	if e != nil {
		panic(e)
	}
}

func main() {
	dat, err := os.ReadFile("input")
	check(err)
	lines := strings.Split(string(dat), "\n")

	pos := 50
	count0 := 0
	for _, line := range lines {
		if line == "" {
			continue
		}
		direction := line[:1]
		amount, err := strconv.Atoi(line[1:])
		check(err)
		if direction == "R" {
			pos += amount
		} else {
			pos -= amount
		}
		pos %= 100
		if pos == 0 {
			count0 += 1
		}
	}
	fmt.Println(count0)

	pos = 50
	count0 = 0
	for _, line := range lines {
		if line == "" {
			continue
		}
		direction := line[:1]
		amount, err := strconv.Atoi(line[1:])
		check(err)
		for _ = range amount {
			if direction == "R" {
				pos += 1
			} else {
				pos -= 1
			}
			pos %= 100
			if pos == 0 {
				count0 += 1
			}
		}
	}
	fmt.Println(count0)
}
