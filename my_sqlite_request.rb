require 'csv'

class MySqliteRequest
    
    def initialize
    end

    def from(csv_name)
        @csv_name = csv_name
        @full_table = CSV.parse(File.read(csv_name), headers: true)
        @full_headers = @full_table.headers
        @select_headers = Array.new
        return self
    end

    def select(column_name)

        if column_name == "*"
            @select_headers = @full_headers
            return self

        elsif @full_headers.include?(column_name)
            @select_headers << column_name
            return self
        end

    end
    # OR
    # def select(column_name_a, column_name_b)
    # end

    def run
        # puts @headers.join('|')
        @full_table.drop(1).each do |row|
            puts @select_headers.map { |header| row[header] }.join('|')
        end
    end

    def where(column_name, criteria)
    end

    def join(column_on_db_a, filename_db_b, column_on_db_b)
    end

    def order(order, column_name)
    end

    def insert(table_name)
    end

    def values(data)
    end

    def update(table_name)
    end

    def set(data)
    end

    def delete
    end



end


# TEST HERE

request = MySqliteRequest.new
request = request.from("small_test.csv")
request = request.select("FirstName")
request = request.run