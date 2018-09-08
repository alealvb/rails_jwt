class UsersController < ApplicationController
  # nos aseguramos que a las acciones "create" y "login" no se les pida autenticarse
  # (no se les pida un token ya que en ambos caso no lo deberian tener)
  skip_before_action :authenticate_request, only: [:create, :login]

  def create
    # creamos un usuario nuevo y respondemos dependiendo si se creo o no
    @user = User.create(user_params)
    if @user.persisted?
      render(json: {
               message: 'Usuario creado!',
               user: @user
             },
             status: :created)
    else
      render(json: {
               message: 'Usuario no creado',
               errors: @user.errors.messages
             },
             status: :bad)
    end
  end

  def login
    # buscamos al usuario por email ya que en el modelo colocamos que este es unico
    @user = User.find_by(email: params[:email])
    # authenticate es un metodo que nos da la gema bcrypt
    # recibe el password y lo compara con el password cifrado que esta en nuestra base de datos
    if @user&.authenticate(params[:password])
      # si el email coincide con el password entonces generamos un token
      generate_token
    else
      render json: { message: 'Credenciales invalidas' }, status: :unauthorized
    end
  end

  def show
    # si el id en el token coincide con un usuario en nuestra base de datos entonces
    # mostramos al usuario
    if @user
      render json: @user
    else
      render json: { error: 'Este usuario no existe' }, status: :not_found
    end
  end

  private

  def user_params
    # filtramos params para obtener solo los atributos que queremos para crear un user
    params.permit(:name, :email, :password)
  end

  def generate_token
    # usamos el id del usuario para "enconderlo" en el token que generamos
    # de esta forma no tenemos que guardar el token en la base de datos
    # ya que una vez que recuperemos el id dentro del token este id nos dira que usuario es
    token = JsonWebToken.encode(id: @user.id)
    render json: {
      access_token: token,
      message: 'Te logueaste!'
    }
  end
end
