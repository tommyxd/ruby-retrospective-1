class Array
  def to_hash
    inject({}) { |hash, item| hash[item[0]] = item[1]; hash }
  end
  
  def index_by
    inject({}) { |hash, item| hash[yield item] = item; hash }
  end
  
  def subarray_count(subarray)
    each_cons(subarray.length).count(subarray)
  end
  
  def occurences_count
    inject(Hash.new(0)) { |hash, item| hash[item] = count(item); hash }
  end
end