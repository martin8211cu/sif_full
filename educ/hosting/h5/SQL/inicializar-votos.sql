declare @i int

select @i = 1
while @i <= 25 begin

insert Votos (concursante, fecha, ip, cookie, votante)
select concursante, getdate(), '0.0.0.0', 'INICIALIZACION', 'INICIALIZACION'
from Concursante


select @i = @i + 1

end
go
