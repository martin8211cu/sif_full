<!--- ************************************************************* --->
<!---  				EXTRAE EL PERIODO POR DEFECTO 					--->
<!--- ************************************************************* --->
	<cfquery name="rsPeriodos" datasource="#Session.DSN#">
		select CPPid
		from CPresupuestoPeriodo p
		where p.Ecodigo = #Session.Ecodigo#
		  and p.CPPestado <> 0
	</cfquery>

	<cfparam name="form.CPPid"	default="#rsPeriodos.CPPid#">
	<cfset session.CPPid = form.CPPid>
<!--- ************************************************************* --->
<!---  				RS DEL COMBO DE ORIGENES 					    --->
<!--- ************************************************************* --->
	<cfquery name="rsORigenes" datasource="#Session.DSN#">
		select Oorigen,Odescripcion from Origenes
	</cfquery>
    <cfinclude template="../../Utiles/sifConcat.cfm">
<!--- ************************************************************* --->
<!---  				RS DEL COMBO DE MESES       					--->
<!--- ************************************************************* --->
	<cfquery name="rsMeses" datasource="#session.dsn#">
		select a.CPCano, a.CPCmes,
				<cf_dbfunction name="to_char" datasource="sifControl" args="a.CPCano"> #_Cat# ' - ' #_Cat#
				case a.CPCmes
					when 1 then 'Enero'
					when 2 then 'Febrero'
					when 3 then 'Marzo'
					when 4 then 'Abril'
					when 5 then 'Mayo'
					when 6 then 'Junio'
					when 7 then 'Julio'
					when 8 then 'Agosto'
					when 9 then 'Septiembre'
					when 10 then 'Octubre'
					when 11 then 'Noviembre'
					when 12 then 'Diciembre'
				end as descripcion
		  from CPmeses a
		 where a.Ecodigo = #session.ecodigo#
		   and a.CPPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CPPid#">
		 order by a.CPCano, a.CPCmes
	</cfquery>
	
<!--- ************************************************************* --->
<!--- ************************************************************* --->
<cfif isdefined("form.CFidOrigenIni")>
	<cfparam name="form.CFidIni" default="#form.CFidOrigenIni#">
	<cfparam name="form.CFidCFidOrigenIni" default="#form.CFidOrigenIni#">
<cfelseif isdefined("form.CFidCFidOrigenIni")>
	<cfparam name="form.CFidIni" default="#form.CFidCFidOrigenIni#">
	<cfparam name="form.CFidOrigenIni" default="#form.CFidCFidOrigenIni#">
<cfelse>
	<cfparam name="form.CFidIni" default="">
	<cfparam name="form.CFidCFidOrigenIni" default="#form.CFidIni#">
	<cfparam name="form.CFidOrigenIni" default="#form.CFidIni#">
</cfif>

<cfif isdefined("form.CFidOrigenFin")>
	<cfparam name="form.CFidFin" default="#form.CFidOrigenFin#">
	<cfparam name="form.CFidCFidOrigenFin" default="#form.CFidOrigenFin#">
<cfelseif isdefined("form.CFidCFidOrigenFin")>
	<cfparam name="form.CFidFin" default="#form.CFidCFidOrigenFin#">
	<cfparam name="form.CFidOrigenFin" default="#form.CFidCFidOrigenFin#">
<cfelse>
	<cfparam name="form.CFidFin" default="">
	<cfparam name="form.CFidCFidOrigenFin" default="#form.CFidFin#">
	<cfparam name="form.CFidOrigenFin" default="#form.CFidFin#">
</cfif>

<cfif isdefined("form.CFidDestIni")>
	<cfparam name="form.CFidCFidDestIni" default="#form.CFidDestIni#">
<cfelseif isdefined("form.CFidCFidDestIni")>
	<cfparam name="form.CFidDestIni" default="#form.CFidCFidDestIni#">
<cfelse>
	<cfparam name="form.CFidCFidDestIni" default="">
	<cfparam name="form.CFidDestIni" default="">
</cfif>

<cfif isdefined("form.CFidDestFin")>
	<cfparam name="form.CFidCFidDestFin" default="#form.CFidDestFin#">
<cfelseif isdefined("form.CFidCFidDestFin")>
	<cfparam name="form.CFidDestFin" default="#form.CFidCFidDestFin#">
<cfelse>
	<cfparam name="form.CFidCFidDestFin" default="">
	<cfparam name="form.CFidDestFin" default="">
</cfif>

<form name="form1" method="post" action="rptDocsPRES-imprimir.cfm" onSubmit="return sbSubmit();">
<table width="100%" border="0">
<!--- ************************************************************* --->
<!--- ************************************************************* --->
	<tr>
		<td width="23%" >
			Tipo Reporte:
		</td>
		<td colspan="3">
			<select name="CPTpoRep" onChange="javascript: this.form.action='';this.form.submit();">
					<option value="RE" <cfif form.CPTpoRep EQ "RE">selected</cfif>>Provisión Presupuestaria</option>
					<option value="LB" <cfif form.CPTpoRep EQ "LB">selected</cfif>>Liberación de Provisiones</option>
					<option value="TE" <cfif form.CPTpoRep EQ "TE">selected</cfif>>Traslados Internos Enviados</option>
					<option value="TR" <cfif form.CPTpoRep EQ "TR">selected</cfif>>Traslados Internos Recibidos</option>
					<option value="T1" <cfif form.CPTpoRep EQ "T1">selected</cfif>>Traslados con Autorizacion Externa Enviados</option>
					<option value="T2" <cfif form.CPTpoRep EQ "T2">selected</cfif>>Traslados con Autorizacion Externa Recibidos</option>
			</select>
		</td>
	</tr>
<!--- ************************************************************* --->
<!--- ************************************************************* --->
	<tr>
		<td>
			Período Presupuestario:
		</td>
		<td  colspan="3" >
		<cf_cboCPPid value="#session.CPPid#" CPPestado="1,2">
		</td>
	</tr>
<!--- ************************************************************* --->
<!--- ************************************************************* --->
	<cfswitch expression="#form.CPTpoRep#">
		<cfcase value="RE;LB"  delimiters=";">
			<tr>
				<td>
					Centro Funcional Inicial:
				</td>
				<cfparam name="form.CFidIni" default="">
				<td>
					<cf_CPSegUsu_cboCFid name="CFidIni" value="#form.CFidIni#" Consultar="true" Todas="B">
				</td>
				<td>
					&nbsp;&nbsp;&nbsp;&nbsp;Final:
				</td>
				<cfparam name="form.CFidFin" default="">
				<td>
					<cf_CPSegUsu_cboCFid name="CFidFin" value="#form.CFidFin#" Consultar="true" Todas="B"> 
				</td>				
			</tr>
		</cfcase>
		<cfcase value="TE;T1"  delimiters=";">
			<tr>
				<td>
					Centro Funcional Origen Inicial:
				</td>
				<cfparam name="form.CFidCFidOrigenIni" default="">
				<cfparam name="form.CFidOrigenIni" default="#form.CFidCFidOrigenIni#">
				<td>
					<cf_CPSegUsu_cboCFid name="CFidOrigenIni" value="#form.CFidOrigenIni#" Consultar="true" Todas="B">
				</td>
				<td>
					&nbsp;&nbsp;&nbsp;&nbsp;Final:
				</td>
				<cfparam name="form.CFidCFidOrigenFin" default="">
				<cfparam name="form.CFidOrigenFin" default="#form.CFidCFidOrigenFin#">
				<td>
					<cf_CPSegUsu_cboCFid name="CFidOrigenFin" value="#form.CFidOrigenFin#" Consultar="true" Todas="B">
				</td>				
			</tr>
			
			
			<tr>
				<td>
					Centro Funcional Destino Inicial:
				</td>
				<td>
					<cfquery name="rsCF" datasource="#Session.DSN#">
						select 	CFid 			as CFidCFidDestIni, 
								CFcodigo 		as CFcodigoCFidDestIni,
								CFdescripcion 	as CFdescripcionCFidDestIni
						  from CFuncional
						 where CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CFidCFidDestIni#" null="#form.CFidCFidDestIni EQ ''#">
					</cfquery>
					<cf_rhcfuncional form="form1" size="40" index="CFidDestIni" query="#rsCF#"> 
				</td>
				<td>
					&nbsp;&nbsp;&nbsp;&nbsp;Final:
				</td>
				<td>
					<cfquery name="rsCF" datasource="#Session.DSN#">
						select 	CFid 			as CFidCFidDestFin, 
								CFcodigo 		as CFcodigoCFidDestFin,
								CFdescripcion 	as CFdescripcionCFidDestFin
						  from CFuncional
						 where CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CFidCFidDestFin#" null="#form.CFidCFidDestFin EQ ''#">
					</cfquery>
					<cf_rhcfuncional form="form1" size="40" index="CFidDestFin" query="#rsCF#">
				</td>				
			</tr>
		</cfcase>
		<cfcase value="TR;T2"  delimiters=";">
			<tr>
				<td>
					Centro Funcional Origen Inicial:
				</td>
				<td>
					<cfquery name="rsCF" datasource="#Session.DSN#">
						select 	CFid 			as CFidCFidOrigenIni, 
								CFcodigo 		as CFcodigoCFidOrigenIni,
								CFdescripcion 	as CFdescripcionCFidOrigenIni
						  from CFuncional
						 where CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CFidCFidOrigenIni#" null="#form.CFidCFidOrigenIni EQ ''#">
					</cfquery>
					<cf_rhcfuncional form="form1" size="40" index="CFidOrigenIni" query="#rsCF#"> 
				</td>
				<td>
					&nbsp;&nbsp;&nbsp;&nbsp;Final:
				</td>
				<td>
					<cfquery name="rsCF" datasource="#Session.DSN#">
						select 	CFid 			as CFidCFidOrigenFin, 
								CFcodigo 		as CFcodigoCFidOrigenFin,
								CFdescripcion 	as CFdescripcionCFidOrigenFin
						  from CFuncional
						 where CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CFidCFidOrigenFin#" null="#form.CFidCFidOrigenFin EQ ''#">
					</cfquery>
					<cf_rhcfuncional form="form1" size="40" index="CFidOrigenFin" query="#rsCF#">
				</td>				
			</tr>		
			<tr>
				<td>
					Centro Funcional Destino Inicial:
				</td>
				<td>
					<cf_CPSegUsu_cboCFid name="CFidDestIni" value="#form.CFidDestIni#" Consultar="true" Todas="B">
				</td>
				<td>
					&nbsp;&nbsp;&nbsp;&nbsp;Final:
				</td>
				<td>
					<cf_CPSegUsu_cboCFid name="CFidDestFin" value="#form.CFidDestFin#" Consultar="true" Todas="B">
				</td>				
			</tr>		
			
		</cfcase>		
	</cfswitch>
	
<!--- ************************************************************* --->
<!--- ************************************************************* --->
	<tr>
		<td>
			Fecha Inicial:
		</td>
		<td width="19%">
			<cfparam name="form.FechaIni" default="">
			<cf_sifcalendario conexion="#session.DSN#" form="form1" name="FechaIni" value="#form.FechaIni#">
		</td>
		<td width="8%">
		   &nbsp;&nbsp;&nbsp;&nbsp;Final:
		</td>
		<td width="50%">
			<cfparam name="form.FechaFin" default="">
			<cf_sifcalendario conexion="#session.DSN#" form="form1" name="FechaFin" value="#form.FechaFin#">
		</td>
	</tr>		
<!--- ************************************************************* --->
<!--- ************************************************************* --->
	<tr>
		<td>
			Cuentas de Presupuesto :
		</td>
		<td>
			<cfparam name="form.CPformato1" default="">
			<cf_CuentaPresupuesto name="CPformato1" value="#form.CPformato1#">
		</td>
		<td>&nbsp;
		</td>
		<td>	
			<cfparam name="form.CPformato2" default="">
			<cf_CuentaPresupuesto name="CPformato2" value="#form.CPformato2#">
		</td>
	</tr>	
<!--- ************************************************************* --->
<!--- ************************************************************* --->
	<tr>
		<cf_btnImprimir name="rptDocsPRES" TipoPagina="Carta Horizontal (Letter Landscape)">
	</tr>
<!--- ************************************************************* --->
<!--- ************************************************************* --->
</table>
</form>
<script>
	var GvarSubmit = false;
	function sbSubmit()
	{
		GvarSubmit = true;
		return true;
	}
</script>