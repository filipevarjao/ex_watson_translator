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
      returned_body = Poison.decode(body)

      assert {:ok, %{"languages" => list_of_languages}} = returned_body
      assert [%{"language" => language_id, "name" => language} | _] = list_of_languages

      assert is_binary(language_id)
      assert String.length(language_id) == 2
      assert is_binary(language)
      refute "" == language
    end
  end

  describe "Translate documents" do
    test "list documents that have been submitted for translation" do
      assert {:ok, %{status_code: 200, body: body}} = TranslatorRemoteAPI.list_documents()
      returned_body = Poison.decode(body)

      assert {:ok, %{"documents" => list_of_documents}} = returned_body
      assert is_list(list_of_documents)
    end
  end
end
