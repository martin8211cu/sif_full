 <style type="text/css">
	.stitulo{
		font-weight:bold;
		font-size:14px;
		text-transform:uppercase;
	}
	.subrayados{
		border-bottom:ridge;
	}
</style>	
<cf_dbfunction name="OP_Concat" returnvariable="concat">
<cfif isdefined("url.CIid") and len(trim(url.CIid)) gt 0>
	<cfset form.CIid=url.CIid>
</cfif>
<cfif isdefined("url.DEid") and len(trim(url.DEid)) gt 0>
	<cfset form.DEid=url.DEid>
</cfif>

<cfset local.IncluirSE=false>


<!---- obtiene el Tcodigo de la accion si ya fue o no aplicada----->
<cfif isdefined("url.RHAlinea") and len(trim(url.RHAlinea)) gt 0>
	<cfquery datasource="#session.dsn#" name="rsTcodigo">
	select Tcodigo from RHAcciones where RHAlinea=<cfqueryparam cfsqltype="cf_sql_numeric" value="#url.RHAlinea#">
	</cfquery>
	<cfset form.Tcodigo=trim(rsTcodigo.Tcodigo)>
</cfif>
<cfif isdefined("url.DLlinea") and len(trim(url.DLlinea)) gt 0>
	<cfquery datasource="#session.dsn#" name="rsTcodigo">
	select Tcodigo from DLaboralesEmpleado where DLlinea=<cfqueryparam cfsqltype="cf_sql_numeric" value="#url.DLlinea#">
	</cfquery>
	<cfset form.Tcodigo=trim(rsTcodigo.Tcodigo)>
</cfif>
<cfif isdefined("url.RHLPid") and len(trim(url.RHLPid)) gt 0>
	<cfquery datasource="#session.dsn#" name="rsTcodigo">
	select Tcodigo 
	from LineaTiempo
	where DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.DEid#">
	<cfif isdefined("url.FechaCorte")>
		and <cfqueryparam cfsqltype="cf_sql_timestamp" value="#url.FechaCorte#"> between
			LTdesde and LThasta
	</cfif>
	</cfquery> 
	<cfset form.Tcodigo=trim(rsTcodigo.Tcodigo)>
</cfif>

<cfset existeAplicado=false>	
<cfset provieneReporte=true>	

<cfif isdefined("form.fromForm")>
	<cfset provieneReporte=true>	
</cfif>	
<cfif (isdefined("url.RHAlinea") and len(trim(url.RHAlinea)) gt 0) or (isdefined("url.DLlinea") and len(trim(url.DLlinea)) gt 0) or (isdefined("url.RHLPid") and len(trim(url.RHLPid)) gt 0)>
		<!------------- dias promedio parametrizados----->
		<cfset factorDias =0>
		
		<cfquery name="rsParametros" datasource="#Session.DSN#">
			select FactorDiasSalario as Pvalor
			from TiposNomina
			where Ecodigo = #session.Ecodigo#
			  and rtrim(ltrim(Tcodigo)) = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.Tcodigo)#">
		</cfquery>
		<cfif rsParametros.recordcount gt 0>
			<cfset factorDias =rsParametros.Pvalor>
		</cfif>	
		
		<cfif len(trim(rsParametros.Pvalor)) EQ 0 or rsParametros.RecordCount EQ 0>
			<cfquery name="rsParametros" datasource="#Session.DSN#">
				select Pvalor from RHParametros where Ecodigo = #session.Ecodigo# and Pcodigo = 80
			</cfquery>
			<cfif rsParametros.recordcount gt 0>
				<cfset factorDias =rsParametros.Pvalor>
			</cfif>	
		</cfif>
		
		<cfquery datasource="#session.dsn#" name="rsDatosConcepto">
			select CIcodigo, CIdescripcion
			from CIncidentes
			where CIid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CIid#">
		</cfquery>
			
		<!----- fin de valores parametrizados-------------->
</cfif>					
	
	
<!---- si se esta consultando una accion que no se ha aplicado------------->
<cfif isdefined("url.RHAlinea") and len(trim(url.RHAlinea)) gt 0>
	<cfquery datasource="#session.dsn#" name="rsAccion">
		select DEid, DLfvigencia
		from RHAcciones
		where RHAlinea=<cfqueryparam cfsqltype="cf_sql_numeric" value="#url.RHAlinea#">
	</cfquery>
	<cfset form.DEid=rsAccion.DEid>			 
		
		<cfquery name="local.checkSE" datasource="#session.dsn#">
			select count(1) as cant
			from RHSalPromAccionRAS b
			where b.RHAlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.RHAlinea#"> 	
			and b.CIid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CIid#">
			and coalesce(RHSPAsalarioescolar,0)>0
		</cfquery>
		
		<cfif local.checkSE.cant>
			<cfset local.IncluirSE=true>
		</cfif>

		<cfquery name="miSalarioPromedio" datasource="#session.dsn#">
			select b.RHSPAdias as cantPago,
				hrc.Tcodigo, hrc.RCDescripcion,RCdesde, RChasta, 
				cp.CPcodigo,
				coalesce(RHSPAsalariobruto,0) as SEsalariobruto, coalesce(RHSPAincidencias,0) as SEIncidencias, 
				coalesce(RHSPAcomponentes,0) as RHSPAcomponentes, 
				coalesce((coalesce(RHSPAsalariobruto,0) + coalesce(RHSPAincidencias,0) + coalesce(RHSPAcomponentes,0)<cfif local.IncluirSE>+coalesce(RHSPAsalarioescolar,0)</cfif>),0) as SESalMes,
				coalesce(
				(select coalesce(sum(coalesce(RHSPAsalariobruto,0) + coalesce(RHSPAincidencias,0) + coalesce(RHSPAcomponentes,0)<cfif local.IncluirSE>+coalesce(RHSPAsalarioescolar,0)</cfif>),0) / coalesce(sum(RHSPAdias),0) * <cfqueryparam cfsqltype="cf_sql_numeric" value="#factorDias#">
					from RHSalPromAccionRAS x
					where x.RHAlinea = b.RHAlinea
						and x.CIid =b.CIid
				),0) as SalarioPromedio,   <!---- se obtiene variable de salario promedio----->
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#factorDias#"> as factorDias,b.CIid
				<cfif local.IncluirSE>,coalesce(RHSPAsalarioescolar,0) as SEsalarioescolar</cfif>
				,cp.CPperiodo,cp.CPmes
			from RHSalPromAccionRAS b
				inner join HRCalculoNomina hrc
					on b.RCNid=hrc.RCNid	
				inner join CalendarioPagos cp
					on b.RCNid=cp.CPid
				inner join DatosEmpleado de
					on b.DEid=de.DEid	
			where b.RHAlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.RHAlinea#"> 	
			and b.CIid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CIid#">
			order by RCdesde desc, cp.CPperiodo*100+cp.CPmes desc
		</cfquery>
				
		<cfif miSalarioPromedio.recordcount gt 0>
			<cfset existeAplicado=true>	
		<cfelse>
			<cfquery datasource="#session.dsn#" name="rsDatosConcepto">
			select a.CIsprango, a.CIspcantidad, a.CImescompleto, b.CIcodigo, b.CIdescripcion, a.CImultiempresa
			from RHConceptosAccion a
				inner join CIncidentes b
					on a.CIid=b.CIid
			where RHAlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.RHAlinea#"> 	
			and a.CIid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CIid#">
			</cfquery>
		</cfif>
</cfif>

<!------ si se esta consultando una accion ya aplicada-------------------->
<cfif isdefined("url.DLlinea") and len(trim(url.DLlinea)) gt 0>
	<cfquery datasource="#session.dsn#" name="rsAccion">
		select DEid, DLfvigencia
		from DLaboralesEmpleado
		where DLlinea=<cfqueryparam cfsqltype="cf_sql_numeric" value="#url.DLlinea#">
	</cfquery>
	
	<cfset form.DEid=rsAccion.DEid>
	<cfset form.Fecha=rsAccion.DLfvigencia>
	
		<cfquery name="local.checkSE" datasource="#session.dsn#">
			select count(1) as cant
			from DLSalPromAccionRAS b
			where b.DLlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.DLlinea#"> 	
			and b.CIid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CIid#">
			and coalesce(RHSPAsalarioescolar,0)>0
		</cfquery>
		<cfif local.checkSE.cant>
			<cfset local.IncluirSE=true>
		</cfif>

	<cfquery name="miSalarioPromedio" datasource="#session.dsn#">
		select b.RHSPAdias as cantPago,
			hrc.Tcodigo, hrc.RCDescripcion,RCdesde, RChasta, 
			cp.CPcodigo,
			coalesce(RHSPAsalariobruto,0) as SEsalariobruto, coalesce(RHSPAincidencias,0) as SEIncidencias, 
			coalesce(RHSPAcomponentes,0) as RHSPAcomponentes, 
			coalesce((coalesce(RHSPAsalariobruto,0) + coalesce(RHSPAincidencias,0) + coalesce(RHSPAcomponentes,0)<cfif local.IncluirSE>+coalesce(RHSPAsalarioescolar,0)</cfif>),0) as SESalMes,
			coalesce(
			(select coalesce(sum(coalesce(RHSPAsalariobruto,0) + coalesce(RHSPAincidencias,0) + coalesce(RHSPAcomponentes,0)<cfif local.IncluirSE>+coalesce(RHSPAsalarioescolar,0)</cfif>),0) / 
						(case when coalesce(sum(RHSPAdias),0) = 0 then 1 else sum(RHSPAdias) end )
					* <cfqueryparam cfsqltype="cf_sql_numeric" value="#factorDias#">            
				from DLSalPromAccionRAS x
				where x.DLlinea = b.DLlinea
					and x.CIid =b.CIid
			),0) as SalarioPromedio,   <!---- se obtiene variable de salario promedio----->
		<cfqueryparam cfsqltype="cf_sql_numeric" value="#factorDias#"> as factorDias,b.CIid
		<cfif local.IncluirSE>,coalesce(RHSPAsalarioescolar,0) as SEsalarioescolar</cfif>
		,cp.CPperiodo,cp.CPmes
		from DLSalPromAccionRAS b
			inner join HRCalculoNomina hrc
				on b.RCNid=hrc.RCNid	
			inner join CalendarioPagos cp
				on b.RCNid=cp.CPid
			inner join DatosEmpleado de
				on b.DEid=de.DEid	
		where b.DLlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.DLlinea#"> 	
		and b.CIid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CIid#">
		order by RCdesde desc,cp.CPperiodo*100+cp.CPmes desc
	</cfquery>

	<cfif miSalarioPromedio.recordcount gt 0>
		<cfset existeAplicado=true>	
	<cfelse>
		<cfquery datasource="#session.dsn#" name="rsDatosConcepto">
		select a.CIsprango, a.CIspcantidad, a.CImescompleto, b.CIcodigo, b.CIdescripcion, a.CImultiempresa
		from DDConceptosEmpleado a
			inner join CIncidentes b
				on a.CIid=b.CIid
		where DLlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.DLlinea#"> 	
		and a.CIid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CIid#">
		</cfquery>
	</cfif>
</cfif>
		
<!------ Se si consulta desde una Proyeccion de Liquidacion -------------------->
<cfif isdefined("url.RHLPid") and len(trim(url.RHLPid)) gt 0>
	<cfquery datasource="#session.dsn#" name="rsProyeccion">
		select DEid, coalesce(EVfvacas, EVfantig) as EVfantig
		from EVacacionesEmpleado 
		where DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.DEid#">
	</cfquery>
	
	<cfset form.DEid=#url.DEid#>
	<cfset form.Fecha=#url.FechaCorte#>
	
	<cfquery name="miSalarioPromedio" datasource="#session.dsn#">
		select b.RHSPAdias as cantPago,
			hrc.Tcodigo, hrc.RCDescripcion,RCdesde, RChasta, 
			cp.CPcodigo,
			coalesce(RHSPAsalariobruto,0) as SEsalariobruto, coalesce(RHSPAincidencias,0) as SEIncidencias, 
			coalesce(RHSPAcomponentes,0) as RHSPAcomponentes, 
			coalesce((coalesce(RHSPAsalariobruto,0) + coalesce(RHSPAincidencias,0) + coalesce(RHSPAcomponentes,0)<cfif local.IncluirSE>+coalesce(RHSPAsalarioescolar,0)</cfif>),0) as SESalMes,
			coalesce(
			(select coalesce(sum(coalesce(RHSPAsalariobruto,0) + coalesce(RHSPAincidencias,0) + coalesce(RHSPAcomponentes,0)<cfif local.IncluirSE>+coalesce(RHSPAsalarioescolar,0)</cfif>),0) / 
						(case when coalesce(sum(RHSPAdias),0) = 0 then 1 else sum(RHSPAdias) end )
					* <cfqueryparam cfsqltype="cf_sql_numeric" value="#factorDias#">            
				from RHLPSalPromRAS x 
				where x.RHLPid = b.RHLPid 
					and x.CIid =b.CIid
			),0) as SalarioPromedio,   <!---- se obtiene variable de salario promedio----->
		<cfqueryparam cfsqltype="cf_sql_numeric" value="#factorDias#"> as factorDias,b.CIid
		<cfif local.IncluirSE>,coalesce(RHSPAsalarioescolar,0) as SEsalarioescolar</cfif>
		,cp.CPperiodo,cp.CPmes
		from RHLPSalPromRAS b
			inner join HRCalculoNomina hrc
				on b.RCNid=hrc.RCNid	
			inner join CalendarioPagos cp
				on b.RCNid=cp.CPid
			inner join DatosEmpleado de
				on b.DEid=de.DEid	
		where b.RHLPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.RHLPid#"> 	
		and b.CIid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.CIid#">
		 and b.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.DEid#">
		order by RCdesde desc,cp.CPperiodo*100+cp.CPmes desc
	</cfquery>

	<cfif miSalarioPromedio.recordcount gt 0>
		<cfset existeAplicado=true>	
	<cfelse>
		<cfquery datasource="#session.dsn#" name="rsDatosConcepto">
		select a.CIsprango, a.CIspcantidad, a.CImescompleto, b.CIcodigo, b.CIdescripcion, a.CImultiempresa
		from RHLPConceptosEmp a
			inner join CIncidentes b
				on a.CIid=b.CIid
		where a.RHLPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.RHLPid#"> 	
		and a.CIid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.CIid#">
		</cfquery>
	</cfif>
</cfif>

<cfif provieneReporte>
	<cfquery datasource="#session.dsn#" name="rsDatosConcepto">
	select a.CIsprango, a.CIspcantidad, a.CImescompleto, b.CIcodigo, b.CIdescripcion, a.CImultiempresa
	from CIncidentesD a
		inner join CIncidentes b
			on a.CIid=b.CIid
	where a.CIid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CIid#">
	</cfquery>
</cfif>


<!------------- se consulta por accion------------------------------------->
<cfif existeAplicado eq false>
		<cfinvoke component="rh.admin.catalogos.calculadora.variables.var_SalarioPromedioRAS" method="get" returnvariable="miSalarioPromedio">
			<cfinvokeargument name="DEid" value="#DEid#"/>
			<cfinvokeargument name="Ecodigo" value="#Ecodigo#"/>
			<cfif isdefined("arguments.RHAlinea") and len(trim(RHAlinea)) gt  0>
				<cfinvokeargument name="RHAlinea" value="#RHAlinea#"/>
			</cfif>	
			<cfif isdefined("url.DLlinea") and len(trim(url.DLlinea)) gt  0>
				<cfinvokeargument name="DLlinea" value="#url.DLlinea#"/>
			</cfif>
			<cfif isdefined("url.RHLPid") and len(trim(url.RHLPid)) gt  0>
				<cfinvokeargument name="RHLPid" value="#url.RHLPid#"/>					
			</cfif>		
			<cfinvokeargument name="CIid" value="#url.CIid#"/>	
			<cfinvokeargument name="FechaCorte" 	value="#form.Fecha#"/>
			<cfinvokeargument name="conexion" value="#session.dsn#">
			<cfif local.incluirSE>
				<cfinvokeargument name="incluirSalarioEscolar" value="true">
			</cfif>
			<cfinvokeargument name="report" value="true"/>
		</cfinvoke> 

</cfif>

<!-------- aplica para todas las consultas----------->
			
			
<cfquery datasource="#session.dsn#" name="rsDatosEmpleado">
	select DEnombre #concat#' '#concat# DEapellido1 #concat#' '#concat# DEapellido2 as NombreEmp
	from DatosEmpleado
	where DEid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid#">
</cfquery>
	

	
<!---------------------------------------------------------------------------- PINTADO DE LOS DATOS-------------------------------------------------->
	<cfinvoke component="sif.Componentes.Translate" method="Translate"
Key="LB_ReportSalarioPromedioRAS"
Default="Reporte de Salario Promedio RAS"
returnvariable="LB_ReportSalarioPromedioRAS"/>	


	<style type="text/css">
	#Table { border-width:1px;border-color:#ffffff;border-collapse:collapse;}
	#Table th {border-bottom: solid 1px #bbb;}
	#Table td {border-bottom: 1px solid #000; padding-left:0.4em;padding-right:0.4em}
	#Table tbody tr:nth-child(1) td:not(:first-child) { border-bottom: none; }
	#Table tbody tr:nth-child(2) td {border-bottom: none;}
	</style>

	<table width="99%" align="center" >
	
		<tr>
			<td colspan="17">
				<cfset miIrA="ReporteSalarioPromedio.cfm">

				<cfif isDefined("url.RHLPid") and len(trim(url.RHLPid)) gt 0>
					<cfset miIrA='/cfmx/rh/nomina/operacion/popUpReporteConceptosPago.cfm?CIid=#url.CIid#&RHLPid=#url.RHLPid#&DEid=#url.DEid#&FechaCorte=#url.FechaCorte#'>
				<cfelseif isdefined("url.ModoPopUp") and len(trim(url.ModoPopUp)) gt 0>
					<cfset miIrA='/cfmx/rh/nomina/operacion/popUpReporteConceptosPago.cfm?CIid=#url.CIid#&RHAlinea=#url.RHAlinea#&DLlinea=#url.DLlinea#'>
				</cfif>	
				<cfif isDefined("url.RHLPid") and len(trim(url.RHLPid)) gt 0>
					<cfset varParam='&RHLPid=#url.RHLPid#&DEid=#url.DEid#&CIid=#url.CIid#&FechaCorte=#url.FechaCorte#'>
				<cfelse>
					<cfset varParam= ''>
					<cfif isDefined("url.RHAlinea") and len(trim(url.RHAlinea)) gt 0>
						<cfset varParam='&RHAlinea=#url.RHAlinea#'>
					</cfif>
					<cfif isDefined("url.DLlinea") and len(trim(url.DLlinea)) gt 0>					
						<cfset varParam= varParam &'&DLlinea=#url.DLlinea#'>
					</cfif>					
				</cfif>	

					<cf_htmlReportsHeaders 
					title="Reporte de Salario Promedio RAS" 
					filename="Reporte_Salario_Promedio_RAS#dateformat(now(),'ddmmyyyy')#_#hour(now())#_#Minute(now())#_#second(now())#.xls"
					irA="#miIrA#"
					param = "#varParam#"
					>	
			</td>
		</tr>		
	</table>	
	<table width="99%" >

		<tr>
			<td colspan="17">
			<cf_EncReporte Titulo="#LB_ReportSalarioPromedioRAS# - #rsDatosEmpleado.NombreEmp#"Color="##E3EDEF">
			</td>
		</tr>
		
		<cfif  existeAplicado eq false and provieneReporte eq false>
		<tr><td colspan="17" align="left"></tr>
		<tr>
			<td colspan="17" align="left">
			<i><b><u>Este reporte ha recalculado el Salario Promedio del empleado en la fecha de la Acci&oacute;n, dado que &eacute;ste NO fue almacenado al momento de realizar la Acci&oacute;n</u></b></i>
			</td>
		</tr>
		<tr><td colspan="17" align="left"></tr>
		</cfif>	
		
		<tr>
			<td colspan="7" class="stitulo" align="left">
				Concepto de Pago:&nbsp;<cfoutput>#rsDatosConcepto.CIcodigo# - #rsDatosConcepto.CIdescripcion#</cfoutput>
			</td>
			<td colspan="8" class="stitulo" align="right">
				Vigencia:&nbsp;<cfoutput><cf_locale name="date" value="#form.Fecha#"/></cfoutput>
			</td>
		</tr>	
	</table>
	<table width="99%" id="Table" >
		<tr><td colspan="17">&nbsp;</td></tr>
		<tr class="stitulo">
			<td align="left">Periodo / Mes</td>			
			<td align="left">Calendario</td>			
			<td align="left">Descripcion</td>			
			<td align="left">Fecha desde</td>			
			<td align="left">Fecha hasta</td>			
			<td align="right">Salario Base</td>
			<td align="right">Concepto</td>
			<td align="right">Componente</td>
			<cfif local.incluirSE>
				<td align="right">Salario escolar</td>
			</cfif>
			<td align="right">Devengado</td>
			<td align="right">Días</td>
		</tr>	
<cfset Tsalariobase=0>
<cfset Tsalarioescolar=0>
<cfset Tconceptos=0>
<cfset Tcomponente=0>
<cfset Tdevengado=0>		
<cfset Tdias=0>	

<cfset TsalarioPromedio=0>
<cfset TfactorDias=0>

<cfset local.Periodos=structNew()>

<cfloop query="miSalarioPromedio">
	<cfset local.currentId=miSalarioPromedio.CPperiodo&'-'&right('00'&miSalarioPromedio.CPmes,2)>
	<cfif !structKeyExists(local.Periodos, local.currentId)>
		<cfset local.Periodos[local.currentId] = 0>
	</cfif>
	<cfset local.Periodos[local.currentId] += 1>
</cfloop>



<cfoutput query="miSalarioPromedio">
	<cfif isdefined("url.RHAlinea") and len(trim(url.RHAlinea)) gt 0>
		<tr>
			<cfset local.currentId=miSalarioPromedio.CPperiodo&'-'&right('00'&miSalarioPromedio.CPmes,2)>
			<cfif local.Periodos[local.currentId] >
				<td rowspan="#local.Periodos[local.currentId]#">#local.currentId#</td>
				<cfset local.Periodos[local.currentId]=0>
			</cfif>
			<td align="left">#CPcodigo#</td>
			<td align="left">#RCDescripcion#</td>
			<td align="left"><cf_locale name="date" value="#RCdesde#"/></td>
			<td align="left"><cf_locale name="date" value="#RChasta#"/></td>
			<td align="right">#LSNumberFormat(SEsalariobruto, ',9.00')#</td>
			<td align="right">#LSNumberFormat(SEIncidencias, ',9.00')#</td>
			<td align="right">#LSNumberFormat(RHSPAcomponentes, ',9.00')#</td>
			<cfif local.incluirSE>
				<td align="right">#LSNumberFormat(SEsalarioescolar, ',9.00')#</td>
			</cfif>
			<td align="right">#LSNumberFormat(SESalMes, ',9.00')#</td>
			<td align="right">#LSNumberFormat(cantPago, ',9.00')#</td>
		</tr>	
	
		<cfset Tsalariobase=Tsalariobase+SEsalariobruto>
		<cfif local.incluirSE>
			<cfset Tsalarioescolar+=SEsalarioescolar>	
		</cfif>
		
		<cfset Tconceptos=Tconceptos+SEIncidencias>
		<cfset Tcomponente=Tcomponente+RHSPAcomponentes>
		<cfset Tdevengado=Tdevengado+SESalMes>		
		<cfset Tdias=Tdias+cantPago>
		<cfset TsalarioPromedio=SalarioPromedio>
		<cfset TfactorDias=factorDias>			
	</cfif>
	
	<cfif isdefined("url.DLlinea") and len(trim(url.DLlinea)) gt 0>
		<tr>
			<cfset local.currentId=miSalarioPromedio.CPperiodo&'-'&right('00'&miSalarioPromedio.CPmes,2)>
			<cfif local.Periodos[local.currentId] >
				<td rowspan="#local.Periodos[local.currentId]#">#local.currentId#</td>
				<cfset local.Periodos[local.currentId]=0>
			</cfif>
			<td align="left">#CPcodigo#</td>
			<td align="left">#RCDescripcion#</td>
			<td align="left"><cf_locale name="date" value="#RCdesde#"/></td>
			<td align="left"><cf_locale name="date" value="#RChasta#"/></td>
			<td align="right">#LSNumberFormat(SEsalariobruto, ',9.00')#</td>
			<td align="right">#LSNumberFormat(SEIncidencias, ',9.00')#</td>
			<td align="right">#LSNumberFormat(RHSPAcomponentes, ',9.00')#</td>
			<cfif local.incluirSE>
				<td align="right">#LSNumberFormat(SEsalarioescolar, ',9.00')#</td>
			</cfif>
			<td align="right">#LSNumberFormat(SESalMes, ',9.00')#</td>
			<td align="right">#LSNumberFormat(cantPago, ',9.00')#</td>
		</tr>	
	
		<cfset Tsalariobase=Tsalariobase+SEsalariobruto>
		<cfif local.incluirSE>
			<cfset Tsalarioescolar+=SEsalarioescolar>	
		</cfif>
		
		<cfset Tconceptos=Tconceptos+SEIncidencias>
		<cfset Tcomponente=Tcomponente+RHSPAcomponentes>
		<cfset Tdevengado=Tdevengado+SESalMes>		
		<cfset Tdias=Tdias+cantPago>
		<cfset TsalarioPromedio=SalarioPromedio>
		<cfset TfactorDias=factorDias>	
	</cfif>
</cfoutput>
<cfoutput>
	<tr><td colspan="11"></td></tr>
	<tr class="stitulo">
		<td colspan="5">&nbsp;</td>
		<td align="right"><strong>#LSNumberFormat(Tsalariobase, ',9.00')#</strong></td>
		<td align="right"><strong>#LSNumberFormat(Tconceptos, ',9.00')#</strong></td>
		<td align="right"><strong>#LSNumberFormat(Tcomponente, ',9.00')#</strong></td>
		<cfif local.incluirSE>
			<td align="right"><strong>#LSNumberFormat(Tsalarioescolar, ',9.00')#</strong></td>				
		</cfif>
		<td align="right"><strong>#LSNumberFormat(Tdevengado, ',9.00')#</strong></td>
		<td align="right"><strong>#LSNumberFormat(Tdias, ',9.00')#</strong></td>
	</tr>
</cfoutput>
</table>

<table width="100%">
	<cfoutput>

	<tr><td>&nbsp;</td></tr>
	<tr><td>&nbsp;</td></tr>
	<cfif Tdias neq 0>
		<tr><td colspan="17"><hr /></td></tr>
		<tr><td colspan="17" align="left"><u>Salario Promedio Diario</u>&nbsp;&nbsp;&nbsp;=&nbsp;&nbsp;&nbsp;(<strong>#LSNumberFormat(Tdevengado, ',9.00')#</strong> /  <strong>#LSNumberFormat(Tdias, ',9.00')#</strong>)&nbsp;&nbsp;&nbsp;=&nbsp;&nbsp;&nbsp;<strong>#LSNumberFormat(Tdevengado/Tdias, ',9.00')#</strong></td></tr>
		<tr><td>&nbsp;</td></tr>
		<tr><td>&nbsp;</td></tr>
	</cfif>
	<tr><td colspan="17"><hr /></td></tr>
	<tr>
	
		<td colspan="17" align="center">
		<u>Salario Promedio : <strong>#LSNumberFormat(TsalarioPromedio, ',9.00')#</strong></u>
		</td>
	</tr>	
	<tr><td colspan="17"><hr /></td></tr>
	
	<cfif isdefined("url.ModoPopUp") and len(trim(url.ModoPopUp)) gt 0>
	<tr><td>&nbsp;</td></tr>
	<tr><td>&nbsp;</td></tr>
	<tr>
		<td colspan="17" align="center">
		<input type="button" class="btnNormal" 	name="btCerrar"   id="btCerrar" value="Cerrar" 		onClick="javascript: window.close();" />
		</td>
	</tr>
	<tr><td>&nbsp;</td></tr>
	<tr><td>&nbsp;</td></tr>
	</cfif>
	
	</cfoutput>
</table>