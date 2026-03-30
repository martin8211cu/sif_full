create procedure cg_cual_valor
@CG15ID int,
@CG13ID tinyint,
@CGM1CD varchar(100),
@VALOR varchar(10) output
as
/* cursor para traer el valor para un nivel dado de la cadena de detalle CGM1CD*/
declare
@pos int,
@espacios int,
@nivel smallint
declare valor cursor
for select CG16NE,  CG13ID
from CGM016
Where CG15ID = @CG15ID
order by CG13ID
select @pos = 1
open valor
fetch valor into @espacios, @nivel
While @@sqlstatus = 0 begin
	select @VALOR = substring(@CGM1CD,@pos,@espacios)
	if @nivel = @CG13ID  break
	select @pos = @pos + @espacios
	fetch valor into @espacios, @nivel
end
return 0

