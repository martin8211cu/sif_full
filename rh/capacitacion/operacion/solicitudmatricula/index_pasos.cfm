<!--- Consultas para determinar cuales pasos ya fueron cumplidos o están siendo cumplidos --->
<cfif isdefined("form.RHRCid") and len(trim(form.RHRCid)) gt 0>
	<cfquery name="rsUno" datasource="#Session.DSN#">
		select 1
		from RHRelacionCap
		where RHRCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHRCid#">
	</cfquery>
	<cfquery name="rsDos" datasource="#Session.DSN#">
		select RHRCestado
		from RHRelacionCap
		where RHRCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHRCid#">
	</cfquery>
	<cfquery name="rsTres" datasource="#Session.DSN#">
		select count(1) as Cont
		from RHDRelacionCap
		where RHRCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHRCid#">
	</cfquery>
</cfif>
<cfscript>
	uno.checked = isdefined("rsUno") and rsUno.RecordCount gt 0;
	dos.checked = (isdefined("rsDos") and rsDos.RHRCestado gt 0) or (isdefined("rsTres") and rsTres.Cont gt 0) or isdefined("form.EmpleadosParmas");
	tres.checked = isdefined("rsTres") and rsTres.Cont gt 0;
	cuatro.checked = (isdefined("rsDos") and ListFind('20,40', rsDos.RHRCestado));
</cfscript>
<cf_web_portlet_start border="true" titulo="Proceso" skin="#Session.Preferences.Skin#">
<cfoutput>
	<table width="100%"  border="0" cellspacing="3" cellpadding="0">
	  <tr>
		<td width="1%" valign="middle"><div align="center">
		  <cfif form.sel eq 0>
		    <img src="/cfmx/rh/imagenes/addressGo.gif" border="0">
	      </cfif>
	    </div></td>
		<td width="1%" valign="middle"><div align="center"><a href="index.cfm?SEL=0"><img src="/cfmx/rh/imagenes/Home01_T.gif" border="0"></a></div></td>
		<td width="100%" valign="middle" nowrap><strong><a href="index.cfm?SEL=0"><cf_translate key="LB_ListaDeRelaciones" xmlFile="/rh/generales.xml">Lista de Relaciones</cf_translate></a></strong></td>
	  </tr>
	  <tr>
		<td width="1%" valign="middle"><div align="center">
		  <cfif form.sel eq 1>
		    <img src="/cfmx/rh/imagenes/addressGo.gif" border="0">
		    <cfelseif uno.checked>
		    <img src="/cfmx/rh/imagenes/w-check.gif" border="0">
	      </cfif>
	    </div></td>
		<td width="1%" valign="middle"><div align="center"><a href="index.cfm?SEL=1&RHRCid=#FORM.RHRCid#"><img src="/cfmx/rh/imagenes/number1_16.gif" border="0"></a></div></td>
		<td width="100%" valign="middle" nowrap><strong><a href="index.cfm?SEL=1&RHRCid=#FORM.RHRCid#">Registro de la Relaci&oacute;n </a></strong></td>
	  </tr>
	  <tr>
		<td valign="middle"><div align="center">
		  <cfif form.sel eq 2>
		    <img src="/cfmx/rh/imagenes/addressGo.gif" border="0">
		    <cfelseif dos.checked>
		    <img src="/cfmx/rh/imagenes/w-check.gif" border="0">
	      </cfif>
	    </div></td>
		<td valign="middle"><div align="center"><a href="index.cfm?SEL=2&RHRCid=#FORM.RHRCid#"><img src="/cfmx/rh/imagenes/number2_16.gif" border="0"></a></div></td>
		<td valign="middle" nowrap><strong><a href="index.cfm?SEL=2&RHRCid=#FORM.RHRCid#"><cf_translate key="LB_AsignacionDeEmpleados" xmlFile="/rh/generales.xml">Asignación de Empleados</cf_translate></a></strong></td>
	  </tr>
	  <tr>
		<td valign="middle"><div align="center">
		  <cfif form.sel eq 3>
		    <img src="/cfmx/rh/imagenes/addressGo.gif" border="0">
		    <cfelseif tres.checked>
		    <img src="/cfmx/rh/imagenes/w-check.gif" border="0">
	      </cfif>
	    </div></td>
		<td valign="middle"><div align="center"><a href="index.cfm?SEL=3&RHRCid=#FORM.RHRCid#"><img src="/cfmx/rh/imagenes/number3_16.gif" border="0"></a></div></td>
		<td valign="middle" nowrap><strong><a href="index.cfm?SEL=3&RHRCid=#FORM.RHRCid#"><cf_translate key="LB_ListaDeEmpleados" xmlFile="/rh/generales.xml">Lista de Empleados</cf_translate</a></strong></td>
	  </tr>
	</table>
</cfoutput>
<cf_web_portlet_end>