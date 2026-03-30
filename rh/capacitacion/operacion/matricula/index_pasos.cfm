﻿<!--- VARIABLES DE TRADUCCION --->
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_RecursosHumanos"
	Default="Recursos Humanos"
	XmlFile="/rh/generales.xml"
	returnvariable="LB_RecursosHumanos"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_ListadeRelaciones"
	Default="Lista de Relaciones"
	returnvariable="LB_ListadeRelaciones"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_RegistroDeLaRelacion"
	Default="Registro de la Relaci&oacute;n"
	returnvariable="LB_RegistroDeLaRelacion"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_AsignacionDeEmpleados"
	Default="Asignaci&oacute;n de Empleados"
	returnvariable="LB_AsignacionDeEmpleados"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_ListaDeEmpleados"
	Default="Lista de Empleados"
	returnvariable="LB_ListaDeEmpleados"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Aprobacion"
	Default="Aprobaci&oacute;n"
	returnvariable="LB_Aprobacion"/>


<!--- FIN VARIABLES DE TRADUCCION --->
﻿<!--- Consultas para determinar cuales pasos ya fueron cumplidos o están siendo cumplidos --->
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
		<td width="100%" valign="middle" nowrap><strong><a href="index.cfm?SEL=0">#LB_ListadeRelaciones#</a></strong></td>
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
		<td width="100%" valign="middle" nowrap><strong><a href="index.cfm?SEL=1&RHRCid=#FORM.RHRCid#">#LB_RegistroDeLaRelacion#</a></strong></td>
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
		<td valign="middle" nowrap><strong><a href="index.cfm?SEL=2&RHRCid=#FORM.RHRCid#">#LB_AsignacionDeEmpleados# </a></strong></td>
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
		<td valign="middle" nowrap><strong><a href="index.cfm?SEL=3&RHRCid=#FORM.RHRCid#">#LB_ListaDeEmpleados#</a></strong></td>
	  </tr>
	  <tr>
		<td valign="middle"><div align="center">
		  <cfif form.sel eq 4>
		    <img src="/cfmx/rh/imagenes/addressGo.gif" border="0">
		    <cfelseif cuatro.checked>
		    <img src="/cfmx/rh/imagenes/w-check.gif" border="0">
	      </cfif>
	    </div></td>
		<td valign="middle"><div align="center"><a href="index.cfm?SEL=4&RHRCid=#FORM.RHRCid#"><img src="/cfmx/rh/imagenes/number4_16.gif" border="0"></a></div></td>
		<td valign="middle" nowrap><strong><a href="index.cfm?SEL=4&RHRCid=#FORM.RHRCid#">#LB_Aprobacion#</a></strong></td>
	  </tr>
	</table>
</cfoutput>
<cf_web_portlet_end>