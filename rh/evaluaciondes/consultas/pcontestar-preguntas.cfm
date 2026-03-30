<table width="100%" border="0" cellpadding="1" cellspacing="0">
<cfoutput>

	<cfquery name="datarespuestas" datasource="#session.DSN#">
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
	
    <cfif datarespuestas.recordCount GT 0>
		<cfset cantidad  = datarespuestas.recordCount>
	<cfelse>
		<cfset cantidad  = 1> 
	</cfif>
	
	<script type="text/javascript" language="javascript1.2">
		respuestas#pregunta# = new Array();
	</script>
	
	<cfif listcontains('V,O', data.PPtipo)>
		<cfset valores = listtoarray(listsort(data.PPrespuesta,'text')) >
	</cfif>

	<cfif data.PPtipo eq 'U' >
		<cfif LvarPPorientacion eq 1 >
            <tr>
        </cfif>
		<cfset porcentaje = 1000 /cantidad>
		
		<cfloop query="datarespuestas">
			<cfif isdefined('form.PCUid') and len(trim(form.PCUid))>
				<cfset contestada = traerValorRespuesta(form.PCUid, LvarPCid, pregunta, datarespuestas.PRid, LvarUsucodigo, LvarUsucodigoeval, 'PRid') >
			</cfif>
			<cfif LvarPPorientacion eq 0>
                <tr>
            </cfif>
				<td width="1%"  style="padding-left:5px; ">&nbsp;</td>
				<td colspan="2" valign="bottom">
					<table width="100%" cellpadding="0" cellspacing="0" border="0">
						<cfif LvarPPorientacion eq 1 >
							<tr>
								<cfquery datasource="#session.DSN#" name="respuestats">
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
									<td valign="top" width="#porcentaje#" style="padding-left:3px;" valign="bottom"><font size="2">#datarespuestas.PRtexto#</font></td>
								</cfif>
							</tr>						
							<tr>
								<td align="1%" >
									<cfif len(trim(datarespuestas.PRvalor))>
										<cfif isdefined('contestada') and datarespuestas.PRid eq contestada >
											 <img src="/cfmx/rh/imagenes/radioCheck.gif" />
										<cfelse>
											 <img src="/cfmx/rh/imagenes/radio.gif" />
										</cfif>
									</cfif>
								</td>
							</tr>	
						<cfelse>
							<tr>
								<td align="1%" >
									<cfif len(trim(datarespuestas.PRvalor))>
										<cfif isdefined('contestada') and datarespuestas.PRid eq contestada >
											 <img src="/cfmx/rh/imagenes/radioCheck.gif" />
										<cfelse>
											 <img src="/cfmx/rh/imagenes/radio.gif" />
										</cfif>
									</cfif>
								</td>
	
								<cfquery datasource="#session.DSN#" name="respuestats">
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
									<td width="99%" style="padding-left:3px;" valign="bottom"><font size="2">#datarespuestas.PRtexto#</font></td>
								</cfif>
							</tr>
						</cfif>
						
					</table>
				</td>
			<cfif LvarPPorientacion  eq 0>
                </tr>
            </cfif>
		</cfloop>
		<tr><td width="1%" >&nbsp;</td>
        <cfif LvarPPorientacion  eq 1>
        	</tr>
        </cfif>

	<cfelseif data.PPtipo eq 'M'>
		<cfif LvarPPorientacion eq 1 >
            <tr>
        </cfif>
        <cfset porcentaje = 1000 /cantidad>
		
		<cfloop query="datarespuestas">	
			<cfif isdefined('form.PCUid') and len(trim(form.PCUid))>
				<cfset contestada = traerValorRespuesta(form.PCUid, LvarPCid, pregunta, datarespuestas.PRid, LvarUsucodigo, LvarUsucodigoeval, 'PRid') >
			</cfif>	
			<cfif LvarPPorientacion eq 0 >
				<tr>
			</cfif>
				<td width="1%"   style="padding-left:5px; ">&nbsp;</td>
				<td colspan="2" align="right" valign="bottom">
					<table width="100%" border="0" cellpadding="0" cellspacing="0" align="right">
						<cfif LvarPPorientacion eq 1 >
							<tr>
								<cfquery datasource="#session.DSN#" name="respuestats">
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
									<td valign="top" width="#porcentaje#" style="padding-left:3px;"><font size="2">#datarespuestas.PRtexto#</font></td>
								</cfif>
							</tr>						
							<tr>
								<td width="1%" valign="top">
									<cfif len(trim(datarespuestas.PRvalor))>
										<cfif isdefined('contestada') and datarespuestas.PRid eq contestada >
											<img src="/cfmx/rh/imagenes/checked.gif" />
										<cfelse>
											<img src="/cfmx/rh/imagenes/unchecked.gif" />
										</cfif>
									</cfif>
								</td>
							</tr>	
						
						<cfelse>
							<tr>
								<td width="1%" valign="top">
									<cfif len(trim(datarespuestas.PRvalor))>
										<cfif isdefined('contestada') and datarespuestas.PRid eq contestada >
											<img src="/cfmx/rh/imagenes/checked.gif" />
										<cfelse>
											<img src="/cfmx/rh/imagenes/unchecked.gif" />
										</cfif>
									</cfif>
								</td>
								<cfquery datasource="#session.DSN#" name="respuestats">
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
						</cfif>
							
					</table>
				</td>
			<cfif LvarPPorientacion eq 0 >
				</tr>
			</cfif>	
		</cfloop>
		<tr><td>&nbsp;</td>
        <cfif LvarPPorientacion eq 1 >
            </tr>
        </cfif>

	<cfelseif data.PPtipo eq 'D'>
		<cfif isdefined('form.PCUid') and len(trim(form.PCUid))>
			<cfset contestada = traerValorPregunta(form.PCUid, LvarPCid, pregunta, LvarUsucodigo, LvarUsucodigoeval) >
		</cfif>
		<tr>
			<td width="1%" style="padding-left:5px; ">&nbsp;</td>
			<td colspan="2"  >
				<table width="664" height="100" bgcolor="##fafafa" style="border:1px solid ##808080" cellpadding="2" cellspacing="0">
					<tr><td valign="top"><cfif isdefined('contestada') and len(trim(contestada))>#contestada#</cfif></td></tr>
				</table>				
			</td>
		</tr>

	<cfelseif data.PPtipo eq 'V'>
		<cfif datarespuestas.recordcount gt 0 >
			<cfif ArrayLen(valores)>
				<cfloop query="datarespuestas">
					<cfif isdefined('form.PCUid') and len(trim(form.PCUid))>
						<cfset contestada = traerValorRespuesta(form.PCUid, LvarPCid, pregunta, datarespuestas.PRid, LvarUsucodigo, LvarUsucodigoeval, 'PRvalorresp') >
					</cfif>
					<tr>
						<td width="1%"   style="padding-left:5px; ">&nbsp;</td>
						<td width="3%" align="center" style="border-bottom:1px solid black;" >
							<cfloop from="1" to="#ArrayLen(valores)#" index="i">
								<cfif isdefined('contestada') and trim(contestada) eq trim(valores[i]) >#valores[i]#</cfif>
							</cfloop>
						</td>
						<cfquery datasource="#session.DSN#" name="respuestats">
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
			<cfelse>
				<cfloop query="datarespuestas">
					<cfif isdefined('form.PCUid') and len(trim(form.PCUid))>
						<cfset contestada = traerValorPregunta(form.PCUid, LvarPCid, pregunta, LvarUsucodigo, LvarUsucodigoeval ) >
					</cfif>
		
					<tr>
						<td  nowrap align="left">#datarespuestas.PRtexto#:</td>
						<td width="1%"   style="padding-left:5px; ">&nbsp;</td>
						<td ><cfif isdefined('contestada') and  len(trim(contestada))>#contestada#<cfelse>- No respondio la pregunta - </cfif></td>
					</tr>
				</cfloop>
			
			</cfif>
		<cfelse>
			<cfif isdefined('form.PCUid') and len(trim(form.PCUid))>
				<cfset contestada = traerValorPregunta(form.PCUid, LvarPCid, pregunta, LvarUsucodigo, LvarUsucodigoeval ) >
			</cfif>
			<tr>
				<td width="1%"   style="padding-left:5px; ">&nbsp;</td>
				<td colspan="2" >
					<cfif isdefined('contestada') and  len(trim(contestada))>#contestada#<cfelse>- No respondio la pregunta - </cfif>
				</td>
			</tr>
		</cfif>
		<tr><td width="1%" >&nbsp;</td></tr>
	<cfelseif data.PPtipo eq 'O'>
		<cfloop query="datarespuestas">
			<cfif isdefined('form.PCUid') and len(trim(form.PCUid))>
				<cfset contestada = traerValorRespuesta(form.PCUid, LvarPCid, pregunta, datarespuestas.PRid, LvarUsucodigo, LvarUsucodigoeval, 'PRvalorresp') >
			</cfif>

			<tr>
				<td width="1%"   style="padding-left:5px; ">&nbsp;</td>
				<td width="3%" style="border-bottom:1px solid black;" align="center"  >
				<cfloop from="1" to="#ArrayLen(valores)#" index="i">
					<cfif isdefined('contestada') and contestada eq valores[i] >#valores[i]#</cfif>
				</cfloop>
				</td>
				<td width="99%" style="padding-left:3px;"><font size="2">
					#datarespuestas.PRtexto#
				</font></td>
			</tr>
		</cfloop>
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