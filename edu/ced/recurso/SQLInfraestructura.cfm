<cfset Gvar_action = "Infraestructura.cfm">
<cfset Gvar_params = "">

<cffunction access="private" description="Agregar parmetros para enviar por get." name="ParamsAppend">
	<cfargument name="name" required="yes" type="string">
	<cfargument name="value" required="yes" type="string">
	<cfif len(trim(Gvar_params)) eq 0>
		<cfset Gvar_params = ListAppend(Gvar_params, "?sql=1", "&")>
	</cfif>
	<cfset Gvar_params = ListAppend(Gvar_params, name&"="&value, "&")>
</cffunction>

<cffunction access="private" description="Cambiar Action del SQL" name="SetAction">
	<cfargument name="action" required="yes" type="string">
	<cfset Gvar_action = action>
</cffunction>


<!--- <cfset params=""> --->
<cfif not isdefined("Form.Nuevo")>
	<cfif isdefined("Form.Alta")>
		<cftransaction>
			<cfquery name="ins_Recurso" datasource="#Session.Edu.DSN#">
				insert into Recurso (CEcodigo, Rcodigo, Rdescripcion, Robservacion, Rcapacidad)
				values(
					<cfqueryparam value="#Session.Edu.CEcodigo#" cfsqltype="cf_sql_numeric">,
					<cfqueryparam value="#Form.Rcodigo#" cfsqltype="cf_sql_varchar">,
					<cfqueryparam value="#Form.Rdescripcion#" cfsqltype="cf_sql_varchar">,
					<cfqueryparam value="#Form.Robservacion#" cfsqltype="cf_sql_text">,
					<cfif len(trim(Form.Rcapacidad)) NEQ 0>
						<cfqueryparam value="#Form.Rcapacidad#" cfsqltype="cf_sql_numeric">
					<cfelse>
						0	
					</cfif>
					)
			<cf_dbidentity1 conexion="#Session.Edu.DSN#">
			</cfquery>
			<cf_dbidentity2 conexion="#Session.Edu.DSN#" name="ins_Recurso">
		</cftransaction>
<!--- 		<cfset params=params&"&Rcodigo="&rsInsert.identity> --->
			<cfset ParamsAppend("Rcodigo", ins_Recurso.Identity)>
			
	<cfelseif isdefined("Form.Baja")>
		<cfquery name="del_Recurso" datasource="#Session.Edu.DSN#">
			if not exists (select 1 from HorarioGuia  
							where Rconsecutivo =  <cfqueryparam value="#Form.Rconsecutivo#" cfsqltype="cf_sql_numeric">
			)
			begin
				delete from Recurso
				where Rconsecutivo = <cfqueryparam value="#Form.Rconsecutivo#" cfsqltype="cf_sql_numeric">
			end
		</cfquery>
		<cfset Gvar_action = "listaInfraestructura.cfm">
	<cfelseif isdefined("Form.Cambio")>
		<cfquery name="upd_Recurso" datasource="#Session.Edu.DSN#">
			update Recurso set
				Rcodigo	= <cfqueryparam value="#Form.Rcodigo#" cfsqltype="cf_sql_varchar">,
				Rdescripcion = ltrim(rtrim(<cfqueryparam value="#Form.Rdescripcion#" cfsqltype="cf_sql_varchar">)),
				Robservacion = ltrim(rtrim(<cfqueryparam value="#Form.Robservacion#" cfsqltype="cf_sql_text">)),
				<cfif len(trim(Form.Rcapacidad)) NEQ 0>
					Rcapacidad = <cfqueryparam value="#Form.Rcapacidad#" cfsqltype="cf_sql_numeric">
				<cfelse>
					Rcapacidad = 0	
				</cfif>	
			where Rconsecutivo = <cfqueryparam value="#Form.Rconsecutivo#" cfsqltype="cf_sql_numeric">
		</cfquery>
		<!--- <cfset params=params&"?Rconsecutivo="&Form.Rconsecutivo> --->
		<cfset ParamsAppend("Rconsecutivo", form.Rconsecutivo)>
	</cfif>
</cfif>

<!--- <cfif not isdefined("form.Nuevo") and not isdefined("Form.Baja")>
	<cflocation url="Infraestructura.cfm#params#">
<cfelse>
	<cfif isdefined("Form.Baja")>
		<cflocation url="Infraestructura.cfm">
	<cfelse>
		<cflocation url="Infraestructura.cfm">
	</cfif>
</cfif>
 --->

<cfset ParamsAppend("Pagina", #form.Pagina#)>
<cfset ParamsAppend("Filtro_Rdescripcion", #form.Filtro_Rdescripcion#)>
<cfset ParamsAppend("Filtro_Rcodigo", #form.Filtro_Rcodigo#)>
<cfset ParamsAppend("Filtro_Rcapacidad", #form.Filtro_Rcapacidad#)>


<!--- <form action="Infraestructura.cfm" method="post" name="sql">
	<input name="modo" type="hidden" value="<cfif isdefined("modo")><cfoutput>#modo#</cfoutput></cfif>">
	<input name="Rconsecutivo" type="hidden" value="<cfif isdefined("Form.Rconsecutivo")><cfoutput>#Form.Rconsecutivo#</cfoutput></cfif>">
	<input name="Pagina" type="hidden" value="<cfif isdefined("Form.Pagina")><cfoutput>#Form.Pagina#</cfoutput></cfif>">
</form>

<HTML>
<head>
</head>
<body>
<script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script>
</body>
</HTML>
 --->