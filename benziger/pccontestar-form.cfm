<cffunction name="traerValorPregunta">
	<cfargument name="PCUid" required="yes" type="numeric">
	<cfargument name="PCid" required="yes" type="numeric">
	<cfargument name="PPid" required="yes" type="numeric">
	<cfargument name="BUid" required="yes" type="numeric">
	
	<cfquery name="respuesta" datasource="sifcontrol">
		select PCUtexto
		from PortalPreguntaU ppu
		
		inner join PortalCuestionarioU pcu
		on ppu.PCUid=pcu.PCUid
		and pcu.PCUid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.PCUid#">
		and pcu.BUid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.BUid#">
		
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
	<cfargument name="BUid" required="yes" type="numeric">
	<cfargument name="tipo" required="yes" type="string">	<!--- Para saber si devuelve PRvalorresp o PRid ---> 
	
	<cfquery name="respuesta" datasource="sifcontrol">
		select pru.PRid, pru.PRvalorresp
		from PortalRespuestaU pru
		
		inner join PortalPreguntaU ppu
		on pru.PCUid=ppu.PCUid
		and pru.PCid=ppu.PCid
		and pru.PPid=ppu.PPid
		
		inner join PortalCuestionarioU pcu
		on ppu.PCUid=pcu.PCUid
		and pcu.PCUid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.PCUid#">
		and pcu.BUid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.BUid#">		
		
		where pru.PCUid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.PCUid#">
		  and pru.PCid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.PCid#">
		  and pru.PPid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.PPid#">
		  and pru.PRid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.PRid#">
	</cfquery>

	<cfif tipo eq 'PRid'>
		<cfreturn respuesta.PRid >
	<cfelse>
		<cfreturn respuesta.PRvalorresp >
	</cfif>
</cffunction>

<!--- Calcula los ids de evaluando y evaluador.
	  Cuando es autoevaluacion son los mismos valores (DEid=DEideval, Usucodigo=Usucodigoeval)	
 --->
<!---
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
--->

<cfset listaPCid = form.PCid >

<cfif listlen(listaPCid)> <!--- if listas de cuestionarios --->
	<cfquery name="data" datasource="sifcontrol">
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
	<!--- Almacena el cuestionario, parte, maximo de preguntas, preguntas contestadas por parte --->	
	<cfquery name="partes" datasource="sifcontrol">
		select PCid, PPparte, PCPmaxpreguntas 
		from PortalCuestionarioParte
		where PCid in (#listaPCid#)
		order by PCid
	</cfquery>

	<script type="text/javascript" language="javascript1.2">
		var respuestas = new Object();		
		var partes = new Object();
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
	
	<!--- ------------------------------ --->
	<script type="text/javascript" language="javascript1.2">
		var preguntas = new Object();		
	</script>
	<cfoutput query="data" group="PCid">
		<cfset _PCid = data.PCid >
		<script type="text/javascript" language="javascript1.2">
			preguntas[#_PCid#] = new Object();
		</script>
		
		<cfoutput group="PPparte">
			<cfset _PPparte = data.PPparte >
			<script type="text/javascript" language="javascript1.2">
				preguntas[#_PCid#][#_PPparte#] = new Object();
			</script>		
		</cfoutput>

		<cfoutput group="PPid">
			<cfset _PPid = data.PPid >
			<cfset _PPparte = data.PPparte >
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
<form name="form1" style="margin:0;" method="post" action="pccontestar-sql.cfm" >
	<input type="hidden" name="totalPCid" value="1">
	<input type="hidden" name="inicio" value="1">
	<input type="hidden" name="actual" value="1">
	<input type="hidden" name="BUid" value="#form.BUid#">
	<input type="hidden" name="PCcodigo" value="#form.PCcodigo#">	
	<cfif isdefined("form.PCUid") and len(trim(form.PCUid))>
		<input type="hidden" name="PCUid" value="#form.PCUid#">	
	</cfif>
	
	<cfset j = 0 >
	<cfloop list="#listaPCid#" index="_pcid">
		<cfset j = j+1 >
		<input type="hidden" name="PCid_#j#" value="#_pcid#">
	</cfloop>

	<cfif isdefined('dataPCUid.PCUid')>
		<input type="hidden" name="PCUid" value="#dataPCUid.PCUid#">
	</cfif>

		<table width="942" cellpadding="0" cellspacing="0" align="center">
			<tr><td align="center">
				<div align="center" style=" width:950px; border:1px solid ##F1F1F1; display:block; padding: 10 10 10 10;" >  <!--- contenedor principal --->
				<cfset cuestionario = '' >
				<cfset parte = '' >
				<cfloop query="data" >
					<cfset LvarPCid = data.PCid >
					<cfset LvarParte = data.PPparte >
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
								<tr><td colspan="2"style="padding:0;"><strong style="font-family:'Times New Roman', Times, serif; font-size:15pt; font-variant:small-caps; font-weight:bolder; padding-left:20px">#data.PCcodigo# - #data.PCnombre#</strong></td></tr>
								<tr><td>&nbsp;</td></tr>
								<tr><td colspan="2" style="padding:0; border-bottom: 1px solid black;"><strong>#data.PCPdescripcion#</strong></td></tr>
								<tr><td>&nbsp;</td></tr>
					<!--- esto es solo para saber si cambio el numero de Parte y pintarla esto estaba como un if en la linea 383 --->
					<cfelseif cuestionario eq data.PCid and parte neq data.PPparte>
						<tr><td colspan="2" style="padding:0; border-bottom: 1px solid black;"><strong>#data.PCPdescripcion#</strong></td></tr>
						<tr><td>&nbsp;</td></tr>
					</cfif>
					
					<!--- esto es solo para saber si cambio el cuestionario y pintar el titulo del mismo--->
					<cfif len(trim(cuestionario)) and cuestionario neq data.PCid and data.PPmantener eq 1>
						<tr><td>&nbsp;</td></tr>
						<tr><td colspan="2" style="padding:0;"><strong style="font-family:'Times New Roman', Times, serif; font-size:15pt; font-variant:small-caps; font-weight:bolder; padding-left:20px">#data.PCcodigo# - #data.PCnombre#</strong></td></tr>
						<tr><td>&nbsp;</td></tr>
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
							<cfinclude template="pcontestar-preguntas.cfm">
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
		<cfinvoke component="sif.Componentes.Translate"
			method="Translate"
			Key="BTN_Anterior"
			Default="Anterior"
			XmlFile="/sif/rh/generales.xml"
			returnvariable="BTN_Anterior"/>
		<cfinvoke component="sif.Componentes.Translate"
			method="Translate"
			Key="BTN_Siguiente"
			Default="Siguiente"
			XmlFile="/sif/rh/generales.xml"
			returnvariable="BTN_Siguiente"/>			
		<cfinvoke component="sif.Componentes.Translate"
			method="Translate"
			Key="BTN_Guardar"
			Default="Guardar"
			XmlFile="/sif/rh/generales.xml"
			returnvariable="BTN_Guardar"/>			
		<table width="100%" align="center">
			<tr><td align="center">
				<input type="button" name="_back" value="< #BTN_Anterior#" disabled onClick="javascript:ira('back',parseInt(document.form1.actual.value))">
				<input type="button" name="_next" value="#BTN_Siguiente# >" <cfif divs eq 1>disabled</cfif> onClick="javascript:ira('goto',parseInt(document.form1.actual.value))">
				<input type="submit" name="guardar" value="#BTN_Guardar#" >
			</td></tr>
			<tr><td>&nbsp;</td></tr>
		</table>	

	</form>
</cfoutput>

<!--- VARIABLES DE TRADUCCION --->
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_NoPuedeCalificarDosRespuestasConElMismoValor"
	Default="No puede calificar dos respuestas con el mismo valor ("
	returnvariable="MSG_NoPuedeCalificarDosRespuestasConElMismoValor"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_DeseaAsignarelValorALaRespuestaActual"
	Default="Desea asignar el valor a la respuesta actual?"
	returnvariable="MSG_DeseaAsignarelValorALaRespuestaActual"/>	
	
	
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

</cfif> <!--- if listas de cuestionarios --->