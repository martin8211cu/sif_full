<cfif not (isdefined("form.Mcodigo") and isdefined("form.Eid") and isdefined("form.ETid") and isdefined("form.EEid")) >
	<cflocation url="comparativo-filtro.cfm">
</cfif>

<cfquery datasource="#session.dsn#" name="dflt" maxrows="1">
	select EEid, ETid, Eid
	from RHEncuestadora
	where RHEinactiva = 0
	  and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	order by RHEdefault desc
</cfquery>

<cfif isdefined("form.CFid") and len(trim(form.CFid)) and isdefined("form.dependencias")>
	<cfquery name="rsCFuncional" datasource="#session.DSN#">
		select CFpath
		from CFuncional
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		  and CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CFid#">
	</cfquery>
	<cfset vRuta = rsCFuncional.CFpath >
</cfif>

<cf_dbtemp name="tbl_trabajoAdmSal" returnvariable="tbl_trabajoAdmSal">
	<cf_dbtempcol name="EPcodigo"		type="char(10)" mandatory="yes" >
	<cf_dbtempcol name="EPdescripcion"	type="varchar(80)" 	mandatory="yes" >
	<cf_dbtempcol name="rango1"			type="float" 	mandatory="yes" >
	<cf_dbtempcol name="rango2"			type="float" 	mandatory="yes" >
	<cf_dbtempcol name="rango3"			type="float" 	mandatory="yes" >
	<cf_dbtempcol name="rango4"			type="float" 	mandatory="yes" >
	<cf_dbtempcol name="RHPcodigo"		type="char(10)" 	mandatory="yes" >
	<cf_dbtempcol name="RHPDescPuesto"	type="varchar(80)" 	mandatory="yes" >
	<cf_dbtempcol name="Total"			type="numeric" 	mandatory="yes" >
</cf_dbtemp>

<cf_dbtemp name="tbl_trabajoRangos" returnvariable="tbl_trabajoRangos">
	<cf_dbtempcol name="rango1"			type="float" 		mandatory="yes" >
	<cf_dbtempcol name="rango2"			type="float" 		mandatory="yes" >
	<cf_dbtempcol name="rango3"			type="float" 		mandatory="yes" >
	<cf_dbtempcol name="rango4"			type="float" 		mandatory="yes" >
	<cf_dbtempcol name="Puestos"		type="varchar(1024)" mandatory="no" >
</cf_dbtemp>

<cfquery datasource="#session.dsn#" name="encuesta">
	insert into #tbl_trabajoAdmSal#(RHPcodigo,RHPDescPuesto,EPcodigo, EPdescripcion, rango1, rango2, rango3, rango4, Total)
	select distinct ep.RHPcodigo, 
		   p.RHPdescpuesto,
		   ref.EPcodigo,
		   ref.EPdescripcion,	
			
			( select coalesce(count(1),0)
			  from LineaTiempo a
	
			  inner join TiposNomina b
			  on a.Tcodigo=b.Tcodigo
			    and a.Ecodigo=b.Ecodigo	
	
			  where a.RHPcodigo=ep.RHPcodigo
			  and a.Ecodigo=ep.Ecodigo
			  and getdate() between a.LTdesde and a.LThasta
			  and LTsalario > 0 and LTsalario <= es.ESp25   ) as rango1 /* 0-25 */,
	
			( select coalesce(count(1),0)
			  from LineaTiempo a
	
			  inner join TiposNomina b
			  on a.Tcodigo=b.Tcodigo
			    and a.Ecodigo=b.Ecodigo	
	
			  where a.RHPcodigo=ep.RHPcodigo
			  and a.Ecodigo=ep.Ecodigo
			  and getdate() between a.LTdesde and a.LThasta
			  and LTsalario > es.ESp25 and LTsalario <= es.ESp50   ) as rango2 /* 25-50 */,
	
			( select coalesce(count(1),0)
			  from LineaTiempo a
	
			  inner join TiposNomina b
			  on a.Tcodigo=b.Tcodigo
			    and a.Ecodigo=b.Ecodigo	
	
			  where a.RHPcodigo=ep.RHPcodigo
			  and a.Ecodigo=ep.Ecodigo
			  and getdate() between a.LTdesde and a.LThasta
			  and LTsalario > es.ESp50 and LTsalario <= es.ESp75   ) as rango3 /* 50-75 */,
	
			( select coalesce(count(1),0)
			  from LineaTiempo a
	
			  inner join TiposNomina b
			  on a.Tcodigo=b.Tcodigo
			    and a.Ecodigo=b.Ecodigo	
	
			  where a.RHPcodigo=ep.RHPcodigo
			  and a.Ecodigo=ep.Ecodigo
			  and getdate() between a.LTdesde and a.LThasta
			  and LTsalario > es.ESp75   ) as rango4 /* 75-50 */,
			  
			( select coalesce(count(1),0)
			  from LineaTiempo a
			  inner join TiposNomina b
			  on a.Tcodigo=b.Tcodigo
			    and a.Ecodigo=b.Ecodigo	
			  where a.RHPcodigo=ep.RHPcodigo
			  and a.Ecodigo=ep.Ecodigo
			  and getdate() between a.LTdesde and a.LThasta 
			  and LTsalario > 0) as total
			  
	from RHEncuestaPuesto ep
	
	inner join EncuestaSalarios es
	on ep.EEid=es.EEid
	and ep.EPid=es.EPid
	
	inner join EncuestaPuesto ref
	on es.EPid=ref.EPid
	
	inner join RHPuestos p
	on ep.Ecodigo=p.Ecodigo
	and rtrim(ltrim(ep.RHPcodigo))=rtrim(ltrim(p.RHPcodigo))

		inner join RHPlazas plz
			on plz.Ecodigo=p.Ecodigo
			and plz.RHPpuesto=p.RHPcodigo

	inner join CFuncional cf
		on cf.Ecodigo = plz.Ecodigo 
		and cf.CFid = plz.CFid
	
	where ep.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	and ep.EEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.EEid#">
	<cfif isdefined("vRuta")>
		and ( upper(cf.CFpath) like '#ucase(vRuta)#/%' or cf.CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CFid#">)
	<cfelseif isdefined("form.CFid") and len(trim(form.CFid))>
		and cf.CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CFid#">
	</cfif>
	and es.Moneda = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Mcodigo#">
	and es.Eid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Eid#">
	and es.ETid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ETid#">
</cfquery>

<cfquery name="DefineRangos" datasource="#session.DSN#">
	insert into #tbl_trabajoRangos#(rango1, rango2,rango3,rango4)
	select distinct round((rango1*100)/Total,2), round((rango2*100)/Total,2),round((rango3*100)/Total,2),round((rango4 *100)/Total,2)
	from #tbl_trabajoAdmSal#
	where Total > 0
</cfquery>
<cfquery name="rsDatos" datasource="#session.DSN#">
	select RHPcodigo,round(rango1*100/Total,2) as rango1,round(rango2*100/Total,2) as rango2,round(rango3*100/Total,2) as rango3,round(rango4*100/Total,2)  as rango4, Total
	from #tbl_trabajoAdmSal#
	where Total > 0
</cfquery>
<cfquery name="encuesta2" datasource="#session.DSN#">
	select *
	from #tbl_trabajoRangos#
</cfquery>
<cfoutput query="rsDatos">
	<cf_dbfunction name="concat" args="Puestos,#rsDatos.RHPcodigo#,'&nbsp;'" returnvariable="Lvar_Descr">
	<cfquery name="updatePuestos" datasource="#session.DSN#">
		update #tbl_trabajoRangos#
		set Puestos = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Lvar_Descr#">
		where rango1 = #rsDatos.rango1#
		  and rango2 = #rsDatos.rango2#
		  and rango3 = #rsDatos.rango3#
		  and rango4 = #rsDatos.rango4#
	</cfquery>
</cfoutput>

<cfquery name="encuesta" datasource="#session.DSN#">
	select *
	from #tbl_trabajoAdmSal#
</cfquery>


<cfquery name="encuesta2" datasource="#session.DSN#">
	select *
	from #tbl_trabajoRangos#
</cfquery>

<cfquery name="empresa" datasource="sifpublica">
	select EEnombre
	from EncuestaEmpresa
	where EEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.EEid#">
</cfquery>

<cfquery name="organizacion" datasource="sifpublica">
	select ETdescripcion
	from EmpresaOrganizacion
	where ETid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ETid#">
</cfquery>

<cfquery name="rsEncuesta" datasource="sifpublica">
	select Edescripcion
	from Encuesta
	where Eid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Eid#">
</cfquery>

<cfoutput>
<table width="100%" cellpadding="0" cellspacing="0">
	<tr>
		<td>
			<cf_EncReporte
				Titulo="Consulta Comparativa de Salarios vs Encuestas"
				Color="##E3EDEF"
				filtro1="Empresa Encuestadora: #empresa.EEnombre#"
				filtro2="Tipo de Organizacion: #organizacion.ETdescripcion#"
				filtro3="Encuesta: #rsEncuesta.Edescripcion#"
				Cols= "9"
			>
		</td>
	</tr>
</table>

</cfoutput>
<br>
<table width="99%" align="center" border="0" bgcolor="#CCCCCC" cellpadding="2" cellspacing="1">
	<tr bgcolor="#EdEdEd">
		<td colspan="4">&nbsp;</td>
		<td colspan="4" align="center"><strong>Cantidad de Personas por Percentil</strong></td>
		<td colspan="4">&nbsp;</td>
	</tr>

	<tr bgcolor="#EdEdEd">
		<td colspan="2"><strong>Puesto</strong></td>
		<td colspan="2"><strong>Puesto Referencia</strong></td>
		<td align="right"><strong>< 25</strong></td>
		<td align="right"><strong>25-50</strong></td>
		<td align="right"><strong>50-75</strong></td>
		<td align="right"><strong>> 75</strong></td>
		<td align="right"><strong>Total</strong></td>
	</tr>

	<cfset LvarRango1 = 0 >
	<cfset LvarRango2 = 0 >
	<cfset LvarRango3 = 0 >
	<cfset LvarRango4 = 0 >
	<cfset LvarTotal  = 0 >

	<cfoutput query="encuesta">
		<cfif encuesta.total gt 0 >
			<tr bgcolor="##FFFFFF">
				<td>#HTMLEditFormat(encuesta.RHPcodigo)# </td>
				<td>#HTMLEditFormat(encuesta.RHPdescpuesto)#</td>
				<td>#HTMLEditFormat(encuesta.EPcodigo)# </td>
				<td>#HTMLEditFormat(encuesta.EPdescripcion)#</td>
				<td align="right">#NumberFormat(rango1,',0')#</td>
				<td align="right">#NumberFormat(rango2,',0')#</td>
				<td align="right">#NumberFormat(rango3,',0')#</td>
				<td align="right">#NumberFormat(rango4,',0')#</td>
				<td align="right">#NumberFormat(total,',0')#</td>
			</tr>
			
			<cfset LvarRango1 = encuesta.rango1 + LvarRango1 >
			<cfset LvarRango2 = encuesta.rango2 + LvarRango2 >
			<cfset LvarRango3 = encuesta.rango3 + LvarRango3 >
			<cfset LvarRango4 = encuesta.rango4 + LvarRango4 >
			<cfset LvarTotal = encuesta.total   + LvarTotal >
		</cfif>
	</cfoutput>
	
	<cfoutput>
	<tr>
		<td colspan="2"><strong>Totales</strong></td>
		<td colspan="2">&nbsp;</td>
		<td align="right"><strong>#NumberFormat(LvarRango1,',0')#</strong></td>
		<td align="right"><strong>#NumberFormat(LvarRango2,',0')#</strong></td>
		<td align="right"><strong>#NumberFormat(LvarRango3,',0')#</strong></td>
		<td align="right"><strong>#NumberFormat(LvarRango4,',0')#</strong></td>
		<td align="right"><strong>#NumberFormat(LvarTotal,',0')#</strong></td>
	</tr>
	</cfoutput>
</table>
<br>

<table width="750" align="center" border="0">
	<tr><td>

		<cfchart 	format="flash" 
					chartwidth="850" 
					chartheight="300"
				  	gridlines="5" 
					show3d="no"  
					scalefrom="0"  
					scaleto="100" yaxistitle="Porcentaje de Empleados por Percentil" xaxistitle="Percentil" >

			<cfoutput query="encuesta2" group="Puestos">
				<cfchartseries type="scatter" serieslabel="#Puestos#">
				
				<cfoutput>
					<cfchartdata item="Percentil < 25" value="#rango1#">
					<cfchartdata item="Percentil 25-50" value="#rango2#">
					<cfchartdata item="Percentil 50-75" value="#rango3#">
					<cfchartdata item="Percentil > 75" value="#rango4#">
				</cfoutput>
				
				</cfchartseries>
			</cfoutput>	

		</cfchart>

	</td></tr>
	<tr><td>&nbsp;</td></tr>
	<tr><td align="center"><input type="button" name="Regresar" value="Regresar" onclick="javascript:location.href='comparativo-filtro.cfm'"></td></tr>
</table>



