```
(lldb) watchpoint set variable self->_person->_nickName
Watchpoint created: Watchpoint 1: addr = 0x600003266e90 size = 8 state = enabled type = w
    watchpoint spec = 'self->_person->_nickName'
    new value: 0x0000000000000000
```


<hr>


watchpoint, 比较适合搞 KVO


<hr>

```
Watchpoint 1 hit:
old value: 0x0000000000000000
new value: 0x0000000108ad4110

```


