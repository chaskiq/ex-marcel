defmodule ExMarcel.OfficeXmlDetector do
  @moduledoc """
  Detects Microsoft Office Open XML formats (docx, xlsx, pptx) from ZIP archives.

  Office Open XML documents are ZIP archives with specific internal structure:
  - Must contain [Content_Types].xml
  - Word: contains word/document.xml
  - Excel: contains xl/workbook.xml
  - PowerPoint: contains ppt/presentation.xml
  """

  @doc """
  Attempts to detect if a ZIP file is an Office Open XML document.

  Accepts either a file path (binary) or an IO handle (pid).

  Returns:
  - `{:ok, mime_type}` if it's an Office document
  - `:not_office` if it's a regular ZIP or detection fails
  """
  def detect(path_or_io) when is_binary(path_or_io) do
    # File path - use :zip.list_dir
    case :zip.list_dir(String.to_charlist(path_or_io)) do
      {:ok, file_list} ->
        filenames = extract_filenames(file_list)

        case office_document_type(filenames) do
          mime_type when is_binary(mime_type) -> {:ok, mime_type}
          false -> :not_office
        end

      _error ->
        :not_office
    end
  end

  def detect(io) when is_pid(io) do
    # IO handle - read content and use :zip.zip_open with :memory
    case :file.read(io, 1_000_000_000) do
      {:ok, binary} ->
        detect_from_binary(binary)

      _error ->
        :not_office
    end
  end

  defp detect_from_binary(binary) do
    case :zip.zip_open(binary, [:memory]) do
      {:ok, handle} ->
        result = case :zip.zip_list_dir(handle) do
          {:ok, file_list} ->
            filenames = extract_filenames(file_list)

            case office_document_type(filenames) do
              mime_type when is_binary(mime_type) -> {:ok, mime_type}
              false -> :not_office
            end

          _error ->
            :not_office
        end

        :zip.zip_close(handle)
        result

      _error ->
        :not_office
    end
  end

  # Extract filenames from :zip result
  defp extract_filenames(file_list) do
    file_list
    |> Enum.filter(fn
      {:zip_file, _name, _info, _comment, _offset, _comp_size} -> true
      _ -> false
    end)
    |> Enum.map(fn {:zip_file, name, _, _, _, _} -> to_string(name) end)
  end

  # Determine Office document type from file list
  defp office_document_type(files) do
    has_content_types = "[Content_Types].xml" in files

    cond do
      # Must have [Content_Types].xml to be Office Open XML
      not has_content_types ->
        false

      # Word document
      "word/document.xml" in files ->
        "application/vnd.openxmlformats-officedocument.wordprocessingml.document"

      # Excel workbook
      "xl/workbook.xml" in files ->
        "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"

      # PowerPoint presentation
      "ppt/presentation.xml" in files ->
        "application/vnd.openxmlformats-officedocument.presentationml.presentation"

      # It has [Content_Types].xml but isn't a recognized Office format
      # Could be other OOXML formats or just a ZIP with that file
      true ->
        false
    end
  end
end
