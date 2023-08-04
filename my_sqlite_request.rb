require 'csv'

class MySqliteRequest
    
    def initialize
        
    # default values for instance variables
        
        @where_hash = {}
        self
    
    end

    def from(csv_name)

    # parses csv file, converts it to a CSV::Table object and stores the headers 

        @full_table = CSV.parse(File.read(csv_name), headers: true) 
        @full_headers = @full_table.headers
        self

    end

    def select(column_names)
        
    # @select_args stores the headers specified by SELECT function parameters

        @select_args = column_names
        self

    end

    def where(column_name, criteria)

    # @where_hash stores header-value pairs in a hash to be singled out in the run function

        @where_hash[column_name] = criteria
        self
    
    end

    def join(column_on_db_a, filename_db_b, column_on_db_b)

    # 'joins' another database with the database specified by the FROM function

        @full_table2 = CSV.parse(File.read(filename_db_b), headers: true) # convert 2nd csv to CSV::Table object
        @combined_headers = @full_headers + @full_table2.headers.reject { |header| header == column_on_db_b } # combine all the headers except for column_on_db_b 
        @combined_table = CSV::Table.new([]) # this is the new 'joined' table

        @full_table.each do |row1| # find any matches for each item in column_on_db_a in column_on_db_b
            matched_rows = @full_table2.find_all { |row2| row2[column_on_db_b] == row1[column_on_db_a] }
            if matched_rows.any?
                matched_rows.each do |row2| # for every match found, create a new CSV:Row
                    merged_row = CSV::Row.new(@combined_headers, [])
                    @combined_headers.each do |header| # for each header, use values from row1 or row2 if row1[header] doesn't exist
                        merged_row[header] = row1[header] || row2[header]
                    end
                    @combined_table << merged_row # add newly created row to new 'joined' table
                end
            else 
                merged_row = CSV::Row.new(@combined_headers, []) # if no match found, create a new CSV:Row 
                @combined_headers.each { |header| merged_row[header] = row1[header] } # for each header, use values from row1
                @combined_table << merged_row # add newly created row to new 'joined' table
            end
        end
        self

    end

    def order(order, column_name)

    # 'nil' values are given precedence in ascending order by use of two-element array in the sorting key used for sort_by method 

        if order == :desc
            @sorted_table = @full_table.sort_by { |row| [row[column_name].nil? ? 0 : 1, row[column_name]] }.reverse
        else
            @sorted_table = @full_table.sort_by { |row| [row[column_name].nil? ? 0 : 1, row[column_name]] }
        end
        self

    end

    def insert(table_name)

    # a boolean is used to indicate we're inserting and csv file is converted to CSV::Table object

        @insert_csv = true
        @full_table = CSV.parse(File.read(table_name), headers: true)
        @full_headers = @full_table.headers
        self

    end

    def values(data)

    # data used by INSERT function

        @new_row = data
        self

    end

    def update(table_name)

    # boolean is used to indicate we're updating and csv file is converted to CSV::Table object

        @update_rows = true
        @full_table = CSV.parse(File.read(table_name), headers: true)
        @full_headers = @full_table.headers
        self
        
    end

    def set(data)

    # data used by UPDATE function

        @update_hash = data
        self

    end

    def delete
        
    # boolean to indicate we're deleting

        @delete_rows = true
        self

    end

    def run

        # INSERT/VALUES

        if @insert_csv
            @full_table << @new_row
            @insert_csv = nil # reset after insertion complete
            return self
        end

        # DELETE

        if @delete_rows
            if !@where_hash.empty? # if WHERE specified, delete only rows that have column values that match WHERE parameters
                @full_table.delete_if { |row| @where_hash.all? { |key, value| row[key] == value } }
                @where_hash = {} # reset WHERE after complete

            else # if no WHERE, delete all data/rows
                @full_table.delete_if { |row| row}
            end
            @delete_rows = nil # reset after deletion complete
            return self
        end

        # UPDATE/SET

        if @update_rows
            @full_table.each do |row|
                if !@where_hash.empty? # if WHERE specified, update only rows that have column values that match WHERE parameters
                    if @where_hash.all? { |key, value| row[key] == value }
                        @update_hash.each do |key, value|
                            row[key] = value 
                        end
                    end
                    @where_hash = {} # reset WHERE after complete
                else # if no WHERE, update all rows
                    @update_hash.each do |key, value|
                        row[key] = value
                    end
                end
            end
            
            @update_rows = nil # reset after updating complete
            return self
        end

        # ORDER/JOIN - check for presence of joined or ordered table

        which_table = nil

        if @sorted_table
            which_table = @sorted_table
        elsif @combined_table
            which_table = @combined_table
        else
            which_table = @full_table
        end

        # SELECT - select headers to be printed

        if @select_args.is_a?(Array) 
            @select_headers = @select_args
        else
            if @select_args == "*" && @combined_table
                @select_headers = @combined_headers
            elsif @select_args == "*"
                @select_headers = @full_headers
            else
                @select_headers = @select_args
            end
        end

        which_table.each do |row|

            # WHERE/SELECT

            if !@where_hash.empty? # if WHERE specified, we only SELECT or print rows that have column values that match WHERE parameters
                if @where_hash.all? { |key, value| row[key] == value }
                    puts row.to_h.slice(*@select_headers) # only 'select' columns/headers get printed
                end

            # SELECT (WHERE absent)

            else # no WHERE means we print all columns
                puts row.to_h.slice(*@select_headers) # only 'select' columns/headers get printed
            end

        end

        # Reset after complete
        @select_args = nil
        @where_hash = {}
        @sorted_table = nil
        @combined_table = nil
    end

end


# TESTS START HERE

# "FROM/SELECT"
# SELECT - SINGLE ARGUMENT AS A STRING
# MySqliteRequest.new.select('*').from('small_test.csv').run
# MySqliteRequest.new.select('FirstName').from('small_test.csv').run
# # SELECT - MULTIPLE ARGUMENTS AS AN ARRAY
# MySqliteRequest.new.select(['Gender', 'Email', 'UserName', 'Device']).from('small_test.csv').run

# "WHERE"
# SINGLE WHERE
# MySqliteRequest.new.select('*').from('small_test.csv').where('FirstName', 'Carl').run
# MULTIPLE WHERES
# MySqliteRequest.new.select(['Gender', 'LastName', 'UserName', 'Age']).from('small_test.csv').where('Gender', 'Male').where('Device', 'Chrome Android').run

# "JOIN"
# MySqliteRequest.new.select(['Player', 'height', 'position']).from('nba_players.csv').join('Player', 'nba_player_data.csv', 'name').run

# "ORDER"
# ASCENDING
# MySqliteRequest.new.select('*').from('small_test.csv').order(:asc, 'Age').run
# DESCENDING
# MySqliteRequest.new.select('*').from('nba_players.csv').order(:desc, 'born').run

# "INSERT/VALUES"
# request = MySqliteRequest.new.insert('small_test.csv').values({"Gender"=>"Male", "FirstName"=>"John", "LastName"=>"Smith", "UserName"=>"john", "Email"=>"john.smith@aol.com", "Age"=>"90", "City"=>"San Andreas", "Device"=>"Chrome Android", "Coffee Quantity"=>"1", "Order At"=>"1990-10-25 5:23:51"}).run
# request = request.select('*').run

# "UPDATE/SET"
# request = MySqliteRequest.new.update('small_test.csv').set({"Coffee Quantity"=>"99"}).where('Gender', 'Male').run
# request = request.select('*').run

# "DELETE"
# request = MySqliteRequest.new.from('small_test.csv').delete.where('Gender', 'Female').where('Age', '21').run
# request = request.select('*').run
