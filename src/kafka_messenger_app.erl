%%%-------------------------------------------------------------------
%% @doc kafka_messenger public API
%% @end
%%%-------------------------------------------------------------------

-module(kafka_messenger_app).

-behaviour(application).

-export([start/2, stop/1]).

start(_StartType, _StartArgs) ->
    {ok, Pid} = kafka_messenger_sup:start_link(),
    io:fwrite("Hello World 1\n"),
    {KafkaBootstrapEndpoints, Topic, Partition} = setKafkaConfig(),
    ok = set_kafka_producer(KafkaBootstrapEndpoints, Topic, Partition),
    {ok, Pid}.

stop(_State) ->
    ok.

%% internal functions
setKafkaConfig() ->
    KafkaBootstrapEndpoints = [{"localhost", 9092}],
    Topic = <<"test-topic">>,
    Partition = 0,
    {KafkaBootstrapEndpoints, Topic, Partition}.

set_kafka_producer(Endpoint, Topic, Partition) ->
    
    io:fwrite("Hello World\n"),
    ok = brod:start_client(Endpoint, client1),
    ok = brod:start_producer(client1, Topic, _ProducerConfig = []),

    {ok, _} = brod:produce_sync_offset(client1, Topic, Partition, <<"key1">>, <<"value1">>),
    
    ok.
