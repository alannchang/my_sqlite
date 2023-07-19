require 'csv'

class MySqliteRequest
    
    def initialize
        @csv_name = ""
        @table = nil
        @headers = nil 
    end

    def run
        puts @headers.join('|')
        @csv_table.drop(1).each do |row|
            puts @headers.map { |header| row[header] }.join('|')
        end
    end
        
    def from(csv_name)
        @csv_name = csv_name
        @csv_table = CSV.parse(File.read(csv_name), headers: true)
        @headers = @csv_table.headers
        return self
    end

    def select(column_name)
        if column_name == "*"
            return self  
        end  
    end
    # OR
    # def select(column_name_a, column_name_b)
    # end

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

# csv_name = "small_test.csv"

# csv_table = CSV.parse(File.read(csv_name), headers: true)
# headers = csv_table.headers

# puts headers.join('|')
# csv_table.drop(1).each do |row|
#   puts headers.map { |header| row[header] }.join('|')
# end

request = MySqliteRequest.new
request = request.from("small_test.csv")
request = request.select("*")
request = request.run