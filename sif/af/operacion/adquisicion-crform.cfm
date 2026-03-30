<!--- Define el modo del mantenimiento --->
<cfif (isdefined("form.lin"))
		and (len(trim(form.lin)))
		and (form.lin gt 0)>
	<cfset MODO = "CAMBIO">
<cfelse>
	<cfset MODO = "ALTA">
</cfif>

<cfquery name="rs" datasource="#Session.DSN#">
			select isnull(Pvalor,1) as Pvalor 
			from Parametros 
			where Ecodigo = #Session.Ecodigo# 
				and Pcodigo = 200060 
</cfquery>
<cfset TipoPlaca = rs.Pvalor />

<!--- Define el Form.DAlinea cuando no viene en en el form, caso cuando viene de las lista de Af por Aplicar y no del Arbol o del SQL --->
<cfparam name="Form.DAlinea" default="#rsActivosAdq.DAlinea#">

<!--- Verifica si la relación está lista para ser aplicada --->
<cfset MensajeError = "">
<cfinclude template="adquisicion-aplicarelacion.cfm">

<!--- Almacenes --->
<cfquery name="rsAlmacenes" datasource="#Session.DSN#">
	select Aid, Bdescripcion
	from Almacen 
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
</cfquery>

<!--- Categorias --->
<cfquery name="rsCategorias" datasource="#Session.DSN#">
	select ACcodigo, ACdescripcion, ACmascara
	from ACategoria 
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
</cfquery>

<!--- Clases : se llenan automáticamente cuando cambia la categoria.--->
<cfquery name="rsClases" datasource="#Session.DSN#">
	select a.ACcodigo, a.ACid, a.ACdescripcion, a.ACdepreciable, a.ACrevalua, a.ACmascara
	from AClasificacion a
	where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
</cfquery>

<cfquery name="rsDSActivosAdq" datasource="#Session.DSN#">
		select  min(a.DSfechainidep) as DSfechainidep, min(a.DSfechainirev) as DSfechainirev
		from DSActivosAdq a 
		where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		  and a.EAcpidtrans = <cfqueryparam cfsqltype="cf_sql_char" value="#form.EAcpidtrans#">
		  and a.EAcpdoc = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.EAcpdoc#">
		  and a.EAcplinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.EAcplinea#">
		  and a.DAlinea =  <cfqueryparam cfsqltype="cf_sql_integer" value="#form.DAlinea#">
	</cfquery>
	
<!--- Consultas del modo cambio --->
<cfif (MODO neq "ALTA")>
	<cfquery name="rsDSActivosAdq" datasource="#Session.DSN#">
		select a.Ecodigo,a.EAcpidtrans, a.EAcpdoc, a.EAcplinea, a.DAlinea, a.lin, a.SNcodigo, a.Aid, a.ACcodigo, a.ACid, a.DSdescripcion, a.AFMid, a.AFMMid, 
			a.DSserie, a.DSplaca, a.DSfechainidep, a.DSfechainirev, a.DSmonto, a.Status, a.CFid, a.ts_rversion, a.Alm_Aid, a.DEid, 
			a.AFCcodigo, b.AFCcodigoclas, b.AFCdescripcion, b.AFCnivel as Nnivel, CRDRid
		from DSActivosAdq a 
			left outer join AFClasificaciones b 
				 on a.AFCcodigo = b.AFCcodigo 
				and a.Ecodigo = b.Ecodigo
		where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		  and a.EAcpidtrans = <cfqueryparam cfsqltype="cf_sql_char" value="#form.EAcpidtrans#">
		  and a.EAcpdoc = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.EAcpdoc#">
		  and a.EAcplinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.EAcplinea#">
		  and a.DAlinea =  <cfqueryparam cfsqltype="cf_sql_integer" value="#form.DAlinea#">
		  and a.lin = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.lin#">
	</cfquery>

 	<cfif (isdefined('rsDSActivosAdq')) 
			and (rsDSActivosAdq.recordCount) 
			and (len(trim(rsDSActivosAdq.ACcodigo))) 
			and (len(trim(rsDSActivosAdq.ACid)))>
			<cfquery name="rsCategoriaClase" datasource="#session.dsn#">
				select 
					a.ACatId idCategoria,
					b.AClaId idClase,
					a.ACcodigo, 
					b.ACid, 
					a.ACcodigodesc as Categoria, 
					a.ACdescripcion as Categoriadesc, 
					b.ACcodigodesc as Clasificacion, 
					b.ACdescripcion as Clasificaciondesc
				from AClasificacion b 
					inner join ACategoria a 
					   on a.ACcodigo = b.ACcodigo 
					  and a.Ecodigo = b.Ecodigo
				where b.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
				and b.ACid = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsDSActivosAdq.ACid#">
				and b.ACcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsDSActivosAdq.ACcodigo#">
			</cfquery>
	</cfif>
 	<cfif (isdefined('rsDSActivosAdq')) 
			and (rsDSActivosAdq.recordCount) 
			and (len(trim(rsDSActivosAdq.AFMid))) 
			and (len(trim(rsDSActivosAdq.AFMMid)))>
		<cfquery name="rsMarcaMod" datasource="#Session.DSN#">
			Select ma.AFMid
				, AFMMid
				, AFMcodigo
				, AFMdescripcion
				, AFMMcodigo
				, AFMMdescripcion
			from AFMarcas ma
				inner join AFMModelos mo
					 on mo.Ecodigo = ma.Ecodigo
					and mo.AFMid = ma.AFMid
			where ma.Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
				and ma.AFMid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsDSActivosAdq.AFMid#">
				and mo.AFMMid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsDSActivosAdq.AFMMid#">
		</cfquery>	
	</cfif>
 	<cfif (isdefined('rsDSActivosAdq'))
			 and (rsDSActivosAdq.recordCount) 
			 and (len(trim(rsDSActivosAdq.DEid)))>
		<cfquery name="rsEmpleadoAdq" datasource="#Session.DSN#">
			Select NTIcodigo, DEid, DEidentificacion,<cf_dbfunction name="concat" args="DEapellido1,' ',DEapellido2,' ',DEnombre"> as NombreEmp
			From DatosEmpleado
			Where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			and DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsDSActivosAdq.DEid#">
		</cfquery>
	</cfif>	
</cfif>

<!--- iframe para ejecutar validación especial de la placa --->
<iframe frameborder="1" name="fr" height="0" width="0" src="adquisicion-valplacas.cfm"></iframe>

<!--- Javascript --->
<script language="javascript" src="/cfmx/sif/js/utilesMonto.js"></script>
<script language="JavaScript" src="/cfmx/sif/js/qForms/qforms.js"></script>
<script language="JavaScript" src="/cfmx/sif/js/MaskApi/masks.js"></script>

<cfset LVarAction = 'adquisicion-crsql.cfm'>
<cfif isdefined("session.LvarJA") and session.LvarJA>
	<cfset LVarAction = 'adquisicion-crsql_JA.cfm'>
<cfelseif isdefined("session.LvarJA") and not session.LvarJA>    
    <cfset LVarAction = 'adquisicion-crsql_Aux.cfm'>
</cfif>

<!--- form --->
<form action="<cfoutput>#LVarAction#</cfoutput>" method="post" name="form1">
<cfoutput>
<!--- Tabla 1 --->
	<table width="100%"  border="0" cellspacing="0" cellpadding="0">
		<tr><td>&nbsp;</td></tr>
		<tr>
			<td rowspan="100" width="5%">&nbsp;</td>
			<td class="subTitulo" nowrap>
				<strong>Detalle de Separaci&oacute;n de Activos Adquiridos.</strong>
			</td>
			<td rowspan="100" width="5%">&nbsp;</td>
		</tr>
		<tr><td>&nbsp;</td></tr>
		<tr><!--- Datos Generales del Activo --->
			<td>
				<!---I--->
				<table width="100%"  border="0" cellspacing="0" cellpadding="0">
					<tr>
						<td width="15%" nowrap><strong>Activo&nbsp;:&nbsp;</strong></td>
						<td width="30%">#HTMLEditFormat(rsActivosAdq.EAdescripcion)#&nbsp;(#form.DAlinea#)</td>
						<td width="10%">&nbsp;&nbsp;&nbsp;</td>
						<td width="15%" nowrap><strong>Estado&nbsp;:&nbsp;</strong></td>
						<td width="30%">#rsActivosAdq.EAstatus#</td>
					</tr>
					
					<cfquery name="rsValmontosD_DAlinea" dbtype="query">
						select * 
						from rsValmontosD 
						where DAlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.DAlinea#">
					</cfquery>
					
					<tr>
						<td nowrap><strong>Monto Activo&nbsp;:&nbsp;</strong></td>
						<td>#LSCurrencyformat(rsValmontosD_DAlinea.DAmonto,'none')#</td>
						<td>&nbsp;</td>
						<td nowrap><strong>Monto L&iacute;neas&nbsp;:&nbsp;</strong></td>
						<td><cfif rsValmontosD_DAlinea.DSmonto neq rsValmontosD_DAlinea.DAmonto><span style="font-size: xx-small; font-weight: bold; "></cfif>#LSCurrencyformat(rsValmontosD_DAlinea.DSmonto,'none')#<cfif rsValmontosD_DAlinea.DSmonto neq rsValmontosD_DAlinea.DAmonto></span></cfif></td>
					</tr>
					<!---Línea en Blanco--->
					<tr>
						<td colspan="4">&nbsp;</td>
						<td>
							<cfif isdefined("rsDSActivosAdq.CRDRid") and len(trim(rsDSActivosAdq.CRDRid))>
								<cf_popup boton="true" url="/cfmx/sif/af/responsables/operacion/documento-Impr.cfm?CRDRid=#rsDSActivosAdq.CRDRid#" link="Consultar Doc." status="yes" resize="yes" scrollbars="yes" height="750" width="850" top="150" left="150">
							</cfif>
						</td>
					</tr>
					<tr>
						<td nowrap><strong>Descripci&oacute;n&nbsp;:&nbsp;</strong></td>
						<td>
							<input type="text" name="DSdescripcion" size="47" tabindex="1"
								maxlength="100" <cfif (MODO neq "ALTA")>value="#HTMLEditFormat(rsDSActivosAdq.DSdescripcion)#"</cfif>>
						</td>
						<td>&nbsp;</td>
                        
                        <!---SML. 06/03/2014. Parametro para la generación de mascara automatica---> 
						<cfquery name="rsMascaraAut" datasource="#session.DSN#">
							select Pvalor
							from Parametros 
							where Ecodigo = #session.Ecodigo#
		  							and Pcodigo = '200050'
						</cfquery>
                        
						<td nowrap><strong>Placa&nbsp;:&nbsp;</strong></td>
						<td nowrap>
							<table width="1%" border="0" cellspacing="0" cellpadding="0">
							  <tr>
								<td>
									<input type="text" name="DSplaca" size="15" tabindex="1"
										maxlength="20" style="text-transform:uppercase" onBlur="javascript:ValidarPlaca(document.form1.DSplaca.value);" <cfif isdefined("rsMascaraAut") and rsMascaraAut.Pvalor EQ 1 >readonly</cfif>>
								</td>
								<td>								
									<input type="text" name="DSplaca_text" size="20" tabindex="1"
										disabled readonly="true" class="cajasinbordeb">
								</td>
								<td>								
									<input type="text" name="DSplaca_text2" size="20" tabindex="1"
										disabled readonly="true" class="cajasinbordeb">
								</td>
							  </tr>
							</table>
						</td>
					</tr>
					<tr>
						<td nowrap><strong>Marca&nbsp;:&nbsp;</strong></td>
						<td rowspan="2">
							<cfif (MODO NEQ 'ALTA')
									and (isdefined('rsMarcaMod'))
									and (rsMarcaMod.recordCount)>
								<cf_sifmarcamod	query="#rsMarcaMod#" tabindexMar="1" tabindexMod="1">
							<cfelse>
								<cf_sifmarcamod  tabindexMar="1" tabindexMod="1">
							</cfif>
						</td>
						<td>&nbsp;</td>
					
						<td nowrap><strong>Categor&iacute;a&nbsp;:&nbsp;</strong></td>
						<td rowspan="2">
							<cfif (MODO NEQ 'ALTA') and (isdefined('rsCategoriaClase')) and (rsCategoriaClase.recordCount)>
								<cf_sifCatClase	query="#rsCategoriaClase#" tabindexCat="1" tabindexClas="1">
							<cfelse>
								<cf_sifCatClase tabindexCat="1" tabindexClas="1">
							</cfif>
						</td>				
					</tr>
					<tr>
						<td nowrap><strong>Modelo&nbsp;:&nbsp;</strong></td>
						<!--- Definido por tag de marca / modelo <td>&nbsp;</td> --->
						<td>&nbsp;</td>
						<td nowrap><strong>Clase&nbsp;:&nbsp;</strong></td>				
					</tr>
						
					<tr>
						<td nowrap><strong>Serie&nbsp;:&nbsp;</strong></td>
						<td>
							<input type="text" name="DSserie" size="47" tabindex="1"
								maxlength="50" <cfif (MODO neq "ALTA")>value="#rsDSActivosAdq.DSserie#"</cfif>>
						</td>
						<td>&nbsp;</td>
						<td nowrap><strong>Inicio Depreciaci&oacute;n&nbsp;:&nbsp;</strong></td>
						<td>
							<cfif (MODO neq "ALTA")>
								<cf_sifcalendario name="DSfechainidep" value="#Dateformat(rsDSActivosAdq.DSfechainidep,'dd/mm/yyyy')#" tabindex="1" readOnly="true">
							<cfelse>
								<cf_sifcalendario name="DSfechainidep" value="#Dateformat(rsDSActivosAdq.DSfechainidep,'dd/mm/yyyy')#" tabindex="1" readOnly="true">
							</cfif>
						</td>
					</tr>
					<tr>
						<td nowrap><strong>Monto&nbsp;:&nbsp;</strong></td>
						<td>
							<input type="text" name="DSmonto" tabindex="1"
									<cfif (MODO neq "ALTA")>value="#lscurrencyformat(rsDSActivosAdq.DSmonto,'none')#"<cfelse>value="0.00"</cfif>
									size="30" maxlength="22" style="text-align:right "
									onBlur	=	"javascript:	if(validaNumero(this,2))	{formatCurrency(this,2);}"
									onFocus	=	"javascript:	this.select();"
									onKeyUp	=	"javascript:	if(snumber(this,event,2))	{if(Key(event)=='13') {this.blur();}};">
						</td>
						<td>&nbsp;</td>
						<td nowrap><strong>Inicio Revaluaci&oacute;n&nbsp;:&nbsp;</strong></td>
						<td>
							<cfif MODO neq "ALTA">
								<cf_sifcalendario name="DSfechainirev" value="#Dateformat(rsDSActivosAdq.DSfechainirev,'dd/mm/yyyy')#" tabindex="1" readOnly="true">
							<cfelse>
								<cf_sifcalendario name="DSfechainirev" value="#Dateformat(rsDSActivosAdq.DSfechainirev,'dd/mm/yyyy')#" tabindex="1" readOnly="true">
							</cfif>
						</td>
					</tr>
					<tr>
						<td nowrap><strong>Centro Funcional&nbsp;:&nbsp;</strong></td>
						<td>
							<cfif (MODO NEQ "ALTA")
									and (isdefined('rsDSActivosAdq'))
									and (rsDSActivosAdq.recordCount)
									and (len(trim(rsDSActivosAdq.CFid)))>
								<cfquery name="rsCFuncional" datasource="#Session.DSN#">
									select  CFid, CFcodigo, CFdescripcion
									from CFuncional
									where CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsDSActivosAdq.CFid#">
								</cfquery>
								<cf_rhcfuncional form="form1" id="CFid" tabindex="1" name="CFcodigo" desc="CFdescripcion" of="#rsActivosAdq.Ocodigo#" query="#rsCFuncional#">
							<cfelse>
								<cf_rhcfuncional form="form1" id="CFid" tabindex="1" name="CFcodigo" desc="CFdescripcion" of="#rsActivosAdq.Ocodigo#">
							</cfif>
						</td>
						<td>&nbsp;</td>
						<td nowrap><strong>Tipo&nbsp;:&nbsp;</strong></td>
						<td><cfif modo neq 'ALTA'>
							<cf_siftipoactivo query="#rsDSActivosAdq#" tabindex="1">
							<cfelse>
							<cf_siftipoactivo tabindex="1">
							</cfif>&nbsp;</td>
					</tr>
					<!---Línea en Blanco---><tr><td colspan="5">&nbsp;</td></tr>
					<tr>
						<td colspan="5">
						<fieldset><legend>Responsable</legend>
							<table width="100%"  border="0" cellspacing="0" cellpadding="0">
								<tr>
									<td nowrap><strong>Empleado&nbsp;:&nbsp;</strong></td>
									<td>
										<cfif (isdefined('rsEmpleadoAdq'))
												and (rsEmpleadoAdq.RecordCount)>
											<cf_rhempleado size="47" query="#rsEmpleadoAdq#" tabindex="1">
										<cfelse>
											<cf_rhempleado size="47" tabindex="1">
										</cfif>
									</td>
									<td rowspan="2" class="Ayuda">Al seleccionar el Empleado <br>se sugiere el Centro Funcional <br>al que pertenece el mismo.</td>
								</tr>
								<tr>
									<td nowrap><strong>Almac&eacute;n&nbsp;:&nbsp;</strong></td>
									<td nowrap>
										<select name="Alm_Aid" tabindex="1">
											<option value=""></option>
											<cfloop query="rsAlmacenes"> 
											<option value="#rsAlmacenes.Aid#" <cfif (MODO NEQ "Alta") and (Aid eq rsDSActivosAdq.Alm_Aid)>selected</cfif>>#HTMLEditFormat(rsAlmacenes.Bdescripcion)#</option>
											</cfloop> 
										</select>
									</td>
								</tr>
							</table>
						</fieldset>	
						</td>
					</tr>
					<!---===Datos Variables===--->
					<tr><td colspan="5">&nbsp;</td></tr>
					<tr>
						<td colspan="5">
						<cfif modo NEQ 'ALTA' and isdefined('rsDSActivosAdq') and (rsDSActivosAdq.recordCount) 
							and len(trim(rsDSActivosAdq.ACcodigo)) and len(trim(rsDSActivosAdq.ACid))>
							
							<fieldset><legend>Otros Datos</legend>
									<input type="hidden" name="AF_CATEGOR" value="#rsCategoriaClase.idCategoria#" />
									<input type="hidden" name="AF_CLASIFI" value="#rsCategoriaClase.idClase#" />
									<cfset Tipificacion = StructNew()> 
									<cfset temp = StructInsert(Tipificacion, "AF", "")> 
									<cfset temp = StructInsert(Tipificacion, "AF_CATEGOR", "#rsCategoriaClase.idCategoria#")> 
									<cfset temp = StructInsert(Tipificacion, "AF_CLASIFI", "#rsCategoriaClase.idClase#")> 
								<cfinvoke component="sif.Componentes.DatosVariables" method="PrintDatoVariable" returnvariable="Cantidad">
									<cfinvokeargument name="DVTcodigoValor" value="AF">
									<cfinvokeargument name="Tipificacion"   value="#Tipificacion#">
									<cfinvokeargument name="DVVidTablaVal"  value="#form.lin#">
									<cfinvokeargument name="form" 			value="form1">
									<cfinvokeargument name="NumeroColumas"  value="3">
									<cfinvokeargument name="DVVidTablaSec" 	value="2"><!---(0=Activos)(1=CRDocumentoResponsabilidad) (2=DSActivosAdq)--->
								</cfinvoke>
								<cfif Cantidad EQ 0>
									<div align="center">No Existen Datos Variables Asignados al Activo</div>
								</cfif>
							</fieldset>
						</cfif>
						</td>
					</tr>
					<!---Línea en Blanco---><tr><td colspan="5">&nbsp;</td></tr>
					<cfset regresa = 'adquisicion-lista.cfm'>
                    <cfif isdefined("session.LvarJA") and session.LvarJA>
						<cfset regresa = 'adquisicion-lista_JA.cfm'>
                    <cfelseif isdefined("session.LvarJA") and not session.LvarJA>    
                        <cfset regresa = 'adquisicion-lista_Aux.cfm'>
                    </cfif>
					<tr><td colspan="5" align="center"> <cf_botones modo="#MODO#" tabindex="1" regresar="#regresa#"> </td></tr>
					<!---Línea en Blanco---><tr><td colspan="5">&nbsp;</td></tr>
					<tr height="150">
						<td colspan="5">
							<table width="100%"  border="0" cellspacing="0" cellpadding="0" class="ayuda">
								<tr>
								<td valign="middle" align="center" width="30%"><input tabindex="1" type="submit" name="btnPreparar_Relacion" value="Preparar Relación" <cfif (len(trim(MensajeError)))>disabled</cfif> onClick="javascript:if (!!window.deshabilitarValidacion) deshabilitarValidacion();" class="btnNormal"></td>
								<td valign="middle" align="center" width="70%" height="168">
									<table width="75%" align="center"  border="0" cellspacing="0" cellpadding="0">
										<tr>
										<td>
											<p align="justify">
												Este botón permite preparar la relación para ser aplicada, debe realizar este paso para poder aplicar la relación.<br> 
												<cfif (len(trim(MensajeError)))>Este botón se encuentra deshabilitado por los motivos que se describen aquí: #MensajeError#</cfif>
											</p>
											
										</td>
										</tr>
									</table>
								</td>
								</tr>
							</table>
						</td>
					</tr>
					<!---Línea en Blanco---><tr><td colspan="5">&nbsp;</td></tr>
				</table>
			<!---F--->
			</td>
		</tr>

		<!---Campos Ocultos--->
		<input type="hidden" name="EAcpidtrans" value="#form.EAcpidtrans#"> 
		<input type="hidden" name="EAcpdoc" value="#form.EAcpdoc#"> 
		<input type="hidden" name="EAcplinea" value="#form.EAcplinea#"> 
		<input type="hidden" name="DAlinea" value="#form.DAlinea#"> 
		<cfif MODO NEQ "ALTA">
			<input type="hidden" name="lin" value="#rsDSActivosAdq.lin#"> 
			<cfset ts = ""> 
					<cfinvoke 
					component="sif.Componentes.DButils"
					method="toTimeStamp"
					returnvariable="ts">
				<cfinvokeargument name="arTimeStamp" value="#rsDSActivosAdq.ts_rversion#"/>
			</cfinvoke>
			<input type="hidden" name="ts_rversion" value="#ts#"> 
		</cfif>
	
	<!--- Fin de la Tabla 1 --->
	</table>
	</cfoutput>

<!--- Fin del Form1--->
</form>

<!--- Iframe --->
<iframe id="frXDECFid" name="frXDECFid" marginheight="0" marginwidth="0" frameborder="1" height="0" width="0" scrolling="auto" src="" ></iframe>

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
	// crea el objeto Mask	
	oStringMask = new Mask("");
	oStringMask.attach(objform.DSplaca.obj,oStringMask.mask,"string","ValidarPlaca(document.form1.DSplaca.value);");

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
				<cfif MODO NEQ "ALTA" and #rsClases.ACid# EQ #rsDSActivosAdq.ACid#>
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

	function funcACcodigo(codigo){
		<cfif TipoPlaca NEQ 2>
			CambiarMascara(codigo);
		</cfif>
	}
	
	function funcACid(codigo){
		<cfif TipoPlaca EQ 2>
			CambiarMascara(codigo);
		</cfif>
	}
	
	function CambiarMascara(codigo){
		var mascara = "";
		objform.DSplaca.obj.value="";
		objform.DSplaca_text.obj.value="";
		codigo = codigo.value;
		
		<cfif TipoPlaca EQ 2>
			<cfoutput query="rsClases">
				if (#Trim(ACid)#==trim(codigo)){
					mascara = '#Trim(ACmascara)#';
				}
			</cfoutput>
		<cfelse>
			<cfoutput query="rsCategorias">
				if (#Trim(ACcodigo)#==trim(codigo)){
					mascara = '#Trim(ACmascara)#';
				}
			</cfoutput>
		</cfif>	
		if (mascara.length > 0) {
			var strErrorMsg="El valor de la placa no concuerda con el formato "+mascara;
			/*
			objform.DSplaca.validateformat("phone number");
			objform.DSplaca.validate=true;
			*/

			oStringMask.mask = mascara.replace(/X/g,"*");
			
			objform.DSplaca.obj.disabled=false;
			objform.DSplaca_text.obj.value=mascara.replace(/X/g,"X");
			return true;
		}
		objform.DSplaca.obj.disabled=true;
		objform.DSplaca.obj.value='';
	}
	
	function ValidarPlaca(placa) {
		document.all["fr"].src="adquisicion-valplacas.cfm?placa="+placa;
	}
	
	//Descripciones
	objform.DSdescripcion.description = "<cfoutput>#JSStringFormat('Descripción')#</cfoutput>";
	objform.AFMid.description = "<cfoutput>#JSStringFormat('Marca')#</cfoutput>";
	objform.AFMMid.description = "<cfoutput>#JSStringFormat('Modelo')#</cfoutput>";
	objform.DSserie.description = "<cfoutput>#JSStringFormat('Serie')#</cfoutput>";
	objform.DSmonto.description = "<cfoutput>#JSStringFormat('Monto')#</cfoutput>";
	objform.DSplaca.description = "<cfoutput>#JSStringFormat('Placa')#</cfoutput>";
	objform.ACcodigo.description = "<cfoutput>#JSStringFormat('Categoria')#</cfoutput>";
	objform.ACid.description = "<cfoutput>#JSStringFormat('Clase')#</cfoutput>";
	objform.DSfechainidep.description = "<cfoutput>#JSStringFormat('Fecha de inicio de la depreciación.')#</cfoutput>";
	objform.DSfechainirev.description = "<cfoutput>#JSStringFormat('Fecha de inicio de la revaluación.')#</cfoutput>";
	objform.CFid.description = "<cfoutput>#JSStringFormat('Centro Funcional')#</cfoutput>";
	objform.DEid.description = "<cfoutput>#JSStringFormat('Empleado.')#</cfoutput>";
	objform.Alm_Aid.description = "<cfoutput>#JSStringFormat('Almacén.')#</cfoutput>";
	objform.AFCcodigo.description = "<cfoutput>#JSStringFormat('Tipo.')#</cfoutput>";

	//habilita inhabilita validaciones
	function deshabilitarValidacion(){
		objform.DSdescripcion.required = false;
		objform.AFMid.required = false;
		objform.AFMMid.required = false;
		//objform.DSserie.required = false;
		objform.DSmonto.required = false;
		objform.DSplaca.required = false;
		objform.ACcodigo.required = false;
		objform.ACid.required = false;
		objform.DSfechainidep.required = false;
		objform.DSfechainirev.required = false;
		objform.CFid.required = false;
		objform.AFCcodigo.required = false;
		objform.allowsubmitonerror = true;
		//objform.DEid.required = false;
		//objform.Alm_Aid.required = false;
	}

	function habilitarValidacion(){
		objform.DSdescripcion.required = true;
		objform.AFMid.required = true;
		objform.AFMMid.required = true;
		//objform.DSserie.required = true;
		objform.DSmonto.required = true;
		objform.DSplaca.required = true;
		objform.ACcodigo.required = true;
		objform.ACid.required = true;
		objform.DSfechainidep.required = true;
		objform.DSfechainirev.required = true;
		objform.CFid.required = true;
		objform.AFCcodigo.required = true;
		objform.allowsubmitonerror = false;
		//objform.DEid.required = true;
		//objform.Alm_Aid.required = true;
	}
	
	//campos requeridos
	habilitarValidacion();

	//validaciones adicionales
	function _customValidations(){
		if (objform.allowsubmitonerror==false) {
			if (objform.botonSel.getValue()!='Nuevo'&&objform.botonSel.getValue()!='Baja') {
				if (objform.DEid.getValue()==""&&objform.Alm_Aid.getValue()==""){
					objform.DEid.throwError("Debe definir un responsable, un empleado o un almacén.");
				}
				if (objform.DEid.getValue()!=""&&objform.Alm_Aid.getValue()!=""){
					objform.DEid.throwError("Debe definir un único responsable, no puede ser un empleado y un almacén.");
				}
			}
		}
		if ((objform._queue.errors).length <= 0) {
			//no hubo errores
			objform.DSmonto.obj.value = qf(objform.DSmonto.obj.value);
		}
	}

	objform.onValidate = _customValidations;
	objform.DEid.onchange = new Function("return limpiarAlmacen();");
	objform.Alm_Aid.onchange = new Function("return limpiarEmpleado();");
	
	function limpiarAlmacen(){
		objform.Alm_Aid.obj.selected = null;
	}
	
	function limpiarEmpleado(){
		objform.DEid.obj.value = "";
		objform.DEidentificacion.obj.value = "";
		objform.NombreEmp.value = "";		
	}
	
	/*AgregarCombo(document.form1.ACcodigo);*/
	<cfif TipoPlaca EQ 2>
			CambiarMascara(document.form1.ACid);
	<cfelse>
		CambiarMascara(document.form1.ACcodigo);
	</cfif>
	<cfif (MODO neq "ALTA")>
			objform.DSplaca.obj.value="<cfoutput>#Trim(rsDSActivosAdq.DSplaca)#</cfoutput>"
			ValidarPlaca(objform.DSplaca.getValue());
	</cfif> 

	function funcDEid(){
		window.ctlcfid = document.form1.CFid;
		window.ctlcfcodigo = document.form1.CFcodigo;
		window.ctlcfdesc = document.form1.CFdescripcion;
		if (objform.DEid.getValue() != "" +/*cat*/ objform.DEidentificacion.getValue() != "" ) {
			var fr = document.getElementById("frXDECFid");
			fr.src = "adquisicion-cfid.cfm?DEid=" + document.form1.DEid.value;
		} else {
			document.form1.CFid.value="";
			document.form1.CFcodigo.value="";
			document.form1.CFdescripcion.value="";
		}
		return true;
	}

	objform.DSdescripcion.obj.focus();
	
		
	//-->
</script>
