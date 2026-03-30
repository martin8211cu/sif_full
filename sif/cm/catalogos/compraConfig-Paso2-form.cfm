<cfset btnNameCalcular="insertarCF">
<cfset btnValueCalcular= "Insertar Todos">
<cfset btnExcluirAbajo="Cambio,Baja,Nuevo,Alta,Limpiar">
<!---Define el Modo--->
<cfset MODOCAMBIO = isdefined("Session.Compras.Configuracion.CFpk") and len(trim(Session.Compras.Configuracion.CFpk))>
<!---Consultas--->
<cfquery name="rsListaCFXSolicitud" datasource="#session.DSN#">
	select a.CMTScodigo, a.CFid as CFpk, a.Mcodigo, a.CMTSmontomax, b.CFcodigo, b.CFdescripcion, c.Mnombre
	from CMTSolicitudCF a 
		inner join CFuncional b 
			on b.Ecodigo = a.Ecodigo
			and b.CFid = a.CFid
		inner join Monedas c 
			on c.Ecodigo = a.Ecodigo
			and c.Mcodigo = a.Mcodigo
	where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		and a.CMTScodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#Session.Compras.Configuracion.CMTScodigo#">
	order by b.CFcodigo, b.CFdescripcion
</cfquery>
<cfif MODOCAMBIO>
	<cfquery name="rsCFXSolicitud" datasource="#session.DSN#">
		select a.CFid, a.Mcodigo, a.CMTSmontomax, b.CFcodigo, b.CFdescripcion, c.Mnombre, a.ts_rversion
		from CMTSolicitudCF a 
			inner join CFuncional b 
				on b.Ecodigo = a.Ecodigo
				and b.CFid = a.CFid
			inner join Monedas c 
				on c.Ecodigo = a.Ecodigo
				and c.Mcodigo = a.Mcodigo
		where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			and a.CMTScodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#Session.Compras.Configuracion.CMTScodigo#">
			and a.CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Compras.Configuracion.CFpk#">
		order by a.Mcodigo, b.CFcodigo
	</cfquery>
	<cfinvoke component="sif/Componentes/DButils" method="toTimeStamp" artimestamp="#rsCFXSolicitud.ts_rversion#" returnvariable="ts"/>
</cfif>
<!---Utilidades de Montos y Números--->
<script language="JavaScript" type="text/javascript" src="/cfmx/sif/js/utilesMonto.js"></script>
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
<form name="form1" action="compraConfig-Paso2-sql.cfm" method="post" onSubmit="javascript:if (window._finalizarform) _finalizarform();" style="margin:0;">
	<cfoutput>
		<table width="100%" border="0" cellspacing="0" cellpadding="0">
			<tr>
				<td width="11%" nowrap><strong>Centro Funcional&nbsp;:&nbsp;</strong></td>
				<td width="37%"><cfif MODOCAMBIO>#rsCFXSolicitud.CFcodigo# - #rsCFXSolicitud.CFdescripcion#<input type="hidden" name="CFpk" value="#rsCFXSolicitud.CFid#"><cfelse><cf_rhcfuncional id="CFpk" tabindex="1"></cfif></td>
				<td width="52%"><cf_botones includevalues="#btnValueCalcular#" align="left" include="#btnNameCalcular#" exclude="#btnExcluirAbajo#"></td>
			</tr>
			<tr>
				<td width="11%" nowrap><strong>Moneda&nbsp;:&nbsp;</strong></td>
				<td colspan="2"><cfif MODOCAMBIO><cf_sifmonedas mcodigo="moneda" query="#rsCFXSolicitud#" tabindex="1"><cfelse><cf_sifmonedas mcodigo="moneda" tabindex="1"></cfif></td>
			</tr>
			<tr>
				<td width="11%" nowrap><strong>Monto M&aacute;ximo&nbsp;:&nbsp;</strong></td>
				<td colspan="2"><input type="text" name="CMTSmonto" size="20" value="<cfif MODOCAMBIO>#LSCurrencyFormat(rsCFXSolicitud.CMTSmontomax,'none')#<cfelse>0.00</cfif>" style="text-align:right;" onBlur="javascript:fm(this,2);" onFocus="javascript:this.value=qf(this); this.select();"  onKeyUp="javascript:if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}" tabindex="1"></td>
			</tr>
		</table>
		<input type="hidden" name="CMTScodigo" value="#Session.Compras.Configuracion.CMTScodigo#">
		<br>
		<cfif MODOCAMBIO>
			<input type="hidden" name="ts_rversion" value="#ts#">
			<cf_botones values="<< Anterior,Eliminar,Nuevo,Guardar, Guardar y Continuar >>" names="Anterior, Baja, Nuevo, Cambio, CambioEsp" tabindex="2">
		<cfelse>
			<cf_botones values="<< Anterior, Agregar, Agregar y Continuar >>" names="Anterior, Alta, AltaEsp" tabindex="2">
		</cfif>
	</cfoutput>
</form>
<br>
<cfinvoke 
		component="sif.Componentes.pListas"
		method="pListaQuery"
		returnvariable="pListaRet"> 
	<cfinvokeargument name="query" value="#rsListaCFXSolicitud#"/> 
	<cfinvokeargument name="desplegar" value="CFcodigo, CFdescripcion, Mnombre, CMTSmontomax"/> 
	<cfinvokeargument name="etiquetas" value="C&oacute;digo,Descripci&oacute;n, Moneda, Monto M&aacute;ximo"/> 
	<cfinvokeargument name="formatos" value="S,S,S,M"/> 
	<cfinvokeargument name="align" value="left,left,left,right"/> 
	<cfinvokeargument name="ajustar" value="N"/> 
	<cfinvokeargument name="checkboxes" value="N"/> 
	<cfinvokeargument name="irA" value="compraConfig.cfm"/> 
	<cfinvokeargument name="keys" value="CMTScodigo,CFpk"/> 
</cfinvoke> 
<!---Validaciones con QFORMS, Otras Validaciones y Funciones en General--->
<script language="JavaScript" type="text/javascript">	
	<!--//	
	qFormAPI.errorColor = "#FFFFCC";
	objForm = new qForm("form1");
	
	objForm.CFpk.description="Centro Funcional";
	objForm.moneda.description="Moneda";
	objForm.CMTSmonto.description="Monto Maximo";
	

	function habilitarValidacion(){
		objForm.CFpk.required = true;
		objForm.moneda.required = true;
		objForm.CMTSmonto.required = true;
	}

	function deshabilitarValidacion(){
		objForm.CFpk.required = false;
		objForm.moneda.required = false;
		objForm.CMTSmonto.required = false;
	}

	
	function _finalizarform() {
		document.form1.CMTSmonto.value = qf(document.form1.CMTSmonto.value);
	}
	
	function _iniciarform(){
		habilitarValidacion();
		<cfif MODOCAMBIO>
			objForm.moneda.obj.focus();
		<cfelse>
			objForm.CFcodigo.obj.focus();
		</cfif>
	}
	
	//para q no valide cuando inserto todos los centros
	function funcinsertarCF(){
		deshabilitarValidacion();
		return true;
	}
	
	_iniciarform();
	
	//-->
</script>