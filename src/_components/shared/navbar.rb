class Shared::Navbar < Bridgetown::Component
  def initialize(metadata:, resource:)
    @metadata, @resource = metadata, resource
  end

  def show_theme_link?
    Bridgetown.env.development?
  end
end
