// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

contract Structs {
    struct Car{
        uint year;
        address addr;
        string owner;
    }
    Car[] public cars;
    Car public car;

    function addCar()external {
        Car memory car1 = Car(1990,msg.sender,"aodi");
        Car memory car2 = Car({year:1991,addr:msg.sender,owner:"baoma"});
        Car memory car3;
        car3.addr=msg.sender;
        car3.owner="benchi";
        car3.year=1993;
        cars.push(car1); 
        cars.push(car2);  
        cars.push(car3);  

        car=Car(1994,msg.sender,"aodi");
        car.year=1995;

        delete car.owner;
        delete cars[0];
        delete cars[1].year;
    }
}