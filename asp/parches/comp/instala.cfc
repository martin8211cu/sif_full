<cfcomponent>
	
	<cffunction name="parametros_instalar">
		<cfparam name="session.instala" default="#StructNew()#">
		<cfparam name="session.instala.parche" default="">
		<cfparam name="session.instala.nombre" default="">
		<cfparam name="session.instala.ds" default="">
		<cfparam name="session.instala.instalacion" default="">
		<cfparam name="session.instala.contado" default="">
		<cfparam name="session.instala.dbms" default="">
	</cffunction>
	
	<cffunction name="get_servidor" returntype="string">
	
		<cfinvoke component="home.Componentes.aspmonitor" method="GetHostName" returnvariable="hostname"/>
		
		<cfquery datasource="asp" name="servidor">
			select servidor from APServidor
			where hostname = <cfqueryparam cfsqltype="cf_sql_varchar" value="#hostname#">
		</cfquery>
		<cfif Len(servidor.servidor)>
			<cfreturn servidor.servidor>
		</cfif>
		
		<cfinvoke component="misc" method="new_guid" returnvariable="srvguid"/>
		
		<cftry>
			<cfset ipaddr = CreateObject("java", "java.net.InetAddress").localhost.hostaddress>
		<cfcatch type="any">
			<cfset ipaddr = '127.0.0.1'>
		</cfcatch>
		</cftry>
		
		<cfquery datasource="asp">
			insert into APServidor (
				servidor, cliente, hostname, ipaddr,
				admin_email, notifica_instalacion, actualizado)
			values (
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#srvguid#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="Cliente sin especificar">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#hostname#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#ipaddr#">,
				null, 0, null)
		</cfquery>
		
		<cfreturn srvguid>
	
	</cffunction>
	
	<cffunction name="guardar" access="public">
		<cfif Len(session.instala.instalacion)>
			<!--- Asegurarme de que exista en la base de datos, si no lo voy a tener que insertar con un guid nuevo --->
			<cfquery datasource="asp" name="existe">
				select instalacion from APInstalacion
				where instalacion = <cfqueryparam cfsqltype="cf_sql_char" value="#session.instala.instalacion#">
			</cfquery>
			<cfif existe.RecordCount EQ 0>
				<cfset session.instala.instalacion = ''>
			</cfif>
		</cfif>
		
		<cfif Len(session.instala.instalacion)>
			<cfquery datasource="asp">
				update APInstalacion
				set nombre = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.parche.info.nombre#">,
				where instalacion = <cfqueryparam cfsqltype="cf_sql_char" value="#session.instala.instalacion#">
			</cfquery>
		<cfelse>
			<cfinvoke component="misc" method="new_guid" returnvariable="newguid"/>
			<cfinvoke component="instala" method="get_servidor" returnvariable="servidor"/>
			<cfquery datasource="asp">
				insert into APInstalacion (
					instalacion, parche, servidor, dbms,
					fecha, instalador, reporte)
				values (
					<cfqueryparam cfsqltype="cf_sql_char" value="#newguid#">,
					<cfqueryparam cfsqltype="cf_sql_char" value="#session.instala.parche#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#servidor#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#session.instala.dbms#">,

					<cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="(Nombre instalador)">,
					<cfqueryparam cfsqltype="cf_sql_timestamp" null="yes"> )
			</cfquery>
			<cfset session.instala.instalacion = newguid>
		</cfif>
	</cffunction>
	
	<cffunction name="nueva_tarea">
		<cfargument name="tipo">
		<cfargument name="ruta" default="">
		<cfargument name="datasource" default="">
	
			<cfquery datasource="asp" name="tareas">
				select coalesce ( max(num_tarea), 0) as max_tarea
				from APTareas
				where instalacion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.instala.instalacion#">
			</cfquery>

			<cfquery datasource="asp">
				insert into APTareas 
					(instalacion, num_tarea, tipo, ruta, datasource, inicio, fin)
				values (
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#session.instala.instalacion#">,
					<cfqueryparam cfsqltype="cf_sql_integer" value="#tareas.max_tarea+1#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.tipo#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.ruta#" null="#Len(Arguments.ruta) EQ 0#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.datasource#" null="#Len (Arguments.datasource) EQ 0#">,
					<cfqueryparam cfsqltype="cf_sql_timestamp" null="yes">,
					<cfqueryparam cfsqltype="cf_sql_timestamp" null="yes"> )
			</cfquery>
	</cffunction>
	
	<cffunction name="cargar_parche_jar">
		<cfargument name="nombre" type="string" required="yes">
		<cfargument name="xml" type="xml" required="yes">
		
		<cfset info = xml.parche.XmlAttributes>
		<cfif Not StructKeyExists(info, 'creado')>
			<cfset info.creado = Now()>
		</cfif>
		<cfif info.nombre NEQ Arguments.nombre>
			<cfthrow message="Nombre invalido dentro del XML: #info.nombre#">
		</cfif>
		<cfquery datasource="asp" name="buscar">
			select parche
			from APParche
			where nombre = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.nombre#">
		</cfquery>
		<cfif Len(buscar.parche)>
			<cfquery datasource="asp">
				update APParche
				set creado = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#info.creado#">,
					autor = <cfqueryparam cfsqltype="cf_sql_varchar" value="#info.autor#">,
					
					pdir = <cfqueryparam cfsqltype="cf_sql_varchar" value="#info.pdir#">,
					pnum = <cfqueryparam cfsqltype="cf_sql_varchar" value="#info.pnum#">,
					psec = <cfqueryparam cfsqltype="cf_sql_varchar" value="#info.psec#">,
					psub = <cfqueryparam cfsqltype="cf_sql_varchar" value="#info.psub#">,
					
					svnrev = <cfqueryparam cfsqltype="cf_sql_integer" value="#info.svnrev#">,
					modulo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#info.modulo#">,
					vistas = <cfqueryparam cfsqltype="cf_sql_bit" value="#info.vistas#">,
					xml = <cfqueryparam cfsqltype="cf_sql_longvarchar" value="#xml#">
				where parche = <cfqueryparam cfsqltype="cf_sql_varchar" value="#buscar.parche#">
			</cfquery>
			<cfset session.instala.parche = buscar.parche>
		<cfelse>
			<cfinvoke component="misc" method="new_guid" returnvariable="newguid"/>
			<cfquery datasource="asp">
				insert into APParche (
					parche, nombre, creado, modificado, autor,
					pdir, pnum, psec, psub, svnrev,
					entregado, cerrado, modulo, vistas, xml)
				values (
					<cfqueryparam cfsqltype="cf_sql_char" value="#newguid#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#info.nombre#">,
					<cfqueryparam cfsqltype="cf_sql_timestamp" value="#info.creado#">,
					null,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#info.autor#">,
		
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#info.pdir#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#info.pnum#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#info.psec#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#info.psub#">,
					<cfqueryparam cfsqltype="cf_sql_integer" value="#info.svnrev#">,
		
					null,
					null,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#info.modulo#">,
					<cfqueryparam cfsqltype="cf_sql_bit" value="#info.vistas#">,
					<cfqueryparam cfsqltype="cf_sql_longvarchar" value="#xml#">)
			</cfquery>
			<cfset session.instala.parche = newguid>
		</cfif>
		<cfset session.instala.nombre = Arguments.nombre>
	</cffunction>
	
	<cffunction name="retomar" output="false">
	
		<cfquery datasource="asp" name="contado">
			select count(1) as n
			from APConteo
			where instalacion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.instala.instalacion#">
			  and antes is not null
		</cfquery>
		<cfquery datasource="asp" name="contado2">
			select count(1) as n
			from APConteo
			where instalacion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.instala.instalacion#">
			  and despues is not null
		</cfquery>
		<cfquery datasource="asp" name="dss">
			select distinct datasource
			from APTareas
			where instalacion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.instala.instalacion#">
			order by datasource
		</cfquery>
		<cfquery datasource="asp" name="siguiente" maxrows="1">
			select num_tarea
			from APTareas
			where instalacion =<cfqueryparam cfsqltype="cf_sql_varchar" value="#session.instala.instalacion#">
			  and (inicio is null or fin is null)
			order by num_tarea asc
		</cfquery>
		
		<cfset session.instala.contado = contado.n GT 0>
		<cfset session.instala.contado2 = contado2.n GT 0>
		<cfinvoke component="asp.parches.comp.misc" method="dsinfotype2dbms"
			dsinfotype="#Application.dsinfo.asp.type#"
			returnvariable="dbms"/>
		<cfset session.instala.dbms = dbms>
		<cfset session.instala.ds = ValueList(dss.datasource)>
		<cfset session.instala.ejecutado = Len(siguiente.num_tarea) NEQ 0>

	</cffunction>
	
	<cffunction name="redactar_mensaje" output="false" returntype="struct">
		<cfset var ret = StructNew()>
		
		<cfsavecontent variable="message_body"><cfinclude template="/asp/parches/comp/instala_compose.cfm"></cfsavecontent>
		
		<cfset ret.subject = "[Parche instalado] " & session.instala.nombre>
		<cfset ret.body = message_body>
		<cfreturn ret>
	</cffunction>
	
</cfcomponent>