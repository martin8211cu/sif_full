<!--- <cfdump var="#form#"> --->
<cfset modo = 'ALTA'>
<cfif isdefined('session.Ecodigo') and isdefined('form.DEid') and form.DEid GT 0 and isdefined('form.RESNtipoRol')>
	<cfset modo = 'CAMBIO'>
</cfif>
<cfif isdefined('url.DEid') and not isdefined('form.DEid')>
	<cfset form.DEid = url.DEid>
</cfif>

<cfif isdefined("url.RESNtipoRol") and (url.RESNtipoRol gt 0) and not isdefined("form.RESNtipoRol")>
	<cfset form.RESNtipoRol = url.RESNtipoRol>
</cfif>

<cfif modo NEQ 'ALTA'>
	<cfquery name="rsConsulta" datasource="#Session.DSN#">
		select a.DEid, a.NTIcodigo, a.DEidentificacion, b.RESNtipoRol, b.ts_rversion,
			<cf_dbfunction name="concat" args="a.DEnombre,'  ',a.DEapellido2,'  ',a.DEapellido1"> as NombreEmp, b.RESNtipoRol
		from DatosEmpleado a, RolEmpleadoSNegocios b
		where a.Ecodigo= <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		  and a.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid#">
		  and b.RESNtipoRol = <cfqueryparam cfsqltype="cf_sql_tinyint" value="#form.RESNtipoRol#">
		  and a.Ecodigo = b.Ecodigo
		and  a.DEid = b.DEid
	</cfquery>
	<cfset rolantiguo = rsConsulta.RESNtipoRol>
	<cfset empantiguo = rsConsulta.DEid>
	<cfif rsConsulta.recordcount GT 0>
		<cfset modo = "CAMBIO">
	</cfif>

	<cfif rsConsulta.RESNtipoRol eq 1>
		<cfset TipoRol = "1 - Cobrador">
	<cfelseif rsConsulta.RESNtipoRol eq 2>
		<cfset TipoRol = "2 - Vendedor">
	<cfelseif rsConsulta.RESNtipoRol eq 3>
		<cfset TipoRol = "3 - Ejecutivo de Cuenta">
	</cfif>

</cfif>



<script language="JavaScript" src="/cfmx/sif/js/utilesMonto.js"></script>
<cfoutput>
<form name="form1" method="post" action="RolEmpleadoCxC-SQL.cfm">
	<input name="Pagina" type="hidden" tabindex="-1" value="#form.Pagina#">	
	<input name="MaxRows" type="hidden" tabindex="-1" value="#form.MaxRows#">	
	<input name="filtro_DEidentificacion" type="hidden" value="<cfif isdefined('form.filtro_DEidentificacion')>#form.filtro_DEidentificacion#</cfif>">
	<input name="filtro_Nombre" type="hidden" value="<cfif isdefined('form.filtro_Nombre')>#form.filtro_Nombre#</cfif>">
	<input name="filtro_corte" type="hidden" value="<cfif isdefined('form.filtro_corte')>#form.filtro_corte#</cfif>">

	<table border="0" cellpadding="2" cellspacing="0" width="100%" height="75%" align="center">
		<tr>
			<td align="right"><strong>Empleado:&nbsp;</strong></td>
			<td align="left">
			<cfif modo NEQ "ALTA">
				<cf_rhempleado query="#rsConsulta#" readonly="true" tabindex="1" size="40" TipoId="-1">
			<cfelse>
				<cf_rhempleado size="30" tabindex="1" TipoId="-1">
			</cfif>
			</td>
		</tr>
		<tr>
			<td align="right"><strong>Rol:&nbsp;</strong></td>
			<td align="left">
				<cfoutput>
					<cfif modo EQ 'ALTA'>
						<select name="RESNtipoRol" id="RESNtipoRol" tabindex="1" >
							<option value="1">Cobrador</option>
							<option value="2">Vendedor</option>
							<option value="3">Ejecutivo de Ventas</option> 	
						</select>
					<cfelseif modo NEQ 'ALTA'>
						<input type="hidden" name="RESNtipoRol" value="#rsConsulta.RESNtipoRol#" />
						<cfif rsConsulta.RESNtipoRol eq 1><strong>Cobrador</strong>
						<cfelseif rsConsulta.RESNtipoRol eq 2><strong>Vendedor</strong>
						<cfelseif rsConsulta.RESNtipoRol eq 3><strong>Ejecutivo de Ventas</strong>
						</cfif>
					</cfif>
				</cfoutput>
			</td>
		</tr>
		<tr><td>&nbsp;</td></tr>
		<tr>
			<td colspan="2" align="center"><cf_botones modo=#modo# tabindex="1" exclude="cambio"></td>
		</tr>
	  <cfset ts = "">
	  <cfif modo NEQ "ALTA">
		<cfinvoke component="sif.Componentes.DButils" method="toTimeStamp"returnvariable="ts">
			<cfinvokeargument name="arTimeStamp" value="#rsConsulta.ts_rversion#"/>
		</cfinvoke>
	</cfif>  
	  <cfoutput>
	  <input tabindex="-1" type="hidden" name="empantiguo" value="<cfif modo NEQ "ALTA">#empantiguo#</cfif>">
	  <input tabindex="-1" type="hidden" name="rolantiguo" value="<cfif modo NEQ "ALTA">#rolantiguo#</cfif>">
	  <input tabindex="-1" type="hidden" name="ts_rversion" value="<cfif modo NEQ "ALTA">#ts#</cfif>">
	  <input tabindex="-1" type="hidden" name="pagenum_lista" value="<cfif isdefined("form.pagenum_lista") and len(trim(form.pagenum_lista))>#form.pagenum_lista#<cfelse>1</cfif>">
	   
	  <input tabindex="-1" type="hidden" name="fDEIdentificacion" value="<cfif isdefined("form.fDEIdentificacion") and len(trim(form.fDEIdentificacion)) >#form.fDEIdentificacion#</cfif>">
	  <input tabindex="-1" type="hidden" name="fRESNtipoRol" value="<cfif isdefined("form.fRESNtipoRol") and len(trim(form.fRESNtipoRol)) >#form.fRESNtipoRol#</cfif>">	
	  </cfoutput>
	</table> 

</form>
</cfoutput>
<cf_qforms>
	<cf_qformsRequiredField name="DEid" description="Empleado">
	<cf_qformsRequiredField name="RESNtipoRol" description="Tipo de Rol">
</cf_qforms>