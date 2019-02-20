json.extract! faq, :id, :title, :content, :user_id, :created_at, :updated_at
json.url faq_url(faq, format: :json)
