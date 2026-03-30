<cfif isdefined("Form.btnEliminar") and isdefined("Form.ILinea") and Len(Trim(Form.ILinea)) GT 0>
	<cfquery name="rsdelete" datasource="#Session.DSN#">
		delete from ImagenArt
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
		  and ILinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.ILinea#">
	</cfquery>
</cfif>

<cfset error = false >
<cfif Len(Trim(Form.FiletoUpload)) GT 0 and not isdefined("Form.btnEliminar")>
	<cfif not error >
		<cftry>
			<cfquery name="ABCimagen" datasource="#Session.DSN#">
				insert into ImagenArt (Ecodigo, Aid, IAimagen)
				values( <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">, 
					   <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Aid#">, 
					   <cf_dbupload filefield="filetoupload" accept="image/*" datasource="#session.dsn#"> )
			</cfquery>
		<cfcatch type="any">
			<cfset Request.Error.backs = 1 >
			<cf_errorCode	code = "50398" msg = "El tipo del archivo que desea agregar no corresponde a una imagen.">
			<cfabort>
		</cfcatch>	
		</cftry>
	</cfif>
</cfif>		

<cfset params="">
<cfif isdefined('form.filtro_Acodigo') and form.filtro_Acodigo NEQ ''>
	<cfset params= params&'&filtro_Acodigo='&form.filtro_Acodigo>	
	<cfset params= params&'&hfiltro_Acodigo='&form.filtro_Acodigo>		
</cfif>
<cfif isdefined('form.filtro_Acodalterno') and form.filtro_Acodalterno NEQ ''>
	<cfset params= params&'&filtro_Acodalterno='&form.filtro_Acodalterno>	
	<cfset params= params&'&hfiltro_Acodalterno='&form.filtro_Acodalterno>	
</cfif>
<cfif isdefined('form.filtro_Adescripcion') and form.filtro_Adescripcion NEQ ''>
	<cfset params= params&'&filtro_Adescripcion='&form.filtro_Adescripcion>	
	<cfset params= params&'&hfiltro_Adescripcion='&form.filtro_Adescripcion>	
</cfif>

<cfif isdefined('form.Regresar')>
	<cflocation url="articulos-lista.cfm?Pagina=#Form.Pagina##params#">
<cfelse>
	<cflocation url="ImgArticulos.cfm?Aid=#form.Aid#&Pagina=#Form.Pagina##params#">
</cfif>

