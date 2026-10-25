class Setting < Settingslogic
  source "#{Rails.root}/config/config.yml"
  namespace Rails.env

  # Settingslogic 用 YAML.load 讀檔，Ruby 3.1 起預設不接受 alias（config.yml 的 <<: *defaults），
  # 所以讀檔這一步自己做，再把目前環境的設定交給 Settingslogic
  def initialize(hash_or_file = self.class.source, section = nil)
    if hash_or_file.is_a?(String)
      yaml = YAML.load(ERB.new(File.read(hash_or_file)).result, aliases: true)
      return super(yaml.fetch(self.class.namespace), section || hash_or_file)
    end
    super
  end
end
