<cfparam name="CurrentPage" default="#GetFileFromPath(GetTemplatePath())#">

<cfif isdefined("url.tab") and Len(Trim(url.tab))>
	<cfset form.tab = url.tab>
</cfif>
<cfparam name="form.tab" default="0">

<cfif isdefined("url.paso") and Len(Trim(url.paso))>
	<cfset form.paso = url.paso>
</cfif>
<cfparam name="form.paso" default="1">

<cfif isdefined("url.ag") and Len(Trim(url.ag))>
	<cfset form.ag = url.ag>
</cfif>
<cfparam name="form.ag" default="">
<cfif isdefined("form.ag") and Len(Trim(form.ag))>
	<cfset form.AGid = form.ag>
</cfif>
<cfif isdefined("url.AGid") and Len(Trim(url.AGid))>
	<cfset form.AGid = url.AGid>
</cfif>
<cfparam name="form.AGid" default="">
<cfset ExisteAgente = isdefined("form.AGid") and Len(Trim(form.AGid))>

<cfif isdefined("url.cue") and Len(Trim(url.cue))>
	<cfset form.cue = url.cue>
</cfif>
<cfparam name="form.cue" default="">
<cfif isdefined("form.cue") and Len(Trim(form.cue))>
	<cfset form.CTid = form.cue>
</cfif>
<cfif isdefined("url.CTid") and Len(Trim(url.CTid))>
	<cfset form.CTid = url.CTid>
</cfif>
<cfparam name="form.CTid" default="">

<cfif isdefined("url.tipo") and Len(Trim(url.tipo))>
	<cfset form.tipo = url.tipo>
</cfif>
<cfparam name="form.tipo" default="">


<cfinclude template="agente-paramslista.cfm">
<cfinclude template="agente-paramsvar.cfm">

<cfif ExisteAgente>
	<cfquery name="rsDatosPersona" datasource="#Session.DSN#">
		select a.Pquien, b.Pid, b.Ppersoneria,
			   case when b.Ppersoneria = 'J' then rtrim(b.PrazonSocial) else rtrim(rtrim(b.Pnombre) || ' ' || rtrim(b.Papellido) || ' ' || b.Papellido2) end as NombreCompleto
		from ISBagente a
			inner join ISBpersona b
				on b.Pquien = a.Pquien
		where a.AGid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.AGid#">
	</cfquery>
	<cfset Form.Pquien = rsDatosPersona.Pquien>
</cfif>

<!--- Si no hay una cuenta precargada busca una cuenta que posea la persona --->
<cfif ExisteAgente and Len(Trim(Form.CTid)) EQ 0>
	<cfquery name="buscarCuenta" datasource="#Session.DSN#">
		select a.CTid
		from ISBcuenta a
		where a.Pquien = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Pquien#">
		and a.CTtipoUso = 'A'
	</cfquery>
	<cfif buscarCuenta.recordCount>
		<cfset Form.CTid = buscarCuenta.CTid>
		<cfset Form.cue = buscarCuenta.CTid>
	</cfif>
</cfif>
<cfset ExisteCuenta = isdefined("form.CTid") and Len(Trim(form.CTid))>
