<cf_dbfunction name="op_concat" returnvariable="LvarCNCT">
<cfquery name="rsArqueo" datasource="#session.dsn#">
	select a.BMfecha,a.CCHefectivo,a.CCHvales,a.CCHAid,a.CCHgastos,a.CCHsobrante,a.CCHfaltante,a.CCHid,
	c.CCHcodigo #LvarCNCT#'-'  #LvarCNCT# c.CCHdescripcion as caja
	from CCHarqueo	a
		inner join CCHica c
		on c.CCHid=a.CCHid
		where a.Ecodigo =#session.Ecodigo#
</cfquery>

<table width="100%">
<form name="form1" action="CCHarqueo.cfm" method="post">
	<tr>
		<td width="10%" >
			<strong><cf_translate key = LB_FechaDesde>Fecha Desde</cf_translate></strong>		
		</td>
		<td width="90%" align="left">
			<cf_sifcalendario form="form1" value="" name="finicio" tabindex="1">
	  </td> 
	</tr>
	<tr>
		<td>
			<strong><cf_translate key = LB_FechaHasta>Fecha Hasta</cf_translate></strong>
		</td>
		<td align="left">
			<cf_sifcalendario form="form1" value="" name="fhasta" tabindex="1">
		</td>
		<td>
			<input type="button" name="filtrar" value="<cfoutput>#BTN_Filtrar#</cfoutput>">
		</td>
	</tr>
</form>
	<tr>
		<td  valign="top" colspan="7">
			<cfinvoke component="sif.Componentes.pListas" method="pListaQuery" 
			query="#rsArqueo#"
			columnas="caja,BMfecha,CCHefectivo,CCHGastos,CCHvales,CCHAid,CCHSobrante,CCHFaltante"
			desplegar="caja,BMfecha,CCHefectivo,CCHGastos,CCHvales,CCHSobrante,CCHFaltante"
			etiquetas="#LB_CajaChica#,#LB_Fecha#,#LB_MontoEfectivo#,#LB_MontoGastos#,#LB_MontoVales#,#LB_Sobrante#,#LB_Faltante#"
			formatos="S,D,M,M,M,M,M"
			align="left,left,right,right,right,right,right"
			ira="arqueo.cfm"
			form_method="post"	
			showEmptyListMsg="yes"
			keys="CCHAid"
			incluyeForm="yes"
			formName="arqueo"
			PageIndex="3"
			MaxRows="15"	
			botones="Nuevo"
			navegacion=""/>
		</td>
	</tr>
</table>
