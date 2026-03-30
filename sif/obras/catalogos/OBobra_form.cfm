<cfquery datasource="#session.dsn#" name="rsOBP">
	select 
		   tp.OBTPid, tp.OBTPtipoCtaLiquidacion
		 , p.OBPid, p.OBPcodigo, p.OBPdescripcion, p.PCEcatidObr, p.CFformatoPry
		 , m.PCEMformato
		 , tp.OBTPnivelProyecto, tp.OBTPnivelObra
		 , ec.PCEcodigo, ec.PCEdescripcion, ec.PCElongitud, ec.PCEempresa, ec.PCEoficina
	  from OBproyecto p
		inner join OBtipoProyecto tp
			inner join PCEMascaras m
			   on m.PCEMid	= tp.PCEMid
			on tp.OBTPid = p.OBTPid
		inner join PCECatalogo ec
		   on ec.PCEcatid = p.PCEcatidObr
	  where OBPid = #session.obras.OBPid#
</cfquery>
<cfset LvarCuentaLiquidacion = rsOBP.OBTPtipoCtaLiquidacion GT 1>

<cfquery datasource="#session.dsn#" name="rsForm_OBobra">
	select a.Ecodigo
	     , a.OBPid
	     , a.OBOid
	     , a.OBOcodigo
	     , a.PCDcatidObr
	     , a.OBOdescripcion
	     , a.OBOtexto
	     , a.OBOestado
	     , a.OBOfechaInicio
	     , a.OBOfechaFinal
	     , a.OBOresponsable
	     , a.CFformatoObr
	     , a.OBOfechaInclusion
	     , a.OBOfechaAbierto
	     , a.OBOfechaCerrado
	     , a.OBOfechaLiquidado
	     , a.OBOLidDefault
	     , ld.CFidActivo
	     , ld.CFformatoLiquidacion
	     , ld.CFcuentaActivo, 		'-1' as CcuentaActivoD
	     , a.BMUsucodigo
	     , a.ts_rversion
 		 , (select min(u.Usulogin)
			  from Usuario u
				where u.Usucodigo = a.UsucodigoInclusion) as UsucodigoInclusion
		 , a.OBOavance 
		 ,		case a.OBOestado 
					when '0' then 'Inactivo'
					when '1' then 'Abierto'
					when '2' then 'Cerrado'
				end as Estado
	     , ec.PCEcodigo
	     , ec.PCEdescripcion
	  from OBobra a
	  	inner join PCECatalogo ec
			on ec.PCEcatid = a.PCEcatidOG
	  	left join OBobraLiquidacion ld
			on ld.OBOLid = a.OBOLidDefault
	 where a.OBOid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.OBOid#" null="#Len(form.OBOid) Is 0#">
</cfquery>

<cfquery datasource="#session.dsn#" name="rsSQL">
	select count(1) as cantidad
	  from OBetapa e
		inner join OBetapaCuentas c
		   on c.OBEid = e.OBEid
	 where e.OBOid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.OBOid#" null="#Len(form.OBOid) Is 0#">
</cfquery>
<cfset LvarHayCuentas = (rsSQL.cantidad GT 0)>

<cfoutput>
<form name="form_OBobra" id="form_OBobra" method="post" action="OBobra_sql.cfm">
	<table summary="Tabla de entrada">
		<tr>
			<td colspan="2" class="subTitulo">
				Obra
				<input 	type="hidden"
						name="OBPid" id="OBPid" 
						value="#HTMLEditFormat(rsForm_OBobra.OBPid)#"
				>
			</td>
		</tr>

		<tr>
			<td valign="top">
				<strong>Proyecto</strong>
			</td>
			<td valign="top">
				<strong>#rsOBP.OBPcodigo# - #rsOBP.OBPdescripcion#</strong>
			</td>
		</tr>

		<tr>
			<td valign="top">
				<strong>Codigo de la Obra</strong>
			</td>
			<td valign="top">

				<cf_conlis
					readonly="#LvarHayCuentas#"
					Form="form_OBobra"
					Campos="PCDcatidObr=PCDcatid, OBOcodigo=PCDvalor, OBOdescripcion=PCDdescripcion"
					Desplegables="N,S,S"
					Modificables="N,S,N"
					Size="0,10,40"

					Values="#rsForm_OBobra.PCDcatidObr# ,#rsForm_OBobra.OBOcodigo# ,#replace(rsForm_OBobra.OBOdescripcion,","," ","ALL")# " 

					Title="Valores del Catálogo para la Obra"
					Tabla="PCDCatalogo d"
					Columnas="PCDcatid, PCDvalor, PCDdescripcion"
					Filtro="PCEcatid = #rsOBP.PCEcatidObr#
						and ((select PCEempresa from PCECatalogo where PCEcatid=d.PCEcatid) = 0 OR coalesce(Ecodigo,-1) = #session.Ecodigo#)
						and not exists(select 1 from OBobra where OBPid=#session.obras.OBPid# AND PCDcatidObr=d.PCDcatid)
						order by PCDvalor"
					Desplegar="PCDvalor, PCDdescripcion"
					Etiquetas="Valor,Descripción"
					filtrar_por="PCDvalor, PCDdescripcion"
					Formatos="S,S"
					Align="left,left"

					Asignar="PCDcatidObr, OBOcodigo, OBOdescripcion"
					Asignarformatos="S,S,S"
					MaxRowsQuery="200"
					funcion	= "sbAsignarObra"
				/>										
			</td>
		</tr>

		<tr>
			<td valign="top">
				<strong>Texto</strong>
			</td>
			<td valign="top">

				<textarea 	name="OBOtexto" id="OBOtexto"
							style="font-family:Arial, Helvetica, sans-serif;font-size:12px" 
							onfocus="this.select()"
							 cols="100" rows="3"
				>#HTMLEditFormat(rsForm_OBobra.OBOtexto)#</textarea>

			</td>
		</tr>

		<tr>
			<td valign="top">
				<strong>Estado de la obra</strong>
			</td>
			<td valign="top">
			<cfif rsForm_OBobra.RecordCount>
				<strong>#rsForm_OBobra.Estado#</strong>
			<cfelse>
				Nuevo
			</cfif>
			</td>
		</tr>

		<tr>
			<td valign="top">
				<strong>Período Estimado</strong>
			</td>
			<td valign="top">
				<table border="0" cellpadding="0" cellspacing="0">
					<tr>
						<td valign="top">
							Inicio:&nbsp;
						</td>
						<td>
							<cf_sifcalendario	name="OBOfechaInicio" 
													value="#DateFormat(rsForm_OBobra.OBOfechaInicio,'dd/mm/yyyy')#"
													form="form_OBobra"
							>
						</td>
						<td>
							&nbsp;&nbsp;&nbsp;&nbsp;
						</td>
						<td valign="top">
							Final:&nbsp;
						</td>
						<td>
							<cf_sifcalendario	name="OBOfechaFinal" 
													value="#DateFormat(rsForm_OBobra.OBOfechaFinal,'dd/mm/yyyy')#"
													form="form_OBobra" 
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

				<input type="text" name="OBOresponsable" id="OBOresponsable" 
						value="#HTMLEditFormat(rsForm_OBobra.OBOresponsable)#" 
						size="50" maxlength="255"
						onfocus="this.select()"  
				>

			</td>
		</tr>
		
		<tr>
			<td valign="top">
				<strong>Usuario que incluyó</strong>
			</td>
			<td valign="top">
				<input type="text" name="UsucodigoInclusion" id="UsucodigoInclusion" 
						value="#HTMLEditFormat(rsForm_OBobra.UsucodigoInclusion)#" 
						size="50" maxlength="255"
						onfocus="this.select()" disabled="disabled">
			</td>
		</tr>
		<tr>
			<td valign="top">
				<strong>Porcentaje de Avance</strong>
			</td>
			<td valign="top">
				<input type="text" name="OBOavance" id="OBOavance" 
						value="#HTMLEditFormat(rsForm_OBobra.OBOavance)#" 
						size="5" maxlength="3"
						onfocus="this.select()">%
			</td>
		</tr>

		<tr>
			<td valign="top">
				<strong>Parte fija de Cuenta para Obra</strong>
			</td>
			<td valign="top">
				<table cellpadding="0" cellspacing="0"> 
				<tr>
				<td valign="top" nowrap="nowrap">


			<cfset LvarProyecto_Formato =  rsOBP.CFformatoPry & mid(rsOBP.PCEMformato,len(rsOBP.CFformatoPry)+1,100)>
			<cfif rsForm_OBobra.CFformatoObr EQ "">
				<cfset LvarObra_Formato =  rsOBP.CFformatoPry & mid(rsOBP.PCEMformato,len(rsOBP.CFformatoPry)+1,100)>
			<cfelse>
				<cfset LvarObra_Formato = rsForm_OBobra.CFformatoObr>
			</cfif>
			<cfset LvarObra_Niveles = listToArray(LvarObra_Formato,"-")>
			<cfset LvarProyecto_Niveles = listToArray(LvarProyecto_Formato,"-")>
				<cfset LvarXX = false>
				<cfloop index="LvarIdx" from="1" to="#rsOBP.OBTPnivelObra+1#"><cfif LvarIdx GT 1>-</cfif><input 
						type="text" name="CFformatoObr" id="CFformatoObr" 
						value="#HTMLEditFormat(LvarObra_Niveles[LvarIdx])#" 
						size="#len(LvarObra_Niveles[LvarIdx])#"
						maxlength="#len(LvarObra_Niveles[LvarIdx])#"
					<cfset LvarNiv = LvarIdx - 1>
					<cfif LvarNiv EQ rsOBP.OBTPnivelObra OR LvarNiv LTE rsOBP.OBTPnivelProyecto AND replace(LvarProyecto_Niveles[LvarIdx],"X","","ALL") NEQ "">
						readonly="yes" style="border:solid 1px ##CCCCCC" tabindex="-1"
					<cfelse>
						<cfset LvarXX = true>
						onfocus="this.select();"
						onblur="this.value = fnConCeros(this.value.toUpperCase(),#len(LvarObra_Niveles[LvarIdx])#);"
					</cfif>
				></cfloop>
			</td>
			<td valign="top">
				<cfif LvarXX>Para mantener un nivel variable: Digite todo el nivel con Xs</cfif>
			</td>
			</tr>
			</table>			
		</tr>

		<tr>
			<td valign="top">
				<strong>Complemento Financiero:</strong>
			</td>
			<td valign="top">
				<cfif form.OBOid NEQ "">
					<cfinvoke component	= "sif.Componentes.AplicarMascara"
								method	= "fnComplementoObras"
								OBOid	= "#form.OBOid#"
								conMayor = "true"
								returnvariable = "LvarCuentaC"
					>
	
					#LvarCuentaC# ó #mid(LvarCuentaC,5,100)#
				</cfif>
			</td>
			
		</tr>

		<tr>
			<td valign="top">
				<strong>Catálogo de Objeto de Gasto</strong>
			</td>
			<td valign="top" nowrap="nowrap">
				<input type="text"
						value="#HTMLEditFormat(rsForm_OBobra.PCEcodigo)#" 
						size="10"
						readonly="yes" tabindex="-1" style="border:solid 1px ##CCCCCC; background:inherit"
				>
				<input type="text"
						value="#HTMLEditFormat(rsForm_OBobra.PCEdescripcion)#" 
						size="40"
						readonly="yes" tabindex="-1" style="border:solid 1px ##CCCCCC; background:inherit"
				>

			</td>
		</tr>

		<tr>
			<td colspan="2" class="formButtons">
			<cfif rsForm_OBobra.RecordCount>
				<cf_botones  regresar='OBobra.cfm' modo='CAMBIO' sufijo="Obra" include="Documentacion">
			<cfelse>
				<cf_botones  regresar='OBobra.cfm' modo='ALTA' sufijo="Obra">
			</cfif>
			</td>
		</tr>
	</table>
	<input type="hidden" name="Ecodigo" value="#HTMLEditFormat(rsForm_OBobra.Ecodigo)#">
	<input type="hidden" name="OBOid" value="#HTMLEditFormat(rsForm_OBobra.OBOid)#">
	<input type="hidden" name="OBOLidDefault" value="#HTMLEditFormat(rsForm_OBobra.OBOLidDefault)#">
	<input type="hidden" name="BMUsucodigo" value="#HTMLEditFormat(rsForm_OBobra.BMUsucodigo)#">

	<cfset ts = "">
	<cfinvoke component="sif.Componentes.DButils" method="toTimeStamp"
		artimestamp="#rsForm_OBobra.ts_rversion#" returnvariable="ts">
	</cfinvoke>
	<input type="hidden" name="ts_rversion" value="#ts#">

</form>
<cf_qforms form="form_OBobra" objForm="LvarQform_OBobra">
	<cf_qformsRequiredField args="OBOcodigo, Codigo de la Obra">
	<cf_qformsRequiredField args="PCDcatidObr, ID de Valor en Catalogo Obras">
	<cf_qformsRequiredField args="OBOdescripcion, Descripcion de la Obra">
	<cf_qformsRequiredField args="OBOfechaInicio, Fecha Estimada Inicio">
	<cf_qformsRequiredField args="OBOfechaFinal, Fecha Estimada Final">
	<cf_qformsRequiredField args="OBOresponsable, Responsable">
	<cf_qformsRequiredField args="OBOavance, Porcentaje de Avance">
</cf_qforms>
<cfif rsForm_OBobra.RecordCount EQ 0>
	<form name="formCatalogo" id="formCatalogo" method="post" action="OBobra_sql.cfm">
		<table>
			<tr>
				<td colspan="2" class="subTitulo">
					Catálogo de Obras para el Proyecto: #rsOBP.PCEcodigo# - #rsOBP.PCEdescripcion#
				</td>
			</tr>
			<tr>
				<td>
					<strong>Nuevo valor para el Catálogo</strong>
				</td>
				<td nowrap="nowrap">
					<input type="text" name="PCDvalorObr" id="PCDvalorObr" size="10" maxlength="#rsOBP.PCElongitud#"
							 onblur="this.value = fnConCeros(this.value, #rsOBP.PCElongitud#);"
					>
					<input type="text" name="PCDdescripcionObr" id="PCDdescripcionObr" size="40"
					>
					<input type="hidden" name="PCEcatidObr" id="PCEcatidObr" value="#rsOBP.PCEcatidObr#" />
					<input type="hidden" name="PCEempresa" id="PCEempresa" value="#rsOBP.PCEempresa#" />
					<input type="hidden" name="PCEoficina" id="PCEoficina" value="#rsOBP.PCEoficina#" />
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
	<cf_qformsRequiredField args="PCDvalorObr, Nuevo Valor para Obras">
	<cf_qformsRequiredField args="PCDdescripcionObr, Descripción Nuevo Valor para Obras">
</cf_qforms>
</cfif>
<script language="javascript">
	var GvarPopUpWinObraDocumentacion=null;
	var GvarPopUpWinObraWarning=null;
	function sbAsignarObra()
	{
		form_OBobra.CFformatoObr[#rsOBP.OBTPnivelObra#].value = form_OBobra.OBOcodigo.value;
	}
	function funcDocumentacionObra()
	{
		if(GvarPopUpWinObraDocumentacion)
		{
			if(!GvarPopUpWinObraDocumentacion.closed) GvarPopUpWinObraDocumentacion.close();
		}
		var LvarLeft	= 100;
		var LvarWidth	= screen.width - (LvarLeft*2);
		var LvarTop		= 100;
		var LvarHeight	= screen.height - (LvarTop*2);
		GvarPopUpWinObraDocumentacion = open("OBdocumentacion.cfm?OBD&OBTPid=#rsOBP.OBTPid#&OBPid=#rsOBP.OBPid#&OBOid=#rsForm_OBobra.OBOid#&OBEid", "popUpWinPCCEclaidOG", "title=no,toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbar=yes,resizable=no,copyhistory=yes,left="+ LvarLeft +",top="+ LvarTop +",width="+ LvarWidth +",height="+ LvarHeight +",screenX=0,screenY=0");
		if (!GvarPopUpWinObraDocumentacion && !GvarPopUpWinObraWarning) 
		{
			alert('Aviso: Su bloqueador de ventanas emergentes (popup blocker) \nestá evitando que se abra la ventana.\nPor favor revise las opciones de su navegador (browser), y \nacepte las ventanas emergentes de este sitio: ' + location.hostname);
			GvarPopUpWinObraWarning = true;
		}
		else
			GvarPopUpWinObraDocumentacion.focus();
		
		return false;
	}

	function fnConCeros(LprmHilera, LprmLong)
	{
		LprmHilera = fnTrim(LprmHilera);
		var s = "";
		for (var i=0;i<LprmLong;i++) s=s+"0";
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
</cfoutput>
