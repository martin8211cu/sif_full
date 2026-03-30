	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		Key="LB_RecursosHumanos"
		Default="Recursos Humanos"
		XmlFile="/rh/generales.xml"
		returnvariable="LB_RecursosHumanos"/>
	<cf_templateheader title="#LB_RecursosHumanos#" template="#session.sitio.template#">
		<cf_web_portlet_start titulo="Consulta de Plazas Presupuestarias " border="true" skin="#Session.Preferences.Skin#">
			<cfinclude template="/rh/portlets/pNavegacion.cfm">			

			<cfif isdefined('url.RHPPid') and not isdefined('form.RHPPid')>
				<cfset form.RHPPid = url.RHPPid>
			</cfif>

				<cfquery name="rsPlazas" datasource="#Session.DSN#">
					select 
						a.RHPPcodigo,pp.RHPcodigo,pp.RHPdescpuesto
						, a.RHPPdescripcion,b.RHCid,z.RHCcodigo,z.RHCdescripcion
						,convert(varchar,b.RHLTPfhasta,103) as RHLTPfhasta
						,sum(c.Monto) as sumaDetalles
						,p.CFid
						,f.CFdescripcion
						,f.CFcodigo
					from RHPlazaPresupuestaria a
						inner join RHMaestroPuestoP m
						on m.RHMPPid=a.RHMPPid
						inner join RHLineaTiempoPlaza b
								inner join RHCategoria z
								on z.RHCid=b.RHCid
								inner join RHPlazas p
									inner join RHPuestos pp
									on pp.RHPcodigo=p.RHPpuesto
									and pp.Ecodigo=p.Ecodigo
									inner join CFuncional f
									on f.CFid=p.CFid
								on p.RHPid=b.RHPid
							on b.RHPPid = a.RHPPid
								and b.Ecodigo=a.Ecodigo
						inner join RHCLTPlaza c
							on c.RHLTPid=b.RHLTPid
								and c.Ecodigo=b.Ecodigo							
					where a.Ecodigo  = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
						and a.RHPPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHPPid#">
					group by a.RHPPcodigo,a.RHPPdescripcion,RHLTPfhasta,p.CFid,CFdescripcion,CFcodigo,pp.RHPcodigo,pp.RHPdescpuesto,b.RHCid,z.RHCcodigo,z.RHCdescripcion
			<!---	select 
					a.RHPPcodigo
					, a.RHPPdescripcion				
					,convert(varchar,b.RHLTPfhasta,103) as RHLTPfhasta
					,sum(c.Monto) as sumaDetalles
					,p.CFid
					,f.CFdescripcion
					,f.CFcodigo
				from RHPlazaPresupuestaria a
					inner join RHLineaTiempoPlaza b
							inner join RHPlazas p
								inner join CFuncional f
								on f.CFid=p.CFid
							on p.RHPid=b.RHPid
						on b.RHPPid = a.RHPPid
							and b.Ecodigo=a.Ecodigo

					inner join RHCLTPlaza c
						on c.RHLTPid=b.RHLTPid
							and c.Ecodigo=b.Ecodigo
							
				where a.Ecodigo  = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
					and a.RHPPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHPPid#">

				group by a.RHPPcodigo,a.RHPPdescripcion,RHLTPfhasta,p.CFid,CFdescripcion,CFcodigo--->
				</cfquery>
			<cfset codPlazaPresup = "">								
			<cfset descPlazaPresup = "">	
			<cfset numFila = 1>
			<cfif isdefined('url.PageNum_lista') and url.PageNum_lista NEQ ''>
				<cfset numFila = url.PageNum_lista>
			</cfif>

			<!--- Query para manejar resultados--->
			<cfset rsResultado = QueryNew("sumaDetalles,RHLTPfhasta")>
			
			<cfif isdefined('rsPlazas') and rsPlazas.recordCount GT 0>
				<cfif numFila GT 1>
					<cfset regIni = ((5 * numFila) - 5 ) + 1>
				<cfelse>
					<cfset regIni = 1>				
				</cfif>

				<cfoutput query="rsPlazas" startrow="#regIni#" maxrows="5">
					<cfset codPlazaPresup = rsPlazas.RHPPcodigo>								
					<cfset descPlazaPresup = rsPlazas.RHPPdescripcion>
					<cfset centroFuncional = '#rsPlazas.CFcodigo#-#rsPlazas.CFdescripcion#'>
					<cfset puesto = '#rsPlazas.RHPcodigo#-#rsPlazas.RHPdescpuesto#'>
					<cfset categoria = '#rsPlazas.RHCcodigo#-#rsPlazas.RHCdescripcion#'>

					<cfset fila = QueryAddRow(rsResultado, 1)>
					<cfset tmp  = QuerySetCell(rsResultado, "sumaDetalles", rsPlazas.sumaDetalles) >
					<cfset tmp  = QuerySetCell(rsResultado, "RHLTPfhasta",  rsPlazas.RHLTPfhasta)>			
				</cfoutput>				
			</cfif>
						
			<table width="100%"  border="0" cellspacing="0" cellpadding="0">
			  <tr>
				<td colspan="2" align="center">
					<table width="70%"  border="0" cellspacing="0" cellpadding="0">
					  <tr><td>&nbsp;</td></tr>
					  <tr>
						<td>
							<cf_web_portlet_start titulo="Plaza Presupuestaria" border="true" skin="#Session.Preferences.Skin#">
								<table cellpadding="3" cellspacing="3">
									<tr>
										<td><strong>Código:</strong></td>
										<td>&nbsp;&nbsp;<cfoutput>#codPlazaPresup#</cfoutput></td>
									</tr>
									<tr>
										<td><strong>Descripción:</strong></td>
										<td>&nbsp;&nbsp;<cfoutput>#descPlazaPresup#</cfoutput></td>
									</tr>
									<tr>
										<td><strong>Centro Funcional:</strong></td>
											<cfif isdefined ('centroFuncional')><td>&nbsp;&nbsp;<cfoutput>#centroFuncional#</cfoutput></td></cfif>
									</tr>
									<tr>
										<td><strong>Puesto:</strong></td>
											<cfif isdefined ('puesto')><td>&nbsp;&nbsp;<cfoutput>#puesto#</cfoutput></td></cfif>
									</tr>
									<tr>
										<td><strong>Categoría:</strong></td>
											<cfif isdefined ('categoria')><td>&nbsp;&nbsp;<cfoutput>#categoria#</cfoutput></td></cfif>
									</tr>
								</table>
							<cf_web_portlet_end>						
						</td>
					  </tr>
					  <tr><td>&nbsp;</td></tr>
					</table>
				</td>
			  </tr>
			  <tr>
				<td valign="top">
					<cfoutput>
						<cfset navegacion = "RHPPid=#form.RHPPid#">
					</cfoutput>
					
					<cfinvoke 
						component="rh.Componentes.pListas" 
						method="pListaRH"
						returnvariable="rsLista"
						columnas="a.RHPPid,b.RHLTPid,RHLTPfdesde,RHLTPfhasta,sum(c.Monto) as sumaDetalles,'' as blanquito"
						desplegar="RHLTPfdesde,RHLTPfhasta,sumaDetalles,blanquito"
						etiquetas="Desde,Hasta,Total, "
						formatos="D,D,UM,U"
						align="left,left,right,left"	
						tabla="RHPlazaPresupuestaria a
							inner join RHLineaTiempoPlaza b
								on b.RHPPid = a.RHPPid
									and b.Ecodigo=a.Ecodigo
						
							inner join RHCLTPlaza c
								on c.RHLTPid=b.RHLTPid
									and c.Ecodigo=b.Ecodigo"
						filtro="a.Ecodigo=#Session.Ecodigo# and a.RHPPid=#form.RHPPid# 
									group by a.RHPPid,b.RHLTPid,RHLTPfdesde,RHLTPfhasta"
						keys="RHLTPid"
						funcion="goLista"
						fparams="RHLTPid"
						showLink="false"
						mostrar_filtro="false"
						filtrar_automatico="true"
						filtrar_por="RHLTPfdesde,RHLTPfhasta,1,''"
						ira="ConsultaPlazaPP.cfm"
						maxrows="5"
						navegacion="#navegacion#"
						showemptylistmsg="true"
					/>			
				</td>
				<td valign="top">
					<cfif isdefined('rsResultado')>
						<cfparam name="width" default="500">
						<cfparam name="height" default="125">	
					<cfchart  
						format="flash"
						chartWidth="#width#" 
						chartHeight="#height#"
						scaleFrom=0 
						scaleTo=10 
						gridLines=3 
						labelFormat="number"
						xAxisTitle="Fecha Hasta"
						yAxisTitle="Salario"
						show3D="no"
						yOffset="0.4"
						url="javascript: go('$ITEMLABEL$');">
						<cfchartseries 
							type="line" 
							query="rsResultado" 
							valueColumn="sumaDetalles" 
							itemColumn="RHLTPfhasta"/>
					</cfchart>
					</cfif>
				</td>
			  </tr>
			</table> 
			
			<script language="javascript" type="text/javascript">
				var popUpWin=0;
				function popUpWindow(URLStr, left, top, width, height) {
				  if(popUpWin) {
					if(!popUpWin.closed) popUpWin.close();
				  }
				  popUpWin = open(URLStr, 'popUpWin', 'toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbar=no,resizable=yes,copyhistory=yes,width='+width+',height='+height+',left='+left+', top='+top+',screenX='+left+',screenY='+top+'');
				}
				function go(fecha) {
					popUpWindow('grafico-componentes-PPP.cfm?RHLTPfdesde='+fecha+'&RHPPid='+<cfoutput>#form.RHPPid#</cfoutput>,250,200,650,500);
				}
				function goLista(item) {
					popUpWindow('grafico-componentes-PPP.cfm?RHLTPid='+item,250,200,650,500);
				}	
				function funcFiltrar(){
					document.lista.RHPPID.value="<cfoutput>#form.RHPPid#</cfoutput>";
					document.lista.submit();
				}
				
			</script>
		<cf_web_portlet_end>
	<cf_templatefooter>	