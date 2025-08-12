require 'rails_helper'

RSpec.describe 'Projects API', type: :request do
  # Test suite for GET /projects
  describe 'GET /projects' do
    let!(:projects) { create_list(:project, 5) } # Assuming FactoryBot is set up

    before { get '/projects' }

    it 'returns projects' do
      expect(json).not_to be_empty
      expect(json.size).to eq(5)
    end

    it 'returns status code 200' do
      expect(response).to have_http_status(200)
    end
  end

  # Test suite for GET /projects/:id
  describe 'GET /projects/:id' do
    let!(:project) { create(:project) }

    before { get "/projects/#{project.id}" }

    context 'when the record exists' do
      it 'returns the project' do
        expect(json).not_to be_empty
        expect(json['id']).to eq(project.id)
      end

      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end
    end

    context 'when the record does not exist' do
      before { get '/projects/1000' } # Non-existent ID

      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end

      it 'returns a not found message' do
        expect(json['error']).to match(/Project not found/)
      end
    end
  end

  # Test suite for POST /projects
  describe 'POST /projects' do
    let(:valid_attributes) { { name: 'Test Project', description: 'A test description', technical_context: { tech_stack: { backend: 'Rails' } } } }

    context 'when the request is valid' do
      before { post '/projects', params: { project: valid_attributes } }

      it 'creates a project' do
        expect(json['name']).to eq('Test Project')
      end

      it 'returns status code 201' do
        expect(response).to have_http_status(201)
      end
    end

    context 'when the request is invalid (missing name)' do
      before { post '/projects', params: { project: { description: 'Invalid project' } } }

      it 'returns status code 422' do
        expect(response).to have_http_status(422)
      end

      it 'returns a validation failure message' do
        expect(json['name']).to include("can't be blank")
      end
    end
  end

  # Test suite for PUT /projects/:id
  describe 'PUT /projects/:id' do
    let!(:project) { create(:project) }
    let(:valid_attributes) { { name: 'Updated Project Name' } }

    context 'when the record exists' do
      before { put "/projects/#{project.id}", params: { project: valid_attributes } }

      it 'updates the record' do
        expect(json['name']).to eq('Updated Project Name')
        expect(project.reload.name).to eq('Updated Project Name')
      end

      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end
    end

    context 'when the record does not exist' do
      before { put '/projects/1000', params: { project: valid_attributes } }

      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end

      it 'returns a not found message' do
        expect(json['error']).to match(/Project not found/)
      end
    
    end

    context 'when the update is invalid (e.g., name is blank)' do
      before { put "/projects/#{project.id}", params: { project: { name: '' } } }

      it 'returns status code 422' do
        expect(response).to have_http_status(422)
      end

      it 'returns a validation failure message' do
        expect(json['name']).to include("can't be blank")
      end
    end
  end

  # Test suite for DELETE /projects/:id
  describe 'DELETE /projects/:id' do
    let!(:project) { create(:project) }

    context 'when the record exists' do
      before { delete "/projects/#{project.id}" }

      it 'returns status code 204' do
        expect(response).to have_http_status(204)
      end

      it 'removes the project from the database' do
        expect { project.reload }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end

    context 'when the record does not exist' do
      before { delete '/projects/1000' }

      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end

      it 'returns a not found message' do
        expect(json['error']).to match(/Project not found/)
      end
    end
  end

  # Helper method to parse JSON response
  def json
    JSON.parse(response.body)
  end
end
