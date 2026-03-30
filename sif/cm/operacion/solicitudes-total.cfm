<cfif isdefined("url.DScant") and isdefined("url.DSmontoest") and isdefined("url.ESidsolicitud")>
	<cfif len(trim(url.DScant)) and len(trim(url.DSmontoest))>

		<cfquery name="rsTotales" datasource="#session.DSN#">
			select coalesce(round(ROUND(DScant*DSmontoest,2)* COALESCE(d.ValorCalculo/100,0),2),0)  as TotalIEPS,
				   coalesce(sum(DScant*DSmontoest),0) as subtotal,

				   case when (b.DStipo = 'S' or b.DStipo = 'A') and (e.afectaIVA = 1 or f.afectaIVA = 1) THEN
					    coalesce(round(DScant*DSmontoest,2),0)
					  else
					    coalesce(round(DScant*DSmontoest,2)+ round(ROUND(DScant*DSmontoest,2)* COALESCE(d.ValorCalculo/100,0),2),0)
				   end as as TbaseIVA,

				   case when (b.DStipo = 'S' or b.DStipo = 'A') and (e.afectaIVA = 1 or f.afectaIVA = 1) THEN
					    coalesce(round(round(DScant*DSmontoest,2) * c.Iporcentaje/100,2),0)
					  else
					    coalesce(round((round(DScant*DSmontoest,2)+ round(ROUND(DScant*DSmontoest,2)* COALESCE(d.ValorCalculo/100,0),2)) * c.Iporcentaje/100,2),0)
					  end as impuesto,

				   case when (b.DStipo = 'S' or b.DStipo = 'A') and (e.afectaIVA = 1 or f.afectaIVA = 1) THEN
					    coalesce(round(round(DScant*DSmontoest,2) * c.Iporcentaje/100,2) +
					    round(DScant*DSmontoest,2)+ round(ROUND(DScant*DSmontoest,2)* COALESCE(d.ValorCalculo/100,0),2),0)
					  else
					    coalesce(round((round(DScant*DSmontoest,2)+ round(ROUND(DScant*DSmontoest,2)* COALESCE(d.ValorCalculo/100,0),2)) * c.Iporcentaje/100,2) +
					    round(DScant*DSmontoest,2)+ round(ROUND(DScant*DSmontoest,2)* COALESCE(d.ValorCalculo/100,0),2),0)
					  end as STMontoT

						from ESolicitudCompraCM a
						inner join DSolicitudCompraCM b
							on a.ESidsolicitud=b.ESidsolicitud
						inner join Impuestos c
							on a.Ecodigo=c.Ecodigo
							and b.Icodigo=c.Icodigo
						left join Impuestos d
							on a.Ecodigo=d.Ecodigo
							and b.codIEPS=d.Icodigo
						left join Conceptos e
							on e.Cid = b.Cid
						left join Articulos f
							on f.Aid= b.Aid

			where a.ESidsolicitud=<cfqueryparam cfsqltype="cf_sql_numeric" value="#url.ESidsolicitud#">
			<cfif isdefined("url.DSlinea") >
				and b.DSlinea <> <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.DSlinea#">
			</cfif>
		</cfquery>

			<cfquery name="obtienetipo" datasource="#session.dsn#">
				select a.DStipo,e.afectaIVA as AFIvaS,f.afectaIVA as AFIvaA
				from ESolicitudCompraCM a
						inner join DSolicitudCompraCM b
							on a.ESidsolicitud=b.ESidsolicitud
						inner join Impuestos c
							on a.Ecodigo=c.Ecodigo
							and b.Icodigo=c.Icodigo
						left join Impuestos d
							on a.Ecodigo=d.Ecodigo
							and b.codIEPS=d.Icodigo
						left join Conceptos e
							on e.Cid = b.Cid
						left join Articulos f
							on f.Aid= b.Aid
				where a.ESidsolicitud=<cfqueryparam cfsqltype="cf_sql_numeric" value="#url.ESidsolicitud#">
				<cfif isdefined("url.DSlinea") >
					and b.DSlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.DSlinea#">
			</cfquery>

			<!--- PROCESA LA LINEA QUE SE ESTA AGREGANDO O MODIFICANDO --->
			<cfset pctImpuesto  = 0 >
			<cfif isdefined("url.Icodigo") and len(trim(url.Icodigo))>
				<cfquery name="rsImpuesto" datasource="#session.DSN#">
					select coalesce(Iporcentaje,0) as Iporcentaje
					from Impuestos
					where Icodigo=<cfqueryparam cfsqltype="cf_sql_varchar" value="#url.Icodigo#">
					and Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
				</cfquery>
				<cfif rsImpuesto.RecordCount gt 0 and len(trim(rsImpuesto.Iporcentaje)) >
					<cfset pctImpuesto = rsImpuesto.Iporcentaje >
				</cfif>
			</cfif>

			<!--- IMPUESTO del IEPS --->
			<cfset pctImpIeps  = 0 >
			<cfif isdefined("url.icodieps") and len(trim(url.icodieps))>
				<cfquery name="rsImpieps" datasource="#session.DSN#">
					select coalesce(ValorCalculo,0) as Iporcentaje
					from Impuestos
					where Icodigo=<cfqueryparam cfsqltype="cf_sql_varchar" value="#url.icodieps#">
					and Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
				</cfquery>
				<cfif rsImpieps.RecordCount gt 0 and len(trim(rsImpieps.Iporcentaje)) >
					<cfset pctImpIeps = rsImpieps.Iporcentaje >
				</cfif>
			</cfif>

	<!--- Inicializamos las variables --->
			<cfset impuestos = 0 >
			<cfset vDIeps   = 0>
			<cfset vDBaseDIva  = 0>
			<cfset subtotal = 0>
			<!--- QUITA COMAS DE LOS MONTOS --->
			<cfset vDScant = replace(url.DScant,',','','all')>
			<cfset vDSmontoest = replace(url.DSmontoest,',','','all')>
			<cfset vDStotalest = vDScant * vDSmontoest >
			<cfset vDIeps   = (pctImpIeps * vDStotalest)/100>

		<cfif obtienetipo.AFIvaS eq 1 or obtienetipo.AFIvaA eq 1>
			<cfset vDBaseDIva  = vDStotalest>
		<cfelse>
			<cfset vDBaseDIva  = vDIeps + vDStotalest>
		</cfif>

			<!--- IMPUESTOS DE LA LINEA QU ESE ESTA AGREGANDO/MODIFICANDO--->
			<cfset impuestos = (pctImpuesto * vDBaseDIva)/100 >




	<!--- IMPUESTOS TOTALES (IMP. ACUMULADO + IMP. DE LA LINEA EN PROCESO ) --->

			<cfset impuestos = impuestos +  rsTotales.impuesto >
			<cfset vDIeps   = vDIeps + rsTotales.TotalIEPS>
			<cfset vDBaseDIva  = vDBaseDIva + rsTotales.TbaseIVA>
			<!--- SUBTOTAL --->
			<cfset subtotal = rsTotales.subtotal + vDStotalest >
		<cfif obtienetipo.AFIvaS eq 1 or obtienetipo.AFIvaA eq 1>
			<cfset total = vDBaseDIva + impuestos + vDIeps>
		<cfelse>
			<cfset total = vDBaseDIva + impuestos >
		</cfif>

		<!---</cfif>--->
	</cfif>

	<script language="javascript1.2" type="text/javascript" src="../../js/utilesMonto.js"></script>
	<script language="javascript1.2" type="text/javascript">
		<cfoutput>
		window.parent.document.form2._subtotal.value = '#subtotal#';
		window.parent.document.form2._ieps.value = '#vDIeps#';
		window.parent.document.form2._baseIVA.value = '#vDBaseDIva#';
		window.parent.document.form2._impuesto.value = '#impuestos#';
		window.parent.document.form2._total.value = '#total#';
		</cfoutput>

		fm(window.parent.document.form2._subtotal,2);
		fm(window.parent.document.form2._ieps,2);
		fm(window.parent.document.form2._baseIVA,2);
		fm(window.parent.document.form2._impuesto,2);
		fm(window.parent.document.form2._total,2);
	</script>
</cfif>