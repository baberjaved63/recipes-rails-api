if @error_message.blank?
  json.ingredient do
    json.amount @amount
  end
else
  json.error_message @error_message
end
