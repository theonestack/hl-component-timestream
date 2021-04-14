CloudFormation do

  timestream_tags = []
  timestream_tags << { Key: 'Name', Value: FnSub("${EnvironmentName}-#{external_parameters[:component_name]}") }
  timestream_tags << { Key: 'Environment', Value: Ref(:EnvironmentName) }
  timestream_tags << { Key: 'EnvironmentType', Value: Ref(:EnvironmentType) }

  database_name = external_parameters.fetch(:database_name, "${EnvironmentName}-#{external_parameters[:component_name]}")
  kms_key_id = external_parameters.fetch(:kms_key_id, nil)

  Timestream_Database(:TimestreamDatabase) {
    DatabaseName FnSub(database_name)
    KmsKeyId kms_key_id if !kms_key_id.nil?
    Tags timestream_tags
  }
  
  tables = external_parameters.fetch(:tables, [])
  tables.each do |table|
    table_name = table['name']
    table_name_safe = table_name.gsub(/[-_.]/,"")
    memory_store_retention = table['memory_store_retention'] if !table['memory_store_retention'].nil?
    magnetic_store_retention = table['magnetic_store_retention'] if !table['magnetic_store_retention'].nil?
    
    Timestream_Table("TimestreamTable#{table_name_safe}") {
      TableName FnSub(table_name)
      DatabaseName Ref(:TimestreamDatabase)
      RetentionProperties ({
        MemoryStoreRetentionPeriodInHours: memory_store_retention,
        MagneticStoreRetentionPeriodInDays: magnetic_store_retention
      }) if !memory_store_retention.nil? & !magnetic_store_retention.nil?
      Tags timestream_tags
    }

  end

  Output(:TimestreamDatabaseName) {
    Value(Ref(:TimestreamDatabase))
    Export FnSub("${EnvironmentName}-#{external_parameters[:component_name]}-TimestreamDatabaseName")
  }

end