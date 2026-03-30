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

	/* NO HAY QUE OBTENER EL SIGUIENTE ID */

	/* Se generan los Datos de Entrada para la Interfaz: se utilizan SELECTs para generar los datos correspondientes a las Tablas de Entrada IE7, ID7 e IS7*/
	declare @sql_IE7 varchar(16000)
	declare @sql_ID7 varchar(16000)
	declare @sql_IS7 varchar(16000)
	
	select @sql_IE7 = 
		'select ''A'' || convert(varchar,@NUMDOC)				as CodigoArticulo, ' 				+ 
		'       ''Prueba '' || convert(varchar,@NUMDOC)	as DescripcionArticulo, ' 	+ 
		'       ''UNI''																	as CodigoUnidadMedida, ' 		+ 
		'       ''APIET'' 															as CodigoClasificacion, ' 	+ 
		'       ''200-0020'' 														as CodigoArticuloAlterno, ' + 
		'       null																		as CodigoMarca, ' 					+ 
		'       null																		as CodigoModelo, ' 					+ 
		'       ''A''																		as Imodo, ' 								+ 
		'       null																		as BMUsucodigo '
	
	/* Si hubiera detalle se crea un select para los datos de la ID7 (filtrado por el mismo CodigoArticulo) */
	select @sql_IED = ""

	/* Si hubiera sub-detalle se crea un select para los datos de la IS7 (filtrado por el mismo CodigoArticulo) */
	select @sql_IS7 = ""

	/* Se invoca el Web Service para iniciar el Motor de Interfaces */
	/* Para minimizar errores de sincronización es importante que la invocación */
	/* del Web Service se realice inmediatamente antes de terminar la transaccion */
	declare @Response varchar(16000)
	select @Response = interfazToSoinSQL 	(
		'http://desarrollo/cfmx/interfacesSoin/webService/interfaz-serviceXML.cfm',
		'soin','2','marcel','sup3rman',
		'7',
		@sql_IE7, @sql_ID7, @sql_IS7,
		0	)

	/* Se obtiene el mensaje de Error y ID generado */
	select @MSG = interfazFromXML('MSG',@Response)
	select @ID  = convert(numeric, interfazFromXML('ID',@Response))

	/* Si el Web Service no da error se termina la transaccion, si da error se devuelve */
	IF @MSG = 'OK'
	BEGIN
		COMMIT TRAN

		UPDATE DOCUMENTO 
		   SET MSG = @MSG
		      ,ID  = @ID
		 WHERE NUMERO = @NUMDOC

		/* Si la interfaz es Sincrónica o Directa y se indicó que generar el XML de datos de salida, los datos de salida entarían en las tablas locales de salida OE7, OD7 y OS7, en la base de datos donde se invocó la Interfaz */
		/* Si la interfaz es Sincrónica o Directa y pero se indicó que no generara el XML de datos de salida, los datos de salida entarían en las tablas remotas de salida OE7, OD7 y OS7, en la base de datos del motor de interfaces */
		/* Si la interfaz es Asincrónica, el Proceso no se ha iniciado todavía, y cuando se procese los datos de salida quedarán en las tablas remotas de salida OE7, OD7 y OS7, en la base de datos del motor de interfaces */
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

