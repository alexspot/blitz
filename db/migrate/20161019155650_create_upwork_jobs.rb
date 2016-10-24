class CreateUpworkJobs < ActiveRecord::Migration
  def change
    create_table :upwork_jobs do |t|

      t.timestamps null: false
    end
  end
end
