class TableMemosController < ApplicationController
  def index
    redirect_to database_memo_path(params[:database_memo_id])
  end

  def show
    @table_memo = TableMemo.find(params[:id])
    source_table_class = @table_memo.source_table_class
    if source_table_class
      @source_column_classes = source_table_class.columns
      @source_table_data = fetch_source_table_data(source_table_class, @source_column_classes)
      @source_table_count = source_table_class.count
    end
  end

  private

  def fetch_source_table_data(source_table_class, source_column_classes)
    cache("source_table_data_#{source_table_class.name.underscore}", expire: 1.day) do
      column_names = source_column_classes.map(&:name)
      source_table_class.limit(20).pluck(*column_names)
    end
  end
end
