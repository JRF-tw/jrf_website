class Setting < Settingslogic
  source "#{Rails.root}/config/config.yml"
  namespace Rails.env

  # Settingslogic 用 YAML.load 讀檔，Ruby 3.1 起 YAML.load 改成安全模式：不接受 alias
  # （config.yml 的 <<: *defaults）也不接受日期、symbol 等型別。config.yml 是自己維護的設定檔，
  # 所以讀檔這一步自己做，用跟 Ruby 2.7 一樣不限制的 unsafe_load，再把目前環境的設定交給 Settingslogic
  def initialize(hash_or_file = self.class.source, section = nil)
    if hash_or_file.is_a?(String)
      yaml = YAML.unsafe_load(ERB.new(File.read(hash_or_file)).result)
      return super(yaml.fetch(self.class.namespace), section || hash_or_file)
    end
    super
  end
end
