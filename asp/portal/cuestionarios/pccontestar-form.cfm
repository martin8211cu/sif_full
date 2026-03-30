<!---
<script language="javascript" type="text/javascript">
	var	timerID = null;
	var	timerRunning = false;
	var	startDate;
	var	startSecs;

	function stopclock() {
		if (timerRunning) {
			clearTimeout(timerID);
		}
		timerRunning = false;
	}

	function startclock() {
		startDate = new Date();
		startSecs = (startDate.getHours()*60*60) + (startDate.getMinutes()*60) + startDate.getSeconds();
		stopclock();
		showtime();
	}

	function showtime() {
	
		var now = new Date();
		var nowSecs = (now.getHours()*60*60) + (now.getMinutes()*60) + now.getSeconds();
		if (nowSecs < startSecs) nowSecs = nowSecs + 86400;
		var elapsedSecs = nowSecs - startSecs;
	
		var hours = Math.floor( elapsedSecs / 3600 );
		elapsedSecs = elapsedSecs - (hours*3600);
	
		var minutes = 	Math.floor( elapsedSecs / 60 );
		elapsedSecs = elapsedSecs - (minutes*60);
	
		var seconds = elapsedSecs;
	
		var timeValue = "" + hours;
		timeValue  += ((minutes < 10) ? ":0" : ":") + minutes;
		timeValue  += ((seconds < 10) ? ":0" : ":") + seconds;
	
		document.timerForm.timerField.value = timeValue;
		timerID = setTimeout("showtime()",1000);
		timerRunning = true;
	}
</script>
--->

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
			  and a.PCUfecha = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#fechaultima.fecha#">
		</cfquery>
		<cfif len(trim(dataPCUid.PCUid))>
			<cfset form.PCUid = dataPCUid.PCUid >
		</cfif>
	</cfif>
</cfif>

<cfif tipo_evaluacion eq 1 >
	<!--- Evaluacion por habilidades --->
	<!--- 1. Recuperar los cuestionarios asociados a las habilidades --->
	<cfquery name="dataPCid" datasource="#session.DSN#">
		select distinct b.PCid
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

		order by PCcodigo
	</cfquery>
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
<cfset listaPCid = valuelist(dataPCid.PCid)>

<cfif listlen(listaPCid)> <!--- if listas de cuestionarios --->
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
		       pc.PCtiempototal
		
		from PortalCuestionario pc
		
		inner join PortalCuestionarioParte pcp
		on pc.PCid=pcp.PCid
		
		inner join PortalPregunta pp
		on pp.PCid=pcp.PCid
		and pp.PPparte=pcp.PPparte
		
		where pc.PCid in (#listaPCid#)
		
		order by pc.PCcodigo, pp.PPparte, pp.PPnumero, pp.PPorden
	</cfquery>
	
	<!--- ------------------------------ --->
	<!--- Crea estructura para manejar el numero de preguntas por partes --->
	<cfquery name="_data" datasource="#session.DSN#">
		select pc.PCid,
			   pc.PCcodigo,
			   pc.PCnombre,
			   pcp.PPparte,
			   pcp.PCPmaxpreguntas,
			   pcp.PCPdescripcion,
			   pcp.PPparte,
			   pp.PPid,	
			   pp.PPnumero, 
			   pp.PPpregunta,
			   pp.PPmantener,
			   pp.PPtipo,
			   pp.PPrespuesta,
		       pc.PCtiempototal,
			   pr.PRid
		
		from PortalCuestionario pc
		
		inner join PortalCuestionarioParte pcp
		on pc.PCid=pcp.PCid
		
		inner join PortalPregunta pp
		on pp.PCid=pcp.PCid
		and pp.PPparte=pcp.PPparte
		
		inner join PortalRespuesta pr
		on pc.PCid=pr.PCid
		and pp.PCid=pr.PCid
		and pp.PPid=pr.PPid
		
		where pc.PCid in (#listaPCid#)
		
		order by pc.PCcodigo, pp.PPparte, pp.PPnumero, pp.PPorden
	</cfquery>
	
	<script type="text/javascript" language="javascript1.2">
		var partes = new Object();
		var respuestas = new Object();
	</script>
	<cfoutput query="_data" group="PCid">
		<cfset _PCid = _data.PCid >
		<script type="text/javascript" language="javascript1.2">
			partes[#_PCid#] = new Object();
		</script>
		<cfoutput group="PPparte">
			<script type="text/javascript" language="javascript1.2">
				var i =0;
				partes[#_PCid#][#_data.PPparte#] = new Array();
			</script>

			<cfoutput group="PPid">
				<script type="text/javascript" language="javascript1.2">
					partes[#_PCid#][#_data.PPparte#][i] = new Array();
					partes[#_PCid#][#_data.PPparte#][i][0] = #PPid#;
					partes[#_PCid#][#_data.PPparte#][i][1] = '#PPtipo#';
					i++;
				</script>
			</cfoutput>
		</cfoutput>
	</cfoutput>
	
	<cfoutput query="_data" group="PPid">
		<cfset _PPid = _data.PPid >
		<script type="text/javascript" language="javascript1.2">
			var i =0;
			respuestas[#_PPid#] = new Array();
		</script>
		<cfoutput>
			<script type="text/javascript" language="javascript1.2">
				respuestas[#_PPid#][i] = #PRid#;
				i++;
			</script>
		</cfoutput>
	</cfoutput>

	<script type="text/javascript" language="javascript1.2">
		function procesar_radios(pregunta, maximo, nombre ){
alert(obj.name)		
			var objeto = document.form1['p_'+pregunta]
			
			// solo hay un radio
			if ( objeto.value ){
				if ( objeto.checked ){
					return true;
				}
			}
			// hay un conjunto de radios
			else{
				for (var k = 0; k < objeto.length; k++){
					if ( objeto[k].checked ){
						return true;
					}
				}
			}	
			return false;
		}
		
		function validar_maximo_preguntas(pcid, parte, tipo, maximo, obj){
			if ( parseInt(maximo) > 0 ){
				var contador = 0 ;
				alert("CUANTOS ANTES " + contador)
				var data = partes[pcid][parte];
				for (var i=0; i<data.length; i++){
					var dataresp = respuestas[data[i][0]];
					if ( data[i][1] == 'U' ){
						if ( procesar_radios(data[i][0], maximo, obj.name) ){
							contador++;
						}
					}
					else if( data[i][1] == 'M' ){
						for (var j=0; j<dataresp.length; j++){
						}
					}
					else if( data[i][1] == 'O' ){
						for (var j=0; j<dataresp.length; j++){
						}
					}
					else if( data[i][1] == 'V' ){
						if ( parseInt(dataresp.length) > 1 ){
							for (var j=0; j<dataresp.length; j++){
							}
						}
						else{
						}
					}
					else if( data[i][1] == 'D' ){
					}

				}
				alert("CUANTOS DESPUES " + contador)
			}
		}
	</script>
	<!--- ------------------------------ --->
	
	<cfset divs = 0 >
	<cfset div_abierto = false >

	<cfoutput>
<!---
	<form name="timerForm" style="margin: 0;">
	<table width="80%" align="center">
		<tr>
			<td align="right" style="padding-right: 20px; " width="25%">
				<strong>TIEMPO DISPONIBLE:</strong>
			</td>
			<td align="left" width="25%">
				#LSNumberFormat(data.PCtiempototal, '9')# minutos
			</td>
			<td align="right" style="padding-right: 20px; " width="25%">
				<strong>TIEMPO TRANSCURRIDO:</strong>
			</td>
			<td align="left" width="25%">
				<input type="text" name="timerField" size="6" style="text-align:right" readonly>
			</td>
		</tr>
		<tr><td colspan="4" align="center" class="tituloProceso">#data.PCnombre#</td></tr>
	</table>
	</form>
--->	

<form name="form1" style="margin:0;" method="post" action="evaluar_des-sql.cfm" >
	<input type="hidden" name="RHEEid" value="#form.RHEEid#">
	<input type="hidden" name="tipo" value="#form.tipo#">
	<input type="hidden" name="Usucodigo" value="#LvarUsucodigo#">
	<input type="hidden" name="DEid" value="#form.DEid#">
	<input type="hidden" name="DEideval" value="#form.DEideval#">
	<input type="hidden" name="Usucodigoeval" value="#LvarUsucodigoeval#">
	<input type="hidden" name="RHPcodigo" value="#form.RHPcodigo#">
	<input type="hidden" name="totalPCid" value="#listlen(listaPCid)#">
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
				<cfloop query="data" >
					<cfset LvarPCid = data.PCid >
					<cfset pregunta = data.PPid >
				
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
								<tr><td colspan="2" class="tituloProceso" style="padding:0;">#data.PCcodigo# - #data.PCnombre#</td></tr>
								<tr><td>&nbsp;</td></tr>
								<tr><td colspan="2" style="padding:0; border-bottom: 1px solid black;"><strong>#data.PCPdescripcion#</strong></td></tr>
								<tr><td>&nbsp;</td></tr>
					</cfif>
					
					<!--- esto es solo para saber si cambio el cuestionario y pintar el titulo del mismo--->
					<cfif len(trim(cuestionario)) and cuestionario neq data.PCid and data.PPmantener eq 1>
						<tr><td>&nbsp;</td></tr>
						<tr><td colspan="2" class="tituloProceso" style="padding:0;">#data.PCcodigo# - #data.PCnombre#</td></tr>
						<tr><td>&nbsp;</td></tr>
						<tr><td colspan="2" style="padding:0; border-bottom: 1px solid black;"><strong>#data.PCPdescripcion#</strong></td></tr>
						<tr><td>&nbsp;</td></tr>
					</cfif>
					
					<!--- esto es solo para saber si cambio el numero de Parte y pintarla --->
					<cfif cuestionario eq data.PCid and parte neq data.PPparte>
						<tr><td colspan="2" style="padding:0; border-bottom: 1px solid black;"><strong>#data.PCPdescripcion#</strong></td></tr>
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
							<!---<cfinclude template="pcontestar-preguntas.cfm">--->
						</td>
					</tr>
					
					<cfset cuestionario = data.PCid >
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
				<input type="button" name="_back" value="< Anterior" disabled onClick="javascript:ira('back',parseInt(document.form1.actual.value))">
				<input type="button" name="_next" value="Siguiente >" <cfif divs eq 1>disabled</cfif> onClick="javascript:ira('goto',parseInt(document.form1.actual.value))">
				<input type="submit" name="guardar" value="Guardar" >
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
					if ( confirm('No puede calificar dos respuestas con el mismo valor ('+cual.value+'). Desea asignar el valor a la respuesta actual?') ){
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

</cfif> <!--- if listas de cuestionarios --->