defmodule Translator do
  alias HTTPoison.{Response, Error}

  @type source :: String.t()
  @type target :: String.t()
  @type model_id :: String.t()
  @type text :: String.t()

  @callback translate(map()) :: {:ok, Response.t()} | {:error, Error.t()}
  @callback identify() :: {:ok, Response.t()} | {:error, Error.t()}
  @callback list_documents() :: {:ok, Response.t()} | {:error, Error.t()}
end
