# frozen_string_literal: true

class <%= name %>Policy < ApplicationPolicy
  relation_scope do |scope|
    scope
  end

  def index?
    #TODO - Policy goes here
  end

  def show?
    #TODO - policy goes here
  end

  def create?
    #TODO - Policy goes here
  end

  def update?
    #TODO - Policy goes here
  end

  def destroy?
    #TODO - Policy goes here
  end
end