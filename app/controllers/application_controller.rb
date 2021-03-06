# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base

  # Be sure to include AuthenticationSystem in Application Controller instead
  include AuthenticatedSystem
  require 'csv'
  
  if Rails.env == "production"
    require "#{Rails.root}/lib/mercator" 
    include Mercator
  end

  rescue_from ActiveRecord::RecordNotFound, :with => :not_found

  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details

  $sort_table = {false => " asc", true =>" desc"}

  def use_citation
    session['citation'] = params[:id]
    redirect_to :controller => "sites"
  end
  
  def remove_citation
    session['citation'] = nil
    redirect_to :controller => "citations"
  end

  def not_found
    render :file => Rails.root.to_s + '/app/views/static/404.html', :layout => true, :status => 404
  end
 
  def sort_column(default_table = params[:controller],default_sort = 'id')
    if params[:sort] and params[:sort][/\./]
      sort = params[:sort].split(".",2)[1].sub('species','specie')
      table = params[:sort].split(".",2)[0]
    else
      sort = default_sort
      table = default_table
    end
    (eval table.sub('species','specie').classify.sub('Method','Methods').sub('Dbfile','DBFile')).column_names.include?(sort) ? "#{table}.#{sort}" : "id"
  end
 
  def sort_direction
    %w[asc desc].include?(params[:direction]) ?  params[:direction] : "asc"
  end

end
