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
	INSERT INTO IE9
	(
									ID,
									EcodigoSDC, 
									Identificacion,
									Tiposocio,
									Nombre,
									Direccion,
									Telefono,
									Fax,
									Email,
									MoraloFisica,
									Vencimiento_dias_Compras,
									Vencimiento_dias_Ventas,
									NumeroSocio,
									CuentaCxC,
									CuentaCxP,
									CodigoPaisISO,
									CertificadoISO,
									Plazo_Entrega_dias,
									Plazo_Credito_dias,
									CodigoSocioSistemaOrigen,
									BMUsucodigo
	)
	VALUES (							ID,
									2, 
									'244458', 
									'A',
									'Gustavo',
									'200 Herdia 2000',
									'254-88-98',
									'233-58-55',
									'Telefono@bom.com',
									'F',
									5,
									3,
									'15',
									'44557-887-5111-55',
									'8875-55874-99',
									'UK',
									'1',
									25,
									3,									
									'551',
									27

	);

	COMMIT;
	RETURN ID;
    END;
 

/* INICIO DE LA TRANSACCION DE UNA OPERACIPON EN LOS SISTEMAS DOS PINOS */
/* por ejemplo, la aplicación de un documento o el cambio de un catálogo */
BEGIN
	LvarID := fnGrabaTablasEntrada;

	LvarMSG := interfazToSoin('http://oracle.des.soin.net/cfmx/interfacesSoin/interfaz-service.cfm','soin','2','marcel','sup3rman','9',TO_CHAR(LvarID));
END;
/

SELECT S_IDPROCESO.CURRVAL AS ID_PROCESO FROM DUAL
/
