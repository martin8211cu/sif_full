<cfset LvarOBJ_PrecioU = createObject("Component","sif.Componentes.CM_PrecioU").init()>
<!--- Recibe afecta --->
<script language="javascript" type="text/javascript" src="/cfmx/sif/js/utilesMonto.js"></script>
<script language="JavaScript" type="text/javascript">
function Asignar(documento,consecutivo,ediid,ddlinea,dolinea,ddiafecta,cantidadrestante,preciou,totallin,caid,ppais,icodigo,idescripcion,unidad) {
	if (window.opener.document != null) {
		window.opener.document.form1.Ddocumento_DDlinea.value = documento;
		window.opener.document.form1.DDIconsecutivo.value = consecutivo;

		window.opener.document.form1.EDIid_DDlinea.value = ediid;
		window.opener.document.form1.DDlinea.value = ddlinea;
		
		if (dolinea && dolinea > 0){
			window.opener.document.form1.DOlinea.value = dolinea;
		} 
		else {
			window.opener.document.form1.DOlinea.value = -1;
		}
		window.opener.cambiarFPafecta(ddiafecta);
		window.opener.document.form1.DPDcantidad.value = cantidadrestante;
		window.opener.cambiarCantidadRestante(cantidadrestante);
		window.opener.cambiarUnidad(unidad);
		window.opener.document.form1.DPDcostoudescoc.value = fm(preciou,#LvarOBJ_PrecioU.getDecimales()#);
		window.opener.document.form1.DPDmontofobreal.value = fm(totallin,2);
		window.opener.cambiarMontoRestante(totallin);
		if (ddiafecta==3) {
			window.opener.cambiarCAid(caid);
			window.opener.cambiarDPDpaisori(ppais);
		} else {
			window.opener.cambiarImpuesto2(icodigo,idescripcion);
		}
		window.opener.document.form1.DPDpeso.value = "0.00";
		if (ddiafecta==3) {
			window.opener.document.form1.DPDcantidad.focus();
			window.opener.document.form1.DPDcantidad.select();
		} else if (ddiafecta==5) {
			window.opener.document.form1.AltaDet.focus();
		} else {
			window.opener.document.form1.DPDmontofobreal.focus();
			window.opener.document.form1.DPDmontofobreal.select();
		}
		window.close();
	}
}
</script>

<html>
<head>
<title>Lista de Líneas de Facturas</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<cf_templatecss>
</head>
<body>

<cfquery name="rsdatos" datasource="#session.dsn#">
	select edi.EDIid, ddi.DOlinea, ddi.DDlinea, ddi.DDIconsecutivo, edi.Ddocumento, ddi.Ecodigo, do.CMtipo, do.Cid,
		do.Aid, do.Alm_Aid, do.ACcodigo, do.ACid, a.CAid as CAid, do.Icodigo, i.Idescripcion, 
		do.Ppais, do.DOdescripcion, 0.00, ddi.cantidadrestante, edi.EDItc, edi.Mcodigo, 
		#LvarOBJ_PrecioU.enSQL_AS("ddi.DDIpreciou * edi.EDItc", "preciou")#, 
		ddi.montorestante * edi.EDItc as totallin,
		ddi.DDIafecta, case ddi.DDItipo when 'A' then 'Artículo' when 'S' then 'Servicio' end as Tipo,
		case ddi.DDIafecta when 1 then 'Fletes' when 2 then 'Seguros' when 3 then 'Costos' when 4 then 'Gastos' when 5 then 'Impuestos' end as Afecta,
		ddi.Ucodigo, u.Udescripcion
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
					and do.Ecodigo = ddi.Ecodigo
				left outer join Unidades u
					on u.Ucodigo = ddi.Ucodigo
					and u.Ecodigo = ddi.Ecodigo
			on ddi.EDIid = edi.EDIid
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
		and edi.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
</cfquery>
<cfinvoke component="sif.Componentes.pListas"	method="pListaQuery" returnvariable="pListaRet">
	<cfinvokeargument name="debug" value="N"/>
	<cfinvokeargument name="query" value="#rsdatos#"/>
	<cfinvokeargument name="desplegar" value="Ddocumento, DDIconsecutivo, Tipo, Afecta"/>
	<cfinvokeargument name="etiquetas" value="Documento, Consecutivo, Tipo, Afecta A"/>
	<cfinvokeargument name="formatos" value=""/>
	<cfinvokeargument name="align" value="left, left, left, left"/>
	<cfinvokeargument name="ajustar" value=""/>
	<cfinvokeargument name="irA" value="ConlisFacturas.cfm"/>
	<cfinvokeargument name="formName" value="listaFacturas"/>
	<cfinvokeargument name="MaxRows" value="15"/>
	<cfinvokeargument name="funcion" value="Asignar"/>
	<cfinvokeargument name="fparams" value="Ddocumento,DDIconsecutivo,EDIid,DDlinea,DOlinea,DDIafecta,cantidadrestante,preciou,totallin,CAid,Ppais,Icodigo,Idescripcion,Udescripcion"/>
	<cfinvokeargument name="showEmptyListMsg" value="yes"/>
</cfinvoke>
</body>
</html>