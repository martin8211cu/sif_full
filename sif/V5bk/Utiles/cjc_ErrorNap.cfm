<cfquery name="rs" datasource="#session.Fondos.dsn#">
select  CJX20TIP,
  C.CJX20NUF,
  B.CJX19REL,
  B.CJX20NUM,
  B.CJX21LIN, 
  B.CGE5COD,  
  convert(varchar(30), ltrim(rtrim(B.CGM1IM))+'-' + ltrim(rtrim(B.CGM1CD))) as cuenta,
  convert(varchar,((B.CJX21MNT - B.CJX21MDS) + isnull(B.CJX21IGA, 0.00) + isnull(B.CJX21ICF, 0.00)),1) as monto
from PRT039 A, CJX021 B, CJX020 C
where PRT39ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#URL.NAP#" >
  and A.PRMREL = B.CJX19REL
  and convert(int, A.PRMDOC) = B.CJX20NUM
  and A.PR1COD = B.PR1COD
  and A.PRT7IDE = B.PRT7IDE
  and A.CP6RUB = B.CP6RUB
  and A.CP7SUB = B.CP7SUB
  and B.CJX19REL = C.CJX19REL
  and B.CJX20NUM = C.CJX20NUM
  and PRT39MO != 0.00	
</cfquery><head>
<meta http-equiv="Content-Type" content="text/html; charset=windows-1252">
<meta name="GENERATOR" content="Microsoft FrontPage 4.0">
<meta name="ProgId" content="FrontPage.Editor.Document">
<title>Facturas sin presupuesto</title>
</head>




<form name="formlista" method="post">
<table  width="100%"cellpadding="0" cellspacing="0">
<link href="/cfmx/sif/V5/css/sif.css" rel="stylesheet" type="text/css">
<tr>
	<td  colspan="8"  align="center"><strong>No se pudo aplicar la relación</strong></td>
</tr>
<tr>
	<td  colspan="8"  align="center"><strong>Existen cuentas sin presupuesto</strong></td>
</tr>
<tr>
	<td class="tituloListas">Tipo</td>
	<td class="tituloListas">No. Factura</td>
	<td class="tituloListas">No. Relación</td>
	<td class="tituloListas">No. Documento</td>
	<td class="tituloListas">No. línea</td>
	<td class="tituloListas">Segmento</td>
	<td class="tituloListas">Cuenta</td>
	<td class="tituloListas">Monto</td>

</tr>
<cfoutput query="rs">
	<tr>
		<td>#rs.CJX20TIP#</td>
		<td>#rs.CJX20NUF#</td>
		<td>#rs.CJX19REL#</td>
		<td>#rs.CJX20NUM#</td>
		<td>#rs.CJX21LIN#</td>
		<td>#rs.CGE5COD#</td>
		<td>#rs.cuenta#</td>
		<td align="right" >#rs.monto#</td>
	</tr>
</cfoutput>
</table>
</form>

