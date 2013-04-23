require 'spec_helper'

describe OrderLogsController do
  describe 'GET new' do
    it 'renders new template' do
      get :new
      response.should render_template("new")
    end
  end
end
