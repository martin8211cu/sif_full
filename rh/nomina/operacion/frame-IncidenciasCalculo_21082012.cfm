<!---modifica para subir nuevamente y agregar en parche--->
<cfquery name="rsIncidenciasCalculo" datasource="#Session.DSN#">
	select ICid, b.CIdescripcion, a.ICfecha, a.ICvalor, a.ICmontores, a.ICcalculo, b.CIcarreracp, coalesce(b.CIafectacostoHE,0) as CIafectacostoHE
	from IncidenciasCalculo a, CIncidentes b
	where a.CIid = b.CIid
	and RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RCNid#">
	and DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.DEid#">
	and CIcarreracp = 0
	order by b.CIcarreracp, a.ICfecha,  b.CIcodigo, b.CIdescripcion
</cfquery>
<cfquery name="rsIncidenciasCalculoCP" datasource="#Session.DSN#">
	select ICid, b.CIdescripcion, a.ICfecha, a.ICvalor, a.ICmontores, a.ICcalculo, b.CIcarreracp, coalesce(b.CIafectacostoHE,0) as CIafectacostoHE,
		CCPid, CCPacumulable, CCPprioridad, TCCPid, b.CItipo
	from IncidenciasCalculo a, CIncidentes b, ConceptosCarreraP c
	where a.CIid = b.CIid
	  and c.CIid = b.CIid
	  and RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RCNid#">
	  and DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.DEid#">
	  and CIcarreracp = 1
	order by b.CIcarreracp, a.ICfecha,  b.CIcodigo, b.CIdescripcion
</cfquery>
<cfquery name="rsDatosRelacion" datasource="#session.DsN#">
	select RChasta
	from RCalculoNomina
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	  and RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RCNid#">
</cfquery>

<cfset apruebaIncidencias = false >

<!--- Aprueba Incidencias Normales parametro 1010 --->
<cfquery name="rs_apruebaincidencias" datasource="#session.DSN#">
	select Pvalor
	from RHParametros
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	and Pcodigo = 1010
</cfquery>

<cfif trim(rs_apruebaincidencias.Pvalor) eq 1 >
	<cfset apruebaIncidencias = true >
	<cfquery name="rsFechas" datasource="#session.DsN#">
		select RCdesde, RChasta
		from RCalculoNomina
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		  and RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RCNid#">
	</cfquery>
	
	<cfquery name="rsPendientesAprobar" datasource="#session.DsN#">
		select count(1) as hay from Incidencias 
		where DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.DEid#">
		and NAP  is null
		and Iestado in(1,2)
		and Ifecha between <cfqueryparam cfsqltype="cf_sql_date" value="#rsFechas.RCdesde#"> and <cfqueryparam cfsqltype="cf_sql_date" value="#rsFechas.RChasta#">
	</cfquery>
	
	<cfquery name="rsPendientesRestaurar" datasource="#session.DsN#">
		select count(1) as hay from Incidencias a 
		where a.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.DEid#">
		and a.NAP  is not null
		and a.Iestado in(1)
		and a.Ifecha between <cfqueryparam cfsqltype="cf_sql_date" value="#rsFechas.RCdesde#"> and <cfqueryparam cfsqltype="cf_sql_date" value="#rsFechas.RChasta#">
		and not exists (
			select 1 from IncidenciasCalculo x
			where x.RCNid   =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RCNid#">
			and   x.DEid    =  a.DEid
			and	  x.CIid    =  a.CIid 
			and   x.ICfecha =  a.Ifecha)
	</cfquery>	
	
</cfif>

<cfquery name="rsAntig" datasource="#session.DSN#">
	select 	EVfantig as Antiguedad
	from EVacacionesEmpleado a
	where a.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.DEid#">
</cfquery>
<cfset Lvar_Antig = DateDiff("m", rsAntig.Antiguedad,rsDatosRelacion.RChasta)/12>

<cfquery name="rsVerificaP1000" datasource="#session.DSN#">
	select Pvalor from RHParametros
	where Ecodigo =<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		and Pcodigo = 1000
</cfquery>
<cfset vn_algunoafecta = 0>
  <tr> 
    <td colspan="9" class="<cfoutput>#Session.Preferences.Skin#_thcenter</cfoutput>"><div align="center"><cf_translate key="LB_Incidencias">Incidencias</cf_translate></div></td>
  </tr>
	<cfif apruebaIncidencias and isdefined('rsPendientesAprobar') and rsPendientesAprobar.hay gt 0>
		<tr> 
			<td colspan="9"   align="center" style="color:red">
				&nbsp;***<cf_translate  key="LB_Existen_Incidencias_Pendientes_de_Aprobar">Existen Incidencias Pendientes de Aprobar</cf_translate>&nbsp;***
			</td>
		</tr>
	</cfif>
	<cfif apruebaIncidencias and isdefined('rsPendientesRestaurar') and rsPendientesRestaurar.hay gt 0>
		<tr> 
			<td colspan="9"   align="center" style="color:red">
				&nbsp;***<cf_translate  key="Existen_Incidencias_Aprobadas_que_requieren_la_restauracion_de_la_nomina">Existen Incidencias Aprobadas que requieren la restauraci&oacute;n de la n&oacute;mina</cf_translate>&nbsp;***
			</td>
		</tr>
	</cfif>
	
	

  <tr> 
    <td align="left" class="FileLabel">&nbsp;</td>
    <td align="left" class="FileLabel"><cf_translate key="LB_Fecha" XmlFile="/rh/generales.xml">Fecha</cf_translate></td>
    <td align="left" class="FileLabel" colspan="3"><cf_translate key="LB_Concepto">Concepto</cf_translate></td>
	<td colspan="2">&nbsp;</td>
   	<td align="right" class="FileLabel"><cf_translate key="LB_Valor">Valor</cf_translate></td>	
    <td align="right" class="FileLabel"><cf_translate key="LB_MontoResultante">Monto Resultante</cf_translate></td>
	<td align="right" class="FileLabel">&nbsp;</td>
  </tr>
<!--- INCIDENCIAS DE CALCULO QUE NO SON DE CARRERA PROFESIONAL --->
<cfoutput query="rsIncidenciasCalculo">
	<tr class=<cfif CurrentRow MOD 2>"listaNon" <cfelse>"listaPar"</cfif> onmouseover="style.backgroundColor='##E4E8F3';" onmouseout="style.backgroundColor='<cfif CurrentRow MOD 2>##FFFFFF<cfelse>##FAFAFA</cfif>';"> 
		<td align="left" ><input type="checkbox" name="chk" value="I|#ICid#"></td>
		<td align="left" >#LSDateFormat(ICfecha,'dd/mm/yyyy')#</td>
		<td align="left" colspan="3">
			#CIdescripcion#
			<cfif rsIncidenciasCalculo.CIafectacostoHE EQ 1 and rsVerificaP1000.RecordCount NEQ 0 and rsVerificaP1000.Pvalor EQ 1>
				(*)
				<cfset vn_algunoafecta = vn_algunoafecta+1>
			</cfif>
		</td>
		<td colspan="2">&nbsp;</td>
		<td align="right" >#LSCurrencyFormat(ICvalor,'none')#</td>
		<td align="right" >#rsMoneda.Msimbolo# #LSCurrencyFormat(ICmontores,'none')# </td>
		<td align="right" ><cfif ICcalculo eq 1><img border="0" src="/cfmx/rh/imagenes/Cferror.gif"></cfif></td>
	</tr>
<!--- 	<cfif vn_algunoafecta NEQ 0 and rsVerificaP1000.RecordCount NEQ 0 and rsVerificaP1000.Pvalor EQ 1>
		<tr>
			<td colspan="7">
				(*)<cf_translate key="LB_SeUtilizaParaCalculoDelCostoDeHoras">Se utiliza para el c&aacute;lculo del costo de horas</cf_translate>
			</td>
		</tr>
	</cfif> --->
</cfoutput>

<!--- INCIDENCIAS DE CALCULO DE CARRERA PROFESIONAL --->
<cfif isdefined('rsIncidenciasCalculoCP') and rsIncidenciasCalculoCP.RecordCount>
	<tr><td>&nbsp;</td></tr>	
	<tr><td colspan="9" ><strong><cf_translate key="LB_CarreraProfesional">Carrera Profesional</cf_translate></strong></td></tr>
	<tr> 
		<td align="left" class="FileLabel">&nbsp;</td>
		<td align="left" class="FileLabel"><cf_translate key="LB_Fecha" XmlFile="/rh/generales.xml">Fecha</cf_translate></td>
		<td align="left" class="FileLabel" colspan="3"><cf_translate key="LB_Concepto">Concepto</cf_translate></td>
		<td>&nbsp;</td>
		<td align="right" class="FileLabel"><cf_translate key="LB_Puntos">Puntos</cf_translate></td>	
		<td align="right" class="FileLabel"><cf_translate key="LB_Valor">Valor</cf_translate></td>	
		<td align="right" class="FileLabel"><cf_translate key="LB_MontoResultante">Monto Resultante</cf_translate></td>
		<td align="right" class="FileLabel">&nbsp;</td>
	</tr>
<!--- INCIDENCIAS DE CALCULO QUE NO SON DE CARRERA PROFESIONAL --->
<cfoutput query="rsIncidenciasCalculoCP">
	<cfinvoke component="rh.Componentes.RH_CalculoCP" method="AcumulaConceptos" returnvariable="Conceptos" conexion="#session.DSN#"
		ecodigo = "#session.Ecodigo#" ccpid = "#rsIncidenciasCalculoCP.CCPid#" acumula = "#rsIncidenciasCalculoCP.CCPacumulable#" tccpid="#rsIncidenciasCalculoCP.TCCPid#"
		prioridad="#rsIncidenciasCalculoCP.CCPprioridad#" rcdesde="#RCdesde#" rchasta="#RChasta#" deid = "#Form.DEid#"/>
	<tr class=<cfif CurrentRow MOD 2>"listaNon" <cfelse>"listaPar"</cfif> onmouseover="style.backgroundColor='##E4E8F3';" onmouseout="style.backgroundColor='<cfif CurrentRow MOD 2>##FFFFFF<cfelse>##FAFAFA</cfif>';"> 
		<td align="left" ><input type="checkbox" name="chk" value="I|#ICid#"></td>
		<td align="left" >#LSDateFormat(ICfecha,'dd/mm/yyyy')#</td>
		<td align="left" colspan="3">
			#CIdescripcion#
			<cfif rsIncidenciasCalculo.CIafectacostoHE EQ 1 and rsVerificaP1000.RecordCount NEQ 0 and rsVerificaP1000.Pvalor EQ 1>
				(*)
				<cfset vn_algunoafecta = vn_algunoafecta+1>
			</cfif>
		</td>
		<td>&nbsp;</td>
		<td align="right" ><cfif rsIncidenciasCalculoCP.CItipo EQ 3 and rsIncidenciasCalculoCP.TCCPid EQ 30>#LSCurrencyFormat(ICvalor,'none')#<cfelse>#LSCurrencyFormat(Conceptos.valor,'none')#</cfif></td>
		<td align="right" >
			<cfif rsIncidenciasCalculoCP.CItipo EQ 3 and rsIncidenciasCalculoCP.TCCPid EQ 30>#LSCurrencyFormat(Lvar_Antig,'none')#<cfelse>#LSCurrencyFormat(ICvalor,'none')#</cfif>
		</td>
		<td align="right" >#rsMoneda.Msimbolo# #LSCurrencyFormat(ICmontores,'none')# </td>
		<td align="right" ><cfif ICcalculo eq 1><img border="0" src="/cfmx/rh/imagenes/Cferror.gif"></cfif></td>
	</tr>
</cfoutput>
</cfif>	
<cfif vn_algunoafecta NEQ 0 and rsVerificaP1000.RecordCount NEQ 0 and rsVerificaP1000.Pvalor EQ 1>
	<tr><td>&nbsp;</td></tr>	
	<tr>
		<td colspan="7">
			(*)<cf_translate key="LB_SeUtilizaParaCalculoDelCostoDeHoras">Se utiliza para el c&aacute;lculo del costo de horas</cf_translate>
		</td>
	</tr>
</cfif>
