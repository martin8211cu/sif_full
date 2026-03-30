<cfset params = "">
<cf_navegacion name="Aid" navegacion="">
<cf_navegacion name="AFAlinea" navegacion="">
<cf_navegacion name="Download" navegacion="">

<cf_dbfunction name="OP_concat"	args="" returnvariable="LvarConcat">
<!--- AFAfecha2 no tiene ninguna regla definida --->
<cfif isdefined("Form.Alta")>
	<cftransaction>
	<cfset AFAfecha2 = '01/01/6100'>
		<cfquery name="rsInsert" datasource="#session.DSN#">
			insert into AFAnotaciones
			(Ecodigo, Aid, AFAtipo, AFAfecha, AFAtexto, AFAfecha1, AFAfecha2) values (
			#session.Ecodigo#,
			<cfqueryparam cfsqltype="cf_sql_numeric" 	value="#form.Aid#">, 0,
			<cfqueryparam cfsqltype="cf_sql_timestamp" 	value="#Now()#">,
			<cfqueryparam cfsqltype="cf_sql_varchar" 	value="#form.Anotacion#">,
			<cfqueryparam cfsqltype="cf_sql_timestamp" 	value="#LSParseDateTime(form.AFAfecha1)#">,
			#lsparsedatetime(AFAfecha2)# )
			<cf_dbidentity1>
		</cfquery>
		<cf_dbidentity2 name="rsInsert">
		<cfif len(trim(form.AFimagen))>
		  <cfset form.AFnombreImagen= UCASE(form.AFnombreImagen)>
		 		<cfquery name="rsInsert2" datasource="#session.DSN#">
				insert into AFImagenes
				(Ecodigo, Aid, AFAlinea, AFimagen, AFextension,AFnombre)values (
				#session.Ecodigo#,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Aid#">,
				#rsInsert.identity#,
				<cf_dbupload filefield="AFimagen" accept="image/gif,image/jpeg,image/pjpeg,image/png,image/x-png" datasource="#session.dsn#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.AFnombreImagen#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.AFnombre#">)
			</cfquery>
		</cfif>
	</cftransaction>
<cfelseif isdefined("Form.Baja")>
	<cftransaction>
		<cfquery datasource="#session.dsn#">
			delete from AFImagenes
				where Ecodigo = #session.Ecodigo#
				and Aid 	  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Aid#">
				and AFAlinea  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.AFAlinea#">
		</cfquery>
		<cfquery datasource="#session.dsn#">
			delete from AFAnotaciones
				where Ecodigo = #session.Ecodigo#
				and Aid 	  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Aid#">
				and AFAlinea  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.AFAlinea#">
		</cfquery>
	</cftransaction>
<cfelseif isdefined("Form.Cambio")>
	<cftransaction>
			<cfquery datasource="#session.dsn#">
				update AFAnotaciones
					set AFAfecha1 = <cfqueryparam cfsqltype="cf_sql_timestamp" 	value="#LSParseDateTime(form.AFAfecha1)#">,
					AFAtexto 	  = <cfqueryparam cfsqltype="cf_sql_varchar" 	value="#form.Anotacion#">
				where Ecodigo     = #session.Ecodigo#
				and Aid 		  = <cfqueryparam cfsqltype="cf_sql_numeric" 	value="#form.Aid#">
				and AFAlinea      = <cfqueryparam cfsqltype="cf_sql_numeric" 	value="#form.AFAlinea#">
			</cfquery>
	   <cfif len(trim(form.AFimagen))>
	   <cfset form.AFnombreImagen= UCASE(form.AFnombreImagen)>
			<cfquery datasource="#session.dsn#">
					update AFImagenes
						set AFimagen = <cf_dbupload filefield="AFimagen" accept="image/*,text/*,application/*" datasource="#session.dsn#">,
						AFextension =  <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.AFnombreImagen#">
					where Ecodigo 	 = #session.Ecodigo#
					and Aid          = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Aid#">
					and AFAlinea     = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.AFAlinea#">
			</cfquery>
		</cfif>
	</cftransaction>
<cfelseif IsDefined("form.Download")>
	<cfquery name="rsArchivo" datasource="#session.dsn#">
		select cast(b.AFAtexto as varchar) #LvarConcat# '.' #LvarConcat# a.AFextension as archivo,
		      AFimagen
		  from AFImagenes a inner join AFAnotaciones b
		    on a.Aid = b.Aid and a.AFAlinea = b.AFAlinea
		where a.Aid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Aid#" null="#Len(form.Aid) Is 0#">
		and a.AFAlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.AFAlinea#" null="#Len(form.AFAlinea) Is 0#">
		and a.Ecodigo =#session.Ecodigo#
	</cfquery>

	<cfset LvarFile = GetTempFile(GetTempDirectory(),"archivos")>
	<cffile action="write" file="#LvarFile#" output="#rsArchivo.AFimagen#" >

	<cfheader name="Content-Disposition"	value="attachment;filename=#rsArchivo.archivo#">
	<cfheader name="Expires" value="0">
	<cfcontent type="*/*" reset="yes" file="#LvarFile#" deletefile="yes">

	<cflocation url="Activos.cfm?tab=2&Aid=#form.Aid#">
</cfif>
<cflocation url="Activos.cfm?tab=2&Aid=#form.Aid#">
