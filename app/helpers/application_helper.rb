module ApplicationHelper
	def NameMonth(month)
		names = ['Enero', 'Febrero', 'Marzo', 'Abril', 'Mayo', 'Junio', 'Julio', 'Agosto', 'Septiembre', 'Octubre', 'Noviembre', 'Diciembre']
		return names[month.to_i - 1]
	end

	def DateWow(date)
		return date.day.to_s + "/" + NameMonth(date.month.to_s) + "/" + date.year.to_s
	end

	def capitalize_and_humanazie(frase)
		words = frase.split(" ")
		words.each_with_index do  |word,index|
			word.humanize!
			word.capitalize! if index == 0
		end
	end
end

