SearchResult = Struct.new(:result, :query, :priority, :blurb) do
  alias :read_attribute_for_serialization :send
end
