<!--- Consultas para determinar cuales pasos ya fueron cumplidos o están siendo cumplidos --->
<cfif isdefined("form.RHVPid") and len(trim(form.RHVPid)) gt 0>
	<cfquery name="rsUno" datasource="#Session.DSN#">
		select 1
		from RHValoracionPuesto
		where RHVPid  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHVPid#">
	</cfquery>
	 
    <cfquery name="rsDos" datasource="#Session.DSN#">
		select count(1) as Cont
		from RHGradosFactorPuesto
		where RHVPid  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHVPid#">
	</cfquery>
	<cfquery name="rsTres" datasource="#Session.DSN#">
		select count(1) as Cont
		from RHDispersionPuesto
		where RHVPid  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHVPid#">
	</cfquery>
	<cfquery name="rscuatro" datasource="#Session.DSN#">
		select count(1) as Cont
		from RHPropuestaPuesto
		where RHVPid  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHVPid#">
	</cfquery>
    
</cfif>
<cfscript>
	uno.checked = isdefined("rsUno") and rsUno.RecordCount gt 0;
	dos.checked = isdefined("rsUno") and rsUno.RecordCount gt 0;
	tres.checked = isdefined("rsTres") and rsTres.Cont gt 0;
	cuatro.checked = isdefined("rscuatro") and rscuatro.Cont gt 0;
</cfscript>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Proceso"
	Default="Proceso"
	returnvariable="LB_Proceso"/>
<cf_web_portlet_start border="true" titulo="Proceso" skin="#Session.Preferences.Skin#">
<cfoutput>
	<cfset filtro = "">
    <cfif (isdefined("form.FRHPcodigo") and len(trim(form.FRHPcodigo)))>
        <cfset filtro = filtro & "&FRHPcodigo=" & #form.FRHPcodigo#>
    </cfif>
    <cfif (isdefined("form.FRHPdescpuesto") and len(trim(form.FRHPdescpuesto)))>
        <cfset filtro = filtro & "&FRHPdescpuesto=" & #form.FRHPdescpuesto#>
    </cfif>
    <cfif (isdefined("form.CFid") and len(trim(form.CFid)))>
        <cfset filtro = filtro & "&CFid=" & #form.CFid#>
    </cfif>        

	

	<table width="100%"  border="0" cellspacing="3" cellpadding="0">
	  <tr>
		<td width="1%" valign="middle"><div align="center">
		  <cfif form.sel eq 0>
		    <img src="/cfmx/rh/imagenes/addressGo.gif" border="0">
	      </cfif>
	    </div></td>
		<td width="1%" valign="middle"><div align="center"><a href="registro_valoracion.cfm?SEL=0"><img src="/cfmx/rh/imagenes/Home01_T.gif" border="0"></a></div></td>
		<td width="100%" valign="middle" nowrap><strong><a href="registro_valoracion.cfm?SEL=0"><font  style="font-size:10px"><cf_translate key="LB_ListaDeValoraciones">Lista de Valoraciones</cf_translate></font></a></strong></td>
	  </tr>
	  <tr>
		<td width="1%" valign="middle"><div align="center">
		  <cfif form.sel eq 1>
		    <img src="/cfmx/rh/imagenes/addressGo.gif" border="0">
		    <cfelseif uno.checked>
		    <img src="/cfmx/rh/imagenes/w-check.gif" border="0">
	      </cfif>
	    </div></td>
		<td width="1%" valign="middle"><div align="center"><a href="registro_valoracion.cfm?SEL=1&RHVPid=#FORM.RHVPid##filtro#"><img src="/cfmx/rh/imagenes/number1_16.gif" border="0"></a></div></td>
		<td width="100%" valign="middle" nowrap><strong><a href="registro_valoracion.cfm?SEL=1&RHVPid=#FORM.RHVPid##filtro#"><font  style="font-size:10px"><cf_translate key="LB_RegistroDeLavaloracion">Registro de la valoraci&oacute;n</cf_translate></font> </a></strong></td>
	  </tr>
	  <tr>
		<td valign="middle"><div align="center">
		  <cfif form.sel eq 2>
		    <img src="/cfmx/rh/imagenes/addressGo.gif" border="0">
		    <cfelseif dos.checked>
		    <img src="/cfmx/rh/imagenes/w-check.gif" border="0">
	      </cfif>
	    </div></td>
		<td valign="middle"><div align="center"><a href="registro_valoracion.cfm?SEL=2&RHVPid=#FORM.RHVPid##filtro#"><img src="/cfmx/rh/imagenes/number2_16.gif" border="0"></a></div></td>
		<td valign="middle" nowrap><strong><a href="registro_valoracion.cfm?SEL=2&RHVPid=#FORM.RHVPid##filtro#"><font  style="font-size:10px"><cf_translate key="LB_Clasificacion_de_grados_por_puesto">Clasificaci&oacute;n de grados por puesto</cf_translate></font></a></strong></td>
	  </tr>
	  <tr>
		<td valign="middle"><div align="center">
		  <cfif form.sel eq 3>
		    <img src="/cfmx/rh/imagenes/addressGo.gif" border="0">
		    <cfelseif tres.checked>
		    <img src="/cfmx/rh/imagenes/w-check.gif" border="0">
	      </cfif>
	    </div></td>
		<td valign="middle"><div align="center"><a href="registro_valoracion.cfm?&SEL=3&RHVPid=#FORM.RHVPid##filtro#"><img src="/cfmx/rh/imagenes/number3_16.gif" border="0"></a></div></td>
		<td valign="middle" nowrap><strong><a href="registro_valoracion.cfm?&SEL=3&RHVPid=#FORM.RHVPid##filtro#"><font  style="font-size:10px"><cf_translate key="LB_Equilibrio_Interno">Equilibrio Interno</cf_translate></font></a></strong></td>
	  </tr>
	
    
<!---      <tr>
		<td valign="middle"><div align="center">
		  <cfif form.sel eq 4>
		    <img src="/cfmx/rh/imagenes/addressGo.gif" border="0">
		    <cfelseif cuatro.checked>
		    <img src="/cfmx/rh/imagenes/w-check.gif" border="0">
	      </cfif>
	    </div></td>
		<td valign="middle"><div align="center"><a href="registro_valoracion.cfm?&SEL=3&RHVPid=#FORM.RHVPid##filtro#"><img src="/cfmx/rh/imagenes/number4_16.gif" border="0"></a></div></td>
		<td valign="middle" nowrap><strong><a href="registro_valoracion.cfm?&SEL=3&RHVPid=#FORM.RHVPid##filtro#"><font  style="font-size:10px"><cf_translate key="LB_Equilibrio_Externo_Opcional">Equilibrio Externo (Opcional)</cf_translate></font></a></strong></td>
	  </tr>      
	   <tr>
		<td valign="middle"><div align="center">
		  <cfif form.sel eq 5>
		    <img src="/cfmx/rh/imagenes/addressGo.gif" border="0">
		    <cfelseif cuatro.checked>
		    <img src="/cfmx/rh/imagenes/w-check.gif" border="0">
	      </cfif>
	    </div></td>
		<td valign="middle"><div align="center"><a href="registro_valoracion.cfm?SEL=5&RHVPid=#FORM.RHVPid##filtro#"><img src="/cfmx/rh/imagenes/number5_16.gif" border="0"></a></div></td>
		<td valign="middle" nowrap><strong><a href="registro_valoracion.cfm?SEL=5&RHVPid=#FORM.RHVPid##filtro#"><font  style="font-size:10px"><cf_translate key="LB_Analisis_comparativo">An&aacute;lisis comparativo</cf_translate></font></a></strong></td>
	  </tr>
      <tr>
		<td valign="middle"><div align="center">
		  <cfif form.sel eq 6>
		    <img src="/cfmx/rh/imagenes/addressGo.gif" border="0">
		    <cfelseif cuatro.checked>
		    <img src="/cfmx/rh/imagenes/w-check.gif" border="0">
	      </cfif>
	    </div></td>
		<td valign="middle"><div align="center"><a href="registro_valoracion.cfm?SEL6&RHVPid=#FORM.RHVPid##filtro#"><img src="/cfmx/rh/imagenes/number6_16.gif" border="0"></a></div></td>
		<td valign="middle" nowrap><strong><a href="registro_valoracion.cfm?SEL=6&RHVPid=#FORM.RHVPid##filtro#"><font  style="font-size:10px"><cf_translate key="LB_Reporte_Final">Reporte Final</cf_translate></font></a></strong></td>
	  </tr>      
 --->	
 
  <tr>
		<td valign="middle"></td>
		<td valign="middle"><div align="center"><img src="/cfmx/rh/imagenes/number4_16.gif" border="0"></div></td>
		<td valign="middle" nowrap><strong><font  style="font-size:10px"><cf_translate key="LB_Equilibrio_Externo_Opcional">Equilibrio Externo (Opcional)</cf_translate></font></strong></td>
	  </tr>      
	   <tr>
		<td valign="middle"><div align="center">
		  <cfif form.sel eq 5>
		    <img src="/cfmx/rh/imagenes/addressGo.gif" border="0">
		    <cfelseif cuatro.checked>
		    <img src="/cfmx/rh/imagenes/w-check.gif" border="0">
	      </cfif>
	    </div></td>
		<td valign="middle"><div align="center"><img src="/cfmx/rh/imagenes/number5_16.gif" border="0"></div></td>
		<td valign="middle" nowrap><strong><font  style="font-size:10px"><cf_translate key="LB_Analisis_comparativo">An&aacute;lisis comparativo</cf_translate></font></strong></td>
	  </tr>
      <tr>
		<td valign="middle"><div align="center">
		  <cfif form.sel eq 6>
		    <img src="/cfmx/rh/imagenes/addressGo.gif" border="0">
		    <cfelseif cuatro.checked>
		    <img src="/cfmx/rh/imagenes/w-check.gif" border="0">
	      </cfif>
	    </div></td>
		<td valign="middle"><div align="center"><img src="/cfmx/rh/imagenes/number6_16.gif" border="0"></div></td>
		<td valign="middle" nowrap><strong><font  style="font-size:10px"><cf_translate key="LB_Reporte_Final">Reporte Final</cf_translate></font></strong></td>
	  </tr>    
 
 
 
 </table>
</cfoutput>
<cf_web_portlet_end>