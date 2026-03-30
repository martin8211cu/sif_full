<!--- Consultas para determinar cuales pasos ya fueron cumplidos o están siendo cumplidos --->
<cfif isdefined("form.RHRSid") and len(trim(form.RHRSid)) gt 0>
	<cfquery name="rsUno" datasource="#Session.DSN#">
		select 1
		from RHRelacionSeguimiento
		where RHRSid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHRSid#">
	</cfquery>
	<cfquery name="rsDos" datasource="#Session.DSN#">
		select RHRSestado
		from RHRelacionSeguimiento
		where RHRSid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHRSid#">
	</cfquery>
	<cfquery name="rsTres" datasource="#Session.DSN#">
		select count(1) as Cont
		from RHEvaluados a
		inner join RHItemEvaluar b
			on a.RHEid = b.RHEid
		where RHRSid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHRSid#">
	</cfquery>
	
	<cfquery name="rsCinco" datasource="#Session.DSN#">
		select count(1) as Cont
		from RHEvaluadores
		where RHEid in
		( select RHEid
		  from RHEvaluados
		 where RHRSid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHRSid#">
		)
	</cfquery>
</cfif>
<cfscript>
	uno.checked  = isdefined("rsUno")  and rsUno.RecordCount gt 0;
	dos.checked  = isdefined("rsTres") and rsTres.Cont gt 0 ;
	tres.checked = isdefined("rsTres") and rsTres.Cont gt 0;
	cuatro.checked = isdefined("rsTres") and rsTres.Cont gt 0;
</cfscript>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Proceso"
	Default="Proceso"
	returnvariable="LB_Proceso"/>
	
<cf_web_portlet_start border="true" titulo="#LB_Proceso#" skin="#Session.Preferences.Skin#">
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
		<td width="1%" valign="middle"><div align="center"><a href="registro_evaluacion.cfm?SEL=1&RHRSid=#FORM.RHRSid#"><img src="/cfmx/rh/imagenes/number1_16.gif" border="0"></a></div></td>
		<td width="100%" valign="middle" nowrap><strong><a href="registro_evaluacion.cfm?SEL=1&RHRSid=#FORM.RHRSid#"><cf_translate key="LB_ConfiguracionDeSeguimiento">Configuraci&oacute;n de Seguimiento</cf_translate> </a></strong></td>
	  </tr>
	  <tr>
		<td valign="middle"><div align="center">
		  <cfif form.sel eq 2>
		    <img src="/cfmx/rh/imagenes/addressGo.gif" border="0">
		    <cfelseif dos.checked>
		    <img src="/cfmx/rh/imagenes/w-check.gif" border="0">
	      </cfif>
	    </div></td>
		<td valign="middle"><div align="center"><a href="registro_evaluacion.cfm?SEL=2&RHRSid=#FORM.RHRSid#"><img src="/cfmx/rh/imagenes/number2_16.gif" border="0"></a></div></td>
		<td valign="middle" nowrap><strong><a href="registro_evaluacion.cfm?SEL=2&RHRSid=#FORM.RHRSid#"><cf_translate key="LB_ObjetivosOConocimientos">Objetivos o Conocimientos</cf_translate></a></strong></td>
	  </tr>
	  <tr>
		<td valign="middle"><div align="center">
		  <cfif form.sel eq 3>
		    <img src="/cfmx/rh/imagenes/addressGo.gif" border="0">
		    <cfelseif tres.checked>
		    <img src="/cfmx/rh/imagenes/w-check.gif" border="0">
	      </cfif>
	    </div></td>
		<td valign="middle"><div align="center"><a href="registro_evaluacion.cfm?SEL=3&RHRSid=#FORM.RHRSid#"><img src="/cfmx/rh/imagenes/number3_16.gif" border="0"></a></div></td>
		<td valign="middle" nowrap><strong><a href="registro_evaluacion.cfm?SEL=3&RHRSid=#FORM.RHRSid#"><cf_translate key="LB_AsignacionDeEvaluadores">Asignaci&oacute;n de Evaluadores</cf_translate></a></strong></td>
	  </tr>
	  <tr>	  
	  <tr>
		<td valign="middle"><div align="center">
		  <cfif form.sel eq 4>
		    <img src="/cfmx/rh/imagenes/addressGo.gif" border="0">
		    <cfelseif cuatro.checked>
		    <img src="/cfmx/rh/imagenes/w-check.gif" border="0">
	      </cfif>
	    </div></td>
		<td valign="middle"><div align="center"><a href="registro_evaluacion.cfm?&SEL=4&RHRSid=#FORM.RHRSid#"><img src="/cfmx/rh/imagenes/number4_16.gif" border="0"></a></div></td>
		<td valign="middle" nowrap><strong><a href="registro_evaluacion.cfm?SEL=4&RHRSid=#FORM.RHRSid#"><cf_translate key="LB_Relaciones_de_Seguimiento">Relaciones de Seguimiento</cf_translate> </a></strong></td>
	  </tr>
	  <td valign="middle"><div align="center">
	  	  <cfif form.sel eq 5>
	  	    <img src="/cfmx/rh/imagenes/addressGo.gif" border="0">
  	      </cfif>
  	   	 </div>
		</td>
		<td valign="middle"><div align="center"><a href="registro_evaluacion.cfm?SEL=5&RHRSid=#FORM.RHRSid#"><img src="/cfmx/rh/imagenes/number5_16.gif" border="0"></a></div></td>
		<td valign="middle" nowrap><strong><a href="registro_evaluacion.cfm?&SEL=5&RHRSid=#FORM.RHRSid#"><cf_translate key="LB_ProgresoDeRelaciones">Progreso de Relaciones</cf_translate> </a></strong></td>
	  </tr>
	</table>
</cfoutput>
<cf_web_portlet_end>