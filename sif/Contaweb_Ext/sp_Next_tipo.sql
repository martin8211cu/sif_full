create proc sp_Next_tipo
	@CGM1IM 	varchar(4),	
	@CGM1CD		varchar(100),	/*Detalle de la Cuenta	*/
	@nivel 		tinyint
as
declare
	@antecesor int,
	@CG11ID_val int,
	@CG12ID_val varchar(10),
	@CG15ID int,
	@CG11ID int,
	@CG12ID varchar(10),
	@CG11DE varchar(100)
select @CG15ID = CG15ID from CGM001 where CGM1IM = @CGM1IM and CGM1CD is null
if @CGM1CD is null and @nivel = 1
begin  /*1*/
  	select @CG11ID = CG11ID 
	from CGM016 
    where CG15ID = @CG15ID 
      and CG13ID = 1
end else  /*1*/
begin /*2*/
  	select @antecesor = isnull(CG16NI,@nivel) 
	from CGM016 
    where CG15ID = @CG15ID 
    and CG13ID = @nivel
/*
  exec sp_TraeDetalleMáscara
	@CG15ID = @CG15ID,
	@CG13ID = @antecesor,	
	@CGM1CD = @CGM1CD,	
	@CG11ID_val = @CG11ID_val  output,
	@CG12ID_val = @CG12ID_val  output
*/
  exec cg_cual_tipo /* para traer el tipo donde está el valor*/
	 @CG15ID = @CG15ID,
	 @CG13ID = @antecesor,	
	 @CGM1CD = @CGM1CD,	
	 @CG11ID_val = @CG11ID_val output,
	 @CG12ID_val = @CG12ID_val output
  if @antecesor = @nivel
  begin /*3*/
    select @CG11ID = @CG11ID_val
  end else /*3*/
  begin /*4*/
    select @CG11ID = CG12LR 
	from CGM012	
	where CG11ID = @CG11ID_val
      and CG12ID = @CG12ID_val
	if exists( 	select 1 
				from CGM012M 
				where CG11ID = @CG11ID_val
      			  and CG12ID = @CG12ID_val
      			  and CGM1IM = @CGM1IM ) begin
		    select @CG11ID = CG12LR 
			from CGM012M
			where CG11ID = @CG11ID_val
		      and CG12ID = @CG12ID_val
      		  and CGM1IM = @CGM1IM 
	end
  end /*4*/
end /*2*/
select @CG11DE = CG11DE 
from CGM011
where CG11ID = @CG11ID
select 	isnull(@CG11ID,-1) as CG11ID,
		isnull(@CG11DE,'Tipo no encontrado') as CG11DE
return
