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
    render :edit, locals: { todo: @todo }
  end

  def create
    @todo = Todo.new(todo_params)

    if @todo.save
      flash.now[:notice] = t('.todo_success')
      render :create, locals: { todo: @todo }
    else
      render :error_create, locals: { todo: @todo }
    end
  end

  def update
    if @todo.update(todo_params)
      flash.now[:notice] = t('.todo_success')
      render :update, locals: { todo: @todo }
    else
      render :error_update, locals: { todo: @todo }
    end
  end

  def destroy
    @id = @todo.id
    @todo.destroy
    render :destroy, locals: { id: @id }
  end

  def toggle
    @todo.done = !@todo.done
    return unless @todo.save

    render :toggle, locals: { todo: @todo }
  end

  private

  def set_todo
    @todo = Todo.find(params[:id])
  end

  def todo_params
    params.require(:todo).permit(:title, :done)
  end
end
