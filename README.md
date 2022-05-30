# ExMarcel

## An Elixir port of Rails's Marcel Mimetype detector.

[![.github/workflows/ci.yml](https://github.com/chaskiq/ex-marcel/actions/workflows/ci.yml/badge.svg)](https://github.com/chaskiq/ex-marcel/actions/workflows/ci.yml)

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `ex_marcel` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:ex_marcel, "~> 0.1.0"}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/ex_marcel](https://hexdocs.pm/ex_marcel).

----

Marcel attempts to choose the most appropriate content type for a given file by looking at the binary data, the filename, and any declared type (perhaps passed as a request header). This is done via the `ExMarcel.MimeType.for` method, and is used like this:

```elixir
ExMarcel.MimeType.for "example.gif"
#  => "image/gif"

file = File.open "example.gif"
ExMarcel.MimeType.for file

#  => "image/gif"

ExMarcel.MimeType.for "unrecognisable-data", name: "example.pdf"
#  => "application/pdf"

ExMarcel.MimeType.for nil, extension: ".pdf"
#  => "application/pdf"

ExMarcel.MimeType.for "unrecognisable-data", name: "example", declared_type: "image/png"
#  => "image/png"

ExMarcel.MimeType.for StringIO.new(File.read "unrecognisable-data")
#  => "application/octet-stream"
```

By preference, the magic number data in any passed in file is used to determine the type. If this doesn't work, it uses the type gleaned from the filename, extension, and finally the declared type. If no valid type is found in any of these, "application/octet-stream" is returned.

Some types aren't easily recognised solely by magic number data. For example Adobe Illustrator files have the same magic number as PDFs (and can usually even be viewed in PDF viewers!). For these types, Marcel uses both the magic number data and the file name to work out the type:

```elixir
ExMarcel.MimeType.for "example.ai", name: "example.ai"
#  => "application/illustrator"
```

This only happens when the type from the filename is a more specific type of that from the magic number. If it isn't the magic number alone is used.

```elixir
ExMarcel.MimeType.for "example.png", name: "example.ai"
#  => "image/png"
# As "application/illustrator" is not a more specific type of "image/png", the filename is ignored
```

## Motivation

ExMarcel is a Port from Rails's Marcel gem, we need a complete solution for mime detection on Elixir land and this is it.

Marcel was extracted from Basecamp 3, in order to make our file detection logic both easily reusable but more importantly, easily testable. Test fixtures have been added for all of the most common file types uploaded to Basecamp, and other common file types too. We hope to expand this test coverage with other file types as and when problems are identified.

## Contributing

Marcel generates MIME lookup tables with `bundle exec rake tables_ex`. MIME types are seeded from data found in `data/*.xml`. Custom MIMEs may be added to `data/custom.xml`, while overrides to the standard MIME database may be added to `lib/mime_type/definitions.rb`.

> The code used for generating this files is a slightly modified version of the ruby rake task, so you will need ruby for this, to run it do:

 > bundle install
 > bundle exec rake tables_ex

## Testing

The main test fixture files are split into two folders, those that can be recognised by magic numbers, and those that can only be recognised by name. Even though strictly unnecessary, the fixtures in both folders should all be valid files of the type they represent.

## License

ExMarcel itself is released under the terms of the MIT License. See the MIT-LICENSE file for details.

Portions of Marcel (Ruby) are adapted from the [mimemagic] gem, released under the terms of the MIT License.

Marcel's magic signature data is adapted from [Apache Tika](https://tika.apache.org), released under the terms of the Apache License. See the APACHE-LICENSE file for details.

[mimemagic]: https://github.com/mimemagicrb/mimemagic


