if Rails.env.development?
  # Pre-loaded our STI subclasses in development so Kase.descendants is properly populated
  %w[kase coaching_kase training_kase].each do |c|
    require_dependency File.join("app","models","#{c}.rb")
  end
end
