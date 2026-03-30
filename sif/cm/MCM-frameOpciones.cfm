<cfinvoke component="home.Componentes.Seguridad" method="init" returnvariable="sec">
<cfset operaciones = ArrayNew(1)><!--- Coleccion de Opciones --->
<cfif isdefined("session.Compras.solicitante") and len(trim(session.Compras.solicitante))>
	<!--- Opciones solo de Solicitantes --->
	<cfif acceso_uri("/sif/cm/operacion/solicitudes-lista.cfm")>
		<cfset opcion = StructNew()><!--- Uri, Titulo, Descripcion --->
		<cfset opcion.uri = "/sif/cm/operacion/solicitudes-lista.cfm">
		<cfset opcion.titulo = "Registro de Solicitudes de Compra">
		<cfset opcion.descripcion = "Este proceso permite la inclusi&oacute;n de solicitudes de compra para cualquier art&iacute;culo, 
		servicio o activo que la empresa requiera adquirir, este proceso se realiza de forma individual por cada uno de 
		los solicitantes de la empresa previo a su aprobaci&oacute;n y tr&aacute;mite en el &aacute;rea de proveedur&iacute;a de la empresa.">
		<cfset ArrayAppend(operaciones,opcion)>
	</cfif>

</cfif>
<cfif isdefined("session.Compras.comprador") and len(trim(session.Compras.comprador))>
	<!--- Opciones solo de Compradores --->
	<!---<cfif acceso_uri("/sif/cm/operacion/reasignarCargas.cfm")>
		<cfset opcion = StructNew()><!--- Uri, Titulo, Descripcion --->
		<cfset opcion.uri = "/sif/cm/operacion/reasignarCargas.cfm">
		<cfset opcion.titulo = "Reasignar Cargas de Trabajo">
		<cfset opcion.descripcion = "Este proceso permite realizar la reasignaci&oacute;n de cargas de trabajo o solicitudes pendientes 
		de ser abastecidas entre los diferentes compradores de la empresa, el mismo es utilizado a fin de asignar solicitudes de 
		materiales a otros compradores de la empresa de acuerdo a la especializaci&oacute;n o disponibilidad de estos.">
		<cfset ArrayAppend(operaciones,opcion)>
	</cfif>
	--->
	<cfif acceso_uri("/sif/cm/operacion/compraProceso.cfm")>
		<cfset opcion = StructNew()><!--- Uri, Titulo, Descripcion --->
		<cfset opcion.uri = "/sif/cm/operacion/compraProceso.cfm">
		<cfset opcion.titulo = "Publicaci&oacute;n de Compra">
		<cfset opcion.descripcion = "Mediante este proceso se puede iniciar un trámite de compra, que incluye la selecci&oacute;n de las 
		líneas de cada solicitud de compra que se desea incluir en el proceso, la selecci&oacute;n de los proveedores que se desea que 
		participen, mediante cotizaciones, la publicaci&oacute;n del proceso, la importaci&oacute;n de las cotizaciones de los proveedores, y 
		la cotizaci&oacute;n manual, de ser necesario.">
		<cfset ArrayAppend(operaciones,opcion)>
	</cfif>
	<cfif acceso_uri("/sif/cm/operacion/listaOrdenCM.cfm")>
		<cfset opcion = StructNew()><!--- Uri, Titulo, Descripcion --->
		<cfset opcion.uri = "/sif/cm/operacion/listaOrdenCM.cfm">
		<cfset opcion.titulo = "&Oacute;rdenes de Compra">
		<cfset opcion.descripcion = "Este proceso permite realizar la creaci&oacute;n de &oacute;rdenes de compra de forma manual, este tipo de 
		&oacute;rdenes de compra se realiza en aquellos casos en que se desea realizar una compra directa o que no involucra una solicitud 
		de materiales o el proceso de cotizaron hacia proveedores.">
		<cfset ArrayAppend(operaciones,opcion)>
	</cfif>
	<cfif acceso_uri("/sif/cm/operacion/evaluarCotizaciones.cfm")>
		<cfset opcion = StructNew()><!--- Uri, Titulo, Descripcion --->
		<cfset opcion.uri = "/sif/cm/operacion/evaluarCotizaciones.cfm">
		<cfset opcion.titulo = "Evaluaci&oacute;n de Cotizaciones">
		<cfset opcion.descripcion = "Este proceso de la aplicaci&oacute;n es utilizado por los compradores de la empresa, el mismo permite a 
		cada uno de estos realizar la comparaci&oacute;n de las diferentes ofertas o cotizaciones que fueron realizadas a fin de abastecer o 
		surtir solicitudes de materiales. Como resultado de este proceso se obtiene una o varias &oacute;rdenes de compra que abastecen las 
		necesidades de las solicitudes de materiales que se cotizaron y que se evaluaron como parte del proceso.">
		<cfset ArrayAppend(operaciones,opcion)>
	</cfif>
	<cfif acceso_uri("/sif/cm/operacion/documentos-lista.cfm")>
		<cfset opcion = StructNew()><!--- Uri, Titulo, Descripcion --->
		<cfset opcion.uri = "/sif/cm/operacion/documentos-lista.cfm?tipo=R">
		<cfset opcion.titulo = "Registro de Documentos de Recepci&oacute;n">
		<cfset opcion.descripcion = "Este proceso permite posterior a la creaci&oacute;n y autorizaci&oacute;n de la orden de compra, realizar el 
		surtido de la misma. Se registra el ingreso de la mercadería solicitada para una o varias &oacute;rdenes de compra 
		definidas por el usuario que realiza la recepci&oacute;n de mercadería">
		<cfset ArrayAppend(operaciones,opcion)>
	</cfif>
	<cfif acceso_uri("/sif/cm/operacion/devolucion-lista.cfm")>
		<cfset opcion = StructNew()><!--- Uri, Titulo, Descripcion --->
		<cfset opcion.uri = "/sif/cm/operacion/devolucion-lista.cfm">
		<cfset opcion.titulo = "Registro de Documentos de Devoluci&oacute;n">
		<cfset opcion.descripcion = "Este proceso permite realizar la devoluci&oacute;n de mercadería al proveedor en aquellas ocasiones en que 
		esta ha sido previamente registrada. Esta devoluci&oacute;n se realiza con el fin de eliminar existencias del inventario e iniciar un 
		proceso de reclamo al proveedor por la mercadería devuelta por múltiples circunstancias.">
		<cfset ArrayAppend(operaciones,opcion)>
	</cfif>

	<cfif acceso_uri("/sif/cm/operacion/reclamos-lista.cfm")>
		<cfset opcion = StructNew()><!--- Uri, Titulo, Descripcion --->
		<cfset opcion.uri = "/sif/cm/operacion/reclamos-lista.cfm">
		<cfset opcion.titulo = "Trabajar con Reclamos">
		<cfset opcion.descripcion = "">
		<cfset ArrayAppend(operaciones,opcion)>
	</cfif>
	
	<cfif acceso_uri("/sif/cm/operacion/EDocumentos-lista.cfm")>
		<cfset opcion = StructNew()><!--- Uri, Titulo, Descripcion --->
		<cfset opcion.uri = "/sif/cm/operacion/EDocumentos-lista.cfm">
		<cfset opcion.titulo = "Registro de Transacciones">
		<cfset opcion.descripcion = "">
		<cfset ArrayAppend(operaciones,opcion)>
	</cfif>	

	<cfif acceso_uri("/sif/cm/operacion/polizaDesalmacenaje.cfm")>
		<cfset opcion = StructNew()><!--- Uri, Titulo, Descripcion --->
		<cfset opcion.uri = "/sif/cm/operacion/polizaDesalmacenaje.cfm">
		<cfset opcion.titulo = "P&oacute;lizas de Desalmacenaje">
		<cfset opcion.descripcion = "">
		<cfset ArrayAppend(operaciones,opcion)>
	</cfif>

	<cfif acceso_uri("/sif/cm/proveedor/trackingRegistro-lista.cfm")>
		<cfset opcion = StructNew()><!--- Uri, Titulo, Descripcion --->
		<cfset opcion.uri = "/sif/cm/proveedor/trackingRegistro-lista.cfm">
		<cfset opcion.titulo = "Administraci&oacute;n de Embarques">
		<cfset opcion.descripcion = "">
		<cfset ArrayAppend(operaciones,opcion)>
	</cfif>

	<cfif acceso_uri("/sif/cm/proveedor/trackingSeguimiento-lista.cfm")>
		<cfset opcion = StructNew()><!--- Uri, Titulo, Descripcion --->
		<cfset opcion.uri = "/sif/cm/proveedor/trackingSeguimiento-lista.cfm">
		<cfset opcion.titulo = "Seguimiento de Embarques">
		<cfset opcion.descripcion = "">
		<cfset ArrayAppend(operaciones,opcion)>
	</cfif>
</cfif>