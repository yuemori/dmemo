class BigqueryDataSource < DataSource

  validates :bigquery_dataset_name, presence: true

  def source_table_names
    bigquery_tables.map { |bigquery_table| [bigquery_dataset_name, bigquery_table.name] }
  end

  def create_data_source_table(dataset_name, table_name)
    BigqueryDataSourceTable.new(self, dataset_name, table_name)
  end
end
