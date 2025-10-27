## [0.2.0] - 2025-10-25

### Added

- **SVG detection fix for files with XML declarations**
  - Fixed pattern matching order bug where SVG files with `<?xml` declarations were incorrectly detected as `application/xml`
  - Added SVG range pattern early in magic table to check for `<svg` tag anywhere in first 4KB
  - Now correctly detects all SVG variants including those with XML declarations, comments, DOCTYPE declarations, etc.

- **Updated tika.xml to September 2025 version**
  - Synced with Ruby Marcel's latest tika.xml (1100+ new MIME type definitions)
  - Updated JavaScript MIME type from `application/javascript` to standard `text/javascript`
  - Improved detection accuracy across hundreds of file formats

- **OLE2 Word document detection improvements**
  - Expanded WordDocument signature search range from 1152-4096 bytes to 0-10MB
  - Fixed range offset handling to properly skip to `offset.first` before reading
  - Now correctly detects old Microsoft Word .DOC files with variable directory entry locations

- **Development tooling and quality improvements**
  - Added `.tool-versions` for asdf version management (Elixir 1.19.0, OTP 28.1)
  - Added `.formatter.exs` with Quokka plugin for enhanced code formatting
  - Added `.editorconfig` for consistent editor configuration
  - Added `.credo.exs` for comprehensive linting rules
  - Added comprehensive GitHub Actions CI workflow
    - Matrix builds across Elixir 1.14-1.19 and OTP 25-28
    - Warnings as errors enforcement
    - Format checking, Credo strict mode, and Dialyzer on latest versions
  - Modernized `mix.exs` with proper docs, coverage, and packaging configuration

### Changed

- **Breaking**: JavaScript files now return `text/javascript` instead of `application/javascript`
  - This aligns with the IANA standard MIME type for JavaScript
  - Updated test fixtures to reflect correct MIME type
- Updated minimum Elixir requirement to ~> 1.14
- Fixed negative step warning in `String.slice(1..-1)` → `String.slice(1..-1//1)`
- Removed invalid test fixture `xml.xml` from SVG fixtures (plain XML, not SVG)

### Fixed

- Pattern matching order bug where generic XML patterns matched before specific SVG patterns
- Range offset handling in magic byte matching (now properly skips to start offset)
- Test fixture organization (removed duplicate/incorrect fixtures)

---

## [0.1.0] - 2022-XX-XX

### Initial Release

Fork of the original chaskiq/ex-marcel package, which was itself a port of Rails Marcel to Elixir.

- MIME type detection by file extension
- MIME type detection by magic bytes (file content analysis)
- Support for combined extension + magic byte detection
- Based on Apache Tika magic database
