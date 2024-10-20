require 'rails_helper'

RSpec.describe MatchesController, type: :controller do
  describe 'POST #create' do
    context 'when valid data is provided' do
      let(:valid_params) { DataHelper::DATA_FOR_POST }
      before do
        create_role
        post :create, params: valid_params
      end

      it 'creates a new match' do
        expect(Match.count).to eq(1)
      end

      it 'returns success status' do
        expect(response).to have_http_status(:ok)
      end

      it 'returns success message' do
        json_response = JSON.parse(response.body)
        expect(json_response['status']).to eq('Success save!')
      end

      it 'check player rating' do
        data       = DataHelper::DATA_FOR_POST[:data]
        importance = data[:importance]
        stat_first = data[:home_team][:statistics][0]
        coef       = DataHelper::ROLES.find { |r| r[:name] == stat_first[:role] }[:coefficients]
        expected_rating_first = coef.reduce(0) { |sum, (key, val)| sum + ((stat_first[key] || 0) * val * importance) }

        team   = Team.find_by_name data[:home_team][:name]
        role   = Role.find_by_name data[:home_team][:statistics][0][:role]
        name   = data[:home_team][:statistics][0][:name]
        player = Player.find_by(team: team, role: role, name: name)

        expect(Statistic.find_by(player: player).rating).to eq(expected_rating_first)
      end
    end

    context 'when data is empty' do
      it 'returns an error for empty data' do
        post :create, params: { data: {} }

        expect(response).to have_http_status(:not_found)
        json_response = JSON.parse(response.body)
        expect(json_response['error']).to eq('Data is empty')
      end
    end

    context 'when home team name is missing' do
      it 'returns an error for missing home team name' do
        invalid_params = {
          data: {
            importance: 2,
            date: '2024-02-02',
            home_team: { statistics: [] },
            away_team: { name: 'Titans', statistics: [] }
          }
        }

        post :create, params: invalid_params

        expect(response).to have_http_status(:not_found)
        json_response = JSON.parse(response.body)
        expect(json_response['error']).to eq('Data is not correct')
      end
    end

    context 'when away team name is missing' do
      it 'returns an error for missing away team name' do
        invalid_params = {
          data: {
            importance: 2,
            date: '2024-02-02',
            home_team: { name: 'Pumas', statistics: [] },
            away_team: { name: 'Titans', statistics: [] }
          }
        }

        post :create, params: invalid_params

        expect(response).to have_http_status(:not_found)
        json_response = JSON.parse(response.body)
        expect(json_response['error']).to eq('Statistic is empty')
      end
    end
  end
end
