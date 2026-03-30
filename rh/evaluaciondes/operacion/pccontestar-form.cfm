<!--- VARIABLES DE TRADUCCION --->
<cfinvoke Key="BTN_Anterior" Default="Anterior" returnvariable="BTN_Anterior" component="sif.Componentes.Translate" method="Translate" XmlFile="/rh/generales.xml"/>
<cfinvoke Key="BTN_Siguiente" Default="Siguiente" returnvariable="BTN_Siguiente"component="sif.Componentes.Translate" method="Translate" XmlFile="/rh/generales.xml"/>
<cfinvoke Key="BTN_Guardar" Default="Guardar" returnvariable="BTN_Guardar" component="sif.Componentes.Translate" method="Translate" XmlFile="/rh/generales.xml"/>
<cfinvoke Key="BTN_Regresar_a_lista" Default="Regresar a lista" returnvariable="BTN_Regresar_a_lista" component="sif.Componentes.Translate" method="Translate" XmlFile="/rh/generales.xml"/>
<cfinvoke Key="MSG_NoPuedeCalificarDosRespuestasConElMismoValor" Default="No puede calificar dos respuestas con el mismo valor (" returnvariable="MSG_NoPuedeCalificarDosRespuestasConElMismoValor" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="MSG_DeseaAsignarelValorALaRespuestaActual" Default="Desea asignar el valor a la respuesta actual?" returnvariable="MSG_DeseaAsignarelValorALaRespuestaActual" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="MG_No_se_ha_definido_el_cuestionarioC" Default="No se ha definido el cuestionario para los conocimientos" returnvariable="MG_No_se_ha_definido_el_cuestionarioC" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="MG_No_se_ha_definido_el_cuestionarioH" Default="No se ha definido el cuestionario para las habilidades" returnvariable="MG_No_se_ha_definido_el_cuestionarioH" component="sif.Componentes.Translate" method="Translate"/>
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

<!--- Calcula los ids de evaluando y evaluador.
	  Cuando es autoevaluacion son los mismos valores (DEid=DEideval, Usucodigo=Usucodigoeval)
 --->
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
			  and a.PCUfecha = '#fechaultima.fecha#'
		</cfquery>

		<cfif len(trim(dataPCUid.PCUid))>
			<cfset form.PCUid = dataPCUid.PCUid >
		</cfif>
	</cfif>
</cfif>
<cfquery name="rsTitulos" datasource="#session.DSN#">
		select coalesce(a.RHEEMostrarTitulo,'N') as RHEEMostrarTitulo
		from RHEEvaluacionDes a
		where a.RHEEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHEEid#">
		and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
</cfquery>

<cfquery name="rsCompetenciaAdd" datasource="#session.DSN#">
	select  b.PCid, c.PCcodigo
	from RHParametros a
	inner join RHHabilidades b
		on a.Ecodigo = b.Ecodigo
		and b.RHHid =  <cf_dbfunction name="to_number" args="Pvalor">
	inner join  	 PortalCuestionario c
		on b.PCid = c.PCid

	where Pcodigo = 830
	and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">


</cfquery>

<cfif tipo_evaluacion NEQ 2>
	<cfif tipo_evaluacion EQ 1 or tipo_evaluacion EQ 4>
		<!--- Evaluacion por habilidades --->
		<!--- 1. Recuperar los cuestionarios asociados a las habilidades --->
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
		<cfif isdefined("listaPCidC") and len(trim(listaPCidC))>
			<cfset listaPCid = ListAppend(listaPCid,listaPCidC)>
		</cfif>
</cfif>


<cfif ListLen(listaPCid) and (not isdefined ('rsCSinCuestionario') or rsCSinCuestionario.RecordCount EQ 0 and (not isdefined ('rsHSinCuestionario') or rsHSinCuestionario.RecordCount EQ 0))>  <!--- if listas de cuestionarios --->
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
			   pp.PPorden,
         coalesce(pp.PPorientacion,0) as PPorientacion

		from PortalCuestionario pc

		inner join PortalCuestionarioParte pcp
		on pc.PCid=pcp.PCid

		inner join PortalPregunta pp
		on pp.PCid=pcp.PCid
		and pp.PPparte=pcp.PPparte

		where pc.PCid in (#listaPCid#)
		order by  pcp.PPparte, pc.PCid , pp.PPorden, pp.PPid
	</cfquery>

	<!--- pc.PCcodigo, pp.PPparte, pp.PPnumero, --->
	<cfquery name="data2"  dbtype="query">
		select PCid,
			   PCcodigo,
			   PCnombre,
			   PPparte,
			   PCPmaxpreguntas,
			   PCPdescripcion,
			   PCPinstrucciones,
			   PPid,
			   PPnumero,
			   PPpregunta,
			   PPmantener,
			   PPtipo,
			   PPrespuesta,
		       PCtiempototal,
               PPorientacion
		from data
		order by  PCcodigo, PPparte, PPnumero,PPorden
	</cfquery>

	<cfquery name="rsExiste"  dbtype="query">
		select 1 as paginacion
		from data
		where PPmantener = 0
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

	<script type="text/javascript" language="javascript1.2">
		var respuestas = new Object();
		var partes     = new Object();
	</script>
	<cfoutput query="partes" group="PCid" >
		<cfset _PCid = partes.PCid >

		<script type="text/javascript" language="javascript1.2">
			partes[#_PCid#] = new Object();
		</script>

		<cfoutput group="PPparte">
			<cfset _PPparte = partes.PPparte >
			<script type="text/javascript" language="javascript1.2">
				partes[#_PCid#][#_PPparte#] = new Array();
			</script>
		</cfoutput>

		<cfoutput>
			<cfset _PPparte = partes.PPparte >
			<script type="text/javascript" language="javascript1.2">
				partes[#_PCid#][#_PPparte#][0] = '#partes.PCPmaxpreguntas#';
				partes[#_PCid#][#_PPparte#][1] = 0;
			</script>
		</cfoutput>
	</cfoutput>
	<!--- ------------------------------ --->
	<script type="text/javascript" language="javascript1.2">
		var preguntas = new Object();

	</script>
	<cfoutput query="data2" group="PCid">
		<cfset _PCid = data2.PCid >
		<script type="text/javascript" language="javascript1.2">
			preguntas[#_PCid#] = new Object();

		</script>

		<cfoutput group="PPparte">
			<cfset _PPparte = data2.PPparte >
			<script type="text/javascript" language="javascript1.2">
				preguntas[#_PCid#][#_PPparte#] = new Object();

			</script>
		</cfoutput>

		<cfoutput group="PPid">
			<cfset _PPid = data2.PPid >
			<cfset _PPparte = data2.PPparte >
			<script type="text/javascript" language="javascript1.2">
				preguntas[#_PCid#][#_PPparte#][#_PPid#] = new Array();
				preguntas[#_PCid#][#_PPparte#][#_PPid#][0] = false;
			</script>
		</cfoutput>

	</cfoutput>
	<!--- ------------------------------ --->
	<cfset divs = 0 >
	<cfset div_abierto = false >

	<cfoutput>


<form name="form1" style="margin:0;" method="post" action="evaluar_des-sql.cfm" >
	<input type="hidden" name="RHEEid" value="#form.RHEEid#">
	<input type="hidden" name="tipo" value="#form.tipo#">
	<input type="hidden" name="Usucodigo" value="#LvarUsucodigo#">
	<input type="hidden" name="DEid" value="#form.DEid#">
	<input type="hidden" name="DEideval" value="#form.DEideval#">
	<input type="hidden" name="Usucodigoeval" value="#LvarUsucodigoeval#">
	<input type="hidden" name="RHPcodigo" value="#form.RHPcodigo#">
	<input type="hidden" name="totalPCid" value="#listlen(listaPCid)#">
	<input type="hidden" name="tipo_evaluacion" value="#tipo_evaluacion#">
	<input type="hidden" name="inicio" value="1">
	<input type="hidden" name="actual" value="1">

	<cfset j = 0 >
	<cfloop list="#listaPCid#" index="_pcid">
		<cfset j = j+1 >
		<input type="hidden" name="PCid_#j#" value="#_pcid#">
	</cfloop>


	<cfif isdefined('dataPCUid.PCUid')>
		<input type="hidden" name="PCUid" value="#dataPCUid.PCUid#">
	</cfif>

		<table width="100%" cellpadding="0" cellspacing="0" align="center">
			<tr><td align="center">
				<div align="center" style=" width:950px; height:400px; border:1px solid ##F1F1F1; overflow:auto; display:block; padding: 10 10 10 10;" >  <!--- contenedor principal --->
				<cfset cuestionario = '' >
				<cfset parte = '' >
				<cfset parte2 = '' >

				<cfloop query="data" >
					<cfset LvarPCid = data.PCid >
					<cfset LvarParte = data.PPparte >
					<cfset pregunta = data.PPid >
                     <cfset LvarPPorientacion = data.PPorientacion >

					<cfif data.currentrow eq 1 or data.PPmantener eq 0>
						<cfset divs = divs + 1>

						<cfif div_abierto >
							</table>
							</div>
							<cfset div_abierto = false >
						</cfif>

						<cfset div_abierto = true >
						<div id="div_#divs#" style="elevation:above; display:none;" >
							<table width="100%" border="0" cellpadding="0" cellspacing="0">
								<tr><td colspan="2"style="padding:0;"><strong style="font-family:'Times New Roman', Times, serif; font-size:15pt; font-variant:small-caps; font-weight:bolder; padding-left:20px"><cfif rsTitulos.RHEEMostrarTitulo eq 'N'>#data.PCcodigo# - #data.PCnombre#</cfif></strong></td></tr>
								<tr><td>&nbsp;</td></tr>
								<tr><td colspan="2" style="padding:0; border-bottom: 1px solid black;"><strong>#data.PCPdescripcion#</strong></td></tr>
								<tr><td>&nbsp;</td></tr>
								<tr><td colspan="2"><strong>#data.PCPinstrucciones#</strong></td></tr>
								<tr><td>&nbsp;</td></tr>
					<!--- esto es solo para saber si cambio el numero de Parte y pintarla esto estaba como un if en la linea 383 --->

					<cfelseif <!------>  cuestionario eq data.PCid and Trim(parte2) neq Trim(data.PCPdescripcion)>
						<tr><td colspan="2" style="padding:0; border-bottom: 1px solid black;"><strong>#data.PCPdescripcion#</strong></td></tr>
						<tr><td>&nbsp;</td></tr>
						<tr><td colspan="2"><strong>#data.PCPinstrucciones#</strong></td></tr>
								<tr><td>&nbsp;</td></tr>
					</cfif>

					 <!--- esto es solo para saber si cambio el cuestionario y pintar el titulo del mismo--->
					<cfif rsTitulos.RHEEMostrarTitulo eq 'N'>
						<cfif len(trim(cuestionario)) and cuestionario neq data.PCid and data.PPmantener eq 1>
							<tr><td>&nbsp;</td></tr>
							 <tr><td colspan="2" style="padding:0;"><strong style="font-family:'Times New Roman', Times, serif; font-size:15pt; font-variant:small-caps; font-weight:bolder; padding-left:20px">#data.PCcodigo# - #data.PCnombre#</strong></td></tr>
							<tr><td>&nbsp;</td></tr>
							<tr><td colspan="2" style="padding:0; border-bottom: 1px solid black;"><strong>#data.PCPdescripcion#</strong></td></tr>
							<tr><td>&nbsp;</td></tr>
							<tr><td colspan="2"><strong>#data.PCPinstrucciones#</strong></td></tr>
							<tr><td>&nbsp;</td></tr>
						</cfif>
					</cfif>

					<cfif data.PPtipo eq 'E'>
						<tr>
							<td colspan="2">#data.PPpregunta#</td>
						</tr>
					<cfelse>
						<tr>
							<td width="1%" style="padding-left:15px; "><cfif rsTitulos.RHEEMostrarTitulo eq 'N'>#data.PPnumero#.</cfif></td>
							<td style="padding-left:5px; ">#data.PPpregunta#</td>
						</tr>
					</cfif>

					<tr>
						<td colspan="2" style="padding-left:15px; ">
							<cfinclude template="pcontestar-preguntas.cfm">
						</td>
					</tr>

					<cfset cuestionario = data.PCid >
					<cfset parte2 = data.PCPdescripcion >
					<cfset parte = data.PPparte >
				</cfloop>

				<cfif div_abierto >
					</table>
					</div>
					<cfset div_abierto = false >
				</cfif>

				</div>
			</td></tr>
		</table>

		<input type="hidden" name="maximo" value="#divs#">	<!--- cantidad de divs pintados --->
		<table width="100%" align="center">
			<tr><td align="center">
				<cfset lVarEstadoBoton = 'button'>

				<cfif isDefined('rsExiste')  and rsExiste.RecordCount eq 0>  <!--- existe paginacion entonces se muestran los botones de avance --->
					<cfset lVarEstadoBoton = 'hidden'>
				</cfif>
					<input type="#lVarEstadoBoton#" name="_back" value="< #BTN_Anterior#" disabled onClick="javascript:ira('back',parseInt(document.form1.actual.value))">
					<input type="#lVarEstadoBoton#" name="_next" value="#BTN_Siguiente# >" <cfif divs eq 1>disabled</cfif> onClick="javascript:ira('goto',parseInt(document.form1.actual.value))">
				<input type="submit" name="guardar" value="#BTN_Guardar#" >
               <input type="button"  name="btn_regresar" value="#BTN_Regresar_a_lista#" onClick="javascript: location.href='evaluar_des-lista.cfm?tipo=#form.tipo#';">
			</td></tr>
			<tr><td>&nbsp;</td></tr>
		</table>

	</form>
</cfoutput>



	<script language="javascript1.2" type="text/javascript">
		function esconder(){
			for (var i=1; i<=parseInt(document.form1.maximo.value); i++){
				document.getElementById('div_'+i).style.display = 'none';
			}
		}

		function ira_lista(){
			document.form1._back.disabled = false;
			document.form1._next.disabled = false;
		}


		function activar_botones(){
			document.form1._back.disabled = false;
			document.form1._next.disabled = false;
		}

		function desactivar_botones(indice, indicei, indicef){
			if (indice <= indicei){
				document.form1._back.disabled = true;
			}
			else if(indice >= indicef){
				document.form1._next.disabled = true;
			}

			if ( parseInt(document.form1.maximo.value) == 1 ){
				document.form1._next.disabled = true;
			}
		}

		function ira(tipo, actual){
			if ( parseInt(document.form1.maximo.value) > 0 ){
				esconder();
				activar_botones()
				var indicei = document.form1.inicio.value;
				var indicef = document.form1.maximo.value;
				var indice = (tipo == 'goto') ? actual+1 : actual-1;
				desactivar_botones(indice, indicei, indicef)
				document.form1.actual.value = indice;
				document.getElementById('div_'+indice).style.display='block';
			}
		}

		function excluye(cual, pregunta, respuesta){
			var contenedor = eval('contenedor_'+pregunta);
			for (var i=0; i<contenedor.length; i++){
				var otros = document.getElementById('p_' + pregunta + '_' + contenedor[i][0]);
				if ( (otros.value == cual.value) && (otros.name != cual.name) && cual.value !='' ){
					if ( confirm('<cfoutput>#MSG_NoPuedeCalificarDosRespuestasConElMismoValor#</cfoutput>'+cual.value+'). <cfoutput>#MSG_DeseaAsignarelValorALaRespuestaActual#</cfoutput>') ){
						otros.value = ''
					}
					else{
						cual.value = '';
					}
				}
			}
		}

		// Cuando entra por primer vez, pone en modo despliegue el div uno
		ira('back', 2);
		//startclock();

	</script>
</cfif>


<cfif isdefined('rsCSinCuestionario') and rsCSinCuestionario.RecordCount NEQ 0 or
	  	  isdefined('rsHSinCuestionario') and rsHSinCuestionario.RecordCount NEQ 0>
        <table width="90%" cellpadding="0" cellspacing="0" align="center" border="0">
        <tr><td colspan="2"><hr></td></tr>
        <tr><td colspan="2"><b>HABILIDADES Y CONOCIMIENTOS NO EVALUADOS</b></td></tr>
        <tr><td colspan="2"><hr></td></tr>

			<cfif isdefined('rsCSinCuestionario') and rsCSinCuestionario.RecordCount>
                <cfquery name="DatosCom" datasource="#session.DSN#">
                    select RHCcodigo
                    from RHConocimientos
                    where RHCid in(#LvarCom#)
                </cfquery>
                <cfset Lvar_Conocimientos = valuelist(DatosCom.RHCcodigo)>
                <tr>
                    <td><cfoutput><br>#MG_No_se_ha_definido_el_cuestionarioC#</br></cfoutput></td>
                    <td><cfoutput>#Lvar_Conocimientos#</cfoutput></td>
                </tr>
            <cfelseif isdefined('rsHSinCuestionario') and rsHSinCuestionario.RecordCount>
                <cfquery name="DatosHab" datasource="#session.DSN#">
                    select RHHcodigo,
                    from RHHabilidades
                    where RHCid in(#LvarHab#)
                </cfquery>
                <cfset Lvar_Habilidades = valuelist(DatosHab.RHHcodigo)>
                    <tr>
                        <td><cfoutput><br>#MG_No_se_ha_definido_el_cuestionarioH#</br></cfoutput></td>
                        <td><cfoutput></#Lvar_Habilidades#</cfoutput></td>
                    </tr>
            </cfif>
	        <tr><td colspan="2"><hr></td></tr>

</cfif> <!--- if listas de cuestionarios --->