module UsersHelper
  def gravatar_for(user, options = { :size => 50 })
    gravatar_image_tag(user.email.downcase, :alt => user.name,
                                            :class => "gravatar",
                                            :gravatar => options)
  end
  
  private
  
    def deny_access
      redirect_to signin_path, :notice => "Please sign in to view this page."
    end
end
