<cfset btnNameCalcular="insertarCF">
<cfset btnValueCalcular= "Insertar Todos">
<cfset btnExcluirAbajo="Cambio,Baja,Nuevo,Alta,Limpiar">
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
<form name="form1" action="solicitantes-Paso2-sql.cfm" method="post" onSubmit="javascript:if (window._finalizarform) _finalizarform();" style="margin:0;">
	<cfoutput>
		<table width="100%" border="0" cellspacing="0" cellpadding="0">
			<tr>
				<td width="1%" nowrap><strong>Centro Funcional&nbsp;:&nbsp;</strong></td>
				<td><cf_rhcfuncional id="CFpk" tabindex="1"></td>
<!---				<td width="37%"><cfif MODOCAMBIO>#rsCFXSolicitud.CFcodigo# - #rsCFXSolicitud.CFdescripcion#<input type="hidden" name="CFpk" value="#rsCFXSolicitud.CFid#"><cfelse><cf_rhcfuncional id="CFpk" tabindex="1"></cfif></td>
--->				<td width="52%"><cf_botones includevalues="#btnValueCalcular#" align="left" include="#btnNameCalcular#" exclude="#btnExcluirAbajo#"></td>
			</tr>
		</table>
		<input type="hidden" name="CMSid" value="#Session.Compras.Solicitantes.CMSid#">
		<input type="hidden" name="Baja" value="">
		<br>
		<cf_botones values="<< Anterior, Agregar, Agregar y Continuar >>" names="Anterior, Alta, AltaEsp" tabindex="2">
	</cfoutput>
</form>
<br>
<cfset img   = "<img border='0' src='/cfmx/sif/imagenes/Borrar01_S.gif'>">
<cfquery name="rsListaCFXSolicitud" datasource="#session.DSN#">
	select a.CFid, a.CFcodigo, a.CFdescripcion, '#img#' as borrar
	from CFuncional a
		inner join CMSolicitantesCF b
			on b.CFid = a.CFid
			and b.CMSid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Compras.Solicitantes.CMSid#">
</cfquery>
<cfinvoke 
		component="sif.Componentes.pListas"
		method="pListaQuery"
		returnvariable="pListaRet"> 
	<cfinvokeargument name="query" value="#rsListaCFXSolicitud#"/> 
	<cfinvokeargument name="desplegar" value="CFcodigo, CFdescripcion, borrar"/> 
	<cfinvokeargument name="etiquetas" value="C&oacute;digo,Descripci&oacute;n, "/> 
	<cfinvokeargument name="formatos" value="S,S,S"/> 
	<cfinvokeargument name="align" value="left,left,right"/> 
	<cfinvokeargument name="ajustar" value="N"/> 
	<cfinvokeargument name="checkboxes" value="N"/> 
	<cfinvokeargument name="irA" value="solicitantes.cfm"/> 
	<cfinvokeargument name="keys" value="CFid"/> 
	<cfinvokeargument name="funcion" value="funcEliminar"/> 
	<cfinvokeargument name="fparams" value="CFid"/> 
</cfinvoke> 
<!---Validaciones con QFORMS, Otras Validaciones y Funciones en General--->
<script language="JavaScript" type="text/javascript">	
	<!--//	
	qFormAPI.errorColor = "#FFFFCC";
	objForm = new qForm("form1");
	
	objForm.CFpk.description="Centro Funcional";
	
	function habilitarValidacion(){
		objForm.CFpk.required = true;
	}
	
	function deshabilitarValidacion(){
		objForm.CFpk.required = false;
	}
	
	function _finalizarform() {
	}
	
	function _iniciarform(){
		habilitarValidacion();
		objForm.CFcodigo.obj.focus();
	}
	
	function funcEliminar(cf){
		if (!confirm('¿Desea eliminar el centro funcional de esta relación?')) return false;
		document.form1.CFpk.value=cf;
		document.form1.Baja.value=1;
		document.form1.submit();
		return false;
	}
	
	//para q no valide cuando inserto todos los centros
	function funcinsertarCF(){
		if (confirm('Esta seguro que desea agregar TODOS los centro funcionales?')){
			deshabilitarValidacion();
			return true;
		}
		else
			return false;
	}
	_iniciarform();
	
	//-->
</script>