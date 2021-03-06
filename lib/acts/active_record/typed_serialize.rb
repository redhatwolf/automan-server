class ActiveRecord::Base
  def self.typed_serialize(attr_name, class_name)
    serialize(attr_name, class_name)

    define_method(attr_name) do
      expected_class = self.class.serialized_attributes[attr_name.to_s]
      
      is_type = begin
      	(value = super).is_a?(expected_class)  	
      rescue NoMethodError => e
      	false      	
      end
      
      if is_type
        value
      else
        send("#{attr_name}=", expected_class.new)
      end
    end
  end
end