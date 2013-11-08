class Class
  def my_attr_accessor(*args)
    args.flatten!
#     p args
    args.each do |accessor|
      accessor = accessor[1..-1] if accessor[0] == "@"
      instance_variable_set("@#{accessor}", nil)
      define_method("#{accessor}=") do |x|
        instance_variable_set("@#{accessor}", x)
      end
      define_method("#{accessor}") do
        instance_variable_get("@#{accessor}")
      end
    end
  end
end

class MassObject
  # takes a list of attributes.
  # creates getters and setters.
  # adds attributes to whitelist.
  def self.my_attr_accessible(*attributes)
    @attributes = attributes
    @attributes = attributes.map { |attr| attr}# "@#{attr}"}
    my_attr_accessor(attributes)


  end

  # returns list of attributes that have been whitelisted.
  def self.attributes
    @attributes
  end

  # takes an array of hashes.
  # returns array of objects.
  def self.parse_all(results)
    result = []
    results.each{ |res| p res ; result << self.new(res) }
    result
  end

  # takes a hash of { attr_name => attr_val }.
  # checks the whitelist.
  # if the key (attr_name) is in the whitelist, the value (attr_val)
  # is assigned to the instance variable.
  def initialize(params = {})
    @attributes = self.class.attributes
    self.class.my_attr_accessor(@attributes)
    params.each do |k, v|
      if @attributes.include? k.to_sym
        self.send "#{k}=".to_sym, v
      else
        raise "There's no goddamned attribute named '#{k}'!"
      end
    end
  end
end

