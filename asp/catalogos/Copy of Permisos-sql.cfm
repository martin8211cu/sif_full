<cfif isdefined("form.accion") and form.accion eq 1 >
	<!--- Borra los datos del usuario, pero solo los que desmarco --->
	<cfif isdefined("form.procesos_borrar") and len(trim(form.procesos_borrar)) gt 1>
		<!--- procesos_borrar puede traer datos repetidos, esto implica que va a 
		      ir varias veces a la bd con un mismo dato. La idea es eliminar los 
			  datos repetidos para evitar lo anterior.
		--->
		<cfset data = QueryNew("Ecodigo, SScodigo, SMcodigo")>
		
		<cfset arreglo = ListToArray(form.procesos_borrar,'*') >
		<cfloop index="i" from="1" to="#ArrayLen(arreglo)#" >
			<cfset arreglo2 = ListToArray(arreglo[i],'|') >
			<cfset fila = QueryAddRow(data, 1)>
			<cfset tmp  = QuerySetCell(data, "Ecodigo",  #arreglo2[2]#) >
			<cfset tmp  = QuerySetCell(data, "SScodigo", #arreglo2[3]#) >
			<cfset tmp  = QuerySetCell(data, "SMcodigo", #arreglo2[4]#) >
		</cfloop>	
		
		<cfquery name="rsData" dbtype="query">
			select distinct Ecodigo, SScodigo, SMcodigo from data
		</cfquery>

		<!--- Borra los procesos para la combinacion empresa/sistema/modulo--->
		<cfloop query="rsData">
			<cfquery name="delete" datasource="asp">
				delete UsuarioProceso
				where Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Usucodigo#">
				  and Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsData.Ecodigo#">
				  and SScodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#rsData.SScodigo#">
				  and SMcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#rsData.SMcodigo#">
				  and exists (select 1
					from SProcesos
					where UsuarioProceso.SScodigo = SProcesos.SScodigo
					  and UsuarioProceso.SMcodigo = SProcesos.SMcodigo
					  and UsuarioProceso.SPcodigo = SProcesos.SPcodigo
					  and SProcesos.SPinterno = 0)
				
			</cfquery>
		</cfloop>
	</cfif>
	
	<cfif isdefined("form.permisos")>
		<!--- Inserta los datos del usuario --->
		<cfloop index = "index" list = "#Form.permisos#" delimiters = ",">
			<cfset data = ListToArray(index,'|') >
			<cfquery name="insert" datasource="asp">
				update UsuarioProceso
				set UPtipo = 'G'
				where Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Usucodigo#">
				  and Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#data[2]#">
				  and SScodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#data[3]#">
				  and SMcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#data[4]#">
				  and SPcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#data[5]#">
				  and exists (select 1
					from SProcesos
					where UsuarioProceso.SScodigo = SProcesos.SScodigo
					  and UsuarioProceso.SMcodigo = SProcesos.SMcodigo
					  and UsuarioProceso.SPcodigo = SProcesos.SPcodigo
					  and SProcesos.SPinterno = 0)

				if @@rowcount = 0 begin
					insert UsuarioProceso( Usucodigo, Ecodigo, SScodigo, SMcodigo, SPcodigo, UPtipo )
					select  <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Usucodigo#">,
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#data[2]#">,
							SScodigo, SMcodigo, SPcodigo,
							'G'
					from SProcesos
					where SScodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#data[3]#">
					  and SMcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#data[4]#">
					  and SPcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#data[5]#">
					  and SPinterno = 0
				end	
			</cfquery>
		
		</cfloop>
	</cfif>
	<cfinvoke component="home.Componentes.MantenimientoUsuarioProcesos"
		method="actualizar">
		<cfinvokeargument name="Usucodigo" value="#form.Usucodigo#">
	</cfinvoke>
</cfif>

<cfoutput>
<form action="Permisos.cfm" method="post" name="sql">
	<input name="fEmpresa" type="hidden" value="<cfif isdefined("form.fEmpresa")>#form.fEmpresa#</cfif>">

	<cfif isdefined("form.accion") and form.accion eq 1 >
		<input name="Usucodigo" type="hidden" value="<cfif isdefined("Form.Usucodigo")>#Form.Usucodigo#</cfif>">
	</cfif>	
</form>
</cfoutput>

<HTML>
<head>
</head>
<body>
<script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script>
</body>
</HTML>