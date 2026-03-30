<table width="100%" border="0" cellpadding="1" cellspacing="0">
<cfoutput>

	<cfquery name="datarespuestas" datasource="sifcontrol">
		select pr.PPid, 
			   pr.PCid,
			   pp.PPparte as parte,
			   pp.PPtipo, 
			   pp.PPrespuesta, 
			   pr.PRid,
			   pr.PRvalor, 
			   pr.PRtexto, 
			   pr.PRimagen
		from PortalCuestionario pc
		
		inner join PortalPregunta pp
		on pc.PCid=pp.PCid

		left outer join PortalRespuesta pr
		on pp.PPid=pr.PPid

		where pr.PCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarPCid#">
		  and pr.PPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#pregunta#">
		  and pp.PPtipo != 'E'
		  order by pr.PRorden
	</cfquery>
	
	<script type="text/javascript" language="javascript1.2">
		respuestas[#pregunta#] = new Array();
	</script>
	
	<cfif listcontains('V,O', data.PPtipo)>
		<cfset valores = listtoarray(listsort(data.PPrespuesta,'text')) >
	</cfif>

	<cfif data.PPtipo eq 'U' >
		<cfloop query="datarespuestas">
			<cfif isdefined('form.PCUid') and len(trim(form.PCUid))>
				<cfset contestada = traerValorRespuesta(form.PCUid, LvarPCid, pregunta, datarespuestas.PRid, form.BUid, 'PRid') >
				<cfif datarespuestas.PRid eq contestada >
					<script type="text/javascript" language="javascript1.2">
						if ( !preguntas[#LvarPCid#][#datarespuestas.parte#][#pregunta#][0] ){
							preguntas[#LvarPCid#][#datarespuestas.parte#][#pregunta#][0] = true
							partes[#LvarPCid#][#datarespuestas.parte#][1] = parseInt(partes[#LvarPCid#][#datarespuestas.parte#][1]) + 1;
						}
					</script>
				</cfif>
			</cfif>
			<tr>
				<td width="1%"  style="padding-left:5px; ">&nbsp;</td>
				<td colspan="2">
					<table width="100%" cellpadding="0" cellspacing="0">
						<tr>
							<td align="1%" ><cfif len(trim(datarespuestas.PRvalor))><input style="border:0;" type="radio" <cfif isdefined('contestada') and datarespuestas.PRid eq contestada >checked</cfif> name="p_#pregunta#" value="#datarespuestas.PRid#" onclick="javascript:validar_radio(#LvarPCid#, #datarespuestas.parte#, #pregunta#, this);"></cfif></td>
							<cfquery datasource="sifcontrol" name="respuestats">
								select PRimagen, ts_rversion 
								from PortalRespuesta
								where PRid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#datarespuestas.PRid#">
							</cfquery>
							<cfif Len(respuestats.PRimagen) GT 1>
								<td>
								<cfinvoke component="sif.Componentes.DButils"
										  method="toTimeStamp"
										  returnvariable="tsurl">
									<cfinvokeargument name="arTimeStamp" value="#respuestats.ts_rversion#"/>
								</cfinvoke>
								<img src="/cfmx/rh/evaluaciondes/operacion/logo_respuesta.cfm?PRid=#datarespuestas.PRid#&ts=#tsurl#" border="0">
								</td>
							<cfelse>
								<td width="99%" style="padding-left:3px;"><font size="2">#datarespuestas.PRtexto#</font></td>
							</cfif>

						</tr>
					</table>
				</td>
			</tr>
		</cfloop>
		<script type="text/javascript" language="javascript1.2">
			size = respuestas[#pregunta#].length
			respuestas[#pregunta#][size] = document.form1['p_#pregunta#'];
		</script>

		<tr><td></td><td colspan="2"><table width="100%"><tr><td><a href="javascript:limpiar_radio(#LvarPCid#,#datarespuestas.parte#,#pregunta#)"><font color="##666666">[<cf_translate key="LB_LimpiarLasRespuestaDadasAEstaPregunta">Limpiar las respuestas dadas a esta pregunta</cf_translate>]</font></a></td><td></td></tr></table></td></tr>
		<tr><td width="1%" >&nbsp;</td></tr>

	<cfelseif data.PPtipo eq 'M'>
		<cfloop query="datarespuestas">	
			<cfif isdefined('form.PCUid') and len(trim(form.PCUid))>
				<cfset contestada = traerValorRespuesta(form.PCUid, LvarPCid, pregunta, datarespuestas.PRid, form.BUid, 'PRid') >

				<cfif datarespuestas.PRid eq contestada >
					<script type="text/javascript" language="javascript1.2">
						if ( !preguntas[#LvarPCid#][#datarespuestas.parte#][#pregunta#][0] ){
							preguntas[#LvarPCid#][#datarespuestas.parte#][#pregunta#][0] = true
							partes[#LvarPCid#][#datarespuestas.parte#][1] = parseInt(partes[#LvarPCid#][#datarespuestas.parte#][1]) + 1;
						}
					</script>
				</cfif>

			</cfif>	
			<tr>
				<td width="1%"   style="padding-left:5px; ">&nbsp;</td>
				<td colspan="2" align="right">
					<table width="100%" border="0" cellpadding="0" cellspacing="0" align="right">
						<tr>
							<td width="1%" valign="top"><cfif len(trim(datarespuestas.PRvalor))><input style="border:0; margin:0;" type="checkbox" <cfif isdefined('contestada') and datarespuestas.PRid eq contestada >checked</cfif> name="p_#pregunta#_#datarespuestas.PRid#" value="#datarespuestas.PRid#" onclick="javascript:validar_check(#LvarPCid#, #datarespuestas.parte#, #pregunta#, this);"></cfif></td>
							<cfquery datasource="sifcontrol" name="respuestats">
								select PRimagen, ts_rversion 
								from PortalRespuesta
								where PRid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#datarespuestas.PRid#">
							</cfquery>
							<cfif Len(respuestats.PRimagen) GT 1>
								<td>
								<cfinvoke component="sif.Componentes.DButils"
										  method="toTimeStamp"
										  returnvariable="tsurl">
									<cfinvokeargument name="arTimeStamp" value="#respuestats.ts_rversion#"/>
								</cfinvoke>
								<img src="/cfmx/rh/evaluaciondes/operacion/logo_respuesta.cfm?PRid=#datarespuestas.PRid#&ts=#tsurl#" border="0">
								</td>
							<cfelse>
								<td width="99%" style="padding-left:3px;"><font size="2">#datarespuestas.PRtexto#</font></td>
							</cfif>

						</tr>
					</table>
				</td>
			</tr>

			<script type="text/javascript" language="javascript1.2">
				size = respuestas[#pregunta#].length
				respuestas[#pregunta#][size] = document.form1['p_#pregunta#_#datarespuestas.PRid#'];
			</script>

		</cfloop>
		<tr><td></td><td colspan="2"><table width="100%"><tr><td><a href="javascript:limpiar_check(#LvarPCid#,#datarespuestas.parte#,#pregunta#)"><font color="##666666">[<cf_translate key="LB_LimpiarLasRespuestaDadasAEstaPregunta">Limpiar las respuestas dadas a esta pregunta</cf_translate>]</font></a></td><td></td></tr></table></td></tr>
		<tr><td>&nbsp;</td></tr>

	<cfelseif data.PPtipo eq 'D'>
		<cfif isdefined('form.PCUid') and len(trim(form.PCUid))>
			<cfset contestada = traerValorPregunta(form.PCUid, LvarPCid, pregunta, form.BUid) >
		</cfif>
		<tr>
			<td width="1%" style="padding-left:5px; ">&nbsp;</td>
			<td colspan="2"  ><textarea name="p_#pregunta#" cols="80" rows="5" onblur="javascript:validar_text(#LvarPCid#, #LvarParte#, #pregunta#, this);" ><cfif isdefined('contestada') and len(trim(contestada))>#contestada#</cfif></textarea></td>
			<script type="text/javascript" language="javascript1.2">
				respuestas[#pregunta#][0] = document.form1['p_#pregunta#'];
			</script>
		</tr>
	<cfelseif data.PPtipo eq 'V'>
		<cfif datarespuestas.recordcount gt 0 >
			<cfif ArrayLen(valores)>
				<cfloop query="datarespuestas">
					<cfif isdefined('form.PCUid') and len(trim(form.PCUid))>
						<cfset contestada = traerValorRespuesta(form.PCUid, LvarPCid, pregunta, datarespuestas.PRid, form.BUid, 'PRvalorresp') >
						<cfloop from="1" to="#ArrayLen(valores)#" index="j">
							<cfif contestada eq valores[j] >
								<script type="text/javascript" language="javascript1.2">
									if ( !preguntas[#LvarPCid#][#datarespuestas.parte#][#pregunta#][0] ){
										preguntas[#LvarPCid#][#datarespuestas.parte#][#pregunta#][0] = true
										partes[#LvarPCid#][#datarespuestas.parte#][1] = parseInt(partes[#LvarPCid#][#datarespuestas.parte#][1]) + 1;
									}
								</script>
							</cfif>
						</cfloop>	
					</cfif>
					<tr>
						<td width="1%"   style="padding-left:5px; ">&nbsp;</td>
						<td width="1%">
							<select name="p_#pregunta#_#datarespuestas.PRid#" onchange="javascript:validar_combo(#LvarPCid#, #datarespuestas.parte#, #pregunta#, this);" >
								<option value=""></option>
								<cfloop from="1" to="#ArrayLen(valores)#" index="i">
									<option value="#i#" <cfif isdefined('contestada') and trim(contestada) eq trim(valores[i]) >selected</cfif>>#valores[i]#</option>
								</cfloop>
							</select>
							<script type="text/javascript" language="javascript1.2">
								size = respuestas[#pregunta#].length
								respuestas[#pregunta#][size] = document.form1['p_#pregunta#_#datarespuestas.PRid#'];
							</script>
						</td>
						<cfquery datasource="sifcontrol" name="respuestats">
							select PRimagen, ts_rversion 
							from PortalRespuesta
							where PRid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#datarespuestas.PRid#">
						</cfquery>
						<cfif Len(respuestats.PRimagen) GT 1>
							<td>
								<cfinvoke component="sif.Componentes.DButils"
										  method="toTimeStamp"
										  returnvariable="tsurl">
									<cfinvokeargument name="arTimeStamp" value="#respuestats.ts_rversion#"/>
								</cfinvoke>
								<img src="/cfmx/rh/evaluaciondes/operacion/logo_respuesta.cfm?PRid=#datarespuestas.PRid#&ts=#tsurl#" border="0">
							</td>
						<cfelse>
							<td width="99%" style="padding-left:3px;"><font size="2">#trim(datarespuestas.PRtexto)#</font></td>
						</cfif>
					</tr>
				</cfloop>
				<tr><td></td><td colspan="2"><table width="100%"><tr><td><a href="javascript:limpiar_combo(#LvarPCid#,#datarespuestas.parte#,#pregunta#)"><font color="##666666">[<cf_translate key="LB_LimpiarLasRespuestaDadasAEstaPregunta">Limpiar las respuestas dadas a esta pregunta</cf_translate>]</font></a></td><td></td></tr></table></td></tr>
			<cfelse>
				<cfloop query="datarespuestas">
					<cfif isdefined('form.PCUid') and len(trim(form.PCUid))>
						<cfset contestada = traerValorPregunta(form.PCUid, LvarPCid, pregunta, form.BUid ) >
					</cfif>
		
					<tr>
						<td  nowrap align="left">#datarespuestas.PRtexto#</td>
						<td width="1%"   style="padding-left:5px; ">&nbsp;</td>
						<td ><input type="text" size="30" maxlength="30" value="<cfif isdefined('contestada') and  len(trim(contestada))>#contestada#</cfif>" name="p_#pregunta#_#datarespuestas.PRid#" onblur="javascript:validar_text(#LvarPCid#, #datarespuestas.parte#, #pregunta#, this);" ></td>
						<script type="text/javascript" language="javascript1.2">
							size = respuestas[#pregunta#].length
							respuestas[#pregunta#][size] = document.form1['p_#pregunta#_#datarespuestas.PRid#'];
						</script>
					</tr>
				</cfloop>
			
			</cfif>
		<cfelse>
			<cfif isdefined('form.PCUid') and len(trim(form.PCUid))>
				<cfset contestada = traerValorPregunta(form.PCUid, LvarPCid, pregunta, form.BUid ) >
			</cfif>

			<tr>
				<td width="1%"   style="padding-left:5px; ">&nbsp;</td>
				<td colspan="2" ><input type="text" size="7" maxlength="7" value="<cfif isdefined('contestada') and  len(trim(contestada))>#contestada#</cfif>" name="p_#pregunta#" onblur="javascript:validar_text(#LvarPCid#, #LvarParte#, #pregunta#, this);"></td>
				<script type="text/javascript" language="javascript1.2">
					respuestas[#pregunta#][0] = document.form1['p_#pregunta#'];
				</script>
			</tr>
		</cfif>
		<tr><td width="1%" >&nbsp;</td></tr>
	<cfelseif data.PPtipo eq 'O'>
		<script type="text/javascript" language="javascript1.2">
			var contenedor_#pregunta# = new Array();
		</script>
		<cfloop query="datarespuestas">
			<cfif isdefined('form.PCUid') and len(trim(form.PCUid))>
				<cfset contestada = traerValorRespuesta(form.PCUid, LvarPCid, pregunta, datarespuestas.PRid, form.BUid, 'PRvalorresp') >
				<cfloop from="1" to="#ArrayLen(valores)#" index="j">
					<cfif contestada eq valores[j] >
						<script type="text/javascript" language="javascript1.2">
							if ( !preguntas[#LvarPCid#][#datarespuestas.parte#][#pregunta#][0] ){
								preguntas[#LvarPCid#][#datarespuestas.parte#][#pregunta#][0] = true
								partes[#LvarPCid#][#datarespuestas.parte#][1] = parseInt(partes[#LvarPCid#][#datarespuestas.parte#][1]) + 1;
							}
						</script>
					</cfif>
				</cfloop>	
			</cfif>

			<script type="text/javascript" language="javascript1.2">
				contenedor_#pregunta#[#datarespuestas.currentrow-1#] = new Array();
				contenedor_#pregunta#[#datarespuestas.currentrow-1#][0] = #datarespuestas.PRid#;
				contenedor_#pregunta#[#datarespuestas.currentrow-1#][1] = '';
			</script>

			<tr>
				<td width="1%"   style="padding-left:5px; ">&nbsp;</td>
				<td width="1%"  >
					<select name="p_#pregunta#_#datarespuestas.PRid#" id="p_#datarespuestas.PPid#_#datarespuestas.PRid#" onChange="javascript:excluye(this, #pregunta#, #datarespuestas.PRid#); validar_combo(#LvarPCid#, #datarespuestas.parte#, #pregunta#, this);">
						<option value=""></option>
						<cfloop from="1" to="#ArrayLen(valores)#" index="i">
							<option value="#i#" <cfif isdefined('contestada') and contestada eq valores[i] >selected</cfif> >#valores[i]#</option>
						</cfloop>
					</select>
					<script type="text/javascript" language="javascript1.2">
						size = respuestas[#pregunta#].length
						respuestas[#pregunta#][size] = document.form1['p_#pregunta#_#datarespuestas.PRid#'];
					</script>
				</td>
				<td width="99%" style="padding-left:3px;"><font size="2">#datarespuestas.PRtexto#</font></td>
			</tr>
		</cfloop>
		<tr><td></td><td colspan="2"><table width="100%"><tr><td><a href="javascript:limpiar_combo(#LvarPCid#,#datarespuestas.parte#,#pregunta#)"><font color="##666666">[<cf_translate key="LB_LimpiarLasRespuestaDadasAEstaPregunta">Limpiar las respuestas dadas a esta pregunta</cf_translate>]</font></a></td><td></td></tr></table></td></tr>
		<tr><td width="1%" >&nbsp;</td></tr>
	</cfif>
</cfoutput>
</table>
<!--- VARIABLES DE TRADUCCION --->
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_EstaParteDelCuestionarioSoloPermiteContestar"
	Default="Esta parte del cuestionario solo permite contestar"
	returnvariable="MSG_EstaParteDelCuestionarioSoloPermiteContestar"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_PreguntasSiDeseaContestarOtraPreguntaElimineAlgunaDeLasPreguntasQueYaRespondio"
	Default="preguntas.\nSi desea contestar otra pregunta, elimine alguna de las preguntas que ya respondió"
	returnvariable="MSG_PreguntasSiDeseaContestarOtraPreguntaElimineAlgunaDeLasPreguntasQueYaRespondio"/>	
	
<script type="text/javascript" language="javascript1.2">
	/*	Validacion de preguntas por parte:
		Hay dos estructuras en javascript:
			1. partes: me indica el cuestionario, las partes por cuestionario, y para cada par de esta combinacion (PCid, PPparte) me dice
			   cuantas preguntas debeb contestar como maximo y cuantas lleva contestadas 
			2. preguntas: me indica el cuestionario, parte, pregunta, y por cada una de estas combinaciones me dice si una pregunta ya fue contestada.
			   Esto porque, por ejemplo si la pregunta es de tipo checkbox, solo debo contabilizar una vez que la pregunta ya se contesto y no contabilizar
			   la cantidad de checks que hay para esa pregunta.
			3. respuestas: es un contenedor de todos los objetos que se pintaron por pregunta. Tiene una referencia a cada objeto, ordenados por pregunta.
	*/

	function validar_radio(cuestionario, parte, pregunta, obj){
		// 1. Valida solo si el numero maximo es mayor a 0, osea hay un limite de preguntas
		//    si es cero significa que responde toda la parte
		if ( parseInt(partes[cuestionario][parte][0]) > 0 ){
			// 2. Valida si la pregunta ya esta contestada.
			//    Si ya lo esta, no contabliza esta pregunta, 
			//    si no lo esta si contabiliza 
			if ( !preguntas[cuestionario][parte][pregunta][0] ){
				if ( parseInt(partes[cuestionario][parte][1]) < parseInt(partes[cuestionario][parte][0]) ){
					preguntas[cuestionario][parte][pregunta][0] = true;
					partes[cuestionario][parte][1] = parseInt(partes[cuestionario][parte][1]) + 1;
				}	
				else{
					alert('<cfoutput>#MSG_EstaParteDelCuestionarioSoloPermiteContestar#</cfoutput> ' + partes[cuestionario][parte][0] + ' <cfoutput>#MSG_PreguntasSiDeseaContestarOtraPreguntaElimineAlgunaDeLasPreguntasQueYaRespondio#</cfoutput>.');
					obj.checked = false;
				}
			}
		}
	}

	function validar_combo(cuestionario, parte, pregunta, obj){
		// 1. Valida solo si el numero maximo es mayor a 0, osea hay un limite de preguntas
		//    si es cero significa que responde toda la parte
		if ( parseInt(partes[cuestionario][parte][0]) > 0 ){
			// 2. Valida si la pregunta ya esta contestada.
			//    Si ya lo esta, no contabliza esta pregunta, 
			//    si no lo esta si contabiliza 
			if ( !preguntas[cuestionario][parte][pregunta][0] ){
				if ( parseInt(partes[cuestionario][parte][1]) < parseInt(partes[cuestionario][parte][0]) ){
					if ( obj.value != '' ){
						preguntas[cuestionario][parte][pregunta][0] = true;
						partes[cuestionario][parte][1] = parseInt(partes[cuestionario][parte][1]) + 1;
					}
				}	
				else{
					alert('<cfoutput>#MSG_EstaParteDelCuestionarioSoloPermiteContestar#</cfoutput> ' + partes[cuestionario][parte][0] + ' <cfoutput>#MSG_PreguntasSiDeseaContestarOtraPreguntaElimineAlgunaDeLasPreguntasQueYaRespondio#</cfoutput>.');
					obj.value = '';
				}

			}
			else{
				if ( !(obj.value != '')  ){
					for( var i=0; i<= respuestas[pregunta].length-1; i++ ){
						if ( respuestas[pregunta][i].value != '' ){
							return
						}
					}
					preguntas[cuestionario][parte][pregunta][0] = false;
					partes[cuestionario][parte][1] = parseInt(partes[cuestionario][parte][1]) - 1;
					if ( parseInt(partes[cuestionario][parte][1]) < 0 ){
						partes[cuestionario][parte][1] = 0;
					}
				}
			}	
		}
	}
	
	function validar_check(cuestionario, parte, pregunta, obj){
		// 1. Valida solo si el numero maximo es mayor a 0, osea hay un limite de preguntas
		//    si es cero significa que responde toda la parte
		if ( parseInt(partes[cuestionario][parte][0]) > 0 ){
			// 2. Valida si la pregunta ya esta contestada.
			//    Si ya lo esta, no contabliza esta pregunta, 
			//    si no lo esta si contabiliza 
			if ( !preguntas[cuestionario][parte][pregunta][0] ){
				if ( obj.checked ){
					if ( parseInt(partes[cuestionario][parte][1]) < parseInt(partes[cuestionario][parte][0]) ){
						preguntas[cuestionario][parte][pregunta][0] = true;
						partes[cuestionario][parte][1] = parseInt(partes[cuestionario][parte][1]) + 1;
					}	
					else{
						alert('<cfoutput>#MSG_EstaParteDelCuestionarioSoloPermiteContestar#</cfoutput> ' + partes[cuestionario][parte][0] + ' <cfoutput>#MSG_PreguntasSiDeseaContestarOtraPreguntaElimineAlgunaDeLasPreguntasQueYaRespondio#</cfoutput>.');
						obj.checked = false;
					}
				}
			}
			else{
				if ( !obj.checked ){
					for( var i=0; i<= respuestas[pregunta].length-1; i++ ){
						if ( respuestas[pregunta][i].checked ){
							return
						}
					}
					preguntas[cuestionario][parte][pregunta][0] = false;
					partes[cuestionario][parte][1] = parseInt(partes[cuestionario][parte][1]) - 1;
					if ( parseInt(partes[cuestionario][parte][1]) < 0 ){
						partes[cuestionario][parte][1] = 0;
					}
				}
			}	
		}
	}
	
	function validar_text(cuestionario, parte, pregunta, obj){
		// 1. Valida solo si el numero maximo es mayor a 0, osea hay un limite de preguntas
		//    si es cero significa que responde toda la parte
		if ( parseInt(partes[cuestionario][parte][0]) > 0 ){
			// 2. Valida si la pregunta ya esta contestada.
			//    Si ya lo esta, no contabliza esta pregunta, 
			//    si no lo esta si contabiliza 
			if ( !preguntas[cuestionario][parte][pregunta][0] ){
				if ( parseInt(partes[cuestionario][parte][1]) < parseInt(partes[cuestionario][parte][0]) ){
					if ( obj.value != '' ){
						preguntas[cuestionario][parte][pregunta][0] = true;
						partes[cuestionario][parte][1] = parseInt(partes[cuestionario][parte][1]) + 1;
					}
				}	
				else{
					alert('<cfoutput>#MSG_EstaParteDelCuestionarioSoloPermiteContestar#</cfoutput> ' + partes[cuestionario][parte][0] + ' <cfoutput>#MSG_PreguntasSiDeseaContestarOtraPreguntaElimineAlgunaDeLasPreguntasQueYaRespondio#</cfoutput>.');
					obj.value = '';
				}

			}
			else{
				if ( !(obj.value != '')  ){
					for( var i=0; i<= respuestas[pregunta].length-1; i++ ){
						if ( respuestas[pregunta][i].value != '' ){
							return
						}
					}
					preguntas[cuestionario][parte][pregunta][0] = false;
					partes[cuestionario][parte][1] = parseInt(partes[cuestionario][parte][1]) - 1;
					if ( parseInt(partes[cuestionario][parte][1]) < 0 ){
						partes[cuestionario][parte][1] = 0;
					}
				}
			}	
		}
	}
	
	function limpiar_radio(cuestionario, parte, pregunta){
		if (preguntas[cuestionario][parte][pregunta][0]){
			partes[cuestionario][parte][1] = parseInt(partes[cuestionario][parte][1]) - 1;
		}
		preguntas[cuestionario][parte][pregunta][0] = false;
		for( var j=0; j<= respuestas[pregunta][0].length-1; j++ ){
			respuestas[pregunta][0][j].checked = false;
		}	
	}

	function limpiar_check(cuestionario, parte, pregunta){
		if (preguntas[cuestionario][parte][pregunta][0]){
			partes[cuestionario][parte][1] = parseInt(partes[cuestionario][parte][1]) - 1;
		}
		preguntas[cuestionario][parte][pregunta][0] = false;
		for( var i=0; i<= respuestas[pregunta].length-1; i++ ){
			respuestas[pregunta][i].checked = false;
		}	
	}

	function limpiar_combo(cuestionario, parte, pregunta){
		if (preguntas[cuestionario][parte][pregunta][0]){
			partes[cuestionario][parte][1] = parseInt(partes[cuestionario][parte][1]) - 1;
		}
		preguntas[cuestionario][parte][pregunta][0] = false;
		for( var i=0; i<= respuestas[pregunta].length-1; i++ ){
			respuestas[pregunta][i].value = '';
		}	
	}



	
</script>