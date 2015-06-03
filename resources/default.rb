default_action :create
actions :create, :create_if_missing, :touch, :delete

attribute :path, kind_of: String, name_attribute: true
attribute :remote_path, kind_of: String, required: true
attribute :bucket, kind_of: String, required: true
attribute :aws_access_key_id, kind_of: String, default: nil
attribute :aws_secret_access_key, kind_of: String, default: nil
attribute :owner, regex: Chef::Config[:user_valid_regex], default: nil
attribute :group, regex: Chef::Config[:group_valid_regex], default: nil
attribute :mode, kind_of: [Integer, String], default: nil
attribute :checksum, kind_of: [String], default: nil
attribute :backup, kind_of: [Integer, FalseClass], default: nil
attribute :use_etag, kind_of: [TrueClass, FalseClass], default: nil
attribute :use_etags, kind_of: [TrueClass, FalseClass], default: nil
attribute :use_last_modified, kind_of: [TrueClass, FalseClass], default: nil
attribute :use_conditional_get, kind_of: [TrueClass, FalseClass], default: nil
attribute :headers, kind_of: Hash, default: nil
attribute :sensitive, kind_of: [TrueClass, FalseClass], default: nil
attribute :inherits, kind_of: [TrueClass, FalseClass], default: nil
attribute :rights, kind_of: Hash, default: nil
attribute :atomic_update, kind_of: [TrueClass, FalseClass], default: nil
attribute :force_unlink, kind_of: [TrueClass, FalseClass], default: nil
attribute :manage_symlink_source, kind_of: [TrueClass, FalseClass], default: nil
# ftp_active_mode makes no sense with s3 so that attribute of remote_file is ignored

def initialize(*args)
  version = Chef::Version.new(Chef::VERSION[/^(\d+\.\d+\.\d+)/, 1])
  if version.major < 10 || ( version.major == 11 && version.minor < 6 )
    raise "sk_s3_file requires at least Chef 11.6.0, you are using #{Chef::VERSION}"
  end
  super
end
