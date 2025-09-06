Rails.application.config.to_prepare do
  ActiveRecord::Base.class_eval do
    # Allow all attributes by default except sensitive ones
    def self.ransackable_attributes(auth_object = nil)
      sensitive_fields = %w[
        encrypted_password
        reset_password_token
        password
        password_confirmation
        remember_token
        authentication_token
        token
      ]

      column_names - sensitive_fields
    end

    def self.ransackable_associations(auth_object = nil)
      reflect_on_all_associations.map(&:name).map(&:to_s)
    end
  end
end
