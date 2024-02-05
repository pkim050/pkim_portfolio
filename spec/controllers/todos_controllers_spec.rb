# frozen_string_literal: true

require 'rails_helper'

RSpec.describe TodosController do
  describe 'routes' do
    it { is_expected.to route(:get, '/roaming_hunger').to(action: :index) }
    it { is_expected.to route(:get, '/roaming_hunger/1/edit').to(action: :edit, id: 1) }
    it { is_expected.to route(:post, '/roaming_hunger').to(action: :create) }
    it { is_expected.to route(:patch, '/roaming_hunger/1').to(action: :update, id: 1) }
    it { is_expected.to route(:delete, '/roaming_hunger/1').to(action: :destroy, id: 1) }
    it { is_expected.to route(:get, '/roaming_hunger/1/toggle').to(action: :toggle, id: 1) }
  end

  describe 'GET #index' do
    let(:todos) { Todo.order('created_at desc') }

    before do
      todos
      get :index
    end

    it 'renders index page' do
      expect(response).to render_template(:index)
    end

    it 'returns 200 status code' do
      expect(response).to have_http_status(:ok)
    end
  end

  describe 'GET #show' do
    let(:todo) { Todo.create(title: 'hi', done: false) }

    it { is_expected.to use_before_action(:set_todo) }

    it 'raises exception' do
      expect do
        get :show,
            as: :turbo_stream,
            params: { id: todo.id }
      end.to raise_error(ActionView::MissingTemplate)
    end
  end

  describe 'GET #edit' do
    let(:todo) { Todo.create(title: 'hi', done: false) }

    before do
      get :edit, as: :turbo_stream, params: { id: todo.id }
    end

    it { is_expected.to use_before_action(:set_todo) }

    it 'assigns @todo' do
      expect(assigns(:todo).attributes).to eq(todo.attributes)
    end

    it 'renders edit form' do
      expect(response).to render_template(:edit)
    end

    it 'returns 200 status code' do
      expect(response).to have_http_status(:ok)
    end
  end
end
