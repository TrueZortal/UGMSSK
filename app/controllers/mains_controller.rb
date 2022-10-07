# frozen_string_literal: true

class MainsController < ApplicationController
  before_action :restrict_access

  def index; end
end
