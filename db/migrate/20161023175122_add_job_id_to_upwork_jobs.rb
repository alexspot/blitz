class AddJobIdToUpworkJobs < ActiveRecord::Migration
  def change
    add_column :upwork_jobs, :job_id, :string
  end
end
