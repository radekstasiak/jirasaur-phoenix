defmodule Jirasaur.Api.V1.ReportView do
	use Jirasaur.Web, :view

	def render("error.v1.json",%{code: code})do 
		%{
			code: code
		}
	end

	def render("success.v1.json",%{response_text: response_text})do
        %{
            "response_type" => "in_channel",
            "text" => "Saved!",
            "attachments" => [%{
            "text" => response_text
        			}]
        }
	end
end