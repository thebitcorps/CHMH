class Admin::ReviewsController < ApplicationController
  def index
    users = User.interns # que tengan procedimientos sin revisar
    @interns = users.select { |i| i.procedures.floating_around }
    # @interns = User.find(procedures)
  end

  def show
    @user = User.find(params[:user])
    @procedures = Procedure.unexamined(@user)
    # aquí va toda la colección de procedures sin examineds, buscar un previous y next para revisar o hacer una lista y hacer bulk editing. Biatch!
  end
end
