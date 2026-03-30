<!--- Consultas para llenar los campos de la pantalla --->
<!--- Categorias --->
<cfquery name="rsCategorias" datasource="#Session.DSN#">
	select ACcodigo, ACcodigodesc, ACdescripcion, ACmascara
	from ACategoria 
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
</cfquery>

<!--- Clases --->
<!--- Se llenan automáticamente cuando cambia la categoria. --->
<cfquery name="rsClases" datasource="#Session.DSN#">
	select a.ACcodigo, a.ACid, a.ACcodigodesc, a.ACdescripcion, a.ACdepreciable, a.ACrevalua
	from AClasificacion a
	where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
</cfquery>

<!--- Oficinas --->
<cfquery name="rsOficinas" datasource="#Session.DSN#">
	select Ocodigo, Oficodigo, Odescripcion 
	from Oficinas
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
</cfquery>

<cfif isdefined("form.CCFid") and len(trim(form.CCFid))>
	<cfquery name="rsForm" datasource="#session.dsn#">
		select 	a.CCFid, 
			a.Ecodigo, 
			a.Ocodigo, 
			a.ACcodigo,
			<cf_dbfunction name="to_char" args="b.ACcodigodesc"> as Categoria,
			b.ACdescripcion as Categoriadesc,  
			a.ACid,
			<cf_dbfunction name="to_char" args="c.ACcodigodesc"> as Clasificacion,
			c.ACdescripcion as Clasificaciondesc, 
			a.CFid, 
			a.CCFvutil, 
			a.CCFdepreciable, 
			a.CCFrevalua, 
			a.CCFtipo, 
			a.CCFvalorres, 
			a.BMUsucodigo, 
			a.ts_rversion
		from ClasificacionCFuncional a
			inner join ACategoria b
				on b.Ecodigo = a.Ecodigo 
				and b.ACcodigo = a.ACcodigo
			inner join AClasificacion c
				on c.Ecodigo = a.Ecodigo 
				and c.ACid = a.ACid
				and c.ACcodigo = a.ACcodigo		
		where a.CCFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CCFid#">
			and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	</cfquery>	
	<cfset modo = "CAMBIO">
<cfelse>
	<cfset modo = "ALTA">
</cfif>

<script language="JavaScript" type="text/javascript" src="/cfmx/sif/js/UtilesMonto.js"></script>

<!--- Pintado de la Pantalla --->
<cfoutput>
<fieldset>
<legend><strong>Clasificaci&oacute;n por Centro Funcional&nbsp;/Oficina</strong>&nbsp;</legend>
	<form action="ClasificacionCF-sql.cfm" method="post" name="form1" onSubmit="return _finalizar();">
		<table width="80%" align="center" border="0" >
			<tr>
				<td align="right"><strong>Categor&iacute;a:</strong></td>
				<td rowspan="2" nowrap colspan="2">
					<cfif isdefined("form.Padre_ACid") and isdefined("form.Padre_ACcodigo")>
						<cfquery name="rsCatClase" datasource="#session.dsn#">
							select 
							b.ACcodigo, 
							<cf_dbfunction name="to_char" args="b.ACcodigodesc"> as Categoria, 
							b.ACdescripcion as Categoriadesc, 
							c.ACid, 
							<cf_dbfunction name="to_char" args="c.ACcodigodesc"> as Clasificacion, 
							c.ACdescripcion as Clasificaciondesc
							from ACategoria b
								inner join AClasificacion c
								on c.Ecodigo = b.Ecodigo 
								and c.ACid = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.Padre_ACid#">
								and c.ACcodigo = b.ACcodigo
							where b.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ecodigo#">
							and b.ACcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.Padre_ACcodigo#">
						</cfquery>
						<cf_sifCatClase query="#rsCatClase#" Modificable="false" tabindex="-1">
					<cfelseif modo NEQ 'ALTA' >
						<cf_sifCatClase query="#rsForm#" tabindex="-1">
					<cfelse>
						<cf_sifCatClase tabindex="1">
					</cfif>
				</td>
			</tr>
			<tr>
				<td align="right"><strong>Clasificaci&oacute;n:</strong></td>
 			</tr>
			<tr>
				<td align="right"><strong>Centro Funcional:</strong></td>
				<td colspan="2">
					<cfif (modo NEQ "ALTA")
								and (isdefined('rsForm'))
								and (rsForm.recordCount)
								and (len(trim(rsForm.CFid)))>
					
						<cfquery name="rsCFuncional" datasource="#Session.DSN#">
							select  CFid, CFcodigo, CFdescripcion
							from CFuncional
							where CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsForm.CFid#">
						</cfquery>
						
						<cf_rhcfuncional form="form1" id="CFid" name="CFcodigo" desc="CFdescripcion" query="#rsCFuncional#" tabindex="1">
					<cfelse>
						<cf_rhcfuncional form="form1" id="CFid" name="CFcodigo" desc="CFdescripcion" tabindex="1">
					</cfif>
				</td>
			</tr>	
			<tr>
				 <td align="right"><strong>Oficina:</strong></td>
				 <td colspan="2">	 
				 	<select name="Ocodigo" tabindex="1">
						<option value="">&nbsp;</option>
						<cfloop query="rsOficinas" >
							<option value="#rsOficinas.Ocodigo#"<cfif modo NEQ "ALTA"><cfif rsForm.Ocodigo eq #rsOficinas.Ocodigo#>selected</cfif></cfif> >#rsOficinas.Odescripcion#</option>
						</cfloop>
					</select>				
				 </td>
			</tr>	

			<tr> 
				<td nowrap align="right"><strong>Vida &uacute;til:</strong></td>
				<td colspan="2">
					<input name="CCFvutil" type="text" tabindex="1"
						value="<cfif modo NEQ "ALTA">#rsForm.CCFvutil# </cfif>" size="5" maxlength="5" style="text-align: right;" onBlur="javascript:fm(this,0); "  onFocus="javascript:this.value=qf(this); this.select();"  onKeyUp="javascript:if(snumber(this,event,0)){ if(Key(event)=='13') {this.blur();}}">
				</td>
			</tr>	
	
			<tr> 
				<td >&nbsp;</td>
				<td colspan="2">
					<input 	type="checkbox" name="CCFdepreciable" tabindex="1"
					<cfif modo NEQ "ALTA" and #rsForm.CCFdepreciable# EQ 1> checked </cfif> ><strong>Depreciable</strong>
				</td>
			</tr>	
	
			<tr>
				<td >&nbsp;</td>
				<td colspan="2">
					<input type="checkbox" name="CCFrevalua" tabindex="1"
					<cfif modo NEQ "ALTA" and #rsForm.CCFrevalua# EQ 1> checked </cfif> ><strong>Reval&uacute;a</strong>
				</td>
			</tr>
	
			<tr>
				<td align="right" nowrap><strong>Tipo de Valor Residual:</strong></td>
				<td colspan="2">
					<select name="CCFtipo" id="CCFtipo" tabindex="1">
						<option value="M" <cfif modo NEQ "ALTA" and Compare(Trim(rsForm.CCFtipo),"M") eq 0>selected</cfif>>Monto</option>
						<option value="P" <cfif modo NEQ "ALTA" and Compare(Trim(rsForm.CCFtipo),"P") eq 0>selected</cfif>>Porcentaje</option>
				  </select>
				</td>
			</tr>
	
			<tr>
				<td align="right" nowrap><strong>Valor Residual:</strong></td>
				<td colspan="2">
					<cfif (modo neq "ALTA")>
						<cf_monto name="CCFvalorres" value="#rsForm.CCFvalorres#" tabindex="1">
					<cfelse>
						<cf_monto name="CCFvalorres" tabindex="1">
					</cfif>
				</td>
			</tr>
	
			<tr><td colspan="3"></td></tr>

			<tr valign="baseline"> 
				<td colspan="3" align="center" nowrap>
					<!--- <cf_botones modo="#modo#" include="Regresar"> --->
					<cfif isdefined("form.Padre_ACid") and isdefined("form.Padre_ACcodigo")> 
						<cf_botones modo="#modo#" include="Regresar" tabindex="1">
					<cfelse>
						<cf_botones modo="#modo#" tabindex="1">
					</cfif>
				</td>
			</tr>
	
			<tr>
				<td colspan="3">
					<cfset ts = "">
					<cfif modo NEQ "ALTA">
						<cfinvoke component="sif.Componentes.DButils" method="toTimeStamp" artimestamp="#rsForm.ts_rversion#" returnvariable="ts">        
						</cfinvoke>
					</cfif>
					<input type="hidden" name="modo" value="" >
					<input type="hidden" name="CCFid" value="<cfif modo NEQ "ALTA">#rsForm.CCFid#</cfif>" >
					<input type="hidden" name="ts_rversion" value="<cfif modo NEQ "ALTA">#ts#</cfif>" >
					<cfif isdefined("form.Padre_ACid")>
						<input type="hidden" name="Padre_ACid" value="#form.Padre_ACid#" >
					</cfif>
					<cfif isdefined("form.Padre_ACcodigo")>
						<input type="hidden" name="Padre_ACcodigo" value="#form.Padre_ACcodigo#" >
					</cfif>
					<input type="hidden" name="Pagina3" 
						value="
							<cfif isdefined("form.pagenum3") and form.pagenum3 NEQ "">
								#form.pagenum3#
							<cfelseif isdefined("url.PageNum_lista3") and url.PageNum_lista3 NEQ "">
								#url.PageNum_lista3#
							</cfif>">
				</td>
			</tr>
		</table>
	</form>
</fieldset>
</cfoutput>

<cfoutput>
	<cf_qforms form="form1">
	<script language="JavaScript1.2" type="text/javascript">
		function _Field_isRango(){
			var low = 0;
			var high = 99999999999999.99;
			var iValue = parseInt(qf(this.value));
			
			if (document.form1.CCFtipo.value=="P"){
				high = 100.00;
			}
			
			if(isNaN(iValue)){
				iValue=0;
			}
			
			if((low>iValue)||(high<iValue)){
				this.error="El campo "+this.description+" debe contener un valor entre "+low+" y "+high+".";
			}
		}
		
		_addValidator("isRango", _Field_isRango);
		objForm.ACcodigo.description="#JSStringFormat('Categoría')#";
		objForm.ACid.description="#JSStringFormat('Clasificación')#";
		objForm.CCFvutil.description="#JSStringFormat('Vida Útil')#";
		objForm.CCFvalorres.description="#JSStringFormat('Valor Residual')#";
		objForm.CCFvalorres.validateRango();

		function _finalizar(){
			objForm.CCFvalorres.obj.value = qf(objForm.CCFvalorres.obj);
			return true;
		}
		
		function habilitarValidacion() {
			objForm.ACcodigo.required = true;
			objForm.ACid.required = true;
			objForm.CCFvutil.required = true;
			objForm.CCFvalorres.required = true;
			objForm.allowsubmitonerror = false;
		}
		function deshabilitarValidacion() {
			objForm.ACcodigo.required = false;
			objForm.ACid.required = false;
			objForm.CCFvutil.required = false;
			objForm.CCFvalorres.required = false;
			objForm.allowsubmitonerror = true;
		}
		
		habilitarValidacion();
		
		//validaciones adicionales
		function _customValidations(){
			if (objForm.allowsubmitonerror==false) {
				if (objForm.botonSel.getValue()!='Nuevo'&&objForm.botonSel.getValue()!='Baja') {
					if (objForm.CFid.getValue()==""&&objForm.Ocodigo.getValue()==""){
						objForm.CFid.throwError("Debe definir una clasificación, un Centro Funcional o una Oficina.");
					}
					if (objForm.CFid.getValue()!=""&&objForm.Ocodigo.getValue()!=""){
						objForm.CFid.throwError("Debe definir solamente una clasificación, un Centro Funcional o una Oficina.");
					}
				}
			}
		}
	
		objForm.onValidate = _customValidations;
		objForm.CFid.onchange = new Function("return limpiarCF();");
		objForm.Ocodigo.onchange = new Function("return limpiarOficina();");
	
		function limpiarCF(){
			objForm.CFid.obj.selected = "";
			objForm.CFcodigo.obj.value = "";
			objForm.CFdescripcion.obj.value = "";
		}
		
		function limpiarOficina(){
			objform.Ocodigo.obj.selected = null;
		}
	
		objForm.CCFvutil.obj.focus();
						
		function funcRegresar(){
			deshabilitarValidacion();
			<cfif isdefined("form.Padre_ACid") and isdefined("form.Padre_ACcodigo")> 
				location.href = 'AClasificacion.cfm?ACcodigo=#form.Padre_ACcodigo#&ACid=#form.Padre_ACid#';
			</cfif>
			return false;
			
		}

	</script>
</cfoutput>