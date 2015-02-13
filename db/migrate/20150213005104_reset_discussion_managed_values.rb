class ResetDiscussionManagedValues < ActiveRecord::Migration
  def change
    Discussion.reset_column_information
    progress_bar = ProgressBar.create( format: "(\e[32m%c/%C\e[0m) %a |%B| \e[31m%e\e[0m ",
                                       progress_mark: "\e[32m/\e[0m",
                                       total: Discussion.count )
    Discussion.order('id desc').find_each do |d|
      d.reset_managed_values!
      progress_bar.increment
    end
  end
end
