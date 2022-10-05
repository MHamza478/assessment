
class Api::V1::ContactsController < ApplicationController
  before_action :check_idempotence_key, only: [:create]
  before_action :check_content_type, only: [:index]
  before_action :set_contact, only: [:update, :show, :destroy]

  def index
    csv_contacts = Contact.to_csv
    render json: { contacts: csv_contacts }, status: 200
  end

  def create 
    @contact = Contact.new(contact_params)
    if @contact.save
      return render json: { message: 'Contact Saved successfully' }, status: 200
    else
      render json: { message: @contact.errors.full_messages.to_sentence }, status: 400
    end
  end

  def update
    if @contact.update(contact_params)
      render json: { message: 'Contact Updated successfully' }, status: 200 
    else
      render json: { message: @contact.errors.full_messages.to_sentence }, status: 400 
    end
  end

  def show
    render json: { contact: @contact }, status: 200
  end

  def destroy
    if @contact.destroy
      render json: { message: 'Contact removed successfully' }, status: 200 
    else
      render json: { message: @contact.errors.full_messages.to_sentence }, status: 400
    end
  end

  private 

  def contact_params
    params.require(:contact).permit(:first_name, :last_name, :email, :note)
  end

  def set_contact
    @contact = Contact.find(params[:id])
  end

  def check_idempotence_key
    return render json: { message: 'Idempotence key required' }, status: 400 if !request.headers['idemKey'].present?
  end

  def check_content_type
    return render json: { message: 'content-Type is required' }, status: 400 if !request.headers['Content-Type'] == 'text/csv'
  end
end