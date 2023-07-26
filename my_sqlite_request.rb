require 'csv'

class MySqliteRequest
    
    def initialize

        @select_headers = []
        @select_rows = nil

        @where_header = nil
        @where_value = nil
        
        @ascending = nil
        @descending = nil
    
    end

    def from(csv_name)

        @from_csv = csv_name # is this necessary?
        @full_table = CSV.parse(File.read(csv_name), headers: true)
        @full_headers = @full_table.headers
        return self

    end

    def select(*args)
        args.each do |column_name|
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
        @csv_name2 = filename_db_b
        @join_header1 = column_on_db_a
        @join_header2 = column_on_db_b
        return self
    end

    def order(order, column_name)
        @order_header = column_name

        if order == "asc"
            @ascending = true
        elsif order == "desc"
            @descending = true
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

        if @insert_csv
            @full_table << @new_row
            @insert_csv = nil
            return self
        end

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


        @full_table.each do |row|

            if @where_header && @where_value # if WHERE criteria specified
                if row[@where_header] == @where_value
                    puts row.to_h.slice(*@select_headers)
                end
            else # otherwise, print selected headers only
                puts row.to_h.slice(*@select_headers)
                
            end

        end
        return self
    end

end


# TEST HERE

# MySqliteRequest.new.from('small_test.csv').select('*').run

# MySqliteRequest.new.from('small_test.csv').select('Gender', 'Email', 'UserName').where('FirstName', 'Carl').run

# req = MySqliteRequest.new
# req = req.insert('small_test.csv').values("Male","Bob","Dylan","bob","rollingstone@hotmail.com","90","Somewhere","Apple iPhone","1","2020-03-05 15:19:48")
# req.run
# req = req.select("*")
# req.run
# req = req.delete.where("FirstName", "Bob")
# req.run
# req = req.select("*")
# req.run

# player_req = MySqliteRequest.new
# player_req = player_req.from('nba_player_data.csv').select('*').run

req = MySqliteRequest.new
req = req.update('small_test.csv').set({'FirstName'=>'Fartface'}).where('Gender', 'Male')
req = req.select('*')
req.run