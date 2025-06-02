# frozen_string_literal: true

class AddressesController < ApplicationController
  before_action :set_address, only: %i[show edit update destroy]

  def index
    @addresses = Address.order(created_at: :desc).page(params[:page]).per(10)
  end

  def show; end

  def new
    @address = Address.new
  end

  def create
    @address = Address.new(address_params)
    if @address.save
      redirect_to @address, notice: 'Address was successfully created.'
    else
      render :new
    end
  end

  def edit; end

  def update
    if @address.update(address_params)
      redirect_to @address, notice: 'Address was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @address.destroy
    redirect_to addresses_url, notice: 'Address was successfully deleted.'
  end

  private

  def set_address
    @address = Address.find(params[:id])
  end

  def address_params
    params.require(:address).permit(:acronym, :street, :street_details, :number, :city, :state, :zip_code)
  end
end
