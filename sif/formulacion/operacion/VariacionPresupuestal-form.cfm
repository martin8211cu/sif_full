<cfset EncabezadoEst = FPRES_EstimacionGI.GetEncabezadoEstimacion(#session.DSN#,#form.FPEEid#, #prefijoHV#)>
<cfset PlantillasCF	 = PlantillaFormulacion.GetPlantillasCF(#session.DSN#,#EncabezadoEst.CFid#)>
<cfparam name="isResponsables" default="false">
<cfif EncabezadoEst.CFuresponsable EQ session.Usucodigo>
	<cfset isResponsables = true>
</cfif>
<cfset LvarFPEPid = "-1">
<cfif ModoDet EQ 'CAMBIO'>
	<cfset DetalleEst = FPRES_EstimacionGI.GetDetalleEstimacion(#session.DSN#,#form.FPEEid#,#form.FPEPid#,#form.FPDElinea#,#prefijoHV#)>
</cfif>
<cfif ListFind('0,-1', EncabezadoEst.FPTVTipo)>
	<cfset fechaValida = FPRES_EstimacionGI.FechaLimiteValida(EncabezadoEst.FPEEFechaLimite)>
<cfelse>
	<cfset fechaValida = true>
</cfif>
<cfif EncabezadoEst.FPEEestado EQ 0 and not request.RolAdmin and not ((EncabezadoEst.FPTVTipo eq '2' or EncabezadoEst.FPTVTipo eq '3') and PlantillasCF.FPCCtipo eq 'I')>
	<cfif fechaValida>
		<cfset ButonAction = '<input name="imageField" type="image" src="../../imagenes/Borrar01_S.gif" width="16" height="16" border="0" onclick="return changeFormActionforDetalles(''#_Cat##V_FPEEid##_Cat#'',''#_Cat##V_FPEPid##_Cat#'',''#_Cat##V_FPDElinea##_Cat#'',''#_Cat##V_FPCCid##_Cat#'');">'>
	<cfelse>
		<cfset ButonAction=''> 
	</cfif>
	<cfset ButonNotes = '<input name="imageField" type="image" src="../../imagenes/notas2.gif" alt="Notas" width="16" height="16" border="0" onclick="DisplayNote(''#_Cat##V_FPEEid##_Cat#'',''#_Cat##V_FPEPid##_Cat#'',''#_Cat##V_FPDElinea##_Cat#'');">'>
<cfelseif EncabezadoEst.FPEEestado NEQ 0 and request.RolAdmin>
	<cfset ButonAction = "">
	<cfset ButonNotes = '<input name="imageField" type="image" src="../../imagenes/notas2.gif" alt="Notas" width="16" height="16" border="0" onclick="DisplayNote(''#_Cat##V_FPEEid##_Cat#'',''#_Cat##V_FPEPid##_Cat#'',''#_Cat##V_FPDElinea##_Cat#'');">'>
<cfelseif EncabezadoEst.FPEEestado EQ 0 and request.RolAdmin and EncabezadoEst.FPTVTipo eq '4'>
	<cfset ButonAction = '<input name="imageField" type="image" src="../../imagenes/Borrar01_S.gif" width="16" height="16" border="0" onclick="return changeFormActionforDetalles(''#_Cat##V_FPEEid##_Cat#'',''#_Cat##V_FPEPid##_Cat#'',''#_Cat##V_FPDElinea##_Cat#'',''#_Cat##V_FPCCid##_Cat#'');">'>
	<cfset ButonNotes = ''>
<cfelse>
	<cfset ButonAction = "">
	<cfset ButonNotes  = "">
</cfif>

<cfquery name="rsMonedaLocal" datasource="#Session.DSN#">
	select Mcodigo 
		from Empresas 
	where Ecodigo = #Session.Ecodigo#
</cfquery>

<cfquery name="TCsug" datasource="#Session.DSN#">
	select tc.Mcodigo, tc.TCcompra, tc.TCventa
	from Htipocambio tc
	where tc.Ecodigo = #Session.Ecodigo#
		and tc.Hfecha  <= <cfqueryparam cfsqltype="cf_sql_date" value="#now()#">
		and tc.Hfechah > <cfqueryparam cfsqltype="cf_sql_date" value="#now()#">
</cfquery>
<cfoutput>
	<table border="0" cellpadding="0" cellspacing="0" align="center">
		<tr align="center">
			<td colspan="2">Estimación de Gastos e Ingresos para #EncabezadoEst.tipo# #EncabezadoEst.Pdescripcion#
			</td>
		</tr>
		<tr align="center">
			<td colspan="2"><strong>Centro Funcional:</strong> 
			<a href="javascript:fnOcultar_CF(true)" id="cf_a" style="display: inline;">#EncabezadoEst.CFdescripcion#</a>
			<form style="display: none;" name="cf_form" id="cf_form" action="#CurrentPage#" method="post">
				<input name="FPEPid" type="hidden" id="FPEPid" value="">
				<input type="hidden" name="tab" value="-1" />
				<cfinvoke component="sif.Componentes.FP_SeguridadUsuario" method="fnGetCFs" returnvariable="CFuncionales" Usucodigo="#session.Usucodigo#" orderby="CFdescripcion"></cfinvoke>
				<select name="FPEEid" onchange="this.form.submit()">
			  	<cfloop query="CFuncionales">
					<cfquery name="rsEE" datasource="#session.DSN#">
					select FPEEid
					from FPEEstimacion
					where Ecodigo   = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
					  and FPEEestado in (0,1,2,3,4,5,6)
					  and CFid = #CFuncionales.CFid#
					  and CPPid = #EncabezadoEst.CPPid#
					</cfquery>
					<cfif len(trim(rsEE.FPEEid))>
						<option value="#rsEE.FPEEid#" <cfif CFuncionales.CFid eq EncabezadoEst.CFid>selected</cfif>>#CFuncionales.CFdescripcion#</option>
					</cfif>
			  	</cfloop>
			  	</select>
            </form>
			<strong>Oficina:</strong> #EncabezadoEst.Ofidescripcion#</td>
		</tr>
		<tr align="center">	
			<cfif len(trim(EncabezadoEst.FPTVid))>
				<cfquery name="rsVariacion" datasource="#session.dsn#">
					select FPTVDescripcion from TipoVariacionPres
					where Ecodigo = #session.Ecodigo# and FPTVid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#EncabezadoEst.FPTVid#">
				</cfquery>
			</cfif>
			<td colspan="2"><cfif isdefined('rsVariacion')><strong>Tipo Variación:</strong> #rsVariacion.FPTVDescripcion#</cfif></td>
		</tr>
		<tr align="center">	
		<td colspan="2">
			<cfif isdefined('PlantillasCF') and PlantillasCF.recordcount>
				<cfloop query="PlantillasCF">
					<cfif (url.tab EQ PlantillasCF.currentrow or form.FPEPID EQ PlantillasCF.FPEPID) and len(trim(PlantillasCF.FPEPnotas))>
							<cf_notas titulo="Notas del Administrador" link="Notas del Administrador" pageIndex="1" msg = "#PlantillasCF.FPEPnotas#" animar="true">
					</cfif>
				</cfloop>
			</cfif>
		</td>
		</tr>
			<cfquery name="HV" datasource="#session.DSN#">
				select Version from VFPEEstimacion where FPEEid = #EncabezadoEst.FPEEid#
			</cfquery>
			<cfif HV.Recordcount GT 0>
				<tr align="left">
					<td colspan="2">
						<a href="javascript:fnOcultar_HV(true)" id="HV_a" style="display: inline;">
							<cfif form.HV EQ 0> Version Original <cfelse>Version #form.HV#</cfif>
						</a>
						<form style="display: none;" name="HV_form" id="HV_form" action="#CurrentPage#" method="post">
							<input name="FPEPid" type="hidden" id="FPEPid" value="#form.FPEPid#">
							<input name="FPEEid" type="hidden" id="FPEPid" value="#EncabezadoEst.FPEEid#">
							<input type="hidden" name="tab" value="#form.tab#"/>
							
							<select name="HV" onchange="this.form.submit()">
									<option value="0" <cfif form.HV EQ  0>selected</cfif>>Versión Original</option>
								<cfloop query="HV">
									<option value="#HV.Version#" <cfif form.HV EQ HV.Version>selected</cfif>>Versión #HV.Version#</option>
								</cfloop>
							</select>
						</form>
					</td>
				</tr>
			</cfif>
		
		<tr align="center">
			<td colspan="2">
				<form name="frm2" action="Equilibrio.cfm" method="post">
					<input type="hidden" name="FPEEid" 	 value="#form.FPEEid#" />
					<input type="hidden" name="tabIni" 	 value="" />
					<input type="hidden" name="tab" 	 value="" />
					<input type="hidden" name="HV"		 value="#form.HV#" 	id="HV"/>
					<cfif isdefined('form.Equilibrio')>
						<input type="hidden" name="CPPid" 	 	value="#EncabezadoEst.CPPid#" />
						<input type="hidden" name="Equilibrio" 	value="true" />
						<input type="submit" name="regersar" 	value="Regresar A Equilibrio" class="btnAnterior" />
					</cfif>
				</form>
			</td>
		</tr>
		<tr>
	
			<td align="center" colspan="2">
				<cfif EncabezadoEst.FPTVTipo eq 0 and not request.RolAdmin >
					<cfquery name="ExisteProcesoPendiente" datasource="#session.dsn#">
						select count(1) as existe
							from FPEEstimacion a
							inner join TipoVariacionPres b on b.FPTVid = a.FPTVid
						where a.Ecodigo = #Session.Ecodigo#
							and CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#EncabezadoEst.CFid#">
							and CPPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#EncabezadoEst.CPPid#">
							and FPTVTipo in (1,2,3)
							and FPEEestado in (0,1,2,3,4,5)
					</cfquery>
					<cfif ExisteProcesoPendiente.existe gt 0>
						<span class="msgError">Existen variaciones pendientes de aprobar para este centro funcional y periódo presupuestal.<br />Para continuar con este proceso deberá de descartar la variación pendiente o finalizarla</span>
						</td></tr>
						<tr><td align="center">
							<button class="btnAnterior"  onclick="fnRgresar('#CurrentPage#')">Regresar</button>
						</td>
						</tr>
						</table>
						<script language="javascript1.2" type="text/javascript">
							function fnRgresar(CurrentPage){
								location.href = CurrentPage;
								return true;
							}
						</script>	
						<cfreturn>
					</cfif>
				</cfif>
				<cfif EncabezadoEst.FPEEestado EQ 0  and PlantillasCF.recordCount GT 0 and fechaValida and (isResponsables or request.RolAdmin)>
					<cfif EncabezadoEst.FPTVTipo eq 4>
						<button class="btnAplicar"  onclick="fnPopUpGrupal(#form.FPEEid#)">Aprobar Grupal</button>
					<cfelse>
				 		<button class="btnAplicar"  onclick="fnSubmitButon('btnEnviarAprobar',#form.FPEEid#,#url.tab#,'#CurrentPage#')">Enviar a Aprobar</button>
					</cfif>
					<button class="btnNormal"  onclick="fnCongelar(#form.FPEEid#)">Congelar</button>
				<cfelseif EncabezadoEst.FPEEestado EQ 0 and not request.RolAdmin and PlantillasCF.recordCount GT 0 and not fechaValida>
					<span class="msgError">La fecha lim&iacute;te para el envio de la Estimación Presupuestal se ha sobrepasado, comuniquese con el administrador del presupuesto</span>#EncabezadoEst.FPEEFechaLimite#.
				 <cfelseif EncabezadoEst.FPEEestado EQ 1 and request.RolAdmin and PlantillasCF.recordCount GT 0 and listfind('0',form.HV)>
					<button class="btnAplicar"  onclick="fnSubmitButon('btnAprobar',#form.FPEEid#,#url.tab#,'#CurrentPage#')">Aprobar</button>
					<button class="btnEliminar" onclick="fnSubmitButon('btnRechazar',#form.FPEEid#,#url.tab#,'#CurrentPage#')">Rechazar</button>
				<cfelseif EncabezadoEst.FPEEestado EQ 2 and request.RolAdmin and PlantillasCF.recordCount GT 0>
					<button class="btnEliminar" onclick="fnSubmitButon('btnRechazar',#form.FPEEid#,#url.tab#,'#CurrentPage#')">Devolver a Preparación</button>
				<cfelseif EncabezadoEst.FPEEestado EQ 1 and request.RolAdmin and PlantillasCF.recordCount GT 0 and listfind('0',form.HV)>
					<button class="btnAplicar"  onclick="fnSubmitButon('btnAprobar',#form.FPEEid#,#url.tab#,'#CurrentPage#')">Aprobar</button></button>
				<cfelseif EncabezadoEst.FPEEestado EQ 0 and request.RolAdmin and PlantillasCF.recordCount GT 0 and ListFind('0', EncabezadoEst.FPTVTipo)>
					<table border="0" cellpadding="0" cellspacing="0">
						<tr>
							<form name="frmFecha" action="EstimacionGI-sql.cfm" method="post" onsubmit="return fnCambioFecha(this);">
								<input type="hidden" name="FPEEid_key" value="#form.FPEEid#" />
								<input type="hidden" name="btnModificarFecha" value="true" />
								<input type="hidden" name="fechaIni" value="#dateformat(EncabezadoEst.FPEEFechaLimite,'dd/mm/yyyy')#" />
								<input type="hidden" name="tab" value="#url.tab#" />
								<input type="hidden" name="CurrentPage" value="#CurrentPage#" />
								<td>
								Fecha l&iacute;mite:&nbsp;</td><td><cf_sifcalendario form="frmFecha" name="fecha" value="#dateformat(EncabezadoEst.FPEEFechaLimite,'dd/mm/yyyy')#"></td>
								<td><button type="submit" class="btnGuardar">Modificar</button>
								</td>
							</form>
						<tr>
					</table>
				 </cfif>
			</td>
		</tr>
		<cfif PlantillasCF.recordCount GT 0 and  EncabezadoEst.FPEEestado EQ 0 and ( isResponsables or request.RolAdmin)>
			<tr>
				<td align="center" colspan="2">
					<button type="submit" class="btnEliminar" onclick="fnSubmitButon('btnDescartar',#form.FPEEid#,#url.tab#,'#CurrentPage#')">Descartar Estimación</button>
				</td>
			</tr>
		</cfif>
	<cfif PlantillasCF.recordCount GT 0>
		<cfquery name="rsYaCargados" datasource="#session.dsn#">
			select count(1) as cantidad
			from FPDEstimacion
			where FPEEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.FPEEid#">
			and PCGDid is not null
		</cfquery>
		<cfquery name="rsConPlan" datasource="#session.dsn#">
			select count(1) cantidad
				from PCGplanCompras E 
					inner join PCGDplanCompras  D 
						on E.PCGEid = D.PCGEid 
			where E.CPPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#EncabezadoEst.CPPid#"> 
			  and D.CFid  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#EncabezadoEst.CFid#"> 
		</cfquery>
		<cfif (not request.RolAdmin or (request.RolAdmin and EncabezadoEst.FPTVTipo eq 4)) and rsConPlan.cantidad GT 0 and rsYaCargados.cantidad EQ 0>
		<tr><td align="center" colspan="2">
		<button type="submit" class="btnNormal" style="background-image:url(/cfmx/sif/imagenes/addressGo.gif); background-repeat:no-repeat; background-position:left;margin-left:5px; margin-right:5px;margin-top:2px; margin-bottom:2px;padding-left:18px;text-align:center;" onclick="fnSubmitButon('btnAgregardetalles',#form.FPEEid#,#url.tab#,'#CurrentPage#')">Cargar Detalles</button></td></tr>
		</td></tr>
		</cfif>
		<cfif (not listfind('1,2',EncabezadoEst.FPEEestado) and not request.RolAdmin ) or (EncabezadoEst.FPEEestado EQ 2 and request.RolAdmin)>
		<form name="formLocalizar" method="post" action="#CurrentPage#" onsubmit="return fnValidar(this);">
			<input name="tab"		 		type="hidden"	id="tab" 	 			value="#url.tab#"/>
			<input name="FPEEid" 	   		type="hidden" 	id="FPEEid"				value="#form.FPEEid#"/>
			<input name="FPEPid" 	   		type="hidden" 	id="FPEPid" 			value="#form.FPEPid#">
			<input name="HV"		  		type="hidden"   id="HV"		   		    value="#form.HV#"/>
		<tr align="center"><td align="center">
			<table border="0" cellpadding="0" cellspacing="0"><tr>
				<td><strong>Clasificaci&oacute;n:&nbsp;</strong></td>
					<td nowrap>
					<cfset valuesArray="">
					<cfif isdefined('form.FPCCid_Loc')>
						<cfset valuesArray = ListtoArray('#form.FPCCid_Loc# ¬ #form.FPCCcodigo_Loc# ¬ #form.FPCCdescripcion_Loc#', '¬')>
					</cfif>
					<cf_conlis
						Campos="FPCCid_Loc, FPCCcodigo_Loc, FPCCdescripcion_Loc"
						valuesArray="#valuesArray#"
						Desplegables="N,S,S"
						Modificables="N,S,N"
						Size="0,10,30"
						Title="Lista de Clasificación de Conceptos de Financiamiento y Egresos"
						Tabla="FPCatConcepto"
						Columnas="FPCCid as FPCCid_Loc, 
								  FPCCcodigo as FPCCcodigo_Loc, 
								  FPCCdescripcion as FPCCdescripcion_Loc"
						Filtro="Ecodigo = #Session.Ecodigo#
						order by FPCCcodigo, FPCCdescripcion"
						Desplegar="FPCCcodigo_Loc, FPCCdescripcion_Loc"
						Etiquetas="Código,Descripción"
						filtrar_por="FPCCcodigo, FPCCdescripcion"
						Formatos="S,S,S"
						Align="left,left,left"
						Asignar="FPCCid_Loc, FPCCcodigo_Loc, FPCCdescripcion_Loc"
						Asignarformatos="I,S,S"
						form="formLocalizar"
						MaxRowsQuery="1500"
						MaxRows="40"/>
					</td>
					<td><button type="submit" class="btnFiltrar" name="btnLocalizar">Localizar</button></td>
				</tr></table>
			</td>
		</tr>
		</form>
		<tr><td nowrap>
			<cfif isdefined('form.btnLocalizar') and isdefined('form.FPCCid_Loc') and len(trim(form.FPCCid_Loc))>
				<cfinvoke component="sif.Componentes.PCG_ConceptoGastoIngreso" method="getPlantillaAsociada" returnvariable="PlantillaAsociado">
					<cfinvokeargument name="FPCCid" 	value="#form.FPCCid_Loc#">
					<cfinvokeargument name="CFid" 	 	value="#EncabezadoEst.CFid#">
				</cfinvoke>
				<cfif not len(trim(PlantillaAsociado.FPEPid))>
					<cfset showlink = "false">
				<cfelse>
					<cfset showlink = "true">
				</cfif>
				<cfquery datasource="#session.dsn#" name="rsCatConcepto">
					select FPCCid, FPCCcodigo, FPCCdescripcion 
						from FPCatConcepto
					where FPCCid = #form.FPCCid_Loc#
				</cfquery>
				<cfquery dbtype="query" name="rsDatos">
					select rsCatConcepto.FPCCid, rsCatConcepto.FPCCcodigo, rsCatConcepto.FPCCdescripcion , PlantillaAsociado.FPEPid, PlantillaAsociado.Descripcion, PlantillaAsociado.Indicador, '#form.FPEEid#' FPEEid, -1 tab
					from rsCatConcepto,PlantillaAsociado
					where rsCatConcepto.FPCCid = PlantillaAsociado.FPCCid
				</cfquery>
				
				<cfinvoke component="sif.Componentes.pListas" method="pListaQuery"
					query		="#rsDatos#"
					desplegar	="FPCCcodigo, FPCCdescripcion, Descripcion, Indicador"
					etiquetas	="Código, Descripción, Plantilla, Indicador Auxiliar de la Plantilla"
					formatos	="I,S,S,S"
					align		="left, left, left, left"
					ira			="#CurrentPage#"
					showlink	="#showlink#" 
					form_method	="post"
					keys		="FPCCid"	
					MaxRows		="5"
					usaAJAX 	= "true"
					conexion 	= "#session.DSN#"	
					PageIndex 	= "3"
					formName	="formLocalizar2"
					CurrentPage ="#CurrentPage#"
				/>	
			</cfif>
		</td></tr>
		</cfif>
		<tr>
			<td colspan="2">
				<cfparam name="url.tabIni" default="1">
				<cfquery dbtype="query" name="rsExisteP">
					select count(1) as cantidad from PlantillasCF where FPEPID = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.FPEPID#">
				</cfquery>
				<cfif form.FPEPID neq -1 and not len(trim(rsExisteP.cantidad)) or rsExisteP.cantidad eq '0'>
					<cfset url.tab = "1">
				</cfif>
				<cf_tabs width="100%" tabIni="#url.tabIni#" acomodar="true">
					<cfloop query="PlantillasCF">
						<cf_tab text="#PlantillasCF.FPEPdescripcion#" selected="#url.tab EQ PlantillasCF.currentrow or form.FPEPID EQ PlantillasCF.FPEPID#">	
							<cfif url.tab EQ PlantillasCF.currentrow or form.FPEPID EQ PlantillasCF.FPEPID>
									<cfinclude template="EstimacionGIDetalle-form.cfm">
									<cfset LvarFPEPid = "#PlantillasCF.FPEPID#">
							</cfif>
						</cf_tab>
					</cfloop>
				</cf_tabs>
			</td>
		</tr>
	<cfelse>
		<tr>
			<td align="center" colspan="2"><span class="msgError">No hay Plantillas asociadas al Centro Funcional</span></td>
		</tr>
		<tr>
			<td align="right" width="50%"><button class="btnAnterior"  onclick="fnRgresar('#CurrentPage#')">Regresar</button></td>
			<td align="left" width="50%"><button type="submit" class="btnEliminar" onclick="fnSubmitButon('btnDescartar',#form.FPEEid#,#url.tab#,'#CurrentPage#')">Descartar Estimación</button></td></tr></td>
		</tr>
	</table>
	</cfif>
</cfoutput>

<script language="javascript">
	
	function fnRgresar(CurrentPage){
		location.href = CurrentPage;
		return true;
	}
	
	<!-- Se carga el tab indicado, esto con el fin de no cargas todos los datos en la página -->
	function tab_set_current(n,i) {
		document.frm2.tab.value = n;
		document.frm2.tab.tabIni = i;
		document.frm2.action ="<cfoutput>#CurrentPage#</cfoutput>"; 
		document.frm2.submit();
	}
	
	function fnSubmitButon(boton,FPEEid,tab,CurrentPage){
		if(boton == 'btnEnviarAprobar')
			msgconfirm = 'Esta seguro que desea enviar a Aprobar la Estimación de Egresos e Ingresos';
		else if (boton == 'btnAprobar')
			msgconfirm = 'Esta seguro que desea Aprobar la Estimación de Egresos e Ingresos';
		else if (boton == 'btnRechazar')
			msgconfirm = 'Esta seguro que desea Rechazar la Estimación de Egresos e Ingresos';
		<cfif (not request.RolAdmin or (request.RolAdmin and EncabezadoEst.FPTVTipo eq 4)) and not len(trim(EncabezadoEst.FPEEVersion))>
		else if (boton == 'btnAgregardetalles')
			msgconfirm = 'Esta seguro que desea cargar los detalles de la Estimación de Egresos e Ingresos';
		</cfif>
		else if (boton == 'btnDescartar')
			msgconfirm = 'Esta seguro que desea descartar la Estimación de Egresos e Ingresos';
		else 
			msgconfirm = 'Esta seguro que desea Procesar la Transacción';
		if(confirm(msgconfirm)){
			param = "FPEEid="+FPEEid+"&"+boton+"=true&tab="+tab+"&CurrentPage="+CurrentPage;
			<cfif isdefined('form.FPEPid') and len(trim(form.FPEPid)) and form.FPEPid neq -1>
			param += "&FPEPid=<cfoutput>#form.FPEPid#</cfoutput>";
			</cfif>
			location.href = "EstimacionGI-sql.cfm?"+param;
			return true;
		}else
			return false;
	}
	
	function fnValidarMonto(form){
		if(!validarCampos)
			return true;
	<cfif ModoDet EQ 'CAMBIO' and listfind('2,3',EncabezadoEst.FPTVTipo)>
		<cfwddx action="cfml2js" input="#DetalleEst#" topLevelVariable="rsDetalleEst"> 
		//Verificar si existe en el recordset
		var nRows = rsDetalleEst.getRowCount();
		if(nRows > 0){
			error = false;
			<cfif EncabezadoEst.FPTVTipo eq '2'>
			tipo = "mayor";
			desc = "abajo";
			<cfelseif EncabezadoEst.FPTVTipo eq '3'>
			tipo = "menor";
			desc = "arriba";
			</cfif>
			for(row = 0; row < nRows; ++row){
				mp = parseFloat(form.DPDMontoTotalPeriodo_ALL.value.toString().replace(/,/g,''));
				mu = parseFloat(form.DPDEcosto_ALL.value.toString().replace(/,/g,''));
				tc = parseFloat(form.Dtipocambio_ALL.value.toString().replace(/,/g,''));
				msj = "Se esta procesando una Estimacion con Monto hacia "+desc+".\n Msj:\n";
				if (rsDetalleEst.getField(row, "LigadoPCG") == 'true' && rsDetalleEst.getField(row, "PCGDautorizado") <cfif EncabezadoEst.FPTVTipo eq '2'><<cfelseif EncabezadoEst.FPTVTipo eq '3'>></cfif> mp * tc ){
					msj += " - El monto del periódo no puede ser "+tipo+" al estipulado en el Plan de Compras(Monto Plan Compras: "+fm(rsDetalleEst.getField(row, "PCGDautorizado"),2)+" - Monto Periódo Actual: "+fm(mp,2)+")\n";
					error = true;
				}if(rsDetalleEst.getField(row, "LigadoPCG") == 'true' && rsDetalleEst.getField(row, "PCGDcostoUori") <cfif EncabezadoEst.FPTVTipo eq '2'><<cfelseif EncabezadoEst.FPTVTipo eq '3'>></cfif> mu){
					<cfif controlaCantidad>msj += " - El monto unitario";<cfelse>msj += " - El monto total";</cfif>
					msj += " no puede ser "+tipo+" al estipulado en el Plan de Compras(Monto Plan Compras: "+fm(rsDetalleEst.getField(row, "PCGDcostoUori"),2)+" - Monto Periódo Actual: "+fm(mu,2)+")\n";
					error = true;
				}
				<cfif controlaCantidad>
					<cfif esMultiperido>
					cp = parseFloat(form.DPDEcantidadPeriodo_ALL.value.toString().replace(/,/g,''));
					ct = parseFloat(form.DPDEcantidad_ALL.value.toString().replace(/,/g,''));
					if(rsDetalleEst.getField(row, "LigadoPCG") == 'true' && rsDetalleEst.getField(row, "CantidadTotal") <cfif EncabezadoEst.FPTVTipo eq '2'><<cfelseif EncabezadoEst.FPTVTipo eq '3'>></cfif> ct){
						msj += " - La cantidad total no puede ser "+tipo+" al estipulado en el Plan de Compras(Cantidad Plan Compras: "+fm(rsDetalleEst.getField(row, "CantidadTotal"),2)+" - Cantidad Periódo Actual: "+fm(ct,2)+")\n";
						error = true;
					}
					<cfelse>
					cp = parseFloat(form.DPDEcantidad_ALL.value.toString().replace(/,/g,''));
					</cfif>
				
				if(rsDetalleEst.getField(row, "LigadoPCG") == 'true' && rsDetalleEst.getField(row, "PCGDcantidad") <cfif EncabezadoEst.FPTVTipo eq '2'><<cfelseif EncabezadoEst.FPTVTipo eq '3'>></cfif> cp){
					msj += " - La cantidad periodo no puede ser "+tipo+" al estipulado en el Plan de Compras(Cantidad Plan Compras: "+fm(rsDetalleEst.getField(row, "PCGDcantidad"),2)+" - Cantidad Periódo Actual: "+fm(cp,2)+")\n";
					error = true;
				}
				</cfif>
			}
			if(error){
				alert(msj);
				return false;
			}
		}
	</cfif>	
		return true;	
	}
	
	function fnValidar(formname){
		msjError = "";
		if (formname.FPCCid_Loc.value == '')
			msjError = msjError+"- El campo Categoría es requerido.\n";
		if (msjError != ""){
			alert("Se presentaron los siguientes errores::\n"+msjError);
			return false;
		}else
			return true;	
	}
	
	function fnOcultar_CF(v) {
		f = document.forms.cf_form;
		a = document.all?document.all.cf_a:document.getElementById('cf_a');
		FPEPid = document.all?document.all.cf_a:document.getElementById('FPEPid');
		FPEPid.value = "<cfoutput>#LvarFPEPid#</cfoutput>";
		<cfif LvarFPEPid eq "-1">
			tab = document.all?document.all.cf_a:document.getElementById('FPEPid');
			tab.value = "1";
		</cfif>
		f.style.display=v?'inline':'none';
		a.style.display=v?'none':'inline';
	}
	function fnOcultar_HV(v) {
		f = document.forms.HV_form;
		a = document.all?document.all.HV_a:document.getElementById('HV_a');
		FPEPid = document.all?document.all.HV_a:document.getElementById('FPEPid');
		FPEPid.value = "<cfoutput>#LvarFPEPid#</cfoutput>";
		<cfif LvarFPEPid eq "-1">
			tab = document.all?document.all.HV_a:document.getElementById('FPEPid');
			tab.value = "1";
		</cfif>
		f.style.display=v?'inline':'none';
		a.style.display=v?'none':'inline';
	}
	
	var popup_win = false;
	function fnPopUpGrupal(FPEEid){
		if(popup_win){
			if(!popup_win.closed)
				popup_win.close();
		}
		var PARAM  = "VariacionPresupuestal-popUp.cfm?FPEEid="+FPEEid;
		popup_win = open(PARAM,'','left=100,top=50,scrollbars=yes,resizable=yes,width=600,height=600');
		return false;
	}
	
	function fnCongelar(FPEEid){
		if(popup_win){
			if(!popup_win.closed)
				popup_win.close();
		}
		var PARAM  = "VariacionPresupuestal-popUp.cfm?Congelar=true&CurrentPage=<cfoutput>#CurrentPage#</cfoutput>&FPEEid="+FPEEid;
		popup_win = open(PARAM,'','left=200,top=100,scrollbars=yes,resizable=yes,width=600,height=400');
		return false;
	}

	fnOcultar_CF(false);

</script>
