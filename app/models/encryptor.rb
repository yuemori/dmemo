class Encryptor
  SECURE = (ENV['SECRET_KEY_BASE'] || YAML.load_file(Rails.root.join('config', 'secrets.yml'))[Rails.env]['secret_key_base']).freeze
  CIPHER = 'aes-256-cbc'

  class << self
    def encrypt(string)
      crypt.encrypt_and_sign(string)
    end

    def decrypt(string)
      crypt.decrypt_and_verify(string)
    end

    private

    def crypt
      @crypt ||= ActiveSupport::MessageEncryptor.new(SECURE, CIPHER)
    end
  end
end
