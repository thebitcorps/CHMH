class Admin::ReviewsController < ApplicationController
  def index
    @interns = User.interns # que tengan procedimientos sin revisar
  end

  def show
    # aquí va toda la colección de procedures sin examineds, buscar un previous y next para revisar o hacer una lista y hacer bulk editing. Biatch!
  end
end
