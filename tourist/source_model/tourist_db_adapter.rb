require 'sqlite3'
require_relative '../model/tourist'
require_relative '../model/tourist_short'
require_relative '../../db'

class TouristDBAdapter
  def initialize
    @db = DB.instance
    @db.results_as_hash=true
  end

  def tourist_by_id(client_id)
    client_id = client_id
    result = @db.execute("SELECT * FROM tourist WHERE client_id = #{client_id.first.to_i}").first
    return Tourist.from_hash(result.transform_keys(&:to_sym)) if result
    nil
  end

  def add_tourist(client)
    result = @db.execute("SELECT MAX(client_id) FROM tourist")
    next_id = result.map(&:to_h).first.values.first
    @db.execute('INSERT INTO tourist (client_id, first_name, paternal_name, last_name, address, phone,email) VALUES (?, ?, ?, ?, ?, ?,? )', next_id+1, *tourist_fields(client))
  end



  # def add_client(client)
  #   stmt = @db.prepare('INSERT INTO client (client_id,first_name, paternal_name, last_name,address, phone
  #   ) VALUES (?, ?, ?, ?, ?, ?)')
  #   stmt.execute(*all_client_fields(client))
  # end

  def remove_tourist(client_id)
    @db.execute("DELETE FROM tourist WHERE client_id = #{client_id}")
  end



  def replace_tourist(client_id, client)
    fields = *tourist_fields(client)

    phone_value = fields[4].nil? ? 'NULL' : "'#{fields[4]}'"
    address_value = fields[3].nil? ? 'NULL' : "'#{fields[3]}'"
    email_value = fields[5].nil? ? 'NULL' : "'#{fields[5]}'"


    @db.execute("UPDATE client SET first_name = '#{fields[0]}',
                               paternal_name = '#{fields[1]}',
                               last_name = '#{fields[2]}',
                               address=#{address_value},
                               phone = #{phone_value},
                               email = #{email_value}
                               WHERE client_id = #{client_id.first.to_i}")
  end





  def tourist_count
    @db.results_as_hash=false
    res=@db.execute("Select COUNT(*) from tourist").first[0]
    @db.results_as_hash=true
    res
  end

  def get_k_n_tourist_short_list(k,n,data_list)
    clients = @db.execute("SELECT * FROM tourist LIMIT #{(k-1)*n}, #{n}")
    clients2=clients.map(&:to_h)
    slice = clients2.map { |h| TouristShort.new(Tourist.from_hash(h.transform_keys(&:to_sym))) }
    DataListTouristShort.new(slice) if data_list.nil?
    # student = student_list.student_by_id(1)
    # puts student.inspect
    data_list.replace_objects(slice)
    puts data_list
    data_list
  end

  private
  attr_accessor :client

  def tourist_fields(client)
    [client.first_name, client.paternal_name, client.last_name,client.address ,client.phone,client.email]
  end

end

