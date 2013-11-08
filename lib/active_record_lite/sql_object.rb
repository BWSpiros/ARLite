require_relative './associatable'
require_relative './db_connection' # use DBConnection.execute freely here.
require_relative './mass_object'
require_relative './searchable'

class SQLObject < MassObject
  # sets the table_name
  def self.set_table_name(table_name)
    @table_name = table_name
  end

  # gets the table_name
  def self.table_name
    @table_name
  end

  def self.objectify(table_name)
    c_name = (table_name.split('_').each{|word| word.capitalize!}.join[0..-2])
    Object::const_get(c_name)
  end

  def self.tablify(class_name)
    t_name = (class_name.split(/[A-Z]/).each{|word| word.downcase!}.join("_")+'s')
  end # Need non-destructive split


  # querys database for all records for this type. (result is array of hashes)
  # converts resulting array of hashes to an array of objects by calling ::new
  # for each row in the result. (might want to call #to_sym on keys)
  def self.all
    res = DBConnection.execute("SELECT * FROM #{@table_name}")
    #res.map!{|record| Object::const_get((@table_name.split('_').each{|word| word.capitalize!}.join[0..-2])).new(record)}
    res.map!{|record| self.new(record)}
    # res
  end

  # querys database for record of this type with id passed.
  # returns either a single object or nil.
  def self.find(id)
    self.new(DBConnection.execute("SELECT * FROM #{table_name} WHERE ID=#{id}")[0])
  end

  # executes query that creates record in db with objects attribute values.
  # use send and map to get instance values.
  # after, update the id attribute with the helper method from db_connection
  def create

  end

  # executes query that updates the row in the db corresponding to this instance
  # of the class. use "#{attr_name} = ?" and join with ', ' for set string.
  def update
  end

  # call either create or update depending if id is nil.
  def save
  end

  # helper method to return values of the attributes.
  def attribute_values
  end
end
