require 'csv'

class MySqliteRequest
    
    def initialize

        @select_headers = []
        @select_rows = nil

        @where_header = nil
        @where_value = nil
        
    end

    def from(csv_name)
        @full_table = CSV.parse(File.read(csv_name), headers: true)
        @full_headers = @full_table.headers
        return self

    end

    def select(*columns)
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
        @where_header = column_name
        @where_value = criteria
        return self
    end

    def join(column_on_db_a, filename_db_b, column_on_db_b)
        @join_table = CSV.parse(File.read(filename_db_b), headers: true)
        new_rows = []

        @full_table.each do |row1|
            matching_value = row1[column_on_db_a]

            matching_rows = @join_table.select { |row2| row2[column_on_db_b] == matching_value}
            matching_rows.each do |row2|
                new_rows << row1.to_h.merge(row2.to_h)
            end
        end

        headers = @full_headers + @join_table.headers.reject { |header| header == column_on_db_b}
        combined_data = new_rows.map { |row| CSV::Row.new(headers, row)}
        @ultimate_table = CSV::Table.new(combined_data)

        return self
    end

    def order(order, column_name)
        if order == :desc
            @sorted_table = @full_table.sort_by { |row| row[column_name]}.reverse
        else
            @sorted_table = @full_table.sort_by { |row| row[column_name]}
        end

        return self
    end

    def insert(table_name)
        @insert_csv = table_name # could this be a boolean?
        @full_table = CSV.parse(File.read(table_name), headers: true)
        @full_headers = @full_table.headers
        return self
    end

    def values(*data)
        @new_row = CSV::Row.new(@full_headers, data)
        return self
    end

    def update(table_name)
        @update_rows = table_name
        @full_table = CSV.parse(File.read(table_name), headers: true)
        @full_headers = @full_table.headers
        return self
    end

    def set(data)
        @update_hash = data
        return self
    end

    def delete
        @delete_rows = true
        return self
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

        # ORDER
        which_table = nil
        if @sorted_table
            which_table = @sorted_table
        else
            which_table = @full_table
        end

        which_table.each do |row|

            # WHERE/SELECT
            if @where_header && @where_value 
                if row[@where_header] == @where_value
                    puts row.to_h.slice(*@select_headers)
                end

            # SELECT (WHERE absent)
            else
                puts row.to_h.slice(*@select_headers)
            end

        end
        @sorted_table = nil
        return self
    end

end


# TEST HERE

# MySqliteRequest.new.from('small_test.csv').select('*').run

# MySqliteRequest.new.from('small_test.csv').select('Gender', 'Email', 'UserName').where('FirstName', 'Carl').run

# MySqliteRequest.new.from('nba_players.csv').select('*').where('Player', 'Kareem Abdul-Jabbar*').run