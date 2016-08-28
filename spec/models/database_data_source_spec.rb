require 'rails_helper'

describe DatabaseDataSource, type: :model do
  let(:data_source) { FactoryGirl.create(:database_data_source) }

  describe "#source_base_class" do
    it "return source base class" do
      expect(data_source.source_base_class).to eq(DatabaseDataSource::DynamicTable::Dmemo_Base)
    end
  end

  describe "#data_source_table" do
    it "return data source table" do
      expect(data_source.data_source_table("public", "data_sources")).to be_present
      expect(data_source.data_source_table("public", "data_sources").columns.map(&:name)).to match_array(%w(
        id name bigquery_dataset_name description adapter host port dbname user password encoding pool created_at updated_at type
      ))
    end
  end

  describe "#data_source_tables" do
    it "returns data source tables" do
      expect(data_source.data_source_tables.size).to be > 0
    end
  end
end
