<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Autoevaluacion"
	Default="Autoevaluación"
	returnvariable="LB_Autoevaluacion"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Jefe"
	Default="Jefe"
	returnvariable="LB_Jefe"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Subordinado"
	Default="Subordinado"
	returnvariable="LB_Subordinado"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Companero"
	Default="Compañero"
	returnvariable="LB_Companero"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_JefeAlterno"
	Default="Jefe Alterno"
	returnvariable="LB_JefeAlterno"/>
<!--- Estilo para titulos --->
<style type="text/css" >
	.tituloProceso {
		font-family: "Times New Roman", Times, serif;
		font-size: 13pt;
		font-variant: small-caps;
	}
	.titulos {
		font-weight:bold;
		font-size: 10pt;
	}
	
	.Encabezado1 {
		font-family: "Times New Roman";
		font-size: 18pt;  color:black;
		font-variant: small-caps;
	}		
	.Encabezado2 {
	 font-family:Georgia, "Times New Roman", Times, serif;
		font-size: 15pt; color:black;
		font-variant: small-caps;
	}		
	.Encabezado3 {
		font-family:Georgia, "Times New Roman", Times, serif;
		font-size: 13pt; color:black;
		font-variant: small-caps;   
	}	
	
</style>
<cfquery name="data_relacion" datasource="#session.DSN#">
	select 
		d.RHRSdescripcion,
		d.RHRStipo,
		c.RHRSid,
		a.DEid,
		a.DEideval,
		case RHEVtipo  
		when  'A' then '#LB_Autoevaluacion#'
		when  'J' then '#LB_Jefe#' 
		when  'C' then '#LB_Companero#'
		when 'E' then '#LB_JefeAlterno#'  
		when  'S' then '#LB_Subordinado#'
		end as RHERtipo
	from RHRSEvaluaciones a
	inner join RHDRelacionSeguimiento c
		on a.RHDRid= c.RHDRid
	inner join RHRelacionSeguimiento d
		on c.RHRSid = d.RHRSid
	where a.RHRSEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHRSEid#">
</cfquery>
 
<cfquery name="RSUltima" datasource="#session.DSN#">
	select max(RHRSEid) as RHRSEid 
	from RHDRelacionSeguimiento a
	inner join 	RHRSEvaluaciones b
		on a.RHDRid = b.RHDRid	
		and b.DEid 		 = <cfqueryparam cfsqltype="cf_sql_numeric" value="#data_relacion.DEid#">
		and b.DEideval 	 = <cfqueryparam cfsqltype="cf_sql_numeric" value="#data_relacion.DEideval#">
		and b.RHRSEestado   in(20,30)
		and b.RHRSEid < <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHRSEid#">
	where  a.RHRSid	 = <cfqueryparam cfsqltype="cf_sql_numeric" value="#data_relacion.RHRSid#">
</cfquery>

<cfquery name="RSCerradas" datasource="#session.DSN#">
		select  yy.RHIEid 
		from RHRERespuestas yy
		where coalesce(yy.RHIEestado,0) != 0 
		and yy.RHRSEid in (
			select RHRSEid 
			from RHDRelacionSeguimiento a
			inner join 	RHRSEvaluaciones b
				on a.RHDRid = b.RHDRid	
				and b.DEid 		 = <cfqueryparam cfsqltype="cf_sql_numeric" value="#data_relacion.DEid#">
				and b.DEideval 	 = <cfqueryparam cfsqltype="cf_sql_numeric" value="#data_relacion.DEideval#">
				and b.RHRSEestado   in( 20,30)
				and b.RHRSEid < <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHRSEid#">
			where  a.RHRSid	 = <cfqueryparam cfsqltype="cf_sql_numeric" value="#data_relacion.RHRSid#">
		) 
</cfquery>
<cfset lista_RHIEid = "">
<cfloop query="RSCerradas">
	<cfset lista_RHIEid = lista_RHIEid & RSCerradas.RHIEid & ','>
</cfloop>
<cfset lista_RHIEid = lista_RHIEid & '-1'>



<cfif isdefined("RSUltima") and  RSUltima.recordCount eq 0>
	<cfset RSUltima.RHRSEid = -1>
</cfif>


<cfquery name="data_empleado" datasource="#session.DSN#">
	select {fn concat(DEnombre,{fn concat(' ',{fn concat(DEapellido1,{fn concat(' ',DEapellido2)})})})} as nombre
	from DatosEmpleado
	where DEid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#data_relacion.DEid#">
</cfquery>
<cfset form.DEid = data_relacion.DEid>
<cfset form.TipoEval = data_relacion.RHRStipo>
<cfset form.DEideval = data_relacion.DEideval>
<cfquery name="data_Evaluador" datasource="#session.DSN#">
	select {fn concat(DEnombre,{fn concat(' ',{fn concat(DEapellido1,{fn concat(' ',DEapellido2)})})})} as nombre
	from DatosEmpleado
	where DEid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#data_relacion.DEideval#">
</cfquery>

<cfquery name="data_cfuncional" datasource="#session.DSN#">
	select b.CFid, CFdescripcion,RHPpuesto
	from LineaTiempo a, RHPlazas b, CFuncional c
	where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	  and a.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#data_relacion.DEid#">
	  and getdate() between a.LTdesde and a.LThasta
	  and a.RHPid = b.RHPid
	  and a.Ecodigo = b.Ecodigo
	  and b.CFid=c.CFid
	  and b.Ecodigo=c.Ecodigo
</cfquery>
<cfquery name="data_puesto" datasource="#session.DSN#">
	select RHPdescpuesto
	from RHPuestos
	where RHPcodigo=<cfqueryparam cfsqltype="cf_sql_char" value="#trim(data_cfuncional.RHPpuesto)#">
</cfquery>
<cfoutput>
<form name="form2" action="evaluar_des-sql.cfm" method="post" onSubmit="return validar();"  >
	<input type="hidden" name="RHRSEid" value="#form.RHRSEid#">
	<input type="hidden" name="tipo" value="#form.tipo#">
	<table width="98%" border="0" cellpadding="1" cellspacing="0" align="center">
			
			<tr><td width="60%">&nbsp;</td></tr>
			<tr>
				<td colspan="4" align="center">
					<table width="100%" cellpadding="0" cellspacing="0" class="areaFiltro">
						<tr>
							<td class="Encabezado1"  align="left" colspan="4">
									<cf_translate key="LB_GestionDelTalento">Gesti&oacute;n del Talento</cf_translate>
							</td>
						</tr>
						<tr>
							<td  class="Encabezado2" align="left" colspan="4">
								<cf_translate key="LB_Evaluacion_por">Evaluaci&oacute;n por</cf_translate><cfif data_relacion.RHRStipo eq 'O'><cf_translate key="LB_Objetivos">objetivos</cf_translate><cfelse><cf_translate key="LB_Comportamientos">comportamientos</cf_translate></cfif>
								
							</td>
						</tr>
						<tr><td class="Encabezado3" align="left" colspan="4">#data_relacion.RHRSdescripcion#</td></tr>
						<tr><td colspan="4"><hr/></td></tr>
						
						
						<tr>
							<td width="1%" valign="top"><cfinclude template="/rh/expediente/catalogos/frame-foto.cfm"></td>
							<td valign="top">
								<table width="100%">
									<tr>
										<td class="titulos" colspan="2" valign="top" >
											<font size="4"><strong><cf_translate key="LB_DatosDeLaPersonaEvaluada">Datos de la persona Evaluada</cf_translate></strong></font>
										</td>
										<td class="titulos" colspan="2" valign="top" ><font size="4"><strong>Datos del Evaluador</strong></font></td>
									</tr>	
									<tr>
										<td class="titulos" width="1%" nowrap ><cf_translate key="LB_Nombre">Nombre</cf_translate>:&nbsp;</td>
										<td class="titulos">#data_empleado.nombre#</td>
										<td colspan="2" class="titulos" ><cf_translate key="LB_Nombre">Nombre</cf_translate>:&nbsp;#data_Evaluador.nombre#</td>
									</tr>
									<cfif data_cfuncional.RecordCount gt 0>
										<tr>
											<td width="1%" nowrap class="titulos"><cf_translate key="LB_Puesto">Puesto</cf_translate>:&nbsp;</td>
											<td class="titulos">#data_puesto.RHPdescpuesto#</td>
											<td colspan="2" class="titulos" >Relaci&oacute;n con la persona evaluada:</td>
										</tr>
										<tr>
											<td width="1%" nowrap class="titulos"><cf_translate key="LB_CentroFuncional">Centro Funcional</cf_translate>:&nbsp;</td>
											<td class="titulos">#data_cfuncional.CFdescripcion#</td>
											<td colspan="2" class="titulos" >#data_relacion.RHERtipo#</td>
										</tr>
									</cfif>
								</table>	
							</td>		
						</tr>
					</table>
				</td>
			</tr>
	</table>
</form>
</cfoutput>