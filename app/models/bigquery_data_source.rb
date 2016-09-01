class BigqueryDataSource < DataSource

  before_save :encrypt_keyfile

  validates :bigquery_dataset_name, :bigquery_project_id, :bigquery_keyfile, presence: true
  validate :valid_project_id_and_keyfile

  def source_table_names
    bigquery_tables.map { |bigquery_table| [bigquery_dataset_name, bigquery_table.name] }
  end

  def create_data_source_table(dataset_name, table_name)
    BigqueryDataSourceTable.new(self, dataset_name, table_name)
  end

  private

  def encrypt_keyfile
    self.bigquery_keyfile = Encryptor.encrypt(bigquery_keyfile)
  end

  def valid_project_id_and_keyfile
    unless BigqueryClient.new(bigquery_project_id, Encryptor.encrypt(bigquery_keyfile), bigquery_dataset_name).valid?
      errors.add(:bigquery_project_id, :invalid)
      errors.add(:bigquery_keyfile, :invalid)
      errors.add(:bigquery_dataset_name, :invalid)
    end
  end
end
