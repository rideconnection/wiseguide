def connection_supports_dmetaphone?
  if ActiveRecord::Base.connection.instance_variable_get(:@config)[:adapter] == "postgresql"
    begin
      sql = "SELECT routine_name FROM information_schema.routines WHERE specific_schema NOT IN ('pg_catalog', 'information_schema') AND type_udt_name != 'trigger';"
      funcs = ActiveRecord::Base.connection.execute(sql).to_a.collect{|h| h["routine_name"]}
      return funcs.include?("dmetaphone") && funcs.include?("dmetaphone_alt")
    rescue => e
      Rails.logger.debug e
    end
  end
  
  return false
end