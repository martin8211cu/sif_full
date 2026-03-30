<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="BTN_GenerarArchivoDeTexto" Default="Generar archivo de texto" returnvariable="BTN_GenerarArchivoDeTexto"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_NoSeEncontraronRegistros" Default="No se encontraron registros" returnvariable="LB_NoSeEncontraronRegistros"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_RepPresupXCentroCostos" Default="Reporte de Presupuesto asignado por Centro de Costo " returnvariable="LB_RepPresupXCentroCostos"/>

<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_CodProg" Default="Programa " returnvariable="LB_CodProg"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_DescUnidad" Default="Descripci&oacute;n" returnvariable="LB_DescUnidad"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_BaseSal" Default="Base Salarial" returnvariable="LB_BaseSal"/>

  <cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_RecursosHumanos"
	Default="Recursos Humanos"
	XmlFile="/rh/generales.xml"
	returnvariable="LB_RecursosHumanos"/>		
	<!---<cf_templateheader title="#LB_RecursosHumanos#" template="#session.sitio.template#">		
	<cf_web_portlet_start titulo="#LB_REsum_RelacionPuestos#">--->

	<cf_templatecss>
	<link href="/cfmx/rh/css/rh.css" rel="stylesheet" type="text/css">
		
	 <cfsavecontent variable="Reporte">	
		<table width="85%" border="0" cellspacing="0" cellpadding="0" style="padding-left: 5px; padding-right: 5px;" align="center">		
		 <tr>	
			<td colspan="8" align="center">				 
			<table width="97%" cellspacing="0" cellpadding="0">					
				<cf_EncReporte
				Titulo="#LB_RepPresupXCentroCostos#" 
				Color="##E3EDEF" 								
				>		
			</td>	
		  </tr>
		  <cfoutput>
		
		  <tr class="tituloListas">		  		 
				<td ><strong>#LB_CodProg#</strong></td>
				<td ><strong>#LB_DescUnidad#</strong></td>			
				<td ><strong>#LB_BaseSal#</strong></td>	
								
				<cfquery name="rsColumnas" datasource="#session.DSN#">
					select RHCRPTid,RHCRPTcodigo,RHCRPTdescripcion, RHRPTNcodigo
					from RHReportesNomina a
						inner join RHColumnasReporte b
							on b.RHRPTNid = a.RHRPTNid 
					where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
					and a.RHRPTNcodigo = 'REPRE'
				</cfquery>	
							
				<cfloop query="rsColumnas">
					<td ><strong>#RHCRPTdescripcion#</strong></td>				
				</cfloop>
							
		   </tr>
		   <tr><td>&nbsp;</td></tr>			
		  
		   
		   <cfloop query="rsCCostoOfic" >
		    <tr><td>#rsCCostoOfic.Oficodigo#</td>
				<td>#rsCCostoOfic.CFdescripcion #</td>	
		   
				<cfquery name="rsSalarioBase" datasource="#session.DSN#">
					select CSid 
					from ComponentesSalariales compSal
					where CSsalariobase  = 1
					and Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
				</cfquery>						
				<cfif rsSalarioBase.RecordCount ><cfset Lvar_CSid = ValueList(rsSalarioBase.CSid)></cfif>
			   
			  <cfquery name="rsSalBase" dbtype="query">
				   select monto
				   from rsPresupXCentroCosto
				   where CSid = (<cfqueryparam cfsqltype="cf_sql_numeric" value="#Lvar_CSid#" list="yes">)
				   and CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsCCostoOfic.CFid#" > 
				   and Oficodigo =  <cfqueryparam cfsqltype="cf_sql_varchar" value= "#rtrim(rsCCostoOfic.Oficodigo)#">
			   </cfquery>			   			 			 
		       <td>#rsSalBase.monto#</td>							   			  
			   
			  
			    <cfquery name="rsAntiguedad" datasource="#session.DSN#" >
					select  CSid
					from ComponentesSalariales compSal
					where compSal.CIid in (select distinct a.CIid
											from RHReportesNomina c
											inner join RHColumnasReporte b
											inner join RHConceptosColumna a
													on a.RHCRPTid = b.RHCRPTid
													on b.RHRPTNid = c.RHRPTNid
													and b.RHCRPTcodigo = 'ANTDAD' 
											where c.RHRPTNcodigo =  'REPRE'
											and c.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">)
					and compSal.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">						
				 </cfquery>			
				 		 
				 <cfset montoAntig = 0>
				<cfif rsAntiguedad.RecordCount >				 
				 	<cfset Lvar_CSid2 = ValueList(rsAntiguedad.CSid)>								  			  			  	
					<cfquery name="rsAntiguedad" dbtype="query">
					   select monto 
					   from rsPresupXCentroCosto
					   where CSid = (<cfqueryparam cfsqltype="cf_sql_numeric" value="#Lvar_CSid2#" list="yes">)
					   and CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsCCostoOfic.CFid#" > 
					   and Oficodigo =  <cfqueryparam cfsqltype="cf_sql_varchar" value= "#rtrim(rsCCostoOfic.Oficodigo)#">
				   </cfquery>
			     <cfset montoAntig= #rsAntiguedad.monto# >
			  </cfif>		
			   						   
			  <cfif isdefined('rsAntiguedad.monto') and rsAntiguedad.monto gt 0> <td align="right">#rsAntiguedad.monto#</td><cfelse><td align="right">0.00</td></cfif>
			   
			   <!--- Sexenio --->
			    <cfquery name="rsSEXNIO" datasource="#session.DSN#" >
					select  CSid
					from ComponentesSalariales compSal
					where compSal.CIid in (select distinct a.CIid
											from RHReportesNomina c
											inner join RHColumnasReporte b
											inner join RHConceptosColumna a
													on a.RHCRPTid = b.RHCRPTid
													on b.RHRPTNid = c.RHRPTNid
													and b.RHCRPTcodigo = 'SEXNIO' 
											where c.RHRPTNcodigo =  'REPRE'
											and c.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">)
					and compSal.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">						
				 </cfquery>	
				 <cfif rsSEXNIO.RecordCount NEQ 0>				 				 
				 <cfset Lvar_CSid3 = ValueList(rsSEXNIO.CSid)>				
				
				  <cfquery name="rsMontoSEXNIO" dbtype="query">
				   select monto 
				   from rsPresupXCentroCosto
				   where CSid = (<cfqueryparam cfsqltype="cf_sql_numeric" value="#Lvar_CSid3#" list="yes">)
				   and CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsCCostoOfic.CFid#" > 
				   and Oficodigo =  <cfqueryparam cfsqltype="cf_sql_varchar" value= "#rtrim(rsCCostoOfic.Oficodigo)#">
			   </cfquery>	
			   </cfif>			   			   
			    <cfif isdefined('rsMontoSEXNIO.monto') and rsMontoSEXNIO.monto gt 0> <td align="right">#rsMontoSEXNIO.monto#</td><cfelse><td align="right">0.00</td></cfif>
			  
			  
			   <!--- Dedicación exclusiva --->
			    <cfquery name="rsDedicExclu" datasource="#session.DSN#" >
					select  CSid
					from ComponentesSalariales compSal
					where compSal.CIid in (select distinct a.CIid
											from RHReportesNomina c
											inner join RHColumnasReporte b
											inner join RHConceptosColumna a
													on a.RHCRPTid = b.RHCRPTid
													on b.RHRPTNid = c.RHRPTNid
													and b.RHCRPTcodigo = 'DEDICEXCL' 
											where c.RHRPTNcodigo =  'REPRE'
											and c.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">)
					and compSal.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">						
				 </cfquery>	
				 
				 <cfif rsDedicExclu.RecordCount NEQ 0>				 				 
				 <cfset Lvar_CSid4 = ValueList(rsDedicExclu.CSid)>				
				
				  <cfquery name="rsMontoDedicExclu" dbtype="query">
				   select monto 
				   from rsPresupXCentroCosto
				   where CSid = (<cfqueryparam cfsqltype="cf_sql_numeric" value="#Lvar_CSid4#" list="yes">)
				   and CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsCCostoOfic.CFid#" > 
				   and Oficodigo =  <cfqueryparam cfsqltype="cf_sql_varchar" value= "#rtrim(rsCCostoOfic.Oficodigo)#">
			   </cfquery>	
			   </cfif>			   			   
		        <cfif isdefined('rsMontoDedicExclu.monto') and rsMontoDedicExclu.monto gt 0> <td align="right">#rsMontoDedicExclu.monto#</td><cfelse><td align="right">0.00</td>                </cfif>
			
			 <!--- Prohibición  --->
			    <cfquery name="rsProhibicion" datasource="#session.DSN#" >
					select  CSid
					from ComponentesSalariales compSal
					where compSal.CIid in (select distinct a.CIid
											from RHReportesNomina c
											inner join RHColumnasReporte b
											inner join RHConceptosColumna a
													on a.RHCRPTid = b.RHCRPTid
													on b.RHRPTNid = c.RHRPTNid
													and b.RHCRPTcodigo = 'PROHB' 
											where c.RHRPTNcodigo =  'REPRE'
											and c.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">)
					and compSal.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">						
				 </cfquery>	
				 
				 <cfif rsProhibicion.RecordCount NEQ 0>				 				 
				 <cfset Lvar_CSid5 = ValueList(rsProhibicion.CSid)>				
				
				  <cfquery name="rsMontoProhibicion" dbtype="query">
				   select monto 
				   from rsPresupXCentroCosto
				   where CSid = (<cfqueryparam cfsqltype="cf_sql_numeric" value="#Lvar_CSid5#" list="yes">)
				   and CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsCCostoOfic.CFid#" > 
				   and Oficodigo =  <cfqueryparam cfsqltype="cf_sql_varchar" value= "#rtrim(rsCCostoOfic.Oficodigo)#">
			   </cfquery>	
			   </cfif>			   			   
		        <cfif isdefined('rsMontoProhibicion.monto') and rsMontoProhibicion.monto gt 0> <td align="right">#rsMontoProhibicion.monto#</td><cfelse><td align="right">0.00</td>                </cfif>
			   			   
			    <!--- Otros Incentivos --->
			    <cfquery name="rsOtrosIncen" datasource="#session.DSN#" >
					select  CSid
					from ComponentesSalariales compSal
					where compSal.CIid in (select distinct a.CIid
											from RHReportesNomina c
											inner join RHColumnasReporte b
											inner join RHConceptosColumna a
													on a.RHCRPTid = b.RHCRPTid
													on b.RHRPTNid = c.RHRPTNid
													and b.RHCRPTcodigo = 'OTROSINCENT' 
											where c.RHRPTNcodigo =  'REPRE'
											and c.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">)
					and compSal.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">						
				 </cfquery>	
				 
				 <cfif rsOtrosIncen.RecordCount NEQ 0>				 				 
				 <cfset Lvar_CSid6 = ValueList(rsOtrosIncen.CSid)>				
				
				  <cfquery name="rsMontoOtrosIncen" dbtype="query">
				   select monto 
				   from rsPresupXCentroCosto
				   where CSid = (<cfqueryparam cfsqltype="cf_sql_numeric" value="#Lvar_CSid6#" list="yes">)
				   and CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsCCostoOfic.CFid#" > 
				   and Oficodigo =  <cfqueryparam cfsqltype="cf_sql_varchar" value= "#rtrim(rsCCostoOfic.Oficodigo)#">
			   </cfquery>	
			   </cfif>			   			   
		        <cfif isdefined('rsMontoOtrosIncen.monto') and rsMontoOtrosIncen.monto gt 0> <td align="right">#rsMontoOtrosIncen.monto#</td><cfelse><td align="right">0.00</td>                </cfif>
			   
			   
			</tr>						   
		    </cfloop>
		   <tr>
		   
		   </tr>		   
		</cfoutput>	
	  	</table>				
	</cfsavecontent>
	
	<cfoutput>	    
	<cfset LvarFileName = "ReportePresupuestoporCentroCosto#Session.Usucodigo#-#DateFormat(Now(),'yyyymmdd')#-#TimeFormat(Now(),'hhmmss')#.xls">
	
	<cf_htmlReportsHeaders 
			title="#LB_RepPresupXCentroCostos#" 
			filename="#LvarFileName#"
			irA="RepPresupXCentroCosto-filtro.cfm"
			back="no"
			back2="yes" 
			>	
    	<cf_templatecss>
		 #Reporte#
		 
 	</cfoutput>
<!---<cf_web_portlet_end>
<cf_templatefooter>	
--->