
<cf_template template="#session.sitio.template#">
	<script  language="JavaScript" src="/cfmx/rh/js/DHTMLMenu/stm31.js"></script>
	<cf_templatearea name="title">
      Recursos Humanos
	</cf_templatearea>
	
	<cf_templatearea name="body">
	<cfif isDefined("Url.RHCconcurso") and not isDefined("form.RHCconcurso")>
		<cfset form.RHCconcurso = Url.RHCconcurso>
	</cfif>
<cfif isDefined("session.Ecodigo") and isDefined("Form.RHCconcurso") and len(trim(#Form.RHCconcurso#)) NEQ 0>
	<cfquery name="rsRHConcursos" datasource="#Session.DSN#" >
		Select distinct substring(RHCdescripcion,1,55) as RHCdescripcion 
        from RHConcursos
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		and RHCconcurso = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHCconcurso#" >		  
		order by RHCdescripcion asc
	</cfquery>
	<cfquery name="rsRHPlazasConcurso" datasource="#Session.DSN#" >
		Select a.RHPCid, a.RHPid, convert(varchar,a.RHPid)  + '-' + substring(b.RHPdescripcion,1,55) as RHPdescripcion 
			, a.Usucodigo 
		from RHPlazasConcurso a, RHPlazas b
		where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		  and RHCconcurso = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHCconcurso#" >
		  and a.Ecodigo = b.Ecodigo
		  and a.RHPid = b.RHPid
		order by RHPdescripcion asc
	</cfquery>

</cfif>
<script language="JavaScript" type="text/JavaScript">
<!--
	function limpiar(){
		document.filtro.fcedula.value = '';
		document.filtro.fNombre.value = '';
		document.filtro.fTipo.value = 'T';
		
		
	}
  function regresar() {
	document.form1.action='/cfmx/rh/Reclutamiento/operacion/listaRegistroEval.cfm';
	document.form1.submit();
}
//-->
</script>
 

            <cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Registro de Evaluaciones'>
				<form style="margin:0" name="form1" method="post">
					<table width="100%"  border="0" cellpadding="0" cellspacing="0" >
					  <tr> 
						<td colspan="2"><cfinclude template="/rh/portlets/pNavegacion.cfm"></td>
					  </tr>
					  <tr> 
						<td colspan="2" align="center">
							<strong style="font-family:'Times New Roman', Times, serif; font-size:15pt; font-variant:small-caps; font-weight:bolder; padding-left:20px">
								<cfoutput>#rsRHConcursos.RHCdescripcion#</cfoutput>
							</strong>
						</td>
					</tr>	 
					 <tr> 
						<td colspan="2" align="center">
							<font size="2">
								<strong style="font-family:'Times New Roman', Times, serif; font-size:15pt; font-variant:small-caps; font-weight:bolder; padding-left:20px">
									Registro de las Evaluaciones por Concursante
								</strong>
							</font>
						</td>
					</tr>	 
					<tr><td colspan="2">&nbsp;</td></tr>  
					<tr align="center"> 
					  <td align="center"  colspan="2"><strong>Plazas:</strong>
						<span class="subTitulo">
							<select name="RHPid"  onChange="document.form1.submit();">
							  <option value="T" <cfif isdefined("form.RHPid") and form.RHPid EQ 'T' >selected</cfif> >Todas las plazas</option>
							  <cfoutput query="rsRHPlazasConcurso">
								<option value="#rsRHPlazasConcurso.RHPid#" <cfif isdefined("form.RHPid") and form.RHPid EQ rsRHPlazasConcurso.RHPid >selected</cfif> >#rsRHPlazasConcurso.RHPdescripcion#</option>
							  </cfoutput>
							</select>
						</span>
					  </td>
					</tr> 
					<TR><td colspan="2">&nbsp;</td></TR>
				</table>
				<input name="RHCconcurso" type="hidden" value="<cfif isdefined("form.RHCconcurso")><cfoutput>#form.RHCconcurso#</cfoutput></cfif>">
			</form>
			<form style="margin:0" name="filtro" method="post">
			<table width="50%" cellpadding="2" cellspacing="0" class="areaFiltro" align="center">

				  <tr>
					  <td><strong>Identificaci&oacute;n:</strong></td>
					  <td><strong>Nombre:</strong></td>
					  <td><strong>Tipo</strong></td>
					  
				  </tr>
				<tr>
					<td><input name="fcedula" type="text" size="20" maxlength="20" onFocus="this.select();" value="<cfif isdefined("form.fcedula")><cfoutput>#form.fcedula#</cfoutput></cfif>"></td>
					<td><input name="fNombre" type="text" size="60" maxlength="60" onFocus="this.select();" value="<cfif isdefined("form.fNombre")><cfoutput>#form.fNombre#</cfoutput></cfif>"></td>
					<td><select name="fTipo" onChange="document.filtro.submit();">
					  <option value="T" <cfif isdefined("form.fTipo") and form.fTipo eq 'T'>selected</cfif> >Todos</option>
					  <option value="I" <cfif isdefined("form.fTipo") and form.fTipo eq 'I'>selected</cfif> >Internos</option>
					  <option value="G" <cfif isdefined("form.fTipo") and form.fTipo eq 'E'>selected</cfif> >Externos</option>
					</select>
					<input name="RHPid" type="hidden" value="<cfif isdefined("form.RHPid")><cfoutput>#form.RHPid#</cfoutput></cfif>">
					<input name="RHCconcurso" type="hidden" value="<cfif isdefined("form.RHCconcurso")><cfoutput>#form.RHCconcurso#</cfoutput></cfif>">
					</td>
				  </tr>
				  <tr>
					  <td colspan="3" align="center">
						  <input type="submit" name="btnFiltrar" value="Filtrar">
						  <input type="button" name="btnLimpiar" value="Limpiar" onClick="javascript:limpiar();">
  						  <input type="button" name="btnRegresar" value="Regresar" onClick="javascript:regresar();">
					  </td>
				  </tr>
				 </table>
	 			</form>
				<table width="50%" cellpadding="2" cellspacing="0" align="center"> 
				<tr>
					<td>
					<cfset filtro = "a.Ecodigo=#session.Ecodigo#  and c.RHCconcurso = #Form.RHCconcurso# and a.DEid = b.DEid  and b.RHCPid = c.RHPCid   and c.Ecodigo = d.Ecodigo and c.RHPid = d.RHPid">
					<cfif isdefined("form.RHPid") and len(trim(form.RHPid)) NEQ 0 and form.RHPid neq 'T'>
						<cfset filtro = filtro & " and c.RHPid  = #form.RHPid#">
					</cfif>
					<cfset navegacion = "">
					<cfif isdefined("form.RHPCid") and len(trim(form.RHPCid)) NEQ 0>
						<cfset filtro = filtro & " 	and b.RHPCid = #form.RHPCid# ">
					</cfif>
					<cfif isdefined("form.fTipo") and len(trim(form.fTipo)) gt 0 and form.fTipo NEQ 'T'>
						<cfset filtro = filtro & " and RHCPtipo = '#form.fTipo#' ">
						<cfset navegacion = navegacion & "&fTipo=#form.fTipo#">
					</cfif>
					<cfif isdefined("form.fcedula") and len(trim(form.fcedula)) gt 0>
						<cfset filtro = filtro & " and  DEidentificacion like '%" & trim(form.fcedula) & "%'">
						<cfset navegacion = navegacion & "&fcedula=#form.fcedula#">
					</cfif>
					<cfif isdefined("form.fNombre") and len(trim(form.fNombre)) gt 0>
						<cfset filtro = filtro & " and  upper(a.DEapellido1 + ' ' + a.DEapellido2 + ', ' + a.DEnombre) like '%" & Ucase(trim(form.fNombre)) & "%'">
						<cfset navegacion = navegacion & "&fNombre=#form.fNombre#">
					</cfif>
				  
					<cfset filtro = filtro & " order by PuestoDesc, NombreCompleto, DEidentificacion ">
					select a.DEid, a.DEidentificacion, 
							a.DEapellido1 + ' ' + a.DEapellido2 + ', ' + a.DEnombre as NombreCompleto,
							c.RHCconcurso, b.RHCPid, c.RHPid, rtrim(ltrim(d.RHPpuesto)) as RHPpuesto,  
							convert(varchar,c.RHPid) + ' - ' + substring(d.RHPdescripcion,1,55) as PuestoDesc 
					from RHConcursantes b, DatosEmpleado a, RHPlazasConcurso c, RHPlazas d
					where a.Ecodigo=#session.Ecodigo#  
					  and c.RHCconcurso = #Form.RHCconcurso# 
					  and a.DEid = b.DEid  
					  and b.RHCPid = c.RHPCid   
					  and c.Ecodigo = d.Ecodigo 
					  and c.RHPid = d.RHPid
					<cfinvoke 
						component="rh.Componentes.pListas"
						method="pListaRH"
						returnvariable="pListaDed">
							<cfinvokeargument name="tabla" value="RHConcursantes b, DatosEmpleado a, RHPlazasConcurso c, RHPlazas d"/>
							<cfinvokeargument name="columnas" value=" a.DEid, a.DEidentificacion, 
															a.DEapellido1 + ' ' + a.DEapellido2 + ', ' + a.DEnombre as NombreCompleto,
															c.RHCconcurso, b.RHCPid, c.RHPid, rtrim(ltrim(d.RHPpuesto)) as RHPpuesto,  convert(varchar,c.RHPid) + ' - ' + substring(d.RHPdescripcion,1,55) as PuestoDesc "/>
							<cfinvokeargument name="desplegar" value="DEidentificacion,NombreCompleto"/>
							<cfinvokeargument name="etiquetas" value="Identificación,Nombre Completo"/>
							<cfinvokeargument name="formatos" value="V, V"/>
						   <!---  <cfinvokeargument name="formName" value="Concurso"/>	 --->
							<cfinvokeargument name="filtro" value="#filtro#"/>
							<cfinvokeargument name="align" value="left,left"/>
							<cfinvokeargument name="ajustar" value="N"/>
							<cfinvokeargument name="debug" value="N"/>
							<cfinvokeargument name="irA" value="Evaluaciones.cfm"/>	
							<cfinvokeargument name="Cortes" value="PuestoDesc"/>		
<!--- 							    <cfinvokeargument name="navegacion" value="#navegacion#"/> --->
							<cfinvokeargument name="keys" value="RHCPid"/>
							
					</cfinvoke>		
					</td>
				</tr>
			</table>
         <cf_web_portlet_end>
				
	</cf_templatearea>
</cf_template>