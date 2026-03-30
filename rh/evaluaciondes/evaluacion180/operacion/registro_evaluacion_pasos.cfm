<cfset form.Estado = 0>
<!--- Consultas para determinar cuales pasos ya fueron cumplidos o están siendo cumplidos --->
<cfif isdefined("form.REid") and len(trim(form.REid)) gt 0>
	<cfquery name="rsUno" datasource="#Session.DSN#">
		select 1
		from RHRegistroEvaluacion
		where REid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.REid#">
	</cfquery>
	<cfquery name="rsDos" datasource="#Session.DSN#">
		select count(1) as cont
		from RHIndicadoresRegistroE
		where REid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.REid#">
	</cfquery>
	<cfquery name="rsTres" datasource="#Session.DSN#">
		select count(1) as cont
		from RHGruposRegistroE
		where REid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.REid#">
	</cfquery>
	<cfquery name="rsCuatro" datasource="#Session.DSN#">
		select count(1) as cont
		from RHEmpleadoRegistroE
		where REid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.REid#">
	</cfquery>
	<cfquery name="rsSeis" datasource="#Session.DSN#">
		select count(1) as cont
		from RHRegistroEvaluacion
		where REid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.REid#">
			and REestado = 1
	</cfquery>
	<cfquery name="rsEstado" datasource="#session.DSN#">
		select REestado from RHRegistroEvaluacion
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			and REid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.REid#">
	</cfquery>
	<cfset form.Estado = rsEstado.REestado>
</cfif>
<cfscript>
	uno.checked = isdefined("rsUno") and rsUno.RecordCount gt 0;
	dos.checked = (isdefined("rsDos") and rsDos.cont gt 0);
	tres.checked = isdefined("rsTres") and rsTres.Cont gt 0;
	cuatro.checked = (isdefined("rsCuatro") and rsCuatro.Cont gt 0);
	cinco.checked = isdefined("rsCuatro") and rsCuatro.Cont gt 0;
	seis.checked = isdefined("rsSeis") and rsCuatro.Cont gt 0;
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
		<td width="1%" valign="middle"><div align="center"><a href="registro_evaluacion.cfm?SEL=0"><img src="/cfmx/rh/imagenes/Home01_T.gif" border="0"></a></div></td>
		<td width="100%" valign="middle" nowrap><strong><a href="registro_evaluacion.cfm?SEL=0">Lista de Relaciones</a></strong></td>
	  </tr>
	  <tr>
		<td width="1%" valign="middle"><div align="center">
		  <cfif form.sel eq 1>
		    <img src="/cfmx/rh/imagenes/addressGo.gif" border="0">
		   <cfelseif uno.checked>
		    <img src="/cfmx/rh/imagenes/w-check.gif" border="0">
	      </cfif>
	    </div></td>
		<td width="1%" valign="middle"><div align="center"><a href="registro_evaluacion.cfm?SEL=1&REid=#FORM.REID#&Estado=#form.Estado#"><img src="/cfmx/rh/imagenes/number1_16.gif" border="0"></a></div></td>
		<td width="100%" valign="middle" nowrap><strong><a href="registro_evaluacion.cfm?SEL=1&REid=#FORM.REID#&Estado=#form.Estado#">Registro de la Relaci&oacute;n </a></strong></td>
	  </tr>
	  <tr>
		<td valign="middle"><div align="center">
		  <cfif form.sel eq 2>
		    <img src="/cfmx/rh/imagenes/addressGo.gif" border="0">
		    <cfelseif dos.checked>
		    <img src="/cfmx/rh/imagenes/w-check.gif" border="0">
	      </cfif>
	    </div></td>
		<td valign="middle"><div align="center"><a href="registro_evaluacion.cfm?SEL=2&REid=#FORM.REID#&Estado=#form.Estado#"><img src="/cfmx/rh/imagenes/number2_16.gif" border="0"></a></div></td>
		<td valign="middle" nowrap><strong><a href="registro_evaluacion.cfm?SEL=2&REid=#FORM.REID#&Estado=#form.Estado#">Indicaciones</a></strong></td>
	  </tr>
	   <tr>
		<td valign="middle"><div align="center">
		  <cfif form.sel eq 3>
		    <img src="/cfmx/rh/imagenes/addressGo.gif" border="0">
		    <cfelseif dos.checked>
		    <img src="/cfmx/rh/imagenes/w-check.gif" border="0">
	      </cfif>
	    </div></td>
		<td valign="middle"><div align="center"><a href="registro_evaluacion.cfm?SEL=3&REid=#FORM.REID#&Estado=#form.Estado#"><img src="/cfmx/rh/imagenes/number3_16.gif" border="0"></a></div></td>
		<td valign="middle" nowrap><strong><a href="registro_evaluacion.cfm?SEL=3&REid=#FORM.REID#&Estado=#form.Estado#">Conceptos</a></strong></td>
	  </tr>
	  <tr>
		<td valign="middle"><div align="center">
		  <cfif form.sel eq 4>
		    <img src="/cfmx/rh/imagenes/addressGo.gif" border="0">
		    <cfelseif tres.checked>
		    <img src="/cfmx/rh/imagenes/w-check.gif" border="0">
	      </cfif>
	    </div></td>
		<td valign="middle"><div align="center"><a href="registro_evaluacion.cfm?SEL=4&REid=#FORM.REID#&Estado=#form.Estado#"><img src="/cfmx/rh/imagenes/number4_16.gif" border="0"></a></div></td>
		<td valign="middle" nowrap><strong><a href="registro_evaluacion.cfm?SEL=4&REid=#FORM.REID#&Estado=#form.Estado#">Grupos</a></strong></td>
	  </tr>
	  <tr>
		<td valign="middle"><div align="center">
		  <cfif form.sel eq 5>
		    <img src="/cfmx/rh/imagenes/addressGo.gif" border="0">
		    <cfelseif cuatro.checked>
		    <img src="/cfmx/rh/imagenes/w-check.gif" border="0">
	      </cfif>
	    </div></td>
		<td valign="middle"><div align="center"><a href="registro_evaluacion.cfm?SEL=5&REid=#FORM.REID#&Estado=#form.Estado#"><img src="/cfmx/rh/imagenes/number5_16.gif" border="0"></a></div></td>
		<td valign="middle" nowrap><strong><a href="registro_evaluacion.cfm?SEL=5&REid=#FORM.REID#&Estado=#form.Estado#">Lista de Empleados</a></strong></td>
	  </tr>
	  <tr>
	  	<td valign="middle"><div align="center">
	  	  <cfif form.sel eq 6>
	  	    <img src="/cfmx/rh/imagenes/addressGo.gif" border="0">
	  	    <cfelseif cinco.checked>
	  	    <img src="/cfmx/rh/imagenes/w-check.gif" border="0">
  	      </cfif>
  	    </div></td>
		<td valign="middle"><div align="center"><a href="registro_evaluacion.cfm?SEL=6&REid=#FORM.REID#&Estado=#form.Estado#"><img src="/cfmx/rh/imagenes/number6_16.gif" border="0"></a></div></td>
		<td valign="middle" nowrap><strong><a href="registro_evaluacion.cfm?SEL=6&REid=#FORM.REID#&Estado=#form.Estado#">Lista de Evaluadores</a></strong></td>
	  </tr>

	  <tr>
	  	<td valign="middle"><div align="center">
	  	  <cfif form.sel eq 7>
	  	    <img src="/cfmx/rh/imagenes/addressGo.gif" border="0">
	  	    <cfelseif seis.checked>
	  	    <img src="/cfmx/rh/imagenes/w-check.gif" border="0">
  	      </cfif>
  	    </div></td>
		<td valign="middle"><div align="center"><a href="registro_evaluacion.cfm?SEL=7&REid=#FORM.REID#&Estado=#form.Estado#"><img src="/cfmx/rh/imagenes/number7_16.gif" border="0"></a></div></td>
		<td valign="middle" nowrap><strong><a href="registro_evaluacion.cfm?SEL=7&REid=#FORM.REID#&Estado=#form.Estado#">Publicar Evaluaci&oacute;n</a></strong></td>
	  </tr>


	</table>
</cfoutput>
<cf_web_portlet_end>