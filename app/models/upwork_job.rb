class UpworkJob < ActiveRecord::Base
  validates :job_id, presence: true

  def self.is_job_new?(job_cihper)
    UpworkJob.find_by(job_id: job_cihper) ? false : true
  end
end
