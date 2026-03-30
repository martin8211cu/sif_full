
<cfif isdefined("url.showMessage") and len(trim(url.showMessage))>
	<cfset Form.showMessage = "#url.showMessage#">
</cfif>
<cfquery datasource="#Session.DSN#" name="Periodo">
    select Pvalor as valor
    from Parametros 
    where Ecodigo = #Session.Ecodigo#
    and Pcodigo = 30 
</cfquery>	
<cfset periodo="#Periodo.valor#">

<cfinclude template="../../Utiles/sifConcat.cfm">
<cfquery name="rsPeriodos" datasource="#Session.DSN#">
	select CPPid, CPPfechaDesde,year(CPPfechaDesde) as var_year,
    					'Presupuesto ' #_Cat#
				case CPPtipoPeriodo when 1 then 'Mensual' when 2 then 'Bimestral' when 3 then 'Trimestral' when 4 then 'Cuatrimestral' when 6 then 'Semestral' when 12 then 'Anual' else '' end
					#_Cat# ' de ' #_Cat# 
					case {fn month(CPPfechaDesde)} when 1 then 'Enero' when 2 then 'Febrero' when 3 then 'Marzo' when 4 then 'Abril' when 5 then 'Mayo' when 6 then 'Junio' when 7 then 'Julio' when 8 then 'Agosto' when 9 then 'Setiembre' when 10 then 'Octubre' when 11 then 'Noviembre' when 12 then 'Diciembre' else '' end
					#_Cat# ' ' #_Cat# <cf_dbfunction name="to_char" args="{fn year(CPPfechaDesde)}">
					#_Cat# ' a ' #_Cat# 
					case {fn month(CPPfechaHasta)} when 1 then 'Enero' when 2 then 'Febrero' when 3 then 'Marzo' when 4 then 'Abril' when 5 then 'Mayo' when 6 then 'Junio' when 7 then 'Julio' when 8 then 'Agosto' when 9 then 'Setiembre' when 10 then 'Octubre' when 11 then 'Noviembre' when 12 then 'Diciembre' else '' end
					#_Cat# ' ' #_Cat# <cf_dbfunction name="to_char" args="{fn year(CPPfechaHasta)}">
			as Pdescripcion

	  from CPresupuestoPeriodo p <!---inner join Monedas m on p.Mcodigo=m.Mcodigo--->
	 where p.Ecodigo = #Session.Ecodigo#
	   and p.CPPestado=1
       and year(CPPfechaHasta)<> #periodo#
</cfquery>

<cfif rsPeriodos.CPPid EQ "">
	<BR>
	<div style="color:#FF0000; text-align:center">
	No existen Periodos de Presupuesto Cerrados
	</div>
	<BR>
	<cfexit>
</cfif>
<cfset periodoAnt="#rsPeriodos.var_year#">

<cfquery datasource="#Session.DSN#" name="rsEmpresa">
	select Edescripcion from Empresas
 	where Ecodigo = #Session.Ecodigo#
</cfquery>
<cfoutput>
<form method="post" name="form1" action="SQLCierreContaPres.cfm">
	<input type="hidden" name="periodo"       value="#periodoAnt#">
	<table border="0" cellpadding="2" cellspacing="0" width="100%">
		<tr align="center">			
			<td width="40%" align="right" style="padding-right: 20px" nowrap>
				<b>Período Presupuestal : </b>
			</td>
			<td align="left" style="padding-right: 10px">
				#rsPeriodos.Pdescripcion#
			</td>
		</tr>
		
		<tr>
			<td align="center" colspan="4">
				<br/>
				<cfif isdefined("Form.showMessage")>
					<script language="JavaScript" type="text/javascript">
						alert("#Form.showMessage#");
					</script>
				</cfif>
				¿Desea procesar el cierre contable presupuestal para la empresa <b>#rsEmpresa.Edescripcion#</b>? 
			</td>
		</tr>
		<tr>
			<td align="center" colspan="4">
				<br/>
				<input type="submit" name="btnCierre" value="Procesar Cierre Presupuestal" onclick="javascript:return confirm('¿Está seguro de efectuar el cierre presupuestal?');"/>
			</td>
		</tr>
		<tr><td>&nbsp;</td></tr>
		<tr><td>&nbsp;</td></tr>
	</table>
</form>
</cfoutput>

