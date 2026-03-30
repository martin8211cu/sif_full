<!----=============== VARIABLES DE TRADUCCION =====================--->
<cfinvoke component="sif.Componentes.Translate"	method="Translate"	Key="LB_ListaDePlazas"	Default="Lista de Plazas"	returnvariable="LB_ListaDePlazas"/>		
<cfinvoke component="sif.Componentes.Translate"	method="Translate"	Key="LB_Codigo"	Default="C&oacute;digo"	returnvariable="LB_Codigo"/>		
<cfinvoke component="sif.Componentes.Translate"	method="Translate"	Key="LB_Descripcion" Default="Descripci&oacute;n" returnvariable="LB_Descripcion"/>		
<cfinvoke component="sif.Componentes.Translate"	method="Translate" Key="MSG_EsteValorYaFueAgregado" Default="Este valor ya fue agregado." returnvariable="MSG_EsteValorYaFueAgregado"/>
<cfinvoke component="sif.Componentes.Translate"	method="Translate"	Key="LB_Se_presentaron_los_siguientes_errores"	Default="Se presentaron los siguientes errores"	returnvariable="LB_Se_presentaron_los_siguientes_errores"/>	
<cfinvoke component="sif.Componentes.Translate"	method="Translate"	Key="LB_es_requerido"	Default="es requerido"	returnvariable="LB_es_requerido"/>				
<cfinvoke component="sif.Componentes.Translate"	method="Translate"	Key="LB_Codigo"	Default="C&oacute;digo"	returnvariable="LB_Codigo"/>			
<cfinvoke component="sif.Componentes.Translate"	method="Translate"	Key="LB_Descripcion"	Default="Descripción"	returnvariable="LB_Descripcion2"/>				
<cfinvoke component="sif.Componentes.Translate"	method="Translate"	Key="LB_Plaza"	Default="Plaza"	returnvariable="LB_Plaza"/>	
<cfinvoke component="sif.Componentes.Translate"	method="Translate"	Key="LB_TipoDeNomina" Default="Tipo de Nómina" returnvariable="LB_TipoDeNomina"/>							
<cfinvoke component="sif.Componentes.Translate"	method="Translate"	Key="LB_RegimenDeVacaciones" Default="Régimen de vacaciones" returnvariable="LB_RegimenDeVacaciones"/>	
<cfinvoke component="sif.Componentes.Translate"	method="Translate"	Key="LB_Jornada" Default="Jornada" returnvariable="LB_Jornada"/>	
<cfinvoke component="sif.Componentes.Translate"	method="Translate"	Key="LB_FechaRige"	Default="Fecha rige" returnvariable="LB_FechaRige"/>			
<cfinvoke component="sif.Componentes.Translate"	method="Translate"	Key="LB_ContratacionDirectaDeOferentesSeleccionados" Default="Contrataci&oacute;n directa de los oferentes seleccionados" returnvariable="Titulo"/>
<!----============================================================---->
<title>	
	<cfoutput>#Titulo#</cfoutput>
</title>
<cfif isdefined("url.oferentes") and len(trim(url.oferentes)) gt 0 and not isdefined("form.oferentes")>
	<cfset form.oferentes = url.oferentes>
</cfif>

<cfquery name="rstAccionNomb" datasource="#session.DSN#">
	select RHTcodigo,RHTdesc,RHTid, RHTtiponomb
	from RHTipoAccion 
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">	
		and RHTcomportam in (1<!---,6--->)
	order by RHTcodigo,RHTdesc
</cfquery>


 <cfquery name="rsCandidatos" datasource="#session.DSN#">
	select a.RHOnombre,a.RHOapellido1,a.RHOapellido2,b.NTIdescripcion,a.RHOidentificacion
	from DatosOferentes a
	inner join NTipoIdentificacion b
		on a.NTIcodigo = b.NTIcodigo
		and b.Ecodigo = #Session.Ecodigo#
	where  a.RHOid  in(#form.oferentes#)
	and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
	order by a.RHOnombre,a.RHOapellido1,a.RHOapellido2
</cfquery>	
<cfquery name="rsParam" datasource="#session.DSN#">
	select Pvalor,RHTcodigo,RHTdesc,RHTid, RHTtiponomb 
	from RHParametros a
		left outer join RHTipoAccion b
			on a.Ecodigo = b.Ecodigo
			and a.Pvalor = <cf_dbfunction name="to_char" args="b.RHTid">
	where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#"> 
		and Pcodigo = 460	
</cfquery>		
<!---Tipos de nomina--->
<cfquery name="rstNomina" datasource="#session.DSN#">
	select  Tcodigo,Tdescripcion
	from TiposNomina
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	Order by Tcodigo,Tdescripcion
</cfquery>
<!----Tipos de regimen de vacaciones--->
<cfquery name="rstRegimen" datasource="#session.DSN#">
	select RVid,RVcodigo,Descripcion
	from RegimenVacaciones
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">	
	Order by RVcodigo,Descripcion
</cfquery>
<!---Jornadas---->
<cfquery name="rstJornadas" datasource="#session.DSN#">
	select RHJid,RHJcodigo,RHJdescripcion
	from RHJornadas
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	Order by RHJcodigo,RHJdescripcion
</cfquery>

<script language="JavaScript" type="text/javascript" src="/cfmx/sif/js/qForms/qforms.js"></script>
<script language="JavaScript" type="text/JavaScript">
<!--//
	// specify the path where the "/qforms/" subfolder is located
	qFormAPI.setLibraryPath("/cfmx/sif/js/qForms/");
	// loads all default libraries
	qFormAPI.include("*");
//-->

function MostrarFechaHasta(){ 
	var miOpcion=document.getElementById("RHTid");
	var usarFechaFin=document.getElementById("usarFechaFin");
	
	var casillaFecha1 = document.getElementById("tdFfintxt1");
	var casillaFecha2 = document.getElementById("tdFfintxt2");
   	var opcion = miOpcion.options[ miOpcion.selectedIndex ].title  ;
	if(opcion!=0){
		casillaFecha1.style.display = "";
		casillaFecha2.style.display = "";
		usarFechaFin.value="1";
	}
	else{
		casillaFecha1.style.display = "none";
		casillaFecha2.style.display = "none";
		usarFechaFin.value="0";
	}
}
</script>
<script language="javascript1.2" type="text/javascript" src="/cfmx/rh/js/utilesMonto.js"></script>
 <cf_templatecss>
 <cf_web_portlet_start border="true" titulo="#Titulo#" skin="#Session.Preferences.Skin#">
 <cfoutput>
 <form style="margin:0" name="form1" method="post" action="CDirectaSQL.cfm"><!--- onsubmit="return validar(this);" --->
	 <table width="100%"  border="0" cellspacing="0" cellpadding="0">
		<!----LISTA DE OFERENTES SELECCIONADOS---->
		<tr>
			<td  colspan="2">
				<fieldset><legend><cf_translate key="LB_Candidatos_Seleccionados">Candidatos Seleccionados</cf_translate></legend>
					<table width="100%"  border="0" cellspacing="0" cellpadding="0">
						<tr>
							<td   colspan="2" bgcolor="##CCCCCC"><strong><cf_translate key="LB_IDentificacion">IDentificaci&oacute;n</cf_translate></strong></td>
							<td  bgcolor="##CCCCCC"><strong><cf_translate key="LB_Nombre">Nombre</cf_translate></strong></td>
						</tr>
						<cfloop query="rsCandidatos">
							<tr>
								<td>#rsCandidatos.NTIdescripcion#</td>
								<td>#rsCandidatos.RHOidentificacion#</td>
								<td>#rsCandidatos.RHOnombre#&nbsp;#rsCandidatos.RHOapellido1#&nbsp;#rsCandidatos.RHOapellido2#</td>
							</tr>
						</cfloop>
					</table>	
				</fieldset>
			</td>
		</tr>		
		<!----DATOS SOLICITADOS---->
		<tr>
			<td  colspan="2"><hr></td>
		</tr>	
		<tr>
			<td>
				<table width="100%" cellpadding="2" cellspacing="0" align="center" border="0">
					<tr><td>&nbsp;</td></tr>
					<tr>
						<td align="right" style="font-size:11px"><strong><cf_translate key="LB_Plaza">Plaza</cf_translate>:&nbsp;</strong></td>
						<td style="font-size:11px">
							<cf_conlis title="#LB_ListaDePlazas#"
							campos = "RHPid,RHPcodigo,RHPdescripcion" 
							desplegables = "N,S,S" 
							modificables = "N,S,N" 
							size = "0,10,20"
							asignar="RHPid,RHPcodigo,RHPdescripcion"
							asignarformatos="I,S,S"
							tabla="	RHPlazas a"																	
							columnas="RHPid,RHPcodigo,RHPdescripcion"
							filtro="a.Ecodigo =#session.Ecodigo#
									and a.RHPactiva = 1"
							desplegar="RHPcodigo,RHPdescripcion"
							etiquetas="	#LB_Codigo#, #LB_Descripcion#"
							formatos="S,S"
							align="left,left"
							showEmptyListMsg="true"
							debug="false"
							form="form1"
							width="800"
							height="500"
							left="70"
							top="20"
							filtrar_por="RHPcodigo,RHPdescripcion"
							funcion="funcCargaDatos"
							fparams="RHPid"
							funcionValorEnBlanco="funcLimpiaDatos()">							
						</td>
					</tr>		
					<tr>
						<td align="right" style=" border-bottom:9px; font-size:11px"><strong><cf_translate key="LB_Oficina">Oficina</cf_translate>:&nbsp;</strong></td>
						<td style="font-size:11px">
							<input type="hidden" name="Ocodigo" value="">
							<input name="Oficina" type="text" size="60" style="border:0; " readonly="" value="">						
						</td>
					</tr>
					<tr>
						<td align="right" style="font-size:11px"><strong><cf_translate key="LB_Departamento">Departamento</cf_translate>:&nbsp;</strong></td>
						<td style="font-size:11px">
							<input type="hidden" name="Dcodigo" value="">
							<input name="Depto" type="text" size="60" style="border:0; " readonly="" value="">		
						</td>
					</tr>																		
					<tr>
						<td width="39%" align="right"><strong><cf_translate key="LB_TipoDeAccion">Tipo de acci&oacute;n</cf_translate>:&nbsp;</strong></td>
						<td width="61%">	
							<cfif isdefined("rsParam") and len(trim(rsParam.Pvalor)) EQ 0>
								<input type="hidden" name="bntIndicador" value="true"><!---Input para saber si NO esta asignado el parametro en RHParametros--->
								<select name="RHTid" id="RHTid" onchange="javascript:MostrarFechaHasta()" >				
										<cfloop query="rstAccionNomb">
											<option title="#rstAccionNomb.RHTtiponomb#" value="#rstAccionNomb.RHTid#" <cfif isdefined("rsDatos") and len(trim(rsDatos.RHTid)) and rsDatos.RHTid EQ rstAccionNomb.RHTid>selected</cfif>>#rstAccionNomb.RHTcodigo# - #rstAccionNomb.RHTdesc#</option>
										</cfloop>
									</select>
							<cfelse>		
								<select name="RHTid" id="RHTid" onchange="javascript:MostrarFechaHasta()">		
									<option title="#rsParam.RHTtiponomb#" value="#rsParam.RHTid#">#rsParam.RHTcodigo# - #rsParam.RHTdesc#</option>
								</select>
							</cfif>	
						</td>				
					</tr>
					<tr>
						<td align="right"><strong><cf_translate key="LB_TipoDeNomina">Tipo de n&oacute;mina</cf_translate>:&nbsp;</strong></td>
						<td>
							<cf_rhtiponominaCombo index="0" todas="False">
							<!---<select name="Tcodigo" id="Tcodigo">					
								<cfloop query="rstNomina">
									<option value="#rstNomina.Tcodigo#">#rstNomina.Tcodigo# - #rstNomina.Tdescripcion#</option>
								</cfloop>
							</select>--->
						</td>			
					</tr>
					<tr>
						<td align="right"><strong><cf_translate key="LB_FechaRige">Fecha rige</cf_translate>:&nbsp;</strong></td>
						<td>
							<cf_sifcalendario conexion="#session.DSN#" form="form1" name="DLfvigencia" value="#LSDateFormat(Now(), 'dd/mm/yyyy')#">
						</td>
					</tr>
					
					<tr>
						
						<td align="right">
							<div id="tdFfintxt1" style="display:none;">
								<strong><cf_translate key="LB_FechaRige">Fecha Hasta</cf_translate>:&nbsp;</strong></td>
							</div>		
						<td>
							<div id="tdFfintxt2" style="display:none;">
								<cf_sifcalendario conexion="#session.DSN#" form="form1" name="DLffin" value="#LSDateFormat(Now(), 'dd/mm/yyyy')#">
							</div>	
						</td>
						
					</tr>
					
					<tr>	
						<td align="right"><strong><cf_translate key="LB_RegimenDeVacaciones">R&eacute;gimen de vacaciones</cf_translate>:&nbsp;</strong></td>
						<td>
							<select name="RVid" id="RVid">					
								<cfloop query="rstRegimen">
									<option value="#rstRegimen.RVid#">#rstRegimen.RVcodigo# - #rstRegimen.Descripcion#</option>
								</cfloop>
							</select>
						</td>			
					</tr>
					<tr>	
						<td align="right"><strong><cf_translate key="LB_ProcentajeOcupacion">Porcentaje Ocupaci&oacute;n</cf_translate>:&nbsp;</strong></td>
						<td><input name="RHAporc" type="text" size="10" maxlength="8" value="100.00" onBlur="javascript:fm(this,2)" onKeyUp="javascript:if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}" style="text-align:right">%</td>
					</tr>	
					<tr>	
						<td align="right"><strong><cf_translate key="PorcentajeSalarioFijo">Porcentaje Salario Fijo</cf_translate>:&nbsp;</strong></td>
						<td><input name="RHAporcsal" type="text" size="10" maxlength="8" value="100.00" onBlur="javascript:fm(this,2)" onKeyUp="javascript:if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}" style="text-align:right">%</td>
					</tr>
					<tr>	
						<td align="right"><strong><cf_translate key="LB_Jornada">Jornada</cf_translate>:&nbsp;</strong></td>
						<td>
							<select name="RHJid" id="RHJid">					
								<cfloop query="rstJornadas">
									<option value="#rstJornadas.RHJid#">#rstJornadas.RHJcodigo# - #rstJornadas.RHJdescripcion#</option>
								</cfloop>
							</select>
						</td>
					</tr>
					<tr>	
						<td align="right"><strong><cf_translate key="LB_SalarioBase">Salario base</cf_translate>:&nbsp;</strong></td>
						<td><input name="DLsalario" type="text" size="20" maxlength="18" value="" onBlur="javascript:fm(this,2)" onKeyUp="javascript:if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}" style="text-align: right;"></td>
					</tr>
					<tr><td>&nbsp;</td></tr>
				</table>
			</td>
		</tr>	
		<!----Fin de datos solicitados--->
		<tr>
			<td  colspan="2">
				<cf_botones include = "btnAplicar,btnCerrar" includevalues = "Aplicar,Cerrar" regresarMenu='true' exclude='Alta'>
			</td>
		</tr>
	 </table>
	 <input type="hidden" name="oferentes" id="oferentes" value="#form.oferentes#">
	 <input type="hidden" name="usarFechaFin" id="usarFechaFin" value="0">
 	 <input type="hidden" name="RHCcantplazas" id="RHCcantplazas" value="0">
	<iframe id="OficinaDepartamento" frameborder="0" name="OficinaDepartamento" width="0" height="0" style="visibility:none;border:none;"></iframe>
 </form>
 </cfoutput>
<cf_web_portlet_end>

<cf_qforms>

<script type="text/javascript" language="javascript1.2">
	function funcCargaDatos(prn_RHPid){		
		document.getElementById("OficinaDepartamento").src="CDirectaBuscaDatos.cfm?RHPid="+prn_RHPid;
	}
	function funcbtnCerrar(){
		window.close();
	}
	function funcLimpiaDatos(){
		document.form1.Ocodigo.value = '';
		document.form1.Oficina.value = '';
		document.form1.Dcodigo.value = '';
		document.form1.Depto.value = '';
	}
	MostrarFechaHasta();
</script>

<script language="javascript" type="text/javascript">
	objForm.RHPid.description = "<cfoutput>#LB_Plaza#</cfoutput>";
	objForm.Tcodigo.description = "<cfoutput>#LB_TipoDeNomina#</cfoutput>";	
	objForm.RVid.description = "<cfoutput>#LB_RegimenDeVacaciones#</cfoutput>";
	objForm.RHJid.description = "<cfoutput>#LB_Jornada#</cfoutput>";
	objForm.DLfvigencia.description  = "<cfoutput>#LB_FechaRige#</cfoutput>";
	objForm.RHPid.required = true;
	objForm.Tcodigo.required = true;
	objForm.RVid.required = true;
	objForm.RHJid.required = true;
	objForm.DLfvigencia.required = true;
</script>