defmodule Translator do
  alias HTTPoison.{Response, Error}

  @type source :: String.t()
  @type target :: String.t()
  @type model_id :: String.t()
  @type text :: String.t()

  @callback translate(map()) :: {:ok, Response.t()} | {:error, Error.t()}
  @callback identify() :: {:ok, Response.t()} | {:error, Error.t()}
  @callback documents() :: {:ok, Response.t()} | {:error, Error.t()}
  @callback documents(tuple()) :: {:ok, Response.t()} | {:error, Error.t()}
  @callback status(String.t()) :: {:ok, Response.t()} | {:error, Error.t()}
  @callback translated(String.t()) :: {:ok, Response.t()} | {:error, Error.t()}
  @callback delete(String.t()) ::
              {:ok, HTTPoison.Response.t() | HTTPoison.AsyncResponse.t()}
              | {:error, HTTPoison.Error.t()}
end
