
<cfparam name="form.DEidotro" default="0">
<cfif isdefined("url.RHEEid") and not isdefined("form.RHEEid")>
	<cfset form.RHEEid = url.RHEEid >
</cfif>
<cfif isdefined("url.DEid") and not isdefined("form.DEid")>
	<cfset form.DEid = url.DEid >
</cfif>
<cfif isdefined("url.DEidotro") and not isdefined("form.DEidotro")>
	<cfset form.DEidotro = url.DEidotro >
</cfif>
<cfif isdefined("url.cual") and not isdefined("form.cual")>
	<cfset form.cual = url.cual >
</cfif>

<cfset form.tipo = 'auto' >
<cfset form.DEideval = form.DEid >
<cfif isdefined("form.cual") and form.cual eq 'J' >
	<cfset form.tipo = 'jefe' >
	<cfquery name="rsEvaluador" datasource="#session.DSN#">
		select DEideval
		from RHEvaluadoresDes
		where DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid#">
		  and RHEDtipo in ( 'J','E')
		  and RHEEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHEEid#">
	</cfquery>
	<cfset form.DEideval = IIf( len(trim(rsEvaluador.DEideval)) gt 0, '#rsEvaluador.DEideval#', '0') >
<cfelseif isdefined("form.cual") and form.cual eq 'O' >	
	<cfset form.tipo = 'otros' >
	<cfset form.DEideval = IIf( len(trim(form.DEidotro)) gt 0, '#form.DEidotro#', '0') >
</cfif>

<cfif len(trim(form.DEideval)) eq 0>
	<cfset form.DEideval = form.DEid >
</cfif>

<cf_navegacion name="DEid" navegacion="">
<cf_navegacion name="RHEEid" navegacion="">

<cf_templatecss>
<cfset paramsuri = ArrayNew (1)>
<cfset ArrayAppend(paramsuri, 'DEid='         & URLEncodedFormat(form.DEid))>
<cfset ArrayAppend(paramsuri, 'RHEEid='             & URLEncodedFormat(form.RHEEid))>

<cf_rhimprime datos="/rh/evaluaciondes/consultas/evaluar_des-form.cfm" paramsuri="&RHEEid=#form.RHEEid#&DEid=#form.DEid#&DEidotro=#form.DEidotro#&cual=#form.cual#">

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
	select RHEEdescripcion, RHEEtipoeval, TEcodigo, RHEEfecha, PCid
	from RHEEvaluacionDes
	where RHEEid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHEEid#">
	  and Ecodigo=<cfqueryparam  cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
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
	  and <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#"> between a.LTdesde and a.LThasta
	  and a.RHPid = b.RHPid
	  and a.Ecodigo = b.Ecodigo
	  and b.CFid=c.CFid
	  and b.Ecodigo=c.Ecodigo
</cfquery>

<!--- trae el puesto del empleado --->
<cfparam name="form.RHPcodigo" default="">
<cfquery name="rsPuesto" datasource="#session.DSN#">
	select RHPcodigo
	from RHListaEvalDes
	where RHEEid = <cfqueryparam cfsqltype="cf_sql_integer" value="#RHEEid#">
	  and DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid#">
</cfquery>
<cfset form.RHPcodigo = rsPuesto.RHPcodigo >

<cfquery name="data_puesto" datasource="#session.DSN#">
	select RHPdescpuesto
	from RHPuestos
	where RHPcodigo=<cfqueryparam cfsqltype="cf_sql_char" value="#trim(form.RHPcodigo)#">
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

	<!--- Usado para validacion de datos en Javascript --->
	<cfset cont = 0 >

	<table width="98%" border="0" cellpadding="1" cellspacing="0" align="center">
		<tr><td width="60%">&nbsp;</td></tr>
		
		<tr>
			<td align="center" colspan="4" class="titulos">
				<strong>#session.Enombre#</strong>
			</td>
		</tr>
		<tr>
			<td align="center" colspan="4">
				<font size="5" style="font-family:Arial, Helvetica, sans-serif ">
					<strong><cf_translate key="LB_EvaluacionDelDesempeno">Evaluaci&oacute;n del Desempe&ntilde;o</cf_translate></strong>
				</font>
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
										<font size="4"><strong><cf_translate key="LB_DatosDeLaPersonaEvaluada">Datos de la persona Evaluada</cf_translate></strong></font>
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
	
	<table width="100%" cellpadding="2" cellspacing="0">
		<tr><td>
		
				<cfif len(trim(data_relacion.PCid))>
					<cfset form.PCid = data_relacion.PCid >
				</cfif>
				<!---
				<cfif isdefined("url.PCUid") and not isdefined("form.PCUid")>
					<cfset form.PCUid = url.PCUid >
				</cfif>	
				--->
				
				<!--- 
					El pintado del cuestionario depende del tipo de evaluacion. 
					Hay dos tipos de evaluacion:
						1. Por habilidades: esta opcion significa que por cada habilidad asociada al puesto
							se va a pintar un cuestionario
						2. Por Cuestionario: para esta opcion solo se pinta el cuestionario que se selecciono
						   para la relacion de evaluacion.	
						3. Por Conocimientos: esta opcion significa que por cada conocimiento asociada al puesto
											se va a pintar un cuestionario
						4. Por Habilidades y Conocimientos: esta opcion significa que por cada conocimiento y habilidad asociada al puesto
											se va a pintar un cuestionario
						0 POR CONOCIMIENTOS, -1 POR HABILIDADES, -2 POR HABILIDADES Y CONOCIMIENTOS
				
				--->
				<!--- <cfset tipo_evaluacion = 1 >
				<cfif isdefined("form.PCid") and len(trim(form.PCid))>
					<cfset tipo_evaluacion = 2 >
				</cfif> --->
				<cfif isdefined("form.PCid") and form.PCid EQ -1 >
					<cfset tipo_evaluacion = 1 >
				<cfelseif isdefined("form.PCid") and form.PCid EQ -2>
					<cfset tipo_evaluacion = 4 >
				<cfelseif isdefined("form.PCid") and form.PCid EQ 0>
					<cfset tipo_evaluacion = 3 >
				<cfelse>
					<cfset tipo_evaluacion = 2 >
				</cfif>
				<link type="text/css" rel="stylesheet" href="/cfmx/asp/css/asp.css">
				<table width="100%" cellspacing="0" cellpadding="0">
					<tr>
						<td valign="top"><cfinclude template="pccontestar-form.cfm"></td>
					</tr>
				</table>	
		
		</td></tr>
	</table>				
</cfoutput>