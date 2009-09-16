module EasyProfiler
end

require 'logger'

base_dir = File.dirname(__FILE__)
require "#{base_dir}/easy_profiler/profile"
require "#{base_dir}/easy_profiler/profile_instance_base"
require "#{base_dir}/easy_profiler/profile_instance"
require "#{base_dir}/easy_profiler/no_profile_instance"

if Object.const_defined?(:ActionController)
  require "#{base_dir}/easy_profiler/firebug_logger"
  require "#{base_dir}/easy_profiler/action_controller_extensions"
  
  ActionController::Base.send(:include, EasyProfiler::ActionControllerExtensions)
end

module Kernel
  # Wraps code block into the profiling session.
  #
  # See the <tt>EasyProfiler::Profile.start</tt> method for
  # parameters description.
  #
  # Example:
  #   easy_profiler('sleep', :enabled => true) do |p|
  #     sleep 1
  #     p.progress('sleep 1')
  #     p.debug('checkpoint reached')
  #     sleep 2
  #     p.progress('sleep 2')
  #   end
  def easy_profiler(name, options = {})
    profiler = EasyProfiler::Profile.start(name, options)
    yield profiler
  ensure
    EasyProfiler::Profile.stop(name) if profiler
  end
end
