defmodule TranslatorRemoteAPI do
  alias Translator
  alias Utils.Formats, as: Formart

  @behaviour Translator

  @version Application.get_env(:ex_watson_translator, :version)
  @url Application.get_env(:ex_watson_translator, :url) <> "/v3/translate?version=#{@version}"
  @api_key Application.get_env(:ex_watson_translator, :api_key)
  @json_header {"Content-Type", "application/json"}

  @impl Translator
  def translate(params) do
    body = build_body(params)
    header = build_header()

    @url
    |> HTTPoison.post(body, header)
  end

  @impl Translator
  def identify do
    header = build_header()

    @url
    |> String.replace("translate?", "identifiable_languages?")
    |> HTTPoison.get(header)
  end

  @impl Translator
  def delete(document_id) when is_binary(document_id) do
    header = build_header()

    url =
      @url
      |> String.replace("translate", "documents/" <> document_id)

    HTTPoison.delete(url, header)
  end

  @impl Translator
  def status(document_id) when is_binary(document_id) do
    header = build_header()

    @url
    |> String.replace("translate", "documents/" <> document_id)
    |> HTTPoison.get(header)
  end

  @impl Translator
  def translated(document_id) when is_binary(document_id) do
    header = build_header()

    @url
    |> String.replace("translate", "documents/" <> document_id <> "/translated_document")
    |> HTTPoison.get(header)
  end

  @impl Translator
  def documents do
    header = build_header()

    @url
    |> String.replace("translate?", "documents?")
    |> HTTPoison.get(header)
  end

  @impl Translator
  def documents({:multipart, data}) do
    case build_body(data) do
      {:error, msg} ->
        {:error, msg}

      body ->
        extension = :proplists.get_value(:header, data)
        header = build_header(extension)

        @url
        |> String.replace("translate?", "documents?")
        |> HTTPoison.post({:multipart, body}, header)
    end
  end

  defp build_body(data) when is_list(data) do
    file_path = :proplists.get_value(:file, data)
    {:ok, file_binary} = File.read(file_path)

    if byte_size(file_binary) < Formart.size_limit() do
      :proplists.delete(:header, data)
    else
      {:error, "Maximum file size: 20 MB"}
    end
  end

  defp build_body(%{text: _, model_id: _} = params) do
    Poison.encode!(params)
  end

  defp build_header, do: build_header(:json)

  defp build_header(:json) do
    api_key = "apikey:#{@api_key}" |> Base.encode64()

    [
      {"Authorization", "Basic " <> api_key},
      @json_header
    ]
  end

  defp build_header(extension) do
    api_key = "apikey:#{@api_key}" |> Base.encode64()

    [
      {"Authorization", "Basic " <> api_key},
      {"Content-Type", extension}
    ]
  end
end
