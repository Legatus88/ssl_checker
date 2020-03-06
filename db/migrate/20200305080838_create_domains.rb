class CreateDomains < ActiveRecord::Migration[6.0]
  def change
    create_table :domains do |t|
      t.string :url, index: { unique: true }
      t.string :aasm_state

      t.timestamps
    end
  end
end
