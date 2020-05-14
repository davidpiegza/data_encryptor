# frozen_string_literal: true

require 'test_helper'

class DataEncryptorTest < Minitest::Test
  def setup
    DataEncryptor.setup! key: 'test_key'
  end

  def test_should_have_a_version_number
    refute_nil ::DataEncryptor::VERSION
  end

  def test_should_have_a_default_algorithm
    assert_equal 'AES-256-CBC', DataEncryptor.setup!(key: 'test_key').fetch(:algorithm)
  end

  def test_should_set_key_and_algorithm
    assert_equal({ key: 'test_key', algorithm: 'AES-256-GCM' }, DataEncryptor.setup!(key: 'test_key', algorithm: 'AES-256-GCM'))
  end

  def test_should_encrypt_data
    assert_match(/\A.*--.*\z/, DataEncryptor.encrypt('secret'))
  end

  def test_should_decrypt_data
    assert_equal 'secret', DataEncryptor.decrypt(DataEncryptor.encrypt('secret'))
  end

  def test_encrypt_should_raise_error_when_missing_key
    DataEncryptor.setup! key: nil
    error = assert_raises(ArgumentError) { DataEncryptor.encrypt('secret') }
    assert_equal 'must specify a key', error.message
  end

  def test_decrypt_should_raise_error_when_missing_key
    DataEncryptor.setup! key: nil
    error = assert_raises(ArgumentError) { DataEncryptor.decrypt('dGVzdA==--aXY=') }
    assert_equal 'must specify a key', error.message
  end

  def test_decrypt_should_raise_error_on_invalid_data
    error = assert_raises(ArgumentError) { DataEncryptor.decrypt('dGVzdA==') }
    assert_equal 'encrypted data has invalid format', error.message
  end
end
