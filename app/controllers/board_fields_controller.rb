
class BoardFieldsController < ApplicationController
skip_before_action :verify_authenticity_token

def update_drag
  p params
end

end