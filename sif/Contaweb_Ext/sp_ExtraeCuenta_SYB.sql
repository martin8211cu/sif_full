 
create proc sp_ExtraeCuenta_SYB
	@CGM1CD		varchar(100),	/*Detalle de la Cuenta	*/
	@CG15ID 	int,							/*Máscara				*/
	@nivel 		tinyint,
	@CG12ID		varchar(10) output
,	@CG11ID		int output /**/
as
/*
** sp_ExtraeCuenta_SYB
** Creado por:  sa en
** Fecha:       08-Sep-1997
*/
begin
	if @CGM1CD = null return
	declare
	@espacios 	tinyint,
	@pos					tinyint,
	@msg 				varchar(100),
	@CG13ID			int
--	,@CG11ID			int 			/* Código del Nivel */
	select @pos = 1
	declare detalle cursor
	for select CG16NE, CG11ID,	CG13ID
	from CGM016
	Where CG15ID = @CG15ID
	order by CG13ID
	open detalle
	fetch detalle	into @espacios, @CG11ID, @CG13ID
	While @@sqlstatus <> 2 begin
		
		select @CG12ID =	substring(@CGM1CD,@pos,@espacios)
		if @CG13ID = @nivel break
		select @pos =	@pos + @espacios
	fetch detalle	into @espacios, @CG11ID, @CG13ID
	end
end
