<!---Errores Controlados--->
<cfif isdefined ('url.ErrorEli') and len(trim(url.ErrorEli)) gt 0>
	<cf_errorCode	code = "50170" msg = "No se puede Eliminar el Documento porque tiene Facturas asociadas que ya fueron Aplicadas">

</cfif>

<cfif isdefined ('url.ErrorS') and len(trim(url.ErrorS)) gt 0>
	<script language="javascript" type="text/javascript">
		alert('No se ha escogido ningun documento para Aplicar');
	</script>

</cfif>

<cfif isdefined ('url.Error') and len(trim(url.Error)) gt 0>
	<cfloop list="#url.Error#" delimiters="," index="bb">
		<cfset valor=#listgetat(bb, 1, ',')#>
		<cf_errorCode	code = "50169"
						msg  = "De los archivos que se generaron no se pudo aplicar el cobro a: @errorDat_1@"
						errorDat_1="#url.Error#"
		>
	</cfloop>
</cfif>

<cfif isdefined('form.EAid') and len(trim(form.EAid))>
	<cfset modo = 'CAMBIO'>
<cfelse>
	<cfset modo = 'ALTA'>
</cfif>

<!---Combo de Configuraciones--->
<cfquery name="configura" datasource="#session.dsn#">
	select CxCGid, CxCGdescrip 
	from CxCGeneracion 
	where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
</cfquery>


<cfif isdefined ('url.EAid') and not isdefined('form.EAid')>
	<cfset form.EAid=#url.EAid#>
	<cfset modo='CAMBIO'>
</cfif>

<cfif modo NEQ 'ALTA'>
	<cfquery datasource="#session.dsn#" name="rsForm">
	select 
			a.EAid,
			a.EAdescrip,
			a.EAfechaVen,
			a.EAestado,
			a.CxCGid,
			a.EAfecha,
			(select CxCGcod from CxCGeneracion where CxCGid = a.CxCGid) as confi
			from 
			EAgrupador a
		where 
			a.Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			and a.EAid= <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.EAid#">
	</cfquery>
	<cfquery name="rsCo" datasource="#session.dsn#">
		select count(1) as cantidad from DPagos where EAid=#form.EAid#
	</cfquery>
	<cfquery name="rsCo1" datasource="#session.dsn#">
		select count(1) as cantidad from BMovimientos where EAid=#form.EAid#
	</cfquery>
</cfif>

<form action="agrupador_sql.cfm"  method="post"  name="form1" id="form1" style= "margin: 0;">
	<cfoutput>	
	<input type="hidden" name="modo" value="#modo#" />
	
	<cfif modo NEQ 'ALTA'>
		<input type="hidden" name="EAid" value="#rsForm.EAid#" />
	</cfif>
	
<table align="center"  width="100%" border="0">	

		<!---Fecha Creación--->
		<tr>			
			<td valign="top" nowrap="nowrap"align="right"><strong>Fecha:</strong></td>
			<td valign="top" nowrap="nowrap" align="left">
				<cfif modo neq 'ALTA'> 
					<strong>#LSDateFormat(rsForm.EAfecha,"DD/MM/YYYY")#</strong>
				<cfelse>
					<strong>#LSDateFormat(now(),"DD/MM/YYYY")#</strong>
				</cfif>
			</td>
		</tr>

		<!---Descripción--->
		<tr>
			<td  align="right"><strong>Descripci&oacute;n:</strong></td>
			<td valign="top" nowrap="nowrap" align="left">
				<input 
				tabindex="1" 
				name="EAdescrip" 
				id="EAdescrip"
				type="text" 
				size="120" 
				maxlength="100"
				value="<cfif modo NEQ 'ALTA'>#trim(rsForm.EAdescrip)#</cfif>"/>
			</td>
		</tr>

		<!---Fecha Vencimiento--->
		<tr>
			<td colspan="2">
				<table border="0" width="100%">
				<tr>
					<td nowrap="nowrap" colspan="2" align="right"><strong>Fecha de Vencimiento:</strong></td> 
						<cfset EAfecha=DateFormat(Now(),'DD/MM/YYYY')>
							<cfif modo NEQ 'ALTA'>
								<cfset EAfechaVen = DateFormat(rsForm.EAfechaVen,'DD/MM/YYYY') >
							<cfelse>
								<cfset EAfechaVen = DateFormat(now(),'DD/MM/YYYY') >
							</cfif>
							<cfif isdefined ('rsCo.cantidad') and #rsCo.cantidad# gt 0 or isdefined ('rsCo1.cantidad') and #rsCo1.cantidad# gt 0>
							<cfset LvarR= 'yes'>
							<cfelse>
							<cfset LvarR= 'no'>
							</cfif>
					<td width="87%"><cf_sifcalendario form="form1" value="#EAfechaVen#" name="EAfechaVen" tabindex="1" readOnly="#LvarR#"></td> 				
				</tr>
				</table>
			</td>
		</tr>
	</cfoutput>
	
		<!---Tipo--->
		<tr>
			<td align="right" valign="top"><strong>Tipo:</strong></td>
			<td align="left"nowrap="nowrap" valign="top">
				<select name="config" <cfif isdefined ('rsCo.cantidad') and #rsCo.cantidad# gt 0 or isdefined ('rsCo1.cantidad') and #rsCo1.cantidad# gt 0> disabled="disabled"</cfif>>  
					<cfif configura.RecordCount>
						<cfoutput query="configura">
						<option value="#configura.CxCGid#" <cfif modo neq "ALTA" and rsForm.CxCGid EQ configura.CXCGid> selected</cfif>>#configura.CxCGdescrip#</option>
					</cfoutput>
					</cfif>
				</select>							
			</td>
		</tr>
	<cfoutput>
	<cfif isdefined ('form.EAid')>
	<cfquery name="rs" datasource="#session.dsn#">
		select count (1) as cantidad from DAgrupador where EAid=#form.EAid#
	</cfquery>
	<cfquery name="rs1" datasource="#session.dsn#">
		select count (1) as cantidad from DPagos where EAid=#form.EAid#
	</cfquery>
	<cfquery name="rs2" datasource="#session.dsn#">
		select count (1) as cantidad from BMovimientos where EAid=#form.EAid#
	</cfquery>
	<cfquery name="rs3" datasource="#session.dsn#">
		select count (1) as cantidad from EAgrupador where EAid=#form.EAid# and EAestado='Aplicado'
	</cfquery>
	</cfif>
		<tr>
			<td>&nbsp;</td>
			<td align="center" nowrap="nowrap" valign="top">
				<!---Botones Alta--->
				<cfif modo neq 'ALTA'>
					<input type="submit"  value="Nuevo" name="nuevo" id="Nuevo" onClick="javascript: inhabilitarValidacion(); "/>
					<input type="submit"  value="Modificar" name="modifica" id="modifica" onClick="javascript: inhabilitarValidacion(); " <cfif rs.cantidad gt 0 or rs1.cantidad gt 0 or rs2.cantidad gt 0 or rs3.cantidad gt 0>disabled="disabled"</cfif>/>
					<input type="submit" name="Baja" value="Eliminar" tabindex="1" onclick="javascript: return funEli() " />
					<input type="submit" name="generar" value="Generar"  <cfif rs1.cantidad gt 0 or rs2.cantidad gt 0 or rs3.cantidad gt 0>disabled="disabled"</cfif>/>
					<input type="submit"  value="Reporte" name="Reporte"/>
					<input type="submit"  value="Regresar" name="irLista" id="irLista" onClick="javascript: inhabilitarValidacion(); "/>
				<!---Botones Baja--->
				<cfelse>
					<input type="submit"  value="Agrega" name="Agrega" id="Agrega" onClick="javascript: habilitarValidacion(); "/>
					<input type="reset" name="Limpiar" value="Limpiar" onClick="javascript: inhabilitarValidacion(); " >		
					<input type="submit"  value="Regresar" name="irLista" id="irLista" onClick="javascript: inhabilitarValidacion(); "/>				
				</cfif>
					<input type="submit"  value="Aid" name="BorrarDet" id="BorrarDet" style="display:none"/>			
			</td>
		</tr>
	</table>
    </cfoutput>
</form>



<!---ValidacionesFormulario--->
<cf_qforms>
<script language="javascript" type="text/javascript">
	function funEli(){
	if ( confirm('¿Está seguro(a) de que desea eliminar el registro?'))
		{
		document.form1.submit();
			
		}
	else{
	return false;
	}
	}
	
	function funcBajaAnt(){
		inhabilitarValidacion();
		return confirm("Desea Eliminar el Registro?")
	}
	function inhabilitarValidacion() {
		objForm.EAdescrip.required = false;	
		objForm.EAfechaVen.required = false;		
		objForm.config.required = false;		
	}

	function habilitarValidacion() {
		objForm.EAdescrip.required = true;	
		objForm.EAfechaVen.required = true;		
		objForm.config.required = true;	
	}

	objForm.EAdescrip.description = "descripción";
	objForm.EAfechaVen.description = "fecha de vencimiento";
	objForm.config.description = "configuración";
	
	function Reporte(){
		//document.form1.action = 'VRreporte_form.cfm'			
	}
</script>

<cfif modo neq "ALTA">
<cfquery name="rsDA" datasource="#session.dsn#">
	select count(1) as cantidad from DAgrupador where EAid= #form.EAid#
</cfquery>

<cfif isdefined ('url.Genera') or rsDA.cantidad gt 0>			
		<cfinclude template="agrupar_det.cfm">	
</cfif>
</cfif>


