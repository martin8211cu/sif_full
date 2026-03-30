/* TABLA DE PRUEBA, SE INSERTA SIEMPRE EL SIGUIENTE NUMERO DE DOCUMENTO 
CREATE TABLE DOCUMENTO 
(NUMERO int, APLICADO INT, NAP NUMBER NULL, NRP NUMBER NULL, ID NUMBER NULL, MSG VARCHAR2(255) NULL);
*/
INSERT INTO DOCUMENTO (NUMERO, APLICADO) 
SELECT COALESCE(MAX(NUMERO),0)+1, 0 FROM DOCUMENTO;
COMMIT;





/* EJEMPLO DE UNA TRANSACCION HIPOTÉTICA DOS PINOS */
DECLARE
    LvarNUMDOC	INT;
    LvarMSG	VARCHAR2(255);
    LvarID	NUMBER;
    LvarNAP	NUMBER;
    LvarNRP	NUMBER;
    /* Función que genera las tablas de entrada en una Transaccion Autonoma */
    /* para que pueda ser procesada por el Motor de Interfaces */
    FUNCTION	fnGrabaTablasEntrada 
RETURN NUMBER AS
	ID	NUMBER;
	PRAGMA AUTONOMOUS_TRANSACTION;
    BEGIN
	/* Obtiene el siguiente ID */
	SELECT S_IDPROCESO.NEXTVAL INTO ID FROM DUAL;

	/* Genera la Tabla Entrada Encabezado */
	insert into IE1 
		(ID, CodigoArticulo, DescripcionArticulo, CodigoUnidadMedida, CodigoClasificacion, CodigoArticuloAlterno, CodigoMarca, CodigoModelo, Imodo, BMUsucodigo)
	VALUES 	(ID, 'A' || to_char(LvarNUMDOC),'Prueba ' || to_char(LvarNUMDOC), 'UNI', 'APIET', '200-0020', null, null, 'A', null);
	COMMIT;
	RETURN ID;
    END;
 

/* INICIO DE LA TRANSACCION DE UNA OPERACIPON EN LOS SISTEMAS DOS PINOS */
/* por ejemplo, la aplicación de un documento o el cambio de un catálogo */
BEGIN
	/* A modo de ejemplo de una operación DosPinos, se aplica el ultimo documento */
	SELECT MAX(NUMERO) INTO LvarNUMDOC FROM DOCUMENTO;
	UPDATE DOCUMENTO
	   SET APLICADO=1
	 WHERE NUMERO = LvarNUMDOC;
	/* Fin del Ejemplo de la operación Dos Pinos */

	/* Se genera la Tabla de Entrada para la Interfaz */
	/* Los datos deben grabarse en una Transacción Autónoma para que estén disponibles */
	/* en el motor de Interfaces */
	LvarID := fnGrabaTablasEntrada;

	/* Se invoca el Web Service para iniciar el Motor de Interfaces */
	/* Para minimizar errores de sincronización es importante que la invocación */
	/* del Web Service se realice inmediatamente antes de terminar la transaccion */

	/* 
	LvarMSG := interfazDosPinosToSoin('http://websdc/cfmx/interfacesSoin/interfaz-service.cfm','soin','2','marcel','sup3rman','7',TO_CHAR(LvarID));
        */
	LvarMSG := interfazDosPinosToSoin('http://oracle.des.soin.net/cfmx/interfacesSoin/interfaz-service.cfm','soin','2','marcel','sup3rman','1',TO_CHAR(LvarID)); 

	/* Si el Web Service no da error se termina la transaccion, si da error se devuelve */
	IF LvarMSG <> 'OK' THEN
		/* Según ejemplo: El Documento queda sin aplicar */
		ROLLBACK;		

		/* A modo de debug, se guarda el msg para saber por qué dio error */
		UPDATE DOCUMENTO 
		   SET MSG = LvarMSG
		      ,ID = LvarID
		 WHERE NUMERO = LvarNUMDOC;
		COMMIT;
	ELSE
  		COMMIT;

		/* Se procesa la tablas de Salida OE8 y OD8 */
		UPDATE DOCUMENTO 
		   SET ID = LvarID
		      ,MSG = LvarMSG
		 WHERE NUMERO = LvarNUMDOC;
		COMMIT;
	END IF;
END;
/

/* FIN DEL EJEMPLO DE LA TRANSACCION HIPOTÉTICA DOS PINOS */;


/* Visualiza el resultado:
	Si MSG<>'OK' se debe visualizar:	Aplicado=0, MSG=El Error Generado
	Si MSG='OK' Y NAP>=0:			Aplicado=1, NAP=número generado, NRP=null
	Si MSG='OK' Y NAP<0:			Aplicado=0, NAP=-1, NRP=número generado
*/
SELECT * 
  FROM DOCUMENTO
WHERE NUMERO = (SELECT MAX(NUMERO) FROM DOCUMENTO);

