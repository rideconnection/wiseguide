if !Rails.configuration.action_controller.perform_caching?
  # Pre-loaded our STI subclasses in development so Kase.descendants is properly populated
  %w[kase coaching_kase training_kase].each do |c|
    require_dependency Rails.root.join("app","models","#{c}.rb").to_s
  end
end
