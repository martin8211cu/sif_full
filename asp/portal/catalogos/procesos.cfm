<cfif isDefined("url.SScodigo")>
	<cfset form.SScodigo = url.SScodigo></cfif>
<cfif isDefined("url.fSScodigo")>
	<cfset form.fSScodigo = url.fSScodigo></cfif>
<cfif isDefined("url.SMcodigo")>
	<cfset form.SMcodigo = url.SMcodigo></cfif>
<cfif isDefined("url.fSMcodigo")>
	<cfset form.fSMcodigo = url.fSMcodigo></cfif>
<cfif isDefined("url.SPcodigo")>
	<cfset form.SPcodigo = url.SPcodigo></cfif>
<cf_templateheader title="Mantenimiento de Procesos">
	<cf_web_portlet_start titulo="Mantenimiento de Procesos">
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
		<cfquery name="rsMenues" datasource="asp">
			select SScodigo, SMcodigo, SMNcodigo, <!---replicate(' ', SMNnivel*2) || SMNtitulo --->SMNtitulo
			from SMenues
			where SPcodigo is null
			order by SScodigo, SMcodigo, SMNpath, SMNorden
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
				<cfif isdefined("url.fSScodigo") and not isdefined("form.fSScodigo")>
					<cfparam name="form.fSScodigo" default="#url.fSScodigo#">
				</cfif>
				<cfif isdefined("url.fSMcodigo") and not isdefined("form.fSMcodigo")>
					<cfparam name="form.fSMcodigo" default="#url.fSMcodigo#">
				</cfif>
				<cfif isdefined("url.fProceso") and not isdefined("form.fProceso")>
					<cfparam name="form.fProceso" default="#url.fProceso#">
				</cfif>

				<form style="margin:0; " name="filtro" method="post">
				<table width="100%" cellpadding="0" cellspacing="0" border="0" class="areaFiltro">
					<tr>
						<td width="10%"><b>Sistema:</b></td>
						<td width="9%">&nbsp;</td>
						<td width="10%">&nbsp;</td>
						<td width="10%"><b>M&oacute;dulo:</b></td>
						<td width="11%" align="left">&nbsp;</td>
						<td width="10%">&nbsp;</td>
						<td width="10%"><b>Proceso:</b></td>
						<td width="21%">&nbsp;
						</td>

						<td width="9%" align="center"><input type="submit" value="Filtrar" name="Filtrar"></td>

					</tr>
					<tr>
					  <td><select name="fSScodigo" onChange="javascript:change_sistema(this, document.filtro);">
                        <option value="">Todos</option>
                        <cfloop query="rsSistemas">
                          <option value="#rsSistemas.SScodigo#" <cfif isdefined("form.fSScodigo") and trim(form.fSScodigo) eq trim(rsSistemas.SScodigo)>selected</cfif> >#rsSistemas.SScodigo#</option>
                        </cfloop>
                      </select></td>
					  <td><img src="edit.gif" alt="Editar sistema" width="19" height="17" border="0" onClick="location.href='sistemas.cfm?SScodigo='+escape(filtro.fSScodigo.value)"></td>
					  <td>&nbsp;</td>
					  <td><select name="fSMcodigo" >
                        <option value="">Todos</option>
                      </select></td>
					  <td align="left"><img src="edit.gif" alt="Editar mdulo" width="19" height="17" border="0" onClick="location.href='modulos.cfm?SScodigo='+escape(filtro.fSScodigo.value)+'&fSScodigo='+escape(filtro.fSScodigo.value)+'&SMcodigo='+escape(filtro.fSMcodigo.value)"></td>
					  <td>&nbsp;</td>
					  <td><input type="text" name="fProceso" size="20" maxlength="100" onFocus="this.select();" value="<cfif isdefined("form.fProceso")>#form.fProceso#</cfif>"></td>
					  <td>&nbsp;</td>
					  <td align="center">&nbsp;</td>
				  </tr>
				</table>
				</form>
				</cfoutput>

				<cfset filtro = '' >
				<cfset additionalCols = ''>
				<cfset navegacion = ''>

				<cfif isdefined("form.fSScodigo") and len(trim(form.fSSCodigo)) gt 0>
					<cfset filtro = " and a.SScodigo = '#form.fSScodigo#' ">
					<cfset additionalCols = ", '#form.fSScodigo#' as fSScodigo ">
					<cfset navegacion = Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "fSScodigo=" & form.fSScodigo>
				</cfif>

				<cfif isdefined("form.fSMcodigo") and len(trim(form.fSMCodigo)) gt 0>
					<cfset filtro = filtro & " and a.SMcodigo = '#form.fSMcodigo#' ">
					<cfset additionalCols = additionalCols & ", '#form.fSMcodigo#' as fSMcodigo ">
					<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "fSMcodigo=" & form.fSMcodigo>
				</cfif>

				<cfif isdefined("form.fProceso") and len(trim(form.fProceso)) gt 0>
					<cfset filtro = filtro & " and ( upper(a.SPcodigo) like '%#trim(Ucase(form.fProceso))#%' ">
					<cfset filtro = filtro & " or upper(a.SPdescripcion) like '%#trim(Ucase(form.fProceso))#%' ) " >
					<cfset additionalCols = additionalCols & ", '#form.fProceso#' as fProceso ">
					<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "fProceso=" & form.fProceso >
				</cfif>

				<cfinvoke 
				 component="commons.Componentes.pListas"
				 method="pListaRH"
				 returnvariable="pListaRet">
					<cfinvokeargument name="tabla" value="SProcesos a, SSistemas b, SModulos c"/>
					<cfinvokeargument name="columnas" value="a.SScodigo, a.SMcodigo, {fn concat({fn concat(rtrim(a.SScodigo), ' - ')}, b.SSdescripcion)} as SSdescripcion, c.SMdescripcion, a.SPcodigo, a.SPorden, a.SPdescripcion, {fn concat(case when SPinterno=1 then 'I' else null end  ,{fn concat(case when SPmenu=1 then 'M' 	else null end ,{fn concat(case when SPanonimo=1 then 'A' else null end ,case when SPpublico=1 	then 'P'else null end)})})}  opcionesbit #additionalCols#"/>
					<cfinvokeargument name="desplegar" value="SMdescripcion, SPorden, opcionesbit, SPcodigo, SPdescripcion"/>
					<cfinvokeargument name="etiquetas" value="Mdulo, Ord, Opc, Cdigo, Proceso"/>
					<cfinvokeargument name="formatos" value=""/>
					<cfinvokeargument name="filtro" value="a.SScodigo=b.SScodigo and a.SScodigo=c.SScodigo and a.SMcodigo=c.SMcodigo #filtro# order by b.SSorden, b.SSdescripcion, a.SScodigo, c.SMorden, c.SMdescripcion, a.SMcodigo, a.SPorden, a.SPcodigo, a.SPdescripcion"/>
					<cfinvokeargument name="align" value=" left, right, left, left, left"/>
					<cfinvokeargument name="ajustar" value="N"/>
					<cfinvokeargument name="irA" value="procesos.cfm"/>
					<cfinvokeargument name="maxRows" value="80"/>
					<cfinvokeargument name="keys" value="SScodigo,SMcodigo,SPcodigo"/>
					<cfinvokeargument name="conexion" value="asp"/>
					<cfinvokeargument name="Cortes" value="SSdescripcion"/>
					<cfinvokeargument name="navegacion" value="#navegacion#"/>
					<cfinvokeargument name="showEmptyListMsg" value="#true#"/>
					<cfinvokeargument name="debug" value="N"/>
				</cfinvoke>
			</td>
			<td valign="top" align="center" nowrap>
				<cfinclude template="procesos-form.cfm">
			</td>
		  </tr>
		</table>
		
		<!--- ============================================== --->
		<!---    ESTE JS LOS USA EL FORM Y EL FILTRO         --->
		<!--- ============================================== --->
		
		<script language="javascript1.2" type="text/javascript">
			function change_sistema(obj, form){
				if (form.name == 'form1'){
					combo = form.SMcodigo;
				}
				else{
					combo = form.fSMcodigo;
				}

				combo.length = 0;
		
				var cont = 0;

				if (form.name != 'form1'){
					combo.length = cont+1;
					combo.options[cont].value = '';
					combo.options[cont].text = 'Todos';	
					cont = 1;
				}
				
				<cfloop query="rsModulos">
				if ( obj.value == '<cfoutput>#rsModulos.SScodigo#</cfoutput>' ) {
					combo.length = cont+1;
					combo.options[cont].value = '<cfoutput>#rsModulos.SMcodigo#</cfoutput>';
					combo.options[cont].text = '<cfoutput>#rsModulos.SMdescripcion#</cfoutput>';	
					
					if (form.name == 'form1'){
						<cfif modo neq 'ALTA' and rsModulos.SMcodigo eq form.SMcodigo >
							combo.options[cont].selected = true;
						<cfelseif isdefined("form.fSMcodigo") and #trim(rsModulos.SMcodigo)# eq #trim(form.fSMcodigo)# >
							combo.options[cont].selected = true;
						</cfif>
					} else {
						<cfif isdefined("form.fSMcodigo") and #trim(rsModulos.SMcodigo)# eq #trim(form.fSMcodigo)# >
							combo.options[cont].selected = true;
						</cfif>
					}
					cont = cont + 1;
				}
				</cfloop>
			}

			<cfif modo eq 'ALTA'>
			function change_modulo(form) {
				var SScodigo = form.SScodigo.value;
				var SMcodigo = form.SMcodigo.value;
				var combo = form.SMNcodigo;
				combo.length = 1;
				var cont = 1;
				<cfoutput query="rsMenues">
					if ( SScodigo == '#JSStringFormat(rsMenues.SScodigo)#' && SMcodigo == '#JSStringFormat(rsMenues.SMcodigo)#' ) {						combo.length = cont+1;
						combo.options[cont  ].value = '#JSStringFormat(rsMenues.SMNcodigo)#';
						combo.options[cont++].text  = '#JSStringFormat(rsMenues.SMNtitulo)#';
					}
				</cfoutput>
			}
			</cfif>
			// sistemas/modulos del mantenimiento
			<cfif modo eq 'ALTA'>
				change_sistema(document.form1.SScodigo, document.form1);
			</cfif>

			// sistemas/modulos del filtro
			change_sistema(document.filtro.fSScodigo, document.filtro)
		</script>
		<!--- ============================================== --->
	<cf_web_portlet_end>
<cf_templatefooter>