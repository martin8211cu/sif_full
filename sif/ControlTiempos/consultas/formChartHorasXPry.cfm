<!--- Pasa parámetros del url al form--->
<cfif isdefined("url.fecDesde") and len(trim(url.fecDesde))>
	<cfset form.fecDesde = url.fecDesde>
</cfif>
<cfif isdefined("url.fecHasta") and len(trim(url.fecHasta))>
	<cfset form.fecHasta = url.fecHasta>
</cfif>
<cfif isdefined("url.cobrable") and len(trim(url.cobrable))>
	<cfset form.cobrable = url.cobrable>
</cfif>
<cfif isdefined("url.proyecto") and len(trim(url.proyecto))>
	<cfset form.proyecto = url.proyecto>
</cfif>


<!--- parametros para la forma de imprimir --->
<cfset vparams = "">
<cfif isdefined("Form.fecDesde")>
	<cfset vparams = vparams & "&fecDesde=" & form.fecDesde>
</cfif>

<cfif isdefined("Form.fecHasta")>
	<cfset vparams = vparams & "&fecHasta=" & form.fecHasta>
</cfif>

<cfif isdefined("Form.cobrable")>
	<cfset vparams = vparams & "&cobrable=" & Form.cobrable>
</cfif>

<cfif isdefined("Form.proyecto")>
	<cfset vparams = vparams & "&proyecto=" & Form.proyecto>
</cfif>

<cf_dbtemp name="temp" returnvariable="temp">
	<cf_dbtempcol name = "codigo" type = "numeric">
	<cf_dbtempcol name = "descripcion" type = "varchar(50)">
	<cf_dbtempcol name = "horas" type = "numeric">
	<cf_dbtempkey  cols = "codigo">	
</cf_dbtemp>

<cfparam name="Form.fecDesde" default="#now()#">
<cfparam name="Form.fecHasta" default="#now()#">
<cfparam name="Form.cobrable" default="2">
	
<cfparam name="width" default="575">
<cfparam name="height" default="400">

<cfquery name="rsTempInsert" datasource="#session.DSN#">
	Insert into #temp# (codigo, descripcion, horas)
	select P.CTPcodigo as codigo, P.CTPdescripcion as descripcion,
		   sum(T.CTThoras) horas
		   from CTTiempos as T  inner join  CTProyectos as P
				on T.CTPcodigo = P.CTPcodigo and
					 P.Ecodigo =  <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
			 inner join  CTReporteTiempos as R
				on T.CTRcodigo = R.CTRcodigo and
					 R.Ecodigo =  <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
		   where R.CTRfecha >= <cfqueryparam cfsqltype="cf_sql_varchar" value="#LSDAteFormat(Form.fecDesde,'YYYYMMDD')#">
			 and R.CTRfecha <= <cfqueryparam cfsqltype="cf_sql_varchar" value="#LSDAteFormat(Form.fecHasta,'YYYYMMDD')#">
			 <cfif isdefined("Form.cobrable") and (Form.cobrable EQ 0 or Form.cobrable EQ 1)>
			 and P.CTPcobrable = <cfqueryparam cfsqltype="cf_sql_integer" value="#Form.cobrable#">
			 </cfif>
		   group by P.CTPdescripcion
</cfquery>


<cfquery name="rsValores" datasource="#session.DSN#">
	select min(horas) as minimo, max(horas) as maximo 
  	from #temp#
</cfquery>
<cfquery name="rsGrafico" datasource="#session.DSN#">
	select *
	from #temp#
</cfquery>

<cfset minimo = 0>
<cfset maximo = #rsValores.maximo#>

<cfquery name="rsActividades" datasource="#Session.DSN#">
	select A.CTAdescripcion as descripcion,A.CTAcodigo, P.CTPcodigo as cod_proyecto, P.CTPdescripcion as proyecto, sum(T.CTThoras) horas
	from CTActividades A, CTProyectos P, CTReporteTiempos R, CTTiempos T
	where A.CTAcodigo = T.CTAcodigo
	and R.CTRcodigo = T.CTRcodigo
	and P.CTPcodigo = T.CTPcodigo
	and P.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
	and R.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
	and R.CTRfecha >= 	<cfqueryparam cfsqltype="cf_sql_varchar" value="#LSDAteFormat(Form.fecDesde,'YYYYMMDD')#">
	and R.CTRfecha <= <cfqueryparam cfsqltype="cf_sql_varchar" value="#LSDAteFormat(Form.fecHasta,'YYYYMMDD')#">
	<cfif Form.cobrable NEQ 2>
		and P.CTPcobrable = <cfqueryparam cfsqltype="cf_sql_integer" value="#Form.cobrable#">
	</cfif>
	group by A.CTAdescripcion, P.CTPdescripcion
</cfquery>

<cfquery name="rsEmpresa" datasource="#session.DSN#" >
	select Edescripcion from Empresas
 	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
</cfquery>

<script language="JavaScript" type="text/javascript" src="/cfmx/sif/js/qForms/qforms.js"></script>
<script language="JavaScript" type="text/javascript" src="/cfmx/sif/js/utilesMonto.js"></script>
<script language="JavaScript" type="text/javascript" src="/cfmx/sif/js/calendar.js"></script>
<script language="JavaScript" type="text/javascript">
 	// specify the path where the "/qforms/" subfolder is located
	qFormAPI.setLibraryPath("/cfmx/sif/js/qForms/");
	// loads all default libraries
	qFormAPI.include("*");
</script>

<style type="text/css">
	.encabReporte {
		background-color: #006699;
		font-weight: bold;
		color: #FFFFFF;
		padding-top: 5px;
		padding-bottom: 5px;
		padding-left: 5px;
		padding-right: 5px;
	}
	.tbline {
		border-width: 1px;
		border-style: solid;
		border-color: #CCCCCC;
	}
	.bottomline {
		border-bottom-width: 1px;
		border-bottom-style: solid;
		border-right-style: none;
		border-top-style: none;
		border-left-style: none;
		border-bottom-color: #CCCCCC;
	}
	.subTituloRep {
		font-weight: bold; 
		font-size: x-small; 
		background-color: #F5F5F5;
	}
}
</style>

<form method="post" name="form1">

	<cfoutput>
		<cfif not isdefined("url.imprimir")>
			<table width="100%" cellpadding="2" cellspacing="0">
				<tr>
					<td valign="top">
						<cfinclude template="../../portlets/pNavegacion.cfm">
						<cf_rhimprime datos="/sif/ControlTiempos/consultas/formChartHorasXPry.cfm" paramsuri="#vparams#">
					</td>
				</tr>
			</table>	
		</cfif>
	</cfoutput>

	<table width="100%" border="0">
		<tr> 
		  <td nowrap colspan="7">&nbsp;</td>
		</tr>
		<tr> 
		  <td nowrap colspan="7" class="tituloAlterno" align="center"><cfoutput>#rsEmpresa.Edescripcion#</cfoutput></td>
		</tr>
		<tr> 
		  <td nowrap align="right" colspan="7">Fecha del Reporte: <cfoutput>#LSDateFormat (Now(),"dd/mm/yyyy")#</cfoutput></td>
		</tr>
		<cfif isDefined("Form.proyecto") and len(trim(#Form.proyecto#)) gt 0>
			<cfquery name="rsProyecto" dbtype="query">
				select proyecto from rsActividades where proyecto = '#Form.proyecto#'
			</cfquery>
			<tr align="center"> 
				<td nowrap>&nbsp;</td>
				<cfoutput>
				<td nowrap colspan="5"><b>Horas por actividad del proyecto #rsProyecto.proyecto#</b></td>
				</cfoutput>
				<td nowrap>&nbsp;</td>
			</tr>
		<cfelse>
			<tr align="center"> 
				<td nowrap>&nbsp;</td>
				<td nowrap colspan="5"><b>Gráfico de horas por proyecto</b></td>
				<td nowrap>&nbsp;</td>
			</tr>
		</cfif>
		<tr> 
			<cfoutput>
				<td nowrap colspan="7" align="center">
				<b>Reporte desde:&nbsp;</b>#LSDateFormat(fecDesde, 'dd-mm-yyyy')# &nbsp; 
				<b>Hasta:&nbsp;</b>#LSDateFormat(fecHasta, 'dd-mm-yyyy')#</td>
		  </cfoutput>
		</tr>
		<cfif isDefined("Form.proyecto") and len(trim(#Form.proyecto#)) gt 0>
			<tr> 
			  <td nowrap colspan="7">&nbsp;</td>
			</tr>
			<tr>
				<td nowrap>&nbsp;</td>
				<td nowrap colspan="5" align="center">
					<cfquery name="rsActividadesXProyecto" dbtype="query">
						Select descripcion as actividad, horas, cod_proyecto, CTAcodigo
						from rsActividades					
						where proyecto = '#Form.proyecto#'
					</cfquery>
					<table width="100%" border="0" cellpadding="2" cellspacing="0" class="tbline">
						<tr> 
							<td nowrap class="encabReporte" align="center">Actividad</td>
							<td nowrap class="encabReporte" align="right">Horas</td>
						</tr>
						<cfloop query="rsActividadesXProyecto">
							<cfoutput> 
								<tr> 
									<td nowrap align="center" 
										<cfif rsGrafico.CurrentRow MOD 2>class="listaPar"<cfelse>class="listaNon"</cfif>>
										<a href="javascript: detRecursos(#cod_proyecto#,#CTAcodigo#,'#Form.fecDesde#','#Form.fecHasta#','#rsEmpresa.Edescripcion#','#rsProyecto.proyecto#','#actividad#',#Form.cobrable#);">
										#actividad#</a>
									</td>
									<td nowrap align="right" 
										<cfif rsGrafico.CurrentRow MOD 2>class="listaPar"<cfelse>class="listaNon"</cfif>>
										<a href="javascript:detRecursos(#cod_proyecto#,#CTAcodigo#,'#Form.fecDesde#','#Form.fecHasta#','#rsEmpresa.Edescripcion#','#rsProyecto.proyecto#','#actividad#',#Form.cobrable#);">
										#LSCurrencyFormat(horas,'none')#</a>
									</td>
								</tr>
							</cfoutput> 
						</cfloop>
					</table>				
				</td>
				<td nowrap>&nbsp;</td>
			</tr>
		<cfelseif rsGrafico.recordcount GT 0>
			<tr> 
				<td nowrap>&nbsp;</td>
					<td nowrap colspan="2" align="center"> 
						<table width="100%" border="0" cellpadding="2" cellspacing="0" class="tbline">
							<tr> 
								<td nowrap class="encabReporte" align="center">Proyecto</td>
								<td nowrap class="encabReporte" align="right">Horas</td>
						  	</tr>
							<cfloop query="rsGrafico">
								<cfoutput> 
									<tr> 
										<td nowrap align="center" 
										<cfif rsGrafico.CurrentRow MOD 2>class="listaPar"<cfelse>class="listaNon"</cfif>>
										<a href="ChartHorasXPry.cfm?fecDesde=#LSDateFormat(Form.fecDesde)#&fecHasta=#LSDateFormat(Form.fecHasta)#&cobrable=#Form.cobrable#&proyecto=#descripcion#">
											#descripcion#</a></td>
										<td nowrap align="right" 
										<cfif rsGrafico.CurrentRow MOD 2>class="listaPar"<cfelse>class="listaNon"</cfif>>
										<a href="ChartHorasXPry.cfm?fecDesde=#LSDateFormat(Form.fecDesde)#&fecHasta=#LSDateFormat(Form.fecHasta)#&cobrable=#Form.cobrable#&proyecto=#descripcion#">
										#LSCurrencyFormat(horas,'none')#</a></td>
									</tr>
								</cfoutput> 
							</cfloop>
						</table>
					</td>
					<td nowrap valign="middle" align="center">&nbsp;</td>
					<td nowrap colspan="2" valign="middle"> 
						<table width="99%" border="0" dwcopytype="CopyTableCell">
							<tr> 
								<td valign="middle" nowrap align="center"> 
									<script la language="JavaScript1.2" type="text/javascript">
											function Chart_OnClick(theItem){
												<cfoutput query="rsGrafico">
													if ('#descripcion#' == theItem)
														document.form1.proyecto.value = #codigo#;
													document.form1.submit();
												</cfoutput>
											}
									</script>			
									<cfchart format="flash" chartWidth="#width#" chartHeight="#height#"
										scaleFrom=0 scaleTo=10 gridLines=3 show3d="yes"
										url="javascript:Chart_OnClick('$ITEMLABEL$');">
										<cfoutput query="rsGrafico">
											<cfchartseries type="pie">
												<cfoutput>
													<cfchartdata item="#descripcion#" value="#horas#">
												</cfoutput>
											</cfchartseries>
										</cfoutput>
									</cfchart>
								</td>
							</tr>
						</table>
					</td>
				<td nowrap>&nbsp;</td>
			</tr>
		<cfelse>
			<tr valign="middle" align="center">
				<td nowrap colspan="7" align="center">
					<table width="100%" border="0" cellpadding="2" cellspacing="0" class="tbline">
						<tr> 
							<td nowrap align="center" class="listaPar">
								<b>No hay resultados para la consulta actual, con el filtro actual.</b>
							</td>
						</tr>
					</table>
				</td>
			</tr>
		</cfif>
		<tr> 
		  <td nowrap colspan="7">&nbsp;</td>
		</tr>
		<cfif isDefined("Form.proyecto") and len(trim(#Form.proyecto#)) gt 0>
			<tr> 
			  <td nowrap colspan="7"><div align="center">------------------ Fin del Reporte ------------------</div></td>
			</tr>
			<tr><td colspan="7">&nbsp;</td></tr>
			<cfif not isdefined("url.imprimir")>
				<tr>
					<td colspan="7" align="center">
						<cfoutput>
						<input name="Regresa" value="Regresar" type="button" 
						onClick="javascript: dosubmit('#Form.fecDesde#','#Form.fecHasta#',#Form.cobrable#);">
						</cfoutput>
					</td>
				</tr>
			</cfif>
		</cfif>
		
	</table>
</form>

<script language="JavaScript" type="text/javascript">

	function detRecursos(proy,activ,Fdesde,Fhasta, Empr, Proy, Activ, Cobr){
		location.href="/cfmx/sif/ControlTiempos/consultas/recursosXActiv.cfm?CTAcodigo=" + activ +
									"&CTPcodigo=" + proy +
									"&fecDesde=" + Fdesde + 
									"&fecHasta=" + Fhasta +
									"&Empresa=" + Empr + 
									"&Proy=" + Proy + 									
									"&nombreAct=" + Activ +
									"&cobrable=" + Cobr;
	}
	
	function dosubmit(Fdesde,Fhasta,cobrable){
		location.href = "/cfmx/sif/ControlTiempos/consultas/ChartHorasXPry.cfm?fecDesde=" + Fdesde + 
					  	"&fecHasta=" + Fhasta + "&cobrable=" + cobrable;
	}

	//Validaciones del Encabezado Registro de Nomina
	qFormAPI.errorColor = "#FFFFCC";
	objForm = new qForm("form1");
	//Funciones adicionales de validación
	function _Field_isFecha(){
		fechaBlur(this.obj);
		if (this.obj.value.length!=10)
			this.error = "El campo " + this.description + " debe contener una fecha válida.";
	}
	_addValidator("isFecha", _Field_isFecha);	
	//Validaciones del Encabezado
	objForm.fecDesde.required = true;
	objForm.fecDesde.description = "Fecha Desde";
	objForm.fecHasta.required = true;
	objForm.fecHasta.description = "Fecha Hasta";
</script>
