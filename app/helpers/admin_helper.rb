module AdminHelper
  def user_roles(user, level)
    if user.is_outside_user then
      levels = [["Outside", 25]] 
    else
      levels = [["Admin", 100], ["Editor", 50], ["Viewer", 0]] 
    end
    levels << ["Deleted", -1] if level == -1
    levels
  end
end
