if !Rails.configuration.action_controller.perform_caching?
  # Pre-loaded our STI subclasses in development so the descendants arrays are properly populated
  %w[kase coaching_kase customer_service_kase training_kase disposition coaching_kase_disposition customer_service_kase_disposition training_kase_disposition].each do |c|
    require_dependency Rails.root.join("app","models","#{c}.rb").to_s
  end
end
