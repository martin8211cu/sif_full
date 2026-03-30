<!---QFORMS--->
<script language="JavaScript" type="text/javascript" src="/cfmx/sif/js/qForms/qforms.js"></script>
<script language="JavaScript" type="text/JavaScript">
	<!--//
		// specify the path where the "/qforms/" subfolder is located
		qFormAPI.setLibraryPath("/cfmx/sif/js/qForms/");
		// loads all default libraries
		qFormAPI.include("*");
	//-->
</script>
<!---Pintado del Form--->
<form name="form1" action="solicitantes-Paso3-sql.cfm" method="post" onSubmit="javascript:if (window._finalizarform) _finalizarform();" style="margin:0;">
	<cfoutput>
		<table width="100%" border="0" cellspacing="0" cellpadding="0">
			<tr>
				<td width="1%" nowrap><strong>Especializaci&oacute;n&nbsp;:&nbsp;</strong></td>
				<td>
					<table border="0" cellspacing="0" cellpadding="0">
						<tr>
							<td><input type="text" name="CMEdescripcion" id="CMEdescripcion" tabindex="1" readonly value="" size="50" maxlength="80"></td>
							<td><a href="##" tabindex="-1"><img src="/cfmx/sif/imagenes/Description.gif" alt="Lista de Especializaci&oacute;n" name="CMEimagen" width="18" height="14" border="0" align="absmiddle" onClick='javascript: doConlisEspecializacion();'></a><input type="hidden" name="CMElinea" value=""></td>
						</tr>
					</table>
				</td>
			</tr>
		</table>
		<input type="hidden" name="CMSid" value="#Session.Compras.Solicitantes.CMSid#">
		<input type="hidden" name="Baja" value="">
		<br>
		<cf_botones values="<< Anterior, Agregar, Finalizar >>" names="Anterior,Alta,Finalizar" tabindex = "2">
	</cfoutput>
</form>
<br>
<table width="100%"  border="0" cellspacing="0" cellpadding="0">
  <tr>
		<cfset img   = "<img border='0' src='/cfmx/sif/imagenes/Borrar01_S.gif'>">
			<td width="33%" valign="top">
				<cf_web_portlet_start titulo="Artículo">
					<cfquery name="rslistaArticulo" datasource="#session.dsn#">
						select cf.CFid, cf.CFdescripcion, cmt.CMTScodigo, cmt.CMTSdescripcion, aa.CMElinea, b.Ccodigoclas as codigo, b.Cdescripcion as descripcion, '#img#' as borrar, 'A' as tipo
						from CMESolicitantes aa
							inner join CMEspecializacionTSCF a
								on aa.CMElinea = a.CMElinea
							inner join Clasificaciones b
								on a.Ecodigo = b.Ecodigo
								and a.Ccodigo = b.Ccodigo
							inner join CFuncional cf
								on cf.CFid = a.CFid
							inner join CMTiposSolicitud cmt
								on cmt.Ecodigo = a.Ecodigo
								and cmt.CMTScodigo = a.CMTScodigo
						where aa.CMSid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Compras.Solicitantes.CMSid#">
							order by cf.CFid, cmt.CMTScodigo
					</cfquery>
					<cfinvoke 
							component="sif.Componentes.pListas"
							method="pListaQuery"
							returnvariable="pListaRet"> 
						<cfinvokeargument name="query" value="#rslistaArticulo#"/> 
						<cfinvokeargument name="desplegar" value="descripcion, borrar"/> 
						<cfinvokeargument name="etiquetas" value=""/> 
						<cfinvokeargument name="cortes" value="CFdescripcion,CMTSdescripcion"/> 
						<cfinvokeargument name="formatos" value="S,V"/> 
						<cfinvokeargument name="align" value="left,center"/> 
						<cfinvokeargument name="ajustar" value="N"/> 
						<cfinvokeargument name="checkboxes" value="N"/> 
						<cfinvokeargument name="irA" value="compraConfig.cfm"/> 
						<cfinvokeargument name="keys" value="CMElinea"/> 
						<cfinvokeargument name="formname" value="formlista"/> 
						<cfinvokeargument name="funcion" value="funcEliminar"/> 
						<cfinvokeargument name="fparams" value="CMElinea,tipo"/> 
						<cfinvokeargument name="PageIndex" value="1"/>
					</cfinvoke> 
				<cf_web_portlet_end>
			</td>
			<td width="1%">&nbsp;</td>
			<td width="33%" valign="top">
				<cf_web_portlet_start titulo="Servicio">
					<cfquery name="rslistaServicio" datasource="#session.dsn#">
						select cf.CFid, cf.CFdescripcion, cmt.CMTScodigo, cmt.CMTSdescripcion, aa.CMElinea, b.CCcodigo as codigo, b.CCdescripcion as descripcion, '#img#' as borrar, 'S' as tipo
						from CMESolicitantes aa
							inner join CMEspecializacionTSCF a
								on aa.CMElinea = a.CMElinea
							inner join CConceptos b
								on a.Ecodigo = b.Ecodigo
								and a.CCid = b.CCid
							inner join CFuncional cf
								on cf.CFid = a.CFid
							inner join CMTiposSolicitud cmt
								on cmt.Ecodigo = a.Ecodigo
								and cmt.CMTScodigo = a.CMTScodigo
						where aa.CMSid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Compras.Solicitantes.CMSid#">
							order by cf.CFid, cmt.CMTScodigo
					</cfquery>
					<cfinvoke 
							component="sif.Componentes.pListas"
							method="pListaQuery"
							returnvariable="pListaRet"> 
						<cfinvokeargument name="query" value="#rslistaServicio#"/> 
						<cfinvokeargument name="desplegar" value="descripcion, borrar"/> 
						<cfinvokeargument name="etiquetas" value=""/> 
						<cfinvokeargument name="cortes" value="CFdescripcion,CMTSdescripcion"/> 
						<cfinvokeargument name="formatos" value="S,V"/> 
						<cfinvokeargument name="align" value="left,center"/> 
						<cfinvokeargument name="ajustar" value="N"/> 
						<cfinvokeargument name="checkboxes" value="N"/> 
						<cfinvokeargument name="irA" value="compraConfig.cfm"/> 
						<cfinvokeargument name="keys" value="CMElinea"/> 
						<cfinvokeargument name="formname" value="formlista"/> 
						<cfinvokeargument name="funcion" value="funcEliminar"/> 
						<cfinvokeargument name="fparams" value="CMElinea,tipo"/> 
						<cfinvokeargument name="PageIndex" value="2"/>
					</cfinvoke> 
				<cf_web_portlet_end>
			</td>
			<td width="1%">&nbsp;</td>
			<td width="33%" valign="top">
				<cf_web_portlet_start titulo="Activo Fijo">
                	<cfinclude template="../../Utiles/sifConcat.cfm">
					<cfquery name="rsCategoriaClase" datasource="#session.dsn#">
						select cf.CFid, cf.CFdescripcion, cmt.CMTScodigo, cmt.CMTSdescripcion, aa.CMElinea,
										b.ACdescripcion #_Cat# '/' #_Cat# c.ACdescripcion as descripcion, '#img#' as borrar, 'F' as tipo
						from CMESolicitantes aa
							inner join CMEspecializacionTSCF a
								on aa.CMElinea = a.CMElinea
							inner join ACategoria b
								on a.Ecodigo = b.Ecodigo
								and a.ACcodigo = b.ACcodigo
							inner join AClasificacion c
								on a.Ecodigo = c.Ecodigo
								and a.ACcodigo = c.ACcodigo
								and a.ACid = c.ACid
							inner join CFuncional cf
								on cf.CFid = a.CFid
							inner join CMTiposSolicitud cmt
								on cmt.Ecodigo = a.Ecodigo
								and cmt.CMTScodigo = a.CMTScodigo
						where aa.CMSid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Compras.Solicitantes.CMSid#">
							order by cf.CFid, cmt.CMTScodigo
					</cfquery>
					<cfinvoke 
							component="sif.Componentes.pListas"
							method="pListaQuery"
							returnvariable="pListaRet"> 
						<cfinvokeargument name="query" value="#rsCategoriaClase#"/> 
						<cfinvokeargument name="desplegar" value="descripcion, borrar"/> 
						<cfinvokeargument name="etiquetas" value=""/> 
						<cfinvokeargument name="cortes" value="CFdescripcion,CMTSdescripcion"/> 
						<cfinvokeargument name="formatos" value="S,V"/> 
						<cfinvokeargument name="align" value="left,center"/> 
						<cfinvokeargument name="ajustar" value="N"/> 
						<cfinvokeargument name="checkboxes" value="N"/> 
						<cfinvokeargument name="irA" value="compraConfig.cfm"/> 
						<cfinvokeargument name="keys" value="CMElinea"/> 
						<cfinvokeargument name="formname" value="formlista"/> 
						<cfinvokeargument name="funcion" value="funcEliminar"/> 
						<cfinvokeargument name="fparams" value="CMElinea,tipo"/> 
						<cfinvokeargument name="PageIndex" value="0"/>
					</cfinvoke> 
				<cf_web_portlet_end>
			</td>
			<td width="1%">&nbsp;</td>
  </tr>
</table>
<!---Validaciones con QFORMS, Otras Validaciones y Funciones en General--->
<script language="JavaScript" type="text/javascript">	
	<!--//	
	qFormAPI.errorColor = "#FFFFCC";
	objForm = new qForm("form1");
	
	objForm.CMElinea.description="Especialización";
	
	function habilitarValidacion(){
		objForm.CMElinea.required = true;
	}
	
	function deshabilitarValidacion(){
		objForm.CMElinea.required = false;
	}
	
	function _finalizarform() {
	}
	
	function _iniciarform(){
		habilitarValidacion();
	}
	
	function funcEliminar(CMElinea,tipo){
		var tipodesc = '';
		if (tipo=='A') tipodesc = "<cfoutput>#JSStringFormat('Artículo')#</cfoutput>";
		if (tipo=='S') tipodesc = "Servicio";
		if (tipo=='F') tipodesc = "Activo Fijo";
		if (!confirm('¿Desea eliminar el ' + tipodesc + '?')) return false;
		document.form1.CMElinea.value=CMElinea;
		document.form1.Baja.value=1;
		document.form1.submit();
		return false;
	}
	
	var popUpWinE = 0;
	function popUpWindowE(URLStr, left, top, width, height){
	if(popUpWinE){
		if(!popUpWinE.closed) popUpWinE.close();
	}
	popUpWinE = open(URLStr, 'popUpWin2', 'toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=yes,resizable=no,copyhistory=yes,width='+width+',height='+height+',left='+left+', top='+top+',screenX='+left+',screenY='+top+'');
	}
	
	function doConlisEspecializacion() {
		var params ="";
		params = "?CMSid=<cfoutput>#Session.Compras.Solicitantes.CMSid#</cfoutput>&form=form1&id=CMElinea&name=CMEdescripcion";
		popUpWindowE("/cfmx/sif/cm/catalogos/conlisEspecializacion.cfm"+params,250,200,650,400);
	}
	
	_iniciarform();
	
	//-->
</script>