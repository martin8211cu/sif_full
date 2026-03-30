<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title>Pruebame.Com</title>
<cfquery name="qryX" datasource="minisif">
	select 	ddi.ETidtracking, ddi.DOlinea, ddi.DDlinea, ddi.Ecodigo, do.CMtipo, do.Cid,
			do.Aid, do.Alm_Aid, do.ACcodigo, do.ACid, a.CAid, coalesce(ica.Icodigo,ca.Icodigo), 
			do.Ppais, do.DOdescripcion, 0.00, ddi.cantidadrestante, ddi.Ucodigo, round(ddi.DDIpreciou * edi.EDItc,2), round(ddi.montorestante * edi.EDItc,2)

	from EDocumentosI edi
		inner join DDocumentosI ddi
		on ddi.EDIid = edi.EDIid
		and ddi.Ecodigo = edi.Ecodigo
		and ddi.cantidadrestante > 0
		and ddi.DDIafecta = 3
		and ddi.ETidtracking = 500000000000005
		and ddi.DDlinea not in  (
			select y.DDlinea from EPolizaDesalmacenaje x
				inner join DPolizaDesalmacenaje y
					on x.EPDid = y.EPDid
					and x.Ecodigo = y.Ecodigo
			where x.EPDestado = 0
			and x.Ecodigo = edi.Ecodigo
		)
	
		inner join DOrdenCM do
		on do.DOlinea = ddi.DOlinea
		and do.Ecodigo = ddi.Ecodigo
	
		left outer join Articulos a
		on a.Aid = do.Aid
		and a.Ecodigo = do.Ecodigo
	
		left outer join CodigoAduanal ca
		on ca.CAid = a.CAid
		and ca.Ecodigo = a.Ecodigo
	
		left outer join ImpuestosCodigoAduanal ica
		on ica.CAid = ca.CAid
		and ica.Ecodigo = ca.Ecodigo
		and ica.Ppaisori = do.Ppais
		and ica.Ecodigo = do.Ecodigo
	
	where edi.EDIestado = 10
		and edi.EDIimportacion = 1
		and edi.Ecodigo = 1
</cfquery>
</head>
<body>
<cfdump var="#qryX#">
</body>
</html>
