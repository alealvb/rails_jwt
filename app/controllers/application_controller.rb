class ApplicationController < ActionController::API
  # con este "before_action", "authenticate_request" va a ser
  # ejecutado justo antes de cualquier accion dentro de nuestros controladores,
  # ya que todos los controladores heredan de ApplicationController (que es esta clase)
  before_action :authenticate_request

  private

  # este metodo verifica la peticion venga con un token para autenticar un usuario
  def authenticate_request
    # optenemos el token que viene en el header de la peticion
    token = request.headers['Authorization']

    # recuperamos la informacion que esta dentro del token
    # en nuestro caso un hash con el id del token junto con la fecha de expiracion del token
    user_data = JsonWebToken.decode(token)

    # buscamos al usuario con el id dentro de user_data y lo asignamos como @user
    @user = User.find_by(id: user_data[:id])
  end
end