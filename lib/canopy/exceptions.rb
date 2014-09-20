module Canopy
  module Exceptions
    class CanopyException < StandardError
    end

    class NotYetImplementedError < CanopyException; end
    class UnsupportedIdentityAction < CanopyException; end
    class EncryptionError < CanopyException; end
    class SSHAuthenticationError < CanopyException; end
  end
end
