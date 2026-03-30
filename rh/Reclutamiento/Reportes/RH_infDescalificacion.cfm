<!--- VARIABLES DE TRADUCCION --->
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Codigo"
	Default="C&oacute;digo"
	XmlFile="/rh/generales.xml"
	returnvariable="LB_Codigo"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Descripcion"
	Default="Descripci&oacute;n"
	XmlFile="/rh/generales.xml"
	returnvariable="LB_Descripcion"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Interno"
	Default="Interno"
	returnvariable="LB_Interno"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Externo"
	Default="Externo"
	returnvariable="LB_Externo"/>
<!---*******************************  Captura de parametros   *******************************--->

<cfif isdefined("url.RHCconcurso")>
	<cfset Form.RHCconcurso = url.RHCconcurso>
</cfif>

<cfif isdefined("url.RHCPid")>
	<cfset Form.RHCPid = url.RHCPid>
</cfif>

<!---*******************************  Declaración de variables *******************************--->

<!---******************  Encabezado 				******************--->
<cf_translatedata tabla="Empresas" col="e.Edescripcion" name="get" returnvariable="LvarEdescripcion"/>
<cfquery name="rsEmpresa" datasource="#session.DSN#">
	select #LvarEdescripcion# as Edescripcion from Empresas
 	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
</cfquery>

<cfquery name="rsConsulta" datasource="#session.DSN#">
	select RHCPtipo
	from RHConcursantes
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
	  and RHCPid = <cfqueryparam cfsqltype="cf_sql_integer" value="#RHCPid#">
</cfquery>

<!---******************  Encabezado 				******************--->
<cfquery name="RSEncabezado" datasource="#Session.DSN#">
	select a.RHCcodigo,RHCdescripcion,a.RHPcodigo,coalesce(b.RHPcodigoext,b.RHPcodigo) as RHPcodigoext,RHPdescpuesto,RHCPid, 
		<cfif isdefined("rsConsulta") and rsConsulta.RecordCount GT 0 and rsConsulta.RHCPtipo EQ 'I'>
		c.DEid, 
		{fn concat(d.DEnombre,{fn concat(' ',{fn concat(d.DEapellido1,{fn concat(' ',d.DEapellido2)})})})}  as nombre,
		DEidentificacion
		<cfelse>
		c.RHOid, 
		{fn concat(d.RHOnombre,{fn concat(' ',{fn concat(' ',d.RHOapellido2)})})}  as nombre,
		 RHOidentificacion
		 </cfif> as identificacion
		,RHCPtipo, RHCrazondeacalifica
	from RHConcursos a inner join RHPuestos b
	  on a.RHPcodigo   = b.RHPcodigo and
		 a.Ecodigo     = b.Ecodigo inner join RHConcursantes c
	  on a.RHCconcurso = c.RHCconcurso inner join 
	  <cfif isdefined("rsConsulta") and rsConsulta.RecordCount GT 0 and rsConsulta.RHCPtipo EQ 'I'>
	  	DatosEmpleado d
	  on c.DEid        = d.DEid
	  <cfelse>
	  	DatosOferentes d 
	  on c.RHOid       = d.RHOid
	  </cfif>
	where a.RHCconcurso  = <cfqueryparam cfsqltype="cf_sql_integer" value="#RHCconcurso#">
	  and c.RHCPid       = <cfqueryparam cfsqltype="cf_sql_integer" value="#RHCPid#">

</cfquery>

<!---******************  Áreas de pintado 		    ******************--->
<!---******************  Encabezado 				******************--->
<link href="/cfmx/plantillas/login02/sif_login02.css" rel="stylesheet" type="text/css">

<cfset vparams ="">
<cfset vparams = vparams & "&RHCconcurso=" & form.RHCconcurso>
<cfset vparams = vparams & "&RHCPid=" & form.RHCPid>


	<cfoutput>
		<cfif not isdefined("url.imprimir")>
			<table width="100%" cellpadding="2" cellspacing="0">
				<tr>
					<td valign="top">
						<cf_rhimprime datos="/rh/Reclutamiento/Reportes/RH_infDescalificacion.cfm" paramsuri="#vparams#">
											
					</td>	
				</tr>
			</table>	
		</cfif>
	</cfoutput>


<table  width="100%"  align="center"border="0">
	<tr>
		<td  align="center" colspan="3"><font size="2"><strong><cfoutput>#rsEmpresa.Edescripcion#</cfoutput></strong></font></td>
	</tr>
	<tr>
		<td  align="center" colspan="3"><font size="2"><strong><cf_translate key="LB_ReporteDeDescalificacion">Reporte de Descalificaci&oacute;n</cf_translate> </strong></font></td>
	</tr>
	<tr>
		<td colspan="3" align="right"><cfoutput><cf_translate key="LB_Fecha">Fecha</cf_translate>: #LSDateFormat(Now(),"dd/mm/yyyy")#</cfoutput></td>
	</tr>
	<tr>
		<td width="5%"></td>
		<td width="21%" align="left" ><cf_translate key="LB_NConcurso">C&oacute;d. Concurso</cf_translate>:</td>
		<td width="74%"><strong><cfoutput>#RSEncabezado.RHCcodigo#</cfoutput></strong></td>
	</tr>
	<tr>
		<td></td>
		<td align="left">#LB_Descripcion#:</td>
		<td><strong><cfoutput>#RSEncabezado.RHCDESCRIPCION#</cfoutput></strong></td>
	</tr>
	<tr>
		<td></td>
		<td align="left" ><cf_translate key="LB_Puesto">Puesto</cf_translate>:</td>
		<td><strong><cfoutput>#RSEncabezado.RHPcodigoext# #RSEncabezado.RHPDESCPUESTO#</cfoutput></strong></td>
	</tr>
	<tr>
		<td></td>
		<td align="left"><cf_translate key="LB_Nombre">Nombre</cf_translate>:</td>
		<td><strong><cfoutput>#RSEncabezado.nombre#</cfoutput></strong></td>
	</tr>
	<tr>
		<td></td>
		<td align="left"><cf_translate key="LB_Identificacion">Identificaci&oacute;n</cf_translate>:</td>
		<td><strong><cfoutput>#RSEncabezado.identificacion#</cfoutput></strong></td>
	</tr>
	<cfoutput>
	<tr>
		<td></td>
		<td align="left"><cf_translate key="LB_TipoDeConcursante">Tipo de Concursante</cf_translate> :</td>
			<cfswitch expression="#RSEncabezado.RHCPtipo#">
				<cfcase value = "I">
					<td><strong>#LB_Interno#</strong></td>
				</cfcase>
				<cfcase value = "E">
					<td><strong>#LB_Externo#</strong></td>
				</cfcase>
			</cfswitch>
	</tr>
	<tr><td>&nbsp;</td></tr>
	<tr>
		<td colspan="3">
			<!---******************  Motivo de la descalificacion		******************--->
			<fieldset ><legend><strong><cf_translate key="LB_MotivoDeLaDescalificacion">Motivo de la descalificaci&oacute;n</cf_translate></strong></legend>
			<table  width="95%"  align="center"border="0">
				<tr>
					<td>
						#RSEncabezado.RHCrazondeacalifica#
					</td>
				</tr>
			</table>
			</fieldset>
		</td>
	</tr>
	</cfoutput>
</table>
<script language="javascript1.2" type="text/javascript">
	<!--
	<cfoutput>
	function imprimir() { 
		<cfset request.Lovarimprime = 1> alert (#request.Lovarimprime#);
		var BTN_IMG = document.getElementById("BTN_IMG");
		 BTN_IMG.style.display = 'none';
		<cfif  isdefined("form.DEid") and not isdefined("url.DEid")>
			var BTN_REG = document.getElementById("BTN_REG");
			BTN_REG.style.display = 'none';
		</cfif>
		window.print()	
        BTN_IMG.style.display = ''
		<cfif  isdefined("form.DEid") and not isdefined("url.DEid")>
			BTN_REG.style.display = '';
		</cfif>
	}
	function atras() {
		history.back();
	}
</cfoutput>
//-->
</script>