<cfinvoke component="sif.Componentes.Translate"
method="Translate"
key="BTN_Filtrar"
xmlfile="/rh/generales.xml"	
Default="Filtrar"
returnvariable="BTN_Filtrar"/>

<cfinvoke component="sif.Componentes.Translate"
method="Translate"
key="LB_RegistrodePartidos"
xmlfile="/rh/generales.xml"	
Default="RegistrodePartidos"
returnvariable="LB_RegistrodePartidos"/>

<cfinvoke component="sif.Componentes.Translate"
method="Translate"
key="LB_Equipo1"
xmlfile="/rh/generales.xml"	
Default="Equipo 1"
returnvariable="LB_Equipo1"/>

<cfinvoke component="sif.Componentes.Translate"
method="Translate"
key="LB_Equipo2"
xmlfile="/rh/generales.xml"	
Default="Equipo 2"
returnvariable="LB_Equipo2"/>

<cfinvoke component="sif.Componentes.Translate"
method="Translate"
key="LB_Fecha"
xmlfile="/rh/generales.xml"	
Default="Fecha"
returnvariable="LB_Fecha"/>
	
<cfinvoke component="sif.Componentes.Translate"
method="Translate"
key="BTN_Nuevo"
xmlfile="/rh/generales.xml"	
Default="Nuevo"
returnvariable="BTN_Nuevo"/>	
	<cf_templateheader title="#LB_RegistrodePartidos#">
	
	<link href="/cfmx/asp/css/asp.css" type="text/css" rel="stylesheet">		
	<cfoutput>  							
<cfset filtro = " ">
		<cfif isdefined("form.fEDPfecha") and len(trim(form.fEDPfecha)) gt 0 >
		<cfset filtro = filtro & " and EDPfecha like '(form.fEDPfecha)' " >
		</cfif>
		<cfif isdefined("form.Equipo1") and len(trim(form.Equipo1)) gt 0 >
		<cfset filtro = filtro & " and upper{fn concat({fn concat({fn concat(TEdescripcion, '-')}, Edescripcion)}) like '%" & #UCase(Form.fEquipo1)# & "%'">
		</cfif>
		<cfif isdefined("form.Equipo2") and len(trim(form.Equipo2)) gt 0 >
		<cfset filtro = filtro & " and upper{fn concat({fn concat({fn concat(TEdescripcion, '-')}, Edescripcion)}) like '%" & #UCase(Form.fEquipo2)# & "%'">
		</cfif>
	<cf_web_portlet_start titulo="#LB_RegistrodePartidos#">
	<table width="100%"  border="0" cellspacing="0" cellpadding="0">
	  
	  
	  <tr>
		<td colspan="2">&nbsp;</td>
	  </tr>
	  <tr>
		
		<td style="padding-left: 5px; padding-right: 5px;" valign="top">

			<form name="filtroCuentas" method="post" action="registropartidos-lista.cfm">
			
			<input type="hidden" name="modo" value="ALTA">
				<table width="100%" border="0" cellpadding="2" cellspacing="0" class="areaFiltro">
				  <tr> 
			<td width="28%" height="17" class="fileLabel"><cfoutput>#LB_Fecha#</cfoutput></td>
			<td width="27%" class="fileLabel"><cfoutput>#LB_Equipo1#</cfoutput></td>
			<td width="27%" class="fileLabel"><cfoutput>#LB_Equipo2#</cfoutput></td>
			<td width="7%" colspan="2" rowspan="2"><input name="btnFiltrar" class="btnFiltrar" type="submit" id="btnFiltrar" value="<cfoutput>#BTN_Filtrar#</cfoutput>"></td>
				  </tr>
				<tr> 
				<td><input name="fEDPfecha" type="text" id="fEDPfecha" size="40" maxlength="60"value="<cfif isdefined('form.fEDPfecha')><cfoutput>#form.fEDPfecha#</cfoutput></cfif>"></td>
				<td><input name="fEquipo1" type="text" id="fEquipo1" size="40" maxlength="60" value="<cfif isdefined('form.fEquipo1')><cfoutput>#form.fEquipo1#</cfoutput></cfif>"></td>
				<td><input name="fEquipo2" type="text" id="fEquipo2" size="40" maxlength="60" value="<cfif isdefined('form.fEquipo2')><cfoutput>#form.fEquipo2#</cfoutput></cfif>"></td>
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
				select {fn concat({fn concat(e1.Edescripcion, '-')}, de1.TEdescripcion)}  as Equipo1, {fn concat({fn 					                concat(e2.Edescripcion, '-')}, de2.TEdescripcion)} as Equipo2, edp.EDPfecha, edp.EDPrid, edp.EDvid, edp.EDPequipo2
				from EDPartidos edp

				inner join EquipoDivision ed1
					inner join DivisionEquipo de1
					on de1.TEid=ed1.TEid
					inner join Equipo e1
					on e1.EDid=ed1.EDid
				on ed1.EDvid=edp.EDvid

				inner join EquipoDivision ed2	
					inner join DivisionEquipo de2
					on de2.TEid=ed2.TEid
					inner join Equipo e2
					on e2.EDid=ed2.EDid
				on ed2.EDvid=edp.EDPequipo2 
				#PreserveSingleQuotes(filtro)#
					order by EDPfecha 					
			</cfquery>			
	
								<cfinvoke 
											component="rh.Componentes.pListas"
								 			method=	"pListaQuery"
								 			returnvariable="pListaRet">
								 			<cfinvokeargument name="query" value="#rsLista#"/>
											<cfinvokeargument name="desplegar" value="EDPfecha, Equipo1, Equipo2"/>
											<cfinvokeargument name="etiquetas" value="#LB_Fecha#,#LB_Equipo1#,#LB_Equipo2#"/>
											<cfinvokeargument name="formatos" value="D,V,V"/>
											<cfinvokeargument name="align" value="left,left,left"/>
											<cfinvokeargument name="filtrar_automatico" value="true"/>
											<cfinvokeargument name="ajustar" value="N"/>
											<cfinvokeargument name="checkboxes" value="N"/>
											<cfinvokeargument name="irA" value="registropartidos.cfm"/>
											<cfinvokeargument name="keys" value="EDPrid"/>
											<cfinvokeargument name="EmptyListMsg" value="true"/>
											</cfinvoke>
												</td>
		
												</tr>
												<tr>
												<td align="center">
	 <form name="formNuevoEmplLista" method="post" action="registropartidos.cfm">
													<input type="hidden" name="modo" value="NUEVO">
													<input name="btnNuevoLista" class="btnNuevo" type="submit" value="<cfoutput>#BTN_Nuevo#</cfoutput>">
												</form>
												</td>
												</tr>
												</table>
						
	</cfoutput> 
	</table><cf_web_portlet_end> 
<cf_templatefooter>