# frozen_string_literal: true

class PatchNotesController < ApplicationController
  def index; end

  def patch_note
    file_check = false

    Dir.children('./app/views/patch_notes/').sort { |a, b| b <=> a }.each do |patch_note|
      file_check = true if patch_note.include? params[:name].gsub('.', '_')
    end

    not_found unless file_check

    render params[:name].gsub('.', '_') and return
  end
end
