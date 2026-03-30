IF OBJECT_ID('dbo.FA_Trae_Factor_Conversion') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.FA_Trae_Factor_Conversion
    IF OBJECT_ID('dbo.FA_Trae_Factor_Conversion') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.FA_Trae_Factor_Conversion >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.FA_Trae_Factor_Conversion >>>'
END
go
           create proc FA_Trae_Factor_Conversion
       @moneda1    varchar(2),
       @moneda2    varchar(2),
       @Factor  float  = null output,
       @vb int = 0,  -- x default para hacer select
	   @TIPO char(1) = 'C' -- tipo de cambio a utilizar	
as
/*
** Calcula el factor de conversion, de acuerdo a dos valores de moneda
** Creado por:  sa en Gaby
** Fecha:       22-Sep-1998
*/
declare

  @TPCVTA1 float,   --tipo cambio venta
  @TPCVTA2 float,   --tipo cambio venta
  @Fecha datetime,
  @TPCCMP1 float,
  @TPCCMP2 float
  select @Fecha = (select getdate())
  set rowcount 1
  select @TPCCMP1 = TPCCMP,
	 @TPCVTA1 = TPCVTA
  from   CCM010
  where MONCOD = @moneda1 and TPCFEC <= @Fecha
  order by TPCFEC DESC
  set rowcount 0
  set rowcount 1
  select @TPCCMP2 = TPCCMP,
	 @TPCVTA2 = TPCVTA
  from   CCM010
  where MONCOD = @moneda2 and TPCFEC <= @Fecha
  order by TPCFEC DESC
  set rowcount 0
  
if @TIPO = 'C' 
	select @Factor = @TPCCMP1/@TPCCMP2
else 
  select @Factor = @TPCVTA1/@TPCVTA2

select @Factor = isnull(@Factor,0)  


if @vb = 0 
begin
	select @Factor
end



go
EXEC sp_procxmode 'dbo.FA_Trae_Factor_Conversion','unchained'
go
IF OBJECT_ID('dbo.FA_Trae_Factor_Conversion') IS NOT NULL
    PRINT '<<< CREATED PROCEDURE dbo.FA_Trae_Factor_Conversion >>>'
ELSE
    PRINT '<<< FAILED CREATING PROCEDURE dbo.FA_Trae_Factor_Conversion >>>'
go
USE GN_CONTABLE
go
GRANT EXECUTE ON dbo.FA_Trae_Factor_Conversion TO CONSULTA
go
