FactoryGirl.define do
  factory :data_source do
    name "dmemo"
    description "# dmemo test db\nDB for test."
    adapter { ActiveRecord::Base.establish_connection.spec.config[:adapter] }
    host "localhost"
    port 5432
    dbname { ActiveRecord::Base.establish_connection.spec.config[:database] }
    user { ActiveRecord::Base.establish_connection.spec.config[:username] }
    password { ActiveRecord::Base.establish_connection.spec.config[:password] }
    encoding nil
    type "DatabaseDataSource"
    pool 1
  end

  factory :database_data_source, class: 'DatabaseDataSource' do
    name "dmemo"
    description "# dmemo test db\nDB for test."
    adapter "postgresql"
    host "localhost"
    port 5432
    dbname "dmemo_test"
    user "postgres"
    password nil
    encoding nil
    type "DatabaseDataSource"
    pool 1
  end

  factory :bigquery_data_source, class: 'BigqueryDataSource' do
    name "dmemo"
    description "# dmemo test bigquery\nBigquery for test."
    adapter "bigquery"
    bigquery_dataset_name 'prod_logs'
    bigquery_project_id 'dmemo_project'
    bigquery_keyfile SecureRandom.hex(128)
    type "BigqueryDataSource"

    trait :with_bigquery_tables do
      after(:create) do |data_source|
        FactoryGirl.create :bigquery_table, data_source_id: data_source.id
      end
    end
  end
end
