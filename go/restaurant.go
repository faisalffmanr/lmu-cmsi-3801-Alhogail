package main

import (
	"log"
	"math/rand"
	"sync"
	"sync/atomic"
	"time"
)

type Order struct {
	id        uint64
	customer  string
	replyChan chan *Order
	preparedBy string
}

func do(seconds int, action ...any) {
	log.Println(action...)
	randomMillis := 500*seconds + rand.Intn(500*seconds)
	time.Sleep(time.Duration(randomMillis) * time.Millisecond)
}


var waiter = make(chan *Order, 3)


var orderIDCounter atomic.Uint64


func cook(name string, wg *sync.WaitGroup) {
	defer wg.Done()
	log.Println(name, "starting work")
	for order := range waiter {
		do(10, name, "cooking order", order.id, "for", order.customer)
		order.preparedBy = name
		order.replyChan <- order
	}
}


func customer(name string, wg *sync.WaitGroup) {
	defer wg.Done()
	log.Println(name, "starting dining experience")
	mealsEaten := 0
	for mealsEaten < 5 {
		order := &Order{
			id:        orderIDCounter.Add(1),
			customer:  name,
			replyChan: make(chan *Order, 1),
		}
		log.Println(name, "placed order", order.id)
		select {
		case waiter <- order: 
			meal := <-order.replyChan 
			do(2, name, "eating cooked order", meal.id, "prepared by", meal.preparedBy)
			mealsEaten++
		case <-time.After(7 * time.Second): 
			do(5, name, "waiting too long, abandoning order", order.id)
		}
		
		time.Sleep(time.Duration(1000+rand.Intn(1000)) * time.Millisecond)
	}
	log.Println(name, "going home after eating", mealsEaten, "meals")
}

func main() {
	rand.Seed(time.Now().UnixNano())
	log.SetFlags(log.LstdFlags)

	var wg sync.WaitGroup

	
	cooks := []string{"Ramy", "David", "Linguini"}
	for _, cookName := range cooks {
		wg.Add(1)
		go cook(cookName, &wg)
	}

	
	customers := []string{"Faisal", "Fahad", "Khaled", "Yazeed", "Sama", "Sara", "Jawad", "Meshary", "Nawaf", "Turki"}
	for _, customerName := range customers {
		wg.Add(1)
		go customer(customerName, &wg)
	}


	wg.Wait()

	close(waiter)

	log.Println("The restaurant is closing")
}
