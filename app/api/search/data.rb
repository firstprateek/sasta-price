module Search
  class Data < Grape::API

    resource :search_data do
      desc "do a post request"

      get do
        "Do a post request with seach_query as parameter"
      end

      desc "create a new employee"
        ## This takes care of parameter validation
      params do
        requires :search_query, type: String
      end
      ## This takes care of creating employee
      post do
        SastaPrice::Processor.process(params[:search_query])
      end
    end

  end
end
