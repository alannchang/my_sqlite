require 'csv'

class MySqliteRequest
    
    def initialize

        @select_headers = []
        @select_rows = nil

        @where_header = nil
        @where_value = nil
        
        @ascending = nil
        @descending = nil

        @insert_table = nil
    
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
        @insert_csv = table_name
        @full_table = CSV.parse(File.read(table_name), headers: true)
        @full_headers = @full_table.headers
        return self
    end

    def values(*data)
        @new_row = CSV::Row.new(@full_headers, data)
        return self
    end

    def update(table_name)
        return self
    end

    def set(data)
        return self
    end

    def delete

        return self
    end

    def run

        if @insert_csv
            @full_table << @new_row
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
    end

end


# TEST HERE

# MySqliteRequest.new.from('small_test.csv').select('*').run
# MySqliteRequest.new.from('small_test.csv').select('Gender', 'Email', 'UserName').where('FirstName', 'Carl').run
MySqliteRequest.new.insert('small_test.csv').values("Male","Bob","Dylan","bob","rollingstone@hotmail.com","90","Somewhere","Apple iPhone","1","2020-03-05 15:19:48").run
