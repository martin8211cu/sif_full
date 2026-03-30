

<cfquery datasource="#session.dsn#" name="rsForm_OBetapa">
	select a.Ecodigo
	     , a.OBPid
	     , a.OBOid
	     , a.Ocodigo, o.Oficodigo, o.Odescripcion
	     , a.OBEid
	     , a.OBEdescripcion, a.OBEcodigo
	     , a.OBEtexto
	     , a.OBEestado
	     , a.OBEfechaInicio
	     , a.OBEfechaFinal
	     , a.OBEresponsable
	     , a.OBEfechaInclusion
	     , a.OBEfechaAbierto
	     , a.OBEfechaCerrado
	     , a.BMUsucodigo
	     , a.ts_rversion
		,		case a.OBEestado 
					when '0' then 'Inactivo'
					when '1' then 'Abierto'
					when '2' then 'Cerrado'
				end as Estado
	
	  from OBetapa a
	  	inner join Oficinas o
		   on o.Ecodigo = a.Ecodigo
		  and o.Ocodigo = a.Ocodigo
	 where a.OBEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.OBEid#" null="#Len(form.OBEid) Is 0#">

</cfquery>

<cfoutput>
<form name="form_OBetapa" id="form_OBetapa" method="post" action="OBetapa_sql.cfm">
	<table summary="Tabla de entrada">
		<tr>
			<td colspan="2" class="subTitulo">
				Etapa de una obra
			</td>
		</tr>

		<tr>
			<td valign="top" nowrap="nowrap">
				<strong>Código Etapa</strong>
			</td>
			<td valign="top">

				<input type="text" name="OBEcodigo" id="OBEcodigo" 
						value="#HTMLEditFormat(rsForm_OBetapa.OBEcodigo)#" 
						size="10" maxlength="10"
						onfocus="this.select()"  
				>

			</td>
		</tr>

		<tr>
			<td valign="top">
				<strong>Descripcion</strong>
			</td>
			<td valign="top">

				<input type="text" name="OBEdescripcion" id="OBEdescripcion" 
						value="#HTMLEditFormat(rsForm_OBetapa.OBEdescripcion)#" 
						size="40" maxlength="40"
						onfocus="this.select()"  
				>

			</td>
		</tr>

		<tr>
			<td valign="top">
				<strong>Oficina</strong>
			</td>
			<td valign="top">

				<cf_conlis
					Form="form_OBetapa"
					Campos="Ocodigo, Oficodigo, Odescripcion"
					Desplegables="N,S,S"
					Modificables="N,S,N"
					Size="0,10,40"
					Values="#rsForm_OBetapa.Ocodigo# ,#rsForm_OBetapa.Oficodigo# ,#rsForm_OBetapa.Odescripcion# " 
					Title="Lista de Oficinas del Proyecto"

					Tabla="Oficinas o inner join OBproyectoOficinas op on op.Ecodigo=o.Ecodigo and op.OBPid = #session.obras.OBPid# and op.Ocodigo=o.Ocodigo"
					Columnas="o.Ocodigo, o.Oficodigo, o.Odescripcion"
					Filtro="o.Ecodigo = #session.Ecodigo#"
					Desplegar="Oficodigo, Odescripcion"
					Etiquetas="Código,Descripción"
					Formatos="S,S"
					Align="left,left"

					Asignar="Ocodigo, Oficodigo, Odescripcion"
					Asignarformatos="S,S,S"
					MaxRowsQuery="200"
				/>										

			</td>
		</tr>

		<tr>
			<td valign="top">
				<strong>Texto</strong>
			</td>
			<td valign="top">

				<textarea 	name="OBEtexto" id="OBEtexto"
							style="font-family:Arial, Helvetica, sans-serif;font-size:12px" rows="6" cols="50" 
							onfocus="this.select()"
				>#HTMLEditFormat(rsForm_OBetapa.OBEtexto)#</textarea>

			</td>
		</tr>

		<tr>
			<td valign="top">
				<strong>Estado</strong>
			</td>
			<td valign="top">
			<cfif rsForm_OBetapa.RecordCount>
				<strong>#rsForm_OBetapa.Estado#</strong>
			<cfelse>
				Nuevo
			</cfif>
			</td>
		</tr>

		<tr>
			<td valign="top" nowrap="nowrap">
				<strong>Período Estimado</strong>
			</td>
			<td valign="top" valign="top">
				<table border="0" cellpadding="0" cellspacing="0">
					<tr>
						<td valign="top">
							Inicio:&nbsp;
						</td>
						<td>
							<cf_sifcalendario	name="OBEfechaInicio" 
													value="#DateFormat(rsForm_OBetapa.OBEfechaInicio,'dd/mm/yyyy')#"
													form="form_OBetapa" 
							>
						</td>
						<td>
							&nbsp;&nbsp;&nbsp;&nbsp;
						</td>
						<td valign="top">
							Final:&nbsp;
						</td>
						<td>
							<cf_sifcalendario	name="OBEfechaFinal" 
													value="#DateFormat(rsForm_OBetapa.OBEfechaFinal,'dd/mm/yyyy')#"
													form="form_OBetapa" 
							>
						</td>
					</tr>
				</table>
			</td>
		</tr>

		<tr>
			<td valign="top">
				<strong>Responsable</strong>
			</td>
			<td valign="top">

				<input type="text" name="OBEresponsable" id="OBEresponsable" 
						value="#HTMLEditFormat(rsForm_OBetapa.OBEresponsable)#" 
						size="50" maxlength="255"
						onfocus="this.select()"  
				>

			</td>
		</tr>

		<tr>
			<td colspan="2" class="formButtons">
			<cfif rsForm_OBetapa.RecordCount>
				<cf_botones  regresar='OBetapa.cfm' modo='CAMBIO' include="Documentacion">
			<cfelse>
				<cf_botones  regresar='OBetapa.cfm' modo='ALTA'>
			</cfif>
			</td>
		</tr>
	</table>
	<a name="etapa"></a>
	<input type="hidden" name="Ecodigo" value="#HTMLEditFormat(rsForm_OBetapa.Ecodigo)#">
	<input type="hidden" name="OBPid" value="#HTMLEditFormat(session.obras.OBPid)#">
	<input type="hidden" name="OBOid" value="#HTMLEditFormat(rsForm_OBobra.OBOid)#">
	<input type="hidden" name="OBEid" value="#HTMLEditFormat(rsForm_OBetapa.OBEid)#">
	<input type="hidden" name="BMUsucodigo" value="#HTMLEditFormat(rsForm_OBetapa.BMUsucodigo)#">

	<cfset ts = "">
	<cfinvoke component="sif.Componentes.DButils" method="toTimeStamp"
		artimestamp="#rsForm_OBetapa.ts_rversion#" returnvariable="ts">
	</cfinvoke>
	<input type="hidden" name="ts_rversion" value="#ts#">
</form>

<cf_qforms form="form_OBetapa" objForm="LvarQForm_OBetapa">
	<cf_qformsRequiredField args="OBPid, ID Proyecto">
	<cf_qformsRequiredField args="OBOid, ID Obra">
	<cf_qformsRequiredField args="Ocodigo, Código Oficina">
	<cf_qformsRequiredField args="OBEcodigo, Código de la Etapa">
	<cf_qformsRequiredField args="OBEdescripcion, Descripcion de la Etapa">
</cf_qforms>

<script>
	var GvarPopUpWinEtapaDocumentacion=null;
	var GvarPopUpWinEtapaWarning=null;
	function funcDocumentacion()
	{
		if(GvarPopUpWinEtapaDocumentacion)
		{
			if(!GvarPopUpWinEtapaDocumentacion.closed) GvarPopUpWinEtapaDocumentacion.close();
		}
		var LvarLeft	= 100;
		var LvarWidth	= screen.width - (LvarLeft*2);
		var LvarTop		= 100;
		var LvarHeight	= screen.height - (LvarTop*2);
		GvarPopUpWinEtapaDocumentacion = open("OBdocumentacion.cfm?OBD&OBTPid=#rsOBP.OBTPid#&OBPid=#rsOBP.OBPid#&OBOid=#rsForm_OBobra.OBOid#&OBEid=#rsForm_OBetapa.OBEid#", "popUpWinPCCEclaidOG", "title=no,toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbar=yes,resizable=no,copyhistory=yes,left="+ LvarLeft +",top="+ LvarTop +",width="+ LvarWidth +",height="+ LvarHeight +",screenX=0,screenY=0");
		if (!GvarPopUpWinEtapaDocumentacion && !GvarPopUpWinEtapaWarning) 
		{
			alert('Aviso: Su bloqueador de ventanas emergentes (popup blocker) \nestá evitando que se abra la ventana.\nPor favor revise las opciones de su navegador (browser), y \nacepte las ventanas emergentes de este sitio: ' + location.hostname);
			GvarPopUpWinEtapaWarning = true;
		}
		else
			GvarPopUpWinEtapaDocumentacion.focus();
		
		return false;
	}

	function fnConCeros(LprmHilera, LprmLong)
	{
		LprmHilera = fnTrim(LprmHilera);
		var s = "";
		for (var i=0;i<LprmLong;i++) s=s+"0";
		return fnRight(s + LprmHilera, LprmLong);
	}		 
	function fnConSubrayado(LprmHilera, LprmLong)
	{
		LprmHilera = fnTrim(LprmHilera);
		var s = "";
		for (var i=0;i<LprmLong;i++) s=s+"_";
		return (LprmHilera + s).substring(0, LprmLong);
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
</cfoutput>
