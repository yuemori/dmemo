class DataSourcesController < ApplicationController
  permits :name, :description, :adapter, :host, :port, :dbname, :user, :password, :encoding, :bigquery_project_id, :bigquery_keyfile, :bigquery_dataset_name, bigquery_tables_attributes: [:id, :name, :_destroy]

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
      bigquery_params = data_source_params(data_source)
      upload_file = bigquery_params[:bigquery_keyfile]
      bigquery_params[:bigquery_keyfile] = upload_file.read if upload_file
      @data_source = BigqueryDataSource.create!(bigquery_params)
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
    data_source['bigquery_keyfile'] = Encryptor.decrypt(@data_source.bigquery_keyfile) if @data_source.bigquery_keyfile.present?
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
