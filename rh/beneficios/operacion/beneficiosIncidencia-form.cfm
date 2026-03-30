<cfif isdefined("Form.HIBlinea") and Len(Trim(Form.HIBlinea))>
	<cfset modo = "CAMBIO">
<cfelse>
	<cfset modo = "ALTA">
</cfif>

<!--- Monedas --->
<cfquery name="rsMonedas" datasource="#Session.DSN#">
	select Mcodigo, Mnombre, Msimbolo, Miso4217
	from Monedas
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
	order by Mcodigo
</cfquery>

<cfif modo EQ "CAMBIO">
	<cfquery name="rsData" datasource="#Session.DSN#">
		select a.HIBlinea, a.BElinea, a.Mcodigo, a.HIBfecha, a.HIBmonto, a.HIBcant, a.HIBporcemp, a.SNcodigo, a.fechaalta, a.BMUsucodigo, a.ts_rversion,
			   b.DEid, b.Bid, b.BEfdesde, b.BEfhasta, b.BEactivo, b.fechainactiva, b.fechaalta, 
			   c.Bcodigo, c.Bdescripcion, d.NTIcodigo, d.DEidentificacion, rtrim(d.DEapellido1 || ' ' || d.DEapellido2) || ', ' || d.DEnombre as NombreEmp, e.NTIdescripcion
		from HIBeneficios a, RHBeneficiosEmpleado b, RHBeneficios c, DatosEmpleado d, NTipoIdentificacion e
		where a.HIBlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.HIBlinea#">
		and a.BElinea = b.BElinea
		and b.Bid = c.Bid
		and b.DEid = d.DEid
		and d.NTIcodigo = e.NTIcodigo
	</cfquery>
</cfif>

<script src="/cfmx/rh/js/utilesMonto.js"></script>
<script src="/cfmx/sif/js/qForms/qforms.js"></script>
<script language="javascript" type="text/javascript">
	// specify the path where the "/qforms/" subfolder is located
	qFormAPI.setLibraryPath("/cfmx/sif/js/qForms/");
	// loads all default libraries
	qFormAPI.include("*");

</script>

<cfoutput>
	<form name="form1" method="post" action="beneficiosIncidencia-sql.cfm" style="margin: 0; " onSubmit="javascript: valida(this);">
		<input type="hidden" name="Btercero" value="0">
		<cfif isdefined("Form.PageNum2")>
			<input type="hidden" name="PageNum2" value="#Form.PageNum2#">
		</cfif>
		<cfif modo EQ "CAMBIO">
			<input type="hidden" name="HIBlinea" value="#Form.HIBlinea#">
			<cfset ts = "">
			<cfinvoke 
				component="sif.Componentes.DButils"
				method="toTimeStamp"
				returnvariable="ts">
				<cfinvokeargument name="arTimeStamp" value="#rsData.ts_rversion#"/>
			</cfinvoke>
			<input type="hidden" name="ts_rversion" value="#ts#">
		</cfif>
		<table width="96%"  border="0" cellspacing="0" cellpadding="2" align="center">
		  <tr>
			<td align="right" nowrap class="fileLabel">Empleado:</td>
			<td colspan="3" nowrap>
				<cfif modo EQ "CAMBIO">
					#rsData.NTIdescripcion#: #rsData.DEidentificacion# - #rsData.NombreEmp#
					<input type="hidden" name="DEid" value="#rsData.DEid#">
				<cfelse>
					<cf_rhempleado tabindex="1" size = "40">
				</cfif>
			</td>
			<td align="right" nowrap class="fileLabel">Beneficio:</td>
			<td colspan="3" nowrap>
				<cfif modo EQ "CAMBIO">
					#rsData.Bcodigo# - #rsData.Bdescripcion#
				<cfelse>
					<cf_rhbeneficioempleado form="form1">
				</cfif>
			</td>
		  </tr>
		  <tr>
			<td align="right" nowrap class="fileLabel">Moneda:</td>
			<td nowrap><select name="Mcodigo">
			  <cfloop query="rsMonedas">
				<option value="#Mcodigo#"<cfif modo EQ 'CAMBIO' and rsMonedas.Mcodigo EQ rsData.Mcodigo> selected</cfif>>#Miso4217# - #Mnombre#</option>
			  </cfloop>
			</select></td>
			<td align="right" nowrap class="fileLabel">Cantidad:</td>
			<td nowrap><input name="HIBcant" type="text" id="HIBcant" size="20" maxlength="18" onFocus="this.value=qf(this); this.select();" onBlur="javascript: fm(this,0);" onKeyUp="if(snumber(this,event,0)){ if(Key(event)=='13') {this.blur();}}" style="text-align: right;" value="<cfif modo EQ 'CAMBIO'>#LSNumberFormat(rsData.HIBcant, ',9')#<cfelse>0</cfif>"></td>
			<td align="right" nowrap class="fileLabel">Monto:</td>
			<td nowrap>
			<input name="HIBmonto" type="text" id="HIBmonto" size="20" maxlength="18" onFocus="this.value=qf(this); this.select();" onBlur="javascript: fm(this,2);" onKeyUp="if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}" style="text-align: right;" value="<cfif modo EQ 'CAMBIO'>#LSNumberFormat(rsData.HIBmonto, ',9.00')#<cfelse>0.00</cfif>">
			</td>
			<td align="right" nowrap class="fileLabel">Porcentaje Empleado: </td>
			<td nowrap>
			<input name="HIBporcemp" type="text" id="HIBporcemp" size="10" maxlength="6" onFocus="this.value=qf(this); this.select();" onBlur="javascript: fm(this,2);" onKeyUp="if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}" style="text-align: right;" value="<cfif modo EQ 'CAMBIO'>#LSNumberFormat(rsData.HIBporcemp, ',9.00')#<cfelse>0.00</cfif>">
			</td>
		  </tr>
		  <tr>
			<td align="right" nowrap class="fileLabel">Socio:</td>
			<td colspan="3" nowrap>
				<cfif modo EQ "CAMBIO">
					<cf_sifsociosnegocios2 form="form1" idquery="#rsData.SNcodigo#">
				<cfelse>
					<cf_sifsociosnegocios2 form="form1">
				</cfif>
			</td>
			<td align="right" nowrap class="fileLabel">Fecha Incidencia:</td>
			<td colspan="3" nowrap>
				<cfif modo EQ "CAMBIO">
					<cfset fechainc = LSDateFormat(rsData.HIBfecha, 'dd/mm/yyyy')>
				<cfelse>
					<cfset fechainc = LSDateFormat(Now(), 'dd/mm/yyyy')>
				</cfif>
				<cf_sifcalendario form="form1" name="HIBfecha" value="#fechainc#">
			</td>
		  </tr>
		  <tr>
		    <td colspan="8" align="center" nowrap>
				<cfif modo EQ "ALTA">
					<input type="submit" name="Alta" value="Agregar">
				<cfelse>
					<input type="submit" name="Cambio" value="Modificar" onClick="javascript: if (window.habilitarValidacion) habilitarValidacion();">
					<input type="submit" name="Baja" value="Eliminar" onclick="javascript: if ( confirm('¿Está seguro(a) de que desea eliminar el registro?') ){ if (window.inhabilitarValidacion) inhabilitarValidacion(); return true; }else{ return false;}">
					<input type="submit" name="Nuevo" value="Nuevo" onClick="javascript: if (window.inhabilitarValidacion) inhabilitarValidacion(); ">
				</cfif>
			</td>
	      </tr>
		  <tr>
		    <td colspan="8" align="center" nowrap>&nbsp;</td>
	      </tr>
	  </table>
	</form>
</cfoutput>

<cfquery name="rsLista" datasource="#Session.DSN#">
	select a.HIBlinea, a.BElinea, a.Mcodigo, a.HIBfecha, a.HIBmonto, a.HIBcant, a.HIBporcemp, a.SNcodigo, a.fechaalta, a.BMUsucodigo,
		   b.DEid, b.Bid, b.BEfdesde, b.BEfhasta, b.BEactivo, b.fechainactiva, b.fechaalta, 
		   c.Bcodigo, c.Bdescripcion, 
		   d.NTIcodigo, d.DEidentificacion, rtrim(d.DEapellido1 + ' ' + d.DEapellido2) + ', ' + d.DEnombre as NombreEmp, e.NTIdescripcion,
		   f.Miso4217, f.Mnombre
	from HIBeneficios a, RHBeneficiosEmpleado b, RHBeneficios c, DatosEmpleado d, NTipoIdentificacion e, Monedas f
	where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
	and a.BElinea = b.BElinea
	and b.Bid = c.Bid
	and b.DEid = d.DEid
	and d.NTIcodigo = e.NTIcodigo
	and a.Ecodigo = f.Ecodigo
	and a.Mcodigo = f.Mcodigo
	order by d.DEidentificacion, b.BEfdesde desc, c.Bcodigo
</cfquery>

<cfinvoke component="rh.Componentes.pListas" method="pListaQuery"
 returnvariable="LvarResult">
	<cfinvokeargument name="query" value="#rsLista#"/>
	<cfinvokeargument name="desplegar" value="DEidentificacion, NombreEmp, Bcodigo, Bdescripcion, HIBfecha, HIBcant, HIBmonto, Mnombre, HIBporcemp"/>
	<cfinvokeargument name="etiquetas" value="Identificaci&oacute;n, Empleado, C&oacute;digo, Beneficio, Fecha Incidencia, Cantidad, Monto, Moneda, Porcentaje Empleado"/>
	<cfinvokeargument name="formatos" value="S, S, S, S, D, I, M, S, M"/>
	<cfinvokeargument name="align" value="left, left, left, left, center, right, right, left, right"/>
	<cfinvokeargument name="ajustar" value="N"/>
	<cfinvokeargument name="checkboxes" value="N"/>
	<cfinvokeargument name="irA" value="#GetFileFromPath(GetTemplatePath())#"/>
	<cfinvokeargument name="keys" value="HIBlinea"/>
	<cfinvokeargument name="maxRows" value="0"/>
	<cfinvokeargument name="PageIndex" value="2"/>
  </cfinvoke> 

<script language="javascript" type="text/javascript">
	function valida(f) {
		f.obj.HIBcant.value = qf(f.obj.HIBcant.value);
		f.obj.HIBmonto.value = qf(f.obj.HIBmonto.value);
		f.obj.HIBporcemp.value = qf(f.obj.HIBporcemp.value);
	}

	// Valida que sea un porcentaje válido
	function __isPorcentaje() {
		if (this.required && (new Number(qf(this.value)) > 100.00)) {
			this.error = "El campo " + this.description + " no puede ser mayor a 100!";
		}
	}

	function habilitarValidacion() {
		<cfif modo EQ "ALTA">
		objForm.DEidentificacion.required = true;
		objForm.Bcodigo.required = true;
		</cfif>
		objForm.HIBfecha.required = true;
		objForm.HIBcant.required = true;
		objForm.HIBmonto.required = true;
		objForm.HIBporcemp.required = true;
		objForm.Mcodigo.required = true;
	}

	function inhabilitarValidacion() {
		<cfif modo EQ "ALTA">
		objForm.DEidentificacion.required = false;
		objForm.Bcodigo.required = false;
		</cfif>
		objForm.HIBfecha.required = false;
		objForm.HIBcant.required = false;
		objForm.HIBmonto.required = false;
		objForm.HIBporcemp.required = false;
		objForm.Mcodigo.required = false;
	}

	qFormAPI.errorColor = "#FFFFCC";
	objForm = new qForm("form1");
	_addValidator("isPorcentaje", __isPorcentaje);

	<cfif modo EQ "ALTA">
	objForm.DEidentificacion.required = true;
	objForm.DEidentificacion.description = "Empleado";
	objForm.Bcodigo.required = true;
	objForm.Bcodigo.description = "Beneficio";
	</cfif>
	objForm.HIBfecha.required = true;
	objForm.HIBfecha.description = "Fecha Incidencia";
	objForm.HIBcant.required = true;
	objForm.HIBcant.description = "Cantidad";
	objForm.HIBmonto.required = true;
	objForm.HIBmonto.description = "Monto";
	objForm.HIBporcemp.required = true;
	objForm.HIBporcemp.description = "Porcentaje Empleado";
	objForm.HIBporcemp.validatePorcentaje();
	objForm.Mcodigo.required = true;
	objForm.Mcodigo.description = "Moneda";

</script>