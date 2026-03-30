<cf_template template="#session.sitio.template#">
	<script  language="JavaScript" src="/cfmx/rh/js/DHTMLMenu/stm31.js"></script>

	<cf_templatearea name="title">
		Registro de Evaluaciones 
	</cf_templatearea>
	
	<cf_templatearea name="body">

	  <cf_web_portlet_start border="true" titulo="Evaluaciones" skin="#Session.Preferences.Skin#">

		<cfinclude template="/rh/portlets/pNavegacion.cfm">
		<cfif isdefined("url.RHCconcurso") and not isdefined("Form.RHCconcurso")>
			<cfset form.RHCconcurso = url.RHCconcurso>
		</cfif>
		<cf_translatedata name="get" tabla="CFuncional" col="CFdescripcion" returnvariable="LvarCFdescripcion">
        <cf_translatedata name="get" tabla="RHPuestos" col="RHPdescpuesto" returnvariable="LvarRHPdescpuesto">
         <cf_translatedata name="get" tabla="RHConcursos" col="RHCdescripcion" returnvariable="LvarRHCdescripcion">
		<cfquery name="rsRHConcursos" datasource="#Session.DSN#">
			Select RHCconcurso, RHCcodigo, #LvarRHCdescripcion# as RHCdescripcion, 
				a.CFid, CFcodigo as CFcodigoresp, #LvarCFdescripcion# as CFdescripcionresp, 
				b.RHPcodigo, coalesce(b.RHPcodigoext,b.RHPcodigo) as RHPcodigoext, #LvarRHPdescpuesto# as RHPdescpuesto, RHCcantplazas, a.RHCfecha,
				RHCfapertura, RHCfcierre, a.RHCmotivo, a.RHCotrosdatos, RHCestado, a.Usucodigo, a.ts_rversion
			from RHConcursos a
				left outer join RHPuestos b
					on a.RHPcodigo = b.RHPcodigo
					and a.Ecodigo  = b.Ecodigo
				left outer join CFuncional c
					on a.CFid	   = c.CFid
					and a.Ecodigo  = c.Ecodigo
			where a.Ecodigo 	= <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			  and a.RHCconcurso = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHCconcurso#" >
			order by RHCdescripcion asc
		</cfquery>
		
		<cfquery name="rsBuscaPuesto" datasource="#Session.DSN#">
			select #LvarRHPdescpuesto# as RHPdescpuesto, coalesce(a.RHPcodigoext,a.RHPcodigo) as RHPcodigo
			from RHPuestos a inner join RHConcursos b
			  on a.Ecodigo   = b.Ecodigo and 
				 a.RHPcodigo = b.RHPcodigo
			where b.Ecodigo     = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			  and b.RHCconcurso = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHCconcurso#" >
		</cfquery>

		<form action="ConcursantesSeleccionados.cfm" method="post" name="form1">
			<cfoutput>
				<table width="65%" height="75%" align="center" border="0" cellpadding="0" cellspacing="0">
					<tr><td>&nbsp;</td></tr>
					<tr>
						<td align="right"><strong><cf_translate key="LB_CentroFuncional" xmlFile="/rh/generales.xml">Centro Funcional</cf_translate>:&nbsp;</strong></td>
						<td align="left"  width="55%">#rsRHConcursos.CFcodigoresp# - #rsRHConcursos.CFdescripcionresp#</td>
					</tr>
					<tr><td>&nbsp;</td></tr>					
					<tr>
						<td width="15%" align="right" nowrap><strong><cf_translate key="LB_CodigoDeConcurso" xmlFile="/rh/generales.xml">Código de Concurso</cf_translate>:&nbsp;</strong></td>
						<td width="65%">
							#rsRHConcursos.RHCcodigo# -  #rsRHConcursos.RHCdescripcion#
						</td>
					</tr>
					<tr><td>&nbsp;</td></tr>	
					<tr>
						<td width="18%" align="right">&nbsp;&nbsp;<strong><cf_translate key="LB_Estado" xmlFile="/rh/generales.xml">Estado</cf_translate>:</strong>&nbsp;</td>
						<td align="left"> 
							<cfswitch expression="#rsRHConcursos.RHCestado#">
								<cfcase value="0"><cf_translate key="LB_EnProceso" xmlFile="/rh/generales.xml">En Proceso</cf_translate></cfcase>
								<cfcase value="10"><cf_translate key="LB_Solicitado" xmlFile="/rh/generales.xml">Solicitado</cf_translate></cfcase>
								<cfcase value="20"><cf_translate key="LB_Desierto" xmlFile="/rh/generales.xml">Desierto</cf_translate></cfcase>
								<cfcase value="30"><cf_translate key="LB_Cerrado" xmlFile="/rh/generales.xml">Cerrado</cf_translate></cfcase>
								<cfcase value="15"><cf_translate key="LB_Verificado" xmlFile="/rh/generales.xml">Verificado</cf_translate></cfcase>
								<cfcase value="40"><cf_translate key="LB_Revision" xmlFile="/rh/generales.xml">Revisión</cf_translate></cfcase>
								<cfcase value="50"><cf_translate key="LB_Aplicado" xmlFile="/rh/generales.xml">Aplicado</cf_translate></cfcase>
								<cfcase value="60"><cf_translate key="LB_Evaluando" xmlFile="/rh/generales.xml">Evaluando</cf_translate></cfcase>
							</cfswitch>
						</td>
					</tr>					
				</table>
				<table width="65%" height="75%" align="center" border="0" cellpadding="0" cellspacing="0">
					<tr><td>&nbsp;</td></tr>					
					<tr>
						<td align="right" width="22%" nowrap><strong><cf_translate key="LB_FechaApertura" xmlFile="/rh/generales.xml">Fecha Apertura</cf_translate>:&nbsp;</strong></td>
						<td align="left" width="10%"><cf_locale name="date" value="#rsRHConcursos.RHCfapertura#"/></td>
						<td align="right" width="15%" nowrap><strong><cf_translate key="LB_Cierre" xmlFile="/rh/generales.xml">Fecha Cierre</cf_translate>:</strong>&nbsp;</td>
						<td align="left" width="10%"><cf_locale name="date" value="#rsRHConcursos.RHCfcierre#"/></td>					
					</tr>
					<tr><td>&nbsp;</td></tr>
					<tr>
						<td align="right" width="15%"><strong>&nbsp; <cf_translate key="LB_NPlazas" xmlFile="/rh/generales.xml">N° Plazas</cf_translate>:&nbsp;</strong></td>
						<td align="left"  width="10%">#rsRHConcursos.RHCcantplazas#</td>
						<td align="right" width="15%"><strong><cf_translate key="LB_Puesto" xmlFile="/rh/generales.xml">Puesto</cf_translate>:&nbsp;</strong></td>
						<td align="left"  width="75%">#rsBuscaPuesto.RHPcodigo#- #rsBuscaPuesto.RHPdescpuesto#</td>
					</tr>
			</table>
		</cfoutput>
		<table width="100%" cellpadding="2" cellspacing="0">
			<tr><td>&nbsp;</td></tr>
			<tr>
				<td>
					<cf_web_portlet_start border="true" titulo="Evaluaci&oacute;n de Concursantes" skin="#Session.Preferences.Skin#">
						<table width="100%" cellpadding="2" cellspacing="0">
							<tr>
								<td>
									<cfquery name="rsLista" datasource="#session.DSN#">							
										select  RHCconcurso,RHCPid, DEidentificacion as identificacion,
										<cf_dbfunction name="concat" args="b.DEnombre,' ',b.DEapellido1,'  ',b.DEapellido2" > as Nombre
										from RHConcursantes a inner join  DatosEmpleado b 
										  on a.Ecodigo  = b.Ecodigo and 
											 a.DEid  	= b.DEid
										where a. Ecodigo  =  <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#" >
										  and RHCconcurso =  <cfqueryparam cfsqltype="cf_sql_integer" value="#form.RHCconcurso#" >
										  and RHCdescalifica = 0
										  
										union
										
										select  RHCconcurso,RHCPid, RHOidentificacion as identificacion,
										<cf_dbfunction name="concat" args="b.DEnombre,' ',b.DEapellido1,'  ',b.DEapellido2" > as Nombre
										from RHConcursantes a inner join  DatosOferentes b 
										  on a.Ecodigo = b.Ecodigo and 
											 a.RHOid   = b.RHOid
										where a.Ecodigo   = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#" >
										  and RHCconcurso = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.RHCconcurso#" >										
										   and RHCdescalifica = 0
									</cfquery>
									<cfinvoke
											component="rh.Componentes.pListas"
											method="pListaQuery"
											returnvariable="pListaRet"> 
										<cfinvokeargument name="query" value="#rsLista#"/> 
										<cfinvokeargument name="desplegar" value="identificacion,Nombre"/> 
										<cfinvokeargument name="etiquetas" value="Identificación,Nombre"/> 
										<cfinvokeargument name="formatos" value="S,S"/> 
										<cfinvokeargument name="align" value="left,left"/> 
										<cfinvokeargument name="ajustar" value="N"/> 
										<cfinvokeargument name="checkboxes" value="N"/> 
										<cfinvokeargument name="irA" value="capturanotas.cfm"/>
										<cfinvokeargument name="incluyeform" value="false"/>
										<cfinvokeargument name="formname" value="form1"/>
										<cfinvokeargument name="keys" value="RHCPid"/> 
										<cfinvokeargument name="showEmptyListMsg" value="true"/>		
										<cfinvokeargument name="maxrows" value="10"/>
										<cfinvokeargument name="showlink" value="true"/>
									</cfinvoke>
								</td>
							</tr>
							<tr><td>&nbsp;</td></tr>
						</table>
					<cf_web_portlet_end>
				</td>
			</tr>
			<tr>
				<td align="center">
					<cfoutput>
					<div align="center">
						<input type="button" name="btnRegresar" value="Regresar" onClick="javascript:regresar(#form.RHCconcurso#);">
						<input type="button" name="btnRegresar" value="Lista de Concursos" onClick="javascript:regresarLista();">
					</div>
					</cfoutput>
				</td>
			</tr>
		</table>
	</form>
		  <cf_web_portlet_end>
	</cf_templatearea>
</cf_template>	  

<script language="JavaScript" type="text/JavaScript">
	<!--
	  function regresar(valor) {
	  	eval("document.form1.action='/cfmx/rh/Reclutamiento/operacion/RegistroEval.cfm?RHCconcurso=" + valor + "'");
		document.form1.submit();
	}
	
	function regresarLista(valor) {
	  	eval("document.form1.action='/cfmx/rh/Reclutamiento/operacion/RegistroEval.cfm'");
		document.form1.submit();
	}
</script>
