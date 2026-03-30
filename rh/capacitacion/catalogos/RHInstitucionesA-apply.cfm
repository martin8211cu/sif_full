<cfif IsDefined("form.Cambio")>
		<cf_dbtimestamp datasource="#session.dsn#"
				table="RHInstitucionesA"
				redirect="metadata.code.cfm"
				timestamp="#form.ts_rversion#"
				field1="RHIAid"
				type1="numeric"
				value1="#form.RHIAid#"
		>


	<cfquery datasource="#session.dsn#" name="rsExiste">
    	select * from RHInstitucionesA
        where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
        and RHIAcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#form.RHIAcodigo#" null="#Len(form.RHIAcodigo) Is 0#">
    </cfquery>

	<cfif isdefined('rsExiste') and rsExiste.RecordCount NEQ 0   >
        <cfset TitleErrs = 'Operación Inválida'>
        <cfset MsgErr	 = 'Instituciones Académicas'>
        <cfset DetErrs 	 = 'El codigo de institucion que esta modificando ya existe, Verificar.'>
        <cflocation url="/cfmx/sif/errorPages/BDerror.cfm?errType=1&errtitle=#URLEncodedFormat(TitleErrs)#&ErrMsg= #URLEncodedFormat(MsgErr)# <br>&ErrDet=#URLEncodedFormat(DetErrs)#" addtoken="no">
    </cfif>

	<cfquery datasource="#session.dsn#">
		update RHInstitucionesA
		set Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		, CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.CEcodigo#">
		, RHIAcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#form.RHIAcodigo#" null="#Len(form.RHIAcodigo) Is 0#">
		, RHIAnombre = <cfqueryparam cfsqltype="cf_sql_char" value="#form.RHIAnombre#" null="#Len(form.RHIAnombre) Is 0#">
		, RHIAtelefono = <cfqueryparam cfsqltype="cf_sql_char" value="#form.RHIAtelefono#" null="#Len(form.RHIAtelefono) Is 0#">
		, RHIAfax = <cfqueryparam cfsqltype="cf_sql_char" value="#form.RHIAfax#" null="#Len(form.RHIAfax) Is 0#">
		, RHIAurl = <cfqueryparam cfsqltype="cf_sql_char" value="#form.RHIAurl#" null="#Len(form.RHIAurl) Is 0#">
		, BMfecha = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">
		, BMUsucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">
		,RHIAcontacto = <cfif isdefined("form.RHIAcontacto") and len(trim(form.RHIAcontacto))><cfqueryparam cfsqltype="cf_sql_varchar" value="#form.RHIAcontacto#"><cfelse>null</cfif>
		,RHIAtelefonoc = <cfif isdefined("form.RHIAtelefonoc") and len(trim(form.RHIAtelefonoc))><cfqueryparam cfsqltype="cf_sql_varchar" value="#form.RHIAtelefonoc#"><cfelse>null</cfif>
		,RHIAemailc =  <cfif isdefined("form.RHIAemailc") and len(trim(form.RHIAemailc))><cfqueryparam cfsqltype="cf_sql_varchar" value="#form.RHIAemailc#"><cfelse>null</cfif>
		where RHIAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHIAid#" null="#Len(form.RHIAid) Is 0#">
	</cfquery>
	<cflocation url="RHInstitucionesA.cfm?RHIAid=#URLEncodedFormat(form.RHIAid)#">
<cfelseif IsDefined("form.Baja")>
	<cfquery datasource="#session.dsn#">
		delete from RHInstitucionesA
		where RHIAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHIAid#" null="#Len(form.RHIAid) Is 0#">
	</cfquery>
<cfelseif IsDefined("form.Nuevo")>
<cfelseif IsDefined("form.Alta")>

	<cfquery datasource="#session.dsn#" name="rsExiste">
    	select * from RHInstitucionesA
        where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
        and RHIAcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#form.RHIAcodigo#" null="#Len(form.RHIAcodigo) Is 0#">
    </cfquery>
    
    <cfif isdefined('rsExiste') and rsExiste.RecordCount NEQ 0   >
		<cfset TitleErrs = 'Operación Inválida'>
        <cfset MsgErr	 = 'Instituciones Académicas'>
        <cfset DetErrs 	 = 'El codigo de institucion que esta agregando ya existe, Verificar.'>
        <cflocation url="/cfmx/sif/errorPages/BDerror.cfm?errType=1&errtitle=#URLEncodedFormat(TitleErrs)#&ErrMsg= #URLEncodedFormat(MsgErr)# <br>&ErrDet=#URLEncodedFormat(DetErrs)#" addtoken="no">
    </cfif>

	<cfquery datasource="#session.dsn#">
		insert into RHInstitucionesA (Ecodigo,CEcodigo,RHIAcodigo,RHIAnombre,RHIAtelefono,RHIAfax,RHIAurl,BMfecha,BMUsucodigo,RHIAcontacto,RHIAtelefonoc,RHIAemailc)
		values (
			<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">,
			<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.CEcodigo#">,
			<cfqueryparam cfsqltype="cf_sql_char" value="#form.RHIAcodigo#" null="#Len(form.RHIAcodigo) Is 0#">,
			<cfqueryparam cfsqltype="cf_sql_char" value="#form.RHIAnombre#" null="#Len(form.RHIAnombre) Is 0#">,
			<cfqueryparam cfsqltype="cf_sql_char" value="#form.RHIAtelefono#" null="#Len(form.RHIAtelefono) Is 0#">,
			<cfqueryparam cfsqltype="cf_sql_char" value="#form.RHIAfax#" null="#Len(form.RHIAfax) Is 0#">,
			<cfqueryparam cfsqltype="cf_sql_char" value="#form.RHIAurl#" null="#Len(form.RHIAurl) Is 0#">,
			<cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
			<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">,
			<cfif isdefined("form.RHIAcontacto") and len(trim(form.RHIAcontacto))><cfqueryparam cfsqltype="cf_sql_varchar" value="#form.RHIAcontacto#"><cfelse>null</cfif>,
			<cfif isdefined("form.RHIAtelefonoc") and len(trim(form.RHIAtelefonoc))><cfqueryparam cfsqltype="cf_sql_varchar" value="#form.RHIAtelefonoc#"><cfelse>null</cfif>,
			<cfif isdefined("form.RHIAemailc") and len(trim(form.RHIAemailc))><cfqueryparam cfsqltype="cf_sql_varchar" value="#form.RHIAemailc#"><cfelse>null</cfif>
			)
	</cfquery>
<cfelse>
	<!--- Tratar como form.nuevo --->
</cfif>
<cflocation url="RHInstitucionesA.cfm">


