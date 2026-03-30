-- TABLA DE PRUEBA, SE INSERTA SIEMPRE EL SIGUIENTE NUMERO DE DOCUMENTO 
if not exists(select 1 from sysobjects where name='DOCUMENTO')
	CREATE TABLE DOCUMENTO 
	(NUMERO int, APLICADO int, ID numeric NULL, MSG varchar(255) NULL)
go

-- GENERA UN NUEVO NUMERO DE DOCUMENTO
INSERT INTO DOCUMENTO (NUMERO, APLICADO) 
SELECT COALESCE(MAX(NUMERO),0)+1, 0 FROM DOCUMENTO
go




/* EJEMPLO DE UNA TRANSACCION HIPOTÉTICA EXTERNA */

/* INICIO DE LA TRANSACCION DE UNA OPERACION EN LOS SISTEMAS EXTERNOS AL SIF */
/* por ejemplo, la aplicación de un documento o el cambio de un catálogo */
BEGIN
	BEGIN TRAN
	declare @NUMDOC	INT,
		@MSG	VARCHAR(255),
		@ID	NUMERIC

	/* A modo de ejemplo de una operación DosPinos, se aplica el ultimo documento */
	SELECT @NUMDOC = MAX(NUMERO) FROM DOCUMENTO
	UPDATE DOCUMENTO
	   SET APLICADO=1
	 WHERE NUMERO = @NUMDOC
	/* Fin del Ejemplo de la operación del Sistema Externo */

	/* Obtiene el siguiente ID */
	exec S_IdProceso_Nextval @ID out

	/* Se genera la Tabla de Entrada para la Interfaz */
	insert into IE7
		(ID, CodigoArticulo, DescripcionArticulo, CodigoUnidadMedida, CodigoClasificacion, CodigoArticuloAlterno, CodigoMarca, CodigoModelo, Imodo, BMUsucodigo)
	VALUES 	(@ID, 'A' || convert(varchar,@NUMDOC),'Prueba ' || convert(varchar,@NUMDOC), 'UNI', 'APIET', '200-0020', null, null, 'A', null)
	/* Si hubiera detalle se inserta en ID7 dentro de un ciclo */

	/* Se invoca el Web Service para iniciar el Motor de Interfaces */
	/* Para minimizar errores de sincronización es importante que la invocación */
	/* del Web Service se realice inmediatamente antes de terminar la transaccion */
	select @MSG = interfazToSoin('http://desarrollo/cfmx/interfacesSoin/webService/interfaz-service.cfm','soin','2','marcel','sup3rman','7',convert(varchar,@ID))

	/* Si el Web Service no da error se termina la transaccion, si da error se devuelve */
	IF @MSG = 'OK'
	BEGIN
  		COMMIT TRAN

		UPDATE DOCUMENTO 
		   SET MSG = @MSG
		      ,ID = @ID
		 WHERE NUMERO = @NUMDOC
	END
	ELSE
	BEGIN
		/* Según ejemplo: El Documento queda sin aplicar */
		ROLLBACK TRAN

		/* A modo de debug, se guarda el msg para saber por qué dio error */
		UPDATE DOCUMENTO 
		   SET MSG = @MSG
		      ,ID = @ID
		 WHERE NUMERO = @NUMDOC

		RAISERROR 40000 @MSG
	END
END
go

/* FIN DEL EJEMPLO DE LA TRANSACCION HIPOTÉTICA DEL SISTEMA EXTERNO AL SIF */


/* Visualiza el resultado:
	Si MSG<>'OK' se debe visualizar:	Aplicado=0, MSG=El Error Generado
	Si MSG='OK' Y NAP>=0:			Aplicado=1, NAP=número generado, NRP=null
	Si MSG='OK' Y NAP<0:			Aplicado=0, NAP=-1, NRP=número generado
*/
SELECT * 
  FROM DOCUMENTO
WHERE NUMERO = (SELECT MAX(NUMERO) FROM DOCUMENTO)

