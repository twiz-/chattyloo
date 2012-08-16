get '/:channel' do
  session_start!

  # Get the current channel and messages from IronCache
  @channel = Channel.find_or_initialize(params[:channel])
  @messages = @channel.messages

  erb :channel
end

post '/' do

  # Get the current channel from IronCache
  @channel = Channel.find_or_initialize(params[:channel])

  # Form message
  message = {
    session_id: params[:session_id],
    body: params[:body],
    timestamp: Time.now.to_i
  }

  # Save message to IronCache
  @channel.insert(message)
  @messages = @channel.messages

  # Get open streams which match this channel
  @channel.streams.each do |stream|
    stream[:out] << "data: #{message.to_json}\n\n"
  end

 # Response without entity body
  204
end