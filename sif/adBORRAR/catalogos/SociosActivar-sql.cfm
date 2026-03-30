<!--- 
	esta pantalla no usa transacciones
	porque los metodos invocados ya son 
	transaccionales, y coldfusion no
	soporta transacciones anidadas
	Modificado por Gustavo Fonseca H.
	Fecha: 24-5-2005
	Motivo: Arreglar el tipo de dato para el CEcodigo, estaba como tipo integer, se dejó en numeric.
	Línea: 38
--->


<cfparam name="form.tipousuario" default="">
<cfinvoke component="home.Componentes.Seguridad" method="init" returnvariable="sec"/>

<cfquery datasource="#session.dsn#" name="SNegocios">
	select SNnombre, SNidentificacion, SNdireccion, SNtelefono, SNFax, SNemail, SNtiposocio
	from SNegocios
	where Ecodigo  = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	  and SNcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.SNcodigo#">
</cfquery>

<cfquery name="rsDatosCuenta" datasource="asp">
	select rtrim(a.LOCIdioma) as LOCIdioma, b.Ppais
	from CuentaEmpresarial a, Direcciones b
	where a.CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.CEcodigo#">
	and a.id_direccion = b.id_direccion
</cfquery>

<cfset usuario_existente = sec.getUsuarioByRef(form.SNcodigo, Session.EcodigoSDC, 'SNegocios')>

<cfif usuario_existente.RecordCount is 0>
	<cfif REFind('^[0-9]+$',form.tipousuario)>
		<cfquery datasource="asp" name="usuario_existente">
			select Usucodigo
			from Usuario
			where Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.tipousuario#">
			  and CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.CEcodigo#">
		</cfquery>
	</cfif>
</cfif>

<cfif usuario_existente.RecordCount>
	<cfset Usucodigo = usuario_existente.Usucodigo>
<cfelse>
	<cfif form.tipousuario is 'U'>
		<cfquery datasource="#session.dsn#" name="buscar_usulogin">
			select Usucodigo
			from Usuario
			where CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.CEcodigo#">
			  and Usulogin = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.usuario#">
		</cfquery>
		<cfif buscar_usulogin.RecordCount>
			<cflocation url="SociosActivar.cfm?SNcodigo=#URLEncodedFormat(Form.SNcodigo)#&tipousuario=#URLEncodedFormat(form.tipousuario)#&msg=existe" addtoken="no">
		</cfif>
		<cfset usulogin = form.usuario>
		<cfset enviar_password = false>
	<cfelseif form.tipousuario is 'T'>
		<cfset enviar_password = true>
		<cfset usulogin = ''>
	<cfelse>
		<cf_errorCode	code = "50006" msg = "tipousuario debe ser T (temporal) o U (usuario)">
	</cfif>
	
	<cf_datospersonales action="new" name="dp">
	<cfset dp.nombre   = SNegocios.SNnombre>
	<cfset dp.id       = SNegocios.SNidentificacion>
	<cfset dp.oficina  = SNegocios.SNtelefono>
	<cfset dp.fax      = SNegocios.SNFax>
	<cfset dp.email1   = SNegocios.SNemail>
	<cf_datospersonales action="insert" data="#dp#">
	<cf_direccion action="new" name="dr">
	<cfset dr.direccion1 = SNegocios.SNdireccion>
	<cfset dr.Pais = rsDatosCuenta.Ppais>
	<cf_direccion action="insert" data="#dr#">
	
	<cfset Usucodigo = sec.crearUsuario(Session.CEcodigo,
		cf_direccion.id_direccion, cf_datospersonales.datos_personales, 
		rsDatosCuenta.LOCIdioma, ParseDateTime('01/01/6100','dd/mm/yyyy'), usulogin, enviar_password)>
	<cfset sec.renombrarUsuario(Usucodigo,usuario,form.passwd)>
</cfif>

<!--- Asociar Referencia --->
<cfset ref = sec.insUsuarioRef(Usucodigo, Session.EcodigoSDC, 'SNegocios', form.SNcodigo)>

<cfif ListFind('P,A', SNegocios.SNtiposocio)>
	<!--- Insertar Rol de Proveedor --->
	<cfset rolIns = sec.insUsuarioRol(Usucodigo, Session.EcodigoSDC, 'SIF', 'PROVEEDOR')>
</cfif>	
<cfif ListFind('C,A', SNegocios.SNtiposocio)>
	<!--- Insertar Rol de Cliente --->
	<cfset rolIns = sec.insUsuarioRol(Usucodigo, Session.EcodigoSDC, 'SIF', 'CLIENTE')>
</cfif>	
t
<cflocation url="Socios.cfm?SNcodigo=#URLEncodedFormat(Form.SNcodigo)#" addtoken="no">

