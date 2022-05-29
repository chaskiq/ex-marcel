
desc "Generate data tables elixir"
task tables_ex: "lib/tables.ex"
file "lib/tables.ex" => %w[ data/tika.xml data/custom.xml ] do |target|
  exec "script/generate_tables_ex.rb", *target.prerequisites, out: target.name
end
