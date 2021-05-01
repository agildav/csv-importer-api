class ForbiddenException < StandardError
  def initialize(msg = "not authorized", exception_type = "forbidden")
    @exception_type = exception_type
    super(msg)
  end

  def exception_type
    @exception_type
  end
end
