<cfquery datasource="#session.DSN#" >
	update Empresas
	set Edescripcion = <cfqueryparam cfsqltype="cf_sql_char" value="#form.nombre_tienda#">
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
</cfquery>
<cfquery datasource="asp">
	update Empresa
	set Enombre = <cfqueryparam cfsqltype="cf_sql_char" value="#form.nombre_tienda#">
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.EcodigoSDC#">
</cfquery>
<cfparam name="form.tipo_vista" default="C">
<cfif form.tipo_vista NEQ "C" and form.tipo_vista NEQ "M">
	<cfset form.tipo_vista="C">
</cfif>
<!--- Guardar ArteTienda --->
<cfquery datasource="#session.DSN#" name="update1">
	update ArteTienda
	set font = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.font#" null="#Len(Trim(form.font)) is 0#">
	, txt_pie_foto = <cfqueryparam cfsqltype="cf_sql_longvarchar" value="#Trim(form.txt_pie_foto)#" null="#Len(Trim(form.txt_pie_foto)) IS 0#">
	, agregar_uno = <cfif isdefined("form.agregar_uno")>1<cfelse>0</cfif>
	, tipo_vista = <cfqueryparam cfsqltype="cf_sql_char" value="#form.tipo_vista#">
	, correo_clientes = <cfqueryparam cfsqltype="cf_sql_char" value="#form.correo_clientes#">
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
	select @@rowcount as num_registros
</cfquery>
<cfif update1.num_registros EQ 0><cfquery datasource="#session.DSN#">
	insert ArteTienda 
		(Ecodigo, font, txt_pie_foto, agregar_uno, tipo_vista, correo_clientes)
	values (
		<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">,
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.font#">,
		<cfqueryparam cfsqltype="cf_sql_longvarchar" value="#form.txt_pie_foto#" null="#Len(Trim(form.txt_pie_foto)) IS 0#">,
		<cfif isdefined("form.agregar_uno")>1<cfelse>0</cfif>,
		<cfqueryparam cfsqltype="cf_sql_char" value="#form.tipo_vista#">,
		<cfqueryparam cfsqltype="cf_sql_char" value="#form.correo_clientes#">)
</cfquery></cfif>

<!--- Guardar imagen --->
<cfif IsDefined("form.logo") and Len(form.logo) GT 2>
	<cffile action="Upload" fileField="form.logo"
		destination="#GetTempDirectory()#" nameConflict="Overwrite" accept="image/*">
	<!--- cfdump var="#GetTempDirectory()#"--->
	<cffile action="readbinary" file="#GetTempDirectory()##cffile.serverFile#" variable="tmp" >
	<cffile action="delete" file="#gettempdirectory()##cffile.serverFile#" >
	<cfquery datasource="#session.dsn#">
		update ArteTienda
		set img_logo = 0x<cfoutput><cfloop from="1" to="#Len(tmp)#" index="i"><cfif tmp[i] GE 0 AND tmp[i] LE 15
				>0#FormatBaseN((tmp[i]+256)mod 256,16)#<cfelseif tmp[i] GT 0 
				>#FormatBaseN(tmp[i],16)#<cfelse>#FormatBaseN(tmp[i]+256,16)#</cfif></cfloop></cfoutput>
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
	</cfquery>	
	<cfquery datasource="asp" >
		update Empresa
		set Elogo = 0x<cfoutput><cfloop from="1" to="#Len(tmp)#" index="i"><cfif tmp[i] GE 0 AND tmp[i] LE 15
				>0#FormatBaseN((tmp[i]+256)mod 256,16)#<cfelseif tmp[i] GT 0 
				>#FormatBaseN(tmp[i],16)#<cfelse>#FormatBaseN(tmp[i]+256,16)#</cfif></cfloop></cfoutput>
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.EcodigoSDC#">
	</cfquery>
	
</cfif>

<cflocation url="tienda.cfm">