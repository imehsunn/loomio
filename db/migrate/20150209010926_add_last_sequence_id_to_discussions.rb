class AddLastSequenceIdToDiscussions < ActiveRecord::Migration
  def change
    add_column :discussions, :last_sequence_id, :integer, default: 0, null: false
    add_column :discussions, :first_sequence_id, :integer, default: 0, null: false
    Discussion.reset_column_information
    progress_bar = ProgressBar.create( format: "(\e[32m%c/%C\e[0m) %a |%B| \e[31m%e\e[0m ",
                                       progress_mark: "\e[32m/\e[0m",
                                       total: Discussion.count )
    Discussion.find_each do |d|
      d.reset_last_sequence_id!
      d.reset_first_sequence_id!
      progress_bar.increment
    end
  end
end
