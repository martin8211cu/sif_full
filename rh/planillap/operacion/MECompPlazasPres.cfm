<!--- VARIABLES DE TRADUCCION --->
<cfinvoke Key="MSG_DeseaRealizarLaModificacion" Default="Desea realizar la modificación?" returnvariable="MSG_DeseaRealizarLaModificacion" component="sif.Componentes.Translate" method="Translate"/>	

<!--- FIN VARIABLES DE TRADUCCION --->
<cf_dbfunction name="op_concat" returnvariable="LvarCNCT">
<cf_templatecss>
<script src="/cfmx/sif/js/qForms/qforms.js"></script>
<script language="javascript1.2" type="text/javascript" src="/cfmx/rh/js/utilesMonto.js"></script>
<script type="text/javascript" language="javascript1.2">
	<!--//
	// specify the path where the "/qforms/" subfolder is located
	qFormAPI.setLibraryPath("/cfmx/sif/js/qForms/");
	// loads all default libraries
	qFormAPI.include("*");
	//-->
	
	var popUpWin = 0;
	function popUpWindow(URLStr, left, top, width, height){
		if(popUpWin){
			if(!popUpWin.closed) popUpWin.close();
		}
		popUpWin = open(URLStr, 'popUpWin', 'toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes,width='+width+',height='+height+',left='+left+', top='+top+',screenX='+left+',screenY='+top+'');
	}

	function funcEliminar(prn_RHCSAid){
		alert('entra');
		if( confirm('¿Desea Eliminar el Registro?') ){
			document.formComponentes.RHCSAidEliminar.value = prn_RHCSAid;
			document.formComponentes.submit();
		}	
	}	
	
	function funcNuevoCorte(){
		var params ="?RHEid="+document.formComponentes.RHEid.value+'&RHSAid='+document.formComponentes.RHSAid.value;
		popUpWindow("/cfmx/rh/planillap/operacion/PopUp-SANuevoCorte.cfm"+params,200,180,500,270);				
	}
</script>
<!----////////////////////////////////DATOS DEL FRAME DE COMPONENTES/////////////////////////////////----->
<cfif isdefined("url.RHEid") and len(trim(url.RHEid)) and not isdefined("form.RHEid")>
	<cfset form.RHEid = url.RHEid>
</cfif>
<cfif isdefined("url.RHSAid") and len(trim(url.RHSAid)) and not isdefined("form.RHSAid")>
	<cfset form.RHSAid = url.RHSAid>
</cfif>

<!---Definicion de variables--->
<cfset ValuesCambioTablas = ArrayNew(1)>	<!---Valores de la tabla salarial---->
<cfset ValuesCambioCategoria = ArrayNew(1)>	<!---Valores de la Categoria---->
<cfset ValuesCambioPuesto = ArrayNew(1)>	<!---Valores del Puesto---->
<cfset vb_negociada = true>					<!---Variable para indicar si la plaza es negociada ---->
<cfset vb_ocupada = true>					<!---Variable para indicar si la plaza esta ocupada ---->

<cfif (isdefined("form.RHSAid") and len(trim(form.RHSAid))) and (isdefined("form.RHEid") and len(trim(form.RHEid)))>
	<!---Datos de la Plaza Presupuestaria---->
	<cfquery name="rsPlaza" datasource="#session.DSN#">
		select 	ltrim(ltrim(pp.RHPPcodigo))#LvarCNCT#' - '#LvarCNCT#ltrim(rtrim(pp.RHPPdescripcion)) as PlazaPresupuestaria,
				ltrim(ltrim(pp.RHPPcodigo))#LvarCNCT#' - '#LvarCNCT#ltrim(rtrim(pp.RHPPdescripcion)) as	PuestoPresupuestario,
				sta.RHTTid,
				sta.RHCid,
				sta.RHMPPid,
				sta.CFid,
				sta.fdesdeplaza,
				sta.fhastaplaza,
				sta.RHSAocupada,
				sta.RHMPnegociado
		from RHSituacionActual sta
			inner join RHPlazaPresupuestaria pp
				on pp.RHPPid = sta.RHPPid
				and pp.Ecodigo = sta.Ecodigo
			left outer join RHMaestroPuestoP mpp
				on mpp.RHMPPid = sta.RHMPPid
				and mpp.Ecodigo = sta.Ecodigo
		where sta.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			and sta.RHEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHEid#">
			and sta.RHSAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHSAid#">
	</cfquery>
	<cfif rsPlaza.RecordCount NEQ 0>
		<!---Cargar variable de validacion si la plaza es negociable---->
		<cfif rsPlaza.RHMPnegociado EQ 'T'>
			<cfset vb_negociada = false>
		</cfif> 
		<!---Cargar variable de validacion si la plaza esta ocupada---->
		<cfif not len(trim(rsPlaza.RHSAocupada))>
			<cfset vb_ocupada = false>
		</cfif> 
		<!---Datos de la tabla---->
		<cfif len(trim(rsPlaza.RHTTid))>
			<cfquery name="rsTabla" datasource="#session.DSN#">
				select RHTTcodigo, RHTTdescripcion
				from RHTTablaSalarial
				where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
					and RHTTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsPlaza.RHTTid#">				
			</cfquery>			
			<cfset ArrayAppend(ValuesCambioTablas, rsPlaza.RHTTid)>
			<cfset ArrayAppend(ValuesCambioTablas, rsTabla.RHTTcodigo)>
			<cfset ArrayAppend(ValuesCambioTablas, rsTabla.RHTTdescripcion)>
		</cfif>
		<!---Datos de la Categoria---->
		<cfif len(trim(rsPlaza.RHCid))>
			<cfquery name="rsCategoria" datasource="#session.DSN#">
				select RHCcodigo, RHCdescripcion
				from RHCategoria
				where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">				
					and RHCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsPlaza.RHCid#">
			</cfquery>			
			<cfset ArrayAppend(ValuesCambioCategoria, rsPlaza.RHCid)>
			<cfset ArrayAppend(ValuesCambioCategoria, rsCategoria.RHCcodigo)>
			<cfset ArrayAppend(ValuesCambioCategoria, rsCategoria.RHCdescripcion)>
		</cfif>
		<!---Datos del Puesto---->
		<cfif len(trim(rsPlaza.RHMPPid))>
			<cfquery name="rsPuesto" datasource="#session.DSN#">
				select RHMPPcodigo, RHMPPdescripcion
				from RHMaestroPuestoP
				where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">				
					and RHMPPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsPlaza.RHMPPid#">
			</cfquery>			
			<cfset ArrayAppend(ValuesCambioPuesto, rsPlaza.RHMPPid)>
			<cfset ArrayAppend(ValuesCambioPuesto, rsPuesto.RHMPPcodigo)>
			<cfset ArrayAppend(ValuesCambioPuesto, rsPuesto.RHMPPdescripcion)>
		</cfif>
		<cfquery name="rsCfuncional" datasource="#session.DSN#">
			select CFid,CFcodigo,CFdescripcion 
			from CFuncional 
			where CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsPlaza.CFid#">
		</cfquery>
	</cfif>
	<cfquery name="rsComponentes" datasource="#session.DSN#">		
		select 	csa.CSid,
				csa.RHSAid,
				csa.RHCSAid,
				csa.Cantidad,
				csa.Monto as MontoRes,
				0 as MontoBase,
				csa.ts_rversion,
				ltrim(rtrim(cmp.CScodigo)) as Codigo,
				ltrim(rtrim(cmp.CSdescripcion)) as CSDescripcion,
				RHMCcomportamiento,
				CSusatabla,
				case cmp.CSsalariobase 
					when 1 then ''
				else '<img border=''0'' onClick=''javascript: funcEliminar("'#LvarCNCT# <cf_dbfunction name="to_char" args="csa.RHCSAid"> #LvarCNCT#'");'' src=''/cfmx/rh/imagenes/Borrar01_S.gif''>' end as eliminar				 
		from RHSituacionActual sa
		inner join RHCSituacionActual csa
			on csa.RHSAid = sa.RHSAid
			inner join ComponentesSalariales cmp
				on cmp.CSid = csa.CSid
				and cmp.Ecodigo = csa.Ecodigo
		 left outer join RHMetodosCalculo c
				 on c.Ecodigo = csa.Ecodigo
				 and c.CSid = csa.CSid
				 and sa.fdesdeplaza between c.RHMCfecharige and c.RHMCfechahasta
				 and c.RHMCestadometodo = 1
		where csa.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#"> 
			and csa.RHSAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHSAid#">
		order by cmp.Codigo, cmp.CSdescripcion
	</cfquery>
</cfif>
<form name="formComponentes" action="MECompPlazasPres-sql.cfm" method="post">
	<cfoutput>
		<input type="hidden" name="RHEid" 	value="<cfif isdefined("form.RHEid") and len(trim(form.RHEid))>#form.RHEid#</cfif>">
		<input type="hidden" name="RHSAid" value="<cfif isdefined("form.RHSAid") and len(trim(form.RHSAid))>#form.RHSAid#</cfif>">		
		<input type="hidden" name="RHCSAidEliminar" value="">
	</cfoutput>
	
	<table width="100%" cellpadding="1" cellspacing="0">
		<tr>
			<td width="10%" nowrap="nowrap" class="tituloListas" align="right">
				<strong style="color:#003366;font-family:'Times New Roman', Times, serif; font-size:11pt; font-variant:small-caps; font-weight:bolder;">Plaza :</strong>		</td>
			<td width="90%" class="tituloListas">
				<cfif isdefined("rsPlaza") and rsPlaza.RecordCount NEQ 0>
					<cfoutput>
						<strong style="color:##003366;font-family:'Times New Roman', Times, serif; font-size:11pt; font-variant:small-caps; font-weight:bolder;">#rsPlaza.PlazaPresupuestaria#</strong>
					</cfoutput>
				</cfif>
			</td>
		</tr>
		<tr>
			<td width="10%" nowrap="nowrap" class="tituloListas" align="right">
				<strong style="color:#003366;font-family:'Times New Roman', Times, serif; font-size:11pt; font-variant:small-caps; font-weight:bolder;">Puesto :</strong>		</td>
			<td class="tituloListas">
				<cfif isdefined("rsPlaza") and rsPlaza.RecordCount NEQ 0>
					<cfoutput>
						<strong style="color:##003366;font-family:'Times New Roman', Times, serif; font-size:11pt; font-variant:small-caps; font-weight:bolder;">#rsPlaza.PuestoPresupuestario#</strong>
					</cfoutput>
				</cfif>
			</td>
		</tr>
		<tr>
			<td colspan="6">
				<!----Encabezado ----->
				<table width="100%" cellpadding="2" cellspacing="0">				
				<tr>
					<td width="20%"><strong>&nbsp;Tabla Salarial:&nbsp;</strong></td>
					<td width="15%" ><strong>&nbsp;Puesto:&nbsp;</strong></td>
					<td width="15%" ><strong>&nbsp;Categor&iacute;a:&nbsp;</strong></td>
					<td width="15%" ><strong>&nbsp;Estado Plaza:&nbsp;</strong></td>
				</tr>
				<tr>
					<!---Tablas salariales---->
					<td width="20%">
						<cf_conlis 
							campos="RHTTid,RHTTcodigo,RHTTdescripcion"
							asignar="RHTTid,RHTTcodigo,RHTTdescripcion"
							size="0,8,25"
							desplegables="N,S,S"
							modificables="N,N,N"							
							title="Lista de Tablas Salariales"
							tabla="RHTTablaSalarial"
							columnas="RHTTid,RHTTcodigo,RHTTdescripcion"
							filtro="Ecodigo = #Session.Ecodigo# 									
									Order by RHTTcodigo,RHTTdescripcion"
							filtrar_por="RHTTcodigo,RHTTdescripcion"
							desplegar="RHTTcodigo,RHTTdescripcion"
							etiquetas="C&oacute;digo, Descripci&oacute;n"
							formatos="S,S"
							align="left,left"						
							asignarFormatos="S,S,S"
							form="formComponentes"
							valuesArray="#ValuesCambioTablas#"
							showEmptyListMsg="true"
							EmptyListMsg=" --- No se encontraron registros --- "
							readonly="yes"/>					
					</td>
					
					<!----Puestos---->
					<td width="15%">
						<cf_conlis 
							campos="RHMPPid,RHMPPcodigo,RHMPPdescripcion"
							asignar="RHMPPid,RHMPPcodigo,RHMPPdescripcion"
							size="0,8,25"
							desplegables="N,S,S"
							modificables="N,S,N"
							title="Lista de Puestos Presupuestarios"
							tabla="RHMaestroPuestoP"
							columnas="RHMPPid,RHMPPcodigo,RHMPPdescripcion"							
							filtro="Ecodigo = #Session.Ecodigo# Order by RHMPPcodigo,RHMPPdescripcion"
							filtrar_por="RHMPPcodigo,RHMPPdescripcion"
							desplegar="RHMPPcodigo,RHMPPdescripcion"
							etiquetas="C&oacute;digo, Descripci&oacute;n"
							formatos="S,S,S,"
							align="left,left"						
							asignarFormatos="S,S,S"
							form="formComponentes"
							valuesArray="#ValuesCambioPuesto#"
							showEmptyListMsg="true"							
							EmptyListMsg=" --- No se encontraron registros --- "
							readonly="yes"/>					
					</td>
					<!----Categorias---->
					<td width="15%">
						<cf_conlis 
							campos="RHCid,RHCcodigo,RHCdescripcion"
							size="0,8,25"
							desplegables="N,S,S"
							modificables="N,S,N"
							title="Lista de Categor&iacute;as"
							tabla="RHCategoria a
									inner join RHCategoriasPuesto b
										on b.RHCid = a.RHCid"
							columnas="a.RHCid as RHCid, RHCcodigo as RHCcodigo, RHCdescripcion as RHCdescripcion"
							filtro="a.Ecodigo = #Session.Ecodigo# and RHMPPid = $RHMPPid,numeric$ Order by RHCcodigo,RHCdescripcion"
							filtrar_por="RHCcodigo, RHCdescripcion"
							desplegar="RHCcodigo, RHCdescripcion"
							etiquetas="C&oacute;digo, Descripci&oacute;n"
							formatos="S,S"
							align="left,left"	
							asignar="RHCid,RHCcodigo, RHCdescripcion"
							asignarFormatos="S,S,S"
							form="formComponentes"
							showEmptyListMsg="true"
							valuesArray="#ValuesCambioCategoria#"
							EmptyListMsg=" --- No se encotraron registros --- "
							readonly="yes"/>					
					</td>	
					<!---Estado de la plaza---->
					<td>
						<select name="RHMPestadoplaza" disabled>
						  <option value="A">Activa</option>
						  <option value="I">Inactiva</option>
						  <option value="C">Congelada</option>
						</select>
					</td>	             
				</tr>
				<tr>
					<td width="20%"><strong>&nbsp;Ctro.Funcional:&nbsp;</strong></td>
					<td width="15%" nowrap="nowrap">
						<table width="100%"><tr>
							<td width="50%" nowrap="nowrap"><strong>&nbsp;Fecha Desde:&nbsp;</strong></td>						
							<td width="50%" nowrap="nowrap"><strong>&nbsp;Fecha Hasta:&nbsp;</strong></td>
						</tr></table>					</td>
					<td width="15%" ><strong>&nbsp;</strong></td>
				</tr>
				<tr>
					<!---Centro funcional---->
					<td>
						<cf_rhcfuncional id="CFid" form="formComponentes" size="25" query="#rsCfuncional#" 
							readonly="yes">					
					</td>
					<!----Fecha desde---->
					<td nowrap="nowrap" valign="middle">
						<table width="100%" border="0"><tr>
							<td width="50%" nowrap="nowrap">
								<cf_sifcalendario conexion="#session.DSN#" form="formComponentes" name="fdesdeplaza" value="#LSDateFormat(rsPlaza.fdesdeplaza,'dd/mm/yyyy')#" readonly="true">							</td>
							<td width="50%" nowrap="nowrap">
								<cf_sifcalendario conexion="#session.DSN#" form="formComponentes" name="fhastaplaza" value="#LSDateFormat(rsPlaza.fhastaplaza,'dd/mm/yyyy')#" readonly="true">							</td>
						</tr></table>					
					</td>
					<td colspan="2" align="center">
						<input type="submit" name="Modificar" value="Modificar" onclick="javascript: return(confirm('<cfoutput>#MSG_DeseaRealizarLaModificacion#</cfoutput>'));"/>&nbsp;
						<cfoutput>
							<input type="button" name="btn_regresar" value="<< Anterior" <cfif isdefined("form.RHEid") and len(trim(form.RHEid))>onclick="javascript: window.parent.funcRegresaPlazas('#form.RHEid#');"</cfif>/>
						</cfoutput>					
					</td>
				</tr>
				<tr><td>&nbsp;</td></tr>
          	</table>
		</td>
		</tr>
		<tr>
			<td colspan="6">
			<!----Lista----->
			<fieldset><legend align="center" style="color:#003366;font-family:'Times New Roman', Times, serif; font-size:11pt; font-variant:small-caps; font-weight:bolder;">Componentes</legend>
			<table width="100%" cellpadding="0" cellspacing="0" border="0">
				<tr>
					<td width="100%">	
						<cfquery name="rsComponentes" datasource="#session.DSN#">
							select RHCFid,CScodigo,CSdescripcion,coalesce(RHCFPresupuestado,0) as Presupuestado,coalesce(RHCFgastado,0.00) as Gastado,
								coalesce(RHCFdisponible,0.00) as Disponible,coalesce(RHCFreserva,0.00) as Reserva,coalesce(RHCFrefuerzo,0.00) as Refuerzo,
								coalesce(RHCFmodificacion,0.00) as Modificacion
							from RHFormulacion a
							inner join RHCFormulacion b
								on b.RHFid = a.RHFid
							inner join ComponentesSalariales d
								on d.CSid = b.CSid
							where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
							  and RHEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHEid#">
							  and RHSAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHSAid#">
						</cfquery>
						<table cellpadding="0" cellpadding="0" align="center">
							<tr>
								<td width="25%"><cf_translate key="LB_Componentes">Componente</cf_translate></td>
								<td><cf_translate key="LB_MontoPresupuestado">Presupuestado</cf_translate></td>
								<td><cf_translate key="LB_MontoGastado">Gastado</cf_translate></td>
								<td><cf_translate key="LB_MontoReseva">Reservado</cf_translate></td>
								<td><cf_translate key="LB_MontoModificado">Modificaci&oacute;n</cf_translate></td>
								<td><cf_translate key="LB_Refuerzo">Refuerzo</cf_translate></td>
								<td><cf_translate key="LB_MontoDisponible">Disponible</cf_translate></td>
							</tr>
						<cfoutput query="rsComponentes">
							<tr>
								<td width="25%">#CSdescripcion#</td>
								<td align="right"><cf_inputNumber name="Presupuestado#RHCFid#" id="Presupuestado#RHCFid#" value="#Presupuestado#" decimales="2" modificable="false" tabindex="2"></td>
								<td align="right"><cf_inputNumber name="Gastado#RHCFid#" id="Gastado#RHCFid#" value="#Gastado#" decimales="2" modificable="false" tabindex="2"></td>
								<td align="right"><cf_inputNumber name="Reserva#RHCFid#" id="Reserva#RHCFid#" value="#Reserva#" decimales="2" modificable="false" tabindex="2"></td>
								<td align="right"><cf_inputNumber name="Modificacion#RHCFid#" id="Modificacion#RHCFid#" value="#Modificacion#" decimales="2" modificable="true" tabindex="2"  onblur="SumaMontos(#RHCFid#)"></td>
								<td align="right"><cf_inputNumber name="Refuerzo#RHCFid#" id="Refuerzo#RHCFid#" value="#Refuerzo#" decimales="2" modificable="true" tabindex="2"onblur="SumaMontos(#RHCFid#)"></td>
								<td align="right"><cf_inputNumber name="Disponible#RHCFid#" id="Disponible#RHCFid#" value="#Disponible#" decimales="2" modificable="false" tabindex="2"></td>
							</tr>
						</cfoutput>
					</table>
				</td>
			</tr>		
			</table>
			</fieldset></td>
		</tr>			
		<tr><td colspan="6">&nbsp;</td></tr>
	</table>
</form>	
<script language="JavaScript" type="text/javascript">	
	function funcHabilitarValidacion(){
		objForm.MontoNuevo.required = true;
		objForm.CantidadNuevo.required = true;
		objForm.CSid.required = true;		
	}
	function SumaMontos(id){
		var Presupuestado = document.getElementById('Presupuestado'+id);
		var Gastado = document.getElementById('Gastado'+id);
		var Reserva = document.getElementById('Reserva'+id);
		var Modificacion = document.getElementById('Modificacion'+id);
		var Refuerzo = document.getElementById('Refuerzo'+id);
		var Disponible = document.getElementById('Disponible'+id);
		var monto;
		monto = (Number(qf(Presupuestado.value)) + Number(qf(Modificacion.value)) + Number(qf(Refuerzo.value))) - (Number(qf(Gastado.value))+Number(qf(Reserva.value))); 
		Disponible.value = fm(monto,2);
	}
	
	function funcModificar(){
		if(confirm('<cfoutput>#MSG_DeseaRealizarLaModificacion#</cfoutput>')){
			return true;
		}
		return false;
	}
</script>
