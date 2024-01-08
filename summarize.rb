# frozen_string_literal: true

require "httparty"
require "json"

def read_file_content
  File.read("full_script.txt")
end

def document_to_messages(document)
  document.split("\n").map { |paragraph| {"role" => "system", "content" => paragraph} }
end

def config(file_content)
  body = {
    model: "gpt-3.5-turbo",
    max_tokens: 950,
    messages: [{"role" => "user", "content" => "I have a transcript from a long interview that I need to condense for a documentary. The transcript has been provided. Can you help me identify the most relevant parts to include in the documentary without adding any words or changing the structure in any way? Please respond with only the relevant quotes, no formatting - as if it was the original text, but shorter."}] + document_to_messages(file_content)
  }

  headers = {
    "Content-Type" => "application/json",
    "Authorization" => ENV["OPENAI_API_KEY"].to_s
  }

  [body, headers]
end

def send_request(body, headers)
  HTTParty.post("https://api.openai.com/v1/chat/completions",
    body: body.to_json,
    headers: headers)
end

def write_to_file(response)
  File.write("ai_summarized_script.txt", JSON.parse(response.body)["choices"][0]["message"]["content"])
end

def summarizer
  file_content = read_file_content
  body, headers = config(file_content)
  response = send_request(body, headers)
  puts response.body
  write_to_file(response)

  puts "Summarization completed!"
end

summarizer
