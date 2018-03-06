# RogerUI


RogerUI This solution is set in an existing system of services, and first and foremost must integrate well with these systems, focussing on the specific missing features of current MQ monitoring solutions. These features are provided via RESTful API where Roger deps provides the necessary features to interact with RabbitMQ. Aditionally it provides an UI dashboard for [Exq](https://github.com/bettyblocks/roger), a job processing library which use [RabbitMQ](https://www.rabbitmq.com) for [Elixir](http://elixir-lang.org).

RogerUI allow you to see nodes, partitions and queues with various details levels.

### [screenshots](https://github.com/spadaveccia/roger_ui/tree/master/screenshots)

## Features

- Graphical User Interface
- Multi-tentant architecture, based on partitions or nodes
- Based on Roger and RabbitMQ
- On-line monitoring - Per-queue concurrency control
- Jobs cancellation (both queued and while running)
- Option to enforce per-partition job uniqueness
- Option to enforce job uniqueness during execution
- Pausing / unpausing work queues
- Cluster-aware
- Retry w/ exponential back off
- Resilient against AMQP network conditions (reconnects, process crashes, etc.)
- Partition state persistence between restarts (configurable trough Roger)
- Detailed queue / partition information
- Graceful shutdown on stopping

## Software Requirements

You will need the following to compile and run the application:

* [Elixir 1.5.1](https://elixir-lang.org/install.html) or greater
* [Roger 1.3.0](https://github.com/bettyblocks/roger/blob/master/README.md#getting-started) or greater
* [RabbitMQ 3.6.0](https://www.rabbitmq.com/#getstarted) or greater

## Installing RogerUI in user mode

#### Installing RogerUI

Once you have installed and configured [RabbitMQ](https://www.rabbitmq.com/#getstarted) and [Roger](https://github.com/bettyblocks/roger/blob/master/README.md#getting-started)

Inside the project folder run mix `deps.get`, and then run `mix compile`

#### Configuring RogerUI

On your application where Roger’s instance its configured:

- Add Roger UI dep in your /mix.exs:
```
defp deps do
{:roger_ui, "~> 0.1}
end
```

#### Configuring with Phoenix to run like Plug

On your application when Roger’s instance its configured:
- Change /web/router.exs file and add the following lines:

```
  pipeline :roger do
    plug :accepts, ["html"]
    plug :put_secure_browser_headers
    plug RogerUi.Web.RouterPlug, namespace: "roger"
  end

  scope "/roger", RogerUi.Web.RouterPlug do
    pipe_through :roger
    forward "/", Router, namespace: "roger"
  end
```

Note: You may found a more complete example of these implementations in [Roger Demo](https://github.com/Spadavecchia/roger_ui_demo) example application.

#### Running RogerUI

Inside Roger UI project folder, run `iex –S mix` to get the application up, then the app will be available at `http://localhost:8080` once it starts.

## Installing RogerUI in developer mode

#### Installing RogerUI

Once you have installed and configured [RabbitMQ](https://www.rabbitmq.com/#getstarted) and [Roger](https://github.com/bettyblocks/roger/blob/master/README.md#getting-started), in your develop enviroment

- Clone or download [RogerUI](https://github.com/Spadavecchia/roger_ui) project,
- Create a phoenix project with mix:  `mix phoenix.new`

In order to install the UI you will require [Node.js & npm](https://docs.npmjs.com/getting-started/installing-node), so you must inside /priv/vue folder:
- run  `npn install` 
- then excecute `npn run build`  

#### Configuring RogerUI

On your application when Roger’s instance its configured:
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

- Optionally, if you wish to run the client in a different machine, change the BASE_URL parameter in priv/vue/config/dev.env.js file, however by default it will run on localhost:
```
module.exports = merge(prodEnv, {
  NODE_ENV: '"development"',
  // Change the API base url.
  BASE_URL: '"http://127.0.0.1:4040/"',
})
```
Inside /priv/vue folder:
- run  npn install 
- then excecute npn run build  
- and finally npn run dev  

#### Configuring with Phoenix to run like Plug

On your application when Roger’s instance its configured:
- Change /web/router.exs file and add the following lines:
```
  pipeline :roger do
    plug :accepts, ["html"]
    plug :put_secure_browser_headers
    plug RogerUi.Web.RouterPlug, namespace: "roger"
  end

  scope "/roger", RogerUi.Web.RouterPlug do
    pipe_through :roger
    forward "/", Router, namespace: "roger"
  end
```
Note: You may found a more complete example of these implementations in [Roger Demo](https://github.com/Spadavecchia/roger_ui_demo) example application.

#### Running RogerUI

Inside Roger UI project folder, 
- run `mix deps.get` and then `mix compile` 
- run `iex –-name server@127.0.0.1 -S mix` to get the application up, remember match server name according /config/config.exs file before described.
- The app will be available at `http://localhost:8080/roger` once it starts.


## License

Copyright © 2018 Betty Blocks
