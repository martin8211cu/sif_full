IF OBJECT_ID('dbo.fe_Indicador_Impresion') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.fe_Indicador_Impresion
    IF OBJECT_ID('dbo.fe_Indicador_Impresion') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.fe_Indicador_Impresion >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.fe_Indicador_Impresion >>>'
END
go
     CREATE PROC fe_Indicador_Impresion
    @cod_flujo  char(5)
AS
    declare @cod_estado int

    if exists (select * from fe_estadofacturacion
	           where cod_flujo = @cod_flujo) begin
	    select @cod_estado = cod_estado
	    from fe_estadofacturacion 
	    where cod_flujo = @cod_flujo
    end
    else begin
	    raiserror 40000 'Estado de Facturacion (%1!) No Existe',@cod_flujo
	    select @cod_estado = 0
    end

    select @cod_estado





go
EXEC sp_procxmode 'dbo.fe_Indicador_Impresion','unchained'
go
IF OBJECT_ID('dbo.fe_Indicador_Impresion') IS NOT NULL
    PRINT '<<< CREATED PROCEDURE dbo.fe_Indicador_Impresion >>>'
ELSE
    PRINT '<<< FAILED CREATING PROCEDURE dbo.fe_Indicador_Impresion >>>'
go
