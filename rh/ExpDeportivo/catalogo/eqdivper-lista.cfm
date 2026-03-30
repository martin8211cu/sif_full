<cfinvoke component="sif.Componentes.Translate"
method="Translate"
key="BTN_Filtrar"
xmlfile="/rh/generales.xml"	
Default="Filtrar"
returnvariable="BTN_Filtrar"/>

<cfinvoke component="sif.Componentes.Translate"
method="Translate"
key="LB_Equipo"
xmlfile="/rh/generales.xml"	
Default="Equipo"
returnvariable="LB_Equipo"/>

<cfinvoke component="sif.Componentes.Translate"
method="Translate"
key="LB_Persona"
xmlfile="/rh/generales.xml"	
Default="Persona"
returnvariable="LB_Persona"/>

<cfinvoke component="sif.Componentes.Translate"
method="Translate"
Key="LB_Equipo"
Default="Equipo"
returnvariable="LB_Equipo"/>

<cfinvoke component="sif.Componentes.Translate"
method="Translate"
Key="LB_Division"
Default="Divisi&oacute;n"
returnvariable="LB_Division"/>	
	
<cfinvoke component="sif.Componentes.Translate"
method="Translate"
key="BTN_Nuevo"
xmlfile="/rh/generales.xml"	
Default="Nuevo"
returnvariable="BTN_Nuevo"/>	
	<cf_templateheader title="#LB_Equipo#">
	<cfoutput> 
	<link href="/cfmx/asp/css/asp.css" type="text/css" rel="stylesheet">
	<script language="javascript" type="text/javascript">
		function funcCancelar3() {
			showList(false);
		}
	</script>
	
								
	<cfset filtro = " ">
		<cfif isdefined("form.fEdescripcion") and len(trim(form.fEdescripcion)) gt 0 >
		<cfset filtro = filtro & " and upper(Edescripcion) like '%#ucase(form.fEdescripcion)#%' " >
		</cfif>
		<cfif isdefined("form.fTEdescripcion") and len(trim(form.fTEdescripcion)) gt 0 >
		<cfset filtro = filtro & " and upper(fTEdescripcion) like '%#ucase(form.fTEdescripcion)#%' " >
		</cfif>
		<cfif isdefined("form.fDEnombre") and len(trim(form.fDEnombre)) gt 0 >
		<cfset filtro = filtro & " and upper({fn concat({fn concat({fn concat({fn concat(DEapellido1, ' ')}, DEapellido2)}, ' ')}, 		 DEnombre) }) like '%" & #UCase(Form.fDEnombre)# & "%'">
		</cfif> 
	<cf_web_portlet_start titulo="#LB_Equipo#">
	<table width="100%"  border="0" cellspacing="0" cellpadding="0">
	  
	  
	  <tr>
		<td colspan="2">&nbsp;</td>
	  </tr>
	  <tr>
		
		<td style="padding-left: 5px; padding-right: 5px;" valign="top">

			<form name="filtroCuentas" method="post" action="eqdivper-lista.cfm">
			
			<input type="hidden" name="modo" value="ALTA">
				<table width="100%" border="0" cellpadding="2" cellspacing="0" class="areaFiltro">
				  <tr> 
			<td width="28%" height="17" class="fileLabel"><cfoutput>#LB_Equipo#</cfoutput></td>
			<td width="27%" class="fileLabel"><cfoutput>#LB_Division#</cfoutput></td>
			<td width="38%" class="fileLabel"><cfoutput>#LB_Persona#</cfoutput></td>
			<td width="7%" colspan="2" rowspan="2"><input name="btnFiltrar" class="btnFiltrar" type="submit" id="btnFiltrar" value="<cfoutput>#BTN_Filtrar#</cfoutput>"></td>
				  </tr>
				<tr> 
				<td><input name="fEdescripcion" type="text" id="fEdescripcion" size="40" maxlength="60"value="<cfif isdefined('form.fEdescripcion')><cfoutput>#form.fEdescripcion#</cfoutput></cfif>"></td>
				<td><input name="fTEdescripcion" type="text" id="fTEdescripcion" size="40" maxlength="60" value="<cfif isdefined('form.fTEdescripcion')><cfoutput>#form.fTEdescripcion#</cfoutput></cfif>"></td>
				<td><input name="fDEnombre" type="text" id="fDEnombre" size="40" maxlength="60" value="<cfif isdefined('form.fDEnombre')><cfoutput>#form.fDEnombre#</cfoutput></cfif>"></td>
											</tr>
	 </table>
				
			</form>
		</td>
  	</tr>
	<tr style="display: ;" id="verLista"> 
          				  		<td> 
									<table width="100%" border="0" cellspacing="0" cellpadding="0">
								  		<tr>
											<td>
			<cfquery name="rsLista" datasource="#session.DSN#">
									select a.EDPid, b.Edescripcion, c.TEdescripcion,{fn concat({fn concat({fn concat({fn concat(d.DEapellido1, ' ')}, d.DEapellido2)}, ', ')}, d.DEnombre) } as nombreEmpl, e.EDvid
									from EquipoDivPersona a
									inner join EquipoDivision e on
									a.EDvid = e.EDvid
									inner join DivisionEquipo c on
									e.TEid = c.TEid
									inner join Equipo b on
									e.EDid = b.EDid
									inner join EDPersonas d on
									a.DEid = d.DEid
									where 1=1
									#PreserveSingleQuotes(filtro)#
									order by Edescripcion
								
	  </cfquery>	
	
								<cfinvoke 
											component="rh.Componentes.pListas"
								 			method=	"pListaQuery"
								 			returnvariable="pListaRet">
								 			<cfinvokeargument name="query" value="#rsLista#"/>
											<cfinvokeargument name="desplegar" value="Edescripcion, TEdescripcion, nombreEmpl"/>
											<cfinvokeargument name="etiquetas" value="#LB_Equipo#,#LB_Division#, #LB_Persona#"/>
											<cfinvokeargument name="formatos" value="V,V,V"/>
											<cfinvokeargument name="align" value="left,left, left"/>
											<cfinvokeargument name="filtrar_automatico" value="true"/>
											<cfinvokeargument name="ajustar" value="N"/>
											<cfinvokeargument name="checkboxes" value="N"/>
											<cfinvokeargument name="irA" value="eqdivper.cfm"/>
											<cfinvokeargument name="keys" value="EDPid"/>
											<cfinvokeargument name="EmptyListMsg" value="true"/>
											</cfinvoke>
												</td>
												</tr>
												<tr>
												<td align="center">
	 <form name="formNuevoEmplLista" method="post" action="eqdivper.cfm">
													<input type="hidden" name="modo" value="NUEVO">
													<input name="btnNuevoLista" class="btnNuevo" type="submit" value="<cfoutput>#BTN_Nuevo#</cfoutput>">
												</form>
												</td>
												</tr>
												</table>
						
	</cfoutput> 
	</table><cf_web_portlet_end> 
<cf_templatefooter>