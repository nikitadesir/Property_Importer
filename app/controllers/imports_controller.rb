class ImportsController < ApplicationController

  # User uploads CSV & previews results before confirming upload
  def preview
    uploaded_file = params[:file]

    if uploaded_file.nil?
      redirect_to new_import_path, alert: "Please upload a CSV file."
      return
    end

    # Store CSV contents in session (Option B)
    session[:csv_data] = uploaded_file.read

    importer = CsvPropertyImporter.new(StringIO.new(session[:csv_data]))
    @output = importer.preview
  end


  # User confirms preview results and saves to db and goes to success page
  def confirm
    if session[:csv_data].blank?
      redirect_to new_import_path, alert: "Upload FAILED. Please upload the file again."
      return
    end

    importer = CsvPropertyImporter.new(StringIO.new(session[:csv_data]))
    importer.import!

    session.delete(:csv_data)

    redirect_to success_imports_path, notice: "Upload completed SUCCESSFULLY."
  end

  # Upload form
  def new
  end

end
