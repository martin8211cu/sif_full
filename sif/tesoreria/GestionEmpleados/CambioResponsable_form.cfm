<cfinvoke component ="sif.Componentes.Translate" method = "Translate" key = "LB_Codigo" default = "C&oacute;digo" returnvariable="LB_Codigo" xmlfile = "CambioResponsable_form.xml">
<cfinvoke component ="sif.Componentes.Translate" method = "Translate" key = "LB_Descripcion" default = "Descripci&oacute;n" returnvariable="LB_Descripcion" xmlfile = "CambioResponsable_form.xml">
<cfinvoke component ="sif.Componentes.Translate" method = "Translate" key = "LB_CentroFuncional" default = "Centro Funcional" returnvariable="LB_CentroFuncional" xmlfile = "CambioResponsable_form.xml">
<cfinvoke component ="sif.Componentes.Translate" method = "Translate" key = "LB_ResponsableActual" default = "Responsable Actual" returnvariable="LB_ResponsableActual" xmlfile = "CambioResponsable_form.xml">
<cfinvoke component ="sif.Componentes.Translate" method = "Translate" key = "LB_NuevoResponsable" default = "Nuevo Responsable" returnvariable="LB_NuevoResponsable" xmlfile = "CambioResponsable_form.xml">
<cfinvoke component ="sif.Componentes.Translate" method = "Translate" key = "LB_FechaCambio" default = "Fecha de Cambio" returnvariable="LB_FechaCambio" xmlfile = "CambioResponsable_form.xml">
<cfinvoke component ="sif.Componentes.Translate" method = "Translate" key = "BTN_Modificar" default = "Modificar" returnvariable="BTN_Modificar" xmlfile = "CambioResponsable_form.xml">
<cfinvoke component ="sif.Componentes.Translate" method = "Translate" key = "BTN_Regresar" default = "Regresar" returnvariable="BTN_Regresar" xmlfile = "CambioResponsable_form.xml">
<cfinvoke component ="sif.Componentes.Translate" method = "Translate" key = "BTN_Bitacora" default = "Bitacora" returnvariable="BTN_Bitacora" xmlfile = "CambioResponsable_form.xml">
<cfinvoke component ="sif.Componentes.Translate" method = "Translate" key = "BTN_Limpiar" default = "Limpiar" returnvariable="BTN_Limpiar" xmlfile = "CambioResponsable_form.xml">


<form name="form1" method="post" action="CambioResponsable_sql.cfm" onsubmit="javascript:return Validar()">
<cfif isdefined ('url.CCHid') and not isdefined ('form.CCHid')>
	<cfset form.CCHid = #url.CCHid#>
</cfif>

<cfif isdefined ('form.CCHid') and len(trim(form.CCHid)) gt 0>

<cfoutput>
<input type="hidden" name="CCHid" value="#form.CCHid#" />
</cfoutput>
<cf_dbfunction name="op_concat" returnvariable="LvarCNCT">
	<cfquery name="rsForm" datasource="#session.dsn#">
		select 
			a.CFcuenta,
			a.Ecodigo,
			a.Mcodigo,
			a.CCHcodigo,
			a.CCHdescripcion,
			a.CCHestado,
			a.CCHmax,
			a.CCHmin,
			a.CCHmontoA,
			a.CCHresponsable,			
			d.DEnombre#LvarCNCT#' '#LvarCNCT#d.DEapellido1#LvarCNCT#' '#LvarCNCT#d.DEapellido2 as CCHresponsable1  
		from CCHica a
		   inner join DatosEmpleado d
             on d.DEid = a.CCHresponsable
		where CCHid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CCHid#">		 
	</cfquery>

	<cfset modo='CAMBIO'>
   <cfelse>
	<cfquery name="rsAlta" datasource="#session.dsn#">
		select CCHCmonto, CCHCmax, CCHCmin 
			from CCHconfig 
		where 
		Ecodigo= <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	</cfquery>
	<cfset modo='ALTA'>

</cfif>
<table width="100%" border="0">
	<cfoutput>
		<tr>
			<td width="46%" align="right">
				<strong>#LB_Codigo#:</strong>			
			</td>
			<td width="54%">
				<input type="text" name="codigo" maxlength="50"  <cfif modo eq 'CAMBIO'> value="#rsForm.CCHcodigo#" disabled="disabled" </cfif>>
		    </td>
		</tr>
		
		<tr>
			<td width="46%" align="right">
				<strong>#LB_Descripcion#</strong>			
			</td>
			<td>
				<input type="text" name="descrip" id="descrip" maxlength="150" disabled="disabled" size="50"  <cfif modo eq 'CAMBIO'> value="#rsForm.CCHdescripcion#" </cfif> />
			</td>
		</tr>
		

		<cfif (isdefined ('form.CCHid') and len(trim(form.CCHid)) eq 0) or not isdefined ('form.CCHid')>
		<tr>
			<td width="46%" align="right">
				<strong>#LB_CentroFuncional#:</strong>			
			</td>
			<td>
						<cf_rhcfuncional form="form1" tabindex="1" >
			</td>
		</tr>
		</cfif>
		
		
		<tr>
			<td width="46%" align="right">
				<strong>#LB_ResponsableActual#:</strong>			
			</td>
			<td>
				<cfif modo eq "CAMBIO">		
					<input type="text" name="RespAnterior" value="#rsForm.CCHresponsable1#" disabled="disabled" size="65" />		
					<input type="hidden" name="idRespAnterior" value="#rsForm.CCHresponsable#" />		
				</cfif>			
			</td>
		</tr>
		<tr>
			<td width="46%" align="right">
				<strong>#LB_NuevoResponsable#:</strong>			
			</td>
			<td>
				<cf_rhempleados form="form1" tabindex="1" DEid="DEid" Usucodigo="Usucodigo2" >						
			</td>
		</tr>
		<tr>
    		<td width="46%" align="right">
				<strong>#LB_FechaCambio#:</strong>			
			</td>
		   <td>
		     <input type="text" name="fechaCambio" value="<cfoutput>#LSDateFormat(Now(),'dd-mm-yyyy')#</cfoutput>" disabled="disabled" size="20" />
		  </td>
		</tr>		

		<tr>
			<cfif modo eq 'ALTA'>
				<td colspan="3" align="center">
					<input type="submit" name="Limpiar" value="#BTN_Limpiar#" onClick="javascript: Limpiar(); "/>
					<input type="submit" name="Regresar" value="#BTN_Regresar#"onClick="javascript: inhabilitarValidacion(); " />
				</td>
			<cfelse>
				<td colspan="4" align="center">
					<input type="submit" name="Modificar" value="#BTN_Modificar#" onClick="javascript: habilitarValidacion(); "/>
					<input type="submit" name="Regresar" value="#BTN_Regresar#" />
					<input type="submit" name="Bitacora" value="#BTN_Bitacora#" />
				</td>

			</cfif>
		</tr>
	<!---	<cfif isdefined ('url.Transac')>
			<cfinclude template="CCHtransacciones.cfm">
		</cfif>--->
	</cfoutput>
  </table>
</form>


<!---<cfif isdefined ('url.Cfunc') or isdefined ('form.cfid')>
	<cfinclude template="CCHcentroF_form.cfm">
</cfif>--->

<!---Validaciones--->

<cf_qforms>


<script language="javascript" type="text/javascript">

	function inhabilitarValidacion() {
	<cfif modo eq 'ALTA'>			
		objForm.DEid.required = false;			
	<cfelse>				
		objForm.DEid.required = false;			
	</cfif>
	}

	function habilitarValidacion() {
	<cfif modo eq 'ALTA'>		
		objForm.DEid.required = true;	
	<cfelse>					
		objForm.DEid.required = true;			
	</cfif>
	
	<cfif modo eq 'ALTA'>
	objForm.DEid.description = "<cfoutput>#LB_NuevoResponsable#</cfoutput>";	
	<cfelse>
	objForm.DEid.description = "<cfoutput>#LB_NuevoResponsable#</cfoutput>";
	</cfif>
	}
</script>

<script language="javascript" type="text/javascript">
	function Validar(){
		document.form1.McodigoOri.disabled=false;
		return true;
	}

</script>
