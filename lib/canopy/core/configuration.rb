module Canopy
  class Configuration

    attr_accessor :config
    attr_accessor :application_root
    attr_accessor :identity_store

    attr_accessor :content

    def initialize(config_file = nil)
      self.application_root = "#{ENV['HOME']}/.canopy"
      self.identity_store = "#{application_root}/identities"
      self.config = config_file || application_root + "/config.yml"

      validate!
    end

    def ssh_private_key=(file)
      set_key(type: :private, keyfile: file)
    end

    def ssh_private_key
      return get_key(type: :private)
    end

    def ssh_public_key=(file)
      set_key(type: :public, keyfile: file)
    end

    def ssh_public_key
      return get_key(type: :public)
    end

    def get_identity(identity)

    end

    def add_identity(name)
      load_yaml_data

      begin
        if @content['identities']['objects'] == nil
          @content['identities']['objects'] = []
        end

        @content['identities']['objects'] << name

        File.open(@config, 'w') do |f|
          f.write(@content.to_yaml)
        end
      rescue Exception => e
        raise e, "Failed to add \"#{name}\" keypair to identity store (#{e.message})"
      end
    end

    def remove_identity(identity)

    end

    def all_identities
      load_yaml_data
      return @content['identities']['objects']
    end

    def init!
      validate!
    end

    def reset!
      begin
        File.delete(@config)
        validate!
      rescue Exception => e
        raise e, 'Failed to reset Canopy configuration properties'
      end
    end

    private

      def load_yaml_data
        begin
          @content = YAML.load_file(@config)
        rescue Exception => e
          raise LoadError, "Failed to load Canopy configuration file (#{e.message})"
        end
      end

      def set_key(hash = {})
        if hash[:keyfile].nil?
          raise ArgumentError, 'No keyfile was specified'
        end

        load_yaml_data

        case hash[:type]
        when :private
          begin
            @content['crypto']['ssh']['private'] = hash[:keyfile]
            File.open(@config, 'w') do |f|
              f.write(@content.to_yaml)
            end
          rescue Exception => e
            raise e, 'Failed to change stored private key'
          end
        when :public
          begin
            @content['crypto']['ssh']['public'] = hash[:keyfile]
            File.open(@config, 'w') do |f|
              f.write(@content.to_yaml)
            end
          rescue Exception => e
            raise e, 'Failed to change stored public key'
          end
        end
      end

      def get_key(hash = {})
        load_yaml_data
        return(@content['crypto']['ssh'][hash[:type].to_s])
      end

      def validate!
        if !Dir.exist?(@application_root)
          begin
            Dir.mkdir(@application_root)
          rescue Exception => e
            raise e, "Failed to create Canopy application directory (#{e.message})"
          end
        end

        if !Dir.exist?(@identity_store)
          begin
            Dir.mkdir(@identity_store)
          rescue Exception => e
            raise e, "Failed to create Canopy identity store (#{e.message})"
          end
        end

        if !File.exist?(@config)
          begin
            new_content = <<-EOS.unindent
              ---
              crypto:
                ssh:
                  private: "#{ENV['HOME']}/.ssh/id_rsa"
                  public: "#{ENV['HOME']}/.ssh/id_rsa.pub"
              identities:
                store: "#{@identity_store}"
                objects:
            EOS

            File.open(@config, "w") do |f|
              f.write(new_content)
            end

            # Force reload YAML data
            load_yaml_data
          rescue Exception => e
            raise e, "Failed to initialize Canopy configuration file (#{@config})"
          end
        end
      end

  end
end
