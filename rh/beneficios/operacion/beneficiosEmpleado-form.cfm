<cfif isdefined("Form.BElinea") and Len(Trim(Form.BElinea))>
	<cfset modo = "CAMBIO">
<cfelse>
	<cfset modo = "ALTA">
</cfif>

<cfquery name="rsEmpleado" datasource="#Session.DSN#">
	select b.NTIcodigo, b.NTIdescripcion, 
		   a.*,
		   rtrim(a.DEnombre + ' ' + a.DEapellido1 + ' ' + a.DEapellido2) as NombreCompleto
	from DatosEmpleado a, NTipoIdentificacion b
	where a.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.DEid#">
	and a.NTIcodigo = b.NTIcodigo
</cfquery>

<cfquery name="rsLista" datasource="#Session.DSN#">
	select a.BElinea, a.DEid, a.Bid, a.Mcodigo, a.BEfdesde, a.BEfhasta, a.BEmonto, 
		   a.BEporcemp, a.SNcodigo, a.BEactivo, a.fechainactiva, a.fechaalta, a.BMUsucodigo,
		   rtrim(b.Bcodigo) as Bcodigo, b.Bdescripcion,
		   case when a.BEactivo = 0 then '<img src=''/cfmx/rh/imagenes/unchecked.gif''>' else '<img src=''/cfmx/rh/imagenes/checked.gif''>' end  as activo
	from RHBeneficiosEmpleado a, RHBeneficios b
	where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
	and a.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.DEid#">
	and a.Bid = b.Bid
	order by a.BEfdesde desc, a.Ecodigo
</cfquery>

<!--- Monedas --->
<cfquery name="rsMonedas" datasource="#Session.DSN#">
	select Mcodigo, Mnombre, Msimbolo, Miso4217
	from Monedas
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
	order by Mcodigo
</cfquery>

<cfif modo EQ "CAMBIO">
	<cfquery name="rsData" datasource="#Session.DSN#">
		select a.BElinea, a.DEid, a.Bid, a.Mcodigo, a.BEfdesde, a.BEfhasta, a.BEmonto, 
		   	   a.BEporcemp, a.SNcodigo, a.BEactivo, a.fechainactiva, a.fechaalta, a.BMUsucodigo, a.ts_rversion,
			   b.Bcodigo, b.Bdescripcion
		from RHBeneficiosEmpleado a, RHBeneficios b
		where a.BElinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.BElinea#">
		and a.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.DEid#">
		and a.Bid = b.Bid
	</cfquery>
</cfif>

<cfset navegacion = "">
<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "DEid=" & Form.DEid>

<script src="/cfmx/rh/js/utilesMonto.js"></script>
<script src="/cfmx/sif/js/qForms/qforms.js"></script>
<script language="javascript" type="text/javascript">
	// specify the path where the "/qforms/" subfolder is located
	qFormAPI.setLibraryPath("/cfmx/sif/js/qForms/");
	// loads all default libraries
	qFormAPI.include("*");

</script>

<cfoutput>
	<table width="100%"  border="0" cellspacing="0" cellpadding="0">
	  <tr>
	  	<!--- Lista de Beneficios por Empleado --->
		<td width="55%" valign="top">
			<table width="98%"  border="0" cellspacing="0" cellpadding="2" align="center">
			  <tr>
				<td class="#Session.preferences.Skin#_thcenter" align="center">Lista de Beneficios para #rsEmpleado.NombreCompleto#</td>
			  </tr>
			  <tr>
				<td>
					<cfinvoke component="rh.Componentes.pListas" method="pListaQuery"
					 returnvariable="LvarResult">
						<cfinvokeargument name="query" value="#rsLista#"/>
						<cfinvokeargument name="desplegar" value="Bcodigo, Bdescripcion, BEfdesde, BEfhasta, activo"/>
						<cfinvokeargument name="etiquetas" value="C&oacute;digo, Descripción, Desde, Hasta, Activo"/>
						<cfinvokeargument name="formatos" value="S, S, D, D, S"/>
						<cfinvokeargument name="align" value="left, left, center, center, center"/>
						<cfinvokeargument name="ajustar" value="N"/>
						<cfinvokeargument name="checkboxes" value="N"/>
						<cfinvokeargument name="irA" value="#GetFileFromPath(GetTemplatePath())#"/>
						<cfinvokeargument name="keys" value="BElinea"/>
						<cfinvokeargument name="maxRows" value="15"/>
						<cfinvokeargument name="navegacion" value="#navegacion#"/>
						<cfinvokeargument name="PageIndex" value="2"/>
					  </cfinvoke> 
				</td>
			  </tr>
			</table>
		</td>
		
		<!--- Formulario --->
		<td width="45%" valign="top">
			<cf_web_portlet_start skin="#Session.Preferences.Skin#" titulo="Asociar Nuevo Beneficio a Empleado">
				<form name="form1" method="post" action="beneficiosEmpleado-sql.cfm" style="margin: 0; " onSubmit="javascript: valida(this);">
					<input type="hidden" name="Btercero" value="0">
					<input type="hidden" name="DEid" value="#Form.DEid#">
					<cfif isdefined("Form.PageNum2")>
						<input type="hidden" name="PageNum2" value="#Form.PageNum2#">
					</cfif>
					<cfif modo EQ "CAMBIO">
						<input type="hidden" name="BElinea" value="#Form.BElinea#">
						<cfset ts = "">
						<cfinvoke 
							component="sif.Componentes.DButils"
							method="toTimeStamp"
							returnvariable="ts">
							<cfinvokeargument name="arTimeStamp" value="#rsData.ts_rversion#"/>
						</cfinvoke>
						<input type="hidden" name="ts_rversion" value="#ts#">
					</cfif>
					<table width="100%" border="0" cellpadding="2" cellspacing="0">
					  <tr>
						<td colspan="2"><cfinclude template="frame-infoEmpleado.cfm"></td>
					  </tr>
					  <tr>
						<td width="25%" align="right" nowrap class="fileLabel">Beneficio:</td>
						<td nowrap>
							<cfif modo EQ "CAMBIO">
								#rsData.Bcodigo# - #rsData.Bdescripcion#
							<cfelse>
								<cf_rhbeneficio form="form1">
							</cfif>
						</td>
					  </tr>
					  <tr>
						<td align="right" nowrap class="fileLabel">Fecha Desde: </td>
						<td>
							<cfif modo EQ "CAMBIO">
								<cfset fdesde = LSDateFormat(rsData.BEfdesde, 'dd/mm/yyyy')>
							<cfelse>
								<cfset fdesde = LSDateFormat(Now(), 'dd/mm/yyyy')>
							</cfif>
							<cf_sifcalendario form="form1" name="BEfdesde" value="#fdesde#">
						</td>
					  </tr>
					  <tr>
						<td align="right" nowrap class="fileLabel">Fecha Hasta: </td>
						<td>
							<cfset fhasta = "">
							<cfif modo EQ "CAMBIO" and Len(Trim(rsData.BEfhasta))>
								<cfset fhasta = LSDateFormat(rsData.BEfhasta, 'dd/mm/yyyy')>
							</cfif>
							<cf_sifcalendario form="form1" name="BEfhasta" value="#fhasta#">
						</td>
					  </tr>
					  <tr>
						<td align="right" nowrap class="fileLabel">Monto:</td>
						<td><input name="BEmonto" type="text" id="BEmonto" size="20" maxlength="18" onFocus="this.value=qf(this); this.select();" onBlur="javascript: fm(this,2);" onKeyUp="if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}" style="text-align: right;" value="<cfif modo EQ 'CAMBIO'>#LSNumberFormat(rsData.BEmonto, ',9.00')#<cfelse>0.00</cfif>"></td>
					  </tr>
					  <tr>
						<td align="right" nowrap class="fileLabel">Porcentaje Empleado: </td>
						<td><input name="BEporcemp" type="text" id="BEporcemp" size="20" maxlength="18" onFocus="this.value=qf(this); this.select();" onBlur="javascript: fm(this,2);" onKeyUp="if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}" style="text-align: right;" value="<cfif modo EQ 'CAMBIO'>#LSNumberFormat(rsData.BEporcemp, ',9.00')#<cfelse>0.00</cfif>"></td>
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
					  <tr id="trSocio">
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
						<td align="right" nowrap class="fileLabel"><input name="BEactivo" type="checkbox" id="BEactivo" value="1"<cfif modo EQ 'CAMBIO' and rsData.BEactivo EQ 0> checked</cfif> onClick="javascript: solicitarFechaInactivacion(this);"></td>
						<td>Inactivar</td>
					  </tr>
					  <cfif modo EQ "CAMBIO" and rsData.BEactivo EQ 0>
					  <tr>
					    <td align="right" nowrap class="fileLabel">&nbsp;</td>
					    <td>
							(Desmarque para volver a activar)
						</td>
				      </tr>
					  </cfif>
					  <tr id="tractivacion" style="display: none;">
						<td align="right" nowrap class="fileLabel">Fecha Inactivaci&oacute;n: </td>
						<td>
							<cfif modo EQ "CAMBIO" and Len(Trim(rsData.fechainactiva))>
								<cfset finactiva = LSDateFormat(rsData.fechainactiva, 'dd/mm/yyyy')>
							<cfelse>
								<cfset finactiva = LSDateFormat(Now(), 'dd/mm/yyyy')>
							</cfif>
							<cf_sifcalendario form="form1" name="fechainactiva" value="#finactiva#">
						</td>
					  </tr>
					  <tr>
						<td colspan="2">&nbsp;</td>
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
						<td colspan="2">&nbsp;</td>
					  </tr>
				  </table>
			  </form>
			<cf_web_portlet_end>
		</td>
	  </tr>
	</table>
</cfoutput>

<script language="javascript" type="text/javascript">
	function valida(f) {
		f.obj.BEmonto.value = qf(f.obj.BEmonto.value);
		f.obj.BEporcemp.value = qf(f.obj.BEporcemp.value);
	}

	// Valida que sea un porcentaje válido
	function __isPorcentaje() {
		if (this.required && (new Number(qf(this.value)) > 100.00)) {
			this.error = "El campo " + this.description + " no puede ser mayor a 100!";
		}
	}

	function solicitarFechaInactivacion(ctl) {
		var a = document.getElementById("tractivacion");
		if (a != null) {
			if (ctl.checked) {
				a.style.display = "";
			} else {
				a.style.display = "none";
			}
		}
		objForm.fechainactiva.required = ctl.checked;
	}

	function habilitarValidacion() {
		<cfif modo EQ "ALTA">
		objForm.Bcodigo.required = true;
		</cfif>
		objForm.BEfdesde.required = true;
		objForm.BEmonto.required = true;
		objForm.BEporcemp.required = true;
		objForm.Mcodigo.required = true;
		objForm.fechainactiva.required = objForm.obj.BEactivo.checked;
		solicitarFechaInactivacion(objForm.obj.BEactivo);
	}

	function inhabilitarValidacion() {
		<cfif modo EQ "ALTA">
		objForm.Bcodigo.required = false;
		</cfif>
		objForm.BEfdesde.required = false;
		objForm.BEmonto.required = false;
		objForm.BEporcemp.required = false;
		objForm.Mcodigo.required = false;
		objForm.fechainactiva.required = false;
		solicitarFechaInactivacion(objForm.obj.BEactivo);
	}

	qFormAPI.errorColor = "#FFFFCC";
	objForm = new qForm("form1");
	_addValidator("isPorcentaje", __isPorcentaje);

	<cfif modo EQ "ALTA">
	objForm.Bcodigo.required = true;
	objForm.Bcodigo.description = "Beneficio";
	</cfif>
	objForm.BEfdesde.required = true;
	objForm.BEfdesde.description = "Fecha Desde";
	objForm.BEmonto.required = true;
	objForm.BEmonto.description = "Monto";
	objForm.BEporcemp.required = true;
	objForm.BEporcemp.description = "Porcentaje Empleado";
	objForm.BEporcemp.validatePorcentaje();
	objForm.Mcodigo.required = true;
	objForm.Mcodigo.description = "Moneda";
	objForm.fechainactiva.required = objForm.obj.BEactivo.checked;
	objForm.fechainactiva.description = "Fecha Inactivación";
	solicitarFechaInactivacion(objForm.obj.BEactivo);

</script>
