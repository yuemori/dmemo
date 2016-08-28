class DataSource < ActiveRecord::Base
  validates :name, :adapter, presence: true

  has_many :ignored_tables
  has_many :bigquery_tables
  accepts_nested_attributes_for :bigquery_tables, allow_destroy: true, reject_if: :bigquery_adapter

  has_one :database_memo, class_name: "DatabaseMemo", foreign_key: :name, primary_key: :name, dependent: :destroy

  class ConnectionBad < IOError
  end

  def bigquery_adapter
    adapter != 'bigquery'
  end

  def self.data_source_tables_cache
    @data_source_tables_cache ||= {}
  end

  def source_table_names
    raise NotImplementedError.new
  end

  def reset_data_source_tables!
    Rails.cache.delete(cache_key_source_table_names)
    self.class.data_source_tables_cache[id] = {}
  end

  def create_data_source_table(_schema_name, _table_name)
    raise NotImplementedError.new
  end

  def cache_key_source_table_names
    "data_source_source_table_names_#{id}"
  end

  def cached_source_table_names
    key = cache_key_source_table_names
    cache = Rails.cache.read(key)
    return cache if cache
    value = source_table_names
    Rails.cache.write(key, value)
    value
  end

  def data_source_table(schema_name, table_name, table_names=cached_source_table_names)
    return if ignored_table_patterns.match(table_name)
    schema_name, _ = table_names.find {|schema, table| schema == schema_name && table == table_name }
    return nil unless schema_name
    full_table_name = "#{schema_name}.#{table_name}"
    self.class.data_source_tables_cache[id] ||= {}
    source_table = self.class.data_source_tables_cache[id][full_table_name]
    return source_table if source_table
    self.class.data_source_tables_cache[id][full_table_name] = create_data_source_table(schema_name, table_name)
  rescue ActiveRecord::ActiveRecordError, Mysql2::Error, PG::Error => e
    raise ConnectionBad.new(e)
  end

  def data_source_tables
    table_names = cached_source_table_names
    table_names.map do |schema_name, table_name|
      data_source_table(schema_name, table_name, table_names)
    end
  end

  def ignored_table_patterns
    @ignored_table_patterns ||= Regexp.union(ignored_tables.pluck(:pattern).map {|pattern| Regexp.new(pattern, true) })
  end

  def access_logging
    Rails.logger.tagged("DataSource #{name}") { yield }
  end
end
