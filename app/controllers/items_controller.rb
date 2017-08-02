class ItemsController < ApplicationController
  before_action :require_user_logged_in
  
  def new
    @items = []
    
    @keyword = params[:keyword]
    if @keyword 
      results = RakutenWebService::Ichiba::Item.search({
        keyword: @keyword,
        imageFlag: 1,
        hits: 20,
      })
      
      results.each do |result|
        item = Item.new(read(result))
        @items << item
      end
    end
  end
  
  private
  
  def read(result)
    code = result['code']
    name = result['itemName']
    url = result['url']
    image_url = result['mediumImageUrls'].first['imageUrl'].gsub('?_ex=128x128', '')
  
    return {
      code: code,
      name: name,
      url: url,
      image_url: image_url,
    }
  end
end
