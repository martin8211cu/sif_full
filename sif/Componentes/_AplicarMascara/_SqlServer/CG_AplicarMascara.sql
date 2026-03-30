if object_id('CGAplicarMascara2') is not null drop function CGAplicarMascara2
go
if object_id('CGAplicarMascara') is not null drop function CGAplicarMascara
go
create function CGAplicarMascara2 (
	@cuenta varchar(255),
	@valor  varchar(255),
	@sustitucion varchar(1) = '?'
)
returns varchar(255)

as
begin

	declare
		@sb varchar(255),
		@pos int, @i int,
		@ch char(1)
	
	set @sb = ''
	set @pos = 1
	set @ch = ''
	if datalength(@cuenta) = 0
		return ''
	if datalength(@valor) = 0
		return @cuenta
	set @i = 1
	while ( (@i) <= Len(@cuenta) ) begin
		set @ch = substring(@cuenta, @i, 1)
		if @ch = @sustitucion begin
			set @sb = @sb + substring(@valor, @pos, 1)
			set @pos = @pos + 1
			if @pos > Len(@valor) begin
				set @pos = 1
			end
		end
		else begin
			set @sb = @sb + @ch
		end
		set @i = @i + 1
	end
	return (@sb)
end
go
create function CGAplicarMascara (
	@cuenta varchar(255),
	@valor  varchar(255)
)
returns varchar(255)

as
begin
	return dbo.CGAplicarMascara2(@cuenta, @valor, '?')
end
go
