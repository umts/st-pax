class CreateCommonVerificationSources < ActiveRecord::Migration[5.2]
  def up
    %w[UHS Disability\ Services Accessible\ Workplace].each do |name|
      VerificationSource.create(name: name)
    end
    VerificationSource.create(name: 'Other', needs_contact_info: true)
  end
end
