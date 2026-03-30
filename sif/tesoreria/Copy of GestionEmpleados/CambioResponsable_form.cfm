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
				<strong>C&oacute;digo:</strong>			
			</td>
			<td width="54%">
				<input type="text" name="codigo" maxlength="50"  <cfif modo eq 'CAMBIO'> value="#rsForm.CCHcodigo#" disabled="disabled" </cfif>>
		    </td>
		</tr>
		
		<tr>
			<td width="46%" align="right">
				<strong>Descripci&oacute;n</strong>			
			</td>
			<td>
				<input type="text" name="descrip" id="descrip" maxlength="150" disabled="disabled" size="50"  <cfif modo eq 'CAMBIO'> value="#rsForm.CCHdescripcion#" </cfif> />
			</td>
		</tr>
		

		<cfif (isdefined ('form.CCHid') and len(trim(form.CCHid)) eq 0) or not isdefined ('form.CCHid')>
		<tr>
			<td width="46%" align="right">
				<strong>Centro Funcional:</strong>			
			</td>
			<td>
						<cf_rhcfuncional form="form1" tabindex="1" >
			</td>
		</tr>
		</cfif>
		
		
		<tr>
			<td width="46%" align="right">
				<strong>Responsable Actual:</strong>			
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
				<strong>Nuevo Responsable:</strong>			
			</td>
			<td>
				<cf_rhempleados form="form1" tabindex="1" DEid="DEid" Usucodigo="Usucodigo2" >						
			</td>
		</tr>
		<tr>
    		<td width="46%" align="right">
				<strong>Fecha de Cambio:</strong>			
			</td>
		   <td>
		     <input type="text" name="fechaCambio" value="<cfoutput>#LSDateFormat(Now(),'dd-mm-yyyy')#</cfoutput>" disabled="disabled" size="20" />
		  </td>
		</tr>		

		<tr>
			<cfif modo eq 'ALTA'>
				<td colspan="3" align="center">
					<input type="submit" name="Limpiar" value="Limpiar" onClick="javascript: Limpiar(); "/>
					<input type="submit" name="Regresar" value="Regresar"onClick="javascript: inhabilitarValidacion(); " />
				</td>
			<cfelse>
				<td colspan="4" align="center">
					<input type="submit" name="Modificar" value="Modificar" onClick="javascript: habilitarValidacion(); "/>
					<input type="submit" name="Regresar" value="Regresar" />
					<input type="submit" name="Bitacora" value="Bitacora" />
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
	objForm.DEid.description = "Responsable de la caja";	
	<cfelse>
	objForm.DEid.description = "Responsable de la caja";
	</cfif>
	}
</script>

<script language="javascript" type="text/javascript">
	function Validar(){
		document.form1.McodigoOri.disabled=false;
		return true;
	}

</script>
