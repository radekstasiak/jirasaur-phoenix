defmodule Shtask.Api.V1.ReportView do
	use Shtask.Web, :view

	def render("error.v1.json",%{code: code})do 
		%{
			code: code
		}
	end

	def render("success.v1.json",%{response_text: response_text, header: header})do
        %{
            "response_type" => "in_channel",
            "text" => "#{header}!",
            "attachments" => [%{
            "text" => response_text
        			}]
        }
	end
end
