<cfif isdefined("form.accion") and form.accion eq 1 >
	<!--- Borra los datos del usuario, pero solo los que desmarco --->
	<cfif isdefined("form.procesos_borrar") and len(trim(form.procesos_borrar)) gt 1>
		<!--- procesos_borrar puede traer datos repetidos, esto implica que va a 
		      ir varias veces a la bd con un mismo dato. La idea es eliminar los 
			  datos repetidos para evitar lo anterior.
		--->
		<cfset data = QueryNew("Ecodigo, SScodigo")>
		
		<cfset arreglo = ListToArray(form.procesos_borrar,'*') >
		<cfset ya_borrados = ''>
		<cfloop index="i" from="1" to="#ArrayLen(arreglo)#" >
			<cfset arreglo2 = ListToArray(arreglo[i],'|') >
			<cfset ya_borrado_pk = arreglo2[1]&'|'&arreglo2[2]&'|'&arreglo2[3]>
			<cfif Not ListFind(ya_borrados, ya_borrado_pk)>
				<cfset ya_borrados = ListAppend(ya_borrados, ya_borrado_pk)>
				<cfquery name="delete" datasource="asp">
					delete from UsuarioRol
					where Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Usucodigo#">
					  and Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arreglo2[2]#">
					  and SScodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#arreglo2[3]#">
					  and exists (select 1
						from SRoles
						where UsuarioRol.SScodigo = SRoles.SScodigo
						  and UsuarioRol.SRcodigo = SRoles.SRcodigo
						  and SRoles.SRinterno = 0)
				</cfquery>
			</cfif>
		</cfloop>
	</cfif>
	
	<cfif isdefined("form.roles")>
		<!--- Inserta los datos del usuario --->
		<cfloop index = "index" list = "#Form.roles#" delimiters = ",">
			<cfset data = ListToArray(index,'|') >
			
			<cfquery name="findReg" datasource="asp">
				select count(*) as cant
				from SRoles , UsuarioRol
				where UsuarioRol.SScodigo = SRoles.SScodigo
				  and UsuarioRol.SRcodigo = SRoles.SRcodigo
				  and SRoles.SRinterno = 0
			</cfquery>

			
			<cfif isdefined('findReg') and findReg.recordCount GT 0 and findReg.cant GT 0>

				<cfquery name="findUsuarioRol" datasource="asp">
					Select Usucodigo
					from UsuarioRol
					where Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Usucodigo#">
					  and Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#data[2]#">
					  and SScodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#data[3]#">
					  and SRcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#data[4]#">
				</cfquery>

				<cfquery name="insert" datasource="asp">
					<cfif isdefined('findUsuarioRol') and findUsuarioRol.recordCount GT 0 and findUsuarioRol.Usucodigo NEQ ''>
						update UsuarioRol
						set Usucodigo = Usucodigo
						where Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Usucodigo#">
						  and Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#data[2]#">
						  and SScodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#data[3]#">
						  and SRcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#data[4]#">
					<cfelse>
						insert INTO UsuarioRol( Usucodigo, Ecodigo, SScodigo, SRcodigo )
						select  <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#form.Usucodigo#">,
								#data[2]#,
								SScodigo, SRcodigo
						from SRoles
						where SScodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#data[3]#">
						  and SRcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#data[4]#">
						  and SRinterno = 0
					</cfif>
				</cfquery>				
            <cfelse>
				<cfquery name="insert" datasource="asp">
						insert INTO UsuarioRol( Usucodigo, Ecodigo, SScodigo, SRcodigo )
						select  <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#form.Usucodigo#">,
								#data[2]#,
								SScodigo, SRcodigo
						from SRoles
						where SScodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#data[3]#">
						  and SRcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#data[4]#">
						  and SRinterno = 0
				</cfquery>				

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
	<input type="hidden" name="opcion" value="R">
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