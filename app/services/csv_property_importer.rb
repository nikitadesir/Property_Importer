require 'csv'
require 'set'

class CsvPropertyImporter
  # Output struct to hold categorized results for preview and import steps
  Output = Struct.new(
    :new_properties,
    :existing_properties,
    :new_units,
    :duplicates,
    :errors,
    :excluded_rows,
    keyword_init: true
  )

  def initialize(file)
    @file = file
  end

  def preview
    run(save: false)
  end

  def import!
    run(save: true)
  end

  private

  # Data normalization helper method
  def normalize(str)
    return "" if str.nil?

    str.to_s
       .force_encoding("UTF-8")
       .encode("UTF-8", invalid: :replace, undef: :replace, replace: "")
       .unicode_normalize(:nfkc)
       .gsub(/\u00A0/, " ")
       .squish
       .titleize
  end

  # Unique key to avoid duplicate properties in preview
  def property_key(building, street, city, state, zip)
    "#{building}|#{street}|#{city}|#{state}|#{zip}"
  end

  # Helper method to store excluded rows so user knows which ones will not be included in upload
  def exclude_row(output, index, row)
    output.excluded_rows << { row: index, data: row.to_h }
  end

  # Core method with logic to process CSV rows, validate data, check for duplicates, save to the db
  def run(save:)
    output = Output.new(
      new_properties: [],
      existing_properties: [],
      new_units: [],
      duplicates: [],
      errors: [],
      excluded_rows: []
    )

    seen_new_properties = Set.new
    seen_existing_properties = Set.new

    # STRINGIO + UTF‑8 FIX
    csv_enum =
      if @file.is_a?(StringIO)
        CSV.new(
          @file.string.force_encoding("UTF-8"),
          headers: true
        )
      else
        CSV.foreach(
          @file.respond_to?(:path) ? @file.path : @file.to_s,
          headers: true,
          encoding: "UTF-8"
        )
      end
    
    csv_enum.each.with_index(1) do |row, index|
      building = normalize(row['Building Name'])
      street   = normalize(row['Street Address'])
      unit     = normalize(row['Unit'])
      city     = normalize(row['City'])
      state    = normalize(row['State'])
      zip      = row['Zip Code'].to_s.strip


      # Data validation and detailed error messages user will see in preview
      if building.blank?
        output.errors << "Row #{index}: Missing building name — #{row['Street Address']}"
        exclude_row(output, index, row)
        next
      end

      if unit.blank?
        output.errors << "Row #{index}: Missing unit — #{building} (#{street})"
        exclude_row(output, index, row)
        next
      end

      if street.blank?
        output.errors << "Row #{index}: Missing street — #{building}"
        exclude_row(output, index, row)
        next
      end

      if city.blank?
        output.errors << "Row #{index}: Missing city — #{building} (#{street})"
        exclude_row(output, index, row)
        next
      end

      if state.blank?
        output.errors << "Row #{index}: Missing state — #{building} (#{street})"
        exclude_row(output, index, row)
        next
      end

      if zip.blank?
        output.errors << "Row #{index}: Missing zip — #{building} (#{street})"
        exclude_row(output, index, row)
        next
      end

      # Find or initialize property to check if new or existing
      property = Property.find_or_initialize_by(
        building_name: building,
        street_address: street,
        city: city,
        state: state,
        zip_code: zip
      )

      key = property_key(building, street, city, state, zip)

      
      if property.new_record?
        unless seen_new_properties.include?(key)
          output.new_properties << {
            building_name: building,
            street: street,
            city: city,
            state: state,
            zip: zip
          }
          seen_new_properties << key
        end
      else
        unless seen_existing_properties.include?(key)
          output.existing_properties << {
            building_name: building,
            street: street,
            city: city,
            state: state,
            zip: zip
          }
          seen_existing_properties << key
        end
      end

      # Check for duplicate units within the same property
      if property.units.exists?(unit_number: unit)
        output.duplicates << "#{building} - Unit #{unit}"
        next
      end

      
      new_unit = property.units.build(unit_number: unit)

      # Add to new_units for preview summary
      output.new_units << {
        unit_number: unit,
        building_name: building,
        street: street,
        city: city,
        state: state,
        zip: zip
      }

      # Saves to db if in import step
      if save
        ActiveRecord::Base.transaction do
          property.save! if property.new_record?
          new_unit.save!
        end
      end
    end

    output
  end
end

