<cf_dbupload filefield="logo" accept="image/*" datasource="asp" queryparam="false" name="dbupload">
<cfif IsDefined('form.crear')>
	<cfparam name="form.emodelo" type="numeric">
	<cfinvoke component="genera_aspcuenta" method="crear" returnvariable="nuevo_CEcodigo"
		Mcodigo="#form.Mcodigo#"
		LOCidioma="#form.LOCidioma#"
		Cid="#form.Cid#"
		CEnombre="#form.Enombre#"
		CEaliaslogin="#form.CEaliaslogin#"
		CEtelefono1="#form.telefono1#"
		CEtelefono2="#form.telefono2#"
		CEfax="#form.fax#"
		logoblob="#dbupload.contents#"/>
	
	<cfinvoke component="genera_aspempresa" method="crear" returnvariable="nuevo_Ecodigo"
		CEcodigo="#nuevo_CEcodigo#"
		Cid="#form.Cid#"
		Mcodigo="#form.Mcodigo#"
		Enombre="#form.Enombre#"
		Etelefono1="#form.telefono1#"
		Etelefono2="#form.telefono2#"
		Efax="#form.fax#" 
		Eidentificacion="#form.Eidentificacion#" 
		logoblob="#dbupload.contents#"
		auditar="#IsDefined(form.auditar)#" />
	
	<!--- Empresa origen --->
	<cfquery datasource="asp" name="ori">
		select e.Ecodigo, e.CEcodigo, c.Ccache, e.Ereferencia
		from Empresa e
			join Caches c
				on e.Cid = c.Cid
		where e.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.emodelo#">
	</cfquery>
	
	<!--- Empresa destino --->
	<cfquery datasource="asp" name="dst">
		select e.Ecodigo, e.CEcodigo, c.Ccache, e.Ereferencia
		from Empresa e
			join Caches c
				on e.Cid = c.Cid
		where e.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#nuevo_Ecodigo#">
	</cfquery>

	<cfloop list="cuentas,cubo,cuboF,tipos,param,rhparam" index="componente">
		<cfinvoke component="genera_#componente#" method="copiar"
			dsori="#ori.Ccache#" Eori="#ori.Ereferencia#"
			dsdst="#dst.Ccache#" Edst="#dst.Ereferencia#" CEdst="#dst.CEcodigo#" />
	</cfloop>
	
	<!--- Crear súper usuario --->

	<!--- Inserta los datos personales --->
	<!---<cfset StructAppend(form, url)>--->
	<cf_datospersonales action="readform" name="data1">
	<cfif Not Len(data1.nombre)>
		<cfset data1.nombre = user>
	</cfif>
	<cf_datospersonales action="insert" name="data1" data="#data1#">
	<!--- Inserta la direccion --->
	<cf_direccion action="readform" name="data2">
	<cf_direccion action="insert" name="data2" data="#data2#">
	
	<!--- Inserta el usuario, le asocia la direccion y los datos personales --->
	<cfinvoke component="home.Componentes.Seguridad" method="init" returnvariable="sec">
	
	<cfset expira = CreateDate(6100,1,1)>
	<cfset idiomaUsuario = ''>
	<cfset usuario = sec.crearUsuario(dst.CEcodigo, data2.id_direccion,
		data1.datos_personales, idiomaUsuario, expira, form.username, false)>
	<cfset sec.renombrarUsuario(usuario, form.username, form.password)>
	<!--- asignar super permisos --->
	<cfset SScodigo= 'aspweb'>
	<cfset SRcodigo = 'aspweb_sa'>
	<cfquery datasource="asp">
		insert INTO UsuarioRol( Usucodigo, Ecodigo, SScodigo, SRcodigo )
		values (<cfqueryparam cfsqltype="cf_sql_numeric" value="#usuario#">,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#dst.Ecodigo#">,
				<cfqueryparam cfsqltype="cf_sql_char" value="#SScodigo#">,
				<cfqueryparam cfsqltype="cf_sql_char" value="#SRcodigo#">)
	</cfquery>
	<cfinvoke component="home.Componentes.MantenimientoUsuarioProcesos"
		method="actualizar"
		Usucodigo="#usuario#"
		SScodigo="#SScodigo#"
		Ecodigo="#dst.Ecodigo#" />

	<cflocation url="../permiso/simple.cfm?ce=#dst.CEcodigo#&e=#dst.Ecodigo#">
<cfelseif IsDefined('form.guardar')>

	<cfinvoke component="update_aspcuenta" method="update" returnvariable="nuevo_CEcodigo"
		CEcodigo="#form.ctae#"
		LOCidioma="#form.LOCidioma#"
		CEnombre="#form.Enombre#"
		CEaliaslogin="#form.CEaliaslogin#"
		CEtelefono1="#form.telefono1#"
		CEtelefono2="#form.telefono2#"
		CEfax="#form.fax#" 
		logoblob="#dbupload.contents#"/>
	
	<cfinvoke component="update_aspempresa" method="update" returnvariable="nuevo_Ecodigo"
		Ecodigo="#form.emp#"
		Enombre="#form.Enombre#"
		Etelefono1="#form.telefono1#"
		Etelefono2="#form.telefono2#"
		Efax="#form.fax#" 
		Eidentificacion="#form.Eidentificacion#" 
		logoblob="#dbupload.contents#"
		auditar="#IsDefined(form.auditar)#" />
	<cflocation url="index.cfm?ctae=#form.ctae#&emp=#form.emp#" addtoken="no">
<cfelse>
	<cfthrow message="Ay, ay, ay ay!">
</cfif>