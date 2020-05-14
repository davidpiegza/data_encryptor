# frozen_string_literal: true

require 'base64'
require 'json'
require 'openssl'

require 'data_encryptor/version'

module DataEncryptor
  def self.setup!(key:, algorithm: 'AES-256-CBC')
    @options = { key: key, algorithm: algorithm }
  end

  def self.encrypt(data)
    raise ArgumentError, 'must specify a key' if @options[:key].to_s.empty?

    cipher = new_cipher
    iv = cipher.random_iv

    decrypted = cipher.update(JSON.dump(data))
    decrypted << cipher.final
    "#{::Base64.strict_encode64(decrypted)}--#{::Base64.strict_encode64(iv)}"
  end

  def self.decrypt(encrypted_data)
    raise ArgumentError, 'must specify a key' if @options[:key].to_s.empty?

    encrypted_data, iv = encrypted_data.split('--').map { |v| ::Base64.strict_decode64(v) }

    raise ArgumentError, 'encrypted data has invalid format' unless encrypted_data && iv

    cipher = new_cipher(method: :decrypt)
    cipher.iv = iv

    decrypted_data = cipher.update(encrypted_data)
    decrypted_data << cipher.final

    JSON.parse(decrypted_data)
  end

  private_class_method def self.new_cipher(method: :encrypt)
    cipher = OpenSSL::Cipher.new(@options.fetch(:algorithm)).public_send(method)
    cipher.key = Digest::SHA256.digest @options.fetch(:key)
    cipher
  end
end
