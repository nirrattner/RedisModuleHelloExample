This repository implements an example Redis Module to demonstrate a bug related to using [`RedisModule_Call`](https://redis.io/docs/reference/modules/modules-api-ref/#redismodule_call) to call the [`HELLO` command](https://redis.io/commands/hello/). The behavior described below has been observed on Redis 7.0.8, Redis 7.0.12, and Redis 7.1.242.

The unexpected behavior is that the `HELLO` command called by `RedisModule_Call` does not respect the current client's authentication or lack of authentication. Regardless of authentication, the first `HELLO` command called by `RedisModule_Call` after the Redis Server starts up will always succeed, and regardless of authentication, all subsequent `HELLO` commands called by `RedisModule_Call` will fail for that given Redis Server process.

The Redis Module implemented in this repository creates a new command `TEST.HELLO`, which uses `RedisModule_Call` to call `HELLO` with no arguments, but with the client user attached using the `C` format argument.

### Recreation Steps

0. These steps assume that the Redis Server and Redis CLI are both installed locally and that the `redis-server` and `redis-cli` commands are both available on the system path.

1. Clone the repository and compile the module with the following commands
```
git clone https://github.com/nirrattner/RedisModuleHelloExample.git
cd RedisModuleHelloExample
make
```

2. Start the Redis Server loading ACL file and the module with the following command
```
redis-server --aclfile users.acl --loadmodule module.so
```

3. In a second terminal, use the Redis CLI to call the `TEST.HELLO` command multiple times without authentication. The first will succeed, and the rest will fail.
```
redis-cli TEST.HELLO # SUCCEEDS
redis-cli TEST.HELLO # FAILS
redis-cli TEST.HELLO # FAILS
```

4. In the first terminal, shut down and then restart the Redis Server with the same command
```
redis-server --aclfile users.acl --loadmodule module.so
```

5. In the second terminal, use the Redis CLI to call the `TEST.HELLO` command multiple times with authentication. Again, the first will succeed, and the rest will fail.
```
redis-cli --user test.user --pass test.pass TEST.HELLO # SUCCEEDS
redis-cli --user test.user --pass test.pass TEST.HELLO # FAILS
redis-cli --user test.user --pass test.pass TEST.HELLO # FAILS
```
