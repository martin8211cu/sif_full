<cfsetting enablecfoutputonly="yes">
<cfswitch expression="#url.xRHTsubcomportam#">
		<cfcase value="1">
			<cfswitch expression="#url.xTipoRiesgo#">
					<cfcase value="1,2,3">
						<cfswitch expression="#url.xConsecuencia#">
								<cfcase value="0,1,5">
									<cfquery datasource="sifcontrol" name="rsControlIncapacidad">
										select *
										from RHIcontrolincapacidad
											where RHIcodigo in (0)
									</cfquery>
								</cfcase>
								<cfcase value="2,3,4,6,7,9">
									<cfquery datasource="sifcontrol" name="rsControlIncapacidad">
										select *
										from RHIcontrolincapacidad
											where RHIcodigo in (5,6)
									</cfquery>
								</cfcase>
						</cfswitch>
					</cfcase>
			</cfswitch>
		</cfcase>
		<cfcase value="2"><!--- ENFERMEDAD GENERAL --->
			<cfswitch expression="#url.xTipoRiesgo#">
				<cfcase value="0">
					<cfswitch expression="#url.xConsecuencia#">
						<cfcase value="0">
							<cfquery datasource="sifcontrol" name="rsControlIncapacidad">
								select *
								from RHIcontrolincapacidad
									where RHIcodigo in (1,2,3,4)
							</cfquery>
						</cfcase>
					</cfswitch>
				</cfcase>
			</cfswitch>
		</cfcase>
		<cfcase value="3"><!--- INCAPACIDAD POR MATERNIDAD --->
			<cfswitch expression="#url.xTipoRiesgo#">
				<cfcase value="6,7,8">
					<cfswitch expression="0">
						<cfcase value="0">
							<cfquery datasource="sifcontrol" name="rsControlIncapacidad">
								select *
								from RHIcontrolincapacidad
									where RHIcodigo =0
							</cfquery>
						</cfcase>
					</cfswitch>
				</cfcase>
			</cfswitch>
		</cfcase>
</cfswitch>

<cfoutput>
	<select name="ControlIncapacidad" id="ControlIncapacidad" >
		<cfif isdefined('rsControlIncapacidad') and rsControlIncapacidad.recordcount gt 0>
			<cfloop query="rsControlIncapacidad">
				<option value="#rsControlIncapacidad.RHIcodigo#">#HtmlEditFormat(rsControlIncapacidad.RHIdescripcion)#</option>
			</cfloop>
		<!---<cfelse>
			<cfif isdefined ('rsControlIncapacidad') and rsControlIncapacidad.recordcount gt 0>
				<cfloop query="rsconcepto">
					<option value="#rsControlIncapacidad.RHIcodigo#"selected="selected">#rsControlIncapacidad.RHIdescripcion#
					</option>
				</cfloop>
			<cfelseif isdefined ('rsControlIncapacidad') and rsControlIncapacidad.recordcount gt 0>
					<cfloop query="rsconcepto">
						<option value="#rsControlIncapacidad.RHIcodigo#"selected="selected">#rsControlIncapacidad.RHIdescripcion#
						</option>
					</cfloop>
			</cfif>--->
		</cfif>
	</select>
</cfoutput>



