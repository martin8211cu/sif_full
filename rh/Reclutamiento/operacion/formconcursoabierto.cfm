<!---- Pregunto por el Ecodigo del curso, pues puede que sea de otra empresa de la corporacion ---->
<cfquery name="rsEcodigo" datasource="#session.DSN#">
   select Ecodigo from RHConcursos 
    where RHCconcurso = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHCconcurso#" >
</cfquery>
<cfif isdefined('rsEcodigo') and len(trim(rsEcodigo.Ecodigo)) gt 0>
    <cfif rsEcodigo.Ecodigo eq session.Ecodigo>
       <cfset varEcodigo = session.Ecodigo>
    <cfelse>
       <cfset varEcodigo = rsEcodigo.Ecodigo>
    </cfif>
</cfif>

<!--- Datos de la Empresa --->
<cf_translatedata tabla="Empresas" col="Edescripcion" name="get" returnvariable="LvarEdescripcion"/>
<cfquery name="rsEmpresa" datasource="#session.DSN#">
	select #LvarEdescripcion# as Edescripcion from Empresas
 	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#varEcodigo#">
</cfquery>

<cfset modo = "ALTA">
<cfif isDefined("varEcodigo") and isDefined("form.RHCconcurso") and len(trim(#form.RHCconcurso#)) NEQ 0>
    <cf_translatedata name="get" tabla="RHConcursos" col="RHCdescripcion" returnvariable="LvarRHCdescripcion"> 
    <cf_translatedata name="get" tabla="CFuncional" col="CFdescripcion" returnvariable="LvarCFdescripcion">
    <cf_translatedata name="get" tabla="RHPuestos" col="RHPdescpuesto" returnvariable="LvarRHPdescpuesto">
    <cf_translatedata name="get" tabla="RHDescriptivoPuesto" col="RHDPobjetivos" returnvariable="LvarRHDPobjetivos">
    <cf_translatedata name="get" tabla="RHDescriptivoPuesto" col="RHDPmision" returnvariable="LvarRHDPmision">
	<cfquery name="rsRHConcursos" datasource="#Session.DSN#" >
		Select RHCconcurso, RHCcodigo, #LvarRHCdescripcion# as RHCdescripcion, 
			a.CFid, CFcodigo as CFcodigoresp, #LvarCFdescripcion# as CFdescripcionresp, 
			a.RHPcodigo, coalesce(b.RHPcodigoext,b.RHPcodigo) as RHPcodigoext,#LvarRHPdescpuesto# as RHPdescpuesto, RHCcantplazas, a.RHCfecha,
			RHCfapertura, RHCfcierre, a.RHCmotivo, a.RHCotrosdatos, RHCestado, a.Usucodigo, a.ts_rversion,c.CFcodigo,#LvarCFdescripcion# as CFdescripcion,RHCotrosdatos,
			#LvarRHDPobjetivos# as RHDPobjetivos,<cf_dbfunction name="date_format" args="a.horafin,hh:mi"> as horafin,#LvarRHDPmision# as RHDPmision
        from RHConcursos a
			left outer join RHPuestos b
					left outer join RHDescriptivoPuesto p
				  	on b.RHPcodigo = p.RHPcodigo and 
					b.Ecodigo = p.Ecodigo 
				on a.RHPcodigo = b.RHPcodigo
				and a.Ecodigo  = b.Ecodigo
			left outer join CFuncional c
				on a.CFid 	  = c.CFid
				and a.Ecodigo = c.Ecodigo 
			<!--- inner join sdc..Usuario d
                on a.Usucodigo = d.Usucodigo --->
		where a.Ecodigo 	= <cfqueryparam cfsqltype="cf_sql_integer" value="#varEcodigo#">
		  and a.RHCconcurso = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHCconcurso#" >
		order by RHCdescripcion asc
	</cfquery>

	<cfquery name="rsBuscaPuesto" datasource="#Session.DSN#">
		select #LvarRHPdescpuesto# as RHPdescpuesto, coalesce(a.RHPcodigoext,a.RHPcodigo) as RHPcodigoext,b.RHPcodigo
		from RHPuestos a inner join RHConcursos b
		  on a.Ecodigo   = b.Ecodigo and
		 	 a.RHPcodigo = b.RHPcodigo
		where b.Ecodigo	  = <cfqueryparam cfsqltype="cf_sql_integer" value="#varEcodigo#">
		and b.RHCconcurso = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHCconcurso#" >
	</cfquery>
	<cfif rsRHConcursos.recordcount>
		<cfset modo = "CAMBIO">
	</cfif> 
	<cfquery name="rsBuscaSolicitante" datasource="#session.DSN#">
		select distinct 
				c.Usucodigo,
				'00' as Ulocalizacion,
				c.Usulogin, 
				{fn concat(d.Pnombre,{fn concat(' ',{fn concat(d.Papellido1,{fn concat(' ',d.Papellido2)})})})} as Usunombre,
				d.Pemail1
			from UsuarioProceso a inner join Empresa b
			  on a.Ecodigo = b.Ecodigo,
				 Usuario c inner join DatosPersonales d
		      on c.datos_personales = d.datos_personales
			where c.Usucodigo = <cfif isdefined("rsConsulta") and rsConsulta.RecordCount GT 0>
									<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsRHConcursos.Usucodigo#">
							   <cfelse>
							   		<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
								</cfif>
				and b.Ereferencia = <cfqueryparam cfsqltype="cf_sql_numeric" value="#varEcodigo#" >
				and c.Utemporal = 0
				and c.Uestado = 1
			order by c.Usulogin 
	</cfquery>
	<cfquery name="rsConsultaEmailConcursante" datasource="#session.DSN#">
		select DEemail
		from DatosEmpleado
		where DEidentificacion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.datos_personales.ID#">
	</cfquery>
	
	<cfquery name="rsConsultaDtosP" datasource="#session.DSN#">
		select Pid
		from DatosPersonales a
		inner join Usuario b
		on a.datos_personales = b.datos_personales
		where b.Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsRHConcursos.Usucodigo#">
	</cfquery>
	
	<cfquery name="rsConsultaEmailSolicitante" datasource="#session.DSN#">
		select DEemail
		from DatosEmpleado
		where DEidentificacion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsConsultaDtosP.Pid#">
	</cfquery>
	<cfquery name="rsBuscaConcursante" datasource="#session.DSN#">
		select distinct 
				c.Usucodigo,
				'00' as Ulocalizacion,
				c.Usulogin, 
				{fn concat(d.Pnombre,{fn concat(' ',{fn concat(d.Papellido1,{fn concat(' ',d.Papellido2)})})})} as Usunombre
			from UsuarioProceso a inner join Empresa b
			  on a.Ecodigo = b.Ecodigo,
				 Usuario c inner join DatosPersonales d
		      on c.datos_personales = d.datos_personales
			where c.Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
				and b.Ereferencia = <cfqueryparam cfsqltype="cf_sql_numeric" value="#varEcodigo#" >
				and c.Utemporal = 0
				and c.Uestado = 1
			order by c.Usulogin 
	</cfquery>		
</cfif>
<cf_translatedata name="get" tabla="RHEAreasEvaluacion" col="RHEAdescripcion" returnvariable="LvarRHEAdescripcion">
<cfquery name="rsAreasConsulta" datasource="#session.DSN#">
	Select b.RHEAcodigo as Codigo, #LvarRHEAdescripcion# as Descrip, a.RHAECpeso as peso
	From RHAreasEvalConcurso a inner join RHEAreasEvaluacion b
	  on a.RHEAid = b.RHEAid 
	Where a.Ecodigo 	= <cfqueryparam cfsqltype="cf_sql_integer" value="#varEcodigo#">
	  and a.RHCconcurso = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHCconcurso#" >
</cfquery>

<style type="text/css">
	.Reporte {
		background-color: #F3F3F3;
		font-weight: bold;
		color: #FFFFFF;
		padding-top: 10px;
		padding-bottom: 10px;
		padding-left: 10px;
		padding-right: 10px;
	}
	.topline {
		border-top-width: 1px;
		border-top-style: solid;
		border-right-style: none;
		border-bottom-style: none;
		border-left-style: none;
		border-top-color: #CCCCCC;
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
<cfoutput>
<form  action="sqlconcursoabierto.cfm" method="post" name="form1">
<!--- Variables de Traduccion --->
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_InscripcionAConcurso"
	Default="Inscripci&oacute;n a Concurso"
	returnvariable="LB_InscripcionAConcurso"/>

<cf_web_portlet_start border="true" titulo="#LB_InscripcionAConcurso#" skin="#Session.Preferences.Skin#">
	
		<table width="100%" height="75%" align="center" border="0" cellpadding="0" cellspacing="0">
			 <tr><td width="1%" align="left">&nbsp;</td></tr>
			<tr>
			  <td width="2%" align="center">&nbsp;</td>
			  <td width="65%" align="center"><fieldset class="reporte">
				<table width="50%" border="0" cellpadding="0" cellspacing="0">
                  <tr><td colspan="4">&nbsp;</td></tr>
                  <tr>
                    <td width="19%" align="right"><strong><cf_translate key="LB_Concurso">Concurso</cf_translate>:&nbsp;</strong></td>
                    <td colspan="3"> #rsRHConcursos.RHCcodigo# - #rsRHConcursos.RHCdescripcion# </td>
                  </tr>
                  <tr><td colspan="4">&nbsp;</td></tr>
				    <tr>
                    <td width="19%" align="right"><strong><cf_translate key="LB_CentroFuncional" xmlFile="/rh/generales.xml">Centro Funcional</cf_translate>:&nbsp;</strong></td>
                    <td colspan="3"> #rsRHConcursos.CFcodigo# - #rsRHConcursos.CFdescripcion# </td>
                  </tr>
                  <tr><td colspan="4">&nbsp;</td></tr>
				   <tr>
                    <td width="19%" align="right"><strong><cf_translate key="LB_Mision">Misión</cf_translate>:&nbsp;</strong></td>
                    <td colspan="3"> #rsRHConcursos.RHDPmision#</td>
                  </tr>
                  <tr><td colspan="4">&nbsp;</td></tr>
				  <tr>
                    <td width="19%" align="right" nowrap="nowrap" colspan="2"><strong><cf_translate key="LB_ReqAdicionales">Requisitos Adicionales</cf_translate>:&nbsp;</strong></td>
                    <td colspan="2"> #rsRHConcursos.RHCotrosdatos#</td>
                  </tr>
                  <tr><td colspan="4">&nbsp;</td></tr>
                  <tr>
                    <td align="right" width="19%" nowrap><strong>&nbsp; &nbsp;<cf_translate key="LB_FechaApertura">Fecha Apertura</cf_translate>:&nbsp;</strong></td>
                    <td align="left" width="32%"><cfif modo neq "ALTA">
                        <cfset fechaI = #rsRHConcursos.RHCfapertura# >
                        <cfelse>
                        <cfset fechaI = '' >
                      </cfif>
      #LSDateFormat(fechaI,'dd/mm/yyyy')# </td>
                    <td width="11%" align="left" nowrap><strong>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<cf_translate key="LB_FechaCierre">Fecha Cierre</cf_translate>:</strong>&nbsp;</td>
                    <td width="38%" align="left" ><cfif modo neq "ALTA">
                        <cfset fechaF = #rsRHConcursos.RHCfcierre# >
                        <cfelse>
                        <cfset fechaF = '' >
                      </cfif>
      #LSDateFormat(fechaF,'dd/mm/yyyy')# </td>
                  </tr>
                  <tr><td colspan="4">&nbsp;</td></tr>
                  <tr>
                    <td align="right" width="19%"><strong><cf_translate key="LB_Puesto" xmlFile="/rh/generales.xml">Puesto</cf_translate>:&nbsp;</strong></td>
                    <cfif isDefined("varEcodigo") and isDefined("form.RHCconcurso") and len(trim(#form.RHCconcurso#)) NEQ 0>
                      <td align="left" colspan="3" width="32%">#rsBuscaPuesto.RHPcodigoext#-&nbsp;#rsBuscaPuesto.RHPdescpuesto#</td>
                    </cfif>
                  </tr>
                  <tr><td colspan="4">&nbsp;</td></tr>
                  <tr>
                    <td width="19%" align="right"><strong>&nbsp; <cf_translate key="LB_NoPlazas" xmlFile="/rh/generales.xml">N&deg; Plazas</cf_translate>:&nbsp;</strong></td>
                    <td width="32%" align="left"> #rsRHConcursos.RHCcantplazas# </td>
					<td align="right" width="19%"><strong><cf_translate key="LB_Hora">Hora Cierre</cf_translate>:&nbsp;</strong></td>
					 <td>#rsRHConcursos.horafin#</td>
                  </tr>
                  <tr><td colspan="4">&nbsp;</td></tr>
                  <tr>
                    <td align="right"><strong><cf_translate key="LB_Solicitante">Solicitante</cf_translate>:</strong>&nbsp;</td>
                    <td align="left" nowrap>#rsBuscaSolicitante.Usunombre#</td>
                  </tr>
                  <tr><td colspan="4">&nbsp;</td></tr>
                  <tr><td colspan="4">&nbsp;</td></tr>
                  <tr>
                    <td align="center" colspan="4">
<!--- Variables de Traduccion --->
						<cfinvoke component="sif.Componentes.Translate"
							method="Translate"
							Key="BTN_ConsultarPuesto"
							Default="Consultar Puesto"
							returnvariable="BTN_ConsultarPuesto"/>
						<cfinvoke component="sif.Componentes.Translate"
							method="Translate"
							Key="BTN_Inscripcion"
							Default="Inscripci&oacute;n"
							XmlFile="/rh/generales.xml"
							returnvariable="BTN_Inscripcion"/>
						<cfinvoke component="sif.Componentes.Translate"
							method="Translate"
							Key="BTN_Regresar"
							Default="Regresar"
							XmlFile="/rh/generales.xml"
							returnvariable="BTN_Regresar"/>
                            
						<cfoutput>		
                        	
                        <cfquery datasource="#session.dsn#" name="rsValidaInscrito">
                         select count(1) as valor
                         from RHConcursantes
                         where Usucodigo = #session.Usucodigo#
                         and RHCconcurso =#form.RHCconcurso# 
                        </cfquery>
                        
						<input name="ConsultarPuesto" type="button" value="#BTN_ConsultarPuesto#" tabindex="1" onClick="javascript: funcConsultaPuesto();">
                        <cfif rsValidaInscrito.valor eq 0>
							<input name="Inscripcion" type="submit" value="#BTN_Inscripcion#" tabindex="1" onClick="javascript: funcInscripcion();">
                        <cfelse>
                       		<input name="Inscripcion" type="button"  value="#BTN_Inscripcion#" tabindex="1" onClick="javascript: alert('Ya te encuentras Inscrito a este Curso')">
                        </cfif>
                        <input name="Regresar" type="button" value="#BTN_Regresar#" tabindex="1" onClick="javascript: funcRegresar();">
						</cfoutput>
                    </td>
                  </tr>
                  <tr><td colspan="4">&nbsp;</td></tr>
                </table>
			</fieldset>
		</td>
		<td width="" valign="top"><fieldset>
			<table width="100%" align="center" border="0" cellspacing="0" cellpadding="0" class="Ayuda">
				<tr><td>&nbsp;</td></tr>
				<tr>
					<td>&nbsp;</td>
					<td align="center">
						<cf_translate key="LB_InscripcionAlConcursoSolicitadoPorLaEmpresa">
						Inscripci&oacute;n al concurso solicitado por la Empresa 
						</cf_translate>
						<strong>#rsEmpresa.Edescripcion#</strong> 
						<cf_translate key="LB_ParaUnoDeSusPuestos">
						para uno de sus puestos.
						</cf_translate>
					</td>
					<td>&nbsp;</td>
			  	</tr>
				<tr><td>&nbsp;</td></tr>
		  </table>
			</fieldset></td>
		</tr>
		
		 <tr><td width="1%" align="center">&nbsp;</td></tr>
	</table>
	
		<br>
	<!--- <cf_botones values= "Consultar Puesto, Inscripci&oacute;n, Regresar" names = "ConsultaPuesto,Inscripcion,Regresar"> --->
	<cfsavecontent variable="MsgCon">
		<html>
			<body>
				
				<cf_translate key="LB_UstedHaSidoInscritoEnElConcurso">Usted ha sido inscrito en el concurso</cf_translate>  #rsRHConcursos.RHCdescripcion#, <cf_translate key="LB_ParaElPuesto">para el puesto</cf_translate> #rsBuscaPuesto.RHPdescpuesto# <br>
				<cf_translate key="LB_SolicitadoPor">solicitado por</cf_translate> #rsBuscaSolicitante.Usunombre#.
				<cf_translate key="LB_ElConcursoSeAbrioElDia">El concurso se abri&oacute; el d&iacute;a</cf_translate> #LSDateFormat(fechaI,'dd/mm/yyyy')# <br>		
				<cf_translate key="LB_YSeCierraElDia">y se cierra el d&iacute;a</cf_translate> #LSDateFormat(fechaF,'dd/mm/yyyy')#.
			</body>
		</html>
	</cfsavecontent>
	<cfsavecontent variable="MsgSol">
		<html>
			<body>
				<cf_translate key="LB_ElSeñor(a)">El señor(a)</cf_translate> #rsBuscaConcursante.Usunombre# <cf_translate key="LB_SeHaInscritoEnElConcurso">se ha inscrito en el concurso</cf_translate> #rsRHConcursos.RHCdescripcion#, <br>
				<cf_translate key="LB_ParaElPuesto">para el puesto</cf_translate> #rsBuscaPuesto.RHPdescpuesto#, <cf_translate key="LB_ElCualHaSidoSolicitadoPorUsted">el cual ha sido solicitado por Usted</cf_translate>.
			</body>
		</html>
	</cfsavecontent>
	
	<cfset ts = "">
	<cfif modo NEQ "ALTA">
		<cfinvoke component="sif.Componentes.DButils" method="toTimeStamp"returnvariable="ts">
			<cfinvokeargument name="arTimeStamp" value="#rsRHConcursos.ts_rversion#"/>
		</cfinvoke>
	</cfif> 
	<input name="RHCconcurso" type="hidden" 
		value="<cfif isdefined("form.RHCconcurso")and (form.RHCconcurso GT 0)><cfoutput>#form.RHCconcurso#</cfoutput></cfif>">
	<input name="RHPcodigo" type="hidden" 
		value="<cfif isdefined("rsRHConcursos.RHPcodigo")and (rsRHConcursos.RHPcodigo GT 0)><cfoutput>#rsRHConcursos.RHPcodigo#</cfoutput></cfif>">
	<input type="hidden" name="ts_rversion" value="<cfif modo NEQ "ALTA">#ts#</cfif>" size="32">
	<input type="hidden" name="Inscribe" value="no">
	<input type="hidden" name="MsgConcursante" value="#MsgCon#">
	<input type="hidden" name="MsgSolicitante" value="#MsgSol#">
	<input type="hidden" name="EmailSol" value="#rsConsultaEmailSolicitante.DEemail#">
	<input type="hidden" name="EmailCon" value="#rsConsultaEmailConcursante.DEemail#">	
	<cf_web_portlet_end>
</form>
</cfoutput>
<cf_qforms form="form1">

<!--- Variables de Traduccion --->
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_DeseaInscribirseEnElConcurso"
	Default="Desea inscribirse en el concurso"
	returnvariable="MSG_DeseaInscribirseEnElConcurso"/>

<SCRIPT LANGUAGE="JavaScript">
<!--
	
	
	function funcInscripcion(){
		if (confirm('¿<cfoutput>#MSG_DeseaInscribirseEnElConcurso#</cfoutput>?')){
			document.form1.Inscribe.value = 'si';
			return true;
		}else{
			document.form1.Inscribe.value = 'no';
			return false;
		}
	}
	
	function funcRegresar() {
		location.href = 'listaconcursoabiertos.cfm';
	}
	
	function funcConsultaPuesto(){
	var params ="";
		params = "<cfoutput>?RHPcodigo=#rsRHConcursos.RHPcodigo#</cfoutput>";
		popUpWindowPuestos("/cfmx/rh/Reclutamiento/operacion/consultaPuesto.cfm"+params,75,50,850,630);
	}
	
	var popUpWin=0;
	//Levanta el Conlis
	function popUpWindowPuestos(URLStr, left, top, width, height)
	{
		if(popUpWin)
		{
			if(!popUpWin.closed) popUpWin.close();
		}
		popUpWin = open(URLStr, 'popupWindow', 'toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=yes,resizable=no,copyhistory=yes,width='+width+',height='+height+',left='+left+',top='+top+',screenX='+left+',screenY='+top);
	}
//-->
</SCRIPT>
