class DataSourcesController < ApplicationController
  permits :name, :description, :adapter, :host, :port, :dbname, :user, :password, :encoding, :bigquery_dataset_name, bigquery_tables_attributes: [:id, :name, :_destroy]

  before_action :require_admin_login, only: %w(new create edit update destroy)

  DUMMY_PASSWORD = "__DUMMY__"

  def index
    redirect_to setting_path
  end

  def show
    redirect_to setting_path
  end

  def new
    @data_source = DataSource.new
    @data_source.bigquery_tables.build
  end

  def create(data_source)
    if data_source[:adapter] == 'bigquery'
      @data_source = BigqueryDataSource.create!(data_source_params(data_source))
    else
      @data_source = DatabaseDataSource.create!(data_source_params(data_source))
    end
    flash[:info] = t("data_source_updated", name: @data_source.name)
    redirect_to data_sources_path
  rescue ActiveRecord::ActiveRecordError => e
    flash[:error] = e.message
    redirect_to new_data_source_path
  end

  def edit(id)
    @data_source = DataSource.includes(:bigquery_tables).find(id)
    @data_source.password = DUMMY_PASSWORD
  end

  def update(id, data_source)
    @data_source = DataSource.find(id)
    @data_source.reset_data_source_tables!
    @data_source.update!(data_source_params(data_source))
    flash[:info] = t("data_source_updated", name: @data_source.name)
    redirect_to data_sources_path
  rescue  ActiveRecord::ActiveRecordError, DataSource::ConnectionBad => e
    flash[:error] = e.message
    redirect_to :back
  end

  def destroy(id)
    data_source = DataSource.find(id)
    data_source.destroy!
    redirect_to data_sources_path
  end

  private

  def data_source_params(data_source)
    data_source.reject!{|k, v| k == "password" && v == DUMMY_PASSWORD }
    data_source
  end
end
