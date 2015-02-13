class AddLastSequenceIdToDiscussions < ActiveRecord::Migration
  def change
    add_column :discussions, :last_sequence_id, :integer, default: 0, null: false
    add_column :discussions, :first_sequence_id, :integer, default: 0, null: false
    add_column :discussion_readers, :last_read_sequence_id, :integer, default: 0, null: false
  end
end
