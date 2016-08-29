require 'rails_helper'

describe BigqueryDataSource, type: :model do
  let(:data_source) { FactoryGirl.create(:bigquery_data_source, :with_bigquery_tables) }
  before do
    allow_any_instance_of(described_class).to receive(:valid_project_id_and_keyfile)
  end

  describe '#data_source_table' do
    it 'return data source table' do
      expect(data_source.data_source_table('prod_logs', 'payment20160801')).to be_present
    end
  end

  describe "#data_source_tables" do
    it "returns data source tables" do
      expect(data_source.data_source_tables.size).to eq 1
    end
  end
end
