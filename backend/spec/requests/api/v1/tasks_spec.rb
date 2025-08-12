require 'rails_helper'

RSpec.describe "Api::V1::Tasks", type: :request do
  let!(:task) { create(:task) } # FactoryBotを使用

  describe "GET /api/v1/tasks" do
    it "returns a list of tasks" do
      get api_v1_tasks_path
      expect(response).to have_http_status(:ok)
      expect(json_response.size).to eq(1)
      expect(json_response.first['title']).to eq(task.title)
    end
  end

  describe "GET /api/v1/tasks/:id" do
    it "returns a single task" do
      get api_v1_task_path(task)
      expect(response).to have_http_status(:ok)
      expect(json_response['title']).to eq(task.title)
    end

    it "returns not found if task does not exist" do
      get api_v1_task_path(id: 999)
      expect(response).to have_http_status(:not_found)
    end
  end

  describe "POST /api/v1/tasks" do
    context "with valid parameters" do
      it "creates a new task" do
        task_params = attributes_for(:task)
        expect {
          post api_v1_tasks_path, params: { task: task_params }
        }.to change(Task, :count).by(1)
        expect(response).to have_http_status(:created)
        expect(json_response['title']).to eq(task_params[:title])
      end
    end

    context "with invalid parameters" do
      it "does not create a new task" do
        task_params = attributes_for(:task, title: nil) # titleをnilにしてバリデーションエラーを発生させる
        expect {
          post api_v1_tasks_path, params: { task: task_params }
        }.to_not change(Task, :count)
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe "PUT /api/v1/tasks/:id" do
    context "with valid parameters" do
      it "updates the task" do
        new_title = "Updated Task Title"
        put api_v1_task_path(task), params: { task: { title: new_title } }
        expect(response).to have_http_status(:ok)
        expect(json_response['title']).to eq(new_title)
        expect(task.reload.title).to eq(new_title)
      end
    end

    context "with invalid parameters" do
      it "does not update the task" do
        put api_v1_task_path(task), params: { task: { title: nil } }
        expect(response).to have_http_status(:unprocessable_entity)
        expect(task.reload.title).to_not be_nil
      end
    end
  end

  describe "DELETE /api/v1/tasks/:id" do
    it "deletes the task" do
      expect {
        delete api_v1_task_path(task)
      }.to change(Task, :count).by(-1)
      expect(response).to have_http_status(:no_content)
      expect { task.reload }.to raise_error(ActiveRecord::RecordNotFound)
    end
  end

  # ヘルパーメソッド
  def json_response
    JSON.parse(response.body)
  end
end