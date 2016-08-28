class DataSourceTable < AbstractDataSourceTable
  def columns
    @columns ||= data_source.access_logging { connection.columns("#{schema_name}.#{table_name}") }
  end

  def defined_at
    @defined_at ||= Time.now
  end

  def adapter
    connection.pool.connections.first
  end

  def fetch_rows(limit=20)
    data_source.access_logging do
      adapter = connection.pool.connections.first
      column_names = columns.map {|column| adapter.quote_column_name(column.name) }.join(", ")
      rows = connection.select_rows(<<-SQL, "#{table_name.classify} Load")
        SELECT #{column_names} FROM #{full_table_name} LIMIT #{limit};
      SQL
      rows.map {|row|
        columns.zip(row).map {|column, value| column.type_cast_from_database(value) }
      }
    end
  rescue ActiveRecord::ActiveRecordError, Mysql2::Error, PG::Error => e
    raise DataSource::ConnectionBad.new(e)
  end

  def fetch_count
    data_source.access_logging do
      adapter = connection.pool.connections.first
      connection.select_value(<<-SQL).to_i
        SELECT COUNT(*) FROM #{full_table_name};
      SQL
    end
  rescue ActiveRecord::ActiveRecordError, Mysql2::Error, PG::Error => e
    raise DataSource::ConnectionBad.new(e)
  end

  private

  def full_table_name
    @full_table_name ||= adapter.quote_table_name("#{schema_name}.#{table_name}")
  end

  def connection
    data_source.source_base_class.connection
  end
end
