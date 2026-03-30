<!--- CALCULO DE LA EXPERIENCIA DE LA PERSONA EN EL PUESTO --->
<cffunction name="ExperienciaPuesto" returntype="numeric">
	<cfargument name="Ecodigo" type="numeric" required="yes">
	<cfargument name="DEid" type="numeric" required="yes">

	<cfquery name="PuestoActual" datasource="#session.DSN#">
		select a.LTid,a.RHPid, b.RHPcodigo, c.RHPdescpuesto,LTdesde,b.RHPpuesto
		from LineaTiempo a
		inner join RHPlazas b
			on b.RHPid = a.RHPid
		inner join RHPuestos c
			on c.RHPcodigo = b.RHPpuesto
			and c.Ecodigo = b.Ecodigo
		where DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.DEid#">
		  and getdate() between LTdesde and LThasta
		  and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.Ecodigo#">
	</cfquery>
	<cfif isdefined('PuestoActual') and PuestoActual.RecordCount>
	<cfquery name="VerificaPuestoAnterior" datasource="#session.DSN#">
		select max(LThasta) as LThasta
		from LineaTiempo a
		inner join RHPlazas b
			on b.RHPid = a.RHPid
		inner join RHPuestos c
			on c.RHPcodigo = b.RHPpuesto
			and c.Ecodigo = b.Ecodigo
		where DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.DEid#">
		  and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.Ecodigo#">
		  and a.RHPid <> <cfqueryparam cfsqltype="cf_sql_numeric" value="#PuestoActual.RHPid#">
		  and b.RHPpuesto <> <cfqueryparam cfsqltype="cf_sql_char" value="#PuestoActual.RHPcodigo#">
		order by LThasta desc
	</cfquery>
	<cfif VerificaPuestoAnterior.RecordCount and LEN(TRIM(VerificaPuestoAnterior.LThasta))>
		<cfset Lvar_Fecha = DateAdd('d',1,VerificaPuestoAnterior.LThasta)>
	<cfelse>
		<cfquery name="rsFechaInicioPuesto" datasource="#session.DSN#">
			select EVfantig
			from EVacacionesEmpleado
			where DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.DEid#">
		</cfquery>
		<cfset Lvar_Fecha = rsFechaInicioPuesto.EVfantig>
	</cfif> 
	<cfset Lvar_Experiencia = Datediff('m',Lvar_Fecha,Now())/12>
	<!--- Calcula la experiencia en otras empresas --->
	<cfquery name="rsrExpExt" datasource="#session.DSN#">
		select RHEEEannos
		from RHExpExternaEmpleado a
		inner join RHPuestos b
			on ltrim(rtrim(a.RHPcodigo)) = ltrim(rtrim(b.RHPcodigo))
			and a.Ecodigo	 = b.Ecodigo
		where a.Ecodigo   	 = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.Ecodigo#">
		and a.DEid 			 = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.DEid#">
		and b.RHPcodigo		 = <cfqueryparam cfsqltype="cf_sql_char" value="#ltrim(rtrim(PuestoActual.RHPpuesto))#">
	</cfquery>
	<cfif isdefined('rsrExpExt') and rsrExpExt.recordCount GT 0 and rsrExpExt.RHEEEannos GT 0>
		<cfset Lvar_Experiencia =  Lvar_Experiencia + rsrExpExt.RHEEEannos >
	</cfif>
	<cfquery name="rsIndicadorExp" datasource="#session.DSN#">
		select max(a.RHCELimiteSup) as LimiteSuperior
		from RHCalificacionExp a , RHValoresPuesto b
		where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.Ecodigo#">
		and a.Ecodigo   = b.Ecodigo
		and a.RHECGid   = b.RHECGid
		and b.RHVPtipo  = 30
		and b.RHPcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#ltrim(rtrim(PuestoActual.RHPpuesto))#">
	</cfquery>
	
	<cfif isdefined('rsIndicadorExp') and rsIndicadorExp.REcordCount EQ 0>
		<cfset Lvar_LimSup = 1>
	<cfelse>
		<cfset Lvar_LimSup = rsIndicadorExp.LimiteSuperior>
	</cfif>
	
	<cfif Lvar_Experiencia gt Lvar_LimSup >
		<cfset Lvar_Indicador = 100 >
	<cfelse>
		<cfset Lvar_Indicador = (Lvar_Experiencia/Lvar_LimSup)*100>
	</cfif>
	
	<!--- <cf_dump var="#Lvar_Indicador#"> --->

	<cfreturn Lvar_Indicador>
	<cfelse>
	<cfreturn 0>
	</cfif>
</cffunction>
<cffunction name="CalificacionEducacion" returntype="numeric">
	<cfargument name="Ecodigo" type="numeric" required="yes">
	<cfargument name="DEid" type="numeric" required="yes">
	<cfquery name="rsNotaEducacion" datasource="#session.DSN#">
		select RHECEnota*(RHCEDPeso/100) as NotaPonderada
		from RHEmpleadoCalificaEd a
		inner join RHCalificaEduc b
			on b.RHCEDid = a.RHCEDid
			and b.Ecodigo = a.Ecodigo
		where a.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.DEid#">
		  and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.Ecodigo#">
		  and a.RHECEaplicada = 1
		  and RHECEfdesde = (select max(RHECEfdesde)
							from RHEmpleadoCalificaEd
							where DEid = RHEmpleadoCalificaEd.DEid
							  and Ecodigo = RHEmpleadoCalificaEd.Ecodigo
							  and RHECEaplicada = 1)
	</cfquery>
	<cfif rsNotaEducacion.RecordCount>
	<cfreturn rsNotaEducacion.NotaPonderada>
	<cfelse>
	<cfreturn 0>
	</cfif>
</cffunction>


<cfset total_competencias = 0 >
<cfif habilidades_requeridas.recordcount gt 0>
	<cfoutput query="habilidades_requeridas">
		<cfset total_competencias = total_competencias + habilidades_requeridas.peso>
	</cfoutput>
</cfif>
<cfif conocimientos_requeridos.recordcount gt 0>
	<cfoutput query="conocimientos_requeridos">
		<cfset total_competencias = total_competencias + conocimientos_requeridos.peso>
	</cfoutput>
</cfif>

<cfquery name="habilidades_obtenidas_pct" datasource="#Session.DSN#">
	select coalesce(sum(b.RHCEdominio * a.RHHpeso / 100.0), 0.0) as nota
	from RHHabilidadesPuesto a
		inner join RHCompetenciasEmpleado b
			on b.idcompetencia = a.RHHid
			and b.Ecodigo = a.Ecodigo
			and b.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid#">
			and b.tipo = 'H'
			and b.RHCEfdesde >= (
								 select max(c.RHCEfdesde) from RHCompetenciasEmpleado c
								 where c.DEid = b.DEid
								   and c.Ecodigo = b.Ecodigo 
								   and c.tipo = b.tipo
								   and c.idcompetencia = b.idcompetencia
								 )

	where a.RHPcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#puesto.RHPcodigo#">
	  and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
</cfquery>

<cfquery name="conocimientos_obtenidos_pct" datasource="#Session.DSN#">
	select coalesce(sum(b.RHCEdominio * a.RHCpeso / 100.0), 0.0) as nota
	from RHConocimientosPuesto a
		inner join RHCompetenciasEmpleado b
			on b.idcompetencia = a.RHCid
			and b.Ecodigo = a.Ecodigo
			and b.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid#">
			and b.tipo = 'C'
			and b.RHCEfdesde >= (
								 select max(c.RHCEfdesde) from RHCompetenciasEmpleado c
								 where c.DEid = b.DEid
								   and c.Ecodigo = b.Ecodigo 
								   and c.tipo = b.tipo
								   and c.idcompetencia = b.idcompetencia
								 )

	where a.RHPcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#puesto.RHPcodigo#">
	  and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
</cfquery>
<!--- LLAMADA A LA FUNCION DEL CALCULO DE EXPERIENCIA DE UNA PERSONA EN EL PUESTO ACTUAL --->
<cfset Experiencia = ExperienciaPuesto(session.Ecodigo,form.DEid)>
<cfset Educacion = CalificacionEducacion(session.Ecodigo,form.DEid)>
 	<!--- Experiencia: <cfdump var="#Experiencia#"><br>
	Educación: <cfdump var="#Educacion#"><br>
	Habilidades: <cfdump var="#habilidades_obtenidas_pct.nota*0.40#"><br>
	Conocimientos: <cf_dump var="#conocimientos_obtenidos_pct.nota*0.25#"> --->
	
<!--- EL CALCULO SE CAMBIA TOMANDO LA NOTA DE EDUCACIÓN, EXPERIENCIA, CONOCIMIENTOS, HABILIDADES Y MULTIPLICANDO CADA UNA POR  UN PESO
	EXPERIENCIA * 15%
	EDUCACION  * 20%
	CONOCIMIENTOS * 25%
	HABILIDADES * 40%
	
	LA SUMA DE ESTAS NOTAS SON LAS QUE ALIMENTAN EL GRAFICO DEL PROGRESO EN EL PUESTO.
--->
	<cfquery name="rsPesosComp" datasource="#session.DSN#">
		select RHPCcodigo,RHPCpeso/100 AS RHPCpeso
		from RHPesosCompetencia
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
	</cfquery>
	
	<cfoutput query="rsPesosComp">
		<cfset Evaluate('Lvar_'&rsPesosComp.RHPCcodigo&'='&rsPesosComp.RHPCpeso)>
	</cfoutput>

<cfif not isdefined("Lvar_HAB")>
	<cfset Lvar_HAB=1>
</cfif>
<cfif not isdefined("Lvar_CON")>
	<cfset Lvar_CON=1>
</cfif>
<cfif not isdefined("Lvar_EXP")>
	<cfset Lvar_EXP=1>
</cfif>
<cfif not isdefined("Lvar_EDU")>
	<cfset Lvar_EDU=1>
</cfif>


<cfset total_competencias_obtenidas = habilidades_obtenidas_pct.nota*Lvar_HAB + conocimientos_obtenidos_pct.nota*Lvar_CON + Experiencia*Lvar_EXP + Educacion*Lvar_EDU>
<table width="100%" align="center" cellpadding="0" cellspacing="0" >
	<tr>
		<td>
			<cfinvoke component="sif.Componentes.Translate" method="Translate"
				Default="Progreso en el Puesto" Key="LB_Progreso_en_el_Puesto" returnvariable="LB_Progreso_en_el_Puesto"/>
			<cf_web_portlet_start border="true" skin="#session.preferences.skin#" titulo="#LB_Progreso_en_el_Puesto#">
			<table width="99%" align="center" cellpadding="0" cellspacing="0" >
			<cfif total_competencias gt 0 >
				<tr><td>&nbsp;</td></tr>
				<tr><td align="center">
				<!--- <cfset tiene = (100 * total_competencias_obtenidas) / total_competencias> --->
				<cfset tiene = total_competencias_obtenidas>
				<cfset falta = 100 - tiene>
				<cfoutput>	
				<cfchart chartwidth="250" format="png" chartheight="250" show3d="yes" showborder="yes" url="javascript: funcBrecha();"><!----$value$, '$serieslabel$','$itemlabel$'--->
					  <cfchartseries type="pie">
						<cfchartdata item="Porcentaje que falta" value="#NumberFormat(falta, '9.00')#">
						<cfchartdata item="Porcentaje que posee" value="#NumberFormat(tiene, '9.00')#">
					  </cfchartseries>
				</cfchart>
				</cfoutput>
				</td></tr>
				<tr><td>&nbsp;</td></tr>
			<cfelse>
				<cfset tiene = (100 * total_competencias_obtenidas) >
				<cfset falta = 0 >
				<tr><td align="center">- <cf_translate key="LB_No_existe_informacion_para_generar_el_reporte">No existe información para generar el reporte</cf_translate> - </td></tr>
			</cfif>
			</table>
			<cf_web_portlet_end>
		</td>
	</tr>		
</table>

<script>
function funcBrecha(){//v1,v2,v3	
 	var params = ''
 	var width = 1030;
	var height = 550;
	var top = (screen.height - height) / 2;
	var left = (screen.width - width) / 2;
 	params = '?Empleado='+<cfoutput>'#form.DEid#'</cfoutput>+'&Puesto='+<cfoutput>'#puesto.RHPcodigo#'</cfoutput>	
	<cfoutput>
 	var nuevo = window.open('/cfmx/rh/indicadoresX/Brecha.cfm'+params,'GraficoBrecha','menubar=yes,resizable=yes,scrollbar=yes,top='+top+',left='+left+',height='+height+',width='+width);
	nuevo.focus();
	</cfoutput>
}
</script>
