-module(argv_ffi).

-export([load/0]).

load() ->
    Runtime = <<(stringarg(bindir))/binary, "/", (stringarg(progname))/binary>>,
    PlainArguments = lists:map(fun list_to_binary/1, init:get_plain_arguments()),
    {Program, Arguments} = case init:get_argument(escript) of
        {ok, _} ->
            [P | Rest] = PlainArguments,
            {P, Rest};
        _ ->
            {ok, Cwd} = file:get_cwd(),
            {Cwd, PlainArguments}
    end,
    {Runtime, Program, Arguments}.

stringarg(Name) ->
    case init:get_argument(Name) of
        {ok, [[Value]]} -> list_to_binary(Value);
        _ -> <<>>
    end.