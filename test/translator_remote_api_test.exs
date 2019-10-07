defmodule TranslatorRemoteAPITest do
  use ExUnit.Case

  alias TranslatorRemoteAPI
  alias Utils.Formats, as: Format

  @path File.cwd!()

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
      assert {:ok, %{status_code: 404, body: _body}} = TranslatorRemoteAPI.translate(payload)
    end

    # test "invalid request" do
    #   payload = Map.delete(@payload, :text)
    #   assert {:ok, %{status_code: 400, body: body}} = TranslatorRemoteAPI.translate(payload)
    # end
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
      assert {:ok, %{status_code: 200, body: body}} = TranslatorRemoteAPI.documents()
      returned_body = Poison.decode(body)

      assert {:ok, %{"documents" => list_of_documents}} = returned_body
      assert is_list(list_of_documents)
    end

    test "fail when submit a file over 20MB" do
      file_path = Path.join([@path, "test/fixtures/overlimit.txt"])
      assert true == File.exists?(file_path)
      file_extension = Path.extname(file_path)
      header = Format.get_header(file_extension)

      payload = {:multipart, [{:file, file_path}, {"model_id", "en-fr"}, {:header, header}]}
      assert {:error, "Maximum file size: 20 MB"} = TranslatorRemoteAPI.documents(payload)
    end

    test "submit a txt document to translate" do
      file_path = Path.join([@path, "test/fixtures/sample.txt"])
      assert true == File.exists?(file_path)
      file_extension = Path.extname(file_path)
      header = Format.get_header(file_extension)

      payload = {:multipart, [{:file, file_path}, {"model_id", "en-fr"}, {:header, header}]}

      assert {:ok, %{status_code: 200, body: body}} = TranslatorRemoteAPI.documents(payload)

      assert {:ok,
              %{
                "document_id" => new_id,
                "filename" => file_name,
                "model_id" => "en-fr",
                "source" => "en",
                "target" => "fr",
                "status" => "processing",
                "created" => _created_time
              }} = Poison.decode(body)

      assert file_name == Path.basename(file_path)
      assert is_binary(new_id)
    end

    test "geting documents status" do
      submit_doc()
      assert {:ok, %{status_code: 200, body: body}} = TranslatorRemoteAPI.documents()
      assert {:ok, %{"documents" => [%{"document_id" => document_id} | _]}} = Poison.decode(body)
      assert {:ok, %{status_code: 200, body: body}} = TranslatorRemoteAPI.status(document_id)
      assert {:ok, %{"status" => document_status}} = Poison.decode(body)
      assert document_status in ["processing", "available", "failed"]
    end

    test "geting translated document" do
      submit_doc()
      assert {:ok, %{status_code: 200, body: body}} = TranslatorRemoteAPI.documents()
      assert {:ok, %{"documents" => list_of_documents}} = Poison.decode(body)

      document_id = get_available_status(list_of_documents)

      assert {:ok, %{status_code: 200, body: body}} =
               TranslatorRemoteAPI.translated(document_id)

      assert is_binary(body)
      assert bit_size(body) > 0
    end

    test "delete document" do
      submit_doc()
      assert {:ok, %{status_code: 200, body: body}} = TranslatorRemoteAPI.documents()
      assert {:ok, %{"documents" => list_of_docs}} = Poison.decode(body)
      list_size = length(list_of_docs)
      assert [document | _] = list_of_docs
      assert {:ok, %{body: body}} = TranslatorRemoteAPI.delete(document["document_id"])

      assert {:ok, %{status_code: 200, body: body}} = TranslatorRemoteAPI.documents()
      assert {:ok, %{"documents" => new_list_of_docs}} = Poison.decode(body)
      assert list_size > length(new_list_of_docs)
    end
  end

  defp submit_doc do
    file_path = Path.join([@path, "test/fixtures/sample.txt"])
    true = File.exists?(file_path)
    file_extension = Path.extname(file_path)
    header = Format.get_header(file_extension)
    payload = {:multipart, [{:file, file_path}, {"model_id", "en-es"}, {:header, header}]}
    {:ok, %{status_code: 200}} = TranslatorRemoteAPI.documents(payload)
  end

  defp get_available_status(list_of_documents) do
    list_of_documents
    |> Enum.find(fn map -> map["status"] == "available" end)
    |> Map.get("document_id")
    |> case  do
      "" ->
        Process.sleep(1000)
        get_available_status(list_of_documents)
      document_id ->
        document_id
    end
  end
end
