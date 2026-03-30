<title>
		<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		Key="LB_ConciliacionMasiva"
		Default="Conciliación Masiva"
		returnvariable="LB_ConciliacionMasiva"/>
		<cfoutput>#LB_ConciliacionMasiva#</cfoutput>
</title>	
<cf_templatecss>
<cf_web_portlet_start titulo="#LB_ConciliacionMasiva#">

<cfquery name="rsPeriodos" datasource="#session.dsn#">
	select distinct Speriodo as value , <cf_dbfunction name="to_char" args="Speriodo">  as description  from CGPeriodosProcesados
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#"/>
	order by value
</cfquery>

<cfquery name="rsMeses" datasource="#session.dsn#">
	select  <cf_dbfunction name="to_number" args="VSvalor"> as value, VSdesc as description
	from VSidioma vs
		inner join Idiomas id
		on id.Iid = vs.Iid
		and id.Icodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.Idioma#"/>
	where VSgrupo = 1
	order by 1
</cfquery>

<cfquery name="rsPeriodoAux" datasource="#session.dsn#"> 
	select Pvalor, Pdescripcion 
	from Parametros 
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#"/> 
	  and Pcodigo = 50 
</cfquery>
<cfquery name="rsMesAux" datasource="#session.dsn#">
	select Pvalor, Pdescripcion 
	from Parametros 
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#"/> 
	  and Pcodigo = 60 
</cfquery>


<cfquery name="rsConceptos" datasource="#session.dsn#">
	select Cconcepto as value, Cdescripcion as description, 0 as orden
	from ConceptoContableE
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
	order by 3,2
</cfquery>
<cfoutput>
	<form action="ConciliacionMasiva-sql.cfm" method="post" name="form1">
		<table width="100%" border="0"  cellpadding="6">
			<tr>
				<td width="50%" align="right"><strong><cf_translate  key="LB_Periodo">Periodo</cf_translate></strong>&nbsp;:</td>
				<td width="50%">
					<select name="GATPeriodo" tabindex="1">
						<cfloop query="rsPeriodos">
							<option value="#rsPeriodos.value#" <cfif isdefined("rsPeriodoAux.Pvalor") and rsPeriodoAux.Pvalor eq rsPeriodos.value>selected</cfif> >#rsPeriodos.description#</option>
						</cfloop>
					</select>
				</td>
			</tr>
			<tr>
				<td align="right"><strong><cf_translate  key="LB_Mes">Mes</cf_translate></strong>&nbsp;:</td>
				<td>
					<select name="GATMes" tabindex="2">
						<cfloop query="rsMeses">
							<option value="#rsMeses.value#" <cfif isdefined("rsMesAux.Pvalor") and rsMesAux.Pvalor eq rsMeses.value>selected</cfif> >#rsMeses.description#</option>
						</cfloop>
					</select>		
				</td>
			</tr>
			<tr>
				<td align="right"><strong><cf_translate  key="LB_Concepto">Concepto</cf_translate></strong>&nbsp;:</td>
				<td>
					<select name="Cconcepto" tabindex="3">
						<cfloop query="rsConceptos">
							<option value="#rsConceptos.value#">#rsConceptos.description#</option>
						</cfloop>
					</select>			
				
				</td>
			</tr>	
			<tr>
			<td colspan="2" align="center">
			<cfinvoke component="sif.Componentes.Translate"
			method="Translate"
			Key="BTN_Conciliar"
			Default="Conciliar"
			returnvariable="BTN_Conciliar"/>
			
			<cfinvoke component="sif.Componentes.Translate"
			method="Translate"
			Key="BTN_Cerrar"
			Default="Cerrar"
			returnvariable="BTN_Cerrar"/>
			
			<input name="btnConciliar" type="submit" value="#BTN_Conciliar#" tabindex="4">
			<input name="btnCerrarDOWN" type="button" value="#BTN_Cerrar#" onClick="javascript:window.close();" tabindex="5"></td>
			</tr>
		</table>
	</form>
</cfoutput>
<cf_web_portlet_end>