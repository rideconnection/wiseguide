class AddAttachmentAttachmentToAssessmentRequest < ActiveRecord::Migration
  def self.up
    add_column :assessment_requests, :attachment_file_name, :string
    add_column :assessment_requests, :attachment_content_type, :string
    add_column :assessment_requests, :attachment_file_size, :integer
    add_column :assessment_requests, :attachment_updated_at, :datetime
  end

  def self.down
    remove_column :assessment_requests, :attachment_file_name
    remove_column :assessment_requests, :attachment_content_type
    remove_column :assessment_requests, :attachment_file_size
    remove_column :assessment_requests, :attachment_updated_at
  end
end
