FactoryGirl.define do
  factory :data_source do
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
    type "BigqueryDataSource"

    trait :with_bigquery_tables do
      after(:create) do |data_source|
        FactoryGirl.create :bigquery_table, data_source_id: data_source.id
      end
    end
  end
end
