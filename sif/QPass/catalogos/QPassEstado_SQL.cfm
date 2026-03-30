<!---NUEVO Estado--->
<cfif IsDefined("form.Nuevo")>
	<cflocation url="QPassEstado.cfm?Nuevo">
</cfif>

	<cfif isdefined("form.QEPvalorDefault")>
		<cfquery name="rsEs" datasource="#session.dsn#">
			select 1 as cantidad 
				from QPassEstado
			where Ecodigo = #session.Ecodigo#
			and QEPvalorDefault = 1
		</cfquery>
	</cfif>
	
	<cfif isdefined("Form.Cambio")>
		<cfquery name="rsEs2" datasource="#session.dsn#">
			select 1 as cantidad 
				from QPassEstado
			where Ecodigo = #session.Ecodigo#
		</cfquery>

	
		<cfset cant = #rsEs2.cantidad#>
</cfif>
<cfif isdefined("Form.Alta")>
	<cfif isdefined('form.QEPvalorDefault') and #rsEs.cantidad# GT 0>
		<cfquery name="rsUpdateOmision" datasource="#session.DSN#">
			update QPassEstado
				set QEPvalorDefault = 0
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		</cfquery>
	</cfif>

	<cfquery name="insertEstado" datasource="#session.dsn#">
		insert into QPassEstado (QPEdescripcion , QPEdisponibleVenta  , QEPvalorDefault ,Ecodigo)
			values(
				<cfqueryparam cfsqltype="cf_sql_char" value="#form.QPEdescripcion#">,
				<cfif isdefined("Form.QPEdisponibleVenta")>1<cfelse>0</cfif>,
				<cfif isdefined("Form.QEPvalorDefault")>1<cfelse>0</cfif>,
				<cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">	
				)
		<cf_dbidentity1 datasource="#Session.DSN#" verificar_transaccion="false">
	</cfquery>
	<cf_dbidentity2 datasource="#Session.DSN#" name="insertEstado" verificar_transaccion="false" returnvariable="QPidEstado">
	<cflocation url="QPassEstado.cfm?QPidEstado=#QPidEstado#" addtoken="no">
	
<cfelseif isdefined("Form.Baja") or isdefined ("btnEliminar")>
	<cfif isdefined("form.chk") and len(trim(form.chk)) GT 0>
		<cfquery name="rsDelete" datasource="#session.DSN#">
			delete from QPassEstado
			where Ecodigo = #session.Ecodigo#
			  and QPidEstado in  (#form.chk#)
		</cfquery>	
	<cfelseif isdefined("form.QPidEstado") and len(trim(form.QPidEstado)) GT 0>
		<cfquery name="rsDelete" datasource="#session.DSN#">
			delete from QPassEstado
			where Ecodigo = #session.Ecodigo#
				and QPidEstado  = #form.QPidEstado#
		</cfquery>	
	</cfif>
	<cflocation url="QPassEstado.cfm" addtoken="no">	
<cfelseif isdefined("Form.Cambio")>
	<cfif #cant# GT 0>
		<cfquery name="rsUpdateOmision" datasource="#session.DSN#">
			update QPassEstado
				set QEPvalorDefault = 0
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		</cfquery>

		<cfquery name="rsUpdate" datasource="#session.DSN#">
			update QPassEstado
				set QPEdescripcion 	= <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.QPEdescripcion#">,
				QPEdisponibleVenta  = <cfif isdefined("form.QPEdisponibleVenta") and len(trim(form.QPEdisponibleVenta))> 1 <cfelse> 0 </cfif>, 
				QEPvalorDefault  	= <cfif isdefined("form.QEPvalorDefault") and len(trim(form.QEPvalorDefault))> 1 <cfelse> 0 </cfif> 
			where Ecodigo 		= <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			and QPidEstado 	= #form.QPidEstado#
		</cfquery>
	</cfif>	
	<cflocation url="QPassEstado.cfm?QPidEstado=#form.QPidEstado#&pagenum3=#form.Pagina3#">
</cfif>
<cfset form.Modo = "Cambio">
<cflocation url="QPassEstado.cfm?QPidEstado=#form.QPidEstado#" addtoken="no">


