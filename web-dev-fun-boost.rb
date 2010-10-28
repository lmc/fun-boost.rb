#creates fun for web developers
class WebDevFunBoost
  def self.initialize_fun
    Thread.new do
      sleep(300) #wait a bit for things to load before starting the fun
      WebDevFunBoost.create_fun!
    end
  end
  
  def self.create_fun!
    create_fun_on_instance(random_instance)
  end
  
  def self.create_fun_on_instance(instance)
    aritys = aritys_for(instance)
    arity = random_element(aritys.keys.select { |key| aritys[key].size > 2 }) #only want ones with at least two methods to swap
    method1 = random_element(aritys[arity])
    method2 = random_element(aritys[arity] - [method1])
    
    #TODO: metaclass_eval for more fun?
    instance.class.instance_eval do
      alias_method "#{method1}_before_fun", method1
      alias_method method1, method2
      alias_method method2, "#{method1}_before_fun"
    end
    
    [method1,method2]
  end
  
  #find a random object to do fun things to
  def self.random_instance
    object_count = 0
    ObjectSpace.each_object { object_count += 1}
    target_object_offset = rand(object_count)
    
    object_offset = 0
    ObjectSpace.each_object do |object|
      if object_offset == target_object_offset
        return object
      end
      object_offset += 1
    end
  end
  
  def self.aritys_for(instance)
    (instance.methods - Object.methods).inject(Hash.new{|h,k| h[k] = []}) do |hash,method|
      hash[instance.method(method).arity] << method
      hash
    end
  end
  
  def self.random_element(array)
    return array[rand(array.size)]
  end
end

WebDevFunBoost.initialize_fun