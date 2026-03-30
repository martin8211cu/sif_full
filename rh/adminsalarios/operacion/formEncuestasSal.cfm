
<cfif modo NEQ "ALTA">
	 <cfquery name="rsEncuesta" datasource="sifpublica">
		select a.Eid, a.EEid, a.Edescripcion, a.Efecha, a.Efechaanterior, a.ts_rversion, b.EEnombre
		from Encuesta a 
		inner join EncuestaEmpresa b
		  on a.EEid = b.EEid
		where Eid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Eid#">
	</cfquery> 

<cfquery name="rsArea" datasource="sifpublica">
	select EEid, EAid, EAdescripcion
	from EmpresaArea
	<cfif isdefined("rsEncuesta.EEid")>
	where EEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsEncuesta.EEid#">
	</cfif>
</cfquery>

<!---
<cfquery name="rsPuestoArea" datasource="sifpublica">
	select 	a.EEid, 
			a.EPid, 
			a.EAid, 
			<cf_dbfunction name="to_char" args="a.EEid"> || '|' || <cf_dbfunction name="to_char" args="a.EPid"> || '|' || <cf_dbfunction name="to_char" args="a.EAid"> as Codigo,
			a.EPcodigo, 
			a.EPdescripcion, 
			c.EAdescripcion
	from EncuestaPuesto a
	
	left outer join EmpresaArea c
	on a.EEid = c.EEid 
	and a.EAid = c.EAid 

	<cfif isdefined("Form.EEid")>
		where a.EEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.EEid#">
	</cfif>

	order by c.EAdescripcion
</cfquery>
--->

<cfquery name="rsPuestoArea" datasource="sifpublica">
	select 	a.EPid, 
			a.EPdescripcion, 
			c.EAdescripcion
	from EncuestaPuesto a
	
	left outer join EmpresaArea c
	on a.EEid = c.EEid 
	and a.EAid = c.EAid 

	<cfif isdefined("rsEncuesta.EEid")>
		where a.EEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsEncuesta.EEid#">
	</cfif>

	order by c.EAdescripcion
</cfquery>

<cfquery name="rsTipoOrg" datasource="sifpublica">
	select EEid, ETid, ETdescripcion
	from EmpresaOrganizacion
	<cfif isdefined("rsEncuesta") and rsEncuesta.RecordCount GT 0>
	where EEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsEncuesta.EEid#">
	</cfif>
</cfquery>	
	
</cfif>

<cfif modoD NEQ "ALTA">
	<cfquery name="rsEPA" datasource="sifpublica">
		select *, <cf_dbfunction name="to_char" args="EEid"> || '|' || <cf_dbfunction name="to_char" args="ETid"> || '|' || <cf_dbfunction name="to_char" args="Eid"> || '|' || <cf_dbfunction name="to_char" args="EPid"> || '|' || <cf_dbfunction name="to_char" args="Moneda"> as Codigo
		from EncuestaSalarios
		where Eid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Eid#">
	</cfquery>

</cfif>

<cfif isdefined("rsEncuesta") and not isdefined("Form.EEid")>
	<cfset Form.EEid = rsEncuesta.EEid>
</cfif>

<cfquery  name="rsEmpEnc" datasource="sifpublica">
	select *
	from EncuestaEmpresa
	order by EEnombre
</cfquery>

<script src="/cfmx/sif/js/qForms/qforms.js"></script>
<script language="JavaScript1.2" src="/cfmx/rh/js/utilesMonto.js"></script>

<form style="margin:0; " name="form1" action="SQLEncuestasSal.cfm" method="post">
	<table width="98%" align="right" border="0" cellspacing="2" cellpadding="0">
		<tr> 
          <td colspan="4" class="tituloAlterno"><div align="center">Encuesta de Salarios</div></td>
        </tr>
		<tr>
			<td nowrap align="right">
				<strong>Empresa Encuestadora:&nbsp;</strong>
			</td>
			<td nowrap>
				<cfoutput>
					<select name="EEid" id="EEid" onChange="javascript:orgArea(this.value,'')"<cfif modo NEQ 'ALTA'>disabled</cfif>> 
						<option value="" ></option>
						<cfloop query="rsEmpEnc" >
							<option value="#rsEmpEnc.EEid#" 
							<cfif modo NEQ 'ALTA' and rsEncuesta.EEid EQ rsEmpEnc.EEid>selected</cfif>>#rsEmpEnc.EEnombre#</option>
						</cfloop>
					</select>
				</cfoutput>
			</td>
		</tr>
		<tr> 
			<td nowrap align="right">
				<strong>Descripción:&nbsp;</strong>
			</td>
			<td width="88%">
				<cfoutput>
					<input name="Edescripcion" type="text"  tabindex="1" 
						value="<cfif modo NEQ "ALTA">#rsEncuesta.Edescripcion#</cfif>" size="60" maxlength="80">
				</cfoutput>
			</td>
		</tr>
		<tr>
			<td align="right"  nowrap>
				<strong>Fecha:&nbsp;</strong>
			</td>
			<td align="left" width="50%">
				<cfoutput>
					<cfif modo NEQ "ALTA">
						<input name="Efecha" type="text"  tabindex="1" 
						value="#LSDateFormat(rsEncuesta.Efecha,'DD/MM/YYYY')#" disabled
						size="12" maxlength="20">
					<cfelse>
						<cf_sifcalendario form="form1" name="Efecha" value="#LSDateFormat(Now(),'DD/MM/YYYY')#">
					</cfif>
				</cfoutput>
			</td>
		</tr>
		<tr> 
			<td>
				<cfoutput>				
					<input type="hidden" name="Eid" value="<cfif modo NEQ "ALTA">#rsEncuesta.Eid#</cfif>"> 
				</cfoutput>
			</td>
		</tr>
		<tr>
				<td nowrap align="left">&nbsp;</td>
				<td nowrap>&nbsp;</td>
			</tr>
		<tr> 
			<td colspan="2"align="center" >
				<cfoutput>
					<cfif modo EQ "ALTA">
						<input name="AgregarE" type="submit" value="Agregar" tabindex="1">
						<input type="button" name="LimpiarD" value="Limpiar" tabindex="6" onClick="javascript:limpiarE();">
						<input name="Regresar" type="button" value="Regresar" onClick="javascript: Lista();" tabindex="1">
					</cfif>
				</cfoutput>
			</td>
		</tr>
		<tr>
			<td nowrap align="left">&nbsp;</td>
			<td nowrap>&nbsp;</td>
		</tr>
		<cfif modo NEQ "ALTA">
			<tr> 
				<td colspan="4" class="tituloAlterno"><div align="center">Puestos por &Aacute;rea</div></td>
			</tr>
			<tr>
				<td nowrap align="left">&nbsp;</td>
				<td nowrap>&nbsp;</td>
			</tr>
			<tr>
				<td nowrap align="left"><div align="right"><strong>Tipo de Organizaci&oacute;n:&nbsp;</strong></div></td>
				<td nowrap >
					<cfoutput>
						<select name="ETid" id="ETid"> 
							<option value="" ></option>
							<cfloop query="rsTipoOrg">
								<option value="#rsTipoOrg.ETid#" 
								<cfif modoD NEQ 'ALTA' and rsEPA.ETid EQ rsTipoOrg.ETid>selected</cfif>>
									#rsTipoOrg.ETdescripcion#</option>
							</cfloop>
						</select>
					</cfoutput>
				</td>
			</tr>
			<tr>
				<td nowrap align="left">
				<div align="right"><strong>Puesto por &Aacute;rea:&nbsp;</strong></div></td>
				<td>
					<cfoutput>
						<select name="EPid" id="EPid"> 
							<option value="" ></option>
							<cfloop query="rsPuestoArea">
								<option value="#rsPuestoArea.EPid#"
								<cfif modoD NEQ 'ALTA' and rsEPA.EPid EQ rsPuestoArea.EPid >selected</cfif>>
										#Ucase(rsPuestoArea.EAdescripcion)# - #rsPuestoArea.EPdescripcion#</option>
							</cfloop>
						</select>
					</cfoutput>
				</td>
			</tr>
			<tr>
				<td nowrap align="left">&nbsp;</td>
				<td nowrap>&nbsp;</td>
			</tr>
			<tr> 
			<td colspan="2"align="center" >
				<cfoutput>
					<cfif modo NEQ "ALTA">
						<input type="submit" name="CambioD" value="Modificar" tabindex="3"
								onClick="javascript: setBtn(this); deshabilitarValidacion();" >
						<input type="submit" name="BajaE" value="Eliminar Encuesta" tabindex="3" 
							   onClick="javascript: setBtn(this); deshabilitarValidacion(); return confirm('¿Desea eliminar este registro?');">
						
					</cfif>					
					<cfif modoD EQ "ALTA">
						<input name="AgregarD"  type="submit" value="Agregar Puesto" tabindex="1">
						<input type="button" name="LimpiarD" value="Limpiar" tabindex="6" 
																 onClick="javascript:limpiarD();">
					<cfelse>
						<input type="submit" name="BajaD" value="Eliminar Puesto" tabindex="3" 
							   onClick="javascript: setBtn(this);deshabilitarValidacion(); return confirm('¿Desea eliminar este registro?');">
						<input type="submit" name="NuevoD" value="Nuevo" tabindex="3" 
							onClick="javascript: setBtn(this); ">
					</cfif>
					<input type="button"  name="Regresar" value="Regresar" onClick="javascript: Lista();" tabindex="1">
				</cfoutput>
			</td>
		</tr>
		</cfif>
	</table>
	
	<input type="hidden" name="ESid" id="ESid" value="<cfif modoD neq "ALTA"><cfoutput>#rsEPA.ESid#</cfoutput></cfif>" >
	<input type="hidden" name="Eid" id="Eid" >
</form>
<script language="JavaScript1.2">

<!--//
	// specify the path where the "/qforms/" subfolder is located
	qFormAPI.setLibraryPath("/cfmx/sif/js/qForms/");
	// loads all default libraries
	qFormAPI.include("*");
	//-->

	function limpiarE(){
		document.form1.EEid.value = "";
		document.form1.Edescripcion.value   = "";
	}
	
	function limpiarD(){
		document.form1.ETid.value = "";
		document.form1.Codigo.value   = "";		
	}
	
	var boton = "";
	function setBtn(button){
		boton = button.name;
	}
	function Lista() {
		location.href = 'listaEncuestasSal.cfm';
	}
	
	qFormAPI.errorColor = "#FFFFCC";
	objForm = new qForm("form1");

	objForm.EEid.required = true;
	objForm.EEid.description="Empresa Encuestadora";

	objForm.Edescripcion.required = true;
	objForm.Edescripcion.description="Descripción";

/**/	
	objForm.ETid.required = true;
	objForm.ETid.description="Tipo de Organización";
	objForm.EPid.required = true;
	objForm.EPid.description="Puesto por Área";

	
	function deshabilitarValidacion(){
		objForm.ETid.required = false;
		objForm.EPid.required = false;
	}
</script>