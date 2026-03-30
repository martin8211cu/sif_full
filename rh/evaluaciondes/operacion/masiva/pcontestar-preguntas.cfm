<table width="100%" border="0" cellpadding="0" cellspacing="0">
<cfoutput>
	<cfquery name="datarespuestas" datasource="#session.DSN#">
		select pr.PPid, 
			   pr.PCid,
			   pp.PPparte as parte,
			   pp.PPtipo, 
			   pp.PPrespuesta, 
			   pr.PRid,
			   pr.PRvalor, 
			   case when len(PRtexto) > 1 then 
			   	coalesce(pr.PRtexto,'&nbsp;') 
			   else
			   	'&nbsp;'
			   end 	   as PRtexto, 
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
	
	
	<!--- <cfdump var="#datarespuestas#"> --->
	<cfif listcontains('V,O', data.PPtipo)>
		<cfset valores = listtoarray(listsort(data.PPrespuesta,'text')) >
	</cfif>

	<cfif data.PPtipo eq 'U' >
		 <cfif LvarPPorientacion eq 1 >
            <tr>
        </cfif>
        
		<cfset porcentaje = 1000 /cantidad>
		
		<cfloop query="datarespuestas">
			<cfif isdefined('Lvar_PCUid') and len(trim(Lvar_PCUid))>
				<cfset contestada = traerValorRespuesta(Lvar_PCUid, LvarPCid, pregunta, datarespuestas.PRid, rsevaluando.Usucodigo, LvarUsucodigoeval, 'PRid') >
				<!--- PCUid:<cfdump var="#Lvar_PCUid#"><br>
				PCid:<cfdump var="#LvarPCid#"><br>
				PPid<cfdump var="#pregunta#"><br>
				PRid:<cfdump var="#datarespuestas.PRid#"><br>
				Usucodigo:<cfdump var="#rsevaluando.Usucodigo#"><br>
				Usucodigoeval:<cfdump var="#LvarUsucodigoeval#"><br>
				
				R/<cfdump var="#contestada#"><br> --->
			</cfif>
			<cfif LvarPPorientacion eq 0 >
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
									<td  valign="top" width="#porcentaje#" style="padding-left:3px;"><font  style="font-size:10px">#datarespuestas.PRtexto#</font></td>
								</cfif>
							</tr>								
							<tr>
								<td align="1%" >
									<cfif len(trim(datarespuestas.PRvalor))>
										<input style="border:0;font-size:10px;" 
												type="radio" 
												id="p_#empleado#_#pregunta#"
												<cfif isdefined('contestada') and datarespuestas.PRid eq contestada >checked</cfif> 
												name="p_#empleado#_#pregunta#" 
												value="#datarespuestas.PRid#" 
												>
									</cfif>
								</td>
							</tr>
						<cfelse>
							<tr>
								<td align="1%" >
									<cfif len(trim(datarespuestas.PRvalor))>
										<input style="border:0;font-size:10px;" 
												type="radio" 
												id="p_#empleado#_#pregunta#"
												<cfif isdefined('contestada') and datarespuestas.PRid eq contestada >checked</cfif> 
												name="p_#empleado#_#pregunta#" 
												value="#datarespuestas.PRid#" >
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
									<td width="99%" style="padding-left:3px;"><font  style="font-size:10px">#datarespuestas.PRtexto#</font></td>
								</cfif>
							</tr>							
						</cfif>
					</table>
				</td>
			<cfif LvarPPorientacion eq 0 >
                </tr>
            </cfif>
		</cfloop>
		<tr><td width="1%" >&nbsp;</td>
         <cfif LvarPPorientacion eq 1 >
            </tr>
         </cfif>

	<cfelseif data.PPtipo eq 'M'>
		 <cfif LvarPPorientacion eq 1 >
            <tr>
        </cfif>	
		<cfset porcentaje = 1000 /cantidad>	
        <cfloop query="datarespuestas">	
			<cfif isdefined('Lvar_PCUid') and len(trim(Lvar_PCUid))>
				<cfset contestada = traerValorRespuesta(Lvar_PCUid, LvarPCid, pregunta, datarespuestas.PRid, rsevaluando.Usucodigo, LvarUsucodigoeval, 'PRid') >
				<!--- PCUid:<cfdump var="#Lvar_PCUid#"><br>
				PCid:<cfdump var="#LvarPCid#"><br>
				PPid<cfdump var="#pregunta#"><br>
				PRid:<cfdump var="#datarespuestas.PRid#"><br>
				Usucodigo:<cfdump var="#rsevaluando.Usucodigo#"><br>
				Usucodigoeval:<cfdump var="#LvarUsucodigoeval#"><br>
				R/<cfdump var="#contestada#"><br> --->
			</cfif>	
			 <cfif LvarPPorientacion eq 0 >
                <tr>
            </cfif>
				<td width="1%"   style="padding-left:5px; ">&nbsp;</td>
				<td colspan="2" align="right"  valign="bottom">
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
									<td valign="top" width="#porcentaje#" style="padding-left:3px;"><font  style="font-size:10px">#datarespuestas.PRtexto#</font></td>
								</cfif>
							</tr>						
							<tr>
								<td width="1%" valign="top">
									<cfif len(trim(datarespuestas.PRvalor))>
										<input  style="border:0; margin:0; font-size:10px;" 
											id="CHK_#empleado#_#pregunta#"
											type="checkbox" <cfif isdefined('contestada') and datarespuestas.PRid eq contestada >checked</cfif> 
											name="CHK_#empleado#_#pregunta#" 
											value="#datarespuestas.PRid#" 
											>
									</cfif>
								</td>
							</tr>
						<cfelse>
							<tr>
								<td width="1%" valign="top">
									<cfif len(trim(datarespuestas.PRvalor))>
										<input  style="border:0; margin:0; font-size:10px;" 
											id="CHK_#empleado#_#pregunta#"
											type="checkbox" <cfif isdefined('contestada') and datarespuestas.PRid eq contestada >checked</cfif> 
											name="CHK_#empleado#_#pregunta#" 
											value="#datarespuestas.PRid#" 
											>
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
									<td width="99%" style="padding-left:3px;"><font  style="font-size:10px">#datarespuestas.PRtexto#</font></td>
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
		<cfif isdefined('Lvar_PCUid') and len(trim(Lvar_PCUid))>
			<cfset contestada = traerValorpregunta(Lvar_PCUid, LvarPCid, pregunta, rsevaluando.Usucodigo, LvarUsucodigoeval) >
			<!--- PCUid:<cfdump var="#Lvar_PCUid#"><br>
			PCid:<cfdump var="#LvarPCid#"><br>
			PPid<cfdump var="#pregunta#"><br>
			PRid:<cfdump var="#datarespuestas.PRid#"><br>
			Usucodigo:<cfdump var="#rsevaluando.Usucodigo#"><br>
			Usucodigoeval:<cfdump var="#LvarUsucodigoeval#"><br>			
			R/<cfdump var="#contestada#"><br>
			 --->		
 		</cfif>
		<tr>
			<td width="1%" style="padding-left:5px; ">&nbsp;</td>
			<td colspan="2"  ><textarea name="p_#empleado#_#pregunta#" style="font-size:10px;" cols="80" rows="5"><cfif isdefined('contestada') and len(trim(contestada))>#contestada#</cfif></textarea></td>
		</tr>
	<cfelseif data.PPtipo eq 'V'>
		
		<cfif datarespuestas.recordcount gt 0 >
			<cfif ArrayLen(valores)>
				<cfloop query="datarespuestas">
					<cfif isdefined('Lvar_PCUid') and len(trim(Lvar_PCUid))>
						<cfset contestada = traerValorRespuesta(Lvar_PCUid, LvarPCid, pregunta, datarespuestas.PRid, rsevaluando.Usucodigo, LvarUsucodigoeval, 'PRvalorresp') >
						<!--- PCUid:<cfdump var="#Lvar_PCUid#"><br>
						PCid:<cfdump var="#LvarPCid#"><br>
						PPid<cfdump var="#pregunta#"><br>
						PRid:<cfdump var="#datarespuestas.PRid#"><br>
						Usucodigo:<cfdump var="#rsevaluando.Usucodigo#"><br>
						Usucodigoeval:<cfdump var="#LvarUsucodigoeval#"><br>
						R/<cfdump var="#contestada#"><br> --->
						
						<cfloop from="1" to="#ArrayLen(valores)#" index="j">
							<cfif contestada eq valores[j] >

							</cfif>
						</cfloop>	
					</cfif>
					<tr>
						<td width="1%"   style="padding-left:5px; ">&nbsp;</td>
						<td width="1%">
							<select name="p_#empleado#_#pregunta#_#datarespuestas.PRid#"  style="font-size:10px">
								<option value=""></option>
								<cfloop from="1" to="#ArrayLen(valores)#" index="i">
									<option value="#i#" <cfif isdefined('contestada') and trim(contestada) eq trim(valores[i]) >selected</cfif>>#valores[i]#</option>
								</cfloop>
							</select>

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
					<cfif isdefined('Lvar_PCUid') and len(trim(Lvar_PCUid))>
						

						<cfset contestada = traerValorpregunta(Lvar_PCUid, LvarPCid, pregunta, rsevaluando.Usucodigo, LvarUsucodigoeval ) >
						<!--- PCUid:<cfdump var="#Lvar_PCUid#"><br>
						PCid:<cfdump var="#LvarPCid#"><br>
						PPid<cfdump var="#pregunta#"><br>
						PRid:<cfdump var="#datarespuestas.PRid#"><br>
						Usucodigo:<cfdump var="#rsevaluando.Usucodigo#"><br>
						Usucodigoeval:<cfdump var="#LvarUsucodigoeval#"><br>						
						R/<cfdump var="#contestada#"><br> --->
					</cfif>
		
					<tr>
						<td  nowrap align="left">#datarespuestas.PRtexto#</td>
						<td width="1%"   style="padding-left:5px; ">&nbsp;</td>
						<td ><input type="text" size="30" style="font-size:10px"  maxlength="30" value="<cfif isdefined('contestada') and  len(trim(contestada))>#contestada#</cfif>" name="p_#empleado#_#pregunta#_#datarespuestas.PRid#"  ></td>

					</tr>
				</cfloop>
			
			</cfif>
		<cfelse>
			<cfif isdefined('Lvar_PCUid') and len(trim(Lvar_PCUid))>
								
				<cfset contestada = traerValorpregunta(Lvar_PCUid, LvarPCid, pregunta, rsevaluando.Usucodigo, LvarUsucodigoeval ) >
				<!--- <cfdump var="#Lvar_PCUid#"><br>
				<cfdump var="#LvarPCid#"><br>
				<cfdump var="#pregunta#"><br>
				<cfdump var="#datarespuestas.PRid#"><br>
				<cfdump var="#rsevaluando.Usucodigo#"><br>
				<cfdump var="#LvarUsucodigoeval#"><br>
				R/<cfdump var="#contestada#"><br> --->
			</cfif>

			<tr>
				<td width="1%"   style="padding-left:5px; ">&nbsp;</td>
				<td colspan="2" ><input type="text" style="font-size:10px" size="7" maxlength="7" value="<cfif isdefined('contestada') and  len(trim(contestada))>#contestada#</cfif>" name="p_#empleado#_#pregunta#" ></td>

			</tr>
		</cfif>
		<tr><td width="1%" >&nbsp;</td></tr>
	<cfelseif data.PPtipo eq 'O'>

		<cfloop query="datarespuestas">
			<cfif isdefined('Lvar_PCUid') and len(trim(Lvar_PCUid))>
							
				<cfset contestada = traerValorRespuesta(Lvar_PCUid, LvarPCid, pregunta, datarespuestas.PRid, rsevaluando.Usucodigo, LvarUsucodigoeval, 'PRvalorresp') >
				<!--- <cfdump var="#Lvar_PCUid#"><br>
				<cfdump var="#LvarPCid#"><br>
				<cfdump var="#pregunta#"><br>
				<cfdump var="#datarespuestas.PRid#"><br>
				<cfdump var="#rsevaluando.Usucodigo#"><br>
				<cfdump var="#LvarUsucodigoeval#"><br>	
				R/<cfdump var="#contestada#"><br> --->
				<cfloop from="1" to="#ArrayLen(valores)#" index="j">
					<cfif contestada eq valores[j] >

					</cfif>
				</cfloop>	
			</cfif>


			<tr>
				<td width="1%"   style="padding-left:5px; ">&nbsp;</td>
				<td width="1%">
					<select name="p_#empleado#_#pregunta#_#datarespuestas.PRid#" id="p_#empleado#_#datarespuestas.PPid#_#datarespuestas.PRid#" style="font-size:10px">
						<option value=""></option>
						<cfloop from="1" to="#ArrayLen(valores)#" index="i">
							<option value="#i#" <cfif isdefined('contestada') and contestada eq valores[i] >selected</cfif> >#valores[i]#</option>
						</cfloop>
					</select>

				</td>
				<td width="99%" style="padding-left:3px;"><font size="2">#datarespuestas.PRtexto#</font></td>
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
	Key="MSG_preguntasSiDeseaContestarOtrapreguntaElimineAlgunaDeLaspreguntasQueYaRespondio"
	Default="preguntas.\nSi desea contestar otra pregunta, elimine alguna de las preguntas que ya respondió"
	returnvariable="MSG_preguntasSiDeseaContestarOtrapreguntaElimineAlgunaDeLaspreguntasQueYaRespondio"/>	
	
