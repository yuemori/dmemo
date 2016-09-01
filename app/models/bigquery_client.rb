class BigqueryClient
  delegate :table, to: :dataset

  def initialize(project_id, keyfile, dataset_name)
    @project_id = project_id
    @keyfile = keyfile
    @dataset_name = dataset_name
  end

  def valid?
    client.present? && dataset.present?
  rescue Google::Cloud::NotFoundError
    false
  end

  private

  def dataset
    @dataset ||= client.dataset(@dataset_name)
  end

  def client
    @client ||= begin
      Tempfile.create('bigquery_keyfile') do |file|
        file.write JSON.load(Encryptor.decrypt(@keyfile).to_json)
        file.rewind
        return Gcloud.new(@project_id, file).bigquery
      end
    end
  rescue JSON::ParserError
    nil
  end
end
