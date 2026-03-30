<!--- Consulta del Modo Cambio --->
<!--- Almacenes --->
<cfquery name="rsAlmacenes" datasource="#Session.dsn#">
	select Aid, Bdescripcion
	from Almacen 
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
</cfquery>

<!--- Categorias --->
<cfquery name="rsCategorias" datasource="#Session.dsn#">
	select ACcodigo, ACdescripcion, ACmascara
	from ACategoria 
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
</cfquery>

<!--- Clases 
se llenan automáticamente cuando cambia la categoria.
--->
<cfquery name="rsClases" datasource="#Session.dsn#">
	select a.ACcodigo, a.ACid, a.ACdescripcion, a.ACdepreciable, a.ACrevalua
	from AClasificacion a
	where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
</cfquery>

<!---Descripcion de la moneda--->
<cffunction name="getDescMoneda" access="private" returntype="string">
	<cfargument name="Mcodigo" required="yes">
	<cfquery name="rs" datasource="#session.dsn#">
		select Mnombre from Monedas where Mcodigo = #Arguments.Mcodigo#
	</cfquery>
	<cfreturn rs.Mnombre>
</cffunction>

<!--- Consultas del modocambio --->
<cfif modocambio>
 	<cfif (isdefined('rsVale')) 
			and (rsVale.recordCount) 
			and (len(trim(rsVale.AFMid))) 
			and (len(trim(rsVale.AFMMid)))>
		<cfquery name="rsMarcaMod" datasource="#Session.dsn#">
			Select ma.AFMid
				, AFMMid
				, AFMcodigo
				, AFMdescripcion
				, AFMMcodigo
				, AFMMdescripcion
			from AFMarcas ma,
				AFMModelos mo
			where ma.Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
				and ma.AFMid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsVale.AFMid#">
				and mo.AFMMid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsVale.AFMMid#">
				and ma.Ecodigo=mo.Ecodigo
				and ma.AFMid=mo.AFMid
		</cfquery>	
	</cfif>
</cfif>

<!--- Javascript --->
<script language="javascript" src="/cfmx/sif/js/utilesMonto.js"></script>
<script language="JavaScript" src="/cfmx/sif/js/qForms/qforms.js"></script>

<!--- form --->
<cfoutput><form action="vales_adquisicion_sql.cfm" method="post" name="form1">

<!--- Tabla 1 --->
<table width="100%"  border="0" cellspacing="0" cellpadding="0">
	<tr><td colspan="3">&nbsp;</td></tr>
	<tr>
		<td rowspan="100" width="5%">&nbsp;</td>
		<td class="subTitulo" nowrap width="80%">
			Adquisici&oacute;n de Activos
		</td>
		<td rowspan="100" width="5%">&nbsp;</td>
	</tr>
	<tr><td>&nbsp;</td></tr>
	<tr><!--- Datos Generales del Activo --->
		<td width="80%">
			<!---I--->
			<table width="100%"  border="0" cellspacing="0" cellpadding="0">
				<tr>
					<td nowrap><strong>Descripci&oacute;n&nbsp;:&nbsp;</strong></td>
					<td>
						<input type="text" name="AFAdescripcion" size="47" maxlength="100" <cfif modocambio>value="#rsVale.AFAdescripcion#"</cfif>>
					</td>
				</tr>
				<tr>
					<td nowrap><strong>Marca&nbsp;:&nbsp;</strong></td>
					<td rowspan="2">
						<cfif modocambio
								and (isdefined('rsMarcaMod'))
								and (rsMarcaMod.recordCount)>
							<cf_sifmarcamod	query="#rsMarcaMod#">
						<cfelse>
							<cf_sifmarcamod>
						</cfif>
					</td>
				</tr>
				<tr>
					<td nowrap><strong>Modelo&nbsp;:&nbsp;</strong></td>
					<!--- Definido por tag de marca / modelo <td>&nbsp;</td> --->
				</tr>
				<tr>
					<td nowrap><strong>Catagor&iacute;a&nbsp;:&nbsp;</strong></td>
					<td>
						<select name="ACcodigo" onChange="javascript:AgregarCombo(this);">
							<cfloop query="rsCategorias">
								<option value="#rsCategorias.ACcodigo#" <cfif modocambio and (ACcodigo eq rsVale.ACcodigo)>selected</cfif>>#rsCategorias.ACdescripcion#</option>
							</cfloop>
						</select>				
					</td>
				</tr>
				<tr>
					<td nowrap><strong>Clase&nbsp;:&nbsp;</strong></td>
					<td>
						<select name="ACid"><!--- Las opciones se defininen dinámicamente cuando cambia la categoría ---></select>
					</td>
				</tr>
				<tr>
					<td nowrap><strong>Serie&nbsp;:&nbsp;</strong></td>
					<td>
						<input type="text" name="AFAserie" size="47" maxlength="50" <cfif modocambio>value="#rsVale.AFAserie#"</cfif>>
					</td>
				</tr>
				<tr>
					<td nowrap><strong>Inicio Depreciaci&oacute;n&nbsp;:&nbsp;</strong></td>
					<td>
						<cfif modocambio>
							<cf_sifcalendario name="AFAfechainidep" value="#LSDateformat(rsVale.AFAfechainidep,'dd/mm/yyyy')#">
						<cfelse>
							<cf_sifcalendario name="AFAfechainidep" value="#LSDateformat(Now(),'dd/mm/yyyy')#">
						</cfif>
					</td>
				</tr>
				<tr>
					<td nowrap><strong>Inicio Revaluaci&oacute;n&nbsp;:&nbsp;</strong></td>
					<td>
						<cfif modocambio>
							<cf_sifcalendario name="AFAfechainirev" value="#LSDateformat(rsVale.AFAfechainirev,'dd/mm/yyyy')#">
						<cfelse>
							<cf_sifcalendario name="AFAfechainirev" value="#LSDateformat(Now(),'dd/mm/yyyy')#">
						</cfif>
					</td>
				</tr>
				<tr>
					<td nowrap><strong>Monto&nbsp;:&nbsp;</strong></td>
					<td>
						<input type="text" name="AFAmonto"
								<cfif modocambio>value="#lscurrencyformat(rsVale.AFAmonto,'none')#"<cfelse>value="0.00"</cfif>
								size="30" maxlength="22" style="text-align:right "
								onBlur	=	"javascript:	if(validaNumero(this,2))	{formatCurrency(this,2);}"
								onFocus	=	"javascript:	this.select();"
								onKeyUp	=	"javascript:	if(snumber(this,event,2))	{if(Key(event)=='13') {this.blur();}};">
					</td>
				</tr>
				<!---Línea en Blanco<tr><td colspan="2">&nbsp;</td></tr>
				<tr>
					<td nowrap><strong>Centro Funcional&nbsp;:&nbsp;</strong></td>
					<td>
						<cfif modocambio
								and (isdefined('rsVale'))
								and (rsVale.recordCount)
								and (len(trim(rsVale.CFid)))>
							<cfquery name="rsCFuncional" datasource="#Session.dsn#">
								select  CFid, CFcodigo, CFdescripcion
								from CFuncional
								where CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsVale.CFid#">
							</cfquery>
							<cf_rhcfuncional form="form1" id="CFid" name="CFcodigo" desc="CFdescripcion" query="#rsCFuncional#"><!--- of="#rsActivosAdq.Ocodigo#" --->
						<cfelse>
							<cf_rhcfuncional form="form1" id="CFid" name="CFcodigo" desc="CFdescripcion" ><!--- of="#rsActivosAdq.Ocodigo#" --->
						</cfif>
					</td>
				</tr>
				--->
				<!---Línea en Blanco---><tr><td colspan="2">&nbsp;</td></tr>
				<tr>
					<td colspan="2">
						<!--- Datos de la Factura SI LOS HAY --->
						<fieldset><legend>Datos de la Factura</legend>
							<table width="100%"  border="0" cellspacing="0" cellpadding="0" class="Ayuda">
								<tr>
									<td><strong>Documento&nbsp;:&nbsp;</strong></td>
									<td>
										<input type="text" name="AFAdocumento" size="30" maxlength="25" <cfif modocambio>value="#rsVale.AFAdocumento#"</cfif>>
									</td>
								</tr>
								<tr>
									<td><strong>Socio&nbsp;:&nbsp;</strong></td>
									<td>
										<cfif modocambio>
											<cf_sifsociosnegocios2 sntiposocio="P" idquery="#rsVale.SNcodigo#">
										<cfelse>
											<cf_sifsociosnegocios2 sntiposocio="P">
										</cfif>
									</td>
								</tr>
							</table>
						</fieldset>
					</td>
				</tr>
				<!---Línea en Blanco---><tr><td colspan="2">&nbsp;</td></tr>
				<tr>
					<td colspan="2" align="center"> 
						<cfset vinclude = "">
						<cfif modocambio>
						<cfset vinclude = "Terminar">
						</cfif>
						<cf_botones modocambio="#modocambio#" include="#vinclude#">  
					</td>
				</tr>
				<!---Línea en Blanco---><tr><td colspan="2">&nbsp;</td></tr>
			</table>
			<!---F--->
		</td>
	</tr>

<!---Campos Ocultos--->
<input type="hidden" name="DEid" value="#form.DEid#"> 
<cfif modocambio>
	<input type="hidden" name="AFAid" value="#rsVale.AFAid#"> 
	<input type="hidden" name="ts_rversion" value="#rsVale_ts#"> 
</cfif>
	
<!--- Fin de la Tabla 1 --->
</table></cfoutput>

<!--- Fin del Form1--->
</form>

<!--- Validaciones Qforms --->
<script language="JavaScript">
	<!--//
	
	// specify the path where the "/qforms/" subfolder is located
	qFormAPI.setLibraryPath("/cfmx/sif/js/qForms/");
	// loads all default libraries
	qFormAPI.include("validation");
	qFormAPI.include("functions", null, "12");
	//crea el objeto qforms
	qFormAPI.errorColor = "#FFFFCC";
	objform = new qForm("form1");
	
	// Funciones de ayuda a funcionamiento del form	
	function AgregarCombo(codigo) {
		var combo = document.form1.ACid;
		var cont = 0;
		codigo = codigo.value;
		combo.length=0;
		<cfoutput query="rsClases">
			if (#Trim(rsClases.ACcodigo)#==trim(codigo)) 
			{
				combo.length=cont+1;
				combo.options[cont].value='#rsClases.ACid#';
				combo.options[cont].text='#rsClases.ACdescripcion#';
				<cfif modocambio and #rsClases.ACid# EQ #rsVale.ACid#>
					combo.options[cont].selected=true;
				</cfif>
				cont++;
			};
		</cfoutput>
	}

	function MaskTest(obj,v, m, e){
		var oMask = new Mask(m, "string");
		if (v.length > 0) {
			var n = oMask.format(v);
			if (oMask.error.length != 0) {
				alert(oMask.error);
				obj.value="";
				return false;
			}
		}
		return true;
	}
	
	//Descripciones
	objform.AFAdescripcion.description = "<cfoutput>#JSStringFormat('Descripción')#</cfoutput>";
	objform.AFMid.description = "<cfoutput>#JSStringFormat('Marca')#</cfoutput>";
	objform.AFMMid.description = "<cfoutput>#JSStringFormat('Modelo')#</cfoutput>";
	objform.AFAserie.description = "<cfoutput>#JSStringFormat('Serie')#</cfoutput>";
	objform.AFAmonto.description = "<cfoutput>#JSStringFormat('Monto')#</cfoutput>";
	objform.ACcodigo.description = "<cfoutput>#JSStringFormat('Categoria')#</cfoutput>";
	objform.ACid.description = "<cfoutput>#JSStringFormat('Clase')#</cfoutput>";
	objform.AFAfechainidep.description = "<cfoutput>#JSStringFormat('Fecha de inicio de la depreciación.')#</cfoutput>";
	objform.AFAfechainirev.description = "<cfoutput>#JSStringFormat('Fecha de inicio de la revaluación.')#</cfoutput>";

	//habilita inhabilita validaciones
	function deshabilitarValidacion(){
		objform.AFAdescripcion.required = false;
		objform.AFMid.required = false;
		objform.AFMMid.required = false;
		objform.AFAserie.required = false;
		objform.AFAmonto.required = false;
		objform.ACcodigo.required = false;
		objform.ACid.required = false;
		objform.AFAfechainidep.required = false;
		objform.AFAfechainirev.required = false;
		objform.allowsubmitonerror = true;
	}

	function habilitarValidacion(){
		objform.AFAdescripcion.required = true;
		objform.AFMid.required = true;
		objform.AFMMid.required = true;
		objform.AFAserie.required = true;
		objform.AFAmonto.required = true;
		objform.ACcodigo.required = true;
		objform.ACid.required = true;
		objform.AFAfechainidep.required = true;
		objform.AFAfechainirev.required = true;
		objform.allowsubmitonerror = false;
	}
	
	//campos requeridos
	habilitarValidacion();

	//validaciones adicionales
	function _customValidations(){
		//definir aquí las validaciones especiales antes del submit
		if ((objform._queue.errors).length <= 0) {
			//no hubo errores
			objform.AFAmonto.obj.value = qf(objform.AFAmonto.obj.value);
		}
	}

	function funcTerminar(){
		if (confirm('¿Confirma que desea terminar el registro de este vale?')){
			return true;
		}
		return false;
	}

	objform.onValidate = _customValidations;

	AgregarCombo(document.form1.ACcodigo);
	
	//-->
</script>