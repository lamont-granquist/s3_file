require 'time'
require 'openssl'
require 'base64'
require 'json'

class S3UrlGenerator
  attr_reader :url, :headers

  def initialize(bucket, path, aws_access_key_id, aws_secret_access_key)
    now = Time.now.utc.strftime('%a, %d %b %Y %H:%M:%S GMT')
    string_to_sign = "GET\n\n\n%s\n" % [now]

    # if credentials not set, try instance profile
    token = nil
    if aws_access_key_id.nil? && aws_secret_access_key.nil?
      require 'open-uri'
      instance_profile_base_url = 'http://169.254.169.254/latest/meta-data/iam/security-credentials/'
      begin
        instance_profiles = open(instance_profile_base_url).read
      rescue OpenURI::HTTPError
        raise ArgumentError, 'No credentials provided and no instance profile on this machine.'
      end
      instance_profile_name = instance_profiles.split.first
      instance_profile = JSON.load(open(instance_profile_base_url + instance_profile_name).read)

      aws_access_key_id = instance_profile['AccessKeyId']
      aws_secret_access_key = instance_profile['SecretAccessKey']
      token = instance_profile['Token']
    end

    string_to_sign += "x-amz-security-token:#{token}\n" if token
    string_to_sign += "/%s%s" % [bucket, path]

    digest = OpenSSL::Digest.new('sha1')
    signed = OpenSSL::HMAC.digest(digest, aws_secret_access_key, string_to_sign)
    signed_base64 = Base64.encode64(signed)

    auth_string = 'AWS %s:%s' % [aws_access_key_id, signed_base64]

    @url = 'https://%s.s3.amazonaws.com%s' % [bucket, path]
    @headers = { 'date' => now, 'authorization' => auth_string }
    @headers['x-amz-security-token'] = token if token
  end
end
