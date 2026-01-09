// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

contract TodoList {
    struct Todo{
        string text;
        bool bo;
        string a;
        string b;
        string c;
        string d;
    } 

    Todo[] public todos;
    function create(string calldata tex) external{
        todos.push(Todo(tex,false,tex,tex,tex,tex));
    }

//52101;30429
    function update(uint index,string calldata str) external{
        todos[index].text=str;
        todos[index].a=str;
        todos[index].b=str;
        todos[index].c=str;
        todos[index].d=str;
    }
    //37240,15568
    function update2(uint index,string calldata str) external{
        Todo storage stodo =todos[index];
        stodo.text=str;
        stodo.a=str;
        stodo.b=str;
        stodo.c=str;
        stodo.d=str;
    }     
}