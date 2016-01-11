module Slug

  def slug
    longname.gsub(/\W+/,'-').downcase
  end

end


module SlugClass

  def find_by_slug(slug)
    all.find{|o| o.slug == slug}
  end

end
