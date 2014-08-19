module ApplicationHelper
	def NameMonth(month)
		names = ['Enero', 'Febrero', 'Marzo', 'Abril', 'Mayo', 'Junio', 'Julio', 'Agosto', 'Septiembre', 'Octubre', 'Noviembre', 'Diciembre']
		return names[month.to_i - 1]
	end

	def DateWow(date)
		return date.day.to_s + "/" + NameMonth(date.month.to_s) + "/" + date.year.to_s
	end
end

