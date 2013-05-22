Description: The ruby file will go through all the tables in the database and will 
pull up a description of each field. For an example for the traits table it will see
the table columns and comments of the table columns on each datafield and make an information file similar table below.

traits,Table for recording trait data.
column_name,column_type, is_nullable, column_default, column_comment
id			,int(11)	,No			, 				, 


Steps to Use:
1.open up a console

2. install the following gems
	-mysql	-mysql2
Exp: gem install mysql

3. Run the application
Exp: ruby documentationmaker.rb

4. Answer the prompts with the appropriate information.
5. The description will be in csv format in the same location as the program file.