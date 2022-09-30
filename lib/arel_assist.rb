# frozen_string_literal: true

require_relative "arel_assist/version"
require "active_record"

module ArelAssist
  extend self

  def self.included(base)
    base.extend self
  end

  # Generates SQL: COUNT("<table-name>"."<column-name>")
  #
  # @example
  #   arel_count(Post.arel_table[:days_active])
  #   #=> 'COUNT("member_summaries"."days_active")'
  #
  # @param [Arel::Attributes::Attribute] field
  # @return [Arel::Nodes::NamedFunction]
  def arel_count(field)
    Arel::Nodes::NamedFunction.new("COUNT", [field])
  end

  # Generates SQL: date_trunc('<date-part>', "<table-name>"."<column-name>")
  #
  # @example
  #   arel_date_trunc('day', MemberSummary.arel_table[:created_at])
  #   #=> "date_trunc('day', \"member_summaries\".\"created_at\")"
  #
  # @param [String,Symbol] date_part - one of the following: year, month, day, hour, minute, second, millisecond, microsecond
  # @param [Arel::Attributes::Attribute] field
  # @return [Arel::Nodes::NamedFunction]
  def arel_date_trunc(date_part, field)
    Arel::Nodes::NamedFunction.new("date_trunc", [sqlv(date_part), field])
  end

  # Generates SQL: MAX("<table-name>"."<column-name>")
  #
  # @example
  #   arel_max(Activity.arel_table[:occurred_at])
  #   #=> 'MAX("activities"."occurred_at")'
  #
  # @param [Arel::Attributes::Attribute] field
  # @return [Arel::Nodes::NamedFunction]
  def arel_max(field)
    Arel::Nodes::NamedFunction.new("MAX", [field])
  end

  # Generates SQL: MIN("<table-name>"."<column-name>")
  #
  # @example
  #   arel_max(Activity.arel_table[:occurred_at])
  #   #=> 'MIN("activities"."occurred_at")'
  #
  # @example with 'AS'
  #   arel_max(Activity.arel_table[:occurred_at]).as("first_activity_occurred_at")
  #   #=> 'MIN("activities"."occurred_at") AS first_activity_occurred_at'
  #
  # @param [Arel::Attributes::Attribute] field
  # @return [Arel::Nodes::NamedFunction]
  def arel_min(field)
    Arel::Nodes::NamedFunction.new("MIN", [field])
  end

  def sqlv(node)
    case node
    when ->(n) { n.respond_to?(:to_sql) }
      node.to_sql
    when Arel::Attributes::Attribute
      Arel::Nodes::SqlLiteral.new("\"#{node.relation.name}\".\"#{node.name}\"")
    when Array, Range
      value = node.map { |x| x.is_a?(String) ? "'#{x}'" : x }.join(",")
      Arel::Nodes::SqlLiteral.new "ARRAY[#{value}]"
    when Time, DateTime, Date, String
      Arel::Nodes.build_quoted node
    else
      Arel::Nodes::SqlLiteral.new node.to_s
    end
  end
end
