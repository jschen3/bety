require 'csv'
require 'mysql'
begin
  puts "Please type the hosting service of the database: Default is localhost"
  host=gets.chomp
  puts "type the username to connect to your database\n"
  username=gets.chomp
  puts "please type the password"
  password=gets.chomp
  puts "please type the name of the database"
  database=gets.chomp
  con = Mysql.new("#{host}","#{username}","#{password}","#{database}")
  information= Mysql.new("#{host}","#{username}","#{password}","INFORMATION_SCHEMA")
  tablesquery='SHOW tables'
  tablesresult=con.query(tablesquery);
  tablelist=Array.new
  tcounter=0
  columnname="Tables_in_#{database}"
  upcase=database.upcase;
  tablesresult.each_hash do |table|
    tablelist[tcounter]=table[columnname]
    tcounter+=1
  end
  i=0 #i is a variable to go through tablelist
  while(i<tablelist.length)
    CSV.open("#{tablelist[i]}.csv","wb") do |csv|
      tablecommentquery="SELECT TABLE_NAME,TABLE_COMMENT FROM TABLES WHERE TABLE_SCHEMA='#{upcase}' AND TABLE_NAME='#{tablelist[i]}'"
      tablecommentresult=information.query(tablecommentquery)
      tablecommentresult.each_hash do |comment|
        csv <<["#{comment['TABLE_NAME']}","#{comment['TABLE_COMMENT']}"]
      end
      csv <<["column_name","column_type","is_nullable","column_default","column_comment"]
      describequery="SELECT column_name,column_type,is_nullable,column_default,column_comment FROM INFORMATION_SCHEMA.COLUMNS WHERE table_name='#{tablelist[i]}'"
      describeresult=con.query(describequery)
      puts 'tablename =#{tablelist[i]}'
      describeresult.each_hash do |description|
        puts description
        csv << ["#{description['column_name']}","#{description['column_type']}","#{description['is_nullable']}","#{description['column_default']}","#{description['column_comment']}"]
      end
    end
    i+=1
  end
  
  rescue Mysql::Error => e
      puts e.errno
      puts e.error

  ensure
      con.close if con
end
