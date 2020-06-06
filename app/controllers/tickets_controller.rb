class TicketsController < ApplicationController
  before_action :set_project
  before_action :set_ticket, only: [:show, :edit, :update, :destroy, :watch]

  def new
    @ticket = @project.tickets.build
    @attachments = []
  end

  def create
    @ticket = @project.tickets.build(ticket_params)
    @ticket.author = current_user
    @ticket.tags = processed_tags

    @ticket.images.attach(params[:attachments])

    if @ticket.save
      @ticket.watchers << current_user
      flash[:notice] = "Ticket has been created."
      redirect_to [@project, @ticket]
    else
      @attachments = Array.wrap(params[:attachments]).map do |attachment|
        blob = ActiveStorage::Blob.find_signed(attachment)
        { signedId: blob.signed_id, name: blob.filename, size: blob.byte_size, path: rails_blob_path(blob) }
      end
      flash.now[:alert] = "Ticket has not been created."
      render "new"
    end
  end

  def show
    @comment = @ticket.comments.build(state: @ticket.state)
    @states = State.all
  end

  def edit
    @attachments = []
  end

  def update
    if @ticket.update(ticket_params)
      @ticket.tags << processed_tags
      flash[:notice] = "Ticket has been updated."
      redirect_to [@project, @ticket]
    else
      @attachments = Array.wrap(params[:attachments]).map do |attachment|
        blob = ActiveStorage::Blob.find_signed(attachment)
        { signedId: blob.signed_id, name: blob.filename, size: blob.byte_size, path: rails_blob_path(blob) }
      end
      flash.now[:alert] = "Ticket has not been updated."
      render "edit"
    end
  end

  def destroy
    @ticket.destroy
    flash[:notice] = "Ticket has been deleted."

    redirect_to @project
  end

  def search
    if params[:search].present?
      @tickets = @project.tickets.search(params[:search])
    else
      @tickets = @project.tickets
    end
    render "projects/show"
  end

  def watch
    if @ticket.watchers.exists?(current_user.id)
      @ticket.watchers.destroy(current_user)
      flash[:notice] = "You are no longer watching this ticket."
    else
      @ticket.watchers << current_user
      flash[:notice] = "You are now watching this ticket."
    end

    redirect_to project_ticket_path(@ticket.project, @ticket)
  end

  def upload_file
    blob = ActiveStorage::Blob.create_and_upload!(io: params[:file], filename: params[:file].original_filename)
    render json: { signedId: blob.signed_id }
  end

  private

  def ticket_params
    params.require(:ticket).permit(:name, :description)
  end

  def set_project
    @project = Project.find(params[:project_id])
  end

  def set_ticket
    @ticket = @project.tickets.find(params[:id])
  end

  def processed_tags
    params[:tag_names].split(",").map do |tag|
      Tag.find_or_initialize_by(name: tag)
    end
  end

end
