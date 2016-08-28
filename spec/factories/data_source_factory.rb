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
end
