<cf_templateheader title="Mantenimiento de Procesos por Grupo">
	<cf_web_portlet_start titulo="Mantenimiento de Procesos por Grupo">
		<cfinclude template="frame-header.cfm">

		<!--- ============================================== --->
		<!---    ESTOS QUERYS LOS USA EL FORM Y EL FILTRO    --->
		<!--- ============================================== --->
		<cfquery name="rsSistemas" datasource="asp">
			select SScodigo, SSdescripcion
			from SSistemas
			order by SSdescripcion
		</cfquery>
		
		<cfquery name="rsModulos" datasource="asp">
			select SScodigo, SMcodigo, SMdescripcion
			from SModulos
			order by SMdescripcion
		</cfquery>
		<!--- ============================================== --->

		<table width="100%"  border="0" cellspacing="0" cellpadding="0">
		  <tr><td colspan="2"><cfinclude template="/home/menu/pNavegacion.cfm"></td></tr>	
		  <tr>
		    <td valign="top" align="center">&nbsp;</td>
		    <td valign="top" align="center">&nbsp;</td>
	      </tr>
		  <tr>
			<td width="55%" valign="top" align="left" nowrap>
				<cfoutput>
				<cfif isdefined("url.SScodigo") and not isdefined("form.SScodigo")>
					<cfparam name="form.SScodigo" default="#url.SScodigo#">
				</cfif>
				<cfif isdefined("url.fSScodigo") and not isdefined("form.fSScodigo")>
					<cfparam name="form.fSScodigo" default="#url.fSScodigo#">
				</cfif>

				<cfif isdefined("url.SRcodigo") and not isdefined("form.SRcodigo")>
					<cfparam name="form.SRcodigo" default="#url.SRcodigo#">
				</cfif>
				<cfif isdefined("url.fSRcodigo") and not isdefined("form.fSRcodigo")>
					<cfparam name="form.fSRcodigo" default="#url.fSRcodigo#">
				</cfif>

				<cfif isdefined("url.fSMcodigo") and not isdefined("form.fSMcodigo")>
					<cfparam name="form.fSMcodigo" default="#url.fSMcodigo#">
				</cfif>

				<cfif isdefined("url.fProceso") and not isdefined("form.fProceso")>
					<cfparam name="form.fProceso" default="#url.fProceso#">
				</cfif>

				<form style="margin:0; " name="filtro" method="post" action="procesos-rol.cfm">
				<table width="100%" cellpadding="0" cellspacing="0" border="0" class="areaFiltro">
					<tr>
						<td><b>Sistema:</b></td>
						<td>
							<select name="fSScodigo" onChange="javascript:change_sistema(this, document.filtro);">
								<option value="">Todos</option>
								<cfloop query="rsSistemas">
									<option value="#rsSistemas.SScodigo#" <cfif isdefined("form.fSScodigo") and trim(form.fSScodigo) eq trim(rsSistemas.SScodigo)>selected</cfif> >#rsSistemas.SScodigo#</option>
								</cfloop>
							</select>
						</td>
						<td><b>M&oacute;dulo:</b></td>
						<td>
							<select name="fSMcodigo">
								<option value="">Todos</option>
							</select>
						</td>

						<td><b>Proceso:</b></td>
						<td>
							<input type="text" name="fProceso" size="20" maxlength="100" onFocus="this.select();" value="<cfif isdefined("form.fProceso")>#form.fProceso#</cfif>">
						</td>

						<td align="center">
							<input type="submit" value="Filtrar" name="Filtrar">
							<input type="hidden" value="#form.SRcodigo#" name="SRcodigo">
							<input type="hidden" value="#form.SScodigo#" name="SScodigo">
						</td>

					</tr>
				</table>
				</form>
				</cfoutput>

				<cfset filtro = '' >
				<cfset additionalCols = ''>
				<cfset navegacion = ''>

				<cfif isdefined("form.SScodigo")>
					<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "SScodigo=" & form.SScodigo>
				</cfif>

				<cfif isdefined("form.SRcodigo")>
					<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "SRcodigo=" & form.SRcodigo>
				</cfif>

				<cfif isdefined("form.fSScodigo") and len(trim(form.fSSCodigo)) gt 0>
					<cfset filtro = " and a.SScodigo = '#form.fSScodigo#' ">
					<cfset additionalCols = ", '#form.fSScodigo#' as fSScodigo ">
					<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "fSScodigo=" & form.fSScodigo>
				</cfif>

				<cfif isdefined("form.fSMcodigo") and len(trim(form.fSMCodigo)) gt 0>
					<cfset filtro = filtro & " and a.SMcodigo = '#form.fSMcodigo#' ">
					<cfset additionalCols = additionalCols & ", '#form.fSMcodigo#' as fSMcodigo ">
					<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "fSMcodigo=" & form.fSMcodigo>
				</cfif>

				<cfif isdefined("form.fProceso") and len(trim(form.fProceso)) gt 0>
					<cfset filtro = filtro & " and ( upper(a.SPcodigo) like '%#trim(Ucase(form.fProceso))#%' ">
					<cfset filtro = filtro & " or upper(b.SPdescripcion) like '%#trim(Ucase(form.fProceso))#%' ) " >
					<cfset additionalCols = additionalCols & ", '#form.fProceso#' as fProceso ">
					<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "fProceso=" & form.fProceso >

				</cfif>

				<cfinvoke 
				 component="commons.Componentes.pListas"
				 method="pListaRH"
				 returnvariable="pListaRet">
					<cfinvokeargument name="tabla" value="SProcesosRol a, SProcesos b, SSistemas c, SModulos d"/>
					<cfinvokeargument name="columnas" value="a.SScodigo, a.SMcodigo, a.SPcodigo, a.SRcodigo, SPdescripcion, SSdescripcion, SMdescripcion #additionalCols#"/>
					<cfinvokeargument name="desplegar" value="SMdescripcion, SPdescripcion"/>
					<cfinvokeargument name="etiquetas" value="Modulo, Proceso"/>
					<cfinvokeargument name="formatos" value=""/>
					<cfinvokeargument name="filtro" value="a.SRcodigo='#form.SRcodigo#' and a.SScodigo=b.SScodigo and a.SMcodigo=b.SMcodigo and a.SPcodigo=b.SPcodigo and a.SScodigo=c.SScodigo and b.SScodigo=c.SScodigo and a.SScodigo=d.SScodigo and a.SMcodigo=d.SMcodigo #filtro# order by c.SSorden, a.SScodigo, d.SMorden, d.SMcodigo, b.SPorden, a.SPcodigo, b.SPdescripcion"/>
					<cfinvokeargument name="align" value="left,left"/>
					<cfinvokeargument name="ajustar" value="N"/>
					<cfinvokeargument name="irA" value="procesos-rol.cfm"/>
					<cfinvokeargument name="maxRows" value="80"/>
					<cfinvokeargument name="keys" value="SScodigo,SRcodigo,SMcodigo,SPcodigo"/>
					<cfinvokeargument name="conexion" value="asp"/>
					<cfinvokeargument name="Cortes" value="SSdescripcion"/>
					<cfinvokeargument name="navegacion" value="#navegacion#"/>
					<cfinvokeargument name="showEmptyListMsg" value="#true#"/>
					<cfinvokeargument name="debug" value="true"/>
				</cfinvoke>
			</td>
			<td valign="top" align="center" nowrap>
				<cfinclude template="procesos-rol-form.cfm">
			</td>
		  </tr>
		</table>

		<!--- ============================================== --->
		<!---    ESTE JS LOS USA EL FORM Y EL FILTRO         --->
		<!--- ============================================== --->
		
		<script language="javascript1.2" type="text/javascript">
			function change_sistema(obj, form){
				var combo = form.fSMcodigo;
				var cont = 0;

				combo.length = 0;

				combo.length = cont+1;
				combo.options[cont].value = '';
				combo.options[cont].text = 'Todos';	
				cont = 1;

				<cfloop query="rsModulos">
					if ( obj.value == '<cfoutput>#rsModulos.SScodigo#</cfoutput>' ) {
						combo.length = cont+1;
						combo.options[cont].value = '<cfoutput>#rsModulos.SMcodigo#</cfoutput>';
						combo.options[cont].text = '<cfoutput>#rsModulos.SMdescripcion#</cfoutput>';	
					
						<cfif isdefined("form.fSMcodigo") and trim(rsModulos.SMcodigo) eq trim(form.fSMcodigo) >
							combo.options[cont].selected = true;
						</cfif>

						cont++
					}
				</cfloop>	
			}

			// sistemas/modulos del mantenimiento
			<cfif modo eq 'ALTA'>
				//change_sistema(document.form1.SScodigo, document.form1)
			</cfif>

			// sistemas/modulos del filtro
			change_sistema(document.filtro.fSScodigo, document.filtro)
		</script>
		

		
		<!--- ============================================== --->

	<cf_web_portlet_end>
<cf_templatefooter>
