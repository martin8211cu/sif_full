<cfset form.Mcodigo = 1 >
<cfset form.Eid = 1 >
<cfset form.ETid = 1 >
<cfset form.EEid = 1 >

<cfquery datasource="#session.dsn#" name="dflt" maxrows="1">
	select EEid, ETid, Eid
	from RHEncuestadora
	where RHEinactiva = 0
	  and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	order by RHEdefault desc
</cfquery>

<!---
<cfquery datasource="#session.dsn#" name="encuesta">
	select rhp.RHPcodigo, rhp.RHPdescpuesto,
		ep.EPcodigo, ep.EPdescripcion, es.ESp25, es.ESp50, es.ESp75, es.ESpromedio,
		<!--- modificar este calculo por un subquery de verdad --->
		(es.ESpromedio + es.ESp25) * 0.6 as SalarioPromedio
	from RHEncuestaPuesto rhep
		join RHPuestos rhp
			on  rhep.Ecodigo = rhp.Ecodigo
			and rhep.RHPcodigo = rhp.RHPcodigo
		join EncuestaPuesto ep
			on ep.EPid = rhep.EPid
			and ep.EEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#dflt.EEid#">
		join EncuestaSalarios es
			on es.EPid = ep.EPid
			and es.Eid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#dflt.Eid#">
			and es.EEid = ep.EEid
			and es.ETid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#dflt.ETid#">
	where rhep.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	order by es.ESpromedio asc
</cfquery>
--->

<cfquery datasource="#session.dsn#" name="encuesta">
	select ep.RHPcodigo, 
		   p.RHPdescpuesto,
		   ref.EPcodigo,
		   ref.EPdescripcion,	
			
			( select coalesce(count(1),0)
			  from LineaTiempo a
	
			  inner join TiposNomina b
			  on a.Tcodigo=b.Tcodigo
	
			  where a.RHPcodigo=ep.RHPcodigo
			  and getdate() between a.LTdesde and a.LThasta
			  and LTsalario > 0 and LTsalario <= es.ESp25   ) as rango1 /* 0-25 */,
	
			( select coalesce(count(1),0)
			  from LineaTiempo a
	
			  inner join TiposNomina b
			  on a.Tcodigo=b.Tcodigo
	
			  where a.RHPcodigo=ep.RHPcodigo
			  and getdate() between a.LTdesde and a.LThasta
			  and LTsalario > es.ESp25 and LTsalario <= es.ESp50   ) as rango2 /* 25-50 */,
	
			( select coalesce(count(1),0)
			  from LineaTiempo a
	
			  inner join TiposNomina b
			  on a.Tcodigo=b.Tcodigo
	
			  where a.RHPcodigo=ep.RHPcodigo
			  and getdate() between a.LTdesde and a.LThasta
			  and LTsalario > es.ESp50 and LTsalario <= es.ESp75   ) as rango3 /* 50-75 */,
	
			( select coalesce(count(1),0)
			  from LineaTiempo a
	
			  inner join TiposNomina b
			  on a.Tcodigo=b.Tcodigo
	
			  where a.RHPcodigo=ep.RHPcodigo
			  and getdate() between a.LTdesde and a.LThasta
			  and LTsalario > es.ESp75   ) as rango4 /* 75-50 */
	
	from RHEncuestaPuesto ep
	
	inner join EncuestaSalarios es
	on ep.EEid=es.EEid
	and ep.EPid=es.EPid
	and es.Moneda = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Mcodigo#">
	and es.Eid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Eid#">
	and es.ETid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ETid#">
	
	inner join EncuestaPuesto ref
	on es.EPid=ref.EPid
	
	inner join RHPuestos p
	on ep.Ecodigo=p.Ecodigo
	and ep.RHPcodigo=p.RHPcodigo
	
	where ep.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	and ep.EEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.EEid#">
</cfquery>

<cf_template>
<cf_templatearea name="title">
	Salarios vs Encuestas
</cf_templatearea>
<cf_templatearea name="body">
<cf_web_portlet_start titulo="Salarios vs Encuestas" width="100%">
<cfinclude template="/home/menu/pNavegacion.cfm">

<table width="750" align="center" border="0"><tr><td>
<!---
<cfchart format="flash" font="arialunicodeMS"
	showxgridlines="no" showygridlines="yes" showborder="no"
	fontbold="no" fontitalic="no" show3d="no" rotated="no" 
	sortxaxis="no" showlegend="yes" showmarkers="yes" 
	xaxistitle="Código de Puesto" yaxistitle="Salarios"
	chartwidth="750" chartheight="550">
<!---
<cfchartseries query="encuesta" itemcolumn="RHPcodigo" valuecolumn="ESp25"           serieslabel="% 25" type="line" seriescolor="##FF0099"></cfchartseries>
<cfchartseries query="encuesta" itemcolumn="RHPcodigo" valuecolumn="ESp50"           serieslabel="% 50" type="line" seriescolor="##33FF66"></cfchartseries>
<cfchartseries query="encuesta" itemcolumn="RHPcodigo" valuecolumn="ESp75"           serieslabel="% 75" type="line" seriescolor="##0066FF"></cfchartseries>
--->
<cfchartseries query="encuesta" itemcolumn="RHPcodigo" valuecolumn="ESpromedio"      serieslabel="Encuesta" type="step" seriescolor="##66CC00"></cfchartseries>
<cfchartseries query="encuesta" itemcolumn="RHPcodigo" valuecolumn="SalarioPromedio" serieslabel="Salario Promedio" type="bar"  seriescolor="##003399"></cfchartseries>

</cfchart>
--->
</td></tr></table>

<table width="99%" align="center" border="0" bgcolor="#CCCCCC" cellpadding="2" cellspacing="1">
  <tr bgcolor="#EdEdEd">
    <td colspan="2"><strong>Puesto</strong></td>
    <td colspan="2"><strong>Puesto Referencia</strong></td>
    <td align="right"><strong>0-25</strong></td>
    <td align="right"><strong>25-50</strong></td>
    <td align="right"><strong>50-75</strong></td>
    <td align="right"><strong>> 75</strong></td>
  </tr>
  <cfoutput query="encuesta">
  <tr bgcolor="##FFFFFF">
    <td>#HTMLEditFormat(encuesta.RHPcodigo)# </td>
    <td>#HTMLEditFormat(encuesta.RHPdescpuesto)#</td>
    <td>#HTMLEditFormat(encuesta.EPcodigo)# </td>
    <td>#HTMLEditFormat(encuesta.EPdescripcion)#</td>
    <td align="right">#NumberFormat(rango1,',0.00')#</td>
    <td align="right">#NumberFormat(rango2,',0.00')#</td>
    <td align="right">#NumberFormat(rango3,',0.00')#</td>
    <td align="right">#NumberFormat(rango4,',0.00')#</td>
  </tr></cfoutput>
  <tr>
    <td colspan="2">&nbsp;</td>
    <td colspan="2">&nbsp;</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
  </tr>
</table>
<br>

<cf_web_portlet_end>



</cf_templatearea>
</cf_template>