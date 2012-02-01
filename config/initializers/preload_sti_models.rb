if Rails.env.development?
  # Make sure we preload the parent and children classes in development
  %w[kase coaching_kase training_kase].each do |c|
    require_dependency File.join("app","models","#{c}.rb")
  end
end
