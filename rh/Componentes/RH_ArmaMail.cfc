<cfcomponent> 
<!--- VARIABLES DE TRADUCCION --->	
<cfinvoke Key="LB_Semanal" Default="Semanal" returnvariable="LB_Semanal" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="LB_Bisemanal" Default="Bisemanal"	 returnvariable="LB_Bisemanal" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="LB_Quincenal" Default="Quincenal"	 returnvariable="LB_Quincenal" component="sif.Componentes.Translate" method="Translate"/>
<!--- FIN VARIABLES DE TRADUCCION --->
<cffunction name="tituloMail" access="public" output="true">
	<cfargument name="RCNid" 	       type="numeric" 	required="yes">
	<!--- HRCalculoNomina --->
	<cfquery name="HRCalculoNomina" datasource="#Session.DSN#">
		select c.CPfpago, a.RCdesde, a.RChasta, a.RCDescripcion, b.Tdescripcion,a.Tcodigo,
		case Ttipopago when 0 then '#LB_Semanal#'
		when 1 then '#LB_Bisemanal#'
		when 2 then '#LB_Quincenal#'
		else ''
		end as   descripcion
		from HRCalculoNomina a
		
		inner join TiposNomina b
		on a.Tcodigo = b.Tcodigo
		
		inner join CalendarioPagos c
		on a.RCNid = c.CPid
		
		where a.RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.RCNid#">
	</cfquery>

	<cfset Titulo = "Boleta de Pago: " & HRCalculoNomina.RCDescripcion>
	<cfreturn #titulo#>
</cffunction>

<cffunction name="ArmaMail" access="public" output="true">
	<cfargument name="RCNid" 	       type="numeric" 	required="yes">
	<cfargument name="DEid" 	       type="numeric"   required="yes">
	<cfargument name="Tcodigo"         type="string" 	required="yes">
	<cfargument name="chkIncidencias"  type="numeric" 	required="yes">
	<cfargument name="chkCargas"       type="numeric" 	required="yes">
	<cfargument name="chkDeducciones"  type="numeric" 	required="yes">



<cfquery name="rsMostrarSalarioNominal" datasource="#session.DSN#">
	select coalesce(Pvalor,'0') as  Pvalor
	from RHParametros
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
	and Pcodigo = 1040
</cfquery>


<!--- ARMA EL EMAIL--->

<!--- Consultas --->
<!--- Monedas --->
<cfquery name="rsMoneda" datasource="#Session.DSN#">
	select Miso4217, Msimbolo 
	from Monedas a
	
	inner join TiposNomina c
	on a.Mcodigo = c.Mcodigo
	
	inner join HRCalculoNomina b
	on b.Tcodigo = c.Tcodigo 
	
	where b.RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.RCNid#">
</cfquery>

<!--- HSalarioEmpleado --->
<cfquery name="rsSE" datasource="#Session.DSN#">
	select SEcalculado
	from HSalarioEmpleado 
	where RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.RCNid#">
	and DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.DEid#">
</cfquery>

<!--- HRCalculoNomina --->
<cfquery name="HRCalculoNomina" datasource="#Session.DSN#">
	select c.CPfpago, a.RCdesde, a.RChasta, a.RCDescripcion, b.Tdescripcion,a.Tcodigo,
	case Ttipopago when 0 then '#LB_Semanal#'
	when 1 then '#LB_Bisemanal#'
	when 2 then '#LB_Quincenal#'
	else ''
	end as   descripcion
	from HRCalculoNomina a
	
	inner join TiposNomina b
	on a.Tcodigo = b.Tcodigo
	
	inner join CalendarioPagos c
	on a.RCNid = c.CPid
	
	where a.RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.RCNid#">
</cfquery>

<!--- Empresa --->
<cfquery name="rsEmpresa" datasource="#session.DSN#">
	select Edescripcion
	from Empresas
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
</cfquery>
 <cfset Titulo = tituloMail(#arguments.RCNid#)>

<cfsavecontent variable="info">
<cfoutput>
<html>
<head>
<title>#Titulo#</title>
</head>
<body>
<table width="97%" border="0" cellspacing="0" cellpadding="0" align="center" style="padding-left: 5px; padding-right: 5px;">
		<tr style="padding: 3px;">
			<td nowrap align="center"><font size="4"><b>#rsEmpresa.Edescripcion#</b></font>
			</td>
		</tr>
</table>

<table width="97%" border="0" cellspacing="0" cellpadding="0" align="center" style="padding-left: 5px; padding-right: 5px;">
	<tr bgcolor="##EEEEEE" style="padding: 3px;">
		<td nowrap align="center"><font size="3"><b>#Titulo#</b></font>
		</td>
	</tr>
</table>
<cf_dbfunction name="op_concat" returnvariable="LvarCNCT">
<cfif isdefined('form.DEid')>
	<cfquery name="rsEncabEmpleado" datasource="#Session.DSN#">
		select (DEapellido1 #LvarCNCT# ' ' #LvarCNCT# DEapellido2 #LvarCNCT# ', ' #LvarCNCT# DEnombre) as nombreEmpl, DEemail, DEidentificacion, NTIdescripcion
		from DatosEmpleado de
		
		inner join NTipoIdentificacion ti
		on de.NTIcodigo=ti.NTIcodigo
		
		where de.DEid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid#">
	</cfquery>
</cfif>

<!--- Encabezado con los datos del empleado --->
<cfif isdefined('rsEncabEmpleado')>
  <cfoutput> 
    <table width="100%" border="0" cellspacing="6" cellpadding="6">
      <tr>
		<td nowrap valign="top">
			<table width="100%" height="100%" border="0" cellpadding="6" cellspacing="0" style = "font-family: Verdana, Arial, Helvetica, sans-serif;	border: 1px solid ##000000;">
			  <tr> 
				<td nowrap colspan="2" align="center" style="font : bold 70% tahoma,arial,Geneva,Helvetica,sans-serif;font-size: 11px;font-weight: bold;background-position: center;padding-top : 2px;padding-bottom : 1px;font-variant: small-caps;text-transform: capitalize;">Informaci&oacute;n del Empleado</td>
			  </tr>
			  <tr> 
				<td nowrap width="33%" style="font-family: Verdana, Arial, Helvetica, sans-serif;font-style: normal;font-weight: bold;padding-right: 10px; font-size:10px;">Nombre completo</td>
				<td nowrap width="67%">#rsEncabEmpleado.nombreEmpl#</td>
			  </tr>
			  <tr> 
				<td nowrap style="font-family: Verdana, Arial, Helvetica, sans-serif;font-style: normal;font-weight: bold;padding-right: 10px; font-size:10px;">#rsEncabEmpleado.NTIdescripcion#</td>
				<td>#rsEncabEmpleado.DEidentificacion#</td>
			  </tr>
		  </table>		
		</td>
      </tr>
    </table>
  </cfoutput> 
</cfif>


<br>
<!--- ========================= Informacion de la Nómina ========================= ---> 
<table width="97%" border="0" cellspacing="0" cellpadding="0" style="padding-left: 5px; padding-right: 5px;" align="center">
	<tr>
		<td nowrap style="font-family: Verdana, Arial, Helvetica, sans-serif;font-style: normal;font-weight: bold;padding-right: 10px; font-size:10px;" align="right">
			Tipo de Nómina :&nbsp;
		</td>
		<td nowrap  align="left" style="font-family: Verdana, Arial, Helvetica, sans-serif;font-style: normal;padding-right: 10px; font-size:10px;">
			#HRCalculoNomina.Tdescripcion#
		</td>
		<td nowrap style="font-family: Verdana, Arial, Helvetica, sans-serif;font-style: normal;font-weight: bold;padding-right: 10px; font-size:10px;" align="right">
			Pago :&nbsp;
		</td>
		<td nowrap  align="left" style="font-family: Verdana, Arial, Helvetica, sans-serif;font-style: normal;padding-right: 10px; font-size:10px;">
			#LSDateFormat(HRCalculoNomina.CPfpago,'dd/mm/yyyy')#
		</td>
		<td nowrap style="font-family: Verdana, Arial, Helvetica, sans-serif;font-style: normal;font-weight: bold;padding-right: 10px; font-size:10px;" align="right">
			Desde :&nbsp;
		</td>
		<td nowrap  align="left" style="font-family: Verdana, Arial, Helvetica, sans-serif;font-style: normal;padding-right: 10px; font-size:10px;">
			#LSDateFormat(HRCalculoNomina.RCdesde,'dd/mm/yyyy')#
		</td>
		<td nowrap style="font-family: Verdana, Arial, Helvetica, sans-serif;font-style: normal;font-weight: bold;padding-right: 10px; font-size:10px;" align="right">
			Hasta :&nbsp;
		</td>
		<td nowrap align="left" style="font-family: Verdana, Arial, Helvetica, sans-serif;font-style: normal;padding-right: 10px; font-size:10px;">
			#LSDateFormat(HRCalculoNomina.RChasta,'dd/mm/yyyy')#
		</td>
	</tr>
</table>
<br>


<!--- ========================= Informacion Resumida ========================= ---> 
<table width="97%" border="0" cellspacing="0" cellpadding="0" style = "font-family: Verdana, Arial, Helvetica, sans-serif;	border: 1px solid ##000000; padding-left: 5px; padding-right: 5px;" align="center">
	<tr><td nowrap colspan="8" style="font : bold 70% tahoma,arial,Geneva,Helvetica,sans-serif;font-size: 11px;font-weight: bold;background-position: center;padding-top : 2px;padding-bottom : 1px;font-variant: small-caps;text-transform: capitalize;"><div align="center"><font size="2">Informaci&oacute;n
	        Resumida</font></div></td></tr>
	<cfquery name="rsSalarioEmpleado" datasource="#Session.DSN#">
		select SEsalariobruto, SEincidencias, SErenta, SEcargasempleado, SEcargaspatrono, SEdeducciones, SEliquido
		from HSalarioEmpleado 
		where RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RCNid#">
		  and DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.DEid#">
	</cfquery>
	<cfif rsSalarioEmpleado.RecordCount gt 0 >
		<tr>
			<td nowrap style="font-family: Verdana, Arial, Helvetica, sans-serif;font-style: normal;font-weight: bold;padding-right: 10px; font-size:10px;"><div align="right">Salario Bruto:&nbsp;</div></td>
			<cfif rsMostrarSalarioNominal.Pvalor eq 1>
				<cfif HRCalculoNomina.Tcodigo neq 3>
					<td nowrap style="font-family: Verdana, Arial, Helvetica, sans-serif;font-style: normal;font-weight: bold;padding-right: 10px; font-size:10px;"><div align="right"><cf_translate  key="LB_Salario">Salario</cf_translate>&nbsp;#HRCalculoNomina.descripcion#:&nbsp;</div></td>
				</cfif>
			 </cfif>
			<td nowrap style="font-family: Verdana, Arial, Helvetica, sans-serif;font-style: normal;font-weight: bold;padding-right: 10px; font-size:10px;"><div align="right">Incidencias:&nbsp;</div></td>
			<td nowrap style="font-family: Verdana, Arial, Helvetica, sans-serif;font-style: normal;font-weight: bold;padding-right: 10px; font-size:10px;"><div align="right">Renta:&nbsp;</div></td>
			<td nowrap style="font-family: Verdana, Arial, Helvetica, sans-serif;font-style: normal;font-weight: bold;padding-right: 10px; font-size:10px;"><div align="right">Cargas Empleado:&nbsp;</div></td>
			<td nowrap style="font-family: Verdana, Arial, Helvetica, sans-serif;font-style: normal;font-weight: bold;padding-right: 10px; font-size:10px;"><div align="right">Deducciones:&nbsp;</div></td>
			<td nowrap style="font-family: Verdana, Arial, Helvetica, sans-serif;font-style: normal;font-weight: bold;padding-right: 10px; font-size:10px;"><div align="right">Salario Líquido:&nbsp;</div></td>
		</tr>

		<tr>
			<td nowrap align="right" style="font-family: Verdana, Arial, Helvetica, sans-serif;font-style: normal;padding-right: 10px; font-size:10px;">#rsMoneda.Msimbolo# #LSCurrencyFormat(rsSalarioEmpleado.SEsalariobruto,'none')#</td>
			<cfif rsMostrarSalarioNominal.Pvalor eq 1>
				<cfif HRCalculoNomina.Tcodigo neq 3>
					<cfquery name="rsLineaTiempo" datasource="#Session.DSN#">
						select LTsalario from LineaTiempo
						where <cfqueryparam cfsqltype="cf_sql_date" value="#HRCalculoNomina.RCdesde#"> between LTdesde and LThasta
						and DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.DEid#">
					</cfquery>
					<cfif rsLineaTiempo.recordCount EQ 0>
						<cfquery name="rsLineaTiempo" datasource="#Session.DSN#">
							select LTsalario from LineaTiempo
							where DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.DEid#">
							and LThasta =    (select max(LThasta) from LineaTiempo  where DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.DEid#">)
						</cfquery>
					</cfif>
					
					
					<cfinvoke component="rh.Componentes.RH_Funciones" 
						method="salarioTipoNomina"
						salario = "#rsLineaTiempo.LTsalario#"
						Tcodigo = "#HRCalculoNomina.Tcodigo#"
						returnvariable="var_salarioTipoNomina">
						<td nowrap align="right" style="font-family: Verdana, Arial, Helvetica, sans-serif;font-style: normal;padding-right: 10px; font-size:10px;">#rsMoneda.Msimbolo# #LSCurrencyFormat(var_salarioTipoNomina,'none')#</td>
				</cfif>
			 </cfif>			
			<td nowrap align="right" style="font-family: Verdana, Arial, Helvetica, sans-serif;font-style: normal;padding-right: 10px; font-size:10px;">#rsMoneda.Msimbolo# #LSCurrencyFormat(rsSalarioEmpleado.SEincidencias,'none')#</td>
			<td nowrap align="right" style="font-family: Verdana, Arial, Helvetica, sans-serif;font-style: normal;padding-right: 10px; font-size:10px;">#rsMoneda.Msimbolo# #LSCurrencyFormat(rsSalarioEmpleado.SErenta,'none')#</td>
			<td nowrap align="right" style="font-family: Verdana, Arial, Helvetica, sans-serif;font-style: normal;padding-right: 10px; font-size:10px;">#rsMoneda.Msimbolo# #LSCurrencyFormat(rsSalarioEmpleado.SEcargasempleado,'none')#</td>
			<td nowrap align="right" style="font-family: Verdana, Arial, Helvetica, sans-serif;font-style: normal;padding-right: 10px; font-size:10px;">#rsMoneda.Msimbolo# #LSCurrencyFormat(rsSalarioEmpleado.SEdeducciones,'none')#</td>
			<td nowrap align="right" style="font-family: Verdana, Arial, Helvetica, sans-serif;font-style: normal;padding-right: 10px; font-size:10px;">#rsMoneda.Msimbolo# #LSCurrencyFormat(rsSalarioEmpleado.SEliquido,'none')#</td>
		</tr>
		<cfelse>
		<tr><td nowrap colspan="6" align="center">No hay Pagos asociados al empleado</td></tr>
	</cfif>	
</table>
<!--- ========================= Informacion Resumida - FIN ========================= ---> 
<br>
  <table width="97%" border="0" cellspacing="0" cellpadding="0" style = "font-family: Verdana, Arial, Helvetica, sans-serif;	border: 1px solid ##000000; padding-left: 5px; padding-right: 5px;" align="center">
    <tr><td nowrap colspan="8" style="font : bold 70% tahoma,arial,Geneva,Helvetica,sans-serif;font-size: 11px;font-weight: bold;background-position: center;padding-top : 2px;padding-bottom : 1px;font-variant: small-caps;text-transform: capitalize;"><div align="center"><font size="2">Informaci&oacute;n
            Detallada</font></div></td></tr>

    <!--- ======================= Salarios ======================== --->
	<cfset vDias = 1 >
	
	<cfquery name="rsDias" datasource="#Session.DSN#">
		select <cf_dbfunction name="to_float" args="FactorDiasSalario"> as dias
		from TiposNomina t, HRCalculoNomina r
		where t.Ecodigo = r.Ecodigo
		  and t.Tcodigo = r.Tcodigo
		  and r.RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RCNid#">
		  and r.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	</cfquery>

	<cfif len(trim(rsDias.dias)) eq 0 >
		<cfquery name="rsDias" datasource="#Session.DSN#">
			select Pvalor as dias
			from RHParametros 
			where Pcodigo = 80 --Número de días para el Cálculo de la Nómina Mensual
			and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		</cfquery>
	</cfif>
	
	<cfif rsDias.recordCount gt 0 and len(trim(rsDias.dias))>
		<cfset vDias = rsDias.dias >
	</cfif>
	
	<cfquery name="rsPagosEmpleado" datasource="#Session.DSN#">
		select 	a.PEdesde, a.PEhasta, a.PEsalario, 
				round((a.PEsalario/<cfqueryparam cfsqltype="cf_sql_float" value="#vDias#">),2) as PEdiario,
				a.PEcantdias, a.PEmontores, a.PEtiporeg, b.RHTcodigo
		from HPagosEmpleado a, RHTipoAccion b 
		where a.RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RCNid#">
		and a.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.DEid#">
	    and a.RHTid=b.RHTid
		order by a.PEdesde, a.PEhasta
	</cfquery>

	<cfquery name="rsPagosEmpleado_0" dbtype="query">
		select * from rsPagosEmpleado where PEtiporeg = 0
	</cfquery>
	<cfquery name="rsPagosEmpleado_1" dbtype="query">
		select * from rsPagosEmpleado where PEtiporeg = 1
	</cfquery>
	<cfquery name="rsPagosEmpleado_2" dbtype="query">
		select * from rsPagosEmpleado where PEtiporeg = 2
	</cfquery>

	<tr><td nowrap colspan="8" style="font-weight: bolder;text-align: center;vertical-align: middle;padding: 2px;	background-color: ##DFDFDF;">Salarios</td></tr>

	<cfif rsPagosEmpleado_0.RecordCount gt 0>
		<tr>
			<td nowrap align="left" style="font-family: Verdana, Arial, Helvetica, sans-serif;font-style: normal;font-weight: bold;padding-right: 10px; font-size:10px;">Fecha Desde</td>
			<td nowrap align="left" style="font-family: Verdana, Arial, Helvetica, sans-serif;font-style: normal;font-weight: bold;padding-right: 10px; font-size:10px;">Fecha Hasta</td>
			<td nowrap align="left" style="font-family: Verdana, Arial, Helvetica, sans-serif;font-style: normal;font-weight: bold;padding-right: 10px; font-size:10px;">C&oacute;digo Acci&oacute;n</td>
			<td nowrap align="right" style="font-family: Verdana, Arial, Helvetica, sans-serif;font-style: normal;font-weight: bold;padding-right: 10px; font-size:10px;">Salario</td>
			<td nowrap align="right" style="font-family: Verdana, Arial, Helvetica, sans-serif;font-style: normal;font-weight: bold;padding-right: 10px; font-size:10px;">Salario Diario</td>
			<td nowrap align="right" style="font-family: Verdana, Arial, Helvetica, sans-serif;font-style: normal;font-weight: bold;padding-right: 10px; font-size:10px;">D&iacute;as</td>
			<td nowrap align="right" style="font-family: Verdana, Arial, Helvetica, sans-serif;font-style: normal;font-weight: bold;padding-right: 10px; font-size:10px;">Monto</td>
			<td nowrap align="right" style="font-family: Verdana, Arial, Helvetica, sans-serif;font-style: normal;font-weight: bold;padding-right: 10px; font-size:10px;">&nbsp;</td>
		</tr>
	
		<cfloop query="rsPagosEmpleado_0">
			<tr style=<cfif CurrentRow MOD 2>"text-indent: 10px; vertical-align: middle" <cfelse>"background-color: ##FAFAFA; vertical-align: middle; text-indent: 10px"</cfif>>
				<td nowrap align="left" style="font-family: Verdana, Arial, Helvetica, sans-serif;font-style: normal;padding-right: 10px; font-size:10px;">#LSDateFormat(PEdesde,'dd/mm/yyyy')#</td>
				<td nowrap align="left" style="font-family: Verdana, Arial, Helvetica, sans-serif;font-style: normal;padding-right: 10px; font-size:10px;">#LSDateFormat(PEhasta,'dd/mm/yyyy')#</td>
				<td nowrap align="left" style="font-family: Verdana, Arial, Helvetica, sans-serif;font-style: normal;padding-right: 10px; font-size:10px;">#RHTcodigo#</td>
				<td nowrap align="right" style="font-family: Verdana, Arial, Helvetica, sans-serif;font-style: normal;padding-right: 10px; font-size:10px;">#rsMoneda.Msimbolo# #LSCurrencyFormat(PEsalario,'none')# </td>
				<td nowrap align="right" style="font-family: Verdana, Arial, Helvetica, sans-serif;font-style: normal;padding-right: 10px; font-size:10px;">#rsMoneda.Msimbolo# #LSCurrencyFormat(PEdiario,'none')# </td>
				<td nowrap align="right" style="font-family: Verdana, Arial, Helvetica, sans-serif;font-style: normal;padding-right: 10px; font-size:10px;">#PEcantdias#</td>
				<td nowrap align="right" style="font-family: Verdana, Arial, Helvetica, sans-serif;font-style: normal;padding-right: 10px; font-size:10px;">#rsMoneda.Msimbolo# #LSCurrencyFormat(PEmontores,'none')# </td>
				<td nowrap align="right" style="font-family: Verdana, Arial, Helvetica, sans-serif;font-style: normal;padding-right: 10px; font-size:10px;">&nbsp;</td>
			</tr>
		</cfloop>
	<cfelse>		
		<tr><td nowrap colspan="8" align="center"><b>No hay Pagos asociados al empleado</b></td></tr>
	</cfif>
    <!--- ======================= Salarios - FIN ======================== --->
	
	 <!--- ======================= Retroactivos - INI ======================== --->
	<cfif rsPagosEmpleado_1.RecordCount GT 0>
		<tr>
			<td nowrap colspan="8" style="font : bold 70% tahoma,arial,Geneva,Helvetica,sans-serif;font-size: 11px;font-style: normal;font-weight: bold;background-image: url(/cfmx/rh/imagenes/p_ocean.gif);background-position: center;padding-top : 2px;padding-bottom : 1px;font-variant: small-caps;text-transform: capitalize;color: ##FFFFFF;"><div align="center"><strong>Retroactivos Recalculados</strong></div></td>
		</tr>
		<cfloop query="rsPagosEmpleado_1">
			<tr style=<cfif CurrentRow MOD 2>"text-indent: 10px; vertical-align: middle" <cfelse>"background-color: ##FAFAFA; vertical-align: middle; text-indent: 10px"</cfif>>
				<td nowrap align="left" >#LSDateFormat(PEdesde,'dd/mm/yyyy')#</td>
				<td nowrap align="left" >#LSDateFormat(PEhasta,'dd/mm/yyyy')#</td>
				<td nowrap align="left" >#RHTcodigo#</td>
				<td nowrap align="right" >#rsMoneda.Msimbolo# #LSCurrencyFormat(PEsalario,'none')# </td>
				<td nowrap align="right" >#rsMoneda.Msimbolo# #LSCurrencyFormat(PEdiario,'none')# </td>
				<td nowrap align="right" >#PEcantdias#</td>
				<td nowrap align="right" >#rsMoneda.Msimbolo# #LSCurrencyFormat(PEmontores,'none')# </td>
				<td nowrap align="right" >&nbsp;</td>
			</tr>
		</cfloop>
	</cfif>
	<cfif rsPagosEmpleado_2.RecordCount gt 0>
		<tr>
			<td nowrap colspan="8" style="font : bold 70% tahoma,arial,Geneva,Helvetica,sans-serif;font-size: 11px;font-style: normal;font-weight: bold;background-image: url(/cfmx/rh/imagenes/p_ocean.gif);background-position: center;padding-top : 2px;padding-bottom : 1px;font-variant: small-caps;text-transform: capitalize;color: ##FFFFFF;"><div align="center"><strong>Retroactivos ya Pagados</strong></div></td>
		</tr>
		<cfloop query="rsPagosEmpleado_2">
			<tr style=<cfif CurrentRow MOD 2>"text-indent: 10px; vertical-align: middle" <cfelse>"background-color: ##FAFAFA; vertical-align: middle; text-indent: 10px"</cfif>>
				<td nowrap align="left" style="font-family: Verdana, Arial, Helvetica, sans-serif;font-style: normal;padding-right: 10px; font-size:10px;">b#LSDateFormat(PEdesde,'dd/mm/yyyy')#</td>
				<td nowrap align="left" style="font-family: Verdana, Arial, Helvetica, sans-serif;font-style: normal;padding-right: 10px; font-size:10px;">v#LSDateFormat(PEhasta,'dd/mm/yyyy')#</td>
				<td nowrap align="left" style="font-family: Verdana, Arial, Helvetica, sans-serif;font-style: normal;padding-right: 10px; font-size:10px;">c#RHTcodigo#</td>
				<td nowrap align="right" style="font-family: Verdana, Arial, Helvetica, sans-serif;font-style: normal;padding-right: 10px; font-size:10px;">b#rsMoneda.Msimbolo# #LSCurrencyFormat(PEsalario,'none')# </td>
				<td nowrap align="right" style="font-family: Verdana, Arial, Helvetica, sans-serif;font-style: normal;padding-right: 10px; font-size:10px;">b#rsMoneda.Msimbolo# #LSCurrencyFormat(PEdiario,'none')# </td>
				<td nowrap align="right" style="font-family: Verdana, Arial, Helvetica, sans-serif;font-style: normal;padding-right: 10px; font-size:10px;">f#PEcantdias#</td>
				<td nowrap align="right" style="font-family: Verdana, Arial, Helvetica, sans-serif;font-style: normal;padding-right: 10px; font-size:10px;">y#rsMoneda.Msimbolo# #LSCurrencyFormat(PEmontores,'none')# </td>
				<td nowrap align="right" style="font-family: Verdana, Arial, Helvetica, sans-serif;font-style: normal;padding-right: 10px; font-size:10px;">&nbsp;</td>
			</tr>
		</cfloop>
	</cfif>
	 <!--- ======================= Retroactivos - FIN ======================== --->

    <!--- ======================= Incidencias ======================== --->
    <tr valign="top"> 
      <td nowrap colspan="8">&nbsp;</td>
    </tr>
	<cfquery name="rsIncidenciasCalculo" datasource="#Session.DSN#">
		select ICid, b.CIdescripcion, a.ICfecha, a.ICvalor, a.ICmontores, a.ICcalculo
		from HIncidenciasCalculo a
		
		inner join CIncidentes b
		on a.CIid = b.CIid
		
		where RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RCNid#">
		and DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.DEid#">
		order by a.ICfecha
	</cfquery>

	<tr><td nowrap colspan="8" style="font-weight: bolder;text-align: center;vertical-align: middle;padding: 2px;	background-color: ##DFDFDF;">Incidencias</td></tr>
	
	<cfif rsIncidenciasCalculo.RecordCount gt 0>
		<tr> 
			<td nowrap align="left" style="font-family: Verdana, Arial, Helvetica, sans-serif;font-style: normal;font-weight: bold;padding-right: 10px; font-size:10px;">Fecha</td>
			<td nowrap align="left" style="font-family: Verdana, Arial, Helvetica, sans-serif;font-style: normal;font-weight: bold;padding-right: 10px; font-size:10px;" colspan="3">Concepto</td>
			<td nowrap align="left" style="font-family: Verdana, Arial, Helvetica, sans-serif;font-style: normal;font-weight: bold;padding-right: 10px; font-size:10px;" >&nbsp;</td>
			<td nowrap align="right" style="font-family: Verdana, Arial, Helvetica, sans-serif;font-style: normal;font-weight: bold;padding-right: 10px; font-size:10px;">Valor</td>
			<td nowrap align="right" style="font-family: Verdana, Arial, Helvetica, sans-serif;font-style: normal;font-weight: bold;padding-right: 10px; font-size:10px;">Monto</td>
			<td nowrap align="right" style="font-family: Verdana, Arial, Helvetica, sans-serif;font-style: normal;font-weight: bold;padding-right: 10px; font-size:10px;">&nbsp;</td>
		</tr>
		<cfloop query="rsIncidenciasCalculo">
			<tr style=<cfif CurrentRow MOD 2>"text-indent: 10px; vertical-align: middle" <cfelse>"background-color: ##FAFAFA; vertical-align: middle; text-indent: 10px"</cfif> > 
				<td nowrap align="left" style="font-family: Verdana, Arial, Helvetica, sans-serif;font-style: normal;padding-right: 10px; font-size:10px;">#LSDateFormat(ICfecha,'dd/mm/yyyy')#</td>
				<td nowrap align="left" colspan="3" style="font-family: Verdana, Arial, Helvetica, sans-serif;font-style: normal;padding-right: 10px; font-size:10px;">#CIdescripcion#</td>
				<td nowrap align="left" style="font-family: Verdana, Arial, Helvetica, sans-serif;font-style: normal;padding-right: 10px; font-size:10px;">&nbsp;</td>
				<td nowrap align="right" style="font-family: Verdana, Arial, Helvetica, sans-serif;font-style: normal;padding-right: 10px; font-size:10px;">#ICvalor#</td>
				<td nowrap align="right" style="font-family: Verdana, Arial, Helvetica, sans-serif;font-style: normal;padding-right: 10px; font-size:10px;">#rsMoneda.Msimbolo# #LSCurrencyFormat(ICmontores,'none')# </td>
				<td nowrap align="right" style="font-family: Verdana, Arial, Helvetica, sans-serif;font-style: normal;padding-right: 10px; font-size:10px;"><cfif ICcalculo eq 1><img border="0" src="http://websdc/cfmx/rh/imagenes/Cferror.gif"></cfif></td>
			</tr>
		</cfloop>
	<cfelse>		
		<tr><td nowrap colspan="8" align="center"><b>No hay Incidencias asociadas al Empleado</b></td></tr>
	</cfif>
    <!--- ======================= Incidencias - FIN ======================== --->

    <!--- ======================= Cargas ======================== --->

    <tr valign="top"> 
      <td nowrap colspan="8">&nbsp;</td>
    </tr>

	<cfquery name="rsCargasCalculo" datasource="#Session.DSN#">
		select a.DClinea, CCvaloremp, CCvalorpat, DCdescripcion, ECauto
		from HCargasCalculo a
		
		inner join DCargas b
		on a.DClinea = b.DClinea
		
		inner join ECargas c
		on b.ECid = c.ECid
		
		where RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RCNid#">
		  and DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.DEid#">
	</cfquery>

	<tr><td nowrap colspan="8" style="font-weight: bolder;text-align: center;vertical-align: middle;padding: 2px;	background-color: ##DFDFDF;">Cargas</td></tr>

	<cfif rsCargasCalculo.RecordCount gt 0>
		<tr>
			<td nowrap align="left" style="font-family: Verdana, Arial, Helvetica, sans-serif;font-style: normal;font-weight: bold;padding-right: 10px; font-size:10px;" colspan="4">Descripci&oacute;n</td>
			<td nowrap align="left" style="font-family: Verdana, Arial, Helvetica, sans-serif;font-style: normal;font-weight: bold;padding-right: 10px; font-size:10px;">&nbsp;</td>
			<td nowrap align="right" style="font-family: Verdana, Arial, Helvetica, sans-serif;font-style: normal;font-weight: bold;padding-right: 10px; font-size:10px;">Monto Patrono</td>
			<td nowrap align="right" style="font-family: Verdana, Arial, Helvetica, sans-serif;font-style: normal;font-weight: bold;padding-right: 10px; font-size:10px;">Monto Empleado</td>
			<td nowrap align="right" style="font-family: Verdana, Arial, Helvetica, sans-serif;font-style: normal;font-weight: bold;padding-right: 10px; font-size:10px;">&nbsp;</td>
		</tr>
		<cfloop query="rsCargasCalculo">
			<tr style=<cfif CurrentRow MOD 2>"text-indent: 10px; vertical-align: middle" <cfelse>"background-color: ##FAFAFA; vertical-align: middle; text-indent: 10px"</cfif>>
				<td nowrap align="left" colspan="4" style="font-family: Verdana, Arial, Helvetica, sans-serif;font-style: normal;padding-right: 10px; font-size:10px;">#DCdescripcion#</td>
				<td nowrap align="left" style="font-family: Verdana, Arial, Helvetica, sans-serif;font-style: normal;padding-right: 10px; font-size:10px;">&nbsp;</td>
				<td nowrap align="right" style="font-family: Verdana, Arial, Helvetica, sans-serif;font-style: normal;padding-right: 10px; font-size:10px;">#rsMoneda.Msimbolo# #LSCurrencyFormat(CCvalorpat,'none')# </td>
				<td nowrap align="right" style="font-family: Verdana, Arial, Helvetica, sans-serif;font-style: normal;padding-right: 10px; font-size:10px;">#rsMoneda.Msimbolo# #LSCurrencyFormat(CCvaloremp,'none')# </td>
				<td nowrap align="right" style="font-family: Verdana, Arial, Helvetica, sans-serif;font-style: normal;padding-right: 10px; font-size:10px;">&nbsp;</td>
			</tr>
		</cfloop>
	<cfelse>		
		<tr><td nowrap colspan="8" align="center"><b>No hay Cargas asociadas al Empleado</b></td></tr>
	</cfif>
    <!--- ======================= Cargas - FIN ======================== --->

    <!--- ======================= Deducciones ======================== --->
    <tr valign="top"> 
      <td nowrap colspan="8">&nbsp;</td>
    </tr>

	<cfquery name="rsDeduccionesCalculo" datasource="#Session.DSN#">
		select  a.Did, a.DCvalor, a.DCinteres, a.DCcalculo, b.Ddescripcion, b.Dvalor, b.Dmetodo, a.DCsaldo, b.Dcontrolsaldo, b.Dreferencia
		from HDeduccionesCalculo a
		
		inner join DeduccionesEmpleado b
		on a.Did = b.Did
		
		where a.RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RCNid#">
		  and a.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.DEid#">
	</cfquery>

	<tr><td nowrap colspan="8" style="font-weight: bolder;text-align: center;vertical-align: middle;padding: 2px;	background-color: ##DFDFDF;">Deducciones</td></tr>

	<cfif rsDeduccionesCalculo.RecordCount gt 0 >
		<tr>
			<td nowrap align="left" style="font-family: Verdana, Arial, Helvetica, sans-serif;font-style: normal;font-weight: bold;padding-right: 10px; font-size:10px;" colspan="4">Descripci&oacute;n</td>
			<td nowrap align="left" style="font-family: Verdana, Arial, Helvetica, sans-serif;font-style: normal;font-weight: bold;padding-right: 10px; font-size:10px;">Referencia</td>
			<td nowrap align="right" style="font-family: Verdana, Arial, Helvetica, sans-serif;font-style: normal;font-weight: bold;padding-right: 10px; font-size:10px;">Saldo posterior</td>
			<td nowrap align="right" style="font-family: Verdana, Arial, Helvetica, sans-serif;font-style: normal;font-weight: bold;padding-right: 10px; font-size:10px;">Monto</td>
			<td nowrap align="right" style="font-family: Verdana, Arial, Helvetica, sans-serif;font-style: normal;font-weight: bold;padding-right: 10px; font-size:10px;">&nbsp;</td>
		</tr>
	
		<cfloop query="rsDeduccionesCalculo">
			<tr style=<cfif CurrentRow MOD 2>"text-indent: 10px; vertical-align: middle" <cfelse>"background-color: ##FAFAFA; vertical-align: middle; text-indent: 10px"</cfif>>
				<td nowrap align="left" colspan="4" style="font-family: Verdana, Arial, Helvetica, sans-serif;font-style: normal;padding-right: 10px; font-size:10px;">#Ddescripcion#</td>
				<td nowrap align="left" style="font-family: Verdana, Arial, Helvetica, sans-serif;font-style: normal;padding-right: 10px; font-size:10px;">#Dreferencia#</td>
				<td nowrap align="right" style="font-family: Verdana, Arial, Helvetica, sans-serif;font-style: normal;padding-right: 10px; font-size:10px;"><cfif Dcontrolsaldo EQ 1>#rsMoneda.Msimbolo# #LSCurrencyFormat(DCsaldo,'none')#</cfif></td>
				<td nowrap align="right" style="font-family: Verdana, Arial, Helvetica, sans-serif;font-style: normal;padding-right: 10px; font-size:10px;">#rsMoneda.Msimbolo# #LSCurrencyFormat(DCvalor,'none')# </td>
				<td nowrap align="right" style="font-family: Verdana, Arial, Helvetica, sans-serif;font-style: normal;padding-right: 10px; font-size:10px;"><cfif DCcalculo eq 1><img border="0" src="http://websdc/cfmx/rh/imagenes/Cferror.gif"></cfif> </td>
			</tr>
		</cfloop>
	<cfelse>		
		<tr><td nowrap colspan="8" align="center"><b>No hay Deducciones asociadas al Empleado</b></td></tr>
	</cfif>
    <!--- ======================= Deducciones - FIN ======================== --->	
	
    <tr valign="top"><td nowrap colspan="8">&nbsp;</td></tr>
  </table>
  <br>
  <table width="97%" border="0" cellspacing="0" cellpadding="0" align="center" style="padding-left: 5px; padding-right: 5px;">
	<tr bgcolor="##EEEEEE" style="padding: 3px;">
		<td nowrap align="center"><font size="3"><b>----- Fin de #Titulo# -----</b></font>
		</td>
	</tr>
  </table>
  
  <table width="97%" border="0" cellspacing="0" cellpadding="0" align="center" style="padding-left: 5px; padding-right: 5px;">
	<tr style="padding: 3px;">
		<td nowrap align="center"><font size="1">
			Este mensaje es generado automáticamente por el sistema de Recursos Humanos. Por favor no responda este mensaje.
		</font>
		</td>
	</tr>
  </table>

</body>
</html>
</cfoutput>	
</cfsavecontent>
<cfreturn #info#>
</cffunction>
</cfcomponent>