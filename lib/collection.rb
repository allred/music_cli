class Collection
  attr_accessor :collection

  def initialize(args={})
    @collection = args['container'] || {} 
  end
end
