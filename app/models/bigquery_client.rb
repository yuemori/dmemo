class BigqueryClient
  class << self
    def fetch_table(dataset_name, table_name)
      client.dataset(dataset_name).table(table_name)
    end

    private

    def client
      @client ||= Gcloud.new.bigquery
    end
  end
end
