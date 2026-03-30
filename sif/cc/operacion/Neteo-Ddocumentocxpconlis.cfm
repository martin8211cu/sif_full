<cfinvoke  key="LB_Titulocxp" default="Lista de Documentos de Cuentas por Pagar" component="sif.Componentes.Translate" method="Translate"
returnvariable="LB_Titulocxp" xmlfile="Neteo-Ddocumentoconlis.xml"/><cfinvoke  key="LB_Documentocxp" default="Documento" component="sif.Componentes.Translate" method="Translate"
returnvariable="LB_Documentocxp" xmlfile="Neteo-Ddocumentoconlis.xml"/>
<cfinvoke  key="LB_Retencioncxp" default="Retencion" component="sif.Componentes.Translate" method="Translate"
returnvariable="LB_Retencioncxp" xmlfile="Neteo-Ddocumentoconlis.xml"/>
<cfinvoke  key="LB_Saldocxp" default="Saldo" component="sif.Componentes.Translate" method="Translate"
returnvariable="LB_Saldocxp" xmlfile="Neteo-Ddocumentoconlis.xml"/>
<cfinvoke  key="MSG_Registroscxp" default="*** No se encontr&oacute; ning&uacute;n documento ***" component="sif.Componentes.Translate" method="Translate"
returnvariable="MSG_Registroscxp" xmlfile="Neteo-Ddocumentoconlis.xml"/>


<cfif isdefined("url.Mcodigo") and len(trim(url.Mcodigo)) GT 0><cfset form.Mcodigo = url.Mcodigo></cfif>
<cfif isdefined("url.CPTcodigo") and len(trim(url.CPTcodigo)) GT 0><cfset form.CPTcodigo = url.CPTcodigo></cfif>
<cfif isdefined("url.SNcodigo") and len(trim(url.SNcodigo)) GT 0><cfset form.SNcodigo = url.SNcodigo></cfif>
<cfparam name="form.Mcodigo" type="numeric">
<cfparam name="form.CPTcodigo" type="string">
<cfparam name="form.SNcodigo" type="string">
<cfparam name="navegacion" type="string" default="">
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<cf_templatecss>
<title="#LB_Titulo#"></title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<script language="javascript" type="text/javascript" src="../../js/utilesMonto.js"></script>
<script language="javascript" type="text/javascript">
	<!--//
	function funcion(p1,p2,p3,r1,r2){
		window.opener.document.formcxp.HDdocumento.value = p1;
		window.opener.document.formcxp.Ddocumento.value = p1;
		window.opener.document.formcxp.idDocumento.value = p2;
		window.opener.document.formcxp.EDsaldo.value = fm(p3,2);
		window.opener.document.formcxp.Dmonto.value = fm(p3,2);
		window.opener.document.formcxp.Dmonto.focus();
		if (window.opener.sbRetencionCxP)
			window.opener.sbRetencionCxP(r1,r2,p3);
		window.close();
	}
	//-->
</script>
</head>
<body>
<cfquery name="rs" datasource="#session.dsn#">
	select rtrim(a.Ddocumento) as Ddocumento, rtrim(a.CPTcodigo) as CPTcodigo, a.IDdocumento, a.EDsaldo, b.CPTdescripcion, c.SNnombre,
			r.Rcodigo as Rcodigo, r.Rporcentaje
 	  from EDocumentosCP a
		inner join CPTransacciones b
			on b.CPTcodigo = a.CPTcodigo
			and b.Ecodigo = a.Ecodigo
		inner join SNegocios c
			on c.SNcodigo = a.SNcodigo
			and c.Ecodigo = a.Ecodigo
		left join Retenciones r
			 on r.Rcodigo = a.Rcodigo
			and r.Ecodigo = a.Ecodigo
	where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		and a.CPTcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#form.CPTcodigo#">
		and a.SNcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.SNcodigo#">
		and a.Mcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Mcodigo#">
		and a.EDsaldo > 0
		<cfif isdefined("url.Typ") AND #url.Typ# EQ "C">
			AND a.TimbreFiscal IS NOT NULL
		</cfif>
		<cfif isdefined("url.Typ") AND #url.Typ# EQ "C">
			and a.Ddocumento not in(
				select Ddocumento
				from DocCompensacionDCxP b inner join DocCompensacion c
			  	on b.idDocCompensacion = c.idDocCompensacion
				  and c.Aplicado = 0
				where b.Ddocumento = a.Ddocumento
				  and b.CPTcodigo = a.CPTcodigo
			)
		<cfelse>
			and a.Ddocumento not in(
				select Ddocumento
				from DocumentoNeteoDCxP b inner join DocumentoNeteo c
				  on b.idDocumentoNeteo = c.idDocumentoNeteo
				  and c.Aplicado = 0
				where b.Ddocumento = a.Ddocumento
				  and b.CPTcodigo = a.CPTcodigo
			)
		</cfif>
	order by b.CPTcodigo,c.SNcodigo
</cfquery>
<table width="100%"  border="0" cellspacing="0" cellpadding="0">
  <tr>
    <td style="text-transform:uppercase" align="center" bgcolor="#CCCCCC"><strong><cfoutput>#LB_Titulocxp#</cfoutput></strong></td>
  </tr>
</table>
<cfinvoke
	component="sif.Componentes.pListas"
	method="pListaQuery"
	returnvariable="pLista"
	query="#rs#"
	cortes="SNnombre,CPTdescripcion"
	desplegar="Ddocumento,Rcodigo,EDsaldo"
	etiquetas="#LB_Documentocxp#, #LB_Retencioncxp#, #LB_Saldocxp#"
	formatos="S,S,M"
	align="left,center,right"
	funcion="funcion"
	fparams="Ddocumento, idDocumento, EDsaldo, Rcodigo, Rporcentaje"
	navegacion="Mcodigo=#form.Mcodigo#&CPTcodigo=#form.CPTcodigo#&SNcodigo=#form.SNcodigo##navegacion#"
	maxrows="12"
	showemptylistmsg="true"
	emptylistmsg="#MSG_Registroscxp#"
/>
</body>
</html>