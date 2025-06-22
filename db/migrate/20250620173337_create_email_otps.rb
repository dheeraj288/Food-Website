class CreateEmailOtps < ActiveRecord::Migration[7.1]
  def change
    create_table :email_otps do |t|
      t.references :user, null: false, foreign_key: true
      t.string :otp_code
      t.boolean :verified
      t.datetime :expires_at

      t.timestamps
    end
  end
end
