module Names

  def set_manufacturer_name(name)
    self.instance_variable_set(:@manufacturer_name, name)
  end

  def get_manufacturer_name
    return self.instance_variable_get(:@manufacturer_name) if self.instance_variable_defined?(:@manufacturer_name)
    puts 'Manufacturer name isn`t set'
  end
end
