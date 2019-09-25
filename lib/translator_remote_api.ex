defmodule TranslatorRemoteAPI do
  alias Translator

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

  defp build_body(params) do
    text = Map.get(params, :text)
    model_id = Map.get(params, :model_id)

    Poison.encode!(%{
      "text" => text,
      "model_id" => model_id
    })
  end

  defp build_header, do: build_header(:json)

  defp build_header(:json) do
    api_key = "apikey:#{@api_key}" |> Base.encode64()

    [
      {"Authorization", "Basic " <> api_key},
      @json_header
    ]
  end
end
