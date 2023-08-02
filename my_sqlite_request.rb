require 'csv'

class MySqliteRequest
    
    def initialize

        @select_headers = []
        @select_rows = nil

        @where_header = []
        @where_value = []
        self
    end

    def from(csv_name)
        @full_table = CSV.parse(File.read(csv_name), headers: true)
        @full_headers = @full_table.headers
        self
    end

    def select(*columns)
        @select_columns = columns
        columns.each do |column_name|
            if column_name == "*"
                @select_headers = @full_headers

            elsif @full_headers.include?(column_name)
                @select_headers << column_name
            end
        end
        return self
    end

    def where(column_name, criteria)
        @where_header << column_name
        @where_value << criteria
        self
    end

    def join(column_on_db_a, filename_db_b, column_on_db_b)
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
        if order == :desc
            @sorted_table = @full_table.sort_by { |row| [row[column_name].nil? ? 0 : 1, row[column_name]] }.reverse
        else
            @sorted_table = @full_table.sort_by { |row| [row[column_name].nil? ? 0 : 1, row[column_name]] }
        end

        self
    end

    def insert(table_name)
        @insert_csv = table_name # could this be a boolean?
        @full_table = CSV.parse(File.read(table_name), headers: true)
        @full_headers = @full_table.headers
        self
    end

    def values(*data)
        @new_row = CSV::Row.new(@full_headers, data)
        self
    end

    def update(table_name)
        @update_rows = table_name
        @full_table = CSV.parse(File.read(table_name), headers: true)
        @full_headers = @full_table.headers
        self
    end

    def set(data)
        @update_hash = data
        self
    end

    def delete
        @delete_rows = true
        self
    end

    def run

        # INSERT/VALUES
        if @insert_csv
            @full_table << @new_row
            @insert_csv = nil
            return self
        end

        # DELETE
        if @delete_rows
            if @where_header && @where_value # if WHERE criteria specified
                @full_table.delete_if { |row| row[@where_header] == @where_value }
                @where_header = nil
                @where_value = nil

            else # not specified = delete all data
                @full_table.delete_if { |row| row}
            end
            @delete_rows = nil
            return self
        end

        # UPDATE/SET
        if @update_rows
            @full_table.each do |row|
                if @where_header && @where_value
                    if row[@where_header] == @where_value
                        @update_hash.each do |key, value|
                            row[key] = value
                        end
                    end
                else
                    @update_hash.each do |key, value|
                        row[key] = value
                    end
                end
            end
            
            @update_rows = nil
            return self
        end

        # ORDER/JOIN
        which_table = nil
        if @sorted_table
            which_table = @sorted_table
        elsif @combined_table
            @select_headers = @combined_headers
            # select(@select_columns)
            which_table = @combined_table
        else
            which_table = @full_table
        end

        which_table.each do |row|

            # WHERE/SELECT
            if !@where_header.empty? # if WHERE specified, 
                wheres_present = 0
                @where_header.zip(@where_value).each do |where_header, where_value|
                    if row[where_header] == where_value
                        wheres_present += 1
                    end
                end
                if wheres_present == @where_header.length
                    puts row.to_h.slice(*@select_headers)
                end

            # SELECT (WHERE absent)
            else
                puts row.to_h.slice(*@select_headers)
            end

        end
        @sorted_table = nil
    end

end


# TESTS HERE

# FROM/SELECT
# BASIC TEST - 'SELECT *'
# MySqliteRequest.new.from('small_test.csv').select('*').run

# WHERE 
# BASIC TEST - ONE WHERE
# MySqliteRequest.new.from('small_test.csv').select('Gender', 'Email', 'UserName').where('FirstName', 'Carl').run
# TEST MULTIPLE WHERE
MySqliteRequest.new.from('small_test.csv').select('Gender', 'Email', 'UserName').where('Gender', 'Male').where('FirstName', 'Marvin').run

# JOIN
# MySqliteRequest.new.from('nba_players.csv').select('*').join('Player', 'nba_player_data.csv', 'name').run

# ORDER
# TEST ASCENDING
# MySqliteRequest.new.from('small_test.csv').select('*').order(:asc, 'Age').run
# TEST DESCENDING
# MySqliteRequest.new.from('nba_players.csv').select('*').order(:desc, 'born').run

# INSERT/VALUES
# MySqliteRequest.new.from('nba_players.csv').select('*').join('Player', 'nba_player_data.csv', 'name').run

# UPDATE/SET
# MySqliteRequest.new.from('nba_players.csv').select('*').join('Player', 'nba_player_data.csv', 'name').run

# DELETE
# request = MySqliteRequest.new.from('small_test.csv').delete.where('Device', 'Chrome Android').run
# request = request.select('*')
# request.run
