IF OBJECT_ID('dbo.fe_Llenar_Bitacora') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.fe_Llenar_Bitacora
    IF OBJECT_ID('dbo.fe_Llenar_Bitacora') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.fe_Llenar_Bitacora >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.fe_Llenar_Bitacora >>>'
END
go
    CREATE PROC fe_Llenar_Bitacora
    @num_factura 	varchar(10) = ' ',                     --1
    @cod_sistema 	varchar(3) = ' ',                      --2
    @num_factura_elec 	varchar(10) = ' ',                 --3
    @fec_emision    datetime = '1900/01/01 01:00:00 AM',  --4
    @cod_estado     varchar(3) = ' ',                      --5
    @fec_procesado  datetime = '1900/01/01 01:00:00 AM',  --6
    @num_prioridad  int = 0,                              --7
    @cod_cliente    numeric(12,0) = 0,                    --8
    @FACTTR         varchar(2) = ' ',                      --9
    @FACDOC         varchar(15) = ' ',                     --10
    @CLICOD        	varchar(15) = ' ',                     --11
    @num_factura_soin char(15) = ' ',                      --12
    @FAM01COD       char(4) = ' ',                         --13
    @FAX01NTR       int = 0                               --14
AS

--/*
declare @S varchar(80),
        @D varchar(80),
        @PROCE varchar(255), 
        @resultado int
        
select @S = 'SSISREPLICADO'
select @D = 'GN_CONTABLE'        

SELECT  @PROCE = @S + '.' + @D + '..fe_Llenar_Bitacora' 

select @resultado = 0 
exec @resultado = @PROCE @num_factura=@num_factura,
                  @cod_sistema=@cod_sistema,
                  @num_factura_elec=@num_factura_elec,
                  @fec_emision=@fec_emision,
                  @cod_estado=@cod_estado,
                  @fec_procesado=@fec_procesado,
                  @num_prioridad=@num_prioridad,
                  @cod_cliente=@cod_cliente,
                  @FACTTR=@FACTTR,
                  @FACDOC=@FACDOC,
                  @CLICOD=@CLICOD,
                  @num_factura_soin=@num_factura_soin,
                  @FAM01COD=@FAM01COD,
                  @FAX01NTR=@FAX01NTR

if (@resultado != 0) or (@@error != 0) begin
    raiserror 40000 "Error al llenar bitacora"
end



--*/

/*
INSERT dbo.fe_cola_facturas_electronicas ( 
    num_factura,                                --1
    cod_sistema,                                --2
    num_factura_elec,                           --3
    fec_emision,                                --4
    cod_estado,                                 --5
    fec_procesado,                              --6
    num_prioridad,                              --7
    cod_cliente,                                --8
    FACTTR,                                     --9
    FACDOC,                                     --10
    CLICOD,                                     --11
    num_factura_soin,                           --12
    FAM01COD,                                   --13
    FAX01NTR)                                   --14
VALUES ( 
    @num_factura,                               --1
    @cod_sistema,                               --2
    @num_factura_elec,                          --3 
    @fec_emision,                               --4
    @cod_estado,                                --5
    @fec_procesado,                             --6 
    @num_prioridad,                             --7
    @cod_cliente,                               --8
    @FACTTR,                                    --9
    @FACDOC,                                    --10
    @CLICOD,                                    --11
    @num_factura_soin,                          --12
    @FAM01COD,                                  --13
    @FAX01NTR)

*/
  
go
EXEC sp_procxmode 'dbo.fe_Llenar_Bitacora','unchained'
go
IF OBJECT_ID('dbo.fe_Llenar_Bitacora') IS NOT NULL
    PRINT '<<< CREATED PROCEDURE dbo.fe_Llenar_Bitacora >>>'
ELSE
    PRINT '<<< FAILED CREATING PROCEDURE dbo.fe_Llenar_Bitacora >>>'
go
