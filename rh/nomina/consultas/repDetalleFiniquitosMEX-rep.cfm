<!--- Modified with Notepad --->
<cfset Session.DebugInfo = true>
<!--- Pago de Planilla (S.A.) --->
<cfsilent>
	<!--- Invoca el portlet de traduccion y genera algunas 
	variables utilizadas en este componente. --->
	<cfsavecontent variable="pNavegacion">
		<cfinclude template="/home/menu/pNavegacion.cfm">
	</cfsavecontent>

 <cfif isdefined("Url.DEid") and Len(Trim(Url.DEid)) and not isdefined("Form.DEid")>
	<cfset Form.DEid = Url.DEid>
 </cfif>
 
 <!---SML. Modificacion para obtener las columnas del reporte de nomina configuradas en Reportes Dinamicos.
			El Reporte de Finiquitos tiene el código de MX004---> 
     
     <cf_dbtemp name="RHColumnasReporte" returnvariable="RHColumnasReporte">
		<cf_dbtempcol name="RHCRPTid"   		type="numeric"      	mandatory="yes">
		<cf_dbtempcol name="RHCRPTcodigo" 		type="char(20)"     	mandatory="no">
		<cf_dbtempcol name="RHCRPTdescripcion" 	type="varchar(80)"  	mandatory="no">
		<cf_dbtempcol name="RHRPTNcolumna" 		type="int"     			mandatory="no">
	</cf_dbtemp>
     
     <cfquery datasource="#session.dsn#" name="rsRHReportesNomina">	
     	insert into #RHColumnasReporte# (RHCRPTid,RHCRPTcodigo,RHCRPTdescripcion,RHRPTNcolumna)
            select RHCRPTid,RHCRPTcodigo,RHCRPTdescripcion,RHRPTNcolumna
			from RHColumnasReporte
			where RHRPTNid in (select RHRPTNid from RHReportesNomina
				   			   where RHRPTNcodigo = 'MX004'
							   and Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">)
			order by RHRPTNcolumna asc
	</cfquery>
    
    <cfquery datasource="#session.dsn#" name="rsCantidadColumnas">	
     	select RHCRPTid as cantidad,RHCRPTdescripcion from #RHColumnasReporte# 
        order by RHRPTNcolumna asc
	</cfquery>
    
<!---<cfthrow message="Deid  #Form.DEid#" >--->
   
	<!--- Genera variables de traduccion --->
 
 <!--- Modificado por Israel  Rodríguez Ruiz APH Mex 2-FEB-12
 	Se realizan  las modificaciones necesarias para obtener el  Reporte de finiquitos --->

	<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_TituloReporte" Default="Reporte Detalle de Finiquitos" returnvariable="LB_TituloReporte"/>
    <cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Identificacion"		Default="Identificacion" 	returnvariable="LB_Identificacion"/>
    <cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Apellido1"	Default="Apellido1" returnvariable="LB_Apellido1"/>
    <cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Apellido2"	Default="Apellido2" returnvariable="LB_Apellido2"/>
    <cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Nombre"		Default="Nombre (s)" 	returnvariable="LB_Nombre"/>
    <cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_DirectoIndirecto"	Default="Directo/Indirecto"   returnvariable="LB_DirectoIndirecto"/>
    <cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_FechaIngreso"Default="Fecha Ingreso"	returnvariable="LB_FechaIngreso"/>
    <cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_FechaBaja"	Default="Fecha Baja" returnvariable="LB_FechaBaja"/>
    <cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_SalDiario"	Default="Salario Diario" 	returnvariable="LB_SalDiario"/>
    <cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_SDI"			Default="SDI" 				returnvariable="LB_SDI"/>
    <cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_ISPT"		Default="ISPT" 			returnvariable="LB_ISPT"/>
    <cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_ISPTF"		Default="ISPT Real Liquidación" 					returnvariable="LB_ISPTF"/>       
    <!---<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_DiasLab"		Default="Dias Trab" 			returnvariable="LB_DiasLab"/>   
    <cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_DiasVac"		Default="Dias Vacacion" 		returnvariable="LB_DiasVac"/>--->
    
<!--- Tabla temporal de calendario de pagos --->
	<cf_dbtemp name="calendario" returnvariable="calendario">
		<cf_dbtempcol name="RCNid"   type="int"          mandatory="yes">
		<cf_dbtempcol name="RCdesde" type="datetime"     mandatory="no">
		<cf_dbtempcol name="RChasta" type="datetime"     mandatory="no">
		<cf_dbtempcol name="Tcodigo" type="char(5)"      mandatory="no">
		<cf_dbtempcol name="FechaPago" type="datetime"   mandatory="no">
		<cf_dbtempkey cols="RCNid">
	</cf_dbtemp>
	<!--- Tabla temporal de resultados --->
	<cf_dbtemp name="salida" returnvariable="salida">
		<cf_dbtempcol name="DEid"     		type="int"          mandatory="yes">
        <cf_dbtempcol name="DLlinea"   		type="int"          mandatory="no">
        <cf_dbtempcol name="Identificacion"	type="char(50)"     mandatory="no">
        <cf_dbtempcol name="Ape1"   		type="char(80)"     mandatory="no">
        <cf_dbtempcol name="Ape2"   		type="char(80)"     mandatory="no">
        <cf_dbtempcol name="Nombre"   		type="char(100)"    mandatory="no">
        <cf_dbtempcol name="DEdato1"   		type="char(80)"     mandatory="no">
        <cf_dbtempcol name="FechaIngreso"  	type="char(20)"     mandatory="no">
        <cf_dbtempcol name="FechaBaja"   	type="char(20)"     mandatory="no">
        <!---<cf_dbtempcol name="FactorDiasSalario"   type="int"     mandatory="no">--->
       <!--- <cf_dbtempcol name="diasAnt"   		type="int"          mandatory="no">---> 
       	<cf_dbtempcol name="SalDiario" 		type="money"     	mandatory="no">
        <cf_dbtempcol name="SDI"			type="money"       	mandatory="no">
		<cf_dbtempcol name="ISPTTotF"		type="money"       	mandatory="no">
        <cf_dbtempcol name="ISPT"			type="money"       	mandatory="no">
        <cf_dbtempcol name="CSsalario" 		type="money"     	mandatory="no">
        <cf_dbtempcol name="Dvac" 			type="float"       	mandatory="no">
        <cf_dbtempcol name="DLab" 			type="int"       	mandatory="no">
        <cfif isdefined('rsCantidadColumnas') and rsCantidadColumnas.RecordCount GT 0>
    		<cfset TotalColumnas = #rsCantidadColumnas.RecordCount#>
    			<cfloop from = "1" to ="#TotalColumnas#" index="i">
    				<cf_dbtempcol name="Columna#i#" 		type="money"     	mandatory="no"> 
        		</cfloop>    	
    	</cfif>
       
        

		<!---<cf_dbtempkey cols="DEid">--->
	</cf_dbtemp>
    
        <cfquery datasource="#session.dsn#">	
            insert #calendario#(RCNid, RCdesde, RChasta, Tcodigo, FechaPago)
                select CPid, CPdesde, CPhasta, Tcodigo, CPfpago
                from CalendarioPagos
                where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
        <cfif isdefined("form.FechaDesde")	and len(trim(form.FechaDesde))>
                    and CPdesde >= <cfqueryparam cfsqltype="cf_sql_date" value="#form.FechaDesde#">
        </cfif> 
        <cfif isdefined("form.FechaHasta")	and len(trim(form.FechaHasta))>           
                   	and CPhasta <= <cfqueryparam cfsqltype="cf_sql_date" value="#form.FechaHasta#">
        </cfif>         
        <cfif isdefined("form.Tcodigo")	and len(trim(form.Tcodigo))>           
                    and Tcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Tcodigo#">
        </cfif>         
        </cfquery>
	
<cfquery datasource="#session.dsn#" name="rsFechas">
    select min(CPdesde) as finicio  , max(CPhasta) as ffinal
    from calendarioPagos
</cfquery> 

<!---<cfdump var="#rsFechas#">
          
 <cf_dumptable var="#calendario#">   --->     
        
	<cfset vSalarioEmpleado 	= 'HSalarioEmpleado'>
    <cfset vRCalculoNomina 		= 'HRCalculoNomina'>
    <cfset vDeduccionesCalculo 	= 'HDeduccionesCalculo'>
    <cfset vIncidenciasCalculo 	= 'HIncidenciasCalculo'>
    <cfset vPagosEmpleado 		= 'HPagosEmpleado'>
    <cfset vCargasCalculo 		= 'HCargasCalculo'>
    <cfset vDatosEmpleado		= 'DatosEmpleado'>

<!----------------------------------------------->
       
 <!---====================================
    INSERTA EN LA INFORMACION DE SALIDA, 
    LOS DATOS BASICOS DEL FUNCIONARIO
    ====================================---> 


<!--- Hay  que probar  estos queries --->


	<cfquery name="rsEncabezado" datasource="#Session.DSN#">
   		insert #salida# (DLlinea, DEid, Nombre,Ape1,Ape2, Identificacion,FechaIngreso,FechaBaja,DEdato1<!---,FactorDiasSalario,diasAnt--->  )
        select distinct a.DLlinea, b.DEid,
			   b.DEnombre,
               b.DEapellido1,
               b.DEapellido2,
               b.DEidentificacion,
			   a.RHLPfingreso as FechaIngreso,
			   c.DLfvigencia as FechaBaja,
               b.DEdato1
			  <!--- <cf_dbfunction name="to_number" args="h.FactorDiasSalario"> as FactorDiasSalario,--->
			   <!---<cf_dbfunction name="datediff" args="e.EVfantig, c.DLfvigencia"> as diasAnt---->
			   <!---<cf_dbfunction name="datediff" args="a.RHLPfingreso, c.DLfvigencia"> as diasAnt--->
		from RHLiquidacionPersonal a
	
			inner join DatosEmpleado b
				on a.DEid = b.DEid
			
			inner join DLaboralesEmpleado c
				on a.DLlinea = c.DLlinea
			
			inner join RHPuestos d
				on c.Ecodigo = d.Ecodigo
				and c.RHPcodigo = d.RHPcodigo
			
			inner join EVacacionesEmpleado e
				on a.DEid = e.DEid
			
			inner join Departamentos f
				on c.Ecodigo = f.Ecodigo
				<!---and c.Dcodigo = f.Dcodigo--->
	
			inner join RHTipoAccion g
				on c.RHTid = g.RHTid
				and g.RHTcomportam = 2
	
			inner join TiposNomina h
				on c.Ecodigo = h.Ecodigo
				and c.Tcodigo = h.Tcodigo
				
			inner join Monedas i
				on h.Ecodigo = i.Ecodigo
				and h.Mcodigo = i.Mcodigo
	
	where
		
	<cfif form.FechaDesde NEQ ''>
    	c.DLfvigencia >= <cfqueryparam cfsqltype="cf_sql_date" value="#LSdateFormat(form.FechaDesde,'yyyy-mm-dd')#">
    <cfelse>
    	c.DLfvigencia >= <cfqueryparam cfsqltype="cf_sql_date" value="#LSdateFormat(rsFechas.finicio,'yyyy-mm-dd')#">
    </cfif>
     
    <cfif form.FechaHasta NEQ ''>
    	and c.DLfvigencia <= <cfqueryparam cfsqltype="cf_sql_date" value="#LSdateFormat(form.FechaHasta,'yyyy-mm-dd')#">
    <cfelse>
	    and c.DLfvigencia <= <cfqueryparam cfsqltype="cf_sql_date" value="#LSdateFormat(rsFechas.ffinal,'yyyy-mm-dd')#">
    </cfif>  
      and b.Ecodigo = #session.Ecodigo#
   	<cfif Form.DEid GT 0 >
    	and b.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.DEid#">
    </cfif> 
    and c.Tcodigo =<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Tcodigo#">
    and a.RHLPestado = 1
    order by  b.DEidentificacion
	</cfquery>
	

<!---Renta ISPT--->
<cfquery datasource="#session.dsn#" name="rsISPT">
    update #salida#
            set ISPT = 
                coalesce(
                        (select sum(RHLFLisptF) from RHLiqFL
                                where DEid = #salida#.DEid
                                	and  DLlinea = #salida#.DLlinea),0)
                                
                ,CSsalario = 
                        coalesce(
                                (select sum(RHLFLsalarioMensual) from RHLiqFL
                                where DEid = #salida#.DEid
                                	and  DLlinea = #salida#.DLlinea),0)
				,SDI = 
                        coalesce(
                                (select DEsdi
                                from #vDatosEmpleado# se
                                        where se.DEid = #salida#.DEid
                                        and se.Ecodigo= #session.Ecodigo#),0)
</cfquery>

<!---Salario Diario--->

	<cfquery datasource="#session.dsn#" name="upSD">
        update #salida#
                set SalDiario = (CSsalario)/(select coalesce(FactorDiasSalario,30) as FactorDiasSalario
											 from DLaboralesEmpleado dle
													inner join TiposNomina tn
													on tn.Ecodigo = dle.Ecodigo and tn.Tcodigo = dle.Tcodigo
										     where DLlinea = #salida#.DLlinea
											 and DEid = #salida#.DEid)
               
    </cfquery> 
    
<cfset a = 1>   
<cfloop query="rsCantidadColumnas">
	<cfquery datasource="#session.dsn#" name="rsValidarCIncidentes">
		select count(CIid) as CIid from RHConceptosColumna
		where RHCRPTid = #rsCantidadColumnas.cantidad#
    </cfquery>
    
	<cfquery datasource="#session.dsn#" name="rsValidarTDeduccion">
		select count(TDid) as TDid from RHConceptosColumna
		where RHCRPTid = #rsCantidadColumnas.cantidad#
    </cfquery>
    
	<cfquery datasource="#session.dsn#" name="rsValidarDCargas">
		select count(DClinea) as DClinea from RHConceptosColumna
		where RHCRPTid = #rsCantidadColumnas.cantidad#
    </cfquery>
    
    <cfif isdefined('rsValidarCIncidentes') and rsValidarCIncidentes.CIid GT 0>
    
    <cfquery name="rsCIidexceso" datasource="#session.DSN#">
    	select coalesce(CIidexceso,0) as CIidexceso
		from CIncidentes
		where Ecodigo = #session.Ecodigo#
		and CIid in (select CIid from RHConceptosColumna where RHCRPTid = #rsCantidadColumnas.cantidad#) 
    </cfquery>
    
    	<cfif isdefined('rsCIidexceso') and rsCIidexceso.CIidexceso GT 0>
    		<cfset Columnan = 'Columna' & #a#>
    		<cfquery datasource="#session.dsn#">
   				update #salida#
				set #Columnan#=  coalesce((select sum(RHLIexento) 
									from RHLiqIngresos
									where DEid =#salida#.DEid 
										and DLlinea =#salida#.DLlinea 
                                        and CIid  in (select CIid as CIid from RHConceptosColumna
													  where RHCRPTid = #rsCantidadColumnas.cantidad#)
                                                      ),0)
                                        
		
			</cfquery>
        <cfelse>
        	<cfset Columnan = 'Columna' & #a#>
            <cfquery name="rsCIid" datasource="#session.DSN#">
    			select CIid
				from CIncidentes
				where Ecodigo = #session.Ecodigo#
				and CIidexceso in (select CIid from RHConceptosColumna where RHCRPTid = #rsCantidadColumnas.cantidad#) 
   			</cfquery>
    		<cfif isdefined('rsCIid') and rsCIid.RecordCount GT 0>
    			<cfquery datasource="#session.dsn#">
   					update #salida#
					set #Columnan#=  coalesce((select sum(RHLIgrabado) 
									from RHLiqIngresos
									where DEid =#salida#.DEid 
										and DLlinea =#salida#.DLlinea 
                                        and CIid  in (#rsCIid.CIid#)
                                                      ),0)
				</cfquery>    
            <cfelse>
            	<cfquery datasource="#session.dsn#">
   					update #salida#
					set #Columnan#=  coalesce((select sum(importe) 
									from RHLiqIngresos
									where DEid =#salida#.DEid 
										and DLlinea =#salida#.DLlinea 
                                        and CIid  in (select CIid from RHConceptosColumna where RHCRPTid = #rsCantidadColumnas.cantidad#)
                                                      ),0)
				</cfquery>             
            </cfif>    
    	</cfif>
    <cfelseif isdefined('rsValidarTDeduccion') and rsValidarTDeduccion.TDid GT 0>
    <cfset Columnan = 'Columna' & #a#>
    <cfquery datasource="#session.dsn#" name="UpdPensionAlimeo">
    	update #salida#
    	set #Columnan# = 
    					coalesce((select SUM(importe) 
								  from RHLiqDeduccion
								  where DEid =#salida#.DEid 
										and DLlinea =#salida#.DLlinea 
										and Did in (select Did from DeduccionesEmpleado
													where TDid in (select TDid as TDid from RHConceptosColumna
																	where RHCRPTid = #rsCantidadColumnas.cantidad#)
													      and DEid = #salida#.DEid)),0)
	</cfquery>
    <cfelseif isdefined('rsValidarDCargas') and rsValidarDCargas.DClinea GT 0>
    <cfset Columnan = 'Columna' & #a#>
    <cfquery datasource="#session.dsn#" name="UpdCargaIMSSo">
    	update #salida#
    	set #Columnan# = 
    					coalesce((select SUM(importe) 
								  from RHLiqCargas
								  where DEid =#salida#.DEid 
									and DLlinea =#salida#.DLlinea 
                                	and DClinea in (select DClinea as DClinea from RHConceptosColumna
											where RHCRPTid = #rsCantidadColumnas.cantidad#)),0)
                        ),0)
	</cfquery>
    </cfif>
    
    <cfset a = a + 1>
    
</cfloop>

<!---<cf_dumpTABLE var="#salida#">--->
 <!---<cfthrow message="salarioDiario #salarioDiario#">--->
 
<!--- Consultas para el Reporte --->
<cfquery name="rsReporte" datasource="#session.dsn#">
	select *
	from #salida#
	order by Ape1,Ape2,Nombre
</cfquery>

</cfsilent>
<cf_htmlReportsHeaders irA="repDetalleFiniquitosMEX-form.cfm"
FileName="Reporte_detalle_Planilla.xls"
title="#LB_TituloReporte#">
<cf_templatecss>
<table width="100%" border="1" cellpadding="0" cellspacing="0" align="center">
<cfoutput>
<tr>
	<td colspan="100%">
		<table width="100%" cellpadding="0" cellspacing="0" border="0">
		<tr>
			<td>	
				<cf_EncReporte
					Titulo="#LB_TituloReporte#"
					Color="##E3EDEF"
					filtro1="Desde:#lsdateformat(form.FechaDesde,'dd/mm/yyyy')# al #lsdateformat(form.FechaHasta,'dd/mm/yyyy')#">
			</td>
		</tr>
		</table>
	</td>
 </tr>
 <tr>
  <td  class="tituloListas" valign="top"><strong>#LB_Identificacion#</strong>&nbsp;&nbsp;</td> 
    <td  class="tituloListas" valign="top"><strong>#LB_Apellido1#</strong>&nbsp;&nbsp;</td>
    <td  class="tituloListas" valign="top"><strong>#LB_Apellido2#</strong>&nbsp;&nbsp;</td>
    <td  class="tituloListas" valign="top"><strong>#LB_Nombre#</strong>&nbsp;&nbsp;</td>
    <td  class="tituloListas" valign="top"><strong>#LB_DirectoIndirecto#</strong>&nbsp;&nbsp;</td>
    <td  class="tituloListas" valign="top" align="right"><strong>#LB_FechaIngreso#</strong>&nbsp;</td>
    <td  class="tituloListas" valign="top" align="right"><strong>#LB_FechaBaja#</strong>&nbsp;</td>    
    <td  class="tituloListas" valign="top" align="right"><strong>#LB_SalDiario#</strong>&nbsp;</td>
    <td  class="tituloListas" valign="top" align="right"><strong>#LB_SDI#</strong>&nbsp;</td>   
    <td  class="tituloListas" valign="top" align="right"><strong>#LB_ISPT#</strong>&nbsp;</td> 
    <!---<td  class="tituloListas" valign="top" align="right"><strong>#LB_ISPTF#</strong>&nbsp;</td> --->
    <cfloop query="rsCantidadColumnas">
    <td  class="tituloListas" valign="top"><strong>#rsCantidadColumnas.RHCRPTdescripcion#</strong>&nbsp;&nbsp;</td>
    </cfloop>
</tr>
</cfoutput>    
    
<cfoutput query="rsReporte">
    <tr>
        <td nowrap>#rsReporte.Identificacion#</td>
        <td nowrap>#rsReporte.ape1#</td>
        <td nowrap>#rsReporte.ape2#</td>
        <td nowrap>#rsReporte.Nombre#</td>  
        <td nowrap>#rsReporte.DEdato1#</td>          
        <td nowrap align="right">#DateFormat(rsReporte.FechaIngreso,"dd/mm/yyyy")#</td>
        <td nowrap align="right">#DateFormat(rsReporte.FechaBaja,"dd/mm/yyyy")#</td>
        <td nowrap align="right">#LSCurrencyformat(rsReporte.SalDiario,'none')#</td>
        <td nowrap align="right">#LSCurrencyformat(rsReporte.SDI,'none')#</td>
        <td nowrap align="right">#LSCurrencyformat(rsReporte.ISPT,'none')#</td>
        <!---<td nowrap align="right">#LSCurrencyformat(rsReporte.ISPTTotF,'none')#</td> --->  
        <cfset x = 1>
        	<cfloop query = "rsCantidadColumnas">
            	<cfif isdefined('rsCantidadColumnas') and rsCantidadColumnas.RecordCount GT 0>
            		<cfset Columnax = 'Columna' & #x#>
            		<cfset Columna = rsReporte[Columnax]>
            			<td nowrap align="right">#LSCurrencyFormat(Columna,'none')#</td>
                	<cfset x = x + 1>
            	</cfif>
           </cfloop>     
     </tr>   
</cfoutput>

<tr><td colspan="31" align="center"><strong><cf_translate key="LB_FinDelReporte"> --Fin Del Reporte-- </cf_translate></strong></td></tr>
</table>
