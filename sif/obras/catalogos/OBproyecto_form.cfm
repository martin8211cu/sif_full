
<cfquery datasource="#session.dsn#" name="rsForm">
	select op.Ecodigo
	     , op.OBPid
	     , op.OBPcodigo
	     , op.PCDcatidPry
	     , op.OBPdescripcion
	     , op.OBPtexto
	     , op.OBTPid
	     , op.PCEcatidObr, ec.PCEcodigo as PCEcodigoObr, ec.PCEdescripcion as PCEdescripcionObr
	     , op.CFformatoPry
	     , op.BMUsucodigo
	     , op.ts_rversion
	
	  from OBproyecto op
	  	inner join PCECatalogo ec
			on ec.PCEcatid = op.PCEcatidObr
	 where op.Ecodigo = #session.Ecodigo#
	   and op.OBPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.OBPid#" null="#form.OBPid EQ ""#">
</cfquery>

<cfset LvarDependencias = false>
<cfquery datasource="#session.dsn#" name="rsSQL">
	select count(1) as cantidad
	  from OBproyectoReglas
	 where OBPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.OBPid#" null="#form.OBPid EQ ""#">
</cfquery>
<cfset LvarDependencias = rsSQL.cantidad NEQ 0>
<cfif NOT LvarDependencias>
	<cfquery datasource="#session.dsn#" name="rsSQL">
		select count(1) as cantidad
		  from OBobra
		 where OBPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.OBPid#" null="#form.OBPid EQ ""#">
	</cfquery>
	<cfset LvarDependencias = rsSQL.cantidad NEQ 0>
</cfif>

<cfoutput>
<form name="formOBP" id="formOBP" method="post" action="OBproyecto_sql.cfm">
	<table summary="Tabla de entrada">
		<tr>
			<td colspan="2" class="subTitulo">
				Proyectos
			</td>
		</tr>

		<tr>
			<td valign="top">
				<strong>Tipo Proyecto</strong>
			</td>
			<td valign="top">
				<cfquery datasource="#session.dsn#" name="rsSQL">
					select OBTPid, OBTPcodigo, OBTPdescripcion
					  from OBtipoProyecto
					 where Ecodigo = #session.Ecodigo#
					<cfif rsForm.RecordCount GT 0>
					   and OBTPid = #rsForm.OBTPid#
					</cfif>
				</cfquery>
				<cfif rsForm.RecordCount EQ 0>
					<cfif isdefined("url.OBTPid")>
						<cfset LvarOBTPid = url.OBTPid>
					<cfelse>
						<cfset LvarOBTPid = rsSQL.OBTPid>
					</cfif>
					<cfset LvarNuevo = "&btnNuevo=1">
				<cfelse>
					<cfset LvarOBTPid = rsForm.OBTPid>
					<cfset LvarNuevo = "">
				</cfif>
                <cfif LvarOBTPid EQ "">
                    <cf_errorCode	code = "80013" msg  = "Debes configurar primero,  al  menos un  Tipo de Proyecto...">	
                </cfif>
				
				<select	name="OBTPid" id="OBTPid" 
						onchange="location.href = 'OBproyecto.cfm?OBPid=-1#LvarNuevo#&OBTPid=' + this.value;"
				>
				<cfloop query="rsSQL">
					<option value="#rsSQL.OBTPid#" <cfif isdefined("url.OBTPid") AND url.OBTPid EQ rsSQL.OBTPid>selected</cfif>>#rsSQL.OBTPcodigo# - #rsSQL.OBTPdescripcion#</option>
				</cfloop>
				</select>

			</td>
		</tr>

		<tr>
			<td valign="top">
				<strong>Codigo de Proyecto</strong>
			</td>
			<td valign="top">

				<cfquery datasource="#session.dsn#" name="rsOBTP">
					select Cmayor, PCEcatidPry, 
							OBTPnivelProyecto, 
							OBTPnivelObra, 
							m.PCEMformato,
							ec.PCEcodigo as PCEcodigoPry, ec.PCEdescripcion as PCEdescripcionPry,
							ec.PCElongitud, ec.PCEempresa, ec.PCEoficina, ec.PCEreferenciarMayor
					  from OBtipoProyecto tp
					  	inner join PCEMascaras m
						   on m.PCEMid	= tp.PCEMid
						inner join PCECatalogo ec
						   on ec.PCEcatid = PCEcatidPry
					 where tp.OBTPid = #LvarOBTPid#
				</cfquery>
				<cfif rsOBTP.PCEempresa EQ "1">
					<cfset LvarEcodigoFiltro = " and d.Ecodigo = #session.Ecodigo#">
				<cfelse>
					<cfset LvarEcodigoFiltro = "">
				</cfif>				
				
				<cfif rsOBTP.PCEreferenciarMayor EQ "0">
					<cfset LvarRefMayor_campo	= "d.PCEcatidref">
					<cfset LvarRefMayor_join	= "">
				<cfelse>
					<cfset LvarRefMayor_campo	= "coalesce(rm.PCEcatidref, d.PCEcatidref)">
					<cfset LvarRefMayor_join	= "left join PCDCatalogoRefMayor rm on rm.Cmayor='#rsOBTP.Cmayor#' and rm.PCDcatid=d.PCDcatid">
				</cfif>

				<cf_conlis
					readonly="#LvarDependencias#"
					Campos="PCDcatidPry=PCDcatid, OBPcodigo=PCDvalor, OBPdescripcion=PCDdescripcion"
					Desplegables="N,S,S"
					Modificables="N,S,N"
					Size="0,10,40"
					Title="Valores del Catálogo para Proyectos"

					traerInicial="#rsForm.PCDcatidPry NEQ ''#"  
					traerFiltro="d.PCDcatid = #rsForm.PCDcatidPry#"  

					Columnas="d.PCDcatid, d.PCDvalor, d.PCDdescripcion, #LvarRefMayor_campo# as PCEcatidref, h.PCEcodigo as PCEcodigoObr, h.PCEdescripcion as PCEdescripcionObr"
						Tabla="PCDCatalogo d #LvarRefMayor_join# inner join PCECatalogo h on h.PCEcatid = #LvarRefMayor_campo#"
					Filtro="d.PCEcatid = #rsOBTP.PCEcatidPry# #LvarEcodigoFiltro#
							and not exists(
								select 1 from OBproyecto
								 where OBTPid = #LvarOBTPid#
								   and OBPcodigo = d.PCDvalor
								   and OBPcodigo <> '#rsForm.OBPcodigo#'
								)
							order by PCDvalor"
					Desplegar="PCDvalor, PCDdescripcion"
					Etiquetas="Valor,Descripción"
					Formatos="S,S"
					Align="left,left"

					Asignar="PCDcatidPry, OBPcodigo, CFformato#rsOBTP.OBTPnivelProyecto#=PCDvalor, OBPdescripcion, PCEcatidObr=PCEcatidref, PCEcodigoObr, PCEdescripcionObr"
					Asignarformatos="S,S,S,S,S,S,S"
					MaxRowsQuery="200"
					form="formOBP"

					 onblur="this.value = fnConCeros(this.value, #rsOBTP.PCElongitud#);"
				/>										
			</td>
		</tr>

		<tr>
			<td valign="top">
				<strong>Catálogo de Obras</strong>
			</td>
			<td valign="top">
				<input type="hidden" name="PCEcatidObr" id="PCEcatidObr"
					value="#rsForm.PCEcatidObr#" 
				>
				<input type="text" name="PCEcodigoObr" id="PCEcodigoObr"
					size="10"
					value="#rsForm.PCEcodigoObr#" 
					readonly="yes" tabindex="-1" style="border:solid 1px ##CCCCCC; background:inherit"
				>
				<input type="text" name="PCEdescripcionObr" id="PCEdescripcionObr"
					size="40"
					value="#rsForm.PCEdescripcionObr#"
					readonly="yes" tabindex="-1" style="border:solid 1px ##CCCCCC; background:inherit"
				>
			</td>
		</tr>

		<tr>
			<td valign="top">
				<strong>Texto</strong>
			</td>
			<td valign="top">

				<textarea 	name="OBPtexto" id="OBPtexto"
							style="font-family:Arial, Helvetica, sans-serif;font-size:12px" rows="6" cols="50" 
							onfocus="this.select();"
				>#HTMLEditFormat(rsForm.OBPtexto)#</textarea>

			</td>
		</tr>

		<tr>
			<td valign="top">
				<strong>Formato de la Cuenta</strong>
			</td>
			<td valign="top">
				<input type="text"   name="PCEMformato" id="PCEMformato" value="#rsOBTP.PCEMformato#"
						size="#len(rsOBTP.PCEMformato)+15#"
						readonly="yes" tabindex="-1" style="border:solid 1px ##CCCCCC; background:inherit"
				>
			</td>
		</tr>

		<tr>
			<td valign="top">
				<strong>Parte fija de Cuenta para Proyecto</strong>
			</td>
			<td valign="top">
				<input type="text" name="CFformato0" id="CFformato0" 
						value="#HTMLEditFormat(rsOBTP.Cmayor)#" 
						size="4" maxlength="4"
						readonly="yes" 
						style="border:solid 1px ##CCCCCC; background:inherit" tabindex="-1"
				
				<cfset LvarCFformato = rtrim(rsOBTP.PCEMformato) & "-">
				<cfset LvarCFformatoPry = rtrim(rsForm.CFformatoPry) & "-">
				<cfset LvarPto1 = 6>
				<cfset LvarXX = false>
				><cfloop index="LvarNivel" from="1" to="#rsOBTP.OBTPnivelObra-1#">-<input 
					<cfset LvarPto2 = find("-",LvarCFformato,LvarPto1)>
					<cfset LvarPtoN = LvarPto2 - LvarPto1>
					<cfif LvarNivel EQ rsOBTP.OBTPnivelProyecto>
						<cfif len(LvarCFformatoPry) LT LvarPto2>
							<cfset LvarValue = "">
						<cfelse>
							<cfset LvarValue = mid(LvarCFformatoPry, LvarPto1, LvarPtoN)>
						</cfif>
								type="text" name="CFformato#LvarNivel#" id="CFformato#LvarNivel#" 
								value="#HTMLEditFormat(LvarValue)#" 
								size="#LvarPtoN#" maxlength="#LvarPtoN#"
								readonly="yes" tabindex="-1" style="border:solid 1px ##CCCCCC; background:inherit"
					<cfelse>
						<cfset LvarXX = true>
						<cfif len(rsForm.CFformatoPry) LT LvarPto2>
							<cfset LvarValue = mid(LvarCFformato, LvarPto1, LvarPtoN)>
						<cfelse>
							<cfset LvarValue = mid(LvarCFformatoPry, LvarPto1, LvarPtoN)>
						</cfif>
								type="text" name="CFformato#LvarNivel#" id="CFformato#LvarNivel#" 
								value="#HTMLEditFormat(LvarValue)#" 
								size="#LvarPtoN#" maxlength="#LvarPtoN#"
								onblur="this.value = fnConCeros(this.value,this.size);"
								onfocus="this.select();" 
					</cfif>
					<cfset LvarPto1 = LvarPto2 + 1>
				></cfloop>
				<cfif LvarXX>Para mantener un nivel variable: Digite todo el nivel con Xs</cfif>
			</td>
		</tr>

		<tr><td>&nbsp;</td></tr>
		
		<tr>
			<td colspan="2" class="formButtons">
			<cfif rsForm.RecordCount>
				<cf_botones  regresar='OBproyecto.cfm?_' modo='CAMBIO' include="Documentacion">
			<cfelse>
				<cf_botones  regresar='OBproyecto.cfm?_' modo='ALTA'>
			</cfif>
			</td>
		</tr>
	</table>
	<input type="hidden" name="Ecodigo" value="#HTMLEditFormat(rsForm.Ecodigo)#">
	<input type="hidden" name="OBPid" value="#HTMLEditFormat(rsForm.OBPid)#">
	<input type="hidden" name="BMUsucodigo" value="#HTMLEditFormat(rsForm.BMUsucodigo)#">

	<cfset ts = "">
	<cfinvoke component="sif.Componentes.DButils" method="toTimeStamp"
		artimestamp="#rsForm.ts_rversion#" returnvariable="ts">
	</cfinvoke>
	<input type="hidden" name="ts_rversion" value="#ts#">

</form>

<script language="javascript">
	var GvarPopUpWinDocumentacion=null;
	var GvarPopUpWinWarning=null;
	function funcDocumentacion()
	{
		if(GvarPopUpWinDocumentacion)
		{
			if(!GvarPopUpWinDocumentacion.closed) GvarPopUpWinDocumentacion.close();
		}
		<cfset session.Obras.OBD.OBTPid = rsForm.OBTPid>
		<cfset session.Obras.OBD.OBPid = rsForm.OBPid>
		<cfset session.Obras.OBD.OBOid = "">
		<cfset session.Obras.OBD.OBEid = "">
		var LvarLeft	= 100;
		var LvarWidth	= screen.width - (LvarLeft*2);
		var LvarTop		= 100;
		var LvarHeight	= screen.height - (LvarTop*2);
		GvarPopUpWinDocumentacion = open("OBdocumentacion.cfm?OBD&OBTPid=#rsForm.OBTPid#&OBPid=#rsForm.OBPid#&OBOid&OBEid", "popUpWinPCCEclaidOG", "title=no,toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbar=yes,resizable=no,copyhistory=yes,left="+ LvarLeft +",top="+ LvarTop +",width="+ LvarWidth +",height="+ LvarHeight +",screenX=0,screenY=0");
		if (!GvarPopUpWinDocumentacion && !GvarPopUpWinWarning) 
		{
			alert('Aviso: Su bloqueador de ventanas emergentes (popup blocker) \nestá evitando que se abra la ventana.\nPor favor revise las opciones de su navegador (browser), y \nacepte las ventanas emergentes de este sitio: ' + location.hostname);
			GvarPopUpWinWarning = true;
		}
		else
			GvarPopUpWinDocumentacion.focus();
		
		return false;
	}

	function fnConCeros(LprmHilera, LprmLong)
	{
		LprmHilera = fnTrim(LprmHilera);
		var s = "";
		for (var i=0;i<LprmLong;i++) s=s+"9";
		return fnRight(s + LprmHilera, LprmLong);
	}		 

	function fnRight(LprmHilera, LprmLong)
	{
		var LvarTot = LprmHilera.length;
		return LprmHilera.substring(LvarTot-LprmLong,LvarTot);
	}
	function fnLTrim(LvarHilera)
	{
		return LvarHilera.replace(/^\s+/,'');
	}
	function fnRTrim(LvarHilera)
	{
		return LvarHilera.replace(/\s+$/,'');
	}
	function fnTrim(LvarHilera)
	{
	   return fnRTrim(fnLTrim(LvarHilera));
	}
</script>
<cf_qforms form="formOBP" objForm="LobjQForm_OBP">
	<cf_qformsRequiredField args="OBPcodigo, Codigo Proyecto">
	<cf_qformsRequiredField args="PCDcatidPry, ID de Valor en Catálogo Proyecto">
	<cf_qformsRequiredField args="OBPdescripcion, Descripcion">
	<cf_qformsRequiredField args="OBTPid, ID Tipo Proyecto">
	<cfloop index="LvarNivel" from="1" to="#rsOBTP.OBTPnivelObra-1#">
		<cf_qformsRequiredField args="CFformato#LvarNivel#, Nivel #LvarNivel# de la Cuenta">
	</cfloop>
	<cf_qformsRequiredField args="PCEcatidObr, ID de Catálogo de Obras">
	<cf_qformsRequiredField args="PCEcodigoObr, Catálogo de Obras">
</cf_qforms>
<cfif rsForm.RecordCount EQ 0>
	<form name="formCatalogo" id="formCatalogo" method="post" action="OBproyecto_sql.cfm">
		<table>
			<tr>
				<td colspan="2" class="subTitulo">
					Catálogo para Proyectos: #rsOBTP.PCEcodigoPry# - #rsOBTP.PCEdescripcionPry#
				</td>
			</tr>
			<tr>
				<td>
					<strong>Nuevo valor para el Catálogo</strong>
				</td>
				<td nowrap="nowrap">
					<input type="text" name="PCDvalorPry" id="PCDvalorPry" size="10" maxlength="#rsOBTP.PCElongitud#"
							 onblur="this.value = fnConCeros(this.value, #rsOBTP.PCElongitud#);"
					>
					<input type="text" name="PCDdescripcionPry" id="PCDdescripcionPry" size="40"
					>
					<input type="hidden" name="OBTPid" value="#LvarOBTPid#" />
				</td>
			</tr>
			<tr>
				<td>
					<strong>Nuevo Catálogo para Obras</strong>
				</td>
				<td nowrap="nowrap">
					<input type="text" name="PCEcodigoObr" id="PCEcodigoObr" size="10" maxlength="10"
					>
					<input type="text" name="PCEdescripcionObr" id="PCEdescripcionObr" size="40"
							onfocus="var LvarPry = document.getElementById('PCDdescripcionPry'); if (this.value == '' && LvarPry.value != '') this.value = 'Obras para ' + LvarPry.value;"
					>
				</td>
			</tr>
			<tr><td>&nbsp;</td></tr>
			<tr>
				<td colspan="3" align="center">
					<input type="submit" name="btnAgregarCAT" value="Agregar Valor"/>
				</td>
			</tr>
	</form>
<cf_qforms form="formCatalogo" objForm="LobjQForm_CAT">
	<cf_qformsRequiredField args="PCDvalorPry, Nuevo Valor para Proyecto">
	<cf_qformsRequiredField args="PCDdescripcionPry, Descripción Nuevo Valor para Proyecto">
	<cf_qformsRequiredField args="PCEcodigoObr, Código Nuevo Catálogo para Obras">
	<cf_qformsRequiredField args="PCEdescripcionObr, Descripción Nuevo Catálogo para Obras">
</cf_qforms>
</cfif>
</cfoutput>
