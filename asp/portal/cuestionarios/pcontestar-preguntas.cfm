<table width="100%" border="0" cellpadding="1" cellspacing="0">
<cfoutput>

	<cfquery name="datarespuestas" datasource="#session.DSN#">
		select pr.PPid, 
			   pr.PCid, 
			   pp.PPtipo, 
			   pp.PPrespuesta, 
			   pp.PPparte,
			   pp.PPtipo,
			   pr.PRid, 
			   pr.PRtexto,
			   pcp.PCPmaxpreguntas, 
			   pr.PRvalor,
			   pr.PRimagen
		from PortalCuestionario pc
		
		inner join PortalCuestionarioParte pcp
		on pc.PCid=pcp.PCid
		
		inner join PortalPregunta pp
		on pc.PCid=pp.PCid

		left outer join PortalRespuesta pr
		on pp.PPid=pr.PPid

		where pr.PCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarPCid#">
		  and pr.PPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#pregunta#">
		  and pp.PPtipo != 'E'
		  order by pr.PRorden
	</cfquery>
	
	<cfif listcontains('V,O', data.PPtipo)>
		<cfset valores = listtoarray(listsort(data.PPrespuesta,'text')) >
	</cfif>

	<cfif data.PPtipo eq 'U' >
		<cfloop query="datarespuestas">
			<cfif isdefined('form.PCUid') and len(trim(form.PCUid))>
				<cfset contestada = traerValorRespuesta(form.PCUid, LvarPCid, pregunta, datarespuestas.PRid, LvarUsucodigo, LvarUsucodigoeval, 'PRid') >
			</cfif>
			<tr>
				<td width="1%"  style="padding-left:5px; ">&nbsp;</td>
				<td colspan="2">
					<table width="100%" cellpadding="0" cellspacing="0">
						<tr>
							<td align="1%" ><cfif len(trim(datarespuestas.PRvalor))><input style="border:0;" onClick="javascript:validar_maximo_preguntas(#LvarPCid#, #data.PPparte#,'#data.PPtipo#',#data.PCPmaxpreguntas#, this);" type="radio" <cfif isdefined('contestada') and datarespuestas.PRid eq contestada >checked</cfif> name="p_#pregunta#" value="#datarespuestas.PRid#"></cfif></td>
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
								<img src="/cfmx/sif/rh/evaluaciondes/operacion/logo_respuesta.cfm?PRid=#datarespuestas.PRid#&ts=#tsurl#" border="0">
								</td>
							<cfelse>
								<td width="99%" style="padding-left:3px;"><font size="2">#datarespuestas.PRvalor# #datarespuestas.PRtexto# XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXx</font></td>
							</cfif>

						</tr>
					</table>
				</td>
			</tr>
		</cfloop>
		<tr><td width="1%" >&nbsp;</td></tr>
	<cfelseif data.PPtipo eq 'M'>
		<cfloop query="datarespuestas">	
			<cfif isdefined('form.PCUid') and len(trim(form.PCUid))>
				<cfset contestada = traerValorRespuesta(form.PCUid, LvarPCid, pregunta, datarespuestas.PRid, LvarUsucodigo, LvarUsucodigoeval, 'PRid') >
			</cfif>	
			<tr>
				<td width="1%"   style="padding-left:5px; ">&nbsp;</td>
				<td colspan="2" align="right">
					<table width="100%" border="0" cellpadding="0" cellspacing="0" align="right">
						<tr>
							<td width="1%" valign="top"><input style="border:0; margin:0;" onClick="javascript:validar_maximo_preguntas(#LvarPCid#, #data.PPparte#,'#data.PPtipo#',#data.PCPmaxpreguntas#, this);" type="checkbox" <cfif isdefined('contestada') and datarespuestas.PRid eq contestada >checked</cfif> name="p_#pregunta#_#datarespuestas.PRid#" value="#datarespuestas.PRid#"></td>
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
								<img src="/cfmx/sif/rh/evaluaciondes/operacion/logo_respuesta.cfm?PRid=#datarespuestas.PRid#&ts=#tsurl#" border="0">
								</td>
							<cfelse>
								<td width="99%" style="padding-left:3px;"><font size="2">#datarespuestas.PRtexto#</font></td>
							</cfif>

						</tr>
					</table>
				</td>
			</tr>
		</cfloop>
		<tr><td>&nbsp;</td></tr>
	<cfelseif data.PPtipo eq 'D'>
		<cfif isdefined('form.PCUid') and len(trim(form.PCUid))>
			<cfset contestada = traerValorPregunta(form.PCUid, LvarPCid, pregunta, LvarUsucodigo, LvarUsucodigoeval) >
		</cfif>
		<tr>
			<td width="1%" style="padding-left:5px; ">&nbsp;</td>
			<td colspan="2"  ><textarea name="p_#pregunta#" onBlur="javascript:validar_maximo_preguntas(#LvarPCid#, #data.PPparte#,'#data.PPtipo#',#data.PCPmaxpreguntas#, this);" cols="80" rows="5"><cfif isdefined('contestada') and len(trim(contestada))>#contestada#</cfif></textarea></td>
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
						<td width="1%">
							<select name="p_#pregunta#_#datarespuestas.PRid#" onChange="javascript:validar_maximo_preguntas(#LvarPCid#, #data.PPparte#,'#data.PPtipo#',#data.PCPmaxpreguntas#, this);">
								<option value=""></option>
								<cfloop from="1" to="#ArrayLen(valores)#" index="i">
									<option value="#i#" <cfif isdefined('contestada') and contestada eq valores[i] >selected</cfif>>#valores[i]#</option>
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
								<img src="/cfmx/sif/rh/evaluaciondes/operacion/logo_respuesta.cfm?PRid=#datarespuestas.PRid#&ts=#tsurl#" border="0">
							</td>
						<cfelse>
							<td width="99%" style="padding-left:3px;"><font size="2">#datarespuestas.PRtexto#</font></td>
						</cfif>
					</tr>
				</cfloop>
			<cfelse>
				<cfloop query="datarespuestas">
					<cfif isdefined('form.PCUid') and len(trim(form.PCUid))>
						<cfset contestada = traerValorPregunta(form.PCUid, LvarPCid, pregunta, LvarUsucodigo, LvarUsucodigoeval ) >
					</cfif>
		
					<tr>
						<td  nowrap align="left">#datarespuestas.PRtexto#</td>
						<td width="1%"   style="padding-left:5px; ">&nbsp;</td>
						<td ><input type="text" onblur="javascript:validar_maximo_preguntas(#LvarPCid#, #data.PPparte#,'#data.PPtipo#',#data.PCPmaxpreguntas#, this);" size="30" maxlength="30" value="<cfif isdefined('contestada') and  len(trim(contestada))>#contestada#</cfif>" name="p_#pregunta#_#datarespuestas.PRid#" ></td>
						
					</tr>
				</cfloop>
			
			</cfif>
		<cfelse>
			<cfif isdefined('form.PCUid') and len(trim(form.PCUid))>
				<cfset contestada = traerValorPregunta(form.PCUid, LvarPCid, pregunta, LvarUsucodigo, LvarUsucodigoeval ) >
			</cfif>

			<tr>
				<td width="1%"   style="padding-left:5px; ">&nbsp;</td>
				<td colspan="2" ><input type="text" onBlur="javascript:validar_maximo_preguntas(#LvarPCid#, #data.PPparte#,'#data.PPtipo#',#data.PCPmaxpreguntas#, this);" size="7" maxlength="7" value="<cfif isdefined('contestada') and  len(trim(contestada))>#contestada#</cfif>" name="p_#pregunta#" ></td>
			</tr>
		</cfif>
		<tr><td width="1%" >&nbsp;</td></tr>
	<cfelseif data.PPtipo eq 'O'>
		<script type="text/javascript" language="javascript1.2">
			var contenedor_#pregunta# = new Array();
		</script>
		<cfloop query="datarespuestas">
			<cfif isdefined('form.PCUid') and len(trim(form.PCUid))>
				<cfset contestada = traerValorRespuesta(form.PCUid, LvarPCid, pregunta, datarespuestas.PRid, LvarUsucodigo, LvarUsucodigoeval, 'PRvalorresp') >
			</cfif>

			<script type="text/javascript" language="javascript1.2">
				contenedor_#pregunta#[#datarespuestas.currentrow-1#] = new Array();
				contenedor_#pregunta#[#datarespuestas.currentrow-1#][0] = #datarespuestas.PRid#;
				contenedor_#pregunta#[#datarespuestas.currentrow-1#][1] = '';
			</script>

			<tr>
				<td width="1%"   style="padding-left:5px; ">&nbsp;</td>
				<td width="1%"  >
					<select name="p_#pregunta#_#datarespuestas.PRid#" id="p_#datarespuestas.PPid#_#datarespuestas.PRid#" onChange="javascript:validar_maximo_preguntas(#LvarPCid#, #data.PPparte#,'#data.PPtipo#',#data.PCPmaxpreguntas#, this);" >
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