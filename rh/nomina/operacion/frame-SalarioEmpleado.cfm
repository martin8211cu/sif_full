<cfinvoke component="sif.Componentes.Translate"
method="Translate"
Key="LB_Semanal"
Default="Semanal"	
returnvariable="LB_Semanal"/>

<cfinvoke component="sif.Componentes.Translate"
method="Translate"
Key="LB_Bisemanal"
Default="Bisemanal"	
returnvariable="LB_Bisemanal"/>

<cfinvoke component="sif.Componentes.Translate"
method="Translate"
Key="LB_Quincenal"
Default="Quincenal"	
returnvariable="LB_Quincenal"/>

<cfquery name="HRCalculoNomina" datasource="#Session.DSN#">
	select a.Tcodigo,
	case Ttipopago 
	when 0 then '#LB_Semanal#'
	when 1 then '#LB_Bisemanal#'
	when 2 then '#LB_Quincenal#'
	else ''
	end as   descripcion
	from RCalculoNomina a
	inner join TiposNomina b
		on a.Tcodigo = b.Tcodigo
		and a.Ecodigo =  b.Ecodigo
	where a.RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RCNid#">
	
</cfquery>

<cfquery name="rsMostrarSalarioNominal" datasource="#session.DSN#">
	select coalesce(Pvalor,'0') as  Pvalor
	from RHParametros
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
	and Pcodigo = 1040
</cfquery>

<cfquery name="rsSalarioEmpleado" datasource="#Session.DSN#">
	select 	SEsalariobruto, SEincidencias, SErenta, SEcargasempleado, 
			SEcargaspatrono,  SEdeducciones, SEliquido
	from SalarioEmpleado 
	where RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RCNid#">
	and DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.DEid#">
</cfquery>
<cfoutput>
    <tr> 
      <td nowrap class="FileLabel"> 
        <div align="right"><cf_translate key="LB_Bruto">Bruto :</cf_translate>&nbsp;</div></td>
		<cfif rsMostrarSalarioNominal.Pvalor eq 1>
			<cfif HRCalculoNomina.Tcodigo neq 3>
				<td nowrap class="FileLabel"><div align="right"><cf_translate  key="LB_Salario">Salario</cf_translate>&nbsp;#HRCalculoNomina.descripcion#:&nbsp;</div></td>
			</cfif>
		 </cfif>     
	 
	 
	  <td nowrap class="FileLabel"> 
        <div align="right"><cf_translate key="LB_Incidencias">Incidencias :</cf_translate>&nbsp;</div></td>
      <td nowrap class="FileLabel"> 
        <div align="right"><cf_translate key="LB_Renta">ISR :</cf_translate>&nbsp;</div></td>
      <td nowrap class="FileLabel"> 
        <div align="right"><cf_translate key="LB_CargasEmpleado">Deducciones Empleado :</cf_translate>&nbsp;</div></td>
      <td nowrap class="FileLabel"> 
        <div align="right"><cf_translate key="LB_CargasPatrono">Deducciones Patrono :</cf_translate>&nbsp;</div></td>
      <td nowrap class="FileLabel"> 
        <div align="right"><cf_translate key="LB_Deducciones">Deducciones :</cf_translate>&nbsp;</div></td>
      <td nowrap class="FileLabel"> 
        <div align="right"><cf_translate key="LB_Liquido">Neto :</cf_translate>&nbsp;</div></td>
    </tr>
	<tr>
      <td nowrap> 
        <div align="right">#rsMoneda.Msimbolo# #LSCurrencyFormat(rsSalarioEmpleado.SEsalariobruto,'none')# </div></td>
		<cfif rsMostrarSalarioNominal.Pvalor eq 1>
			<cfif HRCalculoNomina.Tcodigo neq 3>
				<cfquery name="rsFecha" datasource="#Session.DSN#">
					select CPdesde  from CalendarioPagos 
					where  CPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RCNid#">
				</cfquery>
				<cfquery name="rsLineaTiempo" datasource="#Session.DSN#">
					select LTsalario from LineaTiempo
					where <cfqueryparam cfsqltype="cf_sql_date" value="#rsFecha.CPdesde#">  between LTdesde and LThasta
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
					<td nowrap align="right">#rsMoneda.Msimbolo# #LSCurrencyFormat(var_salarioTipoNomina,'none')#</td>
			</cfif>
		 </cfif>	      
	  
	  
	  <td nowrap> 
        <div align="right">#rsMoneda.Msimbolo# #LSCurrencyFormat(rsSalarioEmpleado.SEincidencias,'none')# </div></td>
      <td nowrap> 
        <div align="right">#rsMoneda.Msimbolo# #LSCurrencyFormat(rsSalarioEmpleado.SErenta,'none')# </div></td>
      <td nowrap> 
        <div align="right">#rsMoneda.Msimbolo# #LSCurrencyFormat(rsSalarioEmpleado.SEcargasempleado,'none')# </div></td>
      <td nowrap> 
        <div align="right">#rsMoneda.Msimbolo# #LSCurrencyFormat(rsSalarioEmpleado.SEcargaspatrono,'none')# </div></td>
      <td nowrap> 
        <div align="right">#rsMoneda.Msimbolo# #LSCurrencyFormat(rsSalarioEmpleado.SEdeducciones,'none')# </div></td>
      <td nowrap> 
        <div align="right">#rsMoneda.Msimbolo# #LSCurrencyFormat(rsSalarioEmpleado.SEliquido,'none')# </div></td>
	</tr>
</cfoutput>