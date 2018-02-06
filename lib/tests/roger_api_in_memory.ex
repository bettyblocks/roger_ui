defmodule RogerUi.Tests.RogerApiInMemory do
  @moduledoc """
  Mocks calls to Roger.Info API
  """

  @behaviour RogerUi.Roger

  def partitions do
    [
      "server@127.0.0.1": %{
        running: %{
          "roger_test_partition_1" => %{
            default: %{consumer_count: 1, max_workers: 10, message_count: 740, paused: false},
            fast: %{consumer_count: 1, max_workers: 10, message_count: 740, paused: false},
            other: %{consumer_count: 1, max_workers: 2, message_count: 0, paused: false}
          }
        },
        waiting: %{
          "roger_test_partition_2" => %{
            default: %{consumer_count: 1, max_workers: 10, message_count: 740, paused: false},
            fast: %{consumer_count: 1, max_workers: 10, message_count: 740, paused: false},
            other: %{consumer_count: 1, max_workers: 2, message_count: 0, paused: false}
          }
        }
      },
      "watcher@127.0.0.1": %{
        running: %{
          "roger_test_partition_3" => %{
            default: %{consumer_count: 1, max_workers: 10, message_count: 740, paused: false},
            fast: %{consumer_count: 1, max_workers: 10, message_count: 740, paused: false},
            other: %{consumer_count: 1, max_workers: 2, message_count: 0, paused: false}
          }
        },
        waiting: %{
          "roger_test_partition_4" => %{
            default: %{consumer_count: 1, max_workers: 10, message_count: 740, paused: false},
            fast: %{consumer_count: 1, max_workers: 10, message_count: 740, paused: false},
            other: %{consumer_count: 1, max_workers: 2, message_count: 0, paused: false}
          }
        }
      }
    ]
  end

  def running_jobs(_partition_name \\ "") do
    [
      "watcher@127.0.0.1": [
        %Roger.Job{
          args: %{"country" => "Venezuela", "email" => "janedoe@gmail.com", "name" => "Jane Doe", "number_of_pets" => 966},
          execution_key: nil, id: "16ovjr39jvijf4kgrlqe2ib2aadojhid", module: RogerDemo.Job.CreateUpdateUser,
          queue_key: nil, queued_at: 1517697586453, retry_count: 0, started_at: 1517697682999
        },
        %Roger.Job{
          args: %{"country" => "Venezuela", "email" => "janedoe@gmail.com", "name" => "Jane Doe", "number_of_pets" => 965},
          execution_key: nil, id: "289gp2bklk91diuukgd73jtm4pes0hfe", module: RogerDemo.Job.CreateUpdateUser,
          queue_key: nil, queued_at: 1517697586453, retry_count: 0, started_at: 1517697682998
        },
        %Roger.Job{
          args: %{"country" => "Venezuela", "email" => "janedoe@gmail.com", "name" => "Jane Doe", "number_of_pets" => 962},
          execution_key: nil, id: "38mkrss34n1uc4tdmulu4mqm4ic9a5t6", module: RogerDemo.Job.CreateUpdateUser,
          queue_key: nil, queued_at: 1517697586453, retry_count: 0, started_at: 1517697682981
        },
        %Roger.Job{
          args: %{"country" => "Venezuela", "email" => "janedoe@gmail.com", "name" => "Jane Doe", "number_of_pets" => 961},
          execution_key: nil, id: "5hm0u6cbeo8tdk6qkq0l8v6qgqnfhori", module: RogerDemo.Job.CreateUpdateUser,
          queue_key: nil, queued_at: 1517697586453, retry_count: 0, started_at: 1517697682981
        },
        %Roger.Job{
          args: %{"country" => "Venezuela", "email" => "janedoe@gmail.com", "name" => "Jane Doe", "number_of_pets" => 964},
          execution_key: nil, id: "83u3ourppqnctk67r6f0mh3cmoa34a3i", module: RogerDemo.Job.CreateUpdateUser,
          queue_key: nil, queued_at: 1517697586453, retry_count: 0, started_at: 1517697682983
        }
      ],
      "server@127.0.0.1": [
        %Roger.Job{
          args: %{"country" => "Venezuela", "email" => "janedoe@gmail.com", "name" => "Jane Doe", "number_of_pets" => 967},
          execution_key: nil, id: "c2mkvrgfonkgf1pdgkdl87okb3hi103r", module: RogerDemo.Job.CreateUpdateUser,
          queue_key: nil, queued_at: 1517697586454, retry_count: 0, started_at: 1517697683000
        },
        %Roger.Job{
          args: %{"country" => "Venezuela", "email" => "janedoe@gmail.com", "name" => "Jane Doe", "number_of_pets" => 970},
          execution_key: nil, id: "fah075k2eeps6dnq3qpage99og2cpoiv", module: RogerDemo.Job.CreateUpdateUser,
          queue_key: nil, queued_at: 1517697586454, retry_count: 0, started_at: 1517697683001
        },
        %Roger.Job{
          args: %{"country" => "Venezuela", "email" => "janedoe@gmail.com", "name" => "Jane Doe", "number_of_pets" => 969},
          execution_key: nil, id: "n2c0v3pouv0944l7k5bbgnfuksq61bu7", module: RogerDemo.Job.CreateUpdateUser,
          queue_key: nil, queued_at: 1517697586454, retry_count: 0, started_at: 1517697683001
        },
        %Roger.Job{
          args: %{"country" => "Venezuela", "email" => "janedoe@gmail.com", "name" => "Jane Doe", "number_of_pets" => 963},
          execution_key: nil, id: "nutgqfhbcqkpju5e7975oh1o10mt6n3t", module: RogerDemo.Job.CreateUpdateUser,
          queue_key: nil, queued_at: 1517697586453, retry_count: 0, started_at: 1517697682983
        },
        %Roger.Job{
          args: %{"country" => "Venezuela", "email" => "janedoe@gmail.com", "name" => "Jane Doe", "number_of_pets" => 968},
          execution_key: nil, id: "qcdvp0qbdhc5d6jabpuk6v0jjg3jkr3t", module: RogerDemo.Job.CreateUpdateUser,
          queue_key: nil, queued_at: 1517697586454, retry_count: 0, started_at: 1517697683000
        }
      ],
      nonode@nohost: []
    ]
  end

  def purge_queue(_partition_name, _queue_name), do: {:ok, %{message_count: 0}}
  def queue_pause(_partition_name, _queue_name), do: :ok
  def queue_resume(_partition_name, _queue_name), do: :ok
  def cancel_job(_partition_name, _job_name), do: :ok
  def queued_jobs(_partition_name, _queue_name), do: :ok
end
