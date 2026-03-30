<cfquery datasource="#session.dsn#" name="rsForm">
	select tp.OBTPid
	     , tp.OBTPcodigo
	     , tp.OBTPdescripcion
	     , tp.Cmayor
	     , tp.PCEMid
	     , tp.OBTPnivelProyecto, tp.OBTPnivelObra, tp.OBTPnivelObjeto, tp.PCCEclaidOG
	     , tp.PCEcatidPry	, PCEdescripcion
		 , tp.OBTPtipoCtaLiquidacion
	     , tp.BMUsucodigo
	     , tp.ts_rversion
	  from OBtipoProyecto tp
		 left join PCECatalogo c
		   on c.PCEcatid = tp.PCEcatidPry
	 where tp.Ecodigo = #session.Ecodigo#
	   and tp.OBTPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.OBTPid#" null="#Len(form.OBTPid) Is 0#">
</cfquery>

<cfset LvarDependencias = false>
<cfif rsForm.RecordCount GT 0>
	<cfquery datasource="#session.dsn#" name="rsSQL">
		select count(1) as cantidad
		  from OBproyecto p
			inner join OBproyectoReglas pr
			   on pr.Ecodigo = p.Ecodigo
			  and pr.OBPid	 = p.OBPid
		 where p.Ecodigo = #session.Ecodigo#
		   and p.OBTPid  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.OBTPid#" null="#Len(form.OBTPid) Is 0#">
	</cfquery>
	<cfset LvarDependencias = rsSQL.cantidad NEQ 0>
	<cfif NOT LvarDependencias>
		<cfquery datasource="#session.dsn#" name="rsSQL">
			select count(1) as cantidad
			  from OBproyecto p
				inner join OBobra o
				   on o.Ecodigo = p.Ecodigo
			  	  and o.OBPid   = p.OBPid
			 where p.Ecodigo = #session.Ecodigo#
			   and p.OBTPid  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.OBTPid#" null="#Len(form.OBTPid) Is 0#">
		</cfquery>
		<cfset LvarDependencias = rsSQL.cantidad NEQ 0>
	</cfif>
</cfif>

<cfoutput>
<form name="form1" id="form1" method="post" action="OBtipoProyecto_sql.cfm">
	<table summary="Tabla de entrada">
		<tr>
			<td colspan="2" class="subTitulo">
				Tipo Proyecto
			</td>
		</tr>

		<tr>
			<td valign="top">
				<strong>Codigo de Tipo Proyecto</strong>
			</td>
			<td valign="top">

				<input type="text" name="OBTPcodigo" id="OBTPcodigo" 
						value="#HTMLEditFormat(rsForm.OBTPcodigo)#" 
						size="10" maxlength="10"
						onfocus="this.select()"  
				>

			</td>
		</tr>

		<tr>
			<td valign="top">
				<strong>Descripcion de Tipo Proyecto</strong>
			</td>
			<td valign="top">

				<input type="text" name="OBTPdescripcion" id="OBTPdescripcion" 
						value="#HTMLEditFormat(rsForm.OBTPdescripcion)#" 
						size="40" maxlength="40"
						onfocus="this.select()"  
				>

			</td>
		</tr>

		<tr>
			<td valign="top">
				<strong>Cuenta de Mayor</strong>
			</td>
			<td valign="top">
				<cf_conlis
					readonly="#LvarDependencias#"
					Campos="Cmayor, Cdescripcion, OBCliquidacion"
					Desplegables="S,S,N"
					Modificables="S,N,N"
					Size="4,40,0"

					traerInicial="#rsForm.Cmayor NEQ ''#"  
					traerFiltro="m.Ecodigo=#session.Ecodigo# AND m.Cmayor='#rsForm.Cmayor#'"  

					Title="Lista de Cuentas de Mayor definidas en Obras"
					Tabla="
						OBctasMayor om
							inner join CtasMayor m
							   on m.Ecodigo = om.Ecodigo
							  and m.Cmayor	= om.Cmayor
							inner join CPVigencia v
							   on v.Ecodigo = m.Ecodigo
							  and v.Cmayor	= m.Cmayor
							  and #dateFormat(now(),'YYYYMM')# between v.CPVdesdeAnoMes and v.CPVhastaAnoMes
							inner join PCEMascaras ms
							   on ms.PCEMid = v.PCEMid
							  "
					Columnas="om.Cmayor, m.Cdescripcion, ms.PCEMid, ms.PCEMdesc, ms.PCEMformato, om.OBCliquidacion
								, (
									select max(PCNid) 
									  from PCNivelMascara n
									 where n.PCEMid= ms.PCEMid
								   ) as MaxNivel
						"
					Filtrar_por="m.Cmayor, m.Cdescripcion"
					Filtro="om.Ecodigo = #session.Ecodigo#"
					Desplegar="Cmayor, Cdescripcion"
					Etiquetas="Mayor,Descripción"
					Formatos="S,S"
					Align="left,left"

					Asignar="Cmayor, Cdescripcion, PCEMid, PCEMdesc, PCEMformato, MaxNivel, OBCliquidacion"
					Asignarformatos="S,S,S,S,S"
					MaxRowsQuery="200"
					OnBlur="this.value = right('0000'+this.value,4)"
					enterAction="submit"
				/>										
				<script language="javascript">
					function right(LprmHilera, LprmLong)
					{
						var LvarTot = LprmHilera.length;
						return LprmHilera.substring(LvarTot-LprmLong,LvarTot);
					}		 
				</script>
			</td>
		</tr>
		<tr>
			<td valign="top" colspan="2">
				<strong>Interpretación de la Cuenta Financiera:</strong>
			</td>
		</tr>
		<tr>
			<td valign="top">
				<strong>&nbsp;&nbsp;- Máscara de la Cuenta:</strong>
			</td>
			<td valign="top">
				<input type="hidden" name="PCEMid" id="PCEMid" value="#rsForm.PCEMid#">
				<input type="text"   name="PCEMdesc" id="PCEMdesc" value=""
						size="40"
						readonly="yes" tabindex="-1" style="border:solid 1px ##CCCCCC; background:inherit"
				>
			</td>
		</tr>
		<tr>
			<td valign="top">
				<strong>&nbsp;&nbsp;- Numero de Niveles:</strong>
			</td>
			<td valign="top">
				<input type="text"   name="MaxNivel" id="MaxNivel" value=""
						size="2"
						readonly="yes" tabindex="-1" style="border:solid 1px ##CCCCCC; background:inherit"
				>
			</td>
		</tr>
		<tr>
			<td valign="top">
				<strong>&nbsp;&nbsp;- Formato de la Cuenta:</strong>
			</td>
			<td valign="top">
				<input type="text"   name="PCEMformato" id="PCEMformato" value=""
						size="40"
						readonly="yes" tabindex="-1" style="border:solid 1px ##CCCCCC; background:inherit"
				>
			</td>
		</tr>

		<tr>
			<td valign="top">
				<strong>&nbsp;&nbsp;- Nivel de Proyecto:</strong>
			</td>
			<td valign="top">

				<cf_inputNumber	name="OBTPnivelProyecto" 
							value="#HTMLEditFormat(rsForm.OBTPnivelProyecto)#"
							enteros="2" decimales="0"
							modificable="#NOT LvarDependencias#"
				>

				<input type="text"   name="PCEdescripcion" id="PCEdescripcion" value="#rsForm.PCEdescripcion#"
						size="40"
						readonly="yes" tabindex="-1" style="border:solid 1px ##CCCCCC; background:inherit"
				>
			</td>
		</tr>

		<tr>
			<td valign="top">
				<strong>&nbsp;&nbsp;- Nivel de Obra:</strong>
			</td>
			<td valign="top">

				<cf_inputNumber	name="OBTPnivelObra" 
							value="#HTMLEditFormat(rsForm.OBTPnivelObra)#"
							enteros="2" decimales="0"
							modificable="#NOT LvarDependencias#"
				>

			</td>
		</tr>

		<tr>
			<td valign="top">
				<strong>&nbsp;&nbsp;- Nivel de Objeto de Gasto:</strong>
			</td>
			<td valign="top">

				<cf_inputNumber	name="OBTPnivelObjeto" 
							value="#HTMLEditFormat(rsForm.OBTPnivelObjeto)#"
							enteros="2" decimales="0"
							modificable="#NOT LvarDependencias OR rsForm.OBTPnivelObjeto LTE rsForm.OBTPnivelObra#"
				>

			</td>
		</tr>

		<tr><td>&nbsp;</td></tr>
		<tr>
			<td colspan="2" class="formButtons">
			<cfif rsForm.RecordCount>
				<cf_botones  regresar='OBtipoProyecto.cfm' modo='CAMBIO' include="Documentacion">
			<cfelse>
				<cf_botones  regresar='OBtipoProyecto.cfm' modo='ALTA'>
			</cfif>
			</td>
		</tr>
		<tr>
			<td>&nbsp;</td>
		</tr>
	</table>
	<input type="hidden" name="OBTPid" value="#HTMLEditFormat(rsForm.OBTPid)#">
	<input type="hidden" name="BMUsucodigo" value="#HTMLEditFormat(rsForm.BMUsucodigo)#">

	<cfset ts = "">
	<cfinvoke component="sif.Componentes.DButils" method="toTimeStamp"
		artimestamp="#rsForm.ts_rversion#" returnvariable="ts">
	</cfinvoke>
	<input type="hidden" name="ts_rversion" value="#ts#">

	<cf_tabs width="60%">
		<cf_tab text="Parámetros Liquidación" selected="no" id=0>
			<cfinclude template="OBtipoProyecto_formLiq.cfm">
		</cf_tab>
		<cf_tab text="Parámetros Cédula Obras" selected="no">
			<cfinclude template="OBtipoProyecto_formCed.cfm">
		</cf_tab>
	</cf_tabs>
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
		var LvarLeft	= 100;
		var LvarWidth	= screen.width - (LvarLeft*2);
		var LvarTop		= 100;
		var LvarHeight	= screen.height - (LvarTop*2);
		GvarPopUpWinDocumentacion = open("OBdocumentacion.cfm?OBD&OBTPid=#rsForm.OBTPid#&OBPid&OBOid&OBEid", "popUpWinPCCEclaidOG", "title=no,toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbar=yes,resizable=no,copyhistory=yes,left="+ LvarLeft +",top="+ LvarTop +",width="+ LvarWidth +",height="+ LvarHeight +",screenX=0,screenY=0");
		if (!GvarPopUpWinDocumentacion && !GvarPopUpWinWarning) 
		{
			alert('Aviso: Su bloqueador de ventanas emergentes (popup blocker) \nestá evitando que se abra la ventana.\nPor favor revise las opciones de su navegador (browser), y \nacepte las ventanas emergentes de este sitio: ' + location.hostname);
			GvarPopUpWinWarning = true;
		}
		else
			GvarPopUpWinDocumentacion.focus();
		
		return false;
	}

	function fnOBTPnivelProyecto()
	{
		if (parseInt(this.value) == 0)
			this.error = "Nivel de Proyecto no puede ser cero.";
	}
	
	function fnOBTPnivelObra()
	{
		if (parseInt(this.value) == 0)
			this.error = "Nivel de Obra no puede ser cero.";
		else if (parseInt(this.value) <= parseInt(LobjQForm.OBTPnivelProyecto.value))
			this.error = "Nivel de Obra debe ser mayor a Nivel de Proyecto.";
	}

	function fnOBTPnivelObjeto()
	{
		if (parseInt(this.value) == 0)
			this.error = "Nivel de Objeto no puede ser cero.";
		else if (parseInt(this.value) <= parseInt(LobjQForm.OBTPnivelObra.value))
			this.error = "Nivel de Objeto de Gasto debe ser mayor a Nivel de Obra.";
	}
</script>
<cf_qforms form="form1" objForm="LobjQForm">
	<cf_qformsRequiredField args="OBTPcodigo, Codigo de Tipo Proyecto">
	<cf_qformsRequiredField args="OBTPdescripcion, Descripcion de Tipo Proyecto">
	<cf_qformsRequiredField args="Cmayor, Cuenta Mayor">
	<cf_qformsRequiredField args="PCEMid, ID de Máscara de Cmayor">
	<cf_qformsRequiredField args="PCEMformato, Máscara de Cuenta Financiera">
	<cf_qformsRequiredField args="OBTPnivelProyecto, Nivel en Mascara de Proyecto,fnOBTPnivelProyecto">
	<cf_qformsRequiredField args="OBTPnivelObra, Nivel en Mascara de Obra,fnOBTPnivelObra">
	<cf_qformsRequiredField args="OBTPnivelObjeto, Nivel en Mascara de Objecto de Gasto,fnOBTPnivelObjeto">

	<cf_qformsRequiredField args="OBTPCnivel1,Parámetros de Cedula de Obras,fnOBCOdetalle">
	<cf_qformsRequiredField args="OBTPLnivel1,Parámetros de Liquidación,fnOBLdetalle">
</cf_qforms>
</cfoutput>

