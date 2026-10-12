#!/usr/bin/env ruby
require 'yaml'
require 'net/http'
require 'json'
require 'uri'
require 'openssl'

VAULT_PATH = File.expand_path("~/obsidian-vault/2-Areas/Musique-Irlandaise/TradCRM/concert-venues/")

if ARGV.include?("-h") || ARGV.include?("--help")
  puts "Usage: #{File.basename($0)} [options]"
  puts ""
  puts "Geocodes Obsidian notes with address frontmatter and sets icon/color based on type."
  puts ""
  puts "Options:"
  puts "  -f, --force    Force reprocess all notes (re-geocode even if coordinates exist)"
  puts "  -h, --help     Show this help message"
  puts ""
  puts "Vault path: #{VAULT_PATH}"
  exit 0
end

FORCE_REPROCESS = ARGV.include?("--force") || ARGV.include?("-f")

# Type -> icon/color mapping (Lucide icons)
TYPE_MAPPING = {
  # Music & Entertainment
  "venue"           => { icon: "music", color: "purple" },
  "concert hall"    => { icon: "music-2", color: "purple" },
  "festival"        => { icon: "tent", color: "orange" },
  "club"            => { icon: "disc-3", color: "pink" },
  
  # Food & Drink
  "restaurant"      => { icon: "utensils", color: "orange" },
  "café"            => { icon: "coffee", color: "brown" },
  "cafe"            => { icon: "coffee", color: "brown" },
  "bar"             => { icon: "beer", color: "amber" },
  "pub"             => { icon: "beer", color: "amber" },
  
  # Culture
  "museum"          => { icon: "landmark", color: "blue" },
  "theater"         => { icon: "drama", color: "red" },
  "theatre"         => { icon: "drama", color: "red" },
  "gallery"         => { icon: "image", color: "cyan" },
  "cultural center" => { icon: "building-2", color: "teal" },
  "library"         => { icon: "library", color: "slate" },
  
  # Spaces
  "park"            => { icon: "trees", color: "green" },
  "church"          => { icon: "church", color: "stone" },
  "community"       => { icon: "users", color: "blue" },
  "school"          => { icon: "graduation-cap", color: "indigo" },
  
  # Business
  "shop"            => { icon: "store", color: "emerald" },
  "office"          => { icon: "building", color: "gray" },
  "hotel"           => { icon: "bed", color: "violet" },
}

DEFAULT_ICON = "map-pin"
DEFAULT_COLOR = "blue"

def geocode(address)
  uri = URI("https://nominatim.openstreetmap.org/search")
  uri.query = URI.encode_www_form(format: "json", q: address)
  
  request = Net::HTTP::Get.new(uri)
  request["User-Agent"] = "ObsidianGeocoder/1.0"
  
  response = Net::HTTP.start(uri.hostname, uri.port, use_ssl: true, verify_mode: OpenSSL::SSL::VERIFY_NONE) do |http|
    http.request(request)
  end
  
  data = JSON.parse(response.body)
  return nil if data.empty?
  
  [data[0]["lat"], data[0]["lon"]]
end

def build_address(frontmatter)
  parts = [
    frontmatter["address"] || frontmatter["adresse"],
    frontmatter["post-code"] || frontmatter["postcode"] || frontmatter["zip"],
    frontmatter["city"] || frontmatter["ville"],
    frontmatter["country"] || frontmatter["pays"]
  ].compact.reject { |p| p.to_s.empty? }
  
  return nil if parts.empty?
  parts.join(", ")
end

def extract_type(type_value)
  return nil unless type_value
  
  if type_value.is_a?(String) && type_value.match(/\[\[([^\]|]+)/)
    $1.strip.downcase
  elsif type_value.is_a?(String)
    type_value.strip.downcase
  else
    nil
  end
end

def find_type_match(type_name)
  return nil unless type_name
  
  return TYPE_MAPPING[type_name] if TYPE_MAPPING[type_name]
  
  TYPE_MAPPING.each do |key, value|
    return value if type_name.include?(key) || key.include?(type_name)
  end
  
  nil
end

def process_note(filepath)
  content = File.read(filepath)
  
  return unless content.match?(/\A---\n/)
  
  parts = content.split("---\n", 3)
  return if parts.length < 3
  
  frontmatter = YAML.safe_load(parts[1], permitted_classes: [Date, Time])
  return unless frontmatter.is_a?(Hash)
  
  updated = false
  
  # Geocode if we have address but no coordinates (or force reprocess)
  full_address = build_address(frontmatter)
  if full_address && (!frontmatter["coordinates"] || FORCE_REPROCESS)
    coords = geocode(full_address)
    if coords
      frontmatter["coordinates"] = coords
      updated = true
      puts "  📍 Geocoded '#{full_address}': #{coords.join(', ')}"
    else
      puts "  ⚠️  Could not geocode: #{full_address}"
    end
    sleep 1
  end
  
  # Set icon/color based on type
  type_name = extract_type(frontmatter["type"])
  type_def = find_type_match(type_name) || { icon: DEFAULT_ICON, color: DEFAULT_COLOR }
  
  if frontmatter["icon"] != type_def[:icon]
    frontmatter["icon"] = type_def[:icon]
    updated = true
  end
  
  if frontmatter["color"] != type_def[:color]
    frontmatter["color"] = type_def[:color]
    updated = true
  end
  
  return unless updated
  
  new_content = "---\n#{frontmatter.to_yaml.sub(/\A---\n/, "")}---\n#{parts[2]}"
  File.write(filepath, new_content)
  
  puts "  ✓ icon: #{frontmatter['icon']}, color: #{frontmatter['color']}"
end

# Main
notes_path = VAULT_PATH
unless Dir.exist?(notes_path)
  puts "❌ Folder not found: #{notes_path}"
  exit 1
end

puts "Processing #{VAULT_PATH}..."
puts "🔄 Force reprocess: #{FORCE_REPROCESS}\n\n"

Dir.glob(File.join(notes_path, "**/*.md")).each do |filepath|
  puts "📄 #{File.basename(filepath)}"
  process_note(filepath)
end

puts "\n✅ Done!"
