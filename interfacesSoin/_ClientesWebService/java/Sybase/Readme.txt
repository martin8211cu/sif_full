WEB SERVICE DE INTERFAZ:


Definir el DSN="sifinterfaces" en el Coldfusion Administrator que apunte al esquema interfaces
Definir en ADMINISTRACION DE CUENTAS ASP:
	Agregar en "Asignación de Módulos a Cuenta Empresarial" el Módulo: "SIF-INTERFAZ"
	Agregar un Usuario: INTERFAZ (asignando usuario y password)
	Asignación de Permisos para usuario INTERFAZ: en "Interfaces con Sistemas Externos" marcar Servicio Web de Interfaz
Cargar Parche del WebService de Interfaz 'interfazToSoin.sql' en la base de datos de los sistemas propios externos (OJO: NO EN SIF)
	("interfazToSoinSybase.bat" crea una funcion Sybase y un procedimiento java que comunica los Sistemas Externos con los Sitemas de SOIN a travez del WebService de Interfaz en los sistemas de Soin)
Para que este parche sirva hay que asegurarse de que haya definidos por lo menos 10 sockets en la VM de Java:
	sp_configure "number of java sockets", 10
En la Opcion "Parámetros de Interfaz" del SIF:
	Colocar la ruta del Servidor_WEB: 'http://SERVIDOR_WEB/cfmx/'
	Activar el Motor de Interfaces
	Activar una a una las interfaces que van a funcionar en los Sistemas Externos

Para que el Sistema Externo utilice el WebService de Interfaces es necesario darles la siguiente información:
	El url del servidor SIF con la direccion del webservice:
		'http://SERVIDOR_WEB/cfmx/interfacesSoin/webService/interfaz-service.cfm'
	El alias del Cliente Empresarial (el que se pone en el campo Empresa de la pantalla de Login) 
	El id de empresa en la base de datos ASP (EcodigoSDC)
	Usuario y Password del usuario INTERFAZ

	select interfazToSoin('http://SERVIDOR_WEB/cfmx/interfacesSoin/webService/interfaz-service.cfm', 'Alias Cliente Empresarial','## EcodigoSDC','Usuario Portal','Password Portal','## de interfaz','## de proceso') as LvarMSG
	select interfazToSoin('http://desarrollo/cfmx/interfacesSoin/webService/interfaz-service.cfm', '','2','INTERFAZ','PASW0RD','8','12345') as LvarMSG
