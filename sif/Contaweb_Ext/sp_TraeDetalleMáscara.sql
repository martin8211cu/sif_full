 
create proc sp_TraeDetalleMáscara
	@CG15ID int,
	@CG13ID tinyint,	
	@CGM1CD varchar(100),	
	@CG11ID_val int output,
	@CG12ID_val varchar(10) output
as
/*
** sp_TraeDetalleMáscara
** Creado por:  sa en
** Fecha:       05-Sep-1997
*/
begin
	declare
		@CG12ID varchar(10),
		@CG12ID_ant varchar(10),
		@cont 					tinyint,		
		@CG11ID 			int,
		@CG11ID_ant 			int,
		@CG11ID_aux  int,
		@CG16NI				smallint,
		@CG16DE				char(1),
		@nivel tinyint
	/*Saco el tipo de Dato a usar por el nivel	*/
	select 	@cont = 1,
						@CG16DE = "N"
	select 	@CG11ID = CG11ID,
						@CG16NI = CG16NI
	From CGM016
	Where 	CG13ID = @CG13ID
		and		CG15ID = @CG15ID
	if @CG16NI = NULL begin
		select @CG16NI = @CG13ID
	end
	exec	sp_ExtraeCuenta_SYB/*?*/
				@CGM1CD		=	@CGM1CD,				
				@CG15ID 	=	@CG15ID,
				@nivel 		= @cont,
				@CG12ID		= @CG12ID output,								
				@CG11ID		= @CG11ID_aux output /**/
	/*Valores anteriores*/
	select 	@CG11ID_ant = @CG11ID_aux,
					@CG12ID_ant = @CG12ID
	while  1=1 begin
/*		PRINT "%1!", @cont
		print "%1!", @CG16DE
		print "%1!", @CG11ID_aux
		print "%1!", @CG12ID
*/
		select @cont = @cont + 1
		if @cont = @CG13ID begin
			/*Determinar si el nivel que se pide es dependiente del anterior*/
			select 	@CG16DE = CG16DE,
							@nivel =  CG16NI + 1
			from CGM016
			Where 	CG15ID = @CG15ID
			and		CG13ID = @cont
		end
	
		if @cont > @CG16NI break
		/*es dependiente*/
		select @CG16DE = CG16DE,
					 @nivel =  isnull(CG16NI,0) + 1
		from CGM016
		Where 	CG15ID = @CG15ID
			and		CG13ID = @cont
		exec	sp_ExtraeCuenta_SYB
					@CGM1CD		=	@CGM1CD,				
					@CG15ID 	=	@CG15ID,
					@nivel 		= @cont,
					@CG12ID		= @CG12ID output,								
					@CG11ID		= @CG11ID_aux output /**/
		if @CG16DE = "S" begin
			/*Depende de un nivel que no es el anterior (un brinco en las busquedas)*/
			if @nivel <> @cont begin
				
				exec sp_TraeDetalleMáscara
					@CG15ID = @CG15ID,
					@CG13ID = @cont,
					@CGM1CD = @CGM1CD,
					@CG11ID_val = @CG11ID_ant output,
					@CG12ID_val = @CG12ID_ant output
			
					/*valor de referencia es el actual*/
					select @CG11ID_aux = @CG11ID_ant
			end else begin
				/*depende del nivel anterior*/
				select @CG11ID_aux = CG12LR
				From CGM012
				Where 	CG11ID 	= 	@CG11ID_ant
					and		CG12ID		=		@CG12ID_ant
			end
/*			PRINT "%1!", @CG11ID_aux*/
		end
		select @CG11ID_ant = @CG11ID_aux, @CG12ID_ant = @CG12ID
--		print "ref %1!",@CG11ID_val
	end
	if @CG16DE = "S" begin
		exec	sp_ExtraeCuenta_SYB
					@CGM1CD		=	@CGM1CD,				
					@CG15ID 	=	@CG15ID,
					@nivel 		= @CG13ID,
					@CG12ID		= @CG12ID output,								
					@CG11ID		= @CG11ID_aux output /**/			
			select @CG11ID_aux = CG12LR
			From CGM012
			Where 	CG11ID 	= 	@CG11ID_ant
				and		CG12ID		=		@CG12ID_ant
	end
--		print "VALOR %1!",@CG11ID_aux
	/*Retorno el valor real referenciado*/
	select @CG11ID_val = isnull(@CG11ID_aux,-999),
				 @CG12ID_val  = isnull(@CG12ID,"-999")	
end
