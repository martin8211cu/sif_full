<cfinclude template="RelacionCalculoRetro-translate.cfm">
<!--- Consultas --->
<!--- Tipos de Nómina que tienen un calendario de pago de tipo especial --->
<cfquery name="rsTiposNomina" datasource="#Session.DSN#">
	select rtrim(a.Tcodigo) as Tcodigo, a.Tdescripcion
	from TiposNomina a
	where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
	and exists (
		select 1
		from CalendarioPagos b
		where a.Tcodigo = b.Tcodigo
		and a.Ecodigo = b.Ecodigo
		and b.CPfcalculo is null
		and b.CPtipo = 3
		and not exists(
			select 1
			from RCalculoNomina rc
			where rc.RCNid = b.CPid
			)
	)
	order by a.Tdescripcion
</cfquery>
<cfif rsTiposNomina.RecordCount EQ 0>
	<cfset err='No hay relaciones de Cálculo Especiales definidas.'>
	<cflocation url="/cfmx/sif/errorPages/BDerror.cfm?errType=0&ErrMsg=Errores Encontrados<br>&ErrDet=#URLEncodedFormat(err)#" addtoken="no">	
</cfif>
<!--- Calendarios --->
<cfquery name="PaySchedAfterRestrict" datasource="#Session.DSN#">
	select 
		a.CPcodigo, 
		a.CPid, 
		rtrim(a.Tcodigo) as Tcodigo, 
		a.CPdesde, 
		a.CPhasta
	from CalendarioPagos a
	where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
	and a.CPfenvio is null
	and a.CPtipo = 3
	and not exists (
		select 1
		from RCalculoNomina h
		where a.Ecodigo = h.Ecodigo
		and a.Tcodigo = h.Tcodigo
		and a.CPdesde = h.RCdesde
		and a.CPhasta = h.RChasta
		and a.CPid = h.RCNid
	)
	and not exists (
		select 1
		from HERNomina i
		where a.Tcodigo = i.Tcodigo
		and a.Ecodigo = i.Ecodigo
		and a.CPdesde = i.HERNfinicio
		and a.CPhasta = i.HERNffin
		and a.CPid = i.RCNid
	)
</cfquery>
<cfif rsTiposNomina.RecordCount EQ 0>
	<cfset err='No hay Calendarios definidos para Nóminas Especiales.'>
	<cflocation url="/cfmx/sif/errorPages/BDerror.cfm?errType=0&ErrMsg=Errores Encontrados<br>&ErrDet=#URLEncodedFormat(err)#" addtoken="no">	
</cfif>
<cfquery name="MinFechasNomina" dbtype="query">
	select Tcodigo, min(CPdesde) as CPdesde
	from PaySchedAfterRestrict
	group by Tcodigo
</cfquery>
<cf_templateheader title="Recursos Humanos">
<cfinvoke Default="Relaci&oacute;n de C&aacute;lculo de N&oacute;mina" VSgrupo="103" returnvariable="nombre_proceso" component="sif.Componentes.TranslateDB" method="Translate" VSvalor="#session.monitoreo.SScodigo#.#session.monitoreo.SMcodigo#.#session.monitoreo.SPcodigo#"/>
<cfif nombre_proceso EQ "">
	<cfset nombre_proceso = "Relacion de Calculo Retroactiva">
</cfif>
<cfset Regresar = "RelacionCalculoRetro-lista.cfm">
 <cf_web_portlet_start  titulo="#nombre_proceso#">
<cfinclude template="/rh/portlets/pNavegacion.cfm">
<table width="100%" border="0" cellspacing="0" cellpadding="0">
  <tr valign="top"> 
	<td>&nbsp;</td>
  </tr>
  <tr valign="top"> 
	<td align="center">
	  <cfinclude template="RelacionCalculoRetro-form.cfm">
	</td>
  </tr>
  <tr valign="top"> 
	<td>&nbsp;</td>
  </tr>
	</table>
	<cf_web_portlet_end>
<cf_templatefooter>					  