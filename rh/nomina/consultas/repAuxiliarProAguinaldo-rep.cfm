<!---<cf_dump var = "#form#">--->
<!---CarolRS modificacion para tomar en cuenta detalles de los calculos en el reporte--->
<cfquery name="rsSaldoCorte" datasource="#session.DSN#">
	select Pvalor from RHParametros where Pcodigo=890 and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
</cfquery>

<!---CarolRS modificacion para tomar en cuenta el redondeo para el saldo de vacaiones--->
<cfquery name="rsRodondeo" datasource="#session.DSN#">
	select Pvalor from RHParametros where Pcodigo=600 and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
</cfquery>

<cfinvoke key="LB_ReporteDeAuxiliarDeProvisionDeAguinaldo" default="Reporte de Auxiliar de Provisi&oacute;n de Aguinaldo" returnvariable="LB_ReporteDeAuxiliarDeProvisionDeAguinaldo" component="sif.Componentes.Translate" method="Translate"/>
<!---<cfelseif form.tipoEmpleado EQ 2>
	<cfinvoke key="LB_ReporteDeAuxiliarDeProvisionDeVacaciones" default="Reporte de Auxiliar de Provisión de Vacaciones (Empleados Inactivos)" returnvariable="LB_ReporteDeAuxiliarDeProvisionDeVacaciones" component="sif.Componentes.Translate" method="Translate"/>
<cfelse>
	<cfinvoke key="LB_ReporteDeAuxiliarDeProvisionDeVacaciones" default="Reporte de Auxiliar de Provisión de Vacaciones" returnvariable="LB_ReporteDeAuxiliarDeProvisionDeVacaciones" component="sif.Componentes.Translate" method="Translate"/>
</cfif>
--->


<cfinvoke key="LB_CentroFuncional" default="Centro Funcional" returnvariable="LB_CentroFuncional" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_Del" default="Del" returnvariable="LB_Del" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_al" default="al" returnvariable="LB_al" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_Indefinido" default="Indefinido" returnvariable="LB_Indefinido" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_hasta" default="Hasta" returnvariable="LB_hasta" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_TodasLasFechas" default="Todas las fechas" returnvariable="LB_TodasLasFechas" component="sif.Componentes.Translate" method="Translate"/>

<cfset filtro1 = ''>
<cfset filtro2 = ''>
<!---<cfset form.CFagrupamiento = 1>--->

<cfset vn_filtroempleados = ''>
<cfif isdefined("form.CFidI") and len(trim(form.CFidI))>
	<cfquery name="CFuncional" datasource="#session.DSN#">
		select CFpath,CFcodigo,CFdescripcion 
		from CFuncional
		where CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CFidI#">
	</cfquery>
	<cfset filtro2 = '#LB_CentroFuncional#: '& CFuncional.CFcodigo & ' - ' & CFuncional.CFdescripcion>	
</cfif>

<cfquery datasource="#session.dsn#" name="CalendarioPagos">	
	select CPid, CPdesde, CPhasta, Tcodigo, CPfpago
    from CalendarioPagos
    where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
    	and CPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CPid1#"> 
</cfquery>

<cfif isdefined('form.cantDiasAnio') and len(trim(form.cantDiasAnio))>
	<cfset cantDiasAnio = #form.cantDiasAnio#>
<cfelse>
	<cfset cantDiasAnio = #form.cantDiasAnio#>
</cfif>


<cf_dbtemp name="TempDatosAuxiliar012345" returnvariable="DatosRep" datasource="#session.DSN#">
	<cf_dbtempcol name="DEid" 			  type="numeric"			mandatory="no">
    <cf_dbtempcol name="Identificacion"	  type="varchar(100)"		mandatory="no">
	<cf_dbtempcol name="nombre" 		  type="varchar(100)"		mandatory="no">
	<cf_dbtempcol name="apellidos"		  type="varchar(160)" 	    mandatory="no">
	<cf_dbtempcol name="CFid"			  type="numeric" 			mandatory="no">
	<cf_dbtempcol name="CFcodigo"		  type="varchar(50)" 		mandatory="no">
	<cf_dbtempcol name="CFdescripcion"	  type="varchar(160)" 	    mandatory="no">
	<cf_dbtempcol name="factorDiario"	  type="numeric(18,4)"	    mandatory="no">
	<cf_dbtempcol name="ProvisionMensual" type="numeric(18,2)"	    mandatory="no">
	<cf_dbtempcol name="ImportePrimaVac"  type="numeric(18,2)"	    mandatory="no">
	<cf_dbtempcol name="fechaingreso"	  type="date"				mandatory="no">
	<cf_dbtempcol name="cortevacas"		  type="date"				mandatory="no">
	<cf_dbtempcol name="LTdesde"		  type="date"				mandatory="no">
	<cf_dbtempcol name="LThasta"		  type="date"				mandatory="no">
	<cf_dbtempcol name="Activo"			  type="numeric"			mandatory="no">	
	<cf_dbtempcol name="fechaCese"		 type="date"				mandatory="no">
</cf_dbtemp>

<cf_dbtemp name="PrimaVacacional" returnvariable="PrimaVacacional" datasource="#session.DSN#">
	<cf_dbtempcol name="PElinea" 			type="numeric"			mandatory="no">
	<cf_dbtempcol name="DEid" 				type="numeric"			mandatory="no">
    <cf_dbtempcol name="Dias" 				type="int"				mandatory="no">
    <cf_dbtempcol name="SueldoMensual" 		type = "numeric(18,2)"  mandatory ="no">
    <cf_dbtempcol name="ProvisionMensual" 	type = "numeric(18,2)"  mandatory ="no">
    <cf_dbtempcol name="ImportePrimaVac" 	type = "numeric(18,2)"  mandatory ="no">
    <cf_dbtempcol name="SueldoDiario" 		type = "numeric(18,2)"  mandatory ="no">
</cf_dbtemp>


<!----Carga los empleados--->
<!---<cfif  listFindNoCase('1,0',form.tipoEmpleado,',') GT 0	>--->
	
	<cfquery datasource="#session.DSN#" name="rsGetDatos">
		insert into #DatosRep#(DEid,Identificacion,nombre,apellidos,CFid,CFcodigo,CFdescripcion,LTdesde,LThasta,Activo,fechaingreso, fechaCese)
		select  distinct b.DEid,c.DEidentificacion,c.DEnombre,<cf_dbfunction name="concat" args="c.DEapellido1,' ',c.DEapellido2">,z.CFid,z.CFcodigo,z.CFdescripcion,x.LTdesde,x.LThasta, 1, 
			(select w.EVfantig from EVacacionesEmpleado w where w.DEid = b.DEid)	<!---nombramiento--->
			,
			(	select coalesce( max(v.DLfvigencia) , null)
				from DLaboralesEmpleado v, RHTipoAccion y 
				where v.DEid = b.DEid 
				and y.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
				and y.RHTid=v.RHTid 
				and y.RHTcomportam = 2 			<!---cese--->
			)
		from HRCalculoNomina a	
			inner join HSalarioEmpleado b
				on a.RCNid = b.RCNid
            inner join DatosEmpleado c
            	on c.DEid = b.DEid	
   		    inner join LineaTiempo x
				on x.DEid = b.DEid
				and x.Ecodigo = a.Ecodigo
			 inner join RHPlazas y
				on y.RHPid = x.RHPid
				and y.Ecodigo = a.Ecodigo
			inner join CFuncional z
				on y.CFid = z.CFid
			where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			<cfif isdefined("form.CFidI") and len(trim(form.CFidI))>
			and y.CFid in (	select z.CFid 
							from CFuncional z 
							where z.Ecodigo = a.Ecodigo
								<cfif isdefined("form.CFcodigoI") and len(trim(form.CFcodigoI)) and isdefined("form.dependencias") and len(trim(form.dependencias))>
									and z.CFpath like <cfqueryparam cfsqltype="cf_sql_varchar" value="#CFuncional.CFpath#/%">
									or z.CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CFidI#">
								<cfelseif not isdefined("form.dependencias")>
									and z.CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CFidI#">
								</cfif>)
			</cfif>
            and b.RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CPid1#">
			group by z.CFid,z.CFcodigo,z.CFdescripcion,b.DEid,c.DEidentificacion,c.DEnombre,c.DEapellido1,c.DEapellido2,x.LTdesde,x.LThasta
			order by z.CFid,z.CFcodigo,z.CFdescripcion,b.DEid,x.LTdesde,x.LThasta
	</cfquery>
	
	<!--- CarolRS. Actualiza el estado en activo o inactivo segun los cortes de la linea del tiempo y la ultima fecha de ingreso.--->
	<cfquery datasource="#session.DSN#">
		update #DatosRep# set Activo =  case when fechaCese is null then 1
											 when  fechaingreso > LTdesde then 0 
											 when  fechaCese > fechaingreso then 0 
											 else 1 end 
	</cfquery>
	
	<!--- CarolRS. Actualiza con el ultimo centro funcional registrado en la linea del tiempo para cada persona, 
	esto en caso de que existan centros funcionales inactivos y un mismo empleado registrado en diferentes centros funcionales--->
	<cfquery datasource="#session.DSN#">
		Update #DatosRep# 
		set CFid = (select dr.CFid 
					from #DatosRep# dr 
					where dr.LThasta = (select max(hx.LThasta) from #DatosRep# hx where hx.DEid = #DatosRep#.DEid)
					and dr.DEid = #DatosRep#.DEid
				)
			, CFcodigo = (select dr.CFcodigo 
					from #DatosRep# dr 
					where dr.LThasta = (select max(hx.LThasta) from #DatosRep# hx where hx.DEid = #DatosRep#.DEid)
					and dr.DEid = #DatosRep#.DEid
				)
			, CFdescripcion = (select dr.CFdescripcion 
					from #DatosRep# dr 
					where dr.LThasta = (select max(hx.LThasta) from #DatosRep# hx where hx.DEid = #DatosRep#.DEid)
					and dr.DEid = #DatosRep#.DEid
				)
	</cfquery>
    

   <!---Calcular Factor Diario--->
   <cfquery name="rsDatosEmpleado" datasource="#session.DSN#">
	select 
	distinct Identificacion,nombre,apellidos,DEid,fechaingreso
	from #DatosRep# 
	</cfquery>
    
	<cfloop query="rsDatosEmpleado">
    
    	<cfset anno = DateDiff('yyyy', rsDatosEmpleado.fechaingreso, CalendarioPagos.CPhasta)>
  
		<cfquery name="rsRegimen" datasource="#session.DSN#">
        	select RVid
		   from HPagosEmpleado a
		   where DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsDatosEmpleado.DEid#">
 			  and RCNid = <cfqueryparam cfsqltype="cf_sql_integer" value="#CalendarioPagos.CPid#">
        	<!---select RVid, dl.DLTmonto
			from LineaTiempo lt 
				inner join DLineaTiempo dl on dl.LTid = LT.LTid 
        		inner join ComponentesSalariales cs on cs.CSid = dl.CSid
        		and cs.CSsalariobase = 1 
			where lt.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">  
				and DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsDatosEmpleado.DEid#">
    			and <cfqueryparam cfsqltype="cf_sql_timestamp" value="#CalendarioPagos.CPhasta#"> between LTdesde and LThasta--->
   		</cfquery>
        
        <cfquery name="rsDiasPrima" datasource="#session.DSN#">
        	select coalesce(rv.DRVdiasgratifica, 0) as DRVdias
            from DRegimenVacaciones rv 
            where rv.RVid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsRegimen.RVid#">
            	and rv.DRVcant = ( select coalesce(max(DRVcant),1) 
                                   from DRegimenVacaciones rv2 
                                   where rv2.RVid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsRegimen.RVid#">
                                   		and rv2.DRVcant <= <cfqueryparam cfsqltype="cf_sql_float" value="#anno+1#">)
        </cfquery>
        
        <cfset factorDiario = (#rsDiasPrima.DRVdias#/#cantDiasAnio#) >
        
        <cfquery datasource="#session.DSN#">
        	insert into #PrimaVacacional# (PElinea,DEid,Dias,SueldoMensual)
        	select ROW_NUMBER()OVER(PARTITION BY DEid Order By DEid),DEid, SUM(PEcantdias) as diasLab,PEsalarioref
			from HPagosEmpleado
			where DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsDatosEmpleado.DEid#">
				and RCNid = <cfqueryparam cfsqltype="cf_sql_integer" value="#CalendarioPagos.CPid#"> 
			group by DEid,PEsalarioref
        </cfquery>
        
        <cfquery name="rsSueldoDiario" datasource="#session.DSN#">
        	select PElinea,DEid,Dias,SueldoMensual
			from  #PrimaVacacional#
        </cfquery>
        
        <cfloop query="rsSueldoDiario">
        	
            <cfset diasLaborados =  #rsSueldoDiario.Dias#>
            
            <cfif isdefined('form.chkFaltas') and form.chkFaltas EQ 1>
            	<cfquery name="rsDiasFalta" datasource="#session.DSN#">
        			select PEcantdias 
					from HPagosEmpleado a
						inner join RHTipoAccion b on a.RHTid = b.RHTid
					where DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsSueldoDiario.DEid#">
 						and RCNid = <cfqueryparam cfsqltype="cf_sql_integer" value="#CalendarioPagos.CPid#"> 
 						and RHTcomportam = 13
 						and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#"> 
 						and PEsalarioref = <cfqueryparam cfsqltype="cf_sql_money" value="#rsSueldoDiario.SueldoMensual#">
        		</cfquery>
                <cfif isdefined('rsDiasFalta') and rsDiasFalta.RecordCount GT 0>
                	<cfset diasLaborados = #diasLaborados# - #rsDiasFalta.PEcantdias#>
                </cfif>
            </cfif>
            
            <cfif isdefined('form.chkIncapacidades') and form.chkIncapacidades EQ 1>
            	<cfquery name="rsDiasFalta" datasource="#session.DSN#">
        			select PEcantdias 
					from HPagosEmpleado a
						inner join RHTipoAccion b on a.RHTid = b.RHTid
					where DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsSueldoDiario.DEid#">
 						and RCNid = <cfqueryparam cfsqltype="cf_sql_integer" value="#CalendarioPagos.CPid#"> 
 						and RHTcomportam = 5
                        and RHTsubcomportam = 2
 						and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#"> 
 						and PEsalarioref = <cfqueryparam cfsqltype="cf_sql_money" value="#rsSueldoDiario.SueldoMensual#">
        		</cfquery>
                <cfif isdefined('rsDiasFalta') and rsDiasFalta.RecordCount GT 0>
                	<cfset diasLaborados = #diasLaborados# - #rsDiasFalta.PEcantdias#>
                </cfif>
            </cfif>
            
        	<cfset SueldoDiario = (#rsSueldoDiario.SueldoMensual#)/30>
        
        	<cfset ProvisionDiaria = #factorDiario# * #SueldoDiario#>
        
        	<cfset ImportePrimaVacional = #ProvisionDiaria# * #diasLaborados#>
            
            <cfquery datasource="#session.DSN#">
				Update #PrimaVacacional# 
            	set ProvisionMensual = #ProvisionDiaria#,
                	ImportePrimaVac = #ImportePrimaVacional#,
                    SueldoDiario = #SueldoDiario#
            	where DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsSueldoDiario.DEid#">
                	and PElinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsSueldoDiario.PElinea#"> 
			</cfquery>          
        </cfloop>
        
        <cfquery datasource="#session.DSN#">
			Update #DatosRep# 
            set factorDiario = #factorDiario#
            where DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsDatosEmpleado.DEid#">
		</cfquery>
        
         <cfquery datasource="#session.DSN#">
			Update #DatosRep# 
            set ProvisionMensual = (select sum(ProvisionMensual) 
            						from #PrimaVacacional# 
                                    where DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsDatosEmpleado.DEid#">
                                    group by DEid),
                ImportePrimaVac = (select sum(ImportePrimaVac) 
            						from #PrimaVacacional# 
                                    where DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsDatosEmpleado.DEid#">
                                    group by DEid)
            where DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsDatosEmpleado.DEid#">
		</cfquery>        
   </cfloop>

<cfquery name="rsDatos" datasource="#session.DSN#">
	select 
	distinct Identificacion,nombre,apellidos,CFcodigo,CFdescripcion,CFid,cortevacas,a.DEid,fechaCese,fechaingreso,factorDiario,ProvisionMensual,ImportePrimaVac
	from #DatosRep# a
	order by CFcodigo,CFdescripcion,nombre,apellidos
</cfquery>

<cfquery datasource="#session.DSN#" dbtype="query" name="rsTotalPV">
	select sum(ImportePrimaVac) as TotalPV
    from rsDatos
</cfquery>

<cfset LvarFileName = "Auxiliar_Pro_Aguinaldo.xls">
<cf_htmlReportsHeaders irA="repAuxiliarProAguinaldo.cfm" FileName="#LvarFileName#" title="#LB_ReporteDeAuxiliarDeProvisionDeAguinaldo#">
	
<table width="100%" cellpadding="0" cellspacing="0" align="center">
	<tr>
		<td>
			<table width="100%" cellpadding="0" cellspacing="0" align="center">
				<tr><td>					
					<cfset filtro1 = ' #LB_Del#: '&LSDateFormat(CalendarioPagos.CPdesde,'dd/mm/yyyy') & ' #LB_al#: '&LSDateFormat(CalendarioPagos.CPhasta,'dd/mm/yyyy')>
					
					<cf_EncReporte
						Titulo="#LB_ReporteDeAuxiliarDeProvisionDeAguinaldo#"
						Color="##E3EDEF"
						filtro1="#filtro1#"
						filtro2="#filtro2#"
					>
				</td></tr>
			</table>
		</td>
	</tr>
	<tr><td>&nbsp;</td></tr>	
	<cfif rsDatos.RecordCount NEQ 0>
		<tr>
			<td>
				<table width="100%" cellpadding="0" cellspacing="0" border="0" align="center">
                	<cfoutput>
					<tr>
						<td valign="top" style="border-bottom:1px solid black;" nowrap="nowrap">
                        	<strong><cf_translate key="LB_Identificacion">Identificacion</cf_translate></strong></td>
						<td valign="top" style="border-bottom:1px solid black;" nowrap="nowrap" >
                       		<strong><cf_translate key="LB_Nombre">Nombre</cf_translate></strong></td>
						<td valign="top" style="border-bottom:1px solid black;" nowrap="nowrap">
                        	<strong><cf_translate key="LB_Apellidos">Apellidos</cf_translate></strong></td>
						<td valign="top" style="border-bottom:1px solid black;" nowrap="nowrap">
                        	<strong><cf_translate key="LB_CF">Centro Funcional</cf_translate></strong></td>
						<td valign="top" align="right" style="border-bottom:1px solid black;" nowrap="nowrap">
							<strong><cf_translate key="LB_MontoProvisionado">Factor <br /> Diario</cf_translate></strong>
						</td>
						<td valign="top" align="right" style="border-bottom:1px solid black;" nowrap="nowrap">
							<strong><cf_translate key="LB_VacacionesPagadas">Provision <br /> Diaria</cf_translate></strong>
						</td>
						<td align="right" style="border-bottom:1px solid black;" nowrap="nowrap">
							<strong><cf_translate key="LB_SaldoProvision">Importe <br />Aguinaldo</cf_translate></strong>
						</td>
						
					</tr>	
					</cfoutput>

					<cfoutput query="rsDatos">
					
						<!---Pintado de corte por centro funcional--->
					<tr>
                    	<td nowrap="nowrap">#rsDatos.Identificacion#</td>
						<td nowrap="nowrap">#rsDatos.nombre#</td>
						<td nowrap="nowrap">&nbsp;&nbsp;&nbsp;#rsDatos.apellidos#</td>
						<td nowrap="nowrap">&nbsp;&nbsp;&nbsp;#rsDatos.CFcodigo# - #rsDatos.CFdescripcion#</td>
						<td align="right">
							#rsDatos.factorDiario#
						</td>
						<td align="right">
							#LSCurrencyFormat(rsDatos.ProvisionMensual,'none')#
						</td>
						<td align="right">
							#LSCurrencyFormat(rsDatos.ImportePrimaVac,'none')#
						</td>
					</tr>
					</cfoutput>		
                    <tr>
						<td align="right" colspan="5">

						</td>
						<td valign="top" nowrap="nowrap">
                        	<strong><cf_translate key="LB_Apellidos">Total</cf_translate></strong></td>
						<td align="right">
							<cfoutput><strong>#LSCurrencyFormat(rsTotalPV.TotalPV,'none')#<strong></cfoutput>
						</td>
					</tr>		
				</table>
			</td>	
		</tr>
	<cfelse>
		<tr><td align="center"><strong>---- <cf_translate key="LB_NoSeEncontraronRegistros">No se encontraron registros</cf_translate> ----</strong></td></tr>	
	</cfif>	
</table>	

