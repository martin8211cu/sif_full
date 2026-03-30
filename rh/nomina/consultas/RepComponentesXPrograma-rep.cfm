<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="BTN_GenerarArchivoDeTexto" Default="Generar archivo de texto" returnvariable="BTN_GenerarArchivoDeTexto"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_NoSeEncontraronRegistros" Default="No se encontraron registros" returnvariable="LB_NoSeEncontraronRegistros"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Detall_Componentes_XPrograma" Default="Componentes por Programa" returnvariable="LB_Detall_Componentes_XPrograma"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Monto" Default="MONTO" returnvariable="LB_Monto"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Componente" Default="COMPONENTE" returnvariable="LB_Componente"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Componentes" Default="COMPONENTES POR PRORAMA" returnvariable="LB_Componentes"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Totales" Default="TOTALES" returnvariable="LB_Totales"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Plazas" Default="PLAZAS" returnvariable="LB_Plazas"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_TCompl" Default="T.COMPLETOS" returnvariable="LB_TCompl"/>
<cfinvoke Key="LB_NoHayDatosRelacionados" Default="No hay datos relacionados" returnvariable="LB_NoHayDatosRelacionados" component="sif.Componentes.Translate" method="Translate"/>

<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Detall_Componentes_XPrograma" Default="Detalle de Componentes por Programa" returnvariable="LB_Detall_Componentes_XPrograma"/>

	<cf_templatecss>
	<link href="/cfmx/rh/css/rh.css" rel="stylesheet" type="text/css">
	
	 <cfsavecontent variable="Reporte">	
		<table width="95%" border="0" cellspacing="0" cellpadding="0" style="padding-left: 5px; padding-right: 5px;" align="center">
		 <cfif rsCompxProg.RecordCount>		
		<cfoutput query="rsCompxProg" group="Odescripcion" > 		
		 <tr>	
			<td colspan="4" align="center">				 
			<table width="95%" cellspacing="0" cellpadding="0">
					
				<cf_EncReporte
				Titulo="#LB_Detall_Componentes_XPrograma#" 
				Color="##E3EDEF" 		
				filtro1="#Odescripcion#"			
				>		
			</td>	
		  </tr>		  		 
		  <tr><td>&nbsp;</td></tr>					 		
		  <tr><td nowrap class="tituloListas" align="center" colspan="4">#Odescripcion#</td> </tr>	 
		 <tr>				 			 	
			<td align="right"><strong>#LB_Componente#</strong></td> 
			<td align="center"><strong>#LB_Monto#</strong></td> 					
		</tr>
		<cfset totalXProg=0 > 															
				<cfoutput  group="CScodigo" >  						
					<tr>						
						<td align="right">#CSdescripcion#</td>
						<td width="30%" align="right">#LSNumberFormat(Monto, '999,999,999.99')#</td>
					</tr>	
					<cfset totalXProg= totalXProg + Monto > 
				</cfoutput>		
				<tr><td align="center"><strong>#LB_Totales#</strong></td> </tr>
						
				<cfquery name="cantPlazas" datasource="#session.DSN#">
					select  count(DISTINCT  f.RHPid) as cantidad
						   ,(sum(LT.LTporcplaza/100 ) + coalesce(sum(RLT.LTporcplaza/100),0)) as tiemposCompl 
					
					from RHEscenarios a
					
					inner join RHFormulacion b
						on b.RHEid = a.RHEid
						and  b.Ecodigo = a.Ecodigo
					
					inner join RHCFormulacion c
						on c.RHFid = b.RHFid
						and c.Ecodigo = b.Ecodigo
					
					inner join ComponentesSalariales d
						on d.CSid = c.CSid
						and d.Ecodigo = c.Ecodigo
					
					inner join RHPlazaPresupuestaria e
						on e.RHPPid = b.RHPPid
						and e.Ecodigo = d.Ecodigo
					
					inner join RHPlazas f
						on f.RHPPid = e.RHPPid
						and f.Ecodigo = e.Ecodigo
						
					inner join LineaTiempo LT
						on LT.RHPid = f.RHPid
						and getdate() between LT.LTdesde and LT.LThasta		
					
					left outer join LineaTiempoR RLT
						on RLT.RHPid = f.RHPid
						and getdate() between RLT.LTdesde and RLT.LThasta		
						
					inner join CFuncional g
						on g.CFid = f.CFid
						and g.Ecodigo = f.Ecodigo
												
					inner join Oficinas ofic
						on ofic.Ocodigo = g.Ocodigo
						and ofic.Ecodigo = a.Ecodigo
						
					<cfif isdefined ('form.Ocodigo') and len(trim(form.Ocodigo))>	
						and ofic.Ocodigo = #form.Ocodigo# 
					</cfif>
					
					where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">	
					<cfif isdefined('form.RHEid')>											     								
						and a.RHEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHEid#">
					</cfif> 	
						
					group by ofic.Odescripcion					
						
				</cfquery>		
				
				<tr><td><strong>#LB_Plazas#:&nbsp;#cantPlazas.cantidad#&nbsp;&nbsp;&nbsp;&nbsp;#LB_TCompl#:&nbsp;&nbsp;#cantPlazas.tiemposCompl#</strong></td>					
				<td align="right"><strong>#LB_Monto#:&nbsp;#LSNumberFormat(totalXProg, '999,999,999.99')#</strong></td></tr>				
						
				</cfoutput>	
			<cfelse>
			<table width="792" align="center" border="0" cellspacing="0" cellpadding="2">
			<cfoutput>
				<tr><td align="center"class="titulo_empresa2"><strong>-------------#LB_NoHayDatosRelacionados#-------------</strong></td></tr>
			</cfoutput>
			</table>				
		  </cfif>
	  	</table>				
	</cfsavecontent>
	
	<cfoutput>	    
	<cfset LvarFileName = "ComponentesXPrograma#Session.Usucodigo#-#DateFormat(Now(),'yyyymmdd')#-#TimeFormat(Now(),'hhmmss')#.xls">
		<cf_htmlReportsHeaders 
			title="#LB_Detall_Componentes_XPrograma#" 
			filename="#LvarFileName#"
			irA="RepComponentesXPrograma-filtro.cfm"
			back="no"
			back2="yes" 
			>	
		  <cf_templatecss>	
		 #Reporte#
 	</cfoutput>

