<!--- Consultas para determinar cuales pasos ya fueron cumplidos o están siendo cumplidos --->
<cfif isdefined("form.RHEEid") and len(trim(form.RHEEid)) gt 0>
	<cfquery name="rsUno" datasource="#Session.DSN#">
		select 1
		from RHEEvaluacionDes
		where RHEEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHEEid#">
	</cfquery>
	<cfquery name="rsDos" datasource="#Session.DSN#">
		select RHEEestado
		from RHEEvaluacionDes
		where RHEEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHEEid#">
	</cfquery>
	<cfquery name="rsTres" datasource="#Session.DSN#">
		select count(1) as Cont
		from RHListaEvalDes
		where RHEEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHEEid#">
	</cfquery>
	<cfquery name="rsCinco" datasource="#Session.DSN#">
		select count(1) as Cont
		from RHEvaluadoresDes
		where RHEEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHEEid#">
	</cfquery>
</cfif>
<cfscript>
	uno.checked = isdefined("rsUno") and rsUno.RecordCount gt 0;
	dos.checked = (isdefined("rsDos") and rsDos.RHEEestado gt 0) or (isdefined("rsTres") and rsTres.Cont gt 0) or isdefined("form.EmpleadosParmas");
	tres.checked = isdefined("rsTres") and rsTres.Cont gt 0;
	cuatro.checked = (isdefined("rsCinco") and rsCinco.Cont gt 0) or isdefined("form.EvaluadoresParmas");
	cinco.checked = isdefined("rsCinco") and rsCinco.Cont gt 0;
</cfscript>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Proceso"
	Default="Proceso"
	returnvariable="LB_Proceso"/>
<cf_web_portlet_start border="true" titulo="Proceso" skin="#Session.Preferences.Skin#">
<cfoutput>
	<table width="100%"  border="0" cellspacing="3" cellpadding="0">
	  <tr>
		<td width="1%" valign="middle"><div align="center">
		  <cfif form.sel eq 0>
		    <img src="/cfmx/rh/imagenes/addressGo.gif" border="0">
	      </cfif>
	    </div></td>
		<td width="1%" valign="middle"><div align="center"><a href="registro_evaluacion.cfm?SEL=0"><img src="/cfmx/rh/imagenes/Home01_T.gif" border="0"></a></div></td>
		<td width="100%" valign="middle" nowrap><strong><a href="registro_evaluacion.cfm?SEL=0"><cf_translate key="LB_ListaDeRelaciones">Lista de Relaciones</cf_translate></a></strong></td>
	  </tr>
	  <tr>
		<td width="1%" valign="middle"><div align="center">
		  <cfif form.sel eq 1>
		    <img src="/cfmx/rh/imagenes/addressGo.gif" border="0">
		    <cfelseif uno.checked>
		    <img src="/cfmx/rh/imagenes/w-check.gif" border="0">
	      </cfif>
	    </div></td>
		<td width="1%" valign="middle"><div align="center"><a href="registro_evaluacion.cfm?SEL=1&RHEEid=#FORM.RHEEID#"><img src="../../imagenes/number1_16.giF" border="0"></a></div></td>
		<td width="100%" valign="middle" nowrap><strong><a href="registro_evaluacion.cfm?SEL=1&RHEEid=#FORM.RHEEID#"><cf_translate key="LB_RegistroDeLaEvaluacion">Registro de la Relaci&oacute;n</cf_translate> </a></strong></td>
	  </tr>
	  <tr>
		<td valign="middle"><div align="center">
		  <cfif form.sel eq 2>
		    <img src="/cfmx/rh/imagenes/addressGo.gif" border="0">
		    <cfelseif dos.checked>
		    <img src="/cfmx/rh/imagenes/w-check.gif" border="0">
	      </cfif>
	    </div></td>
		<td valign="middle"><div align="center"><a href="registro_evaluacion.cfm?SEL=2&RHEEid=#FORM.RHEEID#"><img src="/cfmx/rh/imagenes/number2_16.gif" border="0"></a></div></td>
		<td valign="middle" nowrap><strong><a href="registro_evaluacion.cfm?SEL=2&RHEEid=#FORM.RHEEID#"><cf_translate key="LB_AsignacionDeEmpleados">Asignaci&oacute;n de Empleados</cf_translate></a></strong></td>
	  </tr>
	  <tr>
		<td valign="middle"><div align="center">
		  <cfif form.sel eq 3>
		    <img src="/cfmx/rh/imagenes/addressGo.gif" border="0">
		    <cfelseif tres.checked>
		    <img src="/cfmx/rh/imagenes/w-check.gif" border="0">
	      </cfif>
	    </div></td>
		<td valign="middle"><div align="center"><a href="registro_evaluacion.cfm?&SEL=3&RHEEid=#FORM.RHEEID#"><img src="/cfmx/rh/imagenes/number3_16.gif" border="0"></a></div></td>
		<td valign="middle" nowrap><strong><a href="registro_evaluacion.cfm?&SEL=3&RHEEid=#FORM.RHEEID#"><cf_translate key="LB_ListaDeEmpleados">Lista de Empleados</cf_translate></a></strong></td>
	  </tr>
	  <tr>
		<td valign="middle"><div align="center">
		  <cfif form.sel eq 4>
		    <img src="/cfmx/rh/imagenes/addressGo.gif" border="0">
		    <cfelseif cuatro.checked>
		    <img src="/cfmx/rh/imagenes/w-check.gif" border="0">
	      </cfif>
	    </div></td>
		<td valign="middle"><div align="center"><a href="registro_evaluacion.cfm?SEL=4&RHEEid=#FORM.RHEEID#"><img src="/cfmx/rh/imagenes/number4_16.gif" border="0"></a></div></td>
		<td valign="middle" nowrap><strong><a href="registro_evaluacion.cfm?SEL=4&RHEEid=#FORM.RHEEID#"><cf_translate key="LB_AsignacionDeEvaluadores">Asignaci&oacute;n de Evaluadores</cf_translate></a></strong></td>
	  </tr>
	  <tr>
	  	<td valign="middle"><div align="center">
	  	  <cfif form.sel eq 5>
	  	    <img src="/cfmx/rh/imagenes/addressGo.gif" border="0">
	  	    <cfelseif cinco.checked>
	  	    <img src="/cfmx/rh/imagenes/w-check.gif" border="0">
  	      </cfif>
  	    </div></td>
		<td valign="middle"><div align="center"><a href="registro_evaluacion.cfm?SEL=5&RHEEid=#FORM.RHEEID#"><img src="/cfmx/rh/imagenes/number5_16.gif" border="0"></a></div></td>
		<td valign="middle" nowrap><strong><a href="registro_evaluacion.cfm?SEL=5&RHEEid=#FORM.RHEEID#"><cf_translate key="LB_ListaDeEvaluadores">Lista de Evaluadores</cf_translate> </a></strong></td>
	  </tr>
	</table>
</cfoutput>
<cf_web_portlet_end>