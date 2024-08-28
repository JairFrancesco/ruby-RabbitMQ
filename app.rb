require 'bunny'

begin
  # Connect to RabbitMQ server
  connection = Bunny.new(
    tls: true,
    host: 'rabbitmq-exam.rmq3.cloudamqp.com',
    port: 5671,
    user: 'student',
    password: 'XYR4yqc.cxh4zug6vje',
    vhost: 'mxifnklj'
  )
  connection.start

  channel = connection.create_channel

  # Declare exchange and queue
  exchange_name = 'exchange.232461d0-803e-482b-abd1-01ee8d6fbdb1'
  queue_name = 'exam'
  routing_key = '232461d0-803e-482b-abd1-01ee8d6fbdb1'

  # Create an exchange
  exchange = channel.direct(exchange_name, durable: true)

  # Create a queue
  queue = channel.queue(queue_name, durable: true)

  # Bind the queue to the exchange
  queue.bind(exchange, routing_key: routing_key)

  # Send a persistent message
  message_body = 'Hi CloudAMQP, this was fun!'
  exchange.publish(
    message_body,
    routing_key: routing_key,
    persistent: true
  )

  puts "Sent message: '#{message_body}'"

rescue Bunny::Exception => e
  puts "An error occurred: #{e.message}"
ensure
  # Cleanup
  begin
    queue.unbind(exchange, routing_key: routing_key)
    exchange.delete
    connection.close
  rescue => e
    puts "An error occurred during cleanup: #{e.message}"
  end
end