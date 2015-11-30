require "yaml"

class Wraith::Wraith
  attr_accessor :config

  def initialize(config, yaml_passed = false)
    yaml_string = yaml_passed ? config : open_config_file(config)
    @config = YAML.load yaml_string
  rescue
    puts "unable to find config at #{config}"
    exit 1
  end

  def open_config_file(config_name)
    if File.exist?(config_name) && File.extname(config_name) == ".yaml"
      File.open config_name
    else
      File.open "configs/#{config_name}.yaml"
    end
  end

  def directory
    # Legacy support for those using array configs
    @config["directory"].is_a?(Array) ? @config["directory"].first : @config["directory"]
  end

  def history_dir
    @config["history_dir"]
  end

  def engine
    @config["browser"]
  end

  def snap_file
    @config["snap_file"] || snap_file_from_engine(engine)
  end

  def snap_file_from_engine(engine)
    engine = (engine.is_a? Hash) ? engine.values.first : engine
    path_to_js_templates = File.dirname(__FILE__) + '/javascript'
    case engine
    when "phantomjs"
      path_to_js_templates + "/phantom.js"
    when "casperjs"
      path_to_js_templates + "/casper.js"
    # @TODO - add a SlimerJS option
    else
      abort "Wraith does not recognise the browser engine '#{engine}'"
    end
  end

  def before_capture
    @config["before_capture"] || "false"
  end

  def widths
    @config["screen_widths"]
  end

  def domains
    @config["domains"]
  end

  def base_domain
    domains[base_domain_label]
  end

  def comp_domain
    domains[comp_domain_label]
  end

  def base_domain_label
    domains.keys[0]
  end

  def comp_domain_label
    domains.keys[1]
  end

  def spider_file
    @config["spider_file"] ? @config["spider_file"] : "spider.txt"
  end

  def spider_days
    @config["spider_days"]
  end

  def sitemap
    @config["sitemap"]
  end

  def spider_skips
    @config["spider_skips"]
  end

  def paths
    @config["paths"]
  end

  def fuzz
    @config["fuzz"]
  end

  def highlight_color
    @config["highlight_color"] ? @config["highlight_color"] : "blue"
  end

  def mode
    if %w(diffs_only diffs_first alphanumeric).include?(@config["mode"])
      @config["mode"]
    else
      "alphanumeric"
    end
  end

  def threshold
    @config["threshold"] ? @config["threshold"] : 0
  end

  def gallery_template
    default = 'basic_template'
    if @config["gallery"].nil?
      default
    else
      @config["gallery"]["template"] || default
    end
  end

  def thumb_height
    default = 200
    if @config["gallery"].nil?
      default
    else
      @config["gallery"]["thumb_height"] || default
    end
  end

  def thumb_width
    default = 200
    if @config["gallery"].nil?
      default
    else
      @config["gallery"]["thumb_width"] || default
    end
  end

  def phantomjs_options
    @config["phantomjs_options"]
  end
end
