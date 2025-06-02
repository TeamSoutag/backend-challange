# frozen_string_literal: true

class RefuelingsController < ApplicationController
  before_action :load_resources, only: %i[new create]
  before_action :set_refueling, only: %i[show edit update destroy]

  def index
    @refuelings = Refueling.includes(:user, :gas_station, :product)
                           .order(created_at: :desc).page(params[:page]).per(10)
  end

  def show
    respond_to do |format|
      format.html
      format.json { render json: @refueling }
    end
  end

  def new
    @refueling = Refueling.new
  end

  def create
    service = ::RefuelingServices::RefuelingCreator.new(
      user_id: refueling_params[:user_id],
      gas_station: GasStation.find(refueling_params[:gas_station_id]),
      product: Product.find(refueling_params[:product_id]),
      liters: refueling_params[:liters].to_f
    )

    @refueling = service.execute

    respond_to do |format|
      format.html do
        redirect_to @refueling, notice: 'Refueling was successfully created.'
      end
      format.json { render json: @refueling, status: :created }
    end
  rescue ActiveRecord::RecordInvalid => e
    respond_to do |format|
      format.html do
        flash.now[:alert] = e.message
        render :new
      end
      format.json { render json: { error: e.message }, status: :unprocessable_entity }
    end
  rescue StandardError => e
    respond_to do |format|
      format.html do
        flash.now[:alert] = "Error: #{e.message}"
        render :new
      end
      format.json { render json: { error: e.message }, status: :unprocessable_entity }
    end
  end

  def edit; end

  def update
    if @refueling.update(refueling_params)
      redirect_to @refueling, notice: 'Refueling was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    service = RefuelingServices::RefundUser.new(@refueling)

    if service.execute
      redirect_to refuelings_url, notice: 'Refueling deleted and balance refunded successfully.'
    else
      redirect_to refuelings_url, alert: 'Failed to delete refueling and refund balance.'
    end
  end

  private

  def set_refueling
    @refueling = Refueling.find(params[:id])
  end

  def load_resources
    @gas_stations = GasStation.all
    @products = Product.all
  end

  def refueling_params
    params.require(:refueling).permit(:gas_station_id, :product_id, :user_id, :liters)
  end
end
