=begin
Create a class called MySqliteRequest in my_sqlite_request.rb. It will have a similar behavior than a request on the real sqlite.

All methods, except run, will return an instance of my_sqlite_request. You will build the request by progressive call and execute the request by calling run.

Each row must have an ID.

We will do only 1 join and can do one or multiple where(s) per request.
=end
require 'csv'

class MySqliteRequest
    
# Constructor:
    def initialize
        
    end
        
=begin
    From Implement a from method which must be present on each request. From will take a parameter and it will be the name of the table. (technically a table_name is also a filename (.csv))
=end
    def from(table_name)
        @table_name = table_name
    end

=begin
Select Implement a where method which will take one argument a string OR an array of string. It will continue to build the request. During the run() you will collect on the result only the columns sent as parameters to select :-).
=end

    def select(column_name)
    end
# OR
    def select(column_name_a, column_name_b)
    end

=begin
Where Implement a where method which will take 2 arguments: column_name and value. It will continue to build the request. During the run() you will filter the result which match the value.
=end

    def where(column_name, criteria)
    end

=begin
Join Implement a join method which will load another filename_db and will join both database on a on column.
=end

    def join(column_on_db_a, filename_db_b, column_on_db_b)
    end

=begin
Order Implement an order method which will received two parameters, order (:asc or :desc) and column_name. It will sort depending on the order base on the column_name.
=end

    def order(order, column_name)
    end

=begin
Insert Implement a method to insert which will receive a table name (filename). It will continue to build the request.
=end

    def insert(table_name)
    end

=begin
Values Implement a method to values which will receive data. (a hash of data on format (key => value)). It will continue to build the request. During the run() you do the insert.
=end

    def values(data)
    end
=begin
Update Implement a method to update which will receive a table name (filename). It will continue to build the request. An update request might be associated with a where request.
=end

    def update(table_name)
    end

=begin
Set Implement a method to update which will receive data (a hash of data on format (key => value)). It will perform the update of attributes on all matching row. An update request might be associated with a where request.
=end

    def set(data)
    end

=begin
Delete Implement a delete method. It set the request to delete on all matching row. It will continue to build the request. An delete request might be associated with a where request.
=end

    def delete
    end

=begin
Run Implement a run method and it will execute the request.
=end

end