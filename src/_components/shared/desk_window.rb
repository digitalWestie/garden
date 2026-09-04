class Shared::DeskWindow < Bridgetown::Component
  INIT_STATES = %i[expanded collapsed inactive].freeze
  OPEN_STATES = %i[expanded collapsed].freeze

  def initialize(
    title:,
    id: nil,
    init: :expanded,
    activate_at: nil,
    activate_as: :expanded,
    deactivate_at: nil,
    collapse_before: nil,
    collapse_after: nil,
    persist: false,
    threshold: 0.35,
    class_name: nil,
    style: nil
  )
    @title = title
    @id = id
    @init = normalize_init(init)
    @activate_at = activate_at
    @activate_as = normalize_open(activate_as)
    @deactivate_at = deactivate_at
    @collapse_before = collapse_before
    @collapse_after = collapse_after
    @persist = persist
    @threshold = threshold
    @class_name = class_name
    @style = style
  end

  def active_at_init?
    @init != :inactive
  end

  def open_at_init?
    @init == :expanded
  end

  def scroll_controlled?
    @activate_at.present? ||
      @deactivate_at.present? ||
      @collapse_before.present? ||
      @collapse_after.present?
  end

  private

  def normalize_init(value)
    state = value.to_sym
    raise ArgumentError, "init must be one of #{INIT_STATES.join(", ")}" unless INIT_STATES.include?(state)

    state
  end

  def normalize_open(value)
    state = value.to_sym
    raise ArgumentError, "activate_as must be one of #{OPEN_STATES.join(", ")}" unless OPEN_STATES.include?(state)

    state
  end
end
