#include <string.h>

#include "redismodule.h"

static int test_hello_command(
    RedisModuleCtx *module_context,
    RedisModuleString **argv,
    int argc) {
  RedisModuleCallReply *reply;
  reply = RedisModule_Call(
      module_context,
      "HELLO",
      "0CE");
  return RedisModule_ReplyWithCallReply(module_context, reply);
}

int RedisModule_OnLoad(RedisModuleCtx *module_context) {
  int result;

  result = RedisModule_Init(
      module_context,
      "test-hello",
      1,
      REDISMODULE_APIVER_1);
  if (result) {
    return REDISMODULE_ERR;
  }

  result = RedisModule_CreateCommand(
      module_context,
      "TEST.HELLO",
      test_hello_command,
      "no-auth",
      0,
      0,
      0);
  if (result) {
    return REDISMODULE_ERR;
  }

  return REDISMODULE_OK;
}

