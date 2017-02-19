activate :directory_indexes
activate :autoprefixer
activate :sprockets

set :relative_links, true
set :css_dir, "assets/stylesheets"
set :build_dir, 'docs'
set :js_dir, "assets/javascripts"
set :images_dir, "assets/images"
set :fonts_dir, "assets/fonts"
set :layout, "layouts/application"

sprockets.append_path File.join "#{root}", "bower_components"

page '/*.xml', layout: false
page '/*.json', layout: false
page '/*.txt', layout: false

configure :development do
  activate :livereload
end

configure :build do
  activate :relative_assets
end

require 'rbnacl'
require 'securerandom'
require 'json'
require 'base64'


helpers do
  def encrypt_data(data_to_encrypt)
    new_key = false
    key = begin
            Base64.decode64 data.secret
          rescue
            warn "Key not previously set. Generating new one. You'll want to save this in data/secret.json for future use."
            new_key = true
            RbNaCl::Random.random_bytes RbNaCl::SecretBox.key_bytes
          end
    box = RbNaCl::SecretBox.new(key)

    nonce = RbNaCl::Random.random_bytes(box.nonce_bytes)

    if new_key
      puts "Key: #{Base64.strict_encode64(key)}"
    else
      puts 'Using key from data/secret.json'
    end

    encrypted = box.encrypt(nonce, data_to_encrypt.to_json)

    [Base64.strict_encode64(encrypted), Base64.strict_encode64(nonce)].join(';')
  end
end