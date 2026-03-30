<cf_templateheader title="Reporte">
	<cf_web_portlet_start titulo="Lista de Traslados Generados">
	<br>
	<cfset navegacion = "">
	<cfquery name="rsLista" datasource="#session.dsn#">
		select
		QPTid,
		Usucodigo,
		Ecodigo,
		OcodigoOri,
		OcodigoDest,
		QPTtrasDocumento,
		QPTtrasDescripcion,
		QPTtrasEstado,
		BMFecha,
		ts_rversion,
		UsucodigoDestino,
		QPTFechaAceptacion, 'QPReimprimeDoc.cfm' as irA
			from QPassTraslado
		where Ecodigo = #session.Ecodigo# 
		<cfif isdefined('form.Filtro_doc')and len(trim(form.Filtro_doc)) >
			and upper(QPTtrasDocumento) like upper('%#form.Filtro_doc#%')
		</cfif>	
	</cfquery>	

		<form action="QPReimprimeDoc.cfm" name="form1" method="post">
			<table width="100%" cellpadding="2" cellspacing="0" border="0">
				<tr>
					<td class="titulolistas" colspan="2"><strong>Documento</strong></td>
				</tr>
				<tr>
					<td class="titulolistas"><input type="text" name="Filtro_doc"  tabindex="1" value="<cfif isdefined('form.Filtro_doc')><cfoutput>#form.Filtro_doc#</cfoutput></cfif>"></td>
					<td class="titulolistas"><input name="btnFiltrar" type="submit" id="btnFiltrar" value="Filtrar" tabindex="1" onclick="funcFiltrar();" /></td>
				</tr>
		</form>
			<table width="100%" align="center">
				<tr>
					<td align="right"></td>
				</tr>
				<cfinvoke
					component="sif.Componentes.pListas"
					method="pListaQuery"
					returnvariable="rsLista"
					query="#rsLista#"
					desplegar="QPTtrasDocumento, QPTtrasDescripcion, BMFecha"
					etiquetas="Documento, Descripci&oacute;n, Fecha"
					formatos="S,S,D"
					align="left,left,right"
					ajustar="S"
					irA="Comprobante_Envio.cfm"
					keys="QPTid"
					maxrows="5"
					pageindex="3"
					navegacion="#navegacion#" 				 
					showEmptyListMsg= "true"
					form_method="post"
					formname= "form3"
					usaAJAX = "no"
				/>
			</table>
           </tr>
            <tr> 
                <td valign="top"> </td>
            </tr>
	<cf_web_portlet_end>
<cf_templatefooter>
<script language="JavaScript" type="text/javascript">
	function funcFiltrar(){
			document.form1.action='QPReimprimeDoc.cfm';
			document.form1.submit;
	}
</script>
