create procedure cg_cual_tipo
@CG15ID int,
@CG13ID int,	
@CGM1CD varchar(100),	
@CG11ID_val int output,
@CG12ID_val varchar(10) output
as
declare
@CG12ID varchar(10),
@CG12ID_ant varchar(10),
@cont int,		
@CG11ID int,
@CG11ID_ant int,
@CG11ID_aux  int,
@CG16NI smallint,
@CG16DE char(1),
@nivel int,
@VALOR varchar(10),
@veces smallint,
@CG13ID_ant smallint,
@i smallint,
@msg varchar(250)
select 	@CG11ID = -1, @CG16NI = -1
select  @CG11ID_val= CG11ID,
		@CG16NI = CG16NI
		From CGM016
		Where CG13ID = @CG13ID
		and CG15ID = @CG15ID
select @CG13ID_ant = @CG16NI 
	exec cg_cual_valor
			@CG15ID = @CG15ID,
			@CG13ID = @CG13ID,
			@CGM1CD = @CGM1CD,
			@VALOR = @VALOR output
select @CG12ID_val = @VALOR
if isnull(@CG16NI,-1) = -1 return	
select @CG13ID_ant = @CG13ID
select @veces = 0
select @CG16NI = -1 
while 1 = 1  /*ciclo  para ir hacia atrás buscando el nivel menor de dependencia*/
begin
	select @veces = @veces + 1
	select 	@CG16NI = (select CG16NI
			From CGM016
			Where CG13ID = @CG13ID_ant
			and CG15ID = @CG15ID)
	if isnull(@CG16NI,-1) = -1 break
	select @CG13ID_ant = @CG16NI 
	select @CG16NI = -1
end /* while 1 = 1*/
select @i = 1
	exec cg_cual_valor
			@CG15ID = @CG15ID,
			@CG13ID = @CG13ID_ant ,
			@CGM1CD = @CGM1CD,
			@VALOR = @VALOR output
select  @CG11ID_ant = (select CG11ID
		From CGM016
		Where CG13ID = @CG13ID_ant
		and CG15ID = @CG15ID)
select @i = 1
while 1 = 1   /* ciclo para ir hacia delante hasta el valor del nivel requerido en parámetro*/
begin
	/*buscar el tipo asociado al valor del nivel antecesor*/
	select @CG11ID_aux = isnull((select CG12LR
				From CGM012
				Where CG11ID = @CG11ID_ant
				and CG12ID = @VALOR),-1)
	if isnull(@CG11ID_aux,-1) = -1 
	begin
		select @CG11ID_val = @CG11ID_aux
		select @msg = 'Error...no existe tipo asociado al valor ' + @VALOR + ' del tipo ' + convert(varchar,@CG11ID_ant)
        select @msg = @msg + ' del nivel ' + convert(varchar,@CG13ID_ant) + ' de la máscara ' + convert(varchar,@CG15ID)
		select @msg = @msg + ' y el nivel ' + convert(varchar,@CG13ID) + ' depende de éste '	
		raiserror 40000 @msg
		return -1
	end
		select @CG13ID_ant = isnull((select CG13ID from CGM016 where CG15ID = @CG15ID and CG16NI = @CG13ID_ant),250) 
		if @CG13ID_ant = 250
		begin
		   	raiserror 40000 'error de inconsistencia al recorrer la máscara'   /*error del procedimiento*/
			return -1	
		end
	exec cg_cual_valor
			@CG15ID = @CG15ID,
			@CG13ID = @CG13ID_ant ,
			@CGM1CD = @CGM1CD,
			@VALOR = @VALOR output
	select @CG11ID_val = @CG11ID_aux,@CG11ID_ant = @CG11ID_aux
	select @CG12ID_val = @VALOR
	select @i = @i + 1
	if @i = @veces break
end
  /* segundo while 1 = 1 */
--select @CG11ID_val = @CG11ID_aux
