# frozen_string_literal: true

class ProductsController < ApplicationController
  before_action :set_product, only: %i[show edit update destroy]

  def index
    @products = Product.includes(:gas_stations)
                       .order(created_at: :desc).page(params[:page]).per(10)
  end

  def show
    @gas_station_products = @product.gas_station_products.includes(:gas_station)
  end

  def new
    @product = Product.new
    @product.gas_station_products.build
    @gas_stations = GasStation.all
  end

  def create
    @product = Product.new(product_params)

    if @product.save
      redirect_to @product, notice: 'Product was successfully created.'
    else
      @gas_stations = GasStation.all
      render :new
    end
  end

  def edit
    @product.gas_station_products.build if @product.gas_station_products.empty?
    @gas_stations = GasStation.all
  end

  def update
    if @product.update(product_params)
      redirect_to @product, notice: 'Product was successfully updated.'
    else
      @gas_stations = GasStation.all
      render :edit
    end
  end

  def destroy
    @product.destroy
    redirect_to products_url, notice: 'Product was successfully deleted.'
  end

  private

  def set_product
    @product = Product.find(params[:id])
  end

  def product_params
    params.require(:product).permit(
      :name,
      :discount,
      gas_station_products_attributes: %i[
        id gas_station_id price_per_liter _destroy
      ]
    )
  end
end
