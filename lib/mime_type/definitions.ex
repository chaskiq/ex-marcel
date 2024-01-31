defmodule ExMarcel.Definitions do
  def run_definitions do
    ExMarcel.MimeType.extend("text/plain", extensions: ["txt", "asc"])
    #
    ExMarcel.MimeType.extend("application/illustrator", parents: "application/pdf")

    ExMarcel.MimeType.extend("image/vnd.adobe.photoshop",
      magic: [[0, ["8BPS"]]],
      extensions: ["psd", "psb"]
    )

    ExMarcel.MimeType.extend("application/vnd.ms-excel", parents: "application/x-ole-storage")

    ExMarcel.MimeType.extend("application/vnd.ms-powerpoint",
      parents: "application/x-ole-storage"
    )

    ExMarcel.MimeType.extend(
      "application/vnd.openxmlformats-officedocument.wordprocessingml.document",
      parents: "application/zip"
    )

    ExMarcel.MimeType.extend(
      "application/vnd.openxmlformats-officedocument.wordprocessingml.template",
      parents: "application/vnd.openxmlformats-officedocument.wordprocessingml.document"
    )

    ExMarcel.MimeType.extend("application/vnd.ms-word.document.macroenabled.12",
      parents: "application/vnd.openxmlformats-officedocument.wordprocessingml.document"
    )

    ExMarcel.MimeType.extend("application/vnd.ms-word.template.macroenabled.12",
      parents: "application/vnd.openxmlformats-officedocument.wordprocessingml.document"
    )

    ExMarcel.MimeType.extend("application/vnd.openxmlformats-officedocument.spreadsheetml.sheet",
      parents: "application/zip"
    )

    ExMarcel.MimeType.extend(
      "application/vnd.openxmlformats-officedocument.spreadsheetml.template",
      parents: "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"
    )

    ExMarcel.MimeType.extend("application/vnd.ms-excel.sheet.macroenabled.12",
      parents: "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"
    )

    ExMarcel.MimeType.extend("application/vnd.ms-excel.template.macroenabled.12",
      parents: "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"
    )

    ExMarcel.MimeType.extend("application/vnd.ms-excel.addin.macroenabled.12",
      parents: "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"
    )

    ExMarcel.MimeType.extend("application/vnd.ms-excel.sheet.binary.macroenabled.12",
      parents: "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"
    )

    ExMarcel.MimeType.extend(
      "application/vnd.openxmlformats-officedocument.presentationml.presentation",
      parents: "application/zip"
    )

    ExMarcel.MimeType.extend(
      "application/vnd.openxmlformats-officedocument.presentationml.template",
      parents: "application/vnd.openxmlformats-officedocument.presentationml.presentation"
    )

    ExMarcel.MimeType.extend(
      "application/vnd.openxmlformats-officedocument.presentationml.slideshow",
      parents: "application/vnd.openxmlformats-officedocument.presentationml.presentation"
    )

    ExMarcel.MimeType.extend("application/vnd.ms-powerpoint.addin.macroenabled.12",
      parents: "application/vnd.openxmlformats-officedocument.presentationml.presentation"
    )

    ExMarcel.MimeType.extend("application/vnd.ms-powerpoint.presentation.macroenabled.12",
      parents: "application/vnd.openxmlformats-officedocument.presentationml.presentation"
    )

    ExMarcel.MimeType.extend("application/vnd.ms-powerpoint.template.macroenabled.12",
      parents: "application/vnd.openxmlformats-officedocument.presentationml.presentation"
    )

    ExMarcel.MimeType.extend("application/vnd.ms-powerpoint.slideshow.macroenabled.12",
      parents: "application/vnd.openxmlformats-officedocument.presentationml.presentation"
    )

    ExMarcel.MimeType.extend("application/vnd.apple.pages",
      extensions: ["pages"],
      parents: "application/zip"
    )

    ExMarcel.MimeType.extend("application/vnd.apple.numbers",
      extensions: ["numbers"],
      parents: "application/zip"
    )

    ExMarcel.MimeType.extend("application/vnd.apple.keynote",
      extensions: ["key"],
      parents: "application/zip"
    )

    ExMarcel.MimeType.extend("audio/aac", extensions: ["aac"], parents: "audio/x-aac")

    ExMarcel.MimeType.extend("audio/ogg",
      extensions: ["ogg", "oga"],
      magic: [[0, ["OggS"], [[29, ["vorbis"]]]]]
    )

    ExMarcel.MimeType.extend("image/vnd.dwg", magic: [[0, ["AC10"]]])

    ExMarcel.MimeType.extend("application/x-x509-ca-cert",
      magic: [[0, ["-----BEGIN CERTIFICATE-----"]]],
      extensions: ["pem"],
      parents: "application/x-x509-cert;format=pem"
    )

    ExMarcel.MimeType.extend("image/avif", magic: [[4, ["ftypavif"]]], extensions: ["avif"])
    ExMarcel.MimeType.extend("image/heif", magic: [[4, ["ftypmif1"]]], extensions: ["heif"])
    ExMarcel.MimeType.extend("image/heic", magic: [[4, ["ftypheic"]]], extensions: ["heic"])

    ExMarcel.MimeType.extend("video/mp4",
      magic: [[4, ["ftypisom"]], [4, ["ftypM4V "]]],
      extensions: ["mp4", "m4v"]
    )

    ExMarcel.MimeType.extend("audio/flac",
      magic: [[0, ["fLaC"]]],
      extensions: ["flac"],
      parents: "audio/x-flac"
    )

    ExMarcel.MimeType.extend("audio/x-wav",
      magic: [[0, ["RIFF"], [[8, ["WAVE"]]]]],
      extensions: ["wav"],
      parents: "audio/vnd.wav"
    )

    ExMarcel.MimeType.extend("audio/mpc", magic: [[0, ["MPCKSH"]]], extensions: ["mpc"])

    ExMarcel.MimeType.extend("font/ttf",
      magic: [[0, ["\x00\x01\x00\x00"]]],
      extensions: ["ttf", "ttc"]
    )

    ExMarcel.MimeType.extend("font/otf",
      magic: [[0, ["OTTO"]]],
      extensions: ["otf"],
      parents: "font/ttf"
    )

    ExMarcel.MimeType.extend("application/vnd.adobe.flash.movie",
      magic: [[0, ["FWS"]], [0, ["CWS"]]],
      extensions: ["swf"]
    )

    ExMarcel.MimeType.extend("application/sql", extensions: ["sql"])

    ExMarcel.MimeType.extend("text/vcard",
      magic: [[0, ["BEGIN:VCARD"]]],
      extensions: ["vcf"],
      parents: "text/plain"
    )

    ExMarcel.MimeType.extend(
      "application/vnd.ms-access",
      extensions: ["mdb", "mde", "accdb", "accde"],
      magic: [
        # "\x00\x01\x00Standard Jet DB"
        [0, ["\x00\x01\x00\x00\x53\x74\x61\x6e\x64\x61\x72\x64\x20\x4a\x65\x74\x20\x44\x42"]],
        # "\x00\x01\x00Standard ACE DB"
        [0, ["\x00\x01\x00\x00\x53\x74\x61\x6e\x64\x61\x72\x64\x20\x41\x43\x45\x20\x44\x42"]]
      ],
      parents: "application/x-msaccess"
    )

    ExMarcel.MimeType.extend("text/markdown",
      extensions: ["md", "mdtext", "markdown", "mkd"],
      parents: "text/x-web-markdown"
    )
  end
end
