module InheritUpload

  extend ActiveSupport::Concern

  included do
    after_save :delete_inherited_upload
  end


  def inherit_upload_id
    @upload && @upload.id
  end


  def inherit_upload_id=(id)
    if @upload = Upload.find_by_id(id)
      self.image_uid = @upload.image_uid
    end
  end


  private
    def delete_inherited_upload
      @upload.delete if @upload
    end
end