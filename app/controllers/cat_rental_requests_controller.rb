class CatRentalRequestsController < ApplicationController
  before_action :is_owner, only: [:approve, :deny]

  def new
    @rental_request = CatRentalRequest.new
  end

  def create
    @rental_request = CatRentalRequest.new(cat_rental_request_params)
    @rental_request.user = current_user
    if @rental_request.save
      redirect_to cat_url(@rental_request.cat)
    else
      flash.now[:errors] = @rental_request.errors.full_messages
      render :new
    end
  end

  def approve
    current_cat_rental_request.approve!
    redirect_to cat_url(current_cat)
  end

  def deny
    current_cat_rental_request.deny!
    redirect_to cat_url(current_cat)
  end

  private

  def current_cat_rental_request
    @rental_request ||=
      CatRentalRequest.includes(:cat).find(params[:id])
  end

  def current_cat
    current_cat_rental_request.cat
  end

  def cat_rental_request_params
    params.require(:cat_rental_request)
      .permit(:cat_id, :end_date, :start_date, :status)
  end

  def is_owner
    if current_user.nil? || !current_user.cats.include?(current_cat_rental_request.cat)
      flash[:errors] ||= []
      flash[:errors] << "You must be the owner of this cat to take action."
      redirect_to cat_url(params[:id])
      return
    end
  end
end
