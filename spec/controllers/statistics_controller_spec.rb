require 'rails_helper'

RSpec.describe StatisticsController, type: :controller do
  before(:all) do
    @data = create_team_with_players_and_statistics
  end

  let(:team) { @data[:team] }
  let(:players) { @data[:players] }

  describe 'GET #index' do
    context 'when valid parameters are provided' do
      before do
        get :index, params: { team_name: team.name, top: 3, page: 1, per_page: 2,
                              from: '2023-01-01', to: '2024-12-31', role: 'Defender' }
        @json_response = JSON.parse(response.body)
      end

      it 'returns a successful response' do
        expect(response).to have_http_status(:ok)
      end

      it 'returns the correct team name' do
        expect(@json_response['team']).to eq(team.name)
      end

      it 'returns the correct number of players' do
        expect(@json_response['players'].size).to eq(2)
      end

      it 'returns players with the correct role' do
        expect(@json_response['players'].first['role']).to eq('Defender')
      end

      it 'includes a player with the name "player2"' do
        expect(@json_response['players'].map { |p| p['name'] }).to include('player2')
      end

      it 'returns pagination information' do
        expect(@json_response['page']).to eq(1)
        expect(@json_response['per_page']).to eq(2)
        expect(@json_response['pages']).to be >= 1
        expect(@json_response['items']).to eq(3)
      end
    end

    context 'when no players match the role' do
      before do
        get :index, params: { team_id: team.id, role: 'NonExistentRole' }
        @json_response = JSON.parse(response.body)
      end

      it 'returns a not found response' do
        expect(response).to have_http_status(:not_found)
      end

      it 'returns an error message' do
        expect(@json_response['error']).to eq('Role not found')
      end
    end

    context 'when the team is not found' do
      before do
        get :index
        @json_response = JSON.parse(response.body)
      end

      it 'returns a not found response' do
        expect(response).to have_http_status(:not_found)
      end

      it 'returns a team not found error message' do
        expect(@json_response['error']).to eq('Team not found')
      end
    end
  end
end
