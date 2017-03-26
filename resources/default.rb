default_action :create
actions :create, :create_if_missing, :touch, :delete

attribute :path, kind_of: String, name_attribute: true
attribute :remote_path, kind_of: String, required: true
attribute :bucket, kind_of: String, required: true
attribute :aws_access_key_id, kind_of: String, required: true
attribute :aws_secret_access_key, kind_of: String, required: true
attribute :owner, regex: Chef::Config[:user_valid_regex]
attribute :group, regex: Chef::Config[:group_valid_regex]
attribute :mode, kind_of: [Integer, String]
attribute :checksum, kind_of: [String]
attribute :backup, kind_of: [Integer, FalseClass]
attribute :use_etag, kind_of: [TrueClass, FalseClass]
attribute :use_etags, kind_of: [TrueClass, FalseClass]
attribute :use_last_modified, kind_of: [TrueClass, FalseClass]
attribute :use_conditional_get, kind_of: [TrueClass, FalseClass]
attribute :headers, kind_of: Hash
attribute :sensitive, kind_of: [TrueClass, FalseClass]
attribute :inherits, kind_of: [TrueClass, FalseClass]
attribute :rights, kind_of: Hash
attribute :atomic_update, kind_of: [TrueClass, FalseClass]
attribute :force_unlink, kind_of: [TrueClass, FalseClass]
attribute :manage_symlink_source, kind_of: [TrueClass, FalseClass]
# ftp_active_mode makes no sense with s3 so that attribute of remote_file is ignored

def initialize(*args)
  version = Chef::Version.new(Chef::VERSION[/^(\d+\.\d+\.\d+)/, 1])
  if version.major < 10 || ( version.major == 11 && version.minor < 6 )
    raise "sk_s3_file requires at least Chef 11.6.0, you are using #{Chef::VERSION}"
  end
  super
end
