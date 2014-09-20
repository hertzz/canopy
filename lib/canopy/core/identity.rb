module Canopy
  class Identity

    def initialize; end

    def list_all
      return list(identities: :all)
    end

    def create
      printf 'Name> '

      begin
        name = $stdin.gets.chomp.downcase.tr(" ", "-")

        if name.nil? || name.empty?
          raise ArgumentError, "You must specify a name when creating an identity"
        end

        puts "Creating identity \"#{name}\"..."
        printf 'AccessKey> '
        access_key = $stdin.gets.chomp

        if access_key.nil? || access_key.empty?
          raise ArgumentError, 'You must specify an Access Key when creating an identity'
        end

        printf 'SecretKey> '
        secret_key = $stdin.gets.chomp

        if secret_key.nil? || secret_key.empty?
          raise ArgumentError, 'You must specify a Secret Key when creating an identity'
        end

        # Key encryption
        crypto = Canopy::Crypto.new
        crypto.preauth!

        access_key_encrypted = crypto.encrypt(access_key)
        secret_key_encrypted = crypto.encrypt(secret_key)

        key_map = Hash.new
        key_map[:access_key] = access_key_encrypted
        key_map[:secret_key] = secret_key_encrypted

        begin
          # Write serialized object to file
          File.open("#{Canopy.config.identity_store}/#{name}.key", 'w') do |f|
            f.write(key_map.to_s)
          end
        rescue Exception => e
          puts "Failed to add \"#{name}\" keypair to identity store (#{e.message})"
        end

        Canopy.config.add_identity(name)

        puts "Keypair \"#{name}\" was added to identity store!"
      rescue SystemExit, Interrupt
        puts ' (Skipping creation of new identity. Identity has not been saved!)'
      end
    end

    def remove

    end

    def assume(identity)
    end

    private

      def list(args={})
        # All identities
        if args[:identities] == :all
          identities = Canopy.config.all_identities
          if identities.size == 0
            puts 'No identities have been set up yet!'
          else
            identities.each do |i|
              puts i
            end
          end
        else
          raise ArgumentError, "Unsupported identities argument #{args[:identities]}"
        end
      end

  end
end
