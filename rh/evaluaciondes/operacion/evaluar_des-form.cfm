
<cffunction name="fvalor" returntype="string">
	<cfargument name="RHEEid" type="numeric" required="true">
	<cfargument name="DEid" type="numeric" required="true">
	<cfargument name="DEideval" type="numeric" required="true">
	<cfargument name="item" type="numeric" required="true">
	<cfargument name="tipo" type="string" required="true">
	
	<cfquery name="nota" datasource="#session.DSN#">
		select RHDEnota
		from RHDEvaluacionDes
		where RHEEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.RHEEid#">
		  and DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.DEid#">
		  and DEideval = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.DEideval#">
		  
		<cfif arguments.tipo eq 'H'>
			and RHIHid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.item#">
		<cfelse>
			and RHICid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.item#">
		</cfif>
		  
	</cfquery>
	
	<cfif nota.RecordCount gt 0>
		<cfreturn nota.RHDEnota >
	<cfelse>
		<cfreturn '' >
	</cfif>

</cffunction>

<cffunction name="fvalordesc" returntype="string">
	<cfargument name="TEcodigo" type="numeric" required="true">
	<cfargument name="valor" type="string" required="true">
	
	<cfquery name="notadesc" datasource="#session.DSN#">
		select TEVnombre 
		from TablaEvaluacion a, TablaEvaluacionValor b
		where a.TEcodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.TEcodigo#"> 
		  and a.Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		  and b.TEVvalor=<cfqueryparam cfsqltype="cf_sql_char" value="#trim(arguments.valor)#"> 
		  and a.TEcodigo=b.TEcodigo		  
	</cfquery>
	
	<cfif notadesc.RecordCount gt 0>
		<cfreturn notadesc.TEVnombre >
	<cfelse>
		<cfreturn '-' >
	</cfif>

</cffunction>

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

</style>
<!--- --------------- --->

<cfset modo = 'ALTA'>

<cfquery name="data_relacion" datasource="#session.DSN#">
	select RHEEdescripcion, RHEEtipoeval, TEcodigo, PCid
	from RHEEvaluacionDes
	where RHEEid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHEEid#">
	  and Ecodigo=<cfqueryparam  cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
</cfquery>

<cfquery name="data_relacion_evaluado" datasource="#session.DSN#">
	select RHEDtipo, case RHEDtipo when 'J' then 'Jefatura' when 'A' then 'Autoevaluación' when 'S' then 'Colaborador' when 'C' then 'Compañero' end as tipo 
	from RHEvaluadoresDes
	where RHEEid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHEEid#">
	  and DEid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid#">
	  and DEideval=<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsEmpleado.DEid#">
</cfquery>

<cfif ucase(trim(data_relacion.RHEEtipoeval)) eq 'T'>
	<cfquery name="data_tabla_eval" datasource="#session.DSN#">
		select TEVvalor,  TEVnombre
		from TablaEvaluacion a, TablaEvaluacionValor b
		where a.TEcodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#data_relacion.TEcodigo#">
		and a.Ecodigo=<cfqueryparam  cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		and a.TEcodigo=b.TEcodigo
		order by TEVequivalente desc	
	</cfquery>
</cfif>

<cfquery name="data_empleado" datasource="#session.DSN#">
	select {fn concat(DEnombre,{fn concat(' ',{fn concat(DEapellido1,{fn concat(' ',DEapellido2)})})})} as nombre
	from DatosEmpleado
	where DEid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid#">
</cfquery>

<cfquery name="data_cfuncional" datasource="#session.DSN#">
	select b.CFid, CFdescripcion
	from LineaTiempo a, RHPlazas b, CFuncional c
	where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	  and a.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid#">
	  and getdate() between a.LTdesde and a.LThasta
	  and a.RHPid = b.RHPid
	  and a.Ecodigo = b.Ecodigo
	  and b.CFid=c.CFid
	  and b.Ecodigo=c.Ecodigo
</cfquery>

<cfquery name="data_puesto" datasource="#session.DSN#">
	select RHPdescpuesto
	from RHPuestos
	where RHPcodigo=<cfqueryparam cfsqltype="cf_sql_char" value="#trim(form.RHPcodigo)#">
    and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
</cfquery>

<cfquery name="data_items_habilidades" datasource="#session.DSN#">
	select 	b.RHHid, 
			b.RHHdescripcion, 
			c.RHHtipo 
	from RHNotasEvalDes a, RHHabilidades b, RHHabilidadesPuesto c 
	where a.RHEEid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHEEid#">
	  and a.DEid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid#">
	  and c.RHPcodigo=<cfqueryparam cfsqltype="cf_sql_char" value="#trim(form.RHPcodigo)#">
	  and a.RHHid=b.RHHid
	  and b.RHHid=c.RHHid
	order by 	c.RHHtipo, 
				b.RHHid 
</cfquery>

<cfquery name="data_items_conocimientos" datasource="#session.DSN#">
	select 	b.RHCid, 
			b.RHCdescripcion, 
			c.RHCtipo 
	from 	RHNotasEvalDes a, 
			RHConocimientos b, 
			RHConocimientosPuesto c 
	where a.RHEEid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHEEid#">
	  and a.DEid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid#">
	  and c.RHPcodigo=<cfqueryparam cfsqltype="cf_sql_char" value="#trim(form.RHPcodigo)#">
	  and a.RHCid=b.RHCid
	  and b.RHCid=c.RHCid
	order by 	c.RHCtipo, 
				b.RHCid 
</cfquery>

<cfoutput>

<cfset aplicar = false >


<form name="form2" action="evaluar_des-sql.cfm" method="post" onSubmit="return validar();"  >
	<!--- Ocultos --->
	<input type="hidden" name="RHEEid" value="#form.RHEEid#">
	<input type="hidden" name="DEid" value="#form.DEid#">
	<input type="hidden" name="DEideval" value="#rsEmpleado.DEid#">
	<input type="hidden" name="RHPcodigo" value="#trim(form.RHPcodigo)#">
	<input type="hidden" name="tipo" value="#form.tipo#">
	<input type="hidden" name="RHEDtipo" value="#data_relacion_evaluado.RHEDtipo#">
	<cfif ucase(trim(data_relacion.RHEEtipoeval)) eq 'T'>
		<input type="hidden" name="TEcodigo" value="#data_relacion.TEcodigo#">
	</cfif>

	<!--- Usado para validacion de datos en Javascript --->
	<cfset cont = 0 >
	<input type="hidden" name="cantidad" value="#data_items_habilidades.RecordCount + data_items_conocimientos.RecordCount#">


	<table width="98%" border="0" cellpadding="1" cellspacing="0" align="center">
		<tr><td width="60%">&nbsp;</td></tr>
		
		<tr>
			<td align="center" colspan="4">
<!---2017-04-24. Se comenta el Titulo, porque las Pruebas que se realizan puede ser basada en Competencias o bien Encuentas, si es de éste ultimo tipo, entonces el título no corresponde, sólo si el PCid es menor a 0 se pinta el titulo ---> 	                        
<cfif data_relacion.PCid LT 0>              
				<font size="5" style="font-family:Arial, Helvetica, sans-serif ">
					<strong><cf_translate key="LB_EvaluacionDelDesempeno">Evaluaci&oacute;n del Desempe&ntilde;o</cf_translate></strong>
				</font>
</cfif>
			</td>
		</tr>
		<tr><td align="center" colspan="4"><font size="3" style="font-family:Arial, Helvetica, sans-serif "><strong>#data_relacion.RHEEdescripcion#</strong></font></td></tr>

		<tr>
			<td colspan="4" align="center">
				<table width="100%" cellpadding="0" cellspacing="0" class="areaFiltro">
					<tr>
						<td width="1%" valign="top"><cfinclude template="/rh/expediente/catalogos/frame-foto.cfm"></td>
						<td valign="top">
							<table width="100%">
								<tr>
									<td class="titulos" colspan="2" valign="top" >
										<font size="4"><strong><cf_translate key="LB_DatosDeLaPersonaEvaluada">Datos Personales</cf_translate></strong></font>
									</td>
									<td class="titulos" colspan="2" valign="top" ><!---<font size="4"><strong>Datos del Evaluador</strong></font>---></td>
								</tr>	
								<tr>
									<td class="titulos" width="1%" nowrap ><cf_translate key="LB_Nombre">Nombre</cf_translate>:&nbsp;</td>
									<td class="titulos">#data_empleado.nombre#</td>
									<td colspan="2" class="titulos" ><!---Relaci&oacute;n con la persona evaluada:&nbsp;#data_relacion_evaluado.tipo#---></td>
								</tr>
						
								<tr>
									<td width="1%" nowrap class="titulos"><cf_translate key="LB_Puesto">Puesto</cf_translate>:&nbsp;</td>
									<td class="titulos">#data_puesto.RHPdescpuesto#</td>
								</tr>
								<cfif data_cfuncional.RecordCount gt 0>
									<tr>
										<td width="1%" nowrap class="titulos"><cf_translate key="LB_CentroFuncional">Centro Funcional</cf_translate>:&nbsp;</td>
										<td class="titulos">#data_cfuncional.CFdescripcion#</td>
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
