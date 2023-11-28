# frozen_string_literal: true

class PatchNotesController < ApplicationController
  def index; end

  def boom
    Rails.logger.info(params)
    Rails.logger.info('hello')
    # raw(File.read("./app/views/patch_notes/#{test}"))
  end
end
