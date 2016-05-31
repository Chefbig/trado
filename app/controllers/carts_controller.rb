class CartsController < ApplicationController
    include CartBuilder
    skip_before_action :authenticate_user!

    def mycart
        set_cart_totals
        set_cart_session
        render theme_presenter.page_template_path('carts/mycart'), layout: theme_presenter.layout_template_path
    end

    def checkout
        set_order
        set_grouped_countries
        build_addresses
        set_cart_totals
        set_cart_session
        set_delivery_services
        render theme_presenter.page_template_path('carts/checkout'), layout: theme_presenter.layout_template_path
    end


    def update
        current_cart.update(params[:cart])
        render json: { delivery: current_cart.delivery }, status: 200
        # format.js { render partial: theme_presenter.page_template_path('carts/delivery_service_prices/estimate/success'), format: [:js] }
    end

    def delivery_service_prices
        set_delivery_service_prices
        render json: { table: render_to_string(partial: theme_presenter.page_template_path("carts/delivery_service_prices/table"), format: [:html], locals: { delivery_service_prices: @delivery_service_prices }) }, status: 200
    end

    private

    def build_addresses
        @order.build_delivery_address
        @order.build_billing_address
    end

    def set_delivery_service_prices
        @delivery_service_prices = DeliveryServicePrice.find_collection(current_cart.delivery_service_ids, params[:country_id])
    end

    def set_grouped_countries
        @grouped_countries = [Country.popular.map{ |country| [country.name, country.name] }, Country.all.order('name ASC').map{ |country| [country.name, country.name] }] 
    end
end