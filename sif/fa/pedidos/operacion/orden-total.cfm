<cfset LvarOBJ_PrecioU = createObject("Component","sif.Componentes.CM_PrecioU").init()>
<cfparam name="url.Ecodigo" default="#session.Ecodigo#">
<cfif isdefined("url.DOcantidad") and isdefined("url.DOpreciou") and isdefined("url.EOidorden")>
	<cfif len(trim(url.DOcantidad)) and len(trim(url.DOpreciou))>
		<cfquery name="rsDescuento" datasource="#session.DSN#">
			select coalesce(EOdesc,0) as EOdesc
			from EPedido
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.Ecodigo#">
			  and EOidorden = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.EOidorden#">
		</cfquery>
		
		<cfquery name="rsTotales" datasource="#session.DSN#">
			select coalesce(sum((Iporcentaje*DOpreciou*DOcantidad)/100),0) as impuesto, 
				   coalesce(sum(DOcantidad*DOpreciou),0) as subtotal
			from EPedido a
			
			inner join DPedido b
			on a.Ecodigo=b.Ecodigo
				 and a.EOidorden=b.EOidorden
			
			inner join Impuestos c
			on a.Ecodigo=c.Ecodigo
				 and b.Icodigo=c.Icodigo
			
			where a.EOidorden = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.EOidorden#">

			<cfif isdefined("url.DOlinea") >
				and b.DOlinea <> <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.DOlinea#">
			</cfif>
		</cfquery>

			<!--- PROCESA LA LINEA QUE SE ESTA AGREGANDO O MODIFICANDO --->
			<cfset pctImpuesto  = 0 >
			<cfif isdefined("url.Icodigo") and len(trim(url.Icodigo))>
				<cfquery name="rsImpuesto" datasource="#session.DSN#">
					select coalesce(Iporcentaje,0) as Iporcentaje
					from Impuestos 
					where Icodigo=<cfqueryparam cfsqltype="cf_sql_varchar" value="#url.Icodigo#">
					and Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#url.Ecodigo#">
				</cfquery>
				<cfif rsImpuesto.RecordCount gt 0 and len(trim(rsImpuesto.Iporcentaje)) >
					<cfset pctImpuesto = rsImpuesto.Iporcentaje >
				</cfif>
			</cfif>

			<!--- QUITA COMAS DE LOS MONTOS --->
			<cfset vDOcant = replace(url.DOcantidad,',','','all')>
			<cfset vDOpreciou = LvarOBJ_PrecioU.enCF(replace(url.DOpreciou,',','','all'))>
			<cfset vDOtotalest = vDOcant * vDOpreciou >
			
			<!--- DESCUENTO --->
			<cfset descuento = 0 >
			<cfif isdefined("url.EOdesc") and len(trim(url.EOdesc)) >
				<cfset descuento = replace(url.EOdesc,',','','all') >
			</cfif>

			<!--- IMPUESTOS DE LA LINEA QUE SE ESTA AGREGANDO/MODIFICANDO--->
			<cfset impuestos = (pctImpuesto * vDOtotalest)/100 >

			<!--- IMPUESTOS TOTALES (IMP. ACUMULADO + IMP. DE LA LINEA EN PROCESO ) --->
			<cfset impuestos = impuestos +  rsTotales.impuesto >
			
			<!--- SUBTOTAL --->
			<cfset subtotal = rsTotales.subtotal + vDOtotalest >

			<cfset total = subtotal + impuestos - descuento >
	</cfif>

	<script language="javascript1.2" type="text/javascript" src="../../js/utilesMonto.js"></script>
	<script language="javascript1.2" type="text/javascript">
		<cfoutput>
		window.parent.document.form1._subtotal.value = '#subtotal#';
		window.parent.document.form1._impuesto.value = '#impuestos#';
		window.parent.document.form1._descuento.value = '#descuento#';
		window.parent.document.form1._total.value = '#total#';
		</cfoutput>
	
		fm(window.parent.document.form1._subtotal,2);
		fm(window.parent.document.form1._impuesto,2);
		fm(window.parent.document.form1._descuento,2);
		fm(window.parent.document.form1._total,2);
	</script>
</cfif>