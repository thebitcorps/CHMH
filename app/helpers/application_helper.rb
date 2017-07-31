module ApplicationHelper

	def check_for_devise
		return "wo-nav" if request.path == "/users/sign_in"
	end

	def NameMonth(month)
		names = ['Enero', 'Febrero', 'Marzo', 'Abril', 'Mayo', 'Junio', 'Julio', 'Agosto', 'Septiembre', 'Octubre', 'Noviembre', 'Diciembre']
		names[month.to_i - 1]
	end

	def DateWow(date)
		 [date.day, NameMonth(date.month), date.year].join("/")
	end

	def show_in_hours_and_minutes(minutes)
		(minutes/60).to_s + " horas y " + (minutes%60).to_s + " minutos."
	end

	def capitalize_and_humanize(frase)
		words = frase.split(" ")
		words.each_with_index do  |word, index|
			word.humanize!
			word.capitalize! if index == 0
		end
	end
end

