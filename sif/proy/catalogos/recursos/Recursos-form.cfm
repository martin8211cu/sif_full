<cfset modo = "alta"><cfif isdefined("form.PRJRid") and len(trim(form.PRJRid))><cfset modo = "cambio"></cfif>
<!---Consultas--->
<cfif CompareNoCase(modo,"cambio") eq 0>
	<cfquery name="rsForm" datasource="#session.dsn#">
		select PRJRid, Ucodigo, PRJRcodigo, PRJRdescripcion, PRJtipoRecurso, Ecodigo, RHPcodigo, Aid, Cid, ts_rversion
		from PRJRecurso
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			and PRJRid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.PRJRid#">
	</cfquery>
	<cfinvoke component="sif.Componentes.DButils" method="toTimeStamp" artimestamp="#rsForm.ts_rversion#" returnvariable="ts">
  </cfinvoke>
	<cfswitch expression="#rsForm.PRJtipoRecurso#">
		<cfcase value="1">
			<cfquery name="rsManoObra" datasource="#session.dsn#">
				select RHPcodigo, RHPdescpuesto
				from RHPuestos
				where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.ecodigo#">
					and RHPcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#rsForm.RHPcodigo#">
			</cfquery>
		</cfcase>
		<cfcase value="2">
			<cfquery name="rsMateriales" datasource="#session.dsn#">
				select Aid,Acodigo,Adescripcion
				from Articulos
				where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.ecodigo#">
					and Aid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsForm.Aid#">
			</cfquery>
		</cfcase>
		<cfcase value="3">
			<cfquery name="rsServicios" datasource="#session.dsn#">
				select Cid,Ccodigo,Cdescripcion
				from Conceptos
				where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.ecodigo#">
					and Cid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsForm.Cid#">
			</cfquery>
		</cfcase>
	</cfswitch>
</cfif>
<cfquery name="rsUnidades" datasource="#session.dsn#">
	select Ucodigo, Udescripcion
	from Unidades
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.ecodigo#">
</cfquery>
<cfset rsTiposRecurso = QueryNew("valor, descripcion")>
<cfset temp = QueryAddRow(rsTiposRecurso,3)>
<cfset temp = QuerySetCell(rsTiposRecurso,"valor",1,1)>
<cfset temp = QuerySetCell(rsTiposRecurso,"descripcion","Mano Obra",1)>
<cfset temp = QuerySetCell(rsTiposRecurso,"valor",2,2)>
<cfset temp = QuerySetCell(rsTiposRecurso,"descripcion","Materiales",2)>
<cfset temp = QuerySetCell(rsTiposRecurso,"valor",3,3)>
<cfset temp = QuerySetCell(rsTiposRecurso,"descripcion","Servicios",3)>
<cfquery name="rsPRJparametros" datasource="#session.dsn#">
	select PCEcatidRecurso from PRJparametros where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.ecodigo#">
</cfquery>
<cfif rsPRJparametros.RecordCount>
	<cfquery name="rslongitud" datasource="#session.dsn#">
		select PCElongitud as longitud from PCECatalogo where PCEcatid = #rsPRJparametros.PCEcatidRecurso#
	</cfquery>
<cfelse>
	<cfset rslongitud.longitud = 10>
</cfif>
<cfif rslongitud.longitud gt 10>
	<cfset rslongitud.longitud = 10>
</cfif>
<!---Consultas--->
<!---JavaScript--->
<script language="Javascript" type="text/javascript" src="/cfmx/sif/js/utilesMonto.js"></script>
<script language="Javascript" type="text/javascript" src="/cfmx/sif/js/qForms/qforms.js"></script>
<script language="Javascript" type="text/javascript">
	<!--//
	// specify the path where the "/qforms/" subfolder is located
	qFormAPI.setLibraryPath("/cfmx/sif/js/qForms/");
	// loads all default libraries
	qFormAPI.include("*");
	//qFormAPI.include("validation");
	//qFormAPI.include("functions", null, "12");
	//-->
</script>
<!---JavaScript--->
<!---Tabla Principal--->
<cfoutput><table width="100%"  border="0" cellspacing="0" cellpadding="0">
<form action="Recursos-sql.cfm" method="post" name="form1" onSubmit="javascript:finalizar();">
<cfif CompareNoCase(modo,"cambio") eq 0><input name="PRJRid" type="hidden" id="PRJRid" value="#Trim(rsForm.PRJRid)#"></cfif>
<cfif CompareNoCase(modo,"cambio") eq 0><input name="PAGENUM" type="hidden" id="PAGENUM" value="#Trim(Form.PAGENUM)#"></cfif>
<cfif CompareNoCase(modo,"cambio") eq 0><input name="ts_rversion" type="hidden" id="ts_rversion" value="#ts#"></cfif>
	<tr>
		<td>
			<table width="100%"  border="0" cellpadding="2" cellspacing="2" id="1">
				<tr>
					<td colspan="2" class="subTitulo"><div align="center"><cfif CompareNoCase(modo,"cambio") eq 0>Cambio de Recurso #rsForm.PRJRcodigo# - #rsForm.PRJRdescripcion#<cfelse>Registro de Nuevo Recurso</cfif></div></td>
					</tr>
				<tr>
					<td width="30%"><div align="right"></div></td>
					<td width="70%">&nbsp;</td>
					</tr>
				<tr>
					<td width="30%"><div align="right">C&oacute;digo</div></td>
					<td width="70%"><input name="PRJRcodigo" type="text" id="PRJRcodigo" accesskey="1" tabindex="1" <cfif CompareNoCase(modo,"cambio") eq 0>value="#Trim(rsForm.PRJRcodigo)#"</cfif> size="10" maxlength="#rslongitud.longitud#" style="text-transform:uppercase" onBlur="javascript:completarCodigo(this, this.value, #rslongitud.longitud#);"><input name="hid_PRJRcodigo" type="hidden" id="hid_PRJRcodigo" <cfif CompareNoCase(modo,"cambio") eq 0>value="#Trim(rsForm.PRJRcodigo)#"</cfif>></td>
					</tr>
				<tr>
					<td width="30%"><div align="right">Descripci&oacute;n</div></td>
					<td width="70%"><input name="PRJRdescripcion" type="text" id="PRJRdescripcion" accesskey="2" tabindex="2" <cfif CompareNoCase(modo,"cambio") eq 0>value="#Trim(rsForm.PRJRdescripcion)#"</cfif> size="80" maxlength="80"></td>
					</tr>
				<tr>
					<td width="30%"><div align="right">Unidad de Medida </div></td>
					<td width="70%"><select name="Ucodigo" id="Ucodigo" accesskey="3" tabindex="3">
					  <cfloop query="rsUnidades">
							<option value="#rsUnidades.Ucodigo#" <cfif CompareNoCase(modo,"cambio") eq 0 and (isDefined("rsForm.Ucodigo") AND rsUnidades.Ucodigo EQ rsForm.Ucodigo)>selected</cfif>>#rsUnidades.Udescripcion#</option>
						</cfloop>
					  </select></td>
					</tr>
				<tr>
					<td colspan="2"><div align="right">
					  <fieldset>
					  <legend>Recurso</legend>
					      <table width="100%"  border="0" cellpadding="2" cellspacing="2" id="2">
								<tr>
                  <td width="29%" scope="row"><div align="right">Tipo</div></td>
                  <td width="71%"><select name="PRJtipoRecurso" id="PRJtipoRecurso" accesskey="4" tabindex="4" onChange="javascript:showTipo(this.value);limpiarTipos();inactivarUnidad(this.value);">
									<cfloop query="rsTiposRecurso">
										<option value="#rsTiposRecurso.valor#" <cfif CompareNoCase(modo,"cambio") eq 0 and (isDefined("rsForm.PRJtipoRecurso") AND rsTiposRecurso.valor EQ rsForm.PRJtipoRecurso)>selected</cfif>>#rsTiposRecurso.descripcion#</option>
									</cfloop>
                  </select></td>
                </tr>
								</table>
								<div id="div_1" style="display:none ">
								<table width="100%"  border="0" cellpadding="2" cellspacing="2" id="2">
								<tr>
                  <td width="29%" scope="row"><div align="right">Mano Obra</div></td>
                  <td width="71%"><cfif CompareNoCase(modo,"cambio") eq 0 and CompareNoCase(rsForm.PRJtipoRecurso,'1') eq 0><cf_rhpuesto query="#rsManoObra#"><cfelse><cf_rhpuesto></cfif></td>
                </tr>
								</table>
								</div>
								<div id="div_2" style="display:none;">
								<table width="100%"  border="0" cellpadding="2" cellspacing="2" id="2">
                <tr>
                  <td width="29%" scope="row"><div align="right">Material</div></td>
                  <td width="71%"><cfif CompareNoCase(modo,"cambio") eq 0 and CompareNoCase(rsForm.PRJtipoRecurso,'2') eq 0><cf_sifarticulos query="#rsMateriales#"><cfelse><cf_sifarticulos></cfif></td>
                </tr>
								</table>
								</div>
								<div id="div_3" style="display:none;">
								<table width="100%"  border="0" cellpadding="2" cellspacing="2" id="2">
                <tr>
                  <td width="29%" scope="row"><div align="right">Servicio</div></td>
                  <td width="71%">
							<cfparam name="s_filtro" default="">
							<cfif CompareNoCase(modo,"cambio") eq 0 and CompareNoCase(rsForm.PRJtipoRecurso,'3') eq 0>
								<cf_sifconceptos query="#rsServicios#"  filtroextra="#s_filtro#">
							<cfelse>
								<cf_sifconceptos filtroextra="#s_filtro#">
							</cfif>
<!---
										<input name="Cdescripcion" type="text" id="Cdescripcion" tabindex="7" <cfif CompareNoCase(modo,"cambio") eq 0 and CompareNoCase(rsForm.PRJtipoRecurso,'3') eq 0>value="#Trim(rsServicios.Cdescripcion)#"</cfif> size="50" maxlength="50" readonly> 
										<a href="##">
											<img src="/cfmx/sif/imagenes/Description.gif" alt="Lista de Servicios" name="imagen" width="18" height="14" border="0" align="absmiddle" onClick="javascript:doConlis();">
										</a> 
										<input name="Cid" type="hidden" id="Cid" <cfif CompareNoCase(modo,"cambio") eq 0 and CompareNoCase(rsForm.PRJtipoRecurso,'3') eq 0>value="#Trim(rsServicios.Cid)#"</cfif>> 
 --->									
 					</td>
                </tr>
								</table>
								</div>
					  </fieldset>
					  </div></td>
					</tr>
				<tr>
					<td width="30%"><div align="right"></div></td>
					<td width="70%">&nbsp;</td>
					</tr>
				<tr>
					<td colspan="2"><div align="right"><cf_botones modo="#modo#"></div></td>
					</tr>
				<tr>
					<td width="30%"><div align="right"></div></td>
					<td width="70%">&nbsp;</td>
					</tr>
			</table>
		</td>
	</tr>
</form>
</table></cfoutput>
<!---Tabla Principal--->
<!---JavaScript--->
<script language="Javascript" type="text/javascript">
	<!--//
	qFormAPI.errorColor = "#FFFFCC";
	objForm = new qForm("form1");
	<cfoutput>
	objForm.PRJRcodigo.description = "#JSStringFormat('Código')#";
	objForm.PRJRdescripcion.description = "#JSStringFormat('Desripción')#";
	objForm.Ucodigo.description = "#JSStringFormat('Unidad de Medida')#";
	objForm.PRJtipoRecurso.description = "#JSStringFormat('Tipo de Recurso')#";
	objForm.RHPdescpuesto.description = "#JSStringFormat('Mano Obra')#";
	objForm.Aid.description = "#JSStringFormat('Material')#";
	objForm.Cid.description = "#JSStringFormat('Servicio')#";
	</cfoutput>
	function habilitarValidacionTipo(tipo){
		objForm.RHPdescpuesto.required = tipo==1;
		objForm.Aid.required = tipo==2;
		objForm.Cid.required = tipo==3;
	}
	function deshabilitarValidacionTipo(){
		objForm.RHPdescpuesto.required = false;
		objForm.Aid.required = false;
		objForm.Cid.required = false;
	}
	function habilitarValidacion(){
		objForm.PRJRcodigo.required = true;
		objForm.PRJRdescripcion.required = true;
		objForm.Ucodigo.required = true;
		objForm.PRJtipoRecurso.required = true;
		habilitarValidacionTipo(document.form1.PRJtipoRecurso.value);
	}
	function deshabilitarValidacion(){
		objForm.PRJRcodigo.required = false;
		objForm.PRJRdescripcion.required = false;
		objForm.Ucodigo.required = false;
		objForm.PRJtipoRecurso.required = false;
		deshabilitarValidacionTipo();
	}
	function limpiarTipos(){
		document.form1.RHPcodigo.value="";
		document.form1.RHPdescpuesto.value="";
		document.form1.Aid.value="";
		document.form1.Acodigo.value="";
		document.form1.Adescripcion.value="";		
		document.form1.Cid.value="";
		document.form1.Cdescripcion.value="";		
	}
	function showTipo(tipo){
		var _div_1 = document.getElementById("div_1");
		var _div_2 = document.getElementById("div_2");
		var _div_3 = document.getElementById("div_3");
		_div_1.style.display = tipo==1?"":"none";
		_div_2.style.display = tipo==2?"":"none";
		_div_3.style.display = tipo==3?"":"none";
	}
	showTipo(document.form1.PRJtipoRecurso.value);
	function completarCodigo(campo, valor, longitud){
		while (valor.length<longitud)
			valor = '0' + valor;
		campo.value = valor;
	}
	function inactivarUnidad(valor){
		objForm.Ucodigo.obj.disabled = valor==2;
	}
	inactivarUnidad(document.form1.PRJtipoRecurso.value);
	function finalizar(){
		objForm.Ucodigo.obj.disabled = false;
	}
	var popUpWin=0;
	function popUpWindow(URLStr, left, top, width, height){
	  if(popUpWin) {
		if(!popUpWin.closed) popUpWin.close();
	  }
	  popUpWin = open(URLStr, 'popUpWin', 'toolbar=no,location=no,directories=no,status=no,menub ar=no,scrollbar=no,resizable=yes,copyhistory=yes,width='+width+',height='+height+',left='+left+', top='+top+',screenX='+left+',screenY='+top+'');
	}
	function doConlis() {
		popUpWindow("/cfmx/sif/cm/operacion/ConlisConceptosOC.cfm?formulario=form1&id=Cid&desc=Cdescripcion" ,250,200,650,400);
	}
	habilitarValidacion();
	document.form1.PRJRcodigo.focus();
	//-->
</script>
<!---JavaScript--->