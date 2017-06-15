class UserStocksController < ApplicationController
  before_action :set_user_stock, only: [:show, :edit, :update, :destroy]

  # GET /user_stocks
  # GET /user_stocks.json
  def index
    @user_stocks = UserStock.all
  end

  # GET /user_stocks/1
  # GET /user_stocks/1.json
  def show
  end

  # GET /user_stocks/new
  def new
    @user_stock = UserStock.new
  end

  # GET /user_stocks/1/edit
  def edit
  end

  # POST /user_stocks
  # POST /user_stocks.json
  def create
    if params[:stock_id].present?
      # the stock is already in the database
      @user_stock = UserStock.new(stock_id: params[:stock_id], user: current_user)
    else
      # the stock is not in the database, so we should find it
      # try to find the stock by its ticker again in our database
      stock = Stock.find_by_ticker(params[:stock_ticker])
      if stock
        # the stock could be found by ticker
        @user_stock = UserStock.new(user: current_user, stock: stock)
      else
        # the stock is really not in our database
        stock = Stock.new_from_lookup(params[:stock_ticker])
        # save the stock, so that we do not have to look up from library next time
        if stock.save
          @user_stock = nil
          @user_stock = UserStock.new(user: current_user, stock: stock)
        else
          flash[:error] = 'Stock is not availible'
        end
      end
    end

    respond_to do |format|
      if @user_stock.save
        format.html { redirect_to my_portfolio_path, notice: "Stock #{@user_stock.stock.ticker} was successfully added." }
        format.json { render :show, status: :created, location: @user_stock }
      else
        format.html { render :new }
        format.json { render json: @user_stock.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /user_stocks/1
  # PATCH/PUT /user_stocks/1.json
  def update
    respond_to do |format|
      if @user_stock.update(user_stock_params)
        format.html { redirect_to @user_stock, notice: 'User stock was successfully updated.' }
        format.json { render :show, status: :ok, location: @user_stock }
      else
        format.html { render :edit }
        format.json { render json: @user_stock.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /user_stocks/1
  # DELETE /user_stocks/1.json
  def destroy
    @user_stock.destroy
    respond_to do |format|
      format.html { redirect_to my_portfolio_path, notice: 'Stock was successfully removed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user_stock
      @user_stock = UserStock.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_stock_params
      params.require(:user_stock).permit(:user_id, :stock_id)
    end
end
