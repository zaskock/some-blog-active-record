class CreateComments < ActiveRecord::Migration
	def change
		create_table :contacts do |t|
			t.text :author
			t.text :content
			t.integer :post_id
			t.timestamps
		end
	end
end

 