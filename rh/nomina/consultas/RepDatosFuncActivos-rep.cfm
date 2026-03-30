<!--- VARIABLES DE TRADUCCION --->

<cfinvoke Key="LB_ReporteDatosFunc" Default="Reporte de datos de los funcionarios activos" returnvariable="LB_ReporteDatosFunc" component="sif.Componentes.Translate" method="Translate"/>

<cfinvoke Key="LB_NoHayDatosRelacionados" Default="No hay datos relacionados" returnvariable="LB_NoHayDatosRelacionados" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="LB_Fecha" Default="Fecha" returnvariable="LB_Fecha" component="sif.Componentes.Translate" method="Translate"/>
<!--- FIN VARIABLES DE TRADUCCION --->
<!---<cf_dump var="#url#">--->

<cfquery name="rsReporte" datasource="#Session.DSN#">				
		select  de.DEidentificacion
				,{fn concat({fn concat({fn concat({fn concat(de.DEnombre , ' ' )}, de.DEapellido1 )}, ' ' )}, de.DEapellido2 )} as empleado		
				 ,lt.Dcodigo
				 ,dpt.Dcodigo
				 ,dpt.Ddescripcion
			<cfif isdefined('url.TDid')>
				,TDeducc.TDcodigo 
				,TDeducc.TDdescripcion
			</cfif>
			<cfif isdefined ('url.CSid')>
				,CompSal.CScodigo
				,CompSal.CSdescripcion
			</cfif>			
			<cfif isdefined('url.RHPcodigo')>
				,puestos.RHPcodigo
				,puestos.RHPdescpuesto
			</cfif>
			<cfif isdefined('url.RHCid')>
				,CatPuesto.RHCcodigo
				,CatPuesto.RHCdescripcion
			</cfif>
			<cfif isdefined('url.Ocodigo')>
				,Ofic.Ocodigo
				,Ofic.Odescripcion
			</cfif>
			<cfif isdefined('url.DClinea')>
				,detallcarg.DCdescripcion
				,detallcarg.DCcodigo
			</cfif>
			<cfif isdefined('url.CIid')>
				,CInc.CIdescripcion
				,CInc.CIcodigo
			</cfif>
			
		from
			 LineaTiempo lt
			
			inner join DLineaTiempo DlineaT
				on DlineaT.LTid = lt.LTid		
		
			<cfif isdefined('url.Ocodigo')>
				 inner join  Oficinas Ofic
					on lt.Ocodigo = Ofic.Ocodigo
					and lt.Ecodigo = Ofic.Ecodigo
					and lt.Ocodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.Ocodigo#">
			</cfif>		
		
			inner join RHPuestos puestos
				on puestos.RHPcodigo = lt.RHPcodigo 
				and puestos.Ecodigo = lt.Ecodigo
				<cfif isdefined('url.RHPcodigo') >
					and puestos.RHPcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.RHPcodigo#" >
				</cfif>
		
		        <cfif isdefined('url.RHCid') >
				inner join RHCategoriasPuesto Categorias
						on Categorias.RHCPlinea = lt.RHCPlinea
						and Categorias.Ecodigo =  lt.Ecodigo
						
					inner join RHCategoria CatPuesto
							on CatPuesto.RHCid = Categorias.RHCid
							and CatPuesto.Ecodigo = Categorias.Ecodigo 
							and  CatPuesto.RHCid =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.RHCid#" >
				</cfif>			
		
			<cfif isdefined ('url.CSid')>
				inner join  ComponentesSalariales CompSal
					on   CompSal.CSid = DlineaT.CSid
					and CompSal.Ecodigo = lt.Ecodigo
					and CompSal.CSid = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.CSid#">
			</cfif>
					
				inner join Departamentos dpt				
					on dpt.Dcodigo = lt.Dcodigo
					and dpt.Ecodigo = lt.Ecodigo
					<cfif isdefined('url.Dcodigo')>
						and  dpt.Dcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.Dcodigo#">
					</cfif>
			
			inner join DatosEmpleado de
				on de.DEid = lt.DEid	
				and de.Ecodigo = lt.Ecodigo
				<cfif isdefined('url.DEsexo')>
					and de.DEsexo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.DEsexo#" >
				</cfif>
				
				<cfif isdefined('url.CIid')>
					inner join Incidencias Inc
						on Inc.DEid = de.DEid
						and Iestado = 1
						and Inc.CIid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.CIid#">
						
						inner join CIncidentes CInc
							on CInc.CIid = Inc.CIid												
				</cfif>		
		
				<cfif isdefined('url.DClinea')>
					inner join CargasEmpleado cargasEmpl
						on cargasEmpl.DEid = de.DEid
						and <cfqueryparam value="#now()#" cfsqltype="cf_sql_timestamp"> between  cargasEmpl.CEdesde and cargasEmpl.CEhasta 
						and cargasEmpl.DClinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.DClinea#" > 
						
						inner join DCargas detallcarg
							on detallcarg.DClinea = cargasEmpl.DClinea
						
				</cfif>
		
				<cfif isdefined('url.TDid')>   
					inner join DeduccionesEmpleado deccEmp
						 on deccEmp.DEid = de.DEid 
						 and deccEmp.Ecodigo =  de.Ecodigo		    
						 and <cfqueryparam value="#now()#" cfsqltype="cf_sql_timestamp"> between deccEmp.Dfechaini and deccEmp.Dfechafin
	
							inner join TDeduccion TDeducc
								on TDeducc.TDid = deccEmp.TDid 		
								and TDeducc.Ecodigo = deccEmp.Ecodigo		
								and  TDeducc.TDid =<cfqueryparam cfsqltype="cf_sql_integer" value="#url.TDid#">
				  </cfif>
					
		where lt.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		and  <cfqueryparam value="#now()#" cfsqltype="cf_sql_timestamp"> between lt.LTdesde and lt.LThasta 
		
		order by  dpt.Ddescripcion, de.DEnombre

</cfquery>

<!---<cf_dump var="#rsReporte#">
--->

<!--- Busca el nombre de la Empresa --->
<cfquery name="rsEmpresa" datasource="#session.DSN#">
	select Edescripcion
	from Empresas
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
</cfquery>


<style>
	h1.corte {
		PAGE-BREAK-AFTER: always;}
	.tituloAlterno {
		font-size:20px;
		font-weight:bold;
		text-align:center;}
	.titulo_empresa2 {
		font-size:18px;
		font-weight:bold;
		text-align:center;}
	.titulo_reporte {
		font-size:16px;
		font-style:italic;
		text-align:center;}
	.titulo_filtro {
		font-size:14px;
		font-style:italic;
		text-align:center;}
	.titulolistas {
		font-size:14px;
		font-weight:bold;
		background-color:#CCCCCC;
		}
	.titulo_columnar {
		font-size:14px;
		font-weight:bold;
		background-color:#CCCCCC;
		text-align:right;}
	.listaCorte {
		font-size:15px;
		font-weight:bold;
		background-color: #F4F4F4;
		text-align:left;}
	.listaCorte3 {
		font-size:15px;
		font-weight:bold;
		background-color:  #E8E8E8;
		text-align:left;}
	.listaCorte2 {
		font-size:15px;
		font-weight:bold;
		background-color: #D8D8D8;
		text-align:left;}
	.listaCorte1 {
		font-size:16px;
		font-weight:bold;
		background-color:#CCCCCC;
		text-align:left;}
	.total {
		font-size:14px;
		font-weight:bold;
		background-color:#C5C5C5;
		text-align:right;}

	.detalle {
		font-size:15px;
		text-align:left;}
	.detaller {
		font-size:15px;
		text-align:right;}
	.detallec {
		font-size:15x;
		text-align:center;}	
		
	.mensaje {
		font-size:14px;
		text-align:center;}
	.paginacion {
		font-size:14px;
		text-align:center;}
</style>

<cfif rsReporte.RecordCount>
    <table width="792" align="center" border="0" cellspacing="0" cellpadding="2">
        <cfoutput>
        <tr>
			<td colspan="4">
				<table width="100%" cellpadding="0" cellspacing="0">
					<tr><td>
						<cf_EncReporte
							Titulo="#LB_ReporteDatosFunc#"
							Color="##E3EDEF"
						>
					</td></tr>
				</table>
			</td>
		</tr>		
        </cfoutput>
      	<cfoutput query="rsReporte" group="Dcodigo">
        	<!--- DEPARTAMENTO --->
        	<cfquery name="rsDescDepto" datasource="#session.DSN#" >
            	select Ddescripcion
                from Departamentos
                where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
                  and Dcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsReporte.Dcodigo#">
            </cfquery>
        	<tr class="listaCorte1">
                <td >&nbsp;
              <cf_translate key="LB_Departamento">Departamento</cf_translate>  	  :&nbsp;#Dcodigo# - #rsDescDepto.Ddescripcion#</td>
            </tr>
            <tr><td height="1" bgcolor="000000"></td>		
			 </tr>
			 <cfif isdefined('url.TDid')>
				 <tr class="listaCorte1">
					<td >&nbsp;
				  <cf_translate key="LB_Deduccion">Deducci&oacute;n</cf_translate>  	  :&nbsp;#TDcodigo# - #TDdescripcion#</td>
				</tr>
				<tr><td height="1" bgcolor="000000"></td>		
				 </tr>			 
			 </cfif>
			 <cfif isdefined ('url.CSid')>
			 	 <tr class="listaCorte1">
					<td >&nbsp;
				  <cf_translate key="LB_ComponenteSalarial">Componente Salarial</cf_translate>  	  :&nbsp;#CScodigo# - #CSdescripcion#</td>
				</tr>
				<tr><td height="1" bgcolor="000000"></td>		
				 </tr>					 
			 </cfif>
			 <cfif isdefined('url.RHPcodigo')>
			 	 <tr class="listaCorte1">
					<td >&nbsp;
				  <cf_translate key="LB_Puesto">Puesto</cf_translate>  	  :&nbsp;#RHPcodigo# - #RHPdescpuesto#</td>
				</tr>
				<tr><td height="1" bgcolor="000000"></td>		
				 </tr>				 
			 </cfif>
			 
			 <cfif isdefined('url.RHCid')>
			  <tr class="listaCorte1">
					<td >&nbsp;
				  <cf_translate key="LB_Puesto">Categor&iacute;a del Puesto</cf_translate>  	  :&nbsp;#RHCcodigo# - #RHCdescripcion#</td>
				</tr>
				<tr><td height="1" bgcolor="000000"></td>		
				 </tr>					 
			 </cfif>
			 
			 <cfif isdefined('url.Ocodigo')>
			 	 <tr class="listaCorte1">
					<td >&nbsp;
				  <cf_translate key="LB_Oficina">Oficina</cf_translate>  	  :&nbsp;#Ocodigo# - #Odescripcion#</td>
				</tr>
				<tr><td height="1" bgcolor="000000"></td>		
				 </tr>					 
			 </cfif>
			 
			 <cfif isdefined('url.DClinea')>
			 	 <tr class="listaCorte1">
					<td >&nbsp;
					<cf_translate key="LB_Prestacion">Prestaci&oacute;n</cf_translate>:&nbsp;#DCcodigo# - #DCdescripcion#</td>				  
				</tr>
				<tr><td height="1" bgcolor="000000"></td>		
				 </tr>					 
			 </cfif>	
			 
			 <cfif isdefined('url.CIid')>
			 	<tr class="listaCorte1">
					<td >&nbsp;
					<cf_translate key="LB_Percepcion">Percepci&oacute;n </cf_translate>:&nbsp;#CIcodigo# - #CIdescripcion#</td>								 				</tr>
				<tr><td height="1" bgcolor="000000"></td>		
				 </tr>	
					 
			 </cfif>		 
                <tr>
                  <td>
                      <table width="100%" align="center" border="0" cellspacing="0" cellpadding="2">
                                <tr class="listaCorte">
                                            <td>&nbsp;<cf_translate key="LB_Cedula">C&eacute;dula </cf_translate></td>
											<td>&nbsp;<cf_translate key="LB_Nombre">Nombre</cf_translate></td>                                        
                                        <tr><td width="100%" height="1" bgcolor="000000" colspan="4"></td></tr>
                                        <cfoutput>
                                            <tr>
													<td class="detalle">&nbsp;#DEidentificacion#</td>
													<td class="detalle">&nbsp;#empleado#</td>                                              
                                            </tr>
                                        </cfoutput>
                                    </table>
                                </td>
                            </tr>
                     
                        <!--- TOTAL POR EMPLEADO POR DEDUCCION --->
                        <tr><td height="1" bgcolor="000000"></td>
                        <tr class="listaCorte">
                            <!---<td class="detaller">Total Rebajado:&nbsp;&nbsp;&nbsp;#LSCurrencyFormat(Lvar_TotalRebajadoEmp,'none')#</td>--->
                        </tr>
                        <tr><td>&nbsp;</td></tr>
				
    	</cfoutput><!--- AGRUPADO DEPARTAMENTO --->
    </table>
<cfelse>
	 <table width="792" align="center" border="0" cellspacing="0" cellpadding="2">
     	<cfoutput>
        <tr><td align="center"class="titulo_empresa2"><strong>#LB_NoHayDatosRelacionados#</strong></td></tr>
        </cfoutput>
	</table>
</cfif>