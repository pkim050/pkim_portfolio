# frozen_string_literal: true

class TodosController < ApplicationController
  before_action :set_todo, only: %i[show edit update destroy toggle]

  def index
    @todo = Todo.new
    @todos = Todo.all.sort
    respond_to do |format|
      format.html { render :index, locals: { todos: @todos, todo: @todo } }
    end
  end

  def show
    render :show, locals: { todo: @todo }
  end

  def edit
    Rails.logger.info(params)
    render :edit, locals: { todo: @todo }
  end

  def create
    @todo = Todo.new(todo_params)

    if @todo.save
      Rails.logger.info('Very nice on the create!')
      render :create, locals: { todo: @todo }
    else
      Rails.logger.info('Not very nice on the create!')
    end
    Rails.logger.info(todo_params)
  end

  def update
    if @todo.update(todo_params)
      Rails.logger.info('Very nice on the update!')
      render :update, locals: { todo: @todo }
    else
      Rails.logger.info('Not very nice on the update!')
    end
    Rails.logger.info(todo_params)
  end

  def destroy
    @id = @todo.id
    @todo.destroy
    render :destroy, locals: { id: @id }
  end

  def toggle
    @todo.done = !@todo.done
    if @todo.save
      Rails.logger.info('Very nice on the toggle!')
      render :toggle, locals: { todo: @todo }
    else
      Rails.logger.info('Not very nice on the toggle!')
    end
  end

  private

  def set_todo
    @todo = Todo.find(params[:id])
  end

  def todo_params
    params.require(:todo).permit(:title, :done)
  end
end
