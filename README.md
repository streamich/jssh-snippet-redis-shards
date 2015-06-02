# Provision Multiple Redis Servers

This `jssh` snippet installs multiple *Redis* servers on a single *Ubuntu* box.

It accepts two parameters: number of servers to install and the starting port of the first server:

```javascript
// cluster.js

var cluster = require('jssh-snippet-redis-shards');

cluster({
    shards: 2,
    firstPort: 7000
});
```

To run this script you need [`jssh`](http://npmjs.com/package/jssh) installed:

    npm install -g jssh
    
Now run your file with `jssh`:

    jssh cluster.js
    
Test it:

    redis-cli -p 7000
    set a b
    get a
    "b"
    exit
    
    redis-cli -p 7001
    get a
    (nil)
    