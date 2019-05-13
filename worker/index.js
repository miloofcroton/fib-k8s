const keys = require('./keys');
const redis = require('redis');

const redisClient = redis.createClient({
  host: keys.redisHost,
  port: keys.redisPort,
  retry_strategy: () => 1000
  // retry_strategy: function (options) {
  //   if (options.error && options.error.code === 'ECONNREFUSED') {
  //       // End reconnecting on a specific error and flush all commands with
  //       // a individual error
  //       return new Error('The server refused the connection');
  //   }
  //   if (options.total_retry_time > 1000 * 60 * 60) {
  //       // End reconnecting after a specific timeout and flush all commands
  //       // with a individual error
  //       return new Error('Retry time exhausted');
  //   }
  //   if (options.attempt > 10) {
  //       // End reconnecting with built in error
  //       return undefined;
  //   }
  //   // reconnect after
  //   return Math.min(options.attempt * 100, 3000);
  // }
});
const sub = redisClient.duplicate();

function fib(index) {
  if (index < 2) return 1;
  return fib(index - 1) + fib(index - 2);
}

sub.on('message', (channel, message) => {
  redisClient.hset('values', message, fib(parseInt(message)));
});
sub.subscribe('insert');
