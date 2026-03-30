<cfif isdefined("Form.Cambio")>  
	<cfset modo="CAMBIO">
<cfelse>  
	<cfif not isdefined("Form.modo")>    
		<cfset modo="ALTA">
	<cfelseif Form.modo EQ "CAMBIO">
		<cfset modo="CAMBIO">
	<cfelse>
		<cfset modo="ALTA">
	</cfif>  
</cfif>

<cfif isdefined('url.CCPid') and url.CCPid GT 0 and not isdefined('form.CCPid')>
	<cfset form.CCPid = url.CCPid>
	<cfset modo = "CAMBIO">
</cfif> 
<cfif isdefined('url.filtro_CCPcodigo') and not isdefined('form.filtro_CCPcodigo')>
	<cfset form.filtro_CCPcodigo = url.filtro_CCPcodigo>
</cfif>
<cfif isdefined('url.filtro_CCPdescripcion') and not isdefined('form.filtro_CCPdescripcion')>
	<cfset form.filtro_CCPdescripcion = url.filtro_CCPdescripcion>
</cfif>

<!--- CONSULTAS --->
<cfquery name="rsCodigos" datasource="#Session.DSN#">
	SELECT CCPcodigo
	FROM ConceptosCarreraP
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#"> 
</cfquery> 

<cfquery name="rsTipoConcepto" datasource="#session.DSN#">
	select TCCPid, TCCPdesc
	from TipoConceptoCP 
</cfquery>

<cfquery name="rsUnidadEq" datasource="#session.DSN#">
	select UECPid,UECPdescripcion
	from UnidadEquivalenciaCP 
</cfquery>

<cfif modo neq 'ALTA' >
	<cfquery name="rs" datasource="#Session.DSN#">
		select 	CCPid,CCPcodigo,CCPdescripcion,a.CIid,TCCPid,CCPplazofijo,CCPporcsueldo,CCPvalor,CCPfactorpunto,CCPacumulable , CCPpagoCada,
				CCPmaxpuntos,CCPequivalenciapunto,UECPid,CCPpuntofraccionable,CCPpuestosEspecificos,a.Ecodigo,a.ts_rversion,CCPcategoriasEspecificas,
				CCPprioridad, CCPpagoXdia, CCPaprobacion
		from ConceptosCarreraP a
		where CCPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CCPid#">
	</cfquery>
	<cfquery name="rsPuestosConcepto" datasource="#Session.DSN#">
		select rtrim(a.RHPcodigo) as RHPcodigo, RHPdescpuesto
		from PuestosxConceptoCP a
		inner join RHPuestos b
			on b.RHPcodigo = a.RHPcodigo
			and b.Ecodigo = a.Ecodigo
		where a.CCPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CCPid#">
		  and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	</cfquery>
	<cfquery name="rsCatConcepto" datasource="#session.DSN#">
		select a.RHCid,rtrim(RHCcodigo) as RHCcodigo, RHCdescripcion
		from ConceptosCPCategoria a
		inner join RHCategoria b
			on b.RHCid = a.RHCid
		where a.CCPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CCPid#">
	</cfquery>
</cfif>
<!--- FIN CONSULTAS --->
<script src="/cfmx/rh/js/utilesMonto.js"></script>
<script src="/cfmx/sif/js/qForms/qforms.js"></script>

<cfoutput>
<form name="form1" method="post" action="ConceptosCarreraP-sql.cfm" >
	<cfif isdefined('form.filtro_CCPcodigo') and LEN(TRIM(form.filtro_CCPcodigo))><input name="filtro_CCPcodigo" value="#form.Filtro_CCPcodigo#" type="hidden" /></cfif>
	<cfif isdefined('form.filtro_CCPdescripcion') and LEN(TRIM(form.filtro_CCPdescripcion))><input name="filtro_CCPdescripcion" value="#form.filtro_CCPdescripcion#" type="hidden" /></cfif>
	<cfif modo NEQ 'ALTA'><input name="CCPid" value="#rs.CCPid#" tabindex="-1" type="hidden"></cfif>
	<table width="100%" border="0" cellspacing="0" cellpadding="3">
    	<tr> 
			<td align="right" class="fileLabel">#LB_CODIGO#&nbsp;:</td>
			<td>
				<input name="CCPcodigo" type="text" id="CCPcodigo" size="5" maxlength="5" value="<cfif modo NEQ "ALTA">#rs.CCPcodigo#</cfif>" onfocus="this.select();" tabindex="1"></td>
		</tr>
		<tr> 
			<td align="right" class="fileLabel">#LB_DESCRIPCION#&nbsp;:</td>
			<td><input name="CCPdescripcion" type="text" id="CCPdescripcion" size="50" maxlength="80" value="<cfif modo NEQ "ALTA">#rs.CCPdescripcion#</cfif>" onfocus="this.select();" tabindex="1"></td>
		</tr>
		<!--- <tr> 
			<td align="right" class="fileLabel" nowrap="nowrap"><cf_translate key="LB_ConceptoDePago">Concepto de Pago</cf_translate>:</td>
			<td>
				<cfset Lvar_CIid  = '' >
				<cfset Lvar_CIcodigo = ''>
				<cfset Lvar_CIdescripcion = '' >
				<cfif modo NEQ 'ALTA'>
					<cfquery name="rsConcepto" datasource="#session.DSN#">
						select CIid, CIcodigo, CIdescripcion
						from CIncidentes
						where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
						  and CIid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rs.CIid#">
					</cfquery>
					<cfset Lvar_CIid  = rsConcepto.CIid >
					<cfset Lvar_CIcodigo = rsConcepto.CIcodigo>
					<cfset Lvar_CIdescripcion = rsConcepto.CIdescripcion >
				</cfif>
				<cf_conlis
					campos="CIid,CIcodigo,CIdescripcion"
					desplegables="N,S,S"
					modificables="N,S,N"
					size="0,10,25"
					title="#LB_ListaDeConceptosDePago#"
					tabla="CIncidentes"
					columnas="CIid,CIcodigo,CIdescripcion"
					values="#Lvar_CIid#,#Lvar_CIcodigo#,#Lvar_CIdescripcion#"
					filtro="Ecodigo = #SESSION.ECODIGO#
							and not exists(select CIid
											from ConceptosCarreraP
											where CIid = CIncidentes.CIid
											) 
							and CIcarreracp = 1
							order by CIcodigo"
					desplegar="CIcodigo,CIdescripcion"
					filtrar_por="CIcodigo,CIdescripcion"
					etiquetas="#LB_Codigo#, #LB_Descripcion#"
					formatos="S,S"								
					align="left,left"
					asignar="CIid,CIcodigo,CIdescripcion"
					asignarformatos="I,S, S"
					showEmptyListMsg="true"
					EmptyListMsg="-- #MSG_NoSeEncontraronRegistros# --"
					tabindex="1">
			</td>
		</tr> --->
		<tr>
			<td align="right" class="fileLabel" nowrap ><cf_translate key="LB_TipoDeConcpeto">Tipo de Concepto</cf_translate>:</td>
			<td>
				<select name="TCCPid" tabindex="1">
					<cfloop query="rsTipoConcepto">
						<option value="#TCCPid#" <cfif modo NEQ "ALTA" and rs.TCCPid EQ TCCPid> selected</cfif>>#TCCPdesc#</option>
					</cfloop>
				</select>
	  	</tr>
		<tr>
			<td>&nbsp;</td>
			<td>
				<table border="0" cellpadding="0" cellspacing="3">
					<tr>
						<td><input alt="0" name="CCPpagoXdia" type="checkbox" id="CCPpagoXdia" value="0" <cfif modo NEQ "ALTA" and rs.CCPpagoXdia EQ 1>checked</cfif> tabindex="1"></td>
						<td nowrap><cf_translate key="CHK_PagoPorDia">Pago por D&iacute;a</cf_translate></td>
						<td><input alt="0" name="CCPaprobacion" type="checkbox" id="CCPaprobacion" value="0" <cfif modo NEQ "ALTA" and rs.CCPaprobacion EQ 1>checked</cfif> tabindex="1"></td>
						<td nowrap><cf_translate key="CHK_Aprobacion">Requiere Aprobaci&oacute;n</cf_translate></td>
					</tr>
					<tr>
						<td><input alt="0" name="CCPplazofijo" type="checkbox" id="CCPplazofijo" value="0" <cfif modo NEQ "ALTA" and rs.CCPplazofijo EQ 1>checked</cfif> tabindex="1"></td>
						<td nowrap><cf_translate key="CHK_PlazoFijo">Plazo Fijo</cf_translate></td>
						<td><input alt="0" name="CCPporcsueldo" type="checkbox" id="CCPporcsueldo" value="0" tabindex="1" onclick="javascript: deshabilitaCampos();" <cfif modo NEQ "ALTA" and rs.CCPporcsueldo EQ 1>checked</cfif>></td>
						<td nowrap><cf_translate key="CHK_AplicaUnPorcentajeSobreElSueldo">Aplica un porcentaje sobre el sueldo</cf_translate></td>
					</tr>
					<tr>
						<td><input alt="0" name="CCPpuntofraccionable" type="checkbox" id="CCPpuntofraccionable" value="0" <cfif modo NEQ "ALTA" and rs.CCPporcsueldo EQ 1>disabled</cfif> <cfif modo NEQ "ALTA" and rs.CCPpuntofraccionable EQ 1>checked</cfif>></td>
						<td nowrap><cf_translate key="CHK_PuntoFraccionable">Punto Fraccionable</cf_translate></td>
						<td><input alt="0" name="CCPpuestosEspecificos" type="checkbox" id="CCPpuestosEspecificos" value="0" tabindex="1" onclick="javascript: verPuestos();"<cfif modo NEQ "ALTA" and rs.CCPpuestosEspecificos EQ 1>checked</cfif>></td>
						<td nowrap><cf_translate key="CHK_PuestosEspecificos">Aplica a Puestos Espec&iacute;ficos</cf_translate></td>
					</tr>
					<tr>
						<td><input alt="0" name="CCPacumulable" type="checkbox" id="CCPacumulable" value="0" onclick="javascript: deshabilitaAcumPC();" <cfif modo NEQ "ALTA" and rs.CCPporcsueldo EQ 1 >disabled</cfif> <cfif modo NEQ "ALTA" and rs.CCPacumulable EQ 1>checked</cfif> tabindex="1"></td>
						<td nowrap><cf_translate key="CHK_Acumulable">Acumulable</cf_translate></td>
						<td><input alt="0" name="CCPcategoriasEspecificas" type="checkbox" id="CCPcategoriasEspecificas" value="0" tabindex="1" onclick="javascript: verCat();" <cfif modo NEQ "ALTA" and rs.CCPcategoriasEspecificas EQ 1>checked</cfif>></td>
						<td nowrap><cf_translate key="CHK_CatEspecificas">Aplica a Categor&iacute;as Espec&iacute;ficas</cf_translate></td>
					</tr>
			  	</table>
			</td>
		</tr>
		<cfset Lvar_Valor = 0.00>
		<cfif modo NEQ "ALTA" and rs.CCPvalor GT 0>
			<cfset Lvar_Valor = rs.CCPvalor>
		</cfif>
		<tr>
			<td align="right" class="fileLabel" nowrap="nowrap"><cf_translate key="LB_PrioridadPorTipo">Prioridad por Tipo</cf_translate>:</td>
			<td>
				<select name="CCPprioridad" style="width:40px">
					<cfloop from="0" to="5" index="i">
						<option value="#i#" <cfif modo NEQ 'ALTA' and rs.CCPprioridad EQ i>selected</cfif>>#i#</option>
					</cfloop>					
				</select>	
			</td>	
		</tr>
		<tr> 
			<td align="right" class="fileLabel" nowrap="nowrap"><cf_translate key="LB_ValorSugerido">Valor Sugerido</cf_translate>:</td>
			<td><cf_monto name="CCPvalor" value="#Lvar_Valor#" size="10" tabindex="1" decimales="2"></td>
		</tr>
		<tr>
			<td align="right" class="fileLabel" nowrap ><cf_translate key="LB_UnidadDeEquivalencia">Unidad de Equivalencia</cf_translate>:</td>
			<td>
				<select name="UECPid" onchange="javascript: funcCambioEquivalencia(this.value);" tabindex="1" <cfif modo NEQ "ALTA" and rs.CCPporcsueldo EQ 1>disabled</cfif>>	
					<cfloop query="rsUnidadEq">
						<option value="#UECPid#" <cfif modo NEQ "ALTA" and rs.UECPid EQ UECPid> selected</cfif>>#UECPdescripcion#</option>
					</cfloop>
				</select>
	  	</tr>
		<cfset Lvar_EquivalP = 1.00>
		<cfif modo NEQ "ALTA" and rs.CCPequivalenciapunto GT 0>
			<cfset Lvar_EquivalP = rs.CCPequivalenciapunto>
		</cfif>
		<cfif modo NEQ "ALTA" and rs.CCPporcsueldo EQ 1><cfset Lvar_Readonly = true><cfelse><cfset Lvar_Readonly = false></cfif>
		<tr> 
			<td align="right" class="fileLabel" nowrap="nowrap"><cf_translate key="LB_EquivalenciaEnPuntos">Equivalencia en Puntos</cf_translate>:</td>
			<td><cf_monto name="CCPequivalenciapunto" value="#Lvar_EquivalP#" size="10" tabindex="1" readonly="#Lvar_Readonly#" decimales="4"></td>
		</tr>
		<cfset Lvar_FactorPunto = 1.00>
		<cfif modo NEQ "ALTA" and rs.CCPfactorpunto GT 0>
			<cfset Lvar_FactorPunto = rs.CCPfactorpunto>
		</cfif>
		<tr> 
			<td align="right" class="fileLabel" nowrap="nowrap"><cf_translate key="LB_FactorPorPunto">Factor por Punto</cf_translate>:</td>
			<td>
				<cf_monto name="CCPfactorpunto" value="#Lvar_FactorPunto#" size="10" tabindex="1" readonly="#Lvar_Readonly#"></td>
		</tr>
		<cfset Lvar_MaxPuntos = 1.00>
		<cfif modo NEQ "ALTA" and rs.CCPmaxpuntos GT 0>
			<cfset Lvar_MaxPuntos = rs.CCPmaxpuntos>
		</cfif>
		<tr> 
			<td align="right" class="fileLabel" nowrap="nowrap"><cf_translate key="LB_MaximoAcumulablePorUnidad">M&aacute;ximo Acumulable por Unidad</cf_translate>:</td>
			<td><cf_monto name="CCPmaxpuntos" value="#Lvar_MaxPuntos#" size="10" tabindex="1" readonly="#Lvar_Readonly#"></td>
		</tr>
		<cfset Lvar_pagoCada = 1.00>
		<cfif modo NEQ "ALTA" and rs.CCPpagoCada GT 0><cfset Lvar_pagoCada = rs.CCPpagoCada></cfif>
		<tr> 
			<td align="right" class="fileLabel" nowrap="nowrap"><cf_translate key="LB_AcumPagoCada">Por Acumulaci&oacute;n Pago Cada</cf_translate>:</td>
			<td><cf_monto name="CCPpagoCada" value="#Lvar_pagoCada#" size="10" tabindex="1" readonly="#Lvar_Readonly#"></td>
		</tr>
		<tr id="PuestosEsp"  <cfif modo EQ "ALTA" or rs.CCPpuestosEspecificos EQ 0> style="display:none ;"</cfif>>
			<td>&nbsp;</td>
			<td>
				<table width="100%"  border="0" cellspacing="0" cellpadding="2" style="border:1px solid gray;">
					<tr class="tituloListas"><td align="center">&nbsp;<strong><cf_translate key="LB_PuestosALosQueSeAplica" tabindex="1">Puestos a los que se aplica</cf_translate></strong></td></tr>
					<tr><td>&nbsp;</td></tr>
					<tr>
						<td>
							<table id="tblpuesto" width="100%"  border="0" cellspacing="0" cellpadding="0">
								<tr>
									<td align="right"> <strong><cf_translate key="LB_Puesto" XmlFile="/rh/generales.xml">Puesto</cf_translate>:</strong>&nbsp;</td>
									<td>
										<cf_rhpuesto size="30" tabindex="1">
									</td>
									<td align="right">
										<input type="hidden" name="LastOnePuesto" id="LastOnePuesto" value="ListaNon" tabindex="3">
										&nbsp;<input type="button" name="agregarPuesto" onclick="javascript:if (window.fnNuevoPuesto) fnNuevoPuesto();" value="+" tabindex="1">
									</td>
								</tr>
								<tbody>
								</tbody>
							</table>
						</td>
					</tr>
					<tr><td>&nbsp;</td></tr>
				</table>
			</td>
		</tr>
		<tr id="CategoriasEsp"  <cfif modo EQ "ALTA" or rs.CCPcategoriasEspecificas EQ 0> style="display:none ;"</cfif>>
			<td>&nbsp;</td>
			<td>
				<table width="100%"  border="0" cellspacing="0" cellpadding="2" style="border:1px solid gray;">
					<tr class="tituloListas"><td align="center">&nbsp;<strong><cf_translate key="LB_CategoriaALosQueSeAplica" tabindex="1">Categor&iacute;a a los que se aplica</cf_translate></strong></td></tr>
					<tr><td>&nbsp;</td></tr>
					<tr>
						<td>
							<table id="tblCat" width="100%"  border="0" cellspacing="0" cellpadding="0">
								<tr>
									<td align="right"> <strong><cf_translate key="LB_Categoria">Categor&iacute;a</cf_translate>:</strong>&nbsp;</td>
									<td>
										<cfset ValuesCat = ArrayNew(1)>
										<cfif isdefined("form.RHCid") and len(trim(form.RHCid))>								
											<cfset ArrayAppend(ValuesCat, form.RHCid)>
											<cfset ArrayAppend(ValuesCat, rsPuestosCategoria.RHCcodigo)>
											<cfset ArrayAppend(ValuesCat, rsPuestosCategoria.RHCdescripcion)>
										</cfif>
										<cf_conlis 
											campos="RHCid,RHCcodigo,RHCdescripcion"
											size="0,10,30"
											desplegables="N,S,S"
											modificables="N,S,N"
											title="Lista de Categor&iacute;as"
											tabla="RHCategoria"
											columnas="RHCid as RHCid, RHCcodigo as RHCcodigo, RHCdescripcion as RHCdescripcion"
											valuesArray="#ValuesCat#"
											filtro="Ecodigo = #Session.Ecodigo# Order by RHCcodigo,RHCdescripcion"
											filtrar_por="RHCcodigo, RHCdescripcion"
											desplegar="RHCcodigo, RHCdescripcion"
											etiquetas="C&oacute;digo, Descripci&oacute;n"
											formatos="S,S"
											align="left,left"
											asignar="RHCid,RHCcodigo, RHCdescripcion"
											asignarFormatos="S,S,S"
											form="form1"
											showEmptyListMsg="true"
											EmptyListMsg=" --- No se encotraron registros --- "/>
									</td>
									<td align="right">
										<input type="hidden" name="LastOneCat" id="LastOneCat" value="ListaNon" tabindex="3">
										&nbsp;<input type="button" name="agregarCat" onclick="javascript:if (window.fnNuevoCat) fnNuevoCat();" value="+" tabindex="1">
									</td>
								</tr>
								<tbody>
								</tbody>
							</table>
						</td>
					</tr>
					<tr><td>&nbsp;</td></tr>
				</table>
			</td>
		</tr>
		<tr> 
        	<td colspan="4" align="center"> 
				<cf_botones modo="#modo#" tabindex="1">
			</td>
		</tr>
	</table>
	<cfset ts = "">
	<cfif modo NEQ "ALTA">
		<cfinvoke component="sif.Componentes.DButils" method="toTimeStamp" artimestamp="#rs.ts_rversion#" returnvariable="ts"></cfinvoke>
	</cfif>
	
	<input type="hidden" name="Pagina" value="<cfif isdefined("Pagenum_lista") and Pagenum_lista NEQ "">#Pagenum_lista#<cfelseif isdefined("Form.PageNum")>#PageNum#</cfif>">
	<input type="hidden" name="ts_rversion" value="<cfif modo NEQ "ALTA">#ts#</cfif>">
	<input type="image" id="imgDel" src="/cfmx/rh/imagenes/Borrar01_S.gif" title="Eliminar" style="display:none;">

<!--- para mantener la navegacion --->
<cfif isdefined("Form.FCCPcodigo") and Len(Trim(Form.FCCPcodigo)) NEQ 0>
	<input type="hidden" name="FCCPcodigo" value="#form.FCCPcodigo#" >
</cfif>

<cfif isdefined("Form.FCCPdescripcion") and Len(Trim(Form.FCCPdescripcion)) NEQ 0>
	<input type="hidden" name="FCCPdescripcion" value="#form.FCCPdescripcion#" >
</cfif>

<cfif isdefined("Form.fMetodo") and Len(Trim(Form.fMetodo)) gt 0>
	<input type="hidden" name="fMetodo" value="#form.fMetodo#" >
</cfif> 

</form>

</cfoutput>
<cf_qforms form='form1'>
	<cf_qformsrequiredfield args="CCPcodigo, #MSG_Codigo#">
	<cf_qformsrequiredfield args="CCPdescripcion, #MSG_Descripcion#">
	<!--- <cf_qformsrequiredfield args="CIid, #MSG_ConcpetoDePago#"> --->
</cf_qforms>
<script language="javascript1.2" type="text/javascript">
 	<!--//
	
	<cfif isdefined("rsPuestosConcepto") and rsPuestosConcepto.recordcount gt 0 >
		<cfloop query="rsPuestosConcepto">
			fnLPuesto('<cfoutput>#rsPuestosConcepto.RHPcodigo#</cfoutput>','<cfoutput>#rsPuestosConcepto.RHPdescpuesto#</cfoutput>');
		</cfloop>
	</cfif>	
	<cfif isdefined("rsCatConcepto") and rsCatConcepto.recordcount gt 0 >
		<cfloop query="rsCatConcepto">
			fnLCat('<cfoutput>#rsCatConcepto.RHCid#</cfoutput>','<cfoutput>#rsCatConcepto.RHCcodigo#</cfoutput>','<cfoutput>#rsCatConcepto.RHCdescripcion#</cfoutput>');
		</cfloop>
	</cfif>	
	var vnContadorListas = 0;

	//**********************************Tabla Dinámica**********************************************
	
	var GvarNewTD;
	function fnLPuesto(p1,p2)
	{
	  var LvarTable = document.getElementById("tblpuesto");
	  var LvarTbody = LvarTable.tBodies[0];
	  var LvarTR    = document.createElement("TR");
	  
	  var Lclass 	= document.form1.LastOnePuesto;

	  // Valida no agregar vacíos
	  if (p1=="") return;
	  
	  // Valida no agregar repetidos
	  if (existeCodigoPuesto(p1)) {alert('<cfoutput>#MSG_EstePuestoYaFueAgregado#</cfoutput>.');return;}
  	  
	  // Agrega Columna 0
	  sbAgregaTdInput (LvarTR, Lclass.value, p1, "hidden", "PuestoidList");

	  // Agrega Columna 1
	  sbAgregaTdText  (LvarTR, Lclass.value,  p1 + ' - ' + p2);
	  	
	  // Agrega Evento de borrado en Columna 2
	  sbAgregaTdImage (LvarTR, Lclass.value, "imgDel", "right");
	  if (document.all)
		GvarNewTD.attachEvent ("onclick", sbEliminarTR);
	  else
		GvarNewTD.addEventListener ("click", sbEliminarTR, false);
	
	  // Nombra el TR
	  LvarTR.name = "XXXXX";
	  // Agrega el TR al Tbody
	  LvarTbody.appendChild(LvarTR);
	  
	  if (Lclass.value=="ListaNon")
		Lclass.value="ListaPar";
	  else
		Lclass.value="ListaNon";
	}
	
	function fnLCat(p0,p1,p2)
	{
	  var LvarTable = document.getElementById("tblCat");
	  var LvarTbody = LvarTable.tBodies[0];
	  var LvarTR    = document.createElement("TR");
	  
	  var Lclass 	= document.form1.LastOneCat;

	  // Valida no agregar vacíos
	  if (p0=="") return;
	  
	  // Valida no agregar repetidos
	  if (existeCodigoCat(p0)) {alert('<cfoutput>#MSG_EstaCatYaFueAgregada#</cfoutput>.');return;}
  	  
	  // Agrega Columna 0
	  sbAgregaTdInput (LvarTR, Lclass.value, p0, "hidden", "CatidList");

	  // Agrega Columna 1
	  sbAgregaTdText  (LvarTR, Lclass.value,  p1 + ' - ' + p2);
	  	
	  // Agrega Evento de borrado en Columna 2
	  sbAgregaTdImage (LvarTR, Lclass.value, "imgDel", "right");
	  if (document.all)
		GvarNewTD.attachEvent ("onclick", sbEliminarTR);
	  else
		GvarNewTD.addEventListener ("click", sbEliminarTR, false);
	
	  // Nombra el TR
	  LvarTR.name = "XXXXX";
	  // Agrega el TR al Tbody
	  LvarTbody.appendChild(LvarTR);
	  
	  if (Lclass.value=="ListaNon")
		Lclass.value="ListaPar";
	  else
		Lclass.value="ListaNon";
	}
	
	function fnNuevoPuesto()
	{
	  if (document.form1.RHPcodigo.value != '' && document.form1.RHPdescpuesto.value != ''){
	  	vnContadorListas = vnContadorListas + 1;
	  }

	  var LvarTable = document.getElementById("tblpuesto");
	  var LvarTbody = LvarTable.tBodies[0];
	  var LvarTR    = document.createElement("TR");
	  
	  var Lclass 	= document.form1.LastOnePuesto;
	  var p1 		= document.form1.RHPcodigo.value.toString();//cod
	  var p2 		= document.form1.RHPdescpuesto.value;//desc

	  document.form1.RHPcodigo.value="";
	  document.form1.RHPcodigoext.value="";
	  document.form1.RHPdescpuesto.value="";

	  // Valida no agregar vacíos
	  if (p1=="") return;
	  
	  // Valida no agregar repetidos
	  if (existeCodigoPuesto(p1)) {alert('<cfoutput>#MSG_EstePuestoYaFueAgregado#</cfoutput>.');return;}
  	  
	  // Agrega Columna 0
	  sbAgregaTdInput (LvarTR, Lclass.value, p1, "hidden", "PuestoidList");

	  // Agrega Columna 1
	  sbAgregaTdText  (LvarTR, Lclass.value,  p1 + ' - ' + p2);
	  	
	  // Agrega Evento de borrado en Columna 2
	  sbAgregaTdImage (LvarTR, Lclass.value, "imgDel", "right");
	  if (document.all)
		GvarNewTD.attachEvent ("onclick", sbEliminarTR);
	  else
		GvarNewTD.addEventListener ("click", sbEliminarTR, false);
	
	  // Nombra el TR
	  LvarTR.name = "XXXXX";
	  // Agrega el TR al Tbody
	  LvarTbody.appendChild(LvarTR);
	  
	  if (Lclass.value=="ListaNon")
		Lclass.value="ListaPar";
	  else
		Lclass.value="ListaNon";
	}


	function fnNuevoCat()
	{
	  if (document.form1.RHCcodigo.value != '' && document.form1.RHCdescripcion.value != ''){
	  	vnContadorListas = vnContadorListas + 1;
	  }

	  var LvarTable = document.getElementById("tblCat");
	  var LvarTbody = LvarTable.tBodies[0];
	  var LvarTR    = document.createElement("TR");
	  
	  var Lclass 	= document.form1.LastOneCat;
	  var p0 		= document.form1.RHCid.value.toString();//cod
	  var p1 		= document.form1.RHCcodigo.value.toString();//cod
	  var p2 		= document.form1.RHCdescripcion.value;//desc

	  document.form1.RHCcodigo.value="";
	  document.form1.RHCdescripcion.value="";

	  // Valida no agregar vacíos
	  if (p1=="") return;
	  
	  // Valida no agregar repetidos
	  if (existeCodigoCat(p1)) {alert('<cfoutput>#MSG_EstaCatYaFueAgregada#</cfoutput>.');return;}
  	  
	  // Agrega Columna 0
	  sbAgregaTdInput (LvarTR, Lclass.value, p0, "hidden", "CatidList");

	  // Agrega Columna 1
	  sbAgregaTdText  (LvarTR, Lclass.value,  p1 + ' - ' + p2);
	  	
	  // Agrega Evento de borrado en Columna 2
	  sbAgregaTdImage (LvarTR, Lclass.value, "imgDel", "right");
	  if (document.all)
		GvarNewTD.attachEvent ("onclick", sbEliminarTR);
	  else
		GvarNewTD.addEventListener ("click", sbEliminarTR, false);
	
	  // Nombra el TR
	  LvarTR.name = "XXXXX";
	  // Agrega el TR al Tbody
	  LvarTbody.appendChild(LvarTR);
	  
	  if (Lclass.value=="ListaNon")
		Lclass.value="ListaPar";
	  else
		Lclass.value="ListaNon";
	}
	//Función para eliminar TRs
	function sbEliminarTR(e)
	{
	  vnContadorListas = vnContadorListas - 1;
	  
	  var LvarTR;

	  if (document.all)
		LvarTR = e.srcElement;
	  else
		LvarTR = e.currentTarget;
	
	  while (LvarTR.name != "XXXXX")
		LvarTR = LvarTR.parentNode;
		
	  LvarTR.parentNode.removeChild(LvarTR);
	}
	
	//Función para agregar Imagenes
	function sbAgregaTdImage (LprmTR, LprmClass, LprmNombre, align)
	{
	  // Copia una imagen existente
	  var LvarTDimg    = document.createElement("TD");
	  var LvarImg = document.getElementById(LprmNombre).cloneNode(true);
	  LvarImg.style.display="";
	  LvarImg.align=align;
	  LvarTDimg.appendChild(LvarImg);
	  if (LprmClass != "") LvarTDimg.className = LprmClass;
	
	  GvarNewTD = LvarTDimg;
	  LprmTR.appendChild(LvarTDimg);
	}
	
	//Función para agregar TDs con texto
	function sbAgregaTdText (LprmTR, LprmClass, LprmValue)
	{
	  var LvarTD    = document.createElement("TD");
	
	  var LvarTxt   = document.createTextNode(LprmValue);
	  LvarTD.appendChild(LvarTxt);
	  if (LprmClass!="") LvarTD.className = LprmClass;

	  GvarNewTD = LvarTD;

	  LvarTD.noWrap = true;
	  LprmTR.appendChild(LvarTD);
	}
	
	//Función para agregar TDs con Objetos
	function sbAgregaTdInput (LprmTR, LprmClass, LprmValue, LprmType, LprmName)
	{
	  var LvarTD    = document.createElement("TD");
	
	  var LvarInp   = document.createElement("INPUT");
	  LvarInp.type = LprmType;
	  if (LprmName!="") LvarInp.name = LprmName;
	  if (LprmValue!="") LvarInp.value = LprmValue;
	  LvarTD.appendChild(LvarInp);
	  if (LprmClass!="") LvarTD.className = LprmClass;
	  GvarNewTD = LvarTD;
	  LprmTR.appendChild(LvarTD);
	}
	
	function existeCodigoPuesto(v){
		var LvarTable = document.getElementById("tblpuesto");
		for (var i=0; i<LvarTable.rows.length; i++)
		{

			var value = new String(fnTdValue(LvarTable.rows[i]));
			
			var data = value.split('|');
			
			if (data[0] == v){
				return true;
			}
		}
		return false;
	}

	function existeCodigoCat(v){
		var LvarTable = document.getElementById("tblCat");
		for (var i=0; i<LvarTable.rows.length; i++)
		{

			var value = new String(fnTdValue(LvarTable.rows[i]));
			
			var data = value.split('|');
			
			if (data[0] == v){
				return true;
			}
		}
		return false;
	}

	function fnTdValue(LprmNode)
	{
	  var LvarNode = LprmNode;
	
	  while (LvarNode.hasChildNodes())
	  {
		LvarNode = LvarNode.firstChild;
		if (document.all == null)
		{
		  if (!LvarNode.firstChild && LvarNode.nextSibling != null &&
			LvarNode.nextSibling.hasChildNodes())
			LvarNode = LvarNode.nextSibling;
		}
	  }
	  if (LvarNode.value)
		return LvarNode.value;
	  else
		return LvarNode.nodeValue;
	}
	
	function verPuestos() {
		var a = document.getElementById("PuestosEsp");
		if (document.form1.CCPpuestosEspecificos.checked) {
			if (a) a.style.display = "";
		} else {
			if (a) a.style.display = "none";
		}
	}

	function verCat() {
		var a = document.getElementById("CategoriasEsp");
		if (document.form1.CCPcategoriasEspecificas.checked) {
			if (a) a.style.display = "";
		} else {
			if (a) a.style.display = "none";
		}
	}

	
	function deshabilitaCampos(){
		var LvarChk = document.getElementById("CCPporcsueldo");
		if (LvarChk.checked){
			document.form1.CCPmaxpuntos.disabled 		 = true;
			document.form1.CCPfactorpunto.disabled 		 = true;
			document.form1.CCPequivalenciapunto.disabled = true;
			document.form1.CCPfactorpunto.disabled 		 = true;
			document.form1.CCPpagoCada.disabled 		 = true;
			document.form1.UECPid.disabled 				 = true;
			document.form1.CCPacumulable.checked 		 = false;
			document.form1.CCPacumulable.disabled 		 = true;
			document.form1.CCPpuntofraccionable.checked  = false;
			document.form1.CCPpuntofraccionable.disabled = true;
		}else{
			document.form1.CCPmaxpuntos.disabled 		 = false;
			document.form1.CCPfactorpunto.disabled 		 = false;
			document.form1.CCPequivalenciapunto.disabled = false;
			document.form1.CCPpagoCada.disabled 		 = false;
			document.form1.UECPid.disabled 				 = false;
			document.form1.CCPacumulable.disabled 		 = false;
			document.form1.CCPpuntofraccionable.disabled = false;
		}
	}
	function deshabilitaAcumPC(){
		var LvarChk = document.getElementById("CCPacumulable");
		if (LvarChk.checked){	
			document.form1.CCPpagoCada.disabled = false;
		}else{
			document.form1.CCPpagoCada.value = '1.00';
			document.form1.CCPpagoCada.disabled = true;
		}
	}
	
	function funcCambioEquivalencia(prn_valorsel){
		if(prn_valorsel==10){ //La unidad de equivalencia es puntos
			document.form1.CCPequivalenciapunto.value = 1;
			document.form1.CCPequivalenciapunto.disabled = true;
		}
		else{
			document.form1.CCPequivalenciapunto.disabled = false;
		}
	}
	
	function funcAlta(){
		return funcValidar();
	}
	
	function funcCambio(){
		return funcValidar();
	}
	
	function funcValidar(){
		document.form1.CCPequivalenciapunto.disabled = false;
		document.form1.CCPpagoCada.disabled = false;
		if(parseFloat(document.form1.CCPpagoCada.value) <= 0.00 || parseFloat(document.form1.CCPequivalenciapunto.value) <= 0.00){
			<cfoutput>alert('#MSG_ValorCeroAcumulacionEquivalencia#');</cfoutput>
			return false;
		}		
		return true;
	}

	//Verificar siempre si esta seleccionada la unidad de equivalencia PUNTOS para desactivar el campo "Equivalencia en Puntos"
	if (document.form1.UECPid.value==10){
		document.form1.CCPequivalenciapunto.value = 1;
		document.form1.CCPequivalenciapunto.disabled = true;
	}
	
	deshabilitaAcumPC();
</script>
