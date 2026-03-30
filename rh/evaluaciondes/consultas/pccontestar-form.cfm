<!--- VARIABLES DE TRADUCCION --->
<cfinvoke key="BTN_Anterior" default="Anterior" xmlfile="/rh/generales.xml" returnvariable="BTN_Anterior" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="BTN_Siguiente" default="Siguiente" xmlfile="/rh/generales.xml" returnvariable="BTN_Siguiente" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="BTN_Guardar" default="Guardar" xmlfile="/rh/generales.xml" returnvariable="BTN_Guardar" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="MSG_NoPuedeCalificarDosRespuestasConElMismoValor" default="No puede calificar dos respuestas con el mismo valor (" returnvariable="MSG_NoPuedeCalificarDosRespuestasConElMismoValor" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="MSG_DeseaAsignarelValorALaRespuestaActual" default="Desea asignar el valor a la respuesta actual?" returnvariable="MSG_DeseaAsignarelValorALaRespuestaActual" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="MG_No_se_ha_definido_el_cuestionarioC" Default="No se ha definido el cuestionario para los conocimientos" returnvariable="MG_No_se_ha_definido_el_cuestionarioC" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="MG_No_se_ha_definido_el_cuestionarioH" Default="No se ha definido el cuestionario para las habilidades" returnvariable="MG_No_se_ha_definido_el_cuestionarioH" component="sif.Componentes.Translate" method="Translate"/>
<!--- FIN DE VARIABLES DE TRADUCCIÓN --->

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

<!--- Calcula los ids de evaluando y evaluador.
	  Cuando es autoevaluacion son los mismos valores (DEid=DEideval, Usucodigo=Usucodigoeval)
 --->
<cfif IsDefined('url.DEidEval') and Trim(url.DEidEval) neq "">
	<cfset form.DEidEval = url.DEidEval>
</cfif>

<cfif IsDefined('url.DEid') and Trim(url.DEid) neq "">
	<cfset form.DEid = url.DEid>
</cfif>

<cfif IsDefined('url.RHEEid') and Trim(url.RHEEid) neq "">
	<cfset form.RHEEid = url.RHEEid>
</cfif>

<cfif IsDefined('url.Cual') and Trim(url.Cual) neq "">
	<cfset form.Cual = url.Cual>
</cfif>


<cfinvoke component="home.Componentes.Seguridad" method="init" returnvariable="sec">
<cfif form.tipo eq 'auto'>
	<cfset form.DEideval = form.DEid >
	<cfset rsevaluando = sec.getUsuarioByRef(form.DEid, session.EcodigoSDC, 'DatosEmpleado')>
	<cfset LvarUsucodigo     = rsevaluando.Usucodigo >
	<cfset LvarUsucodigoeval = LvarUsucodigo >
<cfelse>
	<cfset rsevaluando = sec.getUsuarioByRef(form.DEid, session.EcodigoSDC, 'DatosEmpleado')>
	<cfset rsevaluador = sec.getUsuarioByRef(form.DEideval, session.EcodigoSDC, 'DatosEmpleado')>
	<cfset LvarUsucodigo     = rsevaluando.Usucodigo >
	<cfset LvarUsucodigoeval = rsevaluador.Usucodigo >
</cfif>

<!--- CALCULA PCUID --->
<!--- 	esto hay que cambiarlo, voy a pedir que se meta una referencia a PortalCuestionarioU
		del RHEEid, para poder sacar la referncia al ciestionario ya contestado.
--->

<cfquery name="rsTitulos" datasource="#session.DSN#">
		select coalesce(a.RHEEMostrarTitulo,'N') as RHEEMostrarTitulo
		from RHEEvaluacionDes a
		where a.RHEEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHEEid#">
		and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
</cfquery>

<cfif not isdefined("form.PCUid")>

	<cfquery name="fechaultima" datasource="#session.DSN#">
		select max(PCUfecha) as fecha
		from PortalCuestionarioU a

		where a.Usucodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarUsucodigo#">
		  and a.Usucodigoeval=<cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarUsucodigoeval#">
		  and a.DEid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid#">
		  and a.DEideval=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEideval#">
		  and a.PCUreferencia = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHEEid#">
	</cfquery>

	<cfif len(trim(fechaultima.fecha))>
		<cfquery name="dataPCUid" datasource="#session.DSN#">
			select PCUid
			from PortalCuestionarioU a

			where a.PCUreferencia = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHEEid#">
			  and a.Usucodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarUsucodigo#">
			  and a.Usucodigoeval=<cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarUsucodigoeval#">
			  and a.DEid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid#">
			  and a.DEideval=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEideval#">
			  and a.PCUfecha = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#fechaultima.fecha#">
		</cfquery>

		<cfif len(trim(dataPCUid.PCUid))>
			<cfset form.PCUid = dataPCUid.PCUid >
		</cfif>
	</cfif>
</cfif>


<cfif tipo_evaluacion NEQ 2><!---  1 POR HABILIDADES,3 POR CONOCIMIENTOS, 4 POR HABILIDADES Y CONOCIMIENTOS  --->
	<!--- Evaluacion por habilidades o conocimientos --->
	<!--- 1. Recuperar los cuestionarios asociados a las habilidades --->


	<cfif tipo_evaluacion  NEQ 3>
		<cfquery name="dataPCid" datasource="#session.DSN#">
			select a.RHHid,coalesce(b.PCid,0) as PCid, PCcodigo
			from RHNotasEvalDes a
			inner join RHHabilidadesPuesto b
				on a.RHHid=b.RHHid
				  and b.RHPcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.RHPcodigo#">
				  and b.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
				  and b.PCid is not null

				inner join PortalCuestionario c
				on b.PCid=c.PCid
			where a.RHEEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHEEid#">
			  and a.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid#">

			union

			select  b.RHHid,coalesce(b.PCid,0) as PCid, c.PCcodigo
			from RHParametros a
			inner join RHHabilidades b
				on a.Ecodigo = b.Ecodigo
				and b.RHHid =  <cf_dbfunction name="to_number" args="Pvalor">
			inner join  PortalCuestionario c
				on b.PCid = c.PCid
			where Pcodigo = 830
			and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			order by PCcodigo
		</cfquery>
		<cfquery name="rsHSinCuestionario" dbtype="query">
			select distinct RHHid
			from dataPCid
			where PCid = 0
		</cfquery>
		<cfset LvarHab = ValueList(rsHSinCuestionario.RHHid)>
		<cfquery name="dataPCid" dbtype="query">
			select distinct PCid,PCcodigo
			from dataPCid
		</cfquery>
	</cfif>
	<cfif tipo_evaluacion EQ 3 or tipo_evaluacion EQ 4>
		<!--- CUESTIONARIOS PARA CONOCIMIENTOS --->
		<cfquery name="dataPCidC" datasource="#session.DSN#">
			select a.RHCid,coalesce(a.PCid,b.PCid,0) as PCid,coalesce(x.PCcodigo,z.PCcodigo,'') as PCcodigo
            from RHConocimientosPuesto a
            inner join RHConocimientos b
                on b.RHCid=a.RHCid
            inner join RHNotasEvalDes c
                on a.RHCid=c.RHCid
            	and c.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid#">
                and c.RHCid is not null
            left outer join PortalCuestionario x
			on a.PCid=x.PCid
            left outer join PortalCuestionario z
			on b.PCid=z.PCid

           where a.RHPcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.RHPcodigo#">
			  and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			  order by coalesce(x.PCcodigo,z.PCcodigo)
		</cfquery>
		<cfquery name="rsCSinCuestionario" dbtype="query">
			select distinct RHCid
			from dataPCidC
			where PCid = 0
		</cfquery>
		<cfset LvarCom = ValueList(rsCSinCuestionario.RHCid)>
		<cfquery name="dataPCidC" dbtype="query">
			select distinct PCid,PCcodigo
			from dataPCidC
		</cfquery>
	</cfif>
<cfelse>
	<!--- Evaluacion por cuestionario --->
	<cfquery name="dataPCid" datasource="#session.DSN#">
		select a.PCid
		from RHEEvaluacionDes a

		inner join PortalCuestionario c
		on a.PCid=c.PCid

		where a.RHEEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHEEid#">
		and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	</cfquery>
</cfif>


<cfset listaPCid = ''>
<cfif isdefined('dataPCid')>
	<cfset listaPCid = valuelist(dataPCid.PCid) >
</cfif>

<cfif isdefined('dataPCidC') and dataPCidC.recordcount gt 0 >
		<cfset listaPCidC = valuelist(dataPCidC.PCid)>
		<!---<cfif isdefined("listaPCidC") and len(trim(listaPCidC))>
			<cfset listaPCid = ListAppend(listaPCid,listaPCidC)>
		</cfif>	--->
</cfif>

<cfif ListLen(listaPCid)  and  (not isdefined('rsHSinCuestionario') or (isdefined ('rsHSinCuestionario') and rsHSinCuestionario.RecordCount EQ 0))>  <!--- if listas de cuestionarios --->

	<cfquery name="data" datasource="#session.DSN#">
		select pc.PCid,
			   pc.PCcodigo,
			   pc.PCnombre,
			   pcp.PPparte,
			   pcp.PCPmaxpreguntas,
			   pcp.PCPdescripcion,
			   pcp.PCPinstrucciones,
			   pp.PPid,
			   pp.PPnumero,
			   pp.PPpregunta,
			   pp.PPmantener,
			   pp.PPtipo,
			   pp.PPrespuesta,
		       pc.PCtiempototal,
               coalesce(pp.PPorientacion,0) as PPorientacion
		from PortalCuestionario pc

		inner join PortalCuestionarioParte pcp
		on pc.PCid=pcp.PCid

		inner join PortalPregunta pp
		on pp.PCid=pcp.PCid
		and pp.PPparte=pcp.PPparte

		where pc.PCid in (#listaPCid#)
		order by  pp.PPorden
		<!--- order by pc.PCcodigo, pp.PPparte, pp.PPnumero, pp.PPorden --->
	</cfquery>

	<!--- ------------------------------ --->
	<!--- Crea estructura para manejar el numero de preguntas por partes --->
	<!--- Almacena el cuestionario, parte, maximo de preguntas, preguntas contestadas por parte --->
	<cfquery name="partes" datasource="#session.DSN#">
		select PCid, PPparte, PCPmaxpreguntas
		from PortalCuestionarioParte
		where PCid in (#listaPCid#)
		order by PCid
	</cfquery>

	<cfoutput>

		<cfset j = 0 >
		<cfloop list="#listaPCid#" index="_pcid">
			<cfset j = j+1 >
		</cfloop>


		<table width="90%" cellpadding="0" cellspacing="0" align="center" border="0">
			<tr><td align="center">
				<cfset cuestionario = '' >
				<cfset parte = '' >
				<cfset parte2 = '' >
				<table width="100%" border="0" cellpadding="0" cellspacing="0">

				<cfloop query="data" >
					<cfset LvarPCid = data.PCid >
					<cfset LvarParte = data.PPparte >
					<cfset pregunta = data.PPid >
					<cfset LvarPPorientacion = data.PPorientacion >

					<cfif LvarPCid neq cuestionario >
						<!--- <cfset parte = '' > --->
						<tr><td colspan="2"style="padding:0;"><strong style="font-family:'Times New Roman', Times, serif; font-size:15pt; font-variant:small-caps; font-weight:bolder; "><cfif rsTitulos.RHEEMostrarTitulo eq 'N'>#data.PCcodigo# - #data.PCnombre#</cfif></strong></td></tr>
						<tr><td>&nbsp;</td></tr>
					</cfif>

					<cfif Trim(parte2) neq Trim(data.PCPdescripcion)>
						<tr><td colspan="2" style="border-bottom: 1px solid black; "><strong>#data.PCPdescripcion#</strong></td></tr>
						<tr><td>&nbsp;</td></tr>
						<tr><td colspan="2"><strong>#data.PCPinstrucciones#</strong></td></tr>
						<tr><td>&nbsp;</td></tr>
					</cfif>

					<cfif data.PPtipo eq 'E'>
						<tr>
							<td colspan="2">#data.PPpregunta#</td>
						</tr>
					<cfelse>
						<tr>
							<td width="1%" style="padding-left:15px; ">#data.PPnumero#.</td>
							<td style="padding-left:5px; ">#data.PPpregunta#</td>
						</tr>
					</cfif>

					<tr>
						<td colspan="2" style="padding-left:15px; ">
							<cfinclude template="pcontestar-preguntas.cfm">
						</td>
					</tr>

					<cfset cuestionario = data.PCid >
					<cfset parte = data.PPparte >
					<cfset parte2 = data.PCPdescripcion >
				</cfloop>
				</table>
			</td></tr>
		</table>
	</cfoutput>

</cfif> <!--- if listas de cuestionarios por habilidades--->


<cfif isdefined('listaPCidC') and listlen(listaPCidC) and rsCSinCuestionario.RecordCount EQ 0 > <!--- if listas de cuestionarios por conocimientos--->
<!---<cfif isdefined('listaPCidC') and listlen(listaPCidC) and rsCSinCuestionario.RecordCount EQ 0>--->
	<!--- CUESTIONARIOS DE HABILIDADES --->
	<cfquery name="data" datasource="#session.DSN#">
		select pc.PCid,
			   pc.PCcodigo,
			   pc.PCnombre,
			   pcp.PPparte,
			   pcp.PCPmaxpreguntas,
			   pcp.PCPdescripcion,
			   pcp.PCPinstrucciones,
			   pp.PPid,
			   pp.PPnumero,
			   pp.PPpregunta,
			   pp.PPmantener,
			   pp.PPtipo,
			   pp.PPrespuesta,
		       pc.PCtiempototal,
               coalesce(pp.PPorientacion,0) as PPorientacion
		from PortalCuestionario pc

		inner join PortalCuestionarioParte pcp
		on pc.PCid=pcp.PCid

		inner join PortalPregunta pp
		on pp.PCid=pcp.PCid
		and pp.PPparte=pcp.PPparte

		where pc.PCid in (#listaPCidC#)
		order by  pp.PPorden
		<!--- order by pc.PCcodigo, pp.PPparte, pp.PPnumero, pp.PPorden --->
	</cfquery>
	<cfoutput>

		<cfset j = 0 >
		<cfloop list="#listaPCid#" index="_pcid">
			<cfset j = j+1 >
		</cfloop>


		<table width="90%" cellpadding="0" cellspacing="0" align="center" border="0">
			<tr><td align="center">
				<cfset cuestionario = '' >
				<cfset parte = '' >
				<cfset parte2 = '' >
				<table width="100%" border="0" cellpadding="0" cellspacing="0">
				<cfloop query="data" >
					<cfset LvarPCid = data.PCid >
					<cfset LvarParte = data.PPparte >
					<cfset pregunta = data.PPid >
					<cfset LvarPPorientacion = data.PPorientacion >

					<cfif LvarPCid neq cuestionario >
						<!--- <cfset parte = '' > --->
						<tr><td colspan="2"style="padding:0;"><strong style="font-family:'Times New Roman', Times, serif; font-size:15pt; font-variant:small-caps; font-weight:bolder; "><cfif rsTitulos.RHEEMostrarTitulo eq 'N'>#data.PCcodigo# - #data.PCnombre#</cfif></strong></td></tr>
						<tr><td>&nbsp;</td></tr>
					</cfif>

					<cfif Trim(parte2) neq Trim(data.PCPdescripcion)>
						<tr><td colspan="2" style="border-bottom: 1px solid black; "><strong>#data.PCPdescripcion#</strong></td></tr>
						<tr><td>&nbsp;</td></tr>
						<tr><td colspan="2"><strong>#data.PCPinstrucciones#</strong></td></tr>
						<tr><td>&nbsp;</td></tr>
					</cfif>

					<cfif data.PPtipo eq 'E'>
						<tr>
							<td colspan="2">#data.PPpregunta#</td>
						</tr>
					<cfelse>
						<tr>
							<td width="1%" style="padding-left:15px; ">#data.PPnumero#.</td>
							<td style="padding-left:5px; ">#data.PPpregunta#</td>
						</tr>
					</cfif>

					<tr>
						<td colspan="2" style="padding-left:15px; ">
							<cfinclude template="pcontestar-preguntas.cfm">
						</td>
					</tr>

					<cfset cuestionario = data.PCid >
					<cfset parte = data.PPparte >
					<cfset parte2 = data.PCPdescripcion >
				</cfloop>
				</table>
			</td></tr>
		</table>
	</cfoutput>
<cfelse>
	<cfif isdefined('rsCSinCuestionario') and rsCSinCuestionario.RecordCount>
		<cfquery name="DatosCom" datasource="#session.DSN#">
			select RHCcodigo
			from RHConocimientos
			where RHCid in(#LvarCom#)
		</cfquery>
		<cfset Lvar_Conocimientos = valuelist(DatosCom.RHCcodigo)>
		<cf_throw message="#MG_No_se_ha_definido_el_cuestionarioC#:&nbsp;#Lvar_Conocimientos#" errorcode="10000">
	<cfelseif isdefined('rsHSinCuestionario') and rsHSinCuestionario.RecordCount>
		<cfquery name="DatosHab" datasource="#session.DSN#">
			select RHHcodigo
			from RHHabilidades
			where RHCid in(#LvarHab#)
		</cfquery>
		<cfset Lvar_Habilidades = valuelist(DatosHab.RHHcodigo)>
		<cf_throw message="#MG_No_se_ha_definido_el_cuestionarioH#:&nbsp;#Lvar_Habilidades#" errorcode="10000">
	</cfif>

</cfif> <!--- if listas de cuestionarios por conocimientos--->