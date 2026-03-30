<cfif isdefined("form.accion") and form.accion eq 1 >
	<!--- Borra los datos del usuario, pero solo los que desmarco --->
	<cfif isdefined("form.procesos_borrar") and len(trim(form.procesos_borrar)) gt 1>
		<!--- procesos_borrar puede traer datos repetidos, esto implica que va a 
		      ir varias veces a la bd con un mismo dato. La idea es eliminar los 
			  datos repetidos para evitar lo anterior.
		--->
		<cfset arreglo = ListToArray(form.procesos_borrar,'*') >
		<cfset ya_borrados = ''>
		<cfloop index="i" from="1" to="#ArrayLen(arreglo)#" >
			<cfset arreglo2 = ListToArray(arreglo[i],'|')>
			<cfset ya_borrado_pk = arreglo2[2]&'|'&arreglo2[3]&'|'&arreglo2[4]>
			<cfif Not ListFind(ya_borrados, ya_borrado_pk)>
				<cfset ya_borrados = ListAppend(ya_borrados, ya_borrado_pk)>
				<cfquery name="delete" datasource="asp">
					delete from UsuarioProceso
					where Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Usucodigo#">
					  and Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arreglo2[2]#">
					  and SScodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#arreglo2[3]#">
					  and SMcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#arreglo2[4]#">
					  and exists (select 1
						from SProcesos
						where UsuarioProceso.SScodigo = SProcesos.SScodigo
						  and UsuarioProceso.SMcodigo = SProcesos.SMcodigo
						  and UsuarioProceso.SPcodigo = SProcesos.SPcodigo
						  and SProcesos.SPinterno = 0)
				</cfquery>
			</cfif>
		</cfloop>
	</cfif>
	
	<cfif isdefined("form.permisos")>
		<!--- Inserta los datos del usuario --->
		<cfloop index = "index" list = "#Form.permisos#" delimiters = ",">
			<cfset data = ListToArray(index,'|') >
			
			<cfquery name="actuar" datasource="asp">
				select SScodigo
				from SProcesos
				where SPinterno = 0			
					and SScodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#data[3]#">
					and SMcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#data[4]#">
					and SPcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#data[5]#">
			</cfquery>
			
			<cfif isdefined('actuar') and actuar.recordCount GT 0 and actuar.SScodigo NEQ ''>
				<cfquery name="cambioUPtipo" datasource="asp">
					select UPtipo
					from UsuarioProceso
					where Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Usucodigo#">
					  and Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#data[2]#">
					  and SScodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#data[3]#">
					  and SMcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#data[4]#">
					  and SPcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#data[5]#">
				</cfquery>

				<cfif isdefined('cambioUPtipo') and cambioUPtipo.recordCount GT 0 and cambioUPtipo.UPtipo NEQ ''>
					<cfif cambioUPtipo.UPtipo NEQ 'G'>
						<cfquery name="cambioUsuarioProceso" datasource="asp">
							update UsuarioProceso
							set UPtipo = 'G'
							where Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Usucodigo#">
							  and Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#data[2]#">
							  and SScodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#data[3]#">
							  and SMcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#data[4]#">
							  and SPcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#data[5]#">					
						</cfquery>  
					</cfif>
				<cfelse>
					<cfquery datasource="asp">
						insert INTO UsuarioProceso( Usucodigo, Ecodigo, SScodigo, SMcodigo, SPcodigo, UPtipo )
						values (<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Usucodigo#">,
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#data[2]#">,
							<cfqueryparam cfsqltype="cf_sql_char" value="#data[3]#">,
							<cfqueryparam cfsqltype="cf_sql_char" value="#data[4]#">,
							<cfqueryparam cfsqltype="cf_sql_char" value="#data[5]#">,
							'G')
					</cfquery>
				</cfif>
			</cfif>
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
<html><head></head><body><script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script></body></html>