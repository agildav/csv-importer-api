class UnauthorizedException < StandardError
  def initialize(msg = "not authorized", exception_type = "unauthorized")
    @exception_type = exception_type
    super(msg)
  end

  def exception_type
    @exception_type
  end
end
