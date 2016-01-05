
module Parentable

  def level
     i = 0
     f = self
     if not f.is_orphan?
       begin
         f = f.parent
         i += 1
       end until f.is_orphan?
     end
     return i
  end

  def is_orphan?
    self.parent == nil
  end

  def has_children?
     self.children.to_a != []
  end

  def self_and_descendants
     if has_children?
        descentants =  children.inject([]) do |result,child|
            result + child.self_and_descendants
        end
        return [self] + descentants
     else
        return [self]
     end
  end

  def descendants
    self.self_and_descendants - [self]
  end

  def destroy_self_and_descendants
    if self.has_children?
     self.self_and_descendants.each do |d|
      d.destroy
     end
    else
     self.destroy
    end
  end

  def self_and_siblings
     if self.is_orphan?
       self.class.orphans.to_a
     else
       self.parent.children.to_a
     end
  end

  def siblings
     self.self_and_siblings - [self]
  end

  def reassign_children
     if self.has_children?
      self.children.each do |c|
       c.parent_id = self.parent_id
       c.save
      end
     end
  end

end


module ParentableClass

  def orphans
     self.where(parent_id:nil)
  end

end
