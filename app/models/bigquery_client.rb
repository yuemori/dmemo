class BigqueryClient
  class << self
    def fetch_table(dataset_name, table_name)
      client.dataset(dataset_name).table(table_name)
    end

    def enable?
      ENV['GOOGLE_CLOUD_PROJECT'] && ENV['GOOGLE_CLOUD_KEYFILE']
    end

    private

    def client
      @client ||= Gcloud.new.bigquery
    end
  end
end
