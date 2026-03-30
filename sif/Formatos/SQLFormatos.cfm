<cfif not isdefined("Form.Nuevo")>
	<cfif isdefined("Form.Alta")>
		<cfset vEFdescalterna = Replace(form.EFdescalterna,'<p>&nbsp;</p>','','all')>
		<cfset vEFdescalterna= Replace(vEFdescalterna,'<p><font face="Times New Roman" size="3">&nbsp;</font></p>','<font face="Times New Roman" size="3">&nbsp;</font>','all')>
		<cftransaction>
			<cfquery name="ABC_Formatos" datasource="#Session.DSN#">
				insert INTO EFormato (EFcodigo, Ecodigo, EFdescripcion, TFid, Usucodigo, Ulocalizacion, EFfecha, EFpautogestion,EFdescalterna)
				values (
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.EFcodigo#">,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.EFdescripcion#">,
					<cfqueryparam cfsqltype="cf_sql_integer" value="#Form.TFid#">,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">,
					<cfqueryparam cfsqltype="cf_sql_char" value="#Session.Ulocalizacion#">,
					<cfqueryparam cfsqltype="cf_sql_date" value="#now()#">,
					<cfif isdefined("form.EFpautogestion")>1<cfelse>0</cfif>,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#PreserveSingleQuotes(vEFdescalterna)#">
				)
				<cf_dbidentity1 datasource="#Session.DSN#">
			</cfquery>
			<cf_dbidentity2 datasource="#Session.DSN#" name="ABC_Formatos">
		</cftransaction>

		<cfif isdefined('ABC_Formatos.identity') and ABC_Formatos.identity NEQ ''>
			<cfset vDFtexto= Replace(form.DFtexto,'<p>&nbsp;</p>','','all')>
			<cfset vDFtexto= Replace(vDFtexto,'<p><font face="Times New Roman" size="3">&nbsp;</font></p>','<font face="Times New Roman" size="3">&nbsp;</font>','all')>
			<cfquery name="ABC_FormatosDet" datasource="#Session.DSN#">
				insert INTO DFormato(EFid, DFtexto)
				values(
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#ABC_Formatos.identity#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#PreserveSingleQuotes(vDFtexto)#">)
			</cfquery>
		</cfif>

		<cfset modo="ALTA">
	<cfelseif isdefined("Form.Baja")>
		<cfquery name="ABC_Formatos" datasource="#Session.DSN#">
			delete from DFormato
			where EFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.EFid#">
				and DFlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.DFlinea#">
		</cfquery>

		<cfquery name="ABC_Formatos" datasource="#Session.DSN#">
			delete from EFormato
			where EFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.EFid#">
		</cfquery>

		<cfset modo="BAJA">
	<cfelseif isdefined("Form.Cambio")>
		<cfset vEFdescalterna = Replace(form.EFdescalterna,'<p>&nbsp;</p>','','all')>
		<cfset vEFdescalterna= Replace(vEFdescalterna,'<p><font face="Times New Roman" size="3">&nbsp;</font></p>','<font face="Times New Roman" size="3">&nbsp;</font>','all')>
		<cfquery datasource="#Session.DSN#">
			update EFormato
			   set EFcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.EFcodigo#">,
				   EFdescripcion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.EFdescripcion#">,
				   TFid = <cfqueryparam cfsqltype="cf_sql_integer" value="#Form.TFid#">,
				   EFfecha = <cfqueryparam cfsqltype="cf_sql_date" value="#now()#">,
				   EFpautogestion = <cfif isdefined("form.EFpautogestion")>1<cfelse>0</cfif>,
				   EFdescalterna = <cfqueryparam cfsqltype="cf_sql_varchar" value="#PreserveSingleQuotes(vEFdescalterna)#">
			where EFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.EFid#">
		</cfquery>
		<cfset vDFtexto= Replace(form.DFtexto,'<p>&nbsp;</p>','','all')>
		<cfset vDFtexto= Replace(vDFtexto,'<p><font face="Times New Roman" size="3">&nbsp;</font></p>','<font face="Times New Roman" size="3">&nbsp;</font>','all')>
		<cfquery datasource="#Session.DSN#">
			update DFormato
			   set DFtexto = <cfqueryparam cfsqltype="cf_sql_varchar" value="#PreserveSingleQuotes(vDFtexto)#">
			where EFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.EFid#">
				and DFlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.DFlinea#">
		</cfquery>

		<cfset modo="CAMBIO">
	</cfif>
</cfif>

<cfoutput>
<cfset param = ''>
<cfif isdefined("form.Cambio") and isdefined("form.EFid") and len(trim(form.EFid))>
	<cfset param = param & "?EFid=#form.EFid#">
<cfelseif isdefined("Form.Alta") and isdefined("ABC_Formatos.identity") and len(trim(ABC_Formatos.identity))>
	 <cfset param = param & "?EFid=#ABC_Formatos.identity#">
</cfif>
<cflocation url="Formatos.cfm#param#">
</cfoutput>
