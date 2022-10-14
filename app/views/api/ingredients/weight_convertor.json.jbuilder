if @error_message.blank?
  json.converted_amount @amount
else
  json.error_message @error_message
end
