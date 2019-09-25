defmodule TranslatorRemoteAPITest do
  use ExUnit.Case

  alias TranslatorRemoteAPI

  @payload %{
    text: ["hello, world"],
    model_id: "en-es"
  }

  describe "Translate requests" do
    test "translate text" do
      assert {:ok, %{status_code: 200, body: body}} = TranslatorRemoteAPI.translate(@payload)

      assert {:ok,
              %{
                "character_count" => 12,
                "translations" => [%{"translation" => "Hola, mundo"}],
                "word_count" => 2
              }} == Poison.decode(body)
    end

    test "model not found" do
      payload = %{@payload | model_id: "en-aa"}
      assert {:ok, %{status_code: 404, body: body}} = TranslatorRemoteAPI.translate(payload)
    end

    test "invalid request" do
      payload = Map.delete(@payload, :text)
      assert {:ok, %{status_code: 400, body: body}} = TranslatorRemoteAPI.translate(payload)
    end
  end

  describe "Identify languages" do
    test "all supported languages" do
      assert {:ok, %{status_code: 200, body: body}} = TranslatorRemoteAPI.identify()

      assert {:ok,
              %{
                "languages" => [
                  %{"language" => "af", "name" => "Afrikaans"},
                  %{"language" => "ar", "name" => "Arabic"},
                  %{"language" => "az", "name" => "Azerbaijani"},
                  %{"language" => "ba", "name" => "Bashkir"},
                  %{"language" => "be", "name" => "Belarusian"},
                  %{"language" => "bg", "name" => "Bulgarian"},
                  %{"language" => "bn", "name" => "Bengali"},
                  %{"language" => "ca", "name" => "Catalan"},
                  %{"language" => "cs", "name" => "Czech"},
                  %{"language" => "cv", "name" => "Chuvash"},
                  %{"language" => "da", "name" => "Danish"},
                  %{"language" => "de", "name" => "German"},
                  %{"language" => "el", "name" => "Greek"},
                  %{"language" => "en", "name" => "English"},
                  %{"language" => "eo", "name" => "Esperanto"},
                  %{"language" => "es", "name" => "Spanish"},
                  %{"language" => "et", "name" => "Estonian"},
                  %{"language" => "eu", "name" => "Basque"},
                  %{"language" => "fa", "name" => "Persian"},
                  %{"language" => "fi", "name" => "Finnish"},
                  %{"language" => "fr", "name" => "French"},
                  %{"language" => "ga", "name" => "Irish"},
                  %{"language" => "gu", "name" => "Gujarati"},
                  %{"language" => "he", "name" => "Hebrew"},
                  %{"language" => "hi", "name" => "Hindi"},
                  %{"language" => "hr", "name" => "Croatian"},
                  %{"language" => "ht", "name" => "Haitian"},
                  %{"language" => "hu", "name" => "Hungarian"},
                  %{"language" => "hy", "name" => "Armenian"},
                  %{"language" => "is", "name" => "Icelandic"},
                  %{"language" => "it", "name" => "Italian"},
                  %{"language" => "ja", "name" => "Japanese"},
                  %{"language" => "ka", "name" => "Georgian"},
                  %{"language" => "kk", "name" => "Kazakh"},
                  %{"language" => "km", "name" => "Central Khmer"},
                  %{"language" => "ko", "name" => "Korean"},
                  %{"language" => "ku", "name" => "Kurdish"},
                  %{"language" => "ky", "name" => "Kirghiz"},
                  %{"language" => "lt", "name" => "Lithuanian"},
                  %{"language" => "lv", "name" => "Latvian"},
                  %{"language" => "ml", "name" => "Malayalam"},
                  %{"language" => "mn", "name" => "Mongolian"},
                  %{"language" => "ms", "name" => "Malay"},
                  %{"language" => "mt", "name" => "Maltese"},
                  %{"language" => "nb", "name" => "Norwegian Bokmal"},
                  %{"language" => "nl", "name" => "Dutch"},
                  %{"language" => "nn", "name" => "Norwegian Nynorsk"},
                  %{"language" => "pa", "name" => "Panjabi"},
                  %{"language" => "pl", "name" => "Polish"},
                  %{"language" => "ps", "name" => "Pushto"},
                  %{"language" => "pt", "name" => "Portuguese"},
                  %{"language" => "ro", "name" => "Romanian"},
                  %{"language" => "ru", "name" => "Russian"},
                  %{"language" => "sk", "name" => "Slovakian"},
                  %{"language" => "sl", "name" => "Slovenian"},
                  %{"language" => "so", "name" => "Somali"},
                  %{"language" => "sq", "name" => "Albanian"},
                  %{"language" => "sr", "name" => "Serbian"},
                  %{"language" => "sv", "name" => "Swedish"},
                  %{"language" => "ta", "name" => "Tamil"},
                  %{"language" => "te", "name" => "Telugu"},
                  %{"language" => "th", "name" => "Thai"},
                  %{"language" => "tr", "name" => "Turkish"},
                  %{"language" => "uk", "name" => "Ukrainian"},
                  %{"language" => "ur", "name" => "Urdu"},
                  %{"language" => "vi", "name" => "Vietnamese"},
                  %{"language" => "zh", "name" => "Simplified Chinese"},
                  %{"language" => "zh-TW", "name" => "Traditional Chinese"}
                ]
              }} == Poison.decode(body)
    end
  end
end
