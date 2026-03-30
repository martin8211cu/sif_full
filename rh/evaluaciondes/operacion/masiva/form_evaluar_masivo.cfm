<!--- VARIABLES DE TRADUCCION --->
<cfinvoke key="LB_Las_habilidades_del_puesto" default="Las habilidades del puesto" returnvariable="LB_Mensaje" component="sif.Componentes.Translate" method="Translate"/> 
<cfinvoke key="LB_no_cuentan_con_ningun_cuestionario_asociado" default=", no cuentan con ning&uacute;n cuestionario asociado."returnvariable="LB_Mensaje2" component="sif.Componentes.Translate" method="Translate"/> 
<cfinvoke key="LB_RHAutogestion" default="RH - Autogesti&oacute;n" xmlfile="/rh/generales.xml" returnvariable="LB_RHAutogestion" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_Evaluaciones_del_Desempeno_a_Otro_Grupal" default="Evaluaciones del Desempe&ntilde;o a Otro (Grupal)"returnvariable="LB_Evaluaciones_del_Desempeno_a_Otro_Grupal" component="sif.Componentes.Translate" method="Translate"/>	
<cfinvoke key="BTN_Anterior" default="Anterior" xmlfile="/rh/generales.xml" returnvariable="BTN_Anterior" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="BTN_Siguiente" default="Siguiente" xmlfile="/rh/generales.xml"returnvariable="BTN_Siguiente" component="sif.Componentes.Translate" method="Translate"/>			
<cfinvoke key="BTN_Guardar" default="Guardar" xmlfile="/rh/generales.xml" returnvariable="BTN_Guardar" component="sif.Componentes.Translate" method="Translate"/>	
<cfinvoke key="BTN_Regresar" default="Regresar" xmlfile="/rh/generales.xml" returnvariable="BTN_Regresar" component="sif.Componentes.Translate" method="Translate"/>	
<!--- FIN VARIABLES DE TRADUCCION --->

<cffunction name="traerValorPregunta">
	<cfargument name="PCUid" required="yes" type="numeric">
	<cfargument name="PCid" required="yes" type="numeric">
	<cfargument name="PPid" required="yes" type="numeric">
	<cfargument name="Usucodigo" required="yes" type="numeric">
	<cfargument name="Usucodigoeval" required="yes" type="numeric">
	
	<cfquery name="respuesta" datasource="#session.DSN#">
		select PCUtexto
		from PortalPreguntaU ppu
		
		inner join PortalCuestionarioU pcu
		on ppu.PCUid=pcu.PCUid
		and pcu.PCUid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.PCUid#">
		and pcu.Usucodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.Usucodigo#">
		and pcu.Usucodigoeval=<cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.Usucodigoeval#">
		
		where ppu.PCUid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.PCUid#">
		  and ppu.PCid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.PCid#">
		  and ppu.PPid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.PPid#">	
	</cfquery>
	

	<cfreturn respuesta.PCUtexto >
</cffunction>

<cffunction name="traerValorRespuesta">
	<cfargument name="PCUid" required="yes" type="numeric">
	<cfargument name="PCid" required="yes" type="numeric">
	<cfargument name="PPid" required="yes" type="numeric">
	<cfargument name="PRid" required="yes" type="numeric">
	<cfargument name="Usucodigo" required="yes" type="numeric">
	<cfargument name="Usucodigoeval" required="yes" type="numeric">
	<cfargument name="tipo" required="yes" type="string">	<!--- Para saber si devuelve PRvalorresp o PRid ---> 
	
	<cfquery name="respuesta" datasource="#session.DSN#">
		select pru.PRid, pru.PRUvalorresp
		from PortalRespuestaU pru
		
		inner join PortalPreguntaU ppu
		on pru.PCUid=ppu.PCUid
		and pru.PCid=ppu.PCid
		and pru.PPid=ppu.PPid
		
		inner join PortalCuestionarioU pcu
		on ppu.PCUid=pcu.PCUid
		and pcu.PCUid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.PCUid#">
		and pcu.Usucodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.Usucodigo#">
		and pcu.Usucodigoeval=<cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.Usucodigoeval#">
		
		where pru.PCUid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.PCUid#">
		  and pru.PCid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.PCid#">
		  and pru.PPid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.PPid#">
		  and pru.PRid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.PRid#">
	</cfquery>

	<cfif tipo eq 'PRid'>
		<cfreturn respuesta.PRid >
	<cfelse>
		<cfreturn respuesta.PRUvalorresp >
	</cfif>
</cffunction>

<cfquery name="rsReferencia" datasource="asp">
	select llave
	from UsuarioReferencia
	where Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">
	and Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.EcodigoSDC#">
	and STabla = <cfqueryparam cfsqltype="cf_sql_varchar" value="DatosEmpleado">
</cfquery>

<cfquery name="data_empleado" datasource="#session.DSN#">
	select DEid,{fn concat(DEnombre,{fn concat(' ',{fn concat(DEapellido1,{fn concat(' ',DEapellido2)})})})} as nombre
	from DatosEmpleado
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	and DEid in (#DEid_LIST#)
</cfquery>

<cfquery name="data_relacion" datasource="#session.DSN#">
	select RHEEdescripcion, RHEEtipoeval, TEcodigo
	from RHEEvaluacionDes
	where RHEEid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#RHEEid#">
	  and Ecodigo=<cfqueryparam  cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
</cfquery>


<cfquery name="data_relacion_evaluado" datasource="#session.DSN#">
	select DEid,RHEDtipo, case RHEDtipo when 'J' then 'Jefatura' when 'A' then 'Autoevaluación' when 'S' then 'Colaborador' when 'C' then 'Compañero' end as tipo from RHEvaluadoresDes
	where RHEEid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#RHEEid#">
	  and DEid in (#DEid_LIST#)
	  and DEideval=<cfqueryparam cfsqltype="cf_sql_numeric" value="#DEideval#">
</cfquery>

<cfquery name="data_puesto" datasource="#session.DSN#">
	select RHPdescpuesto
	from RHPuestos
	where RHPcodigo=<cfqueryparam cfsqltype="cf_sql_char" value="#trim(RHPcodigo)#">
</cfquery>

		
<cfquery name="rsTitulos" datasource="#session.DSN#">
		select coalesce(a.RHEEMostrarTitulo,'N') as Quitar
		from RHEEvaluacionDes a
		where a.RHEEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#RHEEid#">
		and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
</cfquery>
<cfif tipo_evaluacion NEQ 2>
	<!--- Evaluacion por habilidades --->
	<!--- 1. Recuperar los cuestionarios asociados a las habilidades --->
	<cfif tipo_evaluacion EQ 1 or tipo_evaluacion EQ 4>
		<cfquery name="dataPCid" datasource="#session.DSN#">
			select distinct b.PCid, PCcodigo
			from RHNotasEvalDes a
			
			inner join RHHabilidadesPuesto b
			on a.RHHid=b.RHHid
			  and b.RHPcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#RHPcodigo#">
			  and b.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			  and b.PCid is not null
			  
			inner join PortalCuestionario c
			on b.PCid=c.PCid	
			
			where a.RHEEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#RHEEid#">
			 and a.DEid in (#DEid_LIST#)
			 
			union
	
			select  b.PCid, c.PCcodigo 
			from RHParametros a
			inner join RHHabilidades b
				on a.Ecodigo = b.Ecodigo
				and b.RHHid =  <cf_dbfunction name="to_number" args="Pvalor">
			inner join  	 PortalCuestionario c
				on b.PCid = c.PCid
		
			where Pcodigo = 830
			and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#"> 	
			 
	
			order by PCcodigo
		</cfquery>
		<cfif dataPCid.recordCount eq 0>
			<cfquery name="RSPuesto" datasource="#session.DSN#">
				select {fn concat(RHPcodigo,{fn concat('-',RHPdescpuesto)})} as RHPdescpuesto  from RHPuestos 
				where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
				and RHPcodigo = '#RHPcodigo#'
			</cfquery>
			
			<cfset mensaje = LB_Mensaje & ' '& RSPuesto.RHPdescpuesto & ' '&  LB_Mensaje2 >
			<cf_throw message=#mensaje# errorcode="8025">
		</cfif>
	</cfif>

	<cfif tipo_evaluacion EQ 3 or tipo_evaluacion EQ 4>
		<cfquery name="dataPCidC" datasource="#session.DSN#">
				select distinct coalesce(a.PCid,coalesce(b.PCid,-1)) as PCid
            from RHConocimientosPuesto a
            inner join RHConocimientos b
                on b.RHCid=a.RHCid
            inner join RHNotasEvalDes c
                on a.RHCid=c.RHCid
            	and c.DEid in (#DEid_LIST#)
                and c.RHCid is not null                
           where a.RHPcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#RHPcodigo#">
			  and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">		
		</cfquery>	
		
	</cfif>
<cfelse>
	<!--- Evaluacion por cuestionario --->
	<cfquery name="dataPCid" datasource="#session.DSN#">
		select a.PCid
		from RHEEvaluacionDes a
		
		inner join PortalCuestionario c
		on a.PCid=c.PCid	
		
		where a.RHEEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#RHEEid#">
		and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	</cfquery>
</cfif>
<cfset listaPCid = ''>
<cfif isdefined('dataPCid')>
	<cfset listaPCid = valuelist(dataPCid.PCid) >
</cfif>
<cfif isdefined('dataPCidC') and dataPCidC.recordcount gt 0 >
	<cfset listaPCidC = valuelist(dataPCidC.PCid)>
	<cfset listaPCid = ListAppend(listaPCid,listaPCidC)>
</cfif>

<cfquery name="datallave" datasource="#session.DSN#">
	select 
		   pp.PPid,pp.PPorden	
	from PortalCuestionario pc
	inner join PortalCuestionarioParte pcp
	on pc.PCid=pcp.PCid
	inner join PortalPregunta pp
	on pp.PCid=pcp.PCid
	and pp.PPparte=pcp.PPparte
	where pc.PCid in (#listaPCid#)
	order by  pp.PPorden
</cfquery>

<cfset form.ultimo = datallave.recordCount>

<cfif not isdefined("form.posicion") and not isdefined("url.posicion")>
	<cfset form.posicion = 1>
</cfif>

<cfloop query="datallave">
	<cfif datallave.currentRow eq form.posicion >
		<cfset form.PPid = datallave.PPid>
		<cfbreak>
	</cfif>
</cfloop>


<cfquery name="data" datasource="#session.DSN#">
	select pc.PCid,
		   pc.PCcodigo,
		   pc.PCnombre,
		   pcp.PPparte,
		   pcp.PCPmaxpreguntas,
		   pcp.PCPdescripcion,
		   pp.PPid,	
		   pp.PPnumero, 
		   pp.PPpregunta,
		   pp.PPmantener,
		   pp.PPtipo,
		   pp.PPrespuesta,
		   pc.PCtiempototal,
		   pp.PPorden,
		   coalesce(pp.PPorientacion,0) as PPorientacion
	
	from PortalCuestionario pc
	
	inner join PortalCuestionarioParte pcp
	on pc.PCid=pcp.PCid
	
	inner join PortalPregunta pp
	on pp.PCid=pcp.PCid
	and pp.PPparte=pcp.PPparte
	and pp.PPid =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.PPid#">
	
	where pc.PCid in (#listaPCid#)
	
	order by  pp.PPorden
</cfquery>

<cfif not isdefined("form.PPid") and not isdefined("url.PPid")>
	<cfset form.PPid = data.PPid>
</cfif>

<cfquery name="partes" datasource="#session.DSN#">
	select PCid, PPparte, PCPmaxpreguntas 
	from PortalCuestionarioParte
	where PCid in (#listaPCid#)
	order by PCid
</cfquery>
		
<cf_templateheader title="#LB_RHAutogestion#">
	<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='#LB_Evaluaciones_del_Desempeno_a_Otro_Grupal#'>		
		<cfoutput>
		<form name="form1" style="margin:0;" method="post" action="evaluar_des-sql.cfm" >
			<table width="98%" border="0" cellpadding="1" cellspacing="0" align="center">
				<tr><td width="45%">&nbsp;</td></tr>
				
				<tr>
					<td align="center" colspan="4">
						<font size="5" style="font-family:Arial, Helvetica, sans-serif ">
							<strong><cf_translate key="LB_EvaluacionDelDesempeno">Evaluaci&oacute;n del Desempe&ntilde;o</cf_translate></strong>
						</font>
					</td>
				</tr>
				
				<tr><td align="center" colspan="4"><font size="3" style="font-family:Arial, Helvetica, sans-serif "><strong>#data_relacion.RHEEdescripcion#</strong></font></td></tr>
				<cfloop query="data" >
					<cfif rsTitulos.Quitar eq 'N'>
						<tr <cfif data.currentRow GT 1 > style="display:none" </cfif> >
							<td align="center" colspan="4"><font size="3" style="font-family:Arial, Helvetica, sans-serif "><strong>#data.PCnombre#</strong></font></td>
						</tr>
					</cfif>
					<tr class="areaFiltro" <cfif data.currentRow GT 1 > style="display:none" </cfif>>
						<td align="left" colspan="4" rowspan="2" valign="top">
							<font size="5" style="font-family:Arial, Helvetica, sans-serif ">
								<strong>#data.PPpregunta#</strong>
							</font>
						</td>
					</tr>
					<tr class="areaFiltro" <cfif data.currentRow GT 1 > style="display:none" </cfif>>
						<td align="left" colspan="1">&nbsp;</td>
					</tr>
				</cfloop>
				<tr>
					<td colspan="4" align="center">
						<table width="100%" cellpadding="0" cellspacing="0">
							<tr><td align="center">
								<div align="center" style=" width:950px; height:400px; border:1px solid ##F1F1F1; overflow:auto; display:block; padding: 10 10 10 10;"> 
									<table width="100%" cellpadding="0" cellspacing="0" border="1">
										<cfset LvarPCid = "">
										<cfset pregunta = "">
										<cfset LvarUsucodigo = "">
										<cfinvoke component="home.Componentes.Seguridad" method="init" returnvariable="sec">
										<cfset rsevaluador = sec.getUsuarioByRef(rsReferencia.llave, session.EcodigoSDC, 'DatosEmpleado')>
										<cfset LvarUsucodigoeval = rsevaluador.Usucodigo >
										
										<cfloop query="data"> 
											<cfset LvarPPorientacion = data.PPorientacion >
											<cfset LvarPCid = data.PCid>
											<cfset pregunta = data.PPid>
											<cfset empleado   = "">
											<cfset Lvar_PCUid = "">
											<cfset Usucodigo = "">
											
											<cfloop query="data_empleado"> 
												<cfset empleado          = data_empleado.DEid>
												<cfset rsevaluando 		 = sec.getUsuarioByRef(empleado, session.EcodigoSDC, 'DatosEmpleado')>
												<cfset Usucodigo         = rsevaluando.Usucodigo>
												<cfset LvarUsucodigo     = LvarUsucodigo & rsevaluando.Usucodigo &','>		
												
												<cfquery name="Tienerespuesta" datasource="#session.DSN#">
													select PCUid from PortalCuestionarioU 
													where DEid 		  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#empleado#">
													and PCUreferencia = <cfqueryparam cfsqltype="cf_sql_numeric" value="#RHEEid#">
													 and Usucodigo     = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Usucodigo#">
													 and Usucodigoeval = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsevaluador.Usucodigo#">
													and DEideval      = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsReferencia.llave#">
												</cfquery>
												<cfif Tienerespuesta.recordCount GT 0>
													<cfset Lvar_PCUid = Tienerespuesta.PCUid>
												<cfelse>
													<cfset Lvar_PCUid = -1>
												</cfif>
												<tr  <cfif data.currentRow GT 1 > style="display:none" </cfif> class="<cfif data_empleado.CurrentRow MOD 2>listaNon<cfelse>listaPar</cfif>">
													<td  width="30%" align="left" valign="top"><strong><font  style="font-size:10px">#data_empleado.nombre#</font></strong></td>
													<td  width="70%" align="left" valign="top"> <cfinclude template="pcontestar-preguntas.cfm"> </td>
												</tr>	
											</cfloop>
											<cfset LvarUsucodigo     = LvarUsucodigo & '-1'>
										</cfloop> 
									</table>	
								</div>
							</td></tr>	
						</table>
					</td>
				</tr>		
			</table>
			<table width="100%" align="center">
				<tr><td align="center">
					<input type="submit" name="_back" value="< #BTN_Anterior#"  <cfif form.posicion eq 1>disabled</cfif>>
					<input type="submit" name="_next" value="#BTN_Siguiente# >" <cfif form.posicion eq form.ultimo>disabled</cfif>>
					<input type="submit" name="guardar" value="#BTN_Guardar#" >
					<input type="button" name="btnRegresar" value="<cfoutput>#BTN_Regresar#</cfoutput>" onclick="javascript: funcRegresar()">
				</td></tr>
				<tr><td>&nbsp;</td></tr>
			</table>
			
			<input type="hidden" name="RHEEid" value="#RHEEid#">
			<input type="hidden" name="DEideval" value="#DEideval#">
			<input type="hidden" name="DEid_LIST" value="#DEid_LIST#">
			<input type="hidden" name="listaPCid" value="#listaPCid#">
			<input type="hidden" name="RHPcodigo" value="#RHPcodigo#">
			<input type="hidden" name="posicion" value="#form.posicion#">
			<input type="hidden" name="ultimo" value="#form.ultimo#">
			<input type="hidden" name="PCid" value="#PCid#">
			<input type="hidden" name="PPid" value="#PPid#">
			<input type="hidden" name="Usucodigoeval" value="#LvarUsucodigoeval#">
			<input type="hidden" name="LvarUsucodigo" value="#LvarUsucodigo#">
		</form>	
		</cfoutput>
	<cf_web_portlet_end>
<cf_templatefooter>

<cfquery name="data_empleado" datasource="#session.DSN#">
	select DEid,{fn concat(DEnombre,{fn concat(' ',{fn concat(DEapellido1,{fn concat(' ',DEapellido2)})})})} as nombre
	from DatosEmpleado
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	and DEid in (#DEid_LIST#)
</cfquery>

<script language="JavaScript1.2" type="text/javascript">
	
	function  funcRegresar(){
		location.href ="evaluar_des-lista2.cfm?RHEEid=<cfoutput>#RHEEid#</cfoutput>&PCid=<cfoutput>#PCid#</cfoutput>";
	}
</script>

