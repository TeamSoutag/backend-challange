# frozen_string_literal: true

class GasStationsController < ApplicationController
  before_action :set_gas_station, only: %i[show edit update destroy]

  def index
    @gas_stations = GasStation.includes(:address, :products)
                              .order(created_at: :desc).page(params[:page]).per(10)
  end

  def show; end

  def new
    @gas_station = GasStation.new
    @gas_station.build_address
    @gas_station.gas_station_products.build
  end

  def create
    @gas_station = GasStation.new(gas_station_params)
    if @gas_station.save
      redirect_to @gas_station, notice: 'Gas Station was successfully created.'
    else
      render :new
    end
  end

  def edit; end

  def update
    if @gas_station.update(gas_station_params)
      redirect_to @gas_station, notice: 'Gas Station was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @gas_station.destroy
    redirect_to gas_stations_url, notice: 'Gas Station was successfully deleted.'
  end

  private

  def set_gas_station
    @gas_station = GasStation.find(params[:id])
  end

  def gas_station_params
    params.require(:gas_station).permit(
      :name,
      address_attributes: %i[acronym street street_details number city state zip_code]
    )
  end
end
