# frozen_string_literal: true

require 'fileutils'

class PagesController < ApplicationController
  def home; end

  def about; end

  def projects; end

  def upload_resume_page; end

  def upload_resume
    redirect_to upload_resume_path && return if params[:file_upload].nil?

    tmp = params[:file_upload][:file]

    extension_check(tmp)

    redirect_to upload_resume_path
  end

  private

  def extension_check(tmp)
    if tmp.original_filename.split('.').last.include? 'pdf'
      file = Rails.public_path.join(tmp.original_filename)
      file_check(tmp.original_filename)
      FileUtils.cp tmp.tempfile.path, file
      flash[:notice] = "File #{tmp.original_filename} has successfully uploaded."
    else
      flash[:error] = ["File #{tmp.original_filename} is not a pdf file, please try again."]
    end
  end

  def file_check(tmp)
    return unless tmp.include? 'resume'

    Rails.public_path.children.select { |file| file.extname == '.pdf' }.each do |file|
      Rails.public_path.join(file.basename.to_s).delete
    end
  end
end
