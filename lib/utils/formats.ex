defmodule Utils.Formats do
  # 20 MB
  @size_limit 20_000_000

  # MIME suport
  @extension %{
    ".json" => "application/json",
    "application/powerpoint" => "application/powerpoint",
    "application/mspowerpoint" => "application/mspowerpoint",
    "application/x-rtf" => "application/x-rtf",
    ".xml" => "application/xml",
    ".xlsx" => "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet",
    ".xls" => "application/vnd.ms-excel",
    ".xlt" => "application/vnd.ms-excel",
    ".xla" => "application/vnd.ms-excel",
    ".ppt" => "application/vnd.ms-powerpoint",
    ".pot" => "application/vnd.ms-powerpoint",
    ".pps" => "application/vnd.ms-powerpoint",
    ".ppa" => "application/vnd.ms-powerpoint",
    ".pptx" => "application/vnd.openxmlformats-officedocument.presentationml.presentation",
    ".doc" => "application/msword",
    ".dot" => "application/msword",
    ".docx" => "application/vnd.openxmlformats-officedocument.wordprocessingml.document",
    ".ods" => "application/vnd.oasis.opendocument.spreadsheet",
    ".odp" => "application/vnd.oasis.opendocument.presentation",
    ".odt" => "application/vnd.oasis.opendocument.text",
    ".pdf" => "application/pdf",
    ".rtf" => "application/rtf",
    ".html" => "text/html",
    "text/json" => "text/json",
    ".txt" => "text/plain",
    "text/richtext" => "text/richtext",
    "text/rtf" => "text/rtf",
    "text/xml" => "text/xml"
  }

  def size_limit, do: @size_limit

  def get_header, do: "application/json"

  def get_header(extension), do: Map.get(@extension, extension)
end
