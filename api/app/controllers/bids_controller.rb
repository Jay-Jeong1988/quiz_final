class BidsController < ApplicationController
    before_action :authenticate_user!

    def create
        bid = Bid.new bid_params
        bid.auction = Auction.find params[:auction_id]
        bid.user = current_user
        if bid.auction.user != current_user && !bid.auction.draft?
            if bid.save!
                BidMailer.notify_auction_owner(bid).deliver_later(wait: 01.seconds)
                render json: bid 
            end
        else
            unauthorized_user
        end
    end

    def destroy
        bid = Bid.find params[:id]
        if bid.user == current_user 
            bid.destroy
        else
            unauthorized_user
        end
    end

    private

    def bid_params
        params.require(:bid).permit :price
    end

end
