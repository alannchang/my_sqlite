require 'csv'

class MySqliteRequest
    
    def initialize

        @select_headers = Array.new # headers that will be used in request
        @select_rows = nil
        @where_header = nil
        @where_value = nil
        @ascending = nil
        @descending = nil
    
    end

    def from(csv_name)

        @csv_name = csv_name # csv file name
        @full_table = CSV.parse(File.read(csv_name), headers: true) # complete table as a CSV::Table object
        @full_headers = @full_table.headers # complete list of headers as an array of strings
        return self

    end

    def select(column_name)
        # use select_headers to store the specified columns
        if column_name == "*"
            @select_headers = @full_headers
            return self

        elsif @full_headers.include?(column_name)
            @select_headers << column_name
            return self
        end

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
        
    end

    def order(order, column_name)
        @order_header = column_name

        if order == "asc"
            @ascending = true
        elsif order == "desc"
            @descending = true
        end


    end

    def insert(table_name)
        @insert_table = table_name
    end

    def values(data)
        @insert_table
    end

    def update(table_name)
    end

    def set(data)
    end

    def delete
    end

    def run

        @full_table.each do |row|

            if @where_header && @where_value # if WHERE criteria specified
                if row[@where_header] == @where_value
                    puts row.to_h.slice(*@select_headers)
                end
            else # otherwise, print selected headers only
                puts row.to_h.slice(*@select_headers)
            end

        end
    end

end


# TEST HERE

# MySqliteRequest.new.from('small_test.csv').select('*').run
# MySqliteRequest.new.from('small_test.csv').select('Email').where('FirstName', 'Derick').run