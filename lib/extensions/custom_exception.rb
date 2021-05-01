class CustomException < StandardError
  def initialize(msg = "an exception has occurred", exception_type = "custom")
    @exception_type = exception_type
    super(msg)
  end

  def exception_type
    @exception_type
  end
end
