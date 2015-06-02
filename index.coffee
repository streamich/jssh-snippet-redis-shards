
# Need to have stock redis server pre-installed.
require 'jssh-snippet-redis'


defaults =
  firstPort: 6379
  shards: 4

module.exports = (config) ->

  config = _.extend {}, defaults, config

  # List of ports on which we will run redis servers.
  ports = [config.firstPort..config.firstPort + config.shards - 1]

  mkdir '-p', '/var/run/redis'
  mkdir '-p', '/var/log/redis'

  # Configuration templates.
  dir =  "#{__dirname}/tpl"
  tpl_conf = cat "#{dir}/redis.conf"
  tpl_init = cat "#{dir}/redis-server.sh"

  rport = new RegExp "__PORT__", "g"
  for port in ports
    tpl_conf.replace(rport, port).to "/etc/redis/redis-#{port}.conf"

    mkdir '-p', "/var/lib/redis-#{port}"

    # This requires `jssh-api-jssh-bin`
#    chown 'redis', 'redis', "/var/lib/redis-#{port}"
    # So we do just this, for now
    $ "chown redis.redis /var/lib/redis-#{port}"

    tpl_init.replace(rport, port).to "/etc/init.d/redis_#{port}"
    chmod 777, "/etc/init.d/redis_#{port}"
    $ "update-rc.d redis_#{port} defaults"
    $ "/etc/init.d/redis_#{port} start"

  # Disable default Redis server.
  $ 'update-rc.d redis-server disable'
