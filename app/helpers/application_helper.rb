module ApplicationHelper
	def NameMonth(month)
		names = ['Enero', 'Febrero', 'Marzo', 'Abril', 'Mayo', 'Junio', 'Julio', 'Agosto', 'Septiembre', 'Octubre', 'Noviembre', 'Diciembre']
		 names[month.to_i - 1]
	end

	def DateWow(date)
		 date.day.to_s + "/" + NameMonth(date.month.to_s) + "/" + date.year.to_s
	end

	def show_in_hours_and_minutes(minutes)
		number_with_delimiter(minutes/60) + " horas y " + number_with_delimiter(minutes%60) + " minutos."
	end

	def capitalize_and_humanazie(frase)
		words = frase.split(" ")
		words.each_with_index do  |word,index|
			word.humanize!
			word.capitalize! if index == 0
		end
	end
end

