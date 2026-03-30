<cfinvoke component="sif.Componentes.Translate" method="init" returnvariable="t">
<cfset LB_TituloH 	= t.Translate('LB_TituloH','SIF - Cuentas por Pagar')>
<cfset TIT_RepRet	= t.Translate('TIT_RepRet','Reporte Retenciones')>
<cfset LB_DatosRep	= t.Translate('LB_DatosRep','Datos del Reporte','FiscalProveedores.xml')>
<cfset LB_Desde		= t.Translate('LB_Desde','Desde','/sif/generales.xml')>
<cfset LB_Hasta		= t.Translate('LB_Hasta','Hasta','/sif/generales.xml')>
<cfset LB_Formato 	= t.Translate('LB_Formato','Formato:','/sif/generales.xml')>
<cfset CMB_Enero 	= t.Translate('CMB_Enero','Enero','/sif/generales.xml')>
<cfset CMB_Febrero 	= t.Translate('CMB_Febrero','Febrero','/sif/generales.xml')>
<cfset CMB_Marzo 	= t.Translate('CMB_Marzo','Marzo','/sif/generales.xml')>
<cfset CMB_Abril 	= t.Translate('CMB_Abril','Abril','/sif/generales.xml')>
<cfset CMB_Mayo 	= t.Translate('CMB_Mayo','Mayo','/sif/generales.xml')>
<cfset CMB_Junio 	= t.Translate('CMB_Junio','Junio','/sif/generales.xml')>
<cfset CMB_Julio 	= t.Translate('CMB_Julio','Julio','/sif/generales.xml')>
<cfset CMB_Agosto 	= t.Translate('CMB_Agosto','Agosto','/sif/generales.xml')>
<cfset CMB_Septiembre = t.Translate('CMB_Septiembre','Septiembre','/sif/generales.xml')>
<cfset CMB_Octubre = t.Translate('CMB_Octubre','Octubre','/sif/generales.xml')>
<cfset CMB_Noviembre = t.Translate('CMB_Noviembre','Noviembre','/sif/generales.xml')>
<cfset CMB_Diciembre = t.Translate('CMB_Diciembre','Diciembre','/sif/generales.xml')>
<cfset LB_TipoProv	= t.Translate('LB_TipoProv','Tipo de Proveedores')>
<cfset LB_Retencion	= t.Translate('LB_Retencion','Retenci&oacute;n')>
<cfset LB_Todos		= t.Translate('LB_Todos','Todos','/sif/generales.xml')>
<cfset LB_Nacionales	= t.Translate('LB_Nacionales','Nacionales')>
<cfset LB_Extranjeros = t.Translate('LB_Extranjeros','Extranjeros')>
<cfset LB_Todas		= t.Translate('LB_Todas','Todas','/sif/generales.xml')>

<cfset parameters = ''>
<cfset parameters = parameters &'formato="'& form.formato &'",'>
<cfset parameters = parameters &'generar="'& form.generar &'",'>
<cfset parameters = parameters &'rcodigo='& form.rcodigo &','>
<cfset parameters = parameters &'tiposocio="'& form.tiposocio &'",'>
<cfset parameters = parameters &'botonsel="'& form.botonsel &'",'>
<cfset parameters = parameters &'mes='& form.mes &','>
<cfset parameters = parameters &'mes2='& form.mes2 &','>
<cfset parameters = parameters &'periodo='& form.periodo &','>
<cfset parameters = parameters &'periodo2='& form.periodo2>

<cffunction name="get_CualMes" access="public" returntype="string">
	<cfargument name="valor" type="numeric" required="true" default="<!--- Nombre del mes --->">
		<cfswitch expression="#valor#">
			<cfcase value="1"> <cfset CualMes = '#CMB_Enero#'> </cfcase>
			<cfcase value="2"> <cfset CualMes = '#CMB_Febrero#'> </cfcase>
			<cfcase value="3"> <cfset CualMes = '#CMB_Marzo#'> </cfcase>
			<cfcase value="4"> <cfset CualMes = '#CMB_Abril#'> </cfcase>
			<cfcase value="5"> <cfset CualMes = '#CMB_Mayo#'> </cfcase>
			<cfcase value="6"> <cfset CualMes = '#CMB_Junio#'> </cfcase>												
			<cfcase value="7"> <cfset CualMes = '#CMB_Julio#'> </cfcase>
			<cfcase value="8"> <cfset CualMes = '#CMB_Agosto#'> </cfcase>
			<cfcase value="9"> <cfset CualMes = '#CMB_Septiembre#'> </cfcase>
			<cfcase value="10"> <cfset CualMes = '#CMB_Octubre#'> </cfcase>
			<cfcase value="11"> <cfset CualMes = '#CMB_Noviembre#'> </cfcase>
			<cfcase value="12"> <cfset CualMes = '#CMB_Diciembre#'> </cfcase>
			<cfdefaultcase> <cfset CualMes = '#CMB_Enero#'> </cfdefaultcase>
		</cfswitch>
	<cfreturn #CualMes#>
</cffunction>


<cf_dbfunction name="OP_concat"	returnvariable="_Cat">
	<!--- informacion de los tipos de retenciones --->
	<cfquery name="tipoRet" datasource="#session.DSN#">

		declare @columnas varchar(max)

		set @columnas = ''
		select @columnas = coalesce(@columnas + '[' + cast(Rcodigo as varchar(12)) + '],', '')
		FROM (select distinct Rcodigo from Retenciones where Ccuentaretc is not null and Ecodigo =  #session.Ecodigo#) as DTM

		set @columnas = left(@columnas,LEN(@columnas)-1)

		select   @columnas as colums

	</cfquery>

	<cfquery name="tipoRetE" datasource="#session.DSN#">

		declare @columnasE varchar(max)
		set @columnasE = ''
		select @columnasE = coalesce(@columnasE + 'isnull([' + cast(Rcodigo as varchar(12)) + '],0) as ret' + cast(Rcodigo as varchar(12)) + ',', '')
		FROM (select distinct Rcodigo from Retenciones where Ccuentaretc is not null and Ecodigo =  #session.Ecodigo#) as DTM

		set @columnasE = left(@columnasE,LEN(@columnasE)-1)

		select   @columnasE as columsE

	</cfquery>

	<!--- <cfquery name="colRetenciones" datasource="#session.DSN#">
		select  Rcodigo,
				Rdescripcion
			from Retenciones 
		where Ccuentaretc is not null 
			and Ecodigo =  #session.Ecodigo#
	</cfquery> --->
	

	<cfquery name="rsReporte" datasource="#session.DSN#">
		select a.BMfecha as Pfecha, 		
			a.CPTcodigo #_Cat# ' - ' #_Cat# a.Ddocumento as Pdocumento,
			b.SNcodigo,
			b.id_direccion,

			b.Dfecha,
			b.CPTcodigo #_Cat# ' - ' #_Cat# b.Ddocumento as Ddocumento,

			b.Rcodigo,+

			b.Dtipocambio,
			m.Miso4217,
			b.IDdocumento,
			a.Dtotal,
			coalesce(a.BMmontoretori,0.00),
			b.Dtotal,
			coalesce((
				select sum (MontoCalculado) 
				  from ImpDocumentosCxP
				 where IDdocumento	= b.IDdocumento
				   and Ecodigo		= b.Ecodigo 
			),0)*coalesce(a.BMmontoretori/b.Dtotal,0.00) as ImpuestoCF,
			(SELECT coalesce(sum(hd.DDtotallin*1.00),0.00) *1.00
			FROM HDDocumentosCP hd
			where hd.IDdocumento = b.IDdocumento
				and hd.Ecodigo		= b.Ecodigo ) as DDtotallin,
			(SELECT coalesce(sum(hd.DDimpuestoCF),0) 
			FROM HDDocumentosCP hd
			where hd.IDdocumento = b.IDdocumento
				and hd.Ecodigo		= b.Ecodigo ) as DDimpuestoCF,
			sn.SNdireccion,
			sn.SNidentificacion,
			sn.SNidentificacion2,
			sn.SNnombre,
			#tipoRetE.columsE#
		from BMovimientosCxP a
		inner join HEDocumentosCP b
			 on b.Ecodigo		= a.Ecodigo 
			and b.SNcodigo		= a.SNcodigo
			and b.CPTcodigo	= a.CPTRcodigo
			and b.Ddocumento	= a.DRdocumento
			and b.Rcodigo is not null
			<cfif isdefined("form.Rcodigo") and len(trim(form.Rcodigo)) >
				and b.Rcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#form.Rcodigo#">
			</cfif>
		inner join Monedas m
			on  a.Ecodigo 		= m.Ecodigo
			and a.Mcodigoref 	= m.Mcodigo
		inner join SNegocios  sn
			on  b.Ecodigo 	= sn.Ecodigo
			and b.SNcodigo = sn.SNcodigo
		left outer join DireccionesSIF  snb
			on   snb.id_direccion  = b.id_direccion 
			<cfif isdefined("form.TipoSocio") and len(trim(form.TipoSocio)) and form.TipoSocio eq 'N'>
				and snb.Ppais =  <cfqueryparam cfsqltype="cf_sql_char" value="#rsPais.Ppais#">
			<cfelseif isdefined("form.TipoSocio") and len(trim(form.TipoSocio)) and form.TipoSocio eq 'E'>
				and snb.Ppais !=  <cfqueryparam cfsqltype="cf_sql_char" value="#rsPais.Ppais#">
			</cfif>
		inner join (SELECT *
					FROM
					(
					select 
					b.Ddocumento,
					ret.F_Rcodigo,
					isnull(ret.Rporcentaje,0) valor
					FROM BMovimientosCxP a
					INNER JOIN HEDocumentosCP b ON b.Ecodigo = a.Ecodigo
					AND b.SNcodigo = a.SNcodigo
					AND b.CPTcodigo = a.CPTRcodigo
					AND b.Ddocumento = a.DRdocumento
					AND b.Rcodigo IS NOT NULL
					inner join (select 
						r.Rcodigo,
						r.Ccuentaretc,
						isnull(rc.RcodigoDet,r.Rcodigo) as F_Rcodigo,
						CASE 
							WHEN  r.Ccuentaretc is null 
							THEN isnull(rrc.Rporcentaje,0)
							ELSE isnull(r.Rporcentaje,0)
						END as Rporcentaje
					from Retenciones r
					left join RetencionesComp rc
					on r.Rcodigo = rc.Rcodigo
					left join Retenciones rrc
					on rc.RcodigoDet = rrc.Rcodigo
					)ret
					on ret.Rcodigo = b.Rcodigo
					WHERE a.BMperiodo >= <cfqueryparam cfsqltype="cf_sql_integer" value="#form.periodo#">
							and a.BMperiodo <= <cfqueryparam cfsqltype="cf_sql_integer" value="#form.periodo2#">
							and (a.BMperiodo * 100 + a.BMmes)  between #form.periodo*100+form.mes# and #form.periodo2*100+form.mes2#
							and a.Ecodigo =  #session.Ecodigo#
							and a.CPTcodigo  <> a.CPTRcodigo
							and a.Ddocumento <> a.DRdocumento
					) AS SourceTable
					PIVOT
					(AVG(valor)
					FOR F_Rcodigo IN (#tipoRet.colums#)
					) AS PivotTable
			)Tretenciones
		on Tretenciones.Ddocumento =b.Ddocumento
		where   
			a.BMperiodo >= <cfqueryparam cfsqltype="cf_sql_integer" value="#form.periodo#">
			and a.BMperiodo <= <cfqueryparam cfsqltype="cf_sql_integer" value="#form.periodo2#">
			and (a.BMperiodo * 100 + a.BMmes)  between #form.periodo*100+form.mes# and #form.periodo2*100+form.mes2#
			and a.Ecodigo =  #session.Ecodigo#
			and a.CPTcodigo  <> a.CPTRcodigo
			and a.Ddocumento <> a.DRdocumento
	</cfquery>


	<cfquery name="rsEmpresa" datasource="#session.DSN#">
		select Edescripcion 
		 from Empresas
	 	where Ecodigo =  #session.Ecodigo# 
	</cfquery>

	<cfset NombMes = '#get_CualMes(form.mes)#'>
	<cfset NombMes2 = '#get_CualMes(form.mes2)#'>


<cf_htmlReportsHeaders 
title="Retenciones" 
filename="Retenciones.xls"
irA="Retenciones.cfm"
download="yes"
preview="yes"
>

<style>
.datagrid table { border-collapse: collapse; text-align: left;  } .datagrid {font: normal 12px/150% Arial, Helvetica, sans-serif; background: #fff; border: 1px solid #8C8C8C; -webkit-border-radius: 3px; -moz-border-radius: 3px; border-radius: 3px; }.datagrid table td, .datagrid table th { padding: 3px 10px; }.datagrid table thead th {background:-webkit-gradient( linear, left top, left bottom, color-stop(0.05, #8C8C8C), color-stop(1, #7D7D7D) );background:-moz-linear-gradient( center top, #8C8C8C 5%, #7D7D7D  );filter:progid:DXImageTransform.Microsoft.gradient(startColorstr='#8C8C8C', endColorstr='#7D7D7D');background-color:#8C8C8C; color:#FFFFFF; font-size: 15px; font-weight: bold; border-left: 1px solid #A3A3A3; } .datagrid table thead th:first-child { border: none; }.datagrid table tbody td { color: #7D7D7D; border-left: 1px solid #DBDBDB;font-size: 10px;font-weight: normal; }.datagrid table tbody .alt td { background: #EBEBEB; color: #7D7D7D; }.datagrid table tbody td:first-child { border-left: none; }.datagrid table tbody tr:last-child td { border-bottom: none; }.datagrid table tfoot td div { border-top: 1px solid #8C8C8C;background: #EBEBEB;} .datagrid table tfoot td { padding: 0; font-size: 12px } .datagrid table tfoot td div{ padding: 2px; }.datagrid table tfoot td ul { margin: 0; padding:0; list-style: none; text-align: right; }.datagrid table tfoot  li { display: inline; }.datagrid table tfoot li a { text-decoration: none; display: inline-block;  padding: 2px 8px; margin: 1px;color: #F5F5F5;border: 1px solid #8C8C8C;-webkit-border-radius: 3px; -moz-border-radius: 3px; border-radius: 3px; background:-webkit-gradient( linear, left top, left bottom, color-stop(0.05, #8C8C8C), color-stop(1, #7D7D7D) );background:-moz-linear-gradient( center top, #8C8C8C 5%, #7D7D7D );filter:progid:DXImageTransform.Microsoft.gradient(startColorstr='#8C8C8C', endColorstr='#7D7D7D');background-color:#8C8C8C; }.datagrid table tfoot ul.active, .datagrid table tfoot ul a:hover { text-decoration: none;border-color: #7D7D7D; color: #F5F5F5; background: none; background-color:#8C8C8C;}


}
</style>

<cfquery name="infoRet" datasource="#session.DSN#">
	select distinct Rcodigo, 
		Rdescripcion 
	from Retenciones 
	where Ccuentaretc is not null 
	and Ecodigo =  #session.Ecodigo#
  	order by Rcodigo
</cfquery>


<cfoutput>
	<div class="datagrid" style="width: 2500px;">
	<table align="center" width="" border="0" summary="">
		
		<tr>
			<th align="center" valign="top" colspan="2">
				<strong>#rsEmpresa.Edescripcion#</strong><br>
				<strong>Reporte sobre pagos y retenciones</strong><br>
				<strong>Cuentas por Pagar</strong><br>
				<strong></strong><br>
			</th>
		</tr>
		<tr>
			<th align="left"><strong>Periodo Desde:#form.periodo#</strong></th>
			<th align="left"><strong>Mes:#NombMes#</strong></th>
			 
		</tr>
		<tr>
			<th align="left"><strong>Periodo Hasta:#form.periodo#</strong></th>
			 <th align="left"><strong>Mes:#NombMes2#</strong></th>
		</tr>
	</table>
	</div>
	<!--- DETALLE DEL REPORTE --->
	<div class="datagrid" style="width: 2500px;">
	<table align="center" width="" border="0" summary="">
		<tr>
			<th align="center" width="8%"><strong>FECHA <br>PAGO</strong></th>
			<th align="center" width="8%"><strong>DOC. <br>PAGO</strong></th>
			<th align="center" width="8%"><strong>RFC</strong></th>
			<th align="center" width="8%"><strong>CURP</strong></th>
			<th align="center" width="15%"><strong>PROVEEDOR</strong></th>
			<th align="center" width="20%"><strong>DOMICILIO <br>FISCAL</strong></th>
			<th align="center" width="8%"><strong>COSTO <br>FACTURA</strong></th>
			<th align="center" width="8%"><strong>IMPUESTO <br>TOTAL</strong></th>
			<cfloop query="infoRet">
			<th align="center" width="8%"><strong>#infoRet.Rdescripcion#</strong></th>
			</cfloop>
			<th align="center" width="8%"><strong>TOTAL <br>PAGO</strong></th>
		</tr>
		<cfsavecontent variable="strTHead">
			<cfset tzebra=1>
			<cfloop query="rsReporte">
				<tr <cfif (tzebra%2) EQ 0> class="alt"</cfif>  >
					<td align="center" >#tzebra#- #DateFormat(rsReporte.Pfecha,'dd/mm/yyyy')#</td>
					<td align="center" >#rsReporte.Pdocumento#</td>
					<td align="center" >#rsReporte.SNidentificacion#</td>
					<td align="center" >#rsReporte.SNidentificacion2#</td>
					<td align="center" >#rsReporte.SNnombre#</span></td>
					<td align="center" >#rsReporte.SNdireccion#</td>
					<td align="center" >#LSNumberFormat(rsReporte.DDtotallin ,',9.00')#  </td>
					<td align="center" >#LSNumberFormat(rsReporte.DDimpuestoCF ,',9.00')# </td>
					<td align="center">#LSNumberFormat((rsReporte.DDtotallin*(rsReporte.ret01/100) ),',9.00')#</td>
					<td align="center" >#LSNumberFormat((rsReporte.DDtotallin*(rsReporte.ret02/100)),',9.00')# </td>	
					<td align="center" >#LSNumberFormat((rsReporte.DDtotallin*(rsReporte.ret03/100)),',9.00')# </td>	
					<td align="center" >#LSNumberFormat((rsReporte.DDtotallin*(rsReporte.ret04/100)),',9.00')# </td>	
					<td align="center" >#LSNumberFormat((rsReporte.DDtotallin*(rsReporte.ret05/100)),',9.00')# </td>	
					<td align="center" >#LSNumberFormat((rsReporte.DDtotallin*(rsReporte.ret06/100)),',9.00')# </td>	
					<td align="center" >#LSNumberFormat((rsReporte.DDtotallin*(rsReporte.ret07/100)),',9.00')# </td>
					<td align="center" >#LSNumberFormat((rsReporte.DDtotallin*(rsReporte.ret08/100)),',9.00')# </td>
					<td align="center" >#LSNumberFormat(rsReporte.Dtotal,',9.00')#</td>
				</tr>
				<cfset tzebra=tzebra+1>
			</cfloop>
		</cfsavecontent>
		<cfoutput>#strTHead#</cfoutput>
	</table>
	</div>
</cfoutput>
