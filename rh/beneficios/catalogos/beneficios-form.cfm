<cfif isdefined("Form.Bid") and Len(Trim(Form.Bid))>
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

<cfquery name="rsLista" datasource="#Session.DSN#">
	select Bid, Mcodigo, Ecodigo, Bcodigo, Bdescripcion, Bmontostd, Bporcemp, Btercero, SNcodigo, Brequierereg, Bperiodicidad, Bobs, BMUsucodigo, fechaalta
	from RHBeneficios
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
</cfquery>

<cfif modo EQ "CAMBIO">
	<cfquery name="rsData" datasource="#Session.DSN#">
		select a.Mcodigo, a.Bcodigo, a.Bdescripcion, a.Bmontostd, a.Bporcemp, a.Btercero, 
			   a.SNcodigo, a.Brequierereg, a.Bperiodicidad, a.Bobs, a.BMUsucodigo, a.fechaalta, a.ts_rversion
		from RHBeneficios a
		where a.Bid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Bid#">
		and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
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
	<table width="100%"  border="0" cellspacing="0" cellpadding="2">
	  <tr>
		<td valign="top" align="center" width="50%">
			<cfinvoke component="rh.Componentes.pListas" method="pListaQuery"
			 returnvariable="LvarResult">
				<cfinvokeargument name="query" value="#rsLista#"/>
				<cfinvokeargument name="desplegar" value="Bcodigo, Bdescripcion"/>
				<cfinvokeargument name="etiquetas" value="C&oacute;digo, Descripción"/>
				<cfinvokeargument name="formatos" value=""/>
				<cfinvokeargument name="align" value="left,left"/>
				<cfinvokeargument name="ajustar" value="N"/>
				<cfinvokeargument name="checkboxes" value="N"/>
				<cfinvokeargument name="irA" value="#GetFileFromPath(GetTemplatePath())#"/>
				<cfinvokeargument name="keys" value="Bid"/>
				<cfinvokeargument name="maxRows" value="15"/>
			  </cfinvoke> 
		</td>
		<td valign="top" style="padding-left: 10px; " align="center" width="50%">
			<form name="form1" method="post" action="beneficios-sql.cfm" style="margin:0; " onSubmit="javascript: valida(this);">
				<cfif isdefined("Form.PageNum")>
					<input type="hidden" name="PageNum" value="#Form.PageNum#">
				</cfif>
				<cfif modo EQ "CAMBIO">
					<input type="hidden" name="Bid" value="#Form.Bid#">
					<cfset ts = "">
					<cfinvoke 
						component="sif.Componentes.DButils"
						method="toTimeStamp"
						returnvariable="ts">
						<cfinvokeargument name="arTimeStamp" value="#rsData.ts_rversion#"/>
					</cfinvoke>
					<input type="hidden" name="ts_rversion" value="#ts#">
				</cfif>
				<table width="100%" border="0" cellspacing="0" cellpadding="2">
				  <tr>
					<td width="25%" align="right" nowrap class="fileLabel">C&oacute;digo:</td>
					<td>
						<input name="Bcodigo" type="text" size="10" maxlength="4" alt="El Código" value="<cfif modo EQ 'CAMBIO'>#rsData.Bcodigo#</cfif>">
					</td>
				  </tr>
				  <tr>
					<td width="25%" align="right" nowrap class="fileLabel">Descripci&oacute;n:</td>
					<td><input name="Bdescripcion" type="text" id="Bdescripcion" size="40" maxlength="80" value="<cfif modo EQ 'CAMBIO'>#rsData.Bdescripcion#</cfif>"></td>
				  </tr>
				  <tr>
				    <td align="right" nowrap class="fileLabel">Monto Est&aacute;ndar:</td>
				    <td><input name="Bmontostd" type="text" id="Bmontostd" size="20" maxlength="18" onFocus="this.value=qf(this); this.select();" onBlur="javascript: fm(this,2);" onKeyUp="if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}" style="text-align: right;" value="<cfif modo EQ 'CAMBIO'>#LSNumberFormat(rsData.Bmontostd, ',9.00')#<cfelse>0.00</cfif>"></td>
			      </tr>
				  <tr>
				    <td align="right" nowrap class="fileLabel">Porcentaje Empleado: </td>
				    <td><input name="Bporcemp" type="text" id="Bporcemp" size="20" maxlength="6" onFocus="this.value=qf(this); this.select();" onBlur="javascript: fm(this,2);" onKeyUp="if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}" style="text-align: right;" value="<cfif modo EQ 'CAMBIO'>#LSNumberFormat(rsData.Bporcemp, ',9.00')#<cfelse>0.00</cfif>"></td>
			      </tr>
				  <tr>
				    <td align="right" nowrap class="fileLabel">Moneda:</td>
				    <td>
						<select name="Mcodigo">
						<cfloop query="rsMonedas">
							<option value="#Mcodigo#"<cfif modo EQ 'CAMBIO' and rsMonedas.Mcodigo EQ rsData.Mcodigo> selected</cfif>>#Miso4217# - #Mnombre#</option>
						</cfloop>
						</select>
					</td>
			      </tr>
				  <tr>
				    <td align="right" nowrap class="fileLabel">Periodicidad:</td>
				    <td>
					  <select name="Bperiodicidad" id="Bperiodicidad">
					    <option value="10"<cfif modo EQ 'CAMBIO' and rsData.Bperiodicidad EQ 10> selected</cfif>>Mensual</option>
					    <option value="20"<cfif modo EQ 'CAMBIO' and rsData.Bperiodicidad EQ 20> selected</cfif>>Semestral</option>
					    <option value="30"<cfif modo EQ 'CAMBIO' and rsData.Bperiodicidad EQ 30> selected</cfif>>Anual</option>
					  </select>
					</td>
			      </tr>
				  <tr>
				    <td align="right" valign="top" nowrap class="fileLabel">Observaciones:</td>
				    <td><textarea name="Bobs" rows="5" id="Bobs" style="width: 100%"><cfif modo EQ 'CAMBIO'>#rsData.Bobs#</cfif></textarea></td>
			      </tr>
				  <tr>
				    <td align="right" nowrap class="fileLabel"><input name="Brequierereg" type="checkbox" id="Brequierereg" value="1"<cfif modo EQ 'CAMBIO' and rsData.Brequierereg EQ 1> checked</cfif>></td>
				    <td>Requiere Registro de Monto</td>
			      </tr>
				  <tr>
                    <td align="right" nowrap class="fileLabel"><input name="Btercero" type="checkbox" id="Btercero" value="1"<cfif modo EQ 'CAMBIO' and rsData.Btercero EQ 1> checked</cfif> onClick="javascript: solicitarSocio(this);"></td>
                    <td>Beneficio de Tercero </td>
			      </tr>
				  <tr id="trsocio" style="display: none; ">
				    <td align="right" nowrap class="fileLabel">Socio de Negocio: </td>
				    <td>
						<cfif modo EQ 'CAMBIO'>
							<cf_sifsociosnegocios2 form="form1" idquery="#rsData.SNcodigo#">
						<cfelse>
							<cf_sifsociosnegocios2 form="form1">
						</cfif>
					</td>
			      </tr>
				  <tr>
				    <td align="right" nowrap class="fileLabel">&nbsp;</td>
				    <td>&nbsp;</td>
			      </tr>
				  <tr>
				    <td colspan="2" align="center" nowrap>
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
				    <td align="right" nowrap class="fileLabel">&nbsp;</td>
				    <td>&nbsp;</td>
			      </tr>
			  </table>
			</form>
		</td>
	  </tr>
	</table>
</cfoutput>

<script language="javascript" type="text/javascript">
	function valida(f) {
		f.obj.Bmontostd.value = qf(f.obj.Bmontostd.value);
		f.obj.Bporcemp.value = qf(f.obj.Bporcemp.value);
	}

	// Valida que sea un porcentaje válido
	function __isPorcentaje() {
		if (this.required && (new Number(qf(this.value)) > 100.00)) {
			this.error = "El campo " + this.description + " no puede ser mayor a 100!";
		}
	}

	function habilitarValidacion() {
		objForm.Bcodigo.required = true;
		objForm.Bdescripcion.required = true;
		objForm.Bmontostd.required = true;
		objForm.Bporcemp.required = true;
		objForm.Mcodigo.required = true;
		objForm.Bperiodicidad.required = true;
		objForm.SNcodigo.required = objForm.obj.Btercero.checked;
		solicitarSocio(objForm.obj.Btercero);
	}

	function inhabilitarValidacion() {
		objForm.Bcodigo.required = false;
		objForm.Bdescripcion.required = false;
		objForm.Bmontostd.required = false;
		objForm.Bporcemp.required = false;
		objForm.Mcodigo.required = false;
		objForm.Bperiodicidad.required = false;
		objForm.SNcodigo.required = false;
		solicitarSocio(objForm.obj.Btercero);
	}
	
	function solicitarSocio(ctl) {
		var a = document.getElementById("trsocio");
		if (a != null) {
			if (ctl.checked) {
				a.style.display = "";
			} else {
				a.style.display = "none";
			}
		}
		objForm.SNcodigo.required = ctl.checked;
	}

	qFormAPI.errorColor = "#FFFFCC";
	objForm = new qForm("form1");
	_addValidator("isPorcentaje", __isPorcentaje);
	
	objForm.Bcodigo.required = true;
	objForm.Bcodigo.description = "Código";
	objForm.Bdescripcion.required = true;
	objForm.Bdescripcion.description = "Descripción";
	objForm.Bmontostd.required = true;
	objForm.Bmontostd.description = "Monto Estándar";
	objForm.Bporcemp.required = true;
	objForm.Bporcemp.description = "Porcentaje Empleado";
	objForm.Bporcemp.validatePorcentaje();
	objForm.Mcodigo.required = true;
	objForm.Mcodigo.description = "Moneda";
	objForm.Bperiodicidad.required = true;
	objForm.Bperiodicidad.description = "Periodicidad";
	objForm.SNcodigo.required = objForm.obj.Btercero.checked;
	objForm.SNcodigo.description = "Socio de Negocio";
	solicitarSocio(objForm.obj.Btercero);
	
</script>
