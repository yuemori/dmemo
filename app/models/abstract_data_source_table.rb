class AbstractDataSourceTable
  attr_reader :data_source, :schema_name, :table_name

  def initialize(data_source, schema_name, table_name)
    @data_source = data_source
    @schema_name = schema_name
    @table_name = table_name
  end

  def columns
    raise NotImplementedError.new
  end

  def adapter
    raise NotImplementedError.new
  end

  def fetch_rows
    raise NotImplementedError.new
  end

  def fetch_count
    raise NotImplementedError.new
  end
end
