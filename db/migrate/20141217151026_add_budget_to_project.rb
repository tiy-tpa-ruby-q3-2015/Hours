class AddbudgetToProject < ActiveRecord::Migration
  def change
    add_column :projects, :budget, :int
  end
end
