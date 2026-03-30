<cfinvoke  key="LB_Titulocxc" default="Lista de Documentos de Cuentas por Cobrar" component="sif.Componentes.Translate" method="Translate"
returnvariable="LB_Titulocxc" xmlfile="Neteo-Ddocumentoconlis.xml"/>
<cfinvoke  key="LB_Documentocxc" default="Documento" component="sif.Componentes.Translate" method="Translate"
returnvariable="LB_Documentocxc" xmlfile="Neteo-Ddocumentoconlis.xml"/>
<cfinvoke  key="LB_Retencioncxc" default="Retencion" component="sif.Componentes.Translate" method="Translate"
returnvariable="LB_Retencioncxc" xmlfile="Neteo-Ddocumentoconlis.xml"/>
<cfinvoke  key="LB_Saldocxc" default="Saldo" component="sif.Componentes.Translate" method="Translate"
returnvariable="LB_Saldocxc" xmlfile="Neteo-Ddocumentoconlis.xml"/>
<cfinvoke  key="MSG_Registroscxc" default="*** No se encontr&oacute; ning&uacute;n documento ***" component="sif.Componentes.Translate" method="Translate"
returnvariable="MSG_Registroscxc" xmlfile="Neteo-Ddocumentoconlis.xml"/>

<cfif isdefined("url.Mcodigo") and len(trim(url.Mcodigo)) GT 0><cfset form.Mcodigo = url.Mcodigo></cfif>
<cfif isdefined("url.CCTcodigo") and len(trim(url.CCTcodigo)) GT 0><cfset form.CCTcodigo = url.CCTcodigo></cfif>
<cfif isdefined("url.SNcodigo") and len(trim(url.SNcodigo)) GT 0><cfset form.SNcodigo = url.SNcodigo></cfif>
<cfparam name="form.Mcodigo" type="numeric">
<cfparam name="form.CCTcodigo" type="string">
<cfparam name="form.SNcodigo" type="string">
<cfparam name="navegacion" type="string" default="">
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<cf_templatecss>
<title="#LB_Titulocxc#">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<script language="javascript" type="text/javascript" src="../../js/utilesMonto.js"></script>
<script language="javascript" type="text/javascript">
	<!--//
	function funcion(p1,p2,r1,r2){
		window.opener.document.formcxc.HDdocumento.value = p1;
		window.opener.document.formcxc.Ddocumento.value = p1;
		window.opener.document.formcxc.Dsaldo.value = fm(p2,2);

		window.opener.document.formcxc.Dmonto.value = fm(p2,2);
		window.opener.document.formcxc.Dmonto.focus();
		if (window.opener.sbRetencionCxC)
			window.opener.sbRetencionCxC(r1,r2,p2);
		window.close();
	}
	//-->
</script>
</head>
<body>
<cfquery name="rs" datasource="#session.dsn#">
	select a.Mcodigo, 
			rtrim(a.Ddocumento) as Ddocumento, 
			rtrim(a.CCTcodigo) as CCTcodigo, 
			b.CCTdescripcion, 
			a.Dsaldo, 
			c.SNnombre,
			r.Rcodigo, r.Rporcentaje
	from Documentos a
		inner join CCTransacciones b
			on a.CCTcodigo = b.CCTcodigo
			and a.Ecodigo = b.Ecodigo
		inner join SNegocios c
			on c.SNcodigo = a.SNcodigo
			and c.Ecodigo = a.Ecodigo
		left join Retenciones r
			 on r.Rcodigo = a.Rcodigo
			and r.Ecodigo = a.Ecodigo
	where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		and a.CCTcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#form.CCTcodigo#">
		and a.SNcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.SNcodigo#">
		and a.Mcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Mcodigo#">
		and a.SNcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.SNcodigo#">
		and Dsaldo > 0
		and Ddocumento not in(
				select Ddocumento 
				from DocumentoNeteoDCxC b inner join DocumentoNeteo c
					on b.idDocumentoNeteo = c.idDocumentoNeteo
					and b.Ecodigo = c.Ecodigo
					and c.Aplicado = 0
				where b.Ecodigo = a.Ecodigo
					and b.Ddocumento = a.Ddocumento
					and b.CCTcodigo = a.CCTcodigo
			)
	order by b.CCTcodigo,c.SNcodigo
</cfquery>
<table width="100%"  border="0" cellspacing="0" cellpadding="0">
  <tr>
    <td style="text-transform:uppercase" align="center" bgcolor="#CCCCCC"><strong><cfoutput>#LB_Titulocxc#</cfoutput></strong></td>
  </tr>
</table>
<cfinvoke 
	component="sif.Componentes.pListas"
	method="pListaQuery"	
	returnvariable="pLista"
	query="#rs#"
	cortes="SNnombre,CCTdescripcion"
	desplegar="Ddocumento,Rcodigo, Dsaldo"
	etiquetas="#LB_Documentocxc#, #LB_Retencioncxc#, #LB_Saldocxc#"
	formatos="S,S,M"
	align="left,center,right"
	funcion="funcion"
	fparams="Ddocumento, Dsaldo, Rcodigo, Rporcentaje"
	navegacion="&Mcodigo=#form.Mcodigo#&CCTcodigo=#form.CCTcodigo#&SNcodigo=#form.SNcodigo##navegacion#"
	maxrows="12"
	showemptylistmsg="true"
	emptylistmsg="#MSG_Registroscxc#"
/>
</body>
</html>