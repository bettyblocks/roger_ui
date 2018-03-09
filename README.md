# RogerUI


This library provides an UI dashboard for [Roger](https://github.com/bettyblocks/roger), a job processing library based on message broadcasting [RabbitMQ](https://www.rabbitmq.com)

RogerUI allow you to see nodes, partitions and queues with various details levels.

### [Screenshots](https://github.com/spadaveccia/roger_ui/tree/master/screenshots)

## Features

- Graphical User Interface
- Multi-tentant architecture, based on partitions or nodes
- Based on Roger and RabbitMQ
- On-line monitoring - Per-queue concurrency control
- Jobs cancellation (both queued and while running)
- Pausing / unpausing working queues
- Cluster-aware
- Detailed queue / partition information
- Graceful shutdown on stopping

## Software Requirements

You will need the following to compile and run the application:

* [Elixir 1.5.1](https://elixir-lang.org/install.html) or greater
* [Roger 1.3.0](https://github.com/bettyblocks/roger/blob/master/README.md#getting-started) or greater
* [RabbitMQ 3.6.0](https://www.rabbitmq.com/#getstarted) or greater

## Installing RogerUI (User mode)

#### Installing RogerUI

Once you have installed and configured [RabbitMQ](https://www.rabbitmq.com/#getstarted) and [Roger](https://github.com/bettyblocks/roger/blob/master/README.md#getting-started)

Add Roger UI dep in your /mix.exs:
```
defp deps do
{:roger_ui, "~> 0.1"}
end
```

Inside the project folder run `mix deps.get`, and then run `mix compile`

#### Configuring with Phoenix to run like Plug

On your application when Roger’s instance its configured:
- Change /web/router.exs file and add the following lines:

```
  pipeline :roger do
    plug :accepts, ["html"]
    plug :put_secure_browser_headers
    plug RogerUI.Web.RouterPlug, namespace: "roger"
  end

  scope "/roger", RogerUI.Web.RouterPlug do
    pipe_through :roger
    forward "/", Router, namespace: "roger"
  end
```
You can change the namespace and scope to wathever works for you, then you can start `Phoenix` server and navigate to `roger` namespace like: `http://localhost/roger`

## Installing RogerUI (Developer mode)

#### Installing RogerUI

Once you have installed and configured [RabbitMQ](https://www.rabbitmq.com/#getstarted), [Node.js & npm](https://docs.npmjs.com/getting-started/installing-node) and [Roger](https://github.com/bettyblocks/roger/blob/master/README.md#getting-started), in your develop enviroment

- Create a Phoenix project with mix:  `mix phoenix.new`
- Clone [RogerUI](https://github.com/bettyblocks/roger_ui) project,

 Open command line and go to /priv/vue folder:
- run  `npm install` 

#### Configuring RogerUI

On your application where Roger’s instance its configured:
- Add Roger UI local dep in your /mix.exs:
```
{:roger_ui, "~> 0.1", path: "../roger_ui"}
```
- Change /config/config.exs file and add the following lines:
```
# Configure AMQP
config :roger, Roger.AMQPClient,
  host: "localhost",
  port: 5672

config :roger, Roger.Partition.Worker,
  callbacks: RogerUiDemo.Worker.Callback

if node() == :"server@127.0.0.1" do
  config :roger_ui, :server, true
  config :roger, :partitions,
    roger_ui_demo_partition: [default: 10, other: 2]
else
  config :roger_ui, :server, false
  Node.ping(:"server@127.0.0.1")
end
```
Note: The `:"server@127.0.0.1"` option should match with your local node’s name, so you must set it with `iex –sname` command before application runs. This will be described shortly.

- Optionally, if you wish to run the client in a different machine, you must create a file `server.base.url.js` on `roger_ui/priv/vue/config` directory. This file must contains:

```
module.exports = '"http://your-address:your-port"'
```
IMPORTANT: the address must be enclosed inside double quote AND single quote

Inside roger_ui/priv/vue folder run:
- `npm install`
- `npm run build`
- `npm run dev`

#### Running RogerUI

Inside your phoenix application you must run:
- `mix deps.get`
- `mix compile` 
- `iex –-name server@127.0.0.1 -S mix phx.server` 

to get the application up, remember match server name according `/config/config.exs` file before described.
- RogerUI will be available at `http://localhost:8080` once it starts, or, if you created and configurated `roger_ui/priv/vue/config/server.base.url.js` in that address


## License

Copyright © 2018 Betty Blocks
