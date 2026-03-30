<cfset LvarOBJ_PrecioU = createObject("Component","sif.Componentes.CM_PrecioU").init()>
<!--- Este conlis muestra los ítems del tracking indicado en el parámetro,
	  que no han sido desalmacenados y no están en una póliza abierta --->

<cfif isdefined("url.ETidtracking") and not isdefined("form.ETidtracking")>
	<cfset form.ETidtracking = url.ETidtracking>
<cfelse>
	<cfset form.ETidtracking = -1>
</cfif>

<script language="javascript" type="text/javascript" src="/cfmx/sif/js/utilesMonto.js"></script>
<script language="JavaScript" type="text/javascript">
function Asignar(etiiditem,dolinea,dodescripcion,cantidadrestante,preciou,totallin,caid,cacodigo,cadescripcion,ppais,unidad) {
	if (window.opener.document != null) {

		window.opener.document.form1.ETIiditem.value = etiiditem;		
		window.opener.document.form1.DPDdescripcion.value = dodescripcion;
		
		if (dolinea && dolinea > 0){
			window.opener.document.form1.DOlinea.value = dolinea;
		} 
		else {
			window.opener.document.form1.DOlinea.value = -1;
		}
		
		window.opener.document.form1.DPDcantidad.value = cantidadrestante;
		window.opener.cambiarCantidadRestante(cantidadrestante);
		window.opener.cambiarUnidad(unidad);
		window.opener.document.form1.DPDcostoudescoc.value = fm(preciou,<cfoutput>#LvarOBJ_PrecioU.getDecimales()#</cfoutput>);
		window.opener.document.form1.DPDmontofobreal.value = fm(totallin,2);
		window.opener.cambiarMontoRestante(totallin);
		window.opener.document.form1.CAid.value = caid;
		window.opener.document.form1.CAcodigo.value = cacodigo;
		window.opener.document.form1.CAdescripcion.value = cadescripcion;
		window.opener.cambiarDPDpaisori(ppais);
		window.opener.cambiarImpuesto(caid,ppais);
		window.opener.document.form1.DPDpeso.value = "0.00";
		window.opener.document.form1.DPDcantidad.focus();
		window.opener.document.form1.DPDcantidad.select();
		window.close();
	}
}
</script>

<html>
<head>
<title>Lista de Items del Tracking</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<cf_templatecss>
</head>
<body>

<cfquery name="rsdatos" datasource="#session.dsn#">
	select eti.ETIiditem, eti.DOlinea, eti.Ecodigo, do.CMtipo, do.Cid,
		do.Aid, do.Alm_Aid, do.ACcodigo, do.ACid, art.CAid as CAid, do.Icodigo, 
		do.Ppais, do.DOdescripcion, eti.ETIcantidad, eti.ETtipocambiofac, eti.Mcodigo, 
		#LvarOBJ_PrecioU.enSQL_AS("((eti.ETcostodirecto - eti.ETcostodirectorec) / eti.ETIcantidad)", "preciou")#,
		(eti.ETcostodirecto - eti.ETcostodirectorec) as totallin,
		do.Ucodigo, u.Udescripcion, ca.CAcodigo, ca.CAdescripcion,
		case do.CMtipo when 'A' then 'Artículo' when 'S' then 'Servicio' end as Tipo
	from ETrackingItems eti
		inner join DOrdenCM do
			on do.DOlinea = eti.DOlinea
			and do.Ecodigo = eti.Ecodigo
		left outer join Articulos art
			on art.Aid = do.Aid
			and art.Ecodigo = do.Ecodigo
		left outer join CodigoAduanal ca
			on ca.CAid = art.CAid
			and ca.Ecodigo = art.Ecodigo
		left outer join ImpuestosCodigoAduanal ica
			on ica.Icodigo = ca.Icodigo
			and ica.Ecodigo = ca.Ecodigo
		left outer join Unidades u
			on u.Ucodigo = do.Ucodigo
			and u.Ecodigo = do.Ecodigo
	where eti.ETIestado = 0
		and eti.ETIcantidad > 0
		and eti.ETcantfactura > 0
		and eti.ETIestado = 0
		and eti.DOlinea not in (
			select dpd.DOlinea
			from DPolizaDesalmacenaje dpd
				inner join EPolizaDesalmacenaje epd
					on dpd.EPDid = epd.EPDid
					and dpd.Ecodigo = epd.Ecodigo
			where dpd.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
				and epd.EPDestado = 0
				and epd.EPembarque = <cfqueryparam cfsqltype="cf_sql_char" value="#trim(form.ETidtracking)#">
		)
		and eti.ETidtracking = <cfqueryparam cfsqltype="cf_sql_numeric" value="#trim(form.ETidtracking)#">
</cfquery>

<cfinvoke component="sif.Componentes.pListas" method="pListaQuery" returnvariable="pListaRet">
	<cfinvokeargument name="debug" value="N"/>
	<cfinvokeargument name="query" value="#rsdatos#"/>
	<cfinvokeargument name="desplegar" value="DOdescripcion, ETIcantidad, Tipo"/>
	<cfinvokeargument name="etiquetas" value="Descripcion, Cantidad Disponible, Tipo"/>
	<cfinvokeargument name="formatos" value=""/>
	<cfinvokeargument name="align" value="left, left, left"/>
	<cfinvokeargument name="ajustar" value=""/>
	<cfinvokeargument name="irA" value="ConlisFacturas.cfm"/>
	<cfinvokeargument name="formName" value="listaFacturas"/>
	<cfinvokeargument name="MaxRows" value="15"/>
	<cfinvokeargument name="funcion" value="Asignar"/>
	<cfinvokeargument name="fparams" value="ETIiditem,DOlinea,DOdescripcion,ETIcantidad,preciou,totallin,CAid,CAcodigo,CAdescripcion,Ppais,Udescripcion"/>
	<cfinvokeargument name="showEmptyListMsg" value="yes"/>
</cfinvoke>
</body>
</html>