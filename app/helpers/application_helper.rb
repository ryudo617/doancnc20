module ApplicationHelper
  def full_title(page_title = '')
    base_title = "Fruit shop"
    if page_title.empty?
      base_title
    else
      page_title + " | " + base_title
    end
  end
  
  def categories_list_head
    categories = Category.all
  end
  
  def wishlists
    unless current_user.nil?
      @wishlists = WishList.where(user_id: current_user.id).first(3)
    end
  end

  def resource_name
    :user
  end

  def resource
    @resource ||= User.new
  end

  def devise_mapping
   @devise_mapping ||= Devise.mappings[:user]
  end
end
