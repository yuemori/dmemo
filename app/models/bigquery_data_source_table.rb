class BigqueryDataSourceTable < AbstractDataSourceTable
  alias dataset_name schema_name

  def adapter
    ActiveRecord::Base.connection.pool.connections.first
  end

  class BigqueryColumn
    attr_reader :null, :default, :sql_type, :name

    def initialize(field)
      @name = field.name
      @null = field.mode.nil?
      @default = nil
      @sql_type = field.type
    end
  end

  def columns
    bigquery_table.fields.map { |field| BigqueryColumn.new(field) }
  rescue Google::Cloud::Error => e
    raise DataSource::ConnectionBad.new(e)
  end

  def fetch_rows(limit=20)
    @fetch_rows ||= bigquery_table.data(max: limit).map { |data| data.values }
  rescue Google::Cloud::Error => e
    raise DataSource::ConnectionBad.new(e)
  end

  def fetch_count
    @fetch_count ||= bigquery_table.rows_count
  rescue Google::Cloud::Error => e
    raise DataSource::ConnectionBad.new(e)
  end

  private

  def bigquery_client
    @bigquery_client ||= BigqueryClient.new(data_source.bigquery_project_id, data_source.bigquery_keyfile, data_source.bigquery_dataset_name)
  end

  def bigquery_table
    @bigquery_table ||= bigquery_client.table(table_name) || (raise DataSource::ConnectionBad.new('Table Not Found'))
  end
end
