<html>
<head>
<title>Plan de Finaciamiento</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<cf_templatecss>
</head>
<body>
<cf_dbfunction name="OP_concat"	returnvariable="_Cat">
<cfquery name="data_empleado" datasource="#session.DSN#">
	select a.DEid, b.DEidentificacion, b.DEnombre  #_Cat# ' ' #_Cat# b.DEapellido1 #_Cat# ' ' #_Cat# b.DEapellido2 as DEnombre
	from DeduccionesEmpleado a
	
	inner join DatosEmpleado b
	on a.DEid=b.DEid
	
	where a.Ecodigo =  #session.Ecodigo# 
	  and a.Did=<cfqueryparam cfsqltype="cf_sql_numeric" value="#url.Did#">
</cfquery>


<cfquery name="dataPlan" datasource="#session.DSN#">
	select 	a.TDid,
			d.TDcodigo,
			d.TDdescripcion,
			a.Dreferencia, 
			a.Ddescripcion, 
			a.SNcodigo,
			e.SNnumero,
			e.SNnombre,
			a.Dmonto, 
			a.Dtasa, 
			a.Dfechaini, 
			a.Dobservacion,
			( select distinct PPtasamora 
			  from DeduccionesEmpleadoPlan b 
			  where b.Ecodigo =  #session.Ecodigo# 
				and b.Did = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.Did#">
				and b.PPpagado = 0 
				and a.Did = b.Did 
				and a.Ecodigo=b.Ecodigo ) as Dtasamora,
			( select coalesce(count(1),0)
			  from DeduccionesEmpleadoPlan c
			  where c.Ecodigo =  #session.Ecodigo#  
				and c.Did = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.Did#">
				and c.PPpagado = 0 
				and a.Did = c.Did
				and a.Ecodigo = c.Ecodigo ) as Dnumcuotas
	from DeduccionesEmpleado a
	
	inner join TDeduccion d
	on a.TDid=d.TDid
	   and a.Ecodigo=d.Ecodigo 

	left outer join SNegocios e
	on a.SNcodigo=e.SNcodigo
	   and a.Ecodigo=e.SNcodigo
	
	where a.Ecodigo =  #session.Ecodigo#  
	  and a.Did = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.Did#">
</cfquery>

<cfquery name="dataSaldo" datasource="#session.DSN#">
	select PPfecha_vence, coalesce(PPsaldoant, 0) as PPsaldoactual
	from DeduccionesEmpleadoPlan 
	where Did=<cfqueryparam cfsqltype="cf_sql_numeric" value="#url.Did#"> 
	  and Ecodigo =  #session.Ecodigo#  	
	  and PPpagado=0
	  and PPnumero = ( select min(PPnumero) from DeduccionesEmpleadoPlan where Ecodigo= #session.Ecodigo#   and Did=<cfqueryparam cfsqltype="cf_sql_numeric" value="#url.Did#"> and PPpagado=0)
	order by PPfecha_vence
</cfquery>

<cfquery name="calculo" datasource="#session.DSN#">
	select PPnumero,
			coalesce(PPfecha_pago,PPfecha_vence) as fecha,
			PPsaldoant             as saldoant,
			PPprincipal            as principal,
			PPinteres              as intereses,
			PPprincipal+PPinteres  as total,
			PPsaldoant-PPprincipal as saldofinal,
			PPpagado as pagado,
			case when PPpagado = 1 then '<img src=../../imagenes/w-check.gif border=0 width=16 height=16>' else '' end as img
	from DeduccionesEmpleadoPlan pp
	where pp.Ecodigo =  #session.Ecodigo# 
	  and Did = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.Did#">
	  --and pp.PPfecha_pago is not null
	order by PPnumero
</cfquery>

<cfoutput>

<table width="100%" cellpadding="0" cellspacing="0" >
	<tr><td>
		<table width="100%" align="center" border="0" cellpadding="2" cellspacing="0" class="areaFiltro">
			<tr>
				<td align="right"><strong>Empleado:&nbsp;</strong></td>
				<td>#data_empleado.DEidentificacion#&nbsp;#data_empleado.DEnombre#</td>
			</tr>
			<tr>
				<td width="1%" nowrap align="right"><strong>Tipo de Deducci&oacute;n:&nbsp;</strong></td>
				<td>#dataPlan.TDcodigo# - #dataPlan.TDdescripcion#</td>
				<td align="right" width="1%" nowrap><strong>Referencia:&nbsp;</strong></td>
				<td>#dataPlan.Dreferencia#</td>
			</tr>
		
			<tr>
				<td align="right"><strong>Descripci&oacute;n:&nbsp;</strong></td>
				<td>#dataPlan.Ddescripcion#</td>
				<td align="right"><strong>Socio:&nbsp;</strong></td>
				<td>#dataPlan.SNnumero# - #dataPlan.SNnombre#</td>
			</tr>
		
			<tr>
				<td align="right"><strong>Monto:&nbsp;</strong></td>
				<td>#LSNumberFormat(dataPlan.Dmonto,',9.00')#</td>
				<td align="right"><strong>Saldo actual:&nbsp;</strong></td>
				<td>#LSNumberFormat(dataSaldo.PPsaldoactual,',9.00')#<input type="hidden" name="Dmonto" value="#dataSaldo.PPsaldoactual#"></td>
			</tr>
			
			<tr>
				<td nowrap align="right"><strong>Fecha Inicial:&nbsp;</strong></td>
				<td>#LSdateFormat(dataSaldo.PPfecha_vence,'dd/mm/yyyy')#<input type="hidden" name="PPfecha_vence" value="#LSdateFormat(dataSaldo.PPfecha_vence,'dd/mm/yyyy')#"></td>
				<td nowrap align="right"><strong>Cuotas restantes:&nbsp;</strong></td>
				<td>#LSNumberFormat(dataPlan.Dnumcuotas,',9.00')#<input type="hidden" name="Dnumcuotas" value="#dataPlan.Dnumcuotas#"></td>
			</tr>
			
			<tr>
				<td align="right"><strong>Inter&eacute;s:&nbsp;</strong></td>
				<td>#LSNumberFormat(dataPlan.Dtasa,',9.00')#%<input type="hidden" name="Dtasa" value="#dataPlan.Dtasa#"></td>
				<td align="right" nowrap><strong>Inter&eacute;s Moratorio:&nbsp;</strong></td>
				<td>#LSNumberFormat(dataPlan.Dtasamora,',9.00')#%<input type="hidden" name="Dtasamora" value="#dataPlan.Dtasamora#"></td>
			</tr>
		</table>
		</cfoutput>
	</td></tr>
		
	<tr><td>
		<cfinvoke component="sif.Componentes.pListas" method="pListaQuery" 
			query="#calculo#"
			desplegar="PPnumero,img,fecha,principal,intereses,total,saldofinal"
			etiquetas="N&uacute;m,&nbsp;,Fecha,Principal,Intereses,Cuota,Saldo"
			formatos="S,S,D,M,M,M,M"
			align="right,left,left,right,right,right,right"
			checkboxes="N"
			checkedcol="pagado"
			funcion="void(0)"
			MaxRows="0"
			totales="total" keys="PPnumero"
			incluyeForm="false"	>
		</cfinvoke>
	</td></tr>
	<tr><td align="center"><input type="button" name="Cerrar" value="Cerrar Ventana" onClick="window.close();"</td></tr>
</table>

</body>
</html>