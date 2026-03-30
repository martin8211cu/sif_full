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
<cfif ListFind('0', EncabezadoEst.FPTVTipo)>
	<cfset fechaValida = FPRES_EstimacionGI.FechaLimiteValida(EncabezadoEst.FPEEFechaLimite)>
<cfelse>
	<cfset fechaValida = true>
</cfif>
<cfif (EncabezadoEst.FPEEestado EQ 0 and not request.RolAdmin) or (request.RolAdmin and EncabezadoEst.FPEEestado eq 2)>
	<cfif fechaValida>
		<cfset ButonAction = '<input name="imageField" type="image" src="../../imagenes/Borrar01_S.gif" width="16" height="16" border="0" onclick="return changeFormActionforDetalles(''#_Cat##V_FPEEid##_Cat#'',''#_Cat##V_FPEPid##_Cat#'',''#_Cat##V_FPDElinea##_Cat#'',''#_Cat##V_FPCCid##_Cat#'');">'>
	<cfelse>
		<cfset ButonAction=''> 
	</cfif>
	<cfset ButonNotes = '<input name="imageField" type="image" src="../../imagenes/notas2.gif" alt="Notas" width="16" height="16" border="0" onclick="DisplayNote(''#_Cat##V_FPEEid##_Cat#'',''#_Cat##V_FPEPid##_Cat#'',''#_Cat##V_FPDElinea##_Cat#'');">'>
<cfelseif EncabezadoEst.FPEEestado NEQ 0 and request.RolAdmin>
	<cfset ButonAction = "">
	<cfset ButonNotes = '<input name="imageField" type="image" src="../../imagenes/notas2.gif" alt="Notas" width="16" height="16" border="0" onclick="DisplayNote(''#_Cat##V_FPEEid##_Cat#'',''#_Cat##V_FPEPid##_Cat#'',''#_Cat##V_FPDElinea##_Cat#'');">'>
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
			<td colspan="2" align="center">
				<cfif EncabezadoEst.FPEEestado EQ 0 and not request.RolAdmin and PlantillasCF.recordCount GT 0 and fechaValida and isResponsables>
				 	<button class="btnAplicar"  onclick="fnSubmitButon('btnEnviarAprobar',#form.FPEEid#,#url.tab#,'#CurrentPage#')">Enviar a Aprobar</button></button>
				<cfelseif EncabezadoEst.FPEEestado EQ 0 and not request.RolAdmin and PlantillasCF.recordCount GT 0 and not fechaValida>
					<span class="msgError">La fecha lim&iacute;te para el envio de la Estimación Presupuestal se ha sobrepasado, comuniquese con el administrador del presupuesto</span>.
				 <cfelseif EncabezadoEst.FPEEestado EQ 1 and request.RolAdmin and PlantillasCF.recordCount GT 0 and listfind('0',form.HV)>
					<button class="btnAplicar"  onclick="fnSubmitButon('btnAprobar',#form.FPEEid#,#url.tab#,'#CurrentPage#')">Aprobar</button>
					<button class="btnEliminar" onclick="fnSubmitButon('btnRechazar',#form.FPEEid#,#url.tab#,'#CurrentPage#')">Rechazar</button>
				<cfelseif EncabezadoEst.FPEEestado EQ 2 and request.RolAdmin and PlantillasCF.recordCount GT 0>
					<button class="btnEliminar" onclick="fnSubmitButon('btnRechazar',#form.FPEEid#,#url.tab#,'#CurrentPage#')">Devolver a Preparación</button>
				<cfelseif EncabezadoEst.FPEEestado EQ 1 and request.RolAdmin and PlantillasCF.recordCount GT 0 and listfind('0',form.HV)>
					<button class="btnAplicar"  onclick="fnSubmitButon('btnAprobar',#form.FPEEid#,#url.tab#,'#CurrentPage#')">Aprobar</button></button>
				<cfelseif EncabezadoEst.FPEEestado EQ 0 and request.RolAdmin and PlantillasCF.recordCount GT 0>
					<table border="0" cellpadding="0" cellspacing="0">
						<tr>
							<form name="frmFecha" action="EstimacionGI-sql.cfm" method="post" onsubmit="return fnCambioFecha(this);">
								<input type="hidden" name="FPEEid_key" value="#form.FPEEid#" />
								<input type="hidden" name="btnModificarFecha" value="true" />
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
		<cfif PlantillasCF.recordCount GT 0 and not request.RolAdmin and EncabezadoEst.FPEEestado EQ 0 and isResponsables>
			<tr>
				<td align="center" colspan="2">
					<button type="submit" class="btnEliminar" onclick="fnSubmitButon('btnDescartar',#form.FPEEid#,#url.tab#,'#CurrentPage#')">Descartar Estimación</button>
				</td>
			</tr>
		</cfif>
	<cfif PlantillasCF.recordCount GT 0>
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
			<td>
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
			<td align="left" width="50%"><button type="submit" class="btnEliminar" onclick="fnSubmitButon('btnDescartar',#form.FPEEid#,#url.tab#,'#CurrentPage#')">Descartar Estimación</button></td>
		</tr>
	</cfif>
	</table>

</cfoutput>

<script language="javascript">
	
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
		else if (boton == 'btnDescartar')
			msgconfirm = 'Esta seguro que desea descartar la Estimación de Egresos e Ingresos';
		else
			msgconfirm = 'Esta seguro que desea Procesar la Transacción';
		if(confirm(msgconfirm)){
			location.href = "EstimacionGI-sql.cfm?FPEEid="+FPEEid+"&"+boton+"=true&tab="+tab+"&CurrentPage="+CurrentPage;
			return true;
		}else
			return false;
	}
	
	function fnValidarMonto(){
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
	
	
	fnOcultar_CF(false);

</script>
