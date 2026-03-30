
<cfif isdefined('LvarAutog') and LvarAutog eq 1 >
	<cfset destino = "../autogestion.cfm?o=9&tab=9" >
<cfelseif isdefined("form.fromExpediente")>
	<cfset destino = "expediente.cfm?tab=12">
<cfelseif isdefined("fromAprobacionCV")><!----- si se trabaja desde aprobacion de curriculum vitae---->
	<cfset destino = "AprobacionCV.cfm?tab=5" >	
<cfelse>	
	<cfset destino = "Publicaciones.cfm" >	
</cfif>
 
<cfquery name="rsReqAprobPub" datasource="#Session.DSN#">
	select Pvalor
	from RHParametros
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#"> and Pcodigo = 2692
</cfquery>

<cfif rsReqAprobPub.recordCount gt 0 and rsReqAprobPub.Pvalor eq '1'>
	<cfset lvRHPEstado = 0 >
<cfelse>
	<cfset lvRHPEstado = 1 >	
</cfif>


<cfif isdefined("Alta")>
	<cfquery name="rsInsPub" datasource="#Session.DSN#">
		insert into RHPublicaciones ( DEid, RHPTid, RHPTitulo, RHPAnoPub, RHPPublicadoEn, RHPEditorial, RHPLugar, RHPEnlaceWebPub, RHPCoautores, RHPEstado )
		values
		(	
			<cfif isdefined("form.DEid") and len(trim(form.DEid)) gt 0 ><cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid#">,<cfelse>null,</cfif>

			<cfif isdefined("form.RHPTid") and len(trim(form.RHPTid)) gt 0 ><cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHPTid#">,<cfelse>null,</cfif>		

			<cfif isdefined("form.RHPTitulo") and len(trim(form.RHPTitulo)) gt 0 ><cfqueryparam cfsqltype="cf_sql_varchar" value="#form.RHPTitulo#">,<cfelse>null,</cfif>	
					
			<cfif isdefined("form.RHPAnoPub") and len(trim(form.RHPAnoPub)) gt 0 ><cfqueryparam cfsqltype="cf_sql_integer"value="#form.RHPAnoPub#">,<cfelse>null,</cfif>		

			<cfif isdefined("form.RHPPublicadoEn") and len(trim(form.RHPPublicadoEn)) gt 0 ><cfqueryparam cfsqltype="cf_sql_varchar"value="#form.RHPPublicadoEn#">,<cfelse>null,</cfif>	

			<cfif isdefined("form.RHPEditorial") and len(trim(form.RHPEditorial)) gt 0 ><cfqueryparam cfsqltype="cf_sql_varchar"value="#form.RHPEditorial#">,<cfelse>null,</cfif>	

			<cfif isdefined("form.RHPLugar") and len(trim(form.RHPLugar)) gt 0 ><cfqueryparam cfsqltype="cf_sql_varchar"value="#form.RHPLugar#">,<cfelse>null,</cfif>	

			<cfif isdefined("form.RHPEnlaceWebPub") and len(trim(form.RHPEnlaceWebPub)) gt 0 ><cfqueryparam cfsqltype="cf_sql_longvarchar" value="#form.RHPEnlaceWebPub#">,<cfelse>null,</cfif>	

			<cfif isdefined("form.TCoautorList") and len(trim(form.TCoautorList)) gt 0 ><cfqueryparam cfsqltype="cf_sql_longvarchar" value="#form.TCoautorList#">,<cfelse>null,</cfif>

			<cfqueryparam cfsqltype="cf_sql_integer" value="#lvRHPEstado#">
		)
		<cf_dbidentity1 datasource="#session.DSN#" name="rsInsPub">
	</cfquery> 

	<cf_dbidentity2 datasource="#session.DSN#" name="rsInsPub" returnvariable="LvarRHPid">
	<cfoutput><cflocation url="#destino#&RHPid=#LvarRHPid#&DEid=#form.DEid#"></cfoutput>	

<cfelseif isdefined("Cambio")>	
	<cfquery name="rsValorEstadoPub" datasource="#Session.DSN#">
		select RHPEstado 
		from RHPublicaciones
		where RHPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHPid#">	
	</cfquery>

	<cfquery name="update" datasource="#Session.DSN#">
		update RHPublicaciones
			set	RHPTid = <cfif isdefined("form.RHPTid") and len(trim(form.RHPTid)) gt 0 ><cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHPTid#"><cfelse>null</cfif>,

				RHPTitulo = <cfif isdefined("form.RHPTitulo") and len(trim(form.RHPTitulo)) gt 0 ><cfqueryparam cfsqltype="cf_sql_varchar" value="#form.RHPTitulo#"><cfelse>null</cfif>,

				RHPAnoPub = <cfif isdefined("form.RHPAnoPub") and len(trim(form.RHPAnoPub)) gt 0 ><cfqueryparam cfsqltype="cf_sql_integer" value="#form.RHPAnoPub#"><cfelse>null</cfif>,

				RHPPublicadoEn = <cfif isdefined("form.RHPPublicadoEn") and len(trim(form.RHPPublicadoEn)) gt 0 ><cfqueryparam cfsqltype="cf_sql_varchar" value="#form.RHPPublicadoEn#"><cfelse>null</cfif>,

				RHPEditorial = <cfif isdefined("form.RHPEditorial") and len(trim(form.RHPEditorial)) gt 0 ><cfqueryparam cfsqltype="cf_sql_varchar" value="#form.RHPEditorial#"><cfelse>null</cfif>,

				RHPLugar = <cfif isdefined("form.RHPLugar") and len(trim(form.RHPLugar)) gt 0 ><cfqueryparam cfsqltype="cf_sql_varchar" value="#form.RHPLugar#"><cfelse>null</cfif>,

				RHPEnlaceWebPub = <cfif isdefined("form.RHPEnlaceWebPub") and len(trim(form.RHPEnlaceWebPub)) gt 0 ><cfqueryparam cfsqltype="cf_sql_longvarchar" value="#form.RHPEnlaceWebPub#"><cfelse>null</cfif>,

				RHPCoautores = <cfif isdefined("form.TCoautorList") and len(trim(form.TCoautorList)) gt 0 ><cfqueryparam cfsqltype="cf_sql_longvarchar" value="#form.TCoautorList#"><cfelse>null</cfif>

				<cfif rsValorEstadoPub.RHPEstado neq 1 >
					, RHPEstado = <cfqueryparam cfsqltype="cf_sql_integer" value="#lvRHPEstado#">	
				</cfif>

			where RHPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHPid#">			
	</cfquery> 

	<cfoutput><cflocation url="#destino#&RHPid=#form.RHPid#&DEid=#form.DEid#"></cfoutput>	

<cfelseif isdefined("Baja")>
	<cfquery name="delete" datasource="#Session.DSN#">
		delete from RHPublicaciones
		where RHPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHPid#">
	</cfquery>

	<cfoutput><cflocation url="#destino#&DEid=#form.DEid#"></cfoutput>

<cfelseif isdefined("Nuevo") or isdefined("form.btnNuevo")>
	<cfoutput><cflocation url="#destino#&DEid=#form.DEid#"></cfoutput>	
</cfif>	