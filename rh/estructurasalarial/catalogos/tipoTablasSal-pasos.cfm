<!--- Consultas para determinar cuales pasos ya fueron cumplidos o están siendo cumplidos --->
<cfif isdefined("form.RHTTid") and len(trim(form.RHTTid)) gt 0>
	<cfquery name="rsUno" datasource="#Session.DSN#">
		select 1
		from RHTTablaSalarial
		where RHTTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHTTid#">
	</cfquery>
	<cfquery name="rsDos" datasource="#Session.DSN#">
		select  count(1) as Cont
		from RHVigenciasTabla 
		where Ecodigo  = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		  and RHTTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHTTid#">
	</cfquery>
	<cfif isdefined('form.RHVTid') and LEN(TRIM(form.RHVTid))>
		<cfquery name="rsTres" datasource="#Session.DSN#">
			select  count(1) as Cont
			from RHVigenciasTabla a
			where Ecodigo  = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			  and RHTTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHTTid#">
			  and RHVTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHVTid#">
		</cfquery>
	</cfif>
	<cfif isdefined('form.RHVTid') and LEN(TRIM(form.RHVTid))>
		<cfquery name="rsCuatro" datasource="#Session.DSN#">
			select  count(1) as Cont
			from RHVigenciasTabla a
			where Ecodigo  = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			  and RHTTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHTTid#">
			  and RHVTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHVTid#">
		</cfquery>
	</cfif>
	<cfif isdefined('form.RHVTid') and LEN(TRIM(form.RHVTid))>
		<cfquery name="rsCinco" datasource="#Session.DSN#">
			select  count(1) as Cont
			from RHMontosCategoria
			where RHVTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHVTid#">
			  and (RHMCmontoFijo > 0 or RHMCmontoPorc > 0)
		</cfquery>
	</cfif>

</cfif>
<cfscript>
	uno.checked = isdefined("rsUno") and rsUno.RecordCount gt 0;
	dos.checked =  isdefined("rsDos") and rsDos.Cont gt 0;
	tres.checked = isdefined("rsTres") and rsTres.Cont gt 0;
	cuatro.checked = isdefined("rsCuatro") and rsCuatro.Cont gt 0;
	cinco.checked = isdefined("rsCinco") and rsCinco.Cont gt 0;
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
		<td width="1%" valign="middle"><div align="center"><a href="tipoTablasSal.cfm?SEL=0"><img src="/cfmx/rh/imagenes/Home01_T.gif" border="0"></a></div></td>
		<td width="100%" valign="middle" nowrap><strong><a href="tipoTablasSal.cfm?SEL=0"><cf_translate key="LB_ListaDeTablas">Lista de Tablas Salariales</cf_translate></a></strong></td>
	  </tr>
	  <tr>
		<td width="1%" valign="middle"><div align="center">
		  <cfif form.sel eq 1>
		    <img src="/cfmx/rh/imagenes/addressGo.gif" border="0">
		    <cfelseif uno.checked>
		    <img src="/cfmx/rh/imagenes/w-check.gif" border="0">
	      </cfif>
	    </div></td>
		<td width="1%" valign="middle"><div align="center"><a href="tipoTablasSal.cfm?SEL=1&RHTTid=#FORM.RHTTid#"><img src="../../imagenes/number1_16.giF" border="0"></a></div></td>
		<td width="100%" valign="middle" nowrap><strong><a href="tipoTablasSal.cfm?SEL=1&RHTTid=#FORM.RHTTid#"><cf_translate key="LB_RegistroTabla">Registro de Tabla</cf_translate> </a></strong></td>
	  </tr>
	  <tr>
		<td valign="middle"><div align="center">
		  <cfif form.sel eq 2>
		    <img src="/cfmx/rh/imagenes/addressGo.gif" border="0">
		    <cfelseif dos.checked>
		    <img src="/cfmx/rh/imagenes/w-check.gif" border="0">
	      </cfif>
	    </div></td>
		<td valign="middle"><div align="center"><a href="tipoTablasSal.cfm?SEL=2&RHTTid=#FORM.RHTTid#<cfif isdefined('form.RHVTid')>&RHVTid=#form.RHVTid#</cfif>"><img src="/cfmx/rh/imagenes/number2_16.gif" border="0"></a></div></td>
		<td valign="middle" nowrap><strong><a href="tipoTablasSal.cfm?SEL=2&RHTTid=#FORM.RHTTid#<cfif isdefined('form.RHVTid')>&RHVTid=#form.RHVTid#</cfif>"><cf_translate key="LB_Vigencias">Vigencias</cf_translate></a></strong></td>
	  </tr>
	  <tr>
		<td valign="middle"><div align="center">
		  <cfif form.sel eq 3>
		    <img src="/cfmx/rh/imagenes/addressGo.gif" border="0">
		   <cfelseif tres.checked>
		    <img src="/cfmx/rh/imagenes/w-check.gif" border="0">
	      </cfif>
	    </div></td>
		<cfif tres.checked>
		<td valign="middle"><div align="center"><a href="tipoTablasSal.cfm?&SEL=3&RHTTid=#FORM.RHTTid#&RHVTid=#form.RHVTid#"><img src="/cfmx/rh/imagenes/number3_16.gif" border="0"></a></div></td>
		<td valign="middle" nowrap><strong><a href="tipoTablasSal.cfm?&SEL=3&RHTTid=#FORM.RHTTid#&RHVTid=#form.RHVTid#"><cf_translate key="LB_IncrementoFijo">Incremento Fijo</cf_translate></a></strong></td>
		<cfelse>
		<td valign="middle"><div align="center"><img src="/cfmx/rh/imagenes/number3_16.gif" border="0"></div></td>
		<td valign="middle" nowrap><strong><cf_translate key="LB_IncrementoFijo">Incremento Fijo</cf_translate></strong></td>
		</cfif>
	  </tr>
	  <tr>
		<td valign="middle"><div align="center">
		  <cfif form.sel eq 4>
		    <img src="/cfmx/rh/imagenes/addressGo.gif" border="0">
		    <cfelseif cuatro.checked>
		    <img src="/cfmx/rh/imagenes/w-check.gif" border="0">
	      </cfif>
	    </div></td>
		<cfif cuatro.checked>
		<td valign="middle"><div align="center"><a href="tipoTablasSal.cfm?SEL=4&RHTTid=#FORM.RHTTid#<cfif isdefined('form.RHVTid')>&RHVTid=#form.RHVTid#</cfif>"><img src="/cfmx/rh/imagenes/number4_16.gif" border="0"></a></div></td>
		<td valign="middle" nowrap><strong><a href="tipoTablasSal.cfm?SEL=4&RHTTid=#FORM.RHTTid#<cfif isdefined('form.RHVTid')>&RHVTid=#form.RHVTid#</cfif>"><cf_translate key="LB_IncrementoPorc">Incremento Porcentual</cf_translate></a></strong></td>
		<cfelse>
		<td valign="middle"><div align="center"><img src="/cfmx/rh/imagenes/number4_16.gif" border="0"></div></td>
		<td valign="middle" nowrap><strong><cf_translate key="LB_IncrementoPorc">Incremento Porcentual</cf_translate></strong></td>
		</cfif>
	  </tr>
	  <tr>
	  	<td valign="middle"><div align="center">
	  	  <cfif form.sel eq 5>
	  	    <img src="/cfmx/rh/imagenes/addressGo.gif" border="0">
	  	    <cfelseif cinco.checked>
	  	    <img src="/cfmx/rh/imagenes/w-check.gif" border="0">
  	      </cfif>
  	    </div></td>
		<cfif cinco.checked>
		<td valign="middle"><div align="center"><a href="tipoTablasSal.cfm?SEL=4&RHTTid=#FORM.RHTTid#<cfif isdefined('form.RHVTid')>&RHVTid=#form.RHVTid#</cfif>"><img src="/cfmx/rh/imagenes/number4_16.gif" border="0"></a></div></td>
		<td valign="middle" nowrap><strong><a href="tipoTablasSal.cfm?SEL=4&RHTTid=#FORM.RHTTid#<cfif isdefined('form.RHVTid')>&RHVTid=#form.RHVTid#</cfif>"><cf_translate key="LB_AplicaTabla">Aplicar Tabla</cf_translate></a></strong></td>
		<cfelse>
		<td valign="middle"><div align="center"><img src="/cfmx/rh/imagenes/number4_16.gif" border="0"></div></td>
		<td valign="middle" nowrap><strong><cf_translate key="LB_AplicaTabla">Aplicar Tabla</cf_translate></strong></td>
		</cfif>		
		</tr>
	</table>
</cfoutput>
<cf_web_portlet_end>