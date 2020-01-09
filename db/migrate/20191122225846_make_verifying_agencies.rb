class MakeVerifyingAgencies < ActiveRecord::Migration[5.2]
  def up
    ['UHS', 'Disability Services', 'Accessible Workplace'].each do |name|
      VerifyingAgency.create(name: name)
    end
    ['Physician', 'Other'].each do |name|
      VerifyingAgency.create(name: name, needs_contact_info: true)
    end
  end
  def down
    VerifyingAgency.destroy_all
  end
end
