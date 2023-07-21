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

        @csv_name = csv_name
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
MySqliteRequest.new.from('small_test.csv').select('Gender', 'Email', 'UserName').run