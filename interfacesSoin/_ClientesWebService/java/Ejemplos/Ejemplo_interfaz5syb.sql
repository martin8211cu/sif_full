/*
@M:\SIF_EP\Modelo\scripts\WebServiceInterfaz\Ejemplo_interfaz5.sql
*/
DECLARE
    LvarMSG	VARCHAR2(255);
    LvarID	NUMBER;
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
	INSERT INTO IE5
	(								ID,
									CodigoProveedor, 
									NombreProveedor,
									NumeroIdentificacion,
									TipoPersona,
									Telefono,
									Fax,
									Mail,
									Direccion,
									DiasVencimiento,
									Imodo,
									BMUsucodigo
	)
	VALUES (							ID,
			 						'1',
									'2', 
									'3',
									'F',
									'5',
									'6',
									'7',
									'8',
									9,
									'A',
									27
	);

	COMMIT;
	RETURN ID;
    END;
 

/* INICIO DE LA TRANSACCION DE UNA OPERACIPON EN LOS SISTEMAS DOS PINOS */
/* por ejemplo, la aplicación de un documento o el cambio de un catálogo */
BEGIN
	LvarID := fnGrabaTablasEntrada;

/*
	LvarMSG := interfazToSoin('http://oracle.des.soin.net/cfmx/interfacesSoin/interfaz-service.cfm','soin','2','marcel','sup3rman','5',TO_CHAR(LvarID));
*/
	LvarMSG := interfazToSoin('http://desarrollo/cfmx/interfacesSoin/interfaz-service.cfm','soin','1','marcel','sup3rman','5',TO_CHAR(LvarID));
END;
/

SELECT S_IDPROCESO.NEXTVAL AS ID_PROCESO FROM DUAL
/
