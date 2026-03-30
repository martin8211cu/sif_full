<cfset LvarOBJ_PrecioU = createObject("Component","sif.Componentes.CM_PrecioU").init()>
<cfparam name="url.documento" type="string">
<cfparam name="url.consecutivo" type="numeric">
<cfquery name="rsdatos" datasource="#session.dsn#">
	select edi.EDIid, ddi.DOlinea, ddi.DDlinea, ddi.Ecodigo, do.CMtipo, do.Cid,
		do.Aid, do.Alm_Aid, do.ACcodigo, do.ACid, a.CAid as CAid, do.Icodigo, 
		do.Ppais, do.DOdescripcion, 0.00, ddi.cantidadrestante, edi.EDItc, edi.Mcodigo, 
		#LvarOBJ_PrecioU.enSQL_AS("ddi.DDIpreciou * edi.EDItc", "preciou")#, 
		ddi.montorestante * edi.EDItc as totallin,
		ddi.DDIafecta,ddi.DDIconsecutivo,edi.Ddocumento, i.Idescripcion, ddi.Ucodigo, 
		u.Udescripcion
	from EDocumentosI edi
		inner join DDocumentosI ddi
				left outer join Impuestos i
					on i.Icodigo = ddi.Icodigo
					and i.Ecodigo = ddi.Ecodigo
				left outer join DOrdenCM do
						left outer join Articulos a
							left outer join CodigoAduanal ca
								left outer join ImpuestosCodigoAduanal ica
									on ica.Icodigo = ca.Icodigo
									and ica.Ecodigo = ca.Ecodigo
								on ca.CAid = a.CAid
								and ca.Ecodigo = a.Ecodigo
							on a.Aid = do.Aid
							and a.Ecodigo = do.Ecodigo
					on do.DOlinea = ddi.DOlinea
				left outer join Unidades u
					on u.Ucodigo = ddi.Ucodigo
					and u.Ecodigo = ddi.Ecodigo
			on ddi.DDIconsecutivo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.consecutivo#">
			and ddi.EDIid = edi.EDIid
			and ddi.Ecodigo = edi.Ecodigo
			and ddi.cantidadrestante > 0
			and ddi.EPDid is null
			/*and ddi.DDIafecta < 5*/
			and ddi.DDlinea not in  (
				select y.DDlinea from EPolizaDesalmacenaje x
					inner join DPolizaDesalmacenaje y
						on x.EPDid = y.EPDid
						and x.Ecodigo = y.Ecodigo
				where x.EPDestado = 0
				and x.Ecodigo = edi.Ecodigo
			)
			and ddi.DDlinea not in  (
				select y.DDlinea from EPolizaDesalmacenaje x
					inner join FacturasPoliza y
						on x.EPDid = y.EPDid
						and x.Ecodigo = y.Ecodigo
				where x.EPDestado = 0
				and x.Ecodigo = edi.Ecodigo
			)
			and ddi.DDlinea not in  (
				select y.DDlinea from EPolizaDesalmacenaje x
					inner join CMImpuestosPoliza y
						on x.EPDid = y.EPDid
						and x.Ecodigo = y.Ecodigo
				where x.EPDestado = 0
				and x.Ecodigo = edi.Ecodigo
			)
	where edi.EDIestado = 10
		and edi.EDIimportacion = 1
		and	upper(rtrim(ltrim(edi.Ddocumento))) = <cfqueryparam cfsqltype="cf_sql_char" value="#ucase(trim(url.documento))#">
		and edi.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
</cfquery>
<cfoutput>
<cfif rsdatos.recordcount>
  <script language="javascript" type="text/javascript">
	window.parent.Ddocumento_DDlinea.value = "#rsdatos.Ddocumento#";
	window.parent.DDIconsecutivo.value = "#rsdatos.DDIconsecutivo#";
	window.parent.EDIid_DDlinea.value = "#rsdatos.EDIid#";
	window.parent.DDlinea.value = "#rsdatos.DDlinea#";
	window.parent.DOlinea.value = "#iif(len(rsdatos.DOlinea),DE(rsdatos.DOlinea),DE(-1))#";
	window.parent.cambiarFPafecta("#rsdatos.DDIafecta#");
	window.parent.DPDcantidad.value = "#rsdatos.cantidadrestante#";
	window.parent.cambiarCantidadRestante(#rsdatos.cantidadrestante#);
	window.parent.cambiarUnidad("#rsdatos.Udescripcion#");
	window.parent.DPDcostoudescoc.value = "#LvarOBJ_PrecioU.enCF(rsdatos.preciou)#";
	window.parent.DPDmontofobreal.value = "#LSCurrencyFormat(rsdatos.totallin,'none')#";
	window.parent.cambiarMontoRestante(#rsdatos.totallin#);
	if (#rsdatos.DDIafecta#==3) {
		window.parent.cambiarCAid("#rsdatos.CAid#");
		window.parent.cambiarDPDpaisori("#rsdatos.Ppais#");
	} else {
		window.parent.cambiarImpuesto2("#rsdatos.Icodigo#","#rsdatos.Idescripcion#");
	}
	window.parent.DPDpeso.value = "0.00";
	if (#rsdatos.DDIafecta#==3) {
		window.parent.DPDcantidad.focus();
		window.parent.DPDcantidad.select();
	} else if (#rsdatos.DDIafecta#==5) {
		window.parent.AltaDet.focus();
	} else {
		window.parent.DPDmontofobreal.focus();
		window.parent.DPDmontofobreal.select();
	}
  </script>
<cfelse>
  <script language="javascript" type="text/javascript">
	window.parent.Ddocumento_DDlinea.value = "";
	window.parent.DDIconsecutivo.value = "";
	window.parent.EDIid_DDlinea.value = "";
	window.parent.DDlinea.value = "";
	window.parent.DOlinea.value = "";
	window.parent.cambiarFPafecta("3");
	window.parent.DPDcantidad.value = "0";
	window.parent.cambiarCantidadRestante("0");
	window.parent.cambiarUnidad("");
	window.parent.DPDcostoudescoc.value = "0.00";
	window.parent.DPDmontofobreal.value = "0.00";
	window.parent.cambiarMontoRestante("0");
	window.parent.cambiarCAid("");
	window.parent.cambiarDPDpaisori("");
	window.parent.DPDpeso.value = "0.00";
	window.parent.Ddocumento_DDlinea.focus();
	window.parent.Ddocumento_DDlinea.select();
  </script>
</cfif>
</cfoutput>