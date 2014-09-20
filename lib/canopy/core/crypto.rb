module Canopy
  class Crypto

    attr_accessor :private_key
    attr_accessor :public_key

    attr_accessor :key

    def initialize
      validate_keys
    end

    def preauth!
      begin
        @key = OpenSSL::PKey::RSA.new(File.read(@private_key))
      rescue Exception => e
        raise Canopy::Exceptions::SSHAuthenticationError, "Failed to authenticate against stored SSH key (#{e.message})"
      end
    end

    def encrypt(key_data)
      begin
        return @key.public_encrypt(key_data, OpenSSL::PKey::RSA::PKCS1_OAEP_PADDING)
      rescue Exception => e
        raise Canopy::Exceptions::EncryptionError, "An encryption error has occured (#{e.message})"
      end
    end

    private

      def validate_keys
        @private_key = Canopy.config.ssh_private_key
        @public_key = Canopy.config.ssh_public_key

        if !File.exists?(private_key) || !File.exists?(public_key)
          raise FileNotFoundException, 'Failed to locate public/private keypair set'
        end
      end

  end
end
