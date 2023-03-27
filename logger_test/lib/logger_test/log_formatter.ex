defmodule LoggerTest.LogFormatter do
  @moduledoc """
  This is the formatter for our logging messages
  """
  @protected [:request_id]

  @doc """
  We don't want to print any log messages with the custom skip_log metadata added
  """
  @spec format(any, any, any, any) :: <<_::64, _::_*8>>
  def format(level, message, timestamp, metadata) do
    case metadata[:skip_log] do
      true ->
        ""

      _ ->
        try do
          "##### #{fmt_timestamp(timestamp)} #{fmt_metadata(metadata)} \n [#{level}] #{message}\n"
        rescue
          _ ->
            "could not format message: #{inspect({level, message, timestamp, metadata})}\n"
        end
    end
  end

  defp fmt_metadata(md) do
    # First drop all the keys that I don't think we need, then map through the rest and remove redacted ones.
    md
    |> Keyword.drop([:pid, :time, :mfa, :erl_level, :application, :domain, :mb_prefix, :gl])
    |> Keyword.keys()
    |> Enum.map_join(" ", &output_metadata(md, &1))
  end

  @spec output_metadata(any, any) :: nonempty_binary
  def output_metadata(metadata, key) do
    if Enum.member?(@protected, key) do
      "#{key}=(REDACTED)"
    else
      "#{key}=#{inspect(metadata[key])}"
    end
  end

  defp fmt_timestamp({date, {hh, mm, ss, ms}}) do
    with {:ok, timestamp} <- NaiveDateTime.from_erl({date, {hh, mm, ss}}, {ms * 1000, 3}),
         result <- NaiveDateTime.to_iso8601(timestamp) do
      "#{result}Z"
    end
  end
end
