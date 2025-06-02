# frozen_string_literal: true

class UsersController < ApplicationController
  before_action :set_user, only: %i[show edit update destroy]

  def index
    @users = User.includes(:wallet).order(created_at: :desc).page(params[:page]).per(10)
  end

  def show
    @refuelings = @user.refuelings.order(created_at: :desc)
  end

  def new
    @user = User.new
    @user.build_wallet
  end

  def create
    @user = User.new(user_params)

    @user.build_wallet(balance: 0) unless @user.wallet

    if @user.save
      redirect_to @user, notice: 'User was successfully created.'
    else
      render :new
    end
  end

  def edit
    @user.build_wallet unless @user.wallet
  end

  def update
    if @user.update(user_params)
      redirect_to @user, notice: 'User was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @user.destroy
    redirect_to users_url, notice: 'User was successfully deleted.'
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(
      :name,
      :email,
      wallet_attributes: %i[id balance _destroy]
    )
  end
end
