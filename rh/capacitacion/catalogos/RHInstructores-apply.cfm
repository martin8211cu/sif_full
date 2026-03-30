<!---<cf_dump var="#form#">--->
<cfif isdefined ('form.borrarItem2') and len(trim(form.borrarItem2)) gt 0>
	<cfquery name="delDet" datasource="#session.dsn#">
		delete from RHTiposServxInst
		where RHTSid=#form.borrarItem2#
		and RHIid=#form.RHIid#
		and Ecodigo=#session.Ecodigo#
	</cfquery>
	<cflocation url="RHInstructores.cfm?RHIid=#URLEncodedFormat(form.RHIid)#&Serv=1">
</cfif>

<cfif isdefined ('form.borrarItem') and len(trim(form.borrarItem)) gt 0>

	<cfquery name="delDet" datasource="#session.dsn#">
		delete from RHAreasxInst
		where RHACid=#form.borrarItem#
		and RHIid=#form.RHIid#
		and Ecodigo=#session.Ecodigo#
	</cfquery>
	<cflocation url="RHInstructores.cfm?RHIid=#URLEncodedFormat(form.RHIid)#&Areas=1">
</cfif>


<cfif isdefined ('form.AgregarDet')>
	<cfif isdefined('form.RHTSid') and len(trim(form.RHTSid)) gt 0>
	<cfquery name="vali" datasource="#session.dsn#">
		select count(1) as cantidad from RHTiposServxInst
		where  RHTSid=#form.RHTSid#
		and RHIid=#form.RHIid#
		and Ecodigo=#session.Ecodigo#
	</cfquery>
	<cfif vali.cantidad gt 0>
		<cf_errorCode	code="51864" msg="El código de servicio ya esta registrado para este instructor">
	</cfif>
	<cfquery name="inDet" datasource="#session.dsn#">
		insert into RHTiposServxInst(RHTSid,RHIid,Ecodigo,Usucodigo,fecha)
		values (
		#form.RHTSid#,
		#form.RHIid#,
		#session.Ecodigo#,
		#session.Usucodigo#,
		#now()#)
	</cfquery>
	<cflocation url="RHInstructores.cfm?RHIid=#URLEncodedFormat(form.RHIid)#&Serv=1">
	<cfelse>
		<cf_errorCode	code="51865" msg="Acción Cancelada. No se ha seleccionado ningún servicio.">
	</cfif>
</cfif>

<cfif isdefined ('form.AgregarDetArea')>
<cfif isdefined('form.RHACid') and len(trim(form.RHACid)) gt 0>
	<cfquery name="vali" datasource="#session.dsn#">
		select count(1) as cantidad from RHAreasxInst
		where  RHACid=#form.RHACid#
		and RHIid=#form.RHIid#
		and Ecodigo=#session.Ecodigo#
	</cfquery>
	<cfif vali.cantidad gt 0>
		<cf_errorCode	code="51866" msg="El área ya ha sido registrada para este instructor">
	</cfif>
	<cfquery name="inDet" datasource="#session.dsn#">
		insert into RHAreasxInst(RHACid,RHIid,Ecodigo,Usucodigo,fecha)
		values (
		#form.RHACid#,
		#form.RHIid#,
		#session.Ecodigo#,
		#session.Usucodigo#,
		#now()#)
	</cfquery>
	<cflocation url="RHInstructores.cfm?RHIid=#URLEncodedFormat(form.RHIid)#&Areas=1">
	<cfelse>
		<cf_errorCode	code="51865" msg="Acción Cancelada. No se ha seleccionado ningún servicio.">
	</cfif>
</cfif>

<cfif isdefined ('form.Servicios')>
	<cflocation url="RHInstructores.cfm?RHIid=#URLEncodedFormat(form.RHIid)#&Serv=1">
</cfif>

<cfif isdefined ('form.Areas')>
	<cflocation url="RHInstructores.cfm?RHIid=#URLEncodedFormat(form.RHIid)#&Areas=1">
</cfif>

<cfif IsDefined("form.Cambio")>
		<cf_dbtimestamp datasource="#session.dsn#"
				table="RHInstructores"
				redirect="RHInstructores.cfm"
				timestamp="#form.ts_rversion#"
				field1="RHIid"
				type1="numeric"
				value1="#form.RHIid#"
		>

	<cfquery datasource="#session.dsn#">

		update RHInstructores
		set 
		  RHInombre 	= <cfqueryparam cfsqltype="cf_sql_char" value="#form.RHInombre#" null="#Len(form.RHInombre) Is 0#">
		, RHIapellido1 	= <cfqueryparam cfsqltype="cf_sql_char" value="#form.RHIapellido1#" null="#Len(form.RHIapellido1) Is 0#">
		, RHIapellido2 	= <cfqueryparam cfsqltype="cf_sql_char" value="#form.RHIapellido2#" null="#Len(form.RHIapellido2) Is 0#">
		, RHItelefono 	= <cfqueryparam cfsqltype="cf_sql_char" value="#form.RHItelefono#" null="#Len(form.RHItelefono) Is 0#">
		, RHIemail 		= <cfqueryparam cfsqltype="cf_sql_char" value="#form.RHIemail#" null="#Len(form.RHIemail) Is 0#">
		, BMfecha 		= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">
		, BMUsucodigo 	= <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">
		, RHIexterno 	= <cfif isdefined("form.RHIexterno")>1<cfelse>0</cfif>
		 ,RHIapartado   =<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.RHIapartado#" null="#Len(form.RHIapartado) Is 0#">
		 ,RHIdir        =<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.RHIdir#" null="#Len(form.RHIdir) Is 0#">
		where RHIid 	= <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHIid#" null="#Len(form.RHIid) Is 0#">
		and Ecodigo 	= <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	</cfquery>
	<cflocation url="RHInstructores.cfm?RHIid=#URLEncodedFormat(form.RHIid)#">
<cfelseif IsDefined("form.Baja")>
	<cfquery datasource="#session.dsn#">
		delete from RHInstructores
		where RHIid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHIid#" null="#Len(form.RHIid) Is 0#">
		and Ecodigo 	= <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	</cfquery>
<cfelseif IsDefined("form.Alta")>
	<cfquery datasource="#session.dsn#" name="RSExiste">
		select RHIid from RHInstructores
		where NTIcodigo 		= <cfqueryparam cfsqltype="cf_sql_char" value="#form.NTIcodigo#" >
		and RHIidentificacion	= <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.RHIidentificacion#">
		and Ecodigo 			= <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	</cfquery>
	<cfif RSExiste.recordCount GT 0>
			<cfinvoke component="sif.Componentes.Translate"
			method="Translate"
			Key="LB_MSGERROR"
			Default="Ya existe un instructor con esta identificaci&oacute;n"
			returnvariable="LB_MSGERROR"/> 	
			<cf_throw message="#LB_MSGERROR#" errorcode="10020">
	<cfelse>
		<cfquery datasource="#session.dsn#">
			insert into RHInstructores (NTIcodigo,RHIidentificacion,RHInombre ,RHIapellido1,RHIapellido2,
			RHItelefono,RHIemail,Ecodigo,BMUsucodigo,BMfecha, RHIexterno,RHIdir,RHIapartado)
			values (
				<cfqueryparam cfsqltype="cf_sql_char"    value="#form.NTIcodigo#" >,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.RHIidentificacion#">,
				<cfqueryparam cfsqltype="cf_sql_char" value="#form.RHInombre#" null="#Len(form.RHInombre) Is 0#">,
				<cfqueryparam cfsqltype="cf_sql_char" value="#form.RHIapellido1#" null="#Len(form.RHIapellido1) Is 0#">,
				<cfqueryparam cfsqltype="cf_sql_char" value="#form.RHIapellido2#" null="#Len(form.RHIapellido2) Is 0#">,
				<cfqueryparam cfsqltype="cf_sql_char" value="#form.RHItelefono#" null="#Len(form.RHItelefono) Is 0#">,
				<cfqueryparam cfsqltype="cf_sql_char" value="#form.RHIemail#" null="#Len(form.RHIemail) Is 0#">,
				<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">,
				<cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
				<cfif isdefined("form.RHIexterno")>1<cfelse>0</cfif>,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.RHIdir#" null="#Len(form.RHIdir) Is 0#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.RHIapartado#" null="#Len(form.RHIapartado) Is 0#">
				)
		</cfquery>	
	</cfif>
</cfif>
<cflocation url="RHInstructores.cfm">



