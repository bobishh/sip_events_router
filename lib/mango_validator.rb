class MangoValidator
  def initialize(params, key, salt)
    @key = key
    @salt = salt
    @json_string = params[:json]
    @sign = params[:sign]
  end

  def valid?
    sha.hexdigest(@key + @json_string + @salt) == @sign
  end

  private

  def sha
    @sha256 ||= Digest::SHA256.new
  end
end
