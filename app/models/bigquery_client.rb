class BigqueryClient
  class << self
    def fetch_table(dataset_name, table_name)
      client.dataset(dataset_name).table(table_name)
    end

    def enable?
      project_id && keyfile
    end

    def project_id
      ENV['GOOGLE_CLOUD_PROJECT']
    end

    private

    def keyfile
      ENV['GOOGLE_CLOUD_KEYFILE']
    end

    def client
      @client ||= Gcloud.new.bigquery
    end
  end
end
