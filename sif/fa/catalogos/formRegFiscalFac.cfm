
<script src="/cfmx/sif/js/qForms/qforms.js"></script>
<script language="JavaScript" type="text/JavaScript">
	<!--//
	// specify the path where the "/qforms/" subfolder is located
	qFormAPI.setLibraryPath("/cfmx/sif/js/qForms/");
	// loads all default libraries
	qFormAPI.include("*");
	//-->
</script>


<cfif isdefined("Form.Cambio")>
	<cfset modo="CAMBIO">
<cfelse>
	<cfif not isdefined("Form.modo")>
		<cfset modo="ALTA">
	<cfelseif Form.modo EQ "CAMBIO">
		<cfset modo="CAMBIO">
	<cfelse>
		<cfset modo="ALTA">
	</cfif>
</cfif>

<cfif modo NEQ "ALTA">
	<cfquery name="rsRegFiscalFac" datasource="#Session.DSN#">
		select   id_RegFiscal,
                 codigo_RegFiscal,
                 nombre_RegFiscal,				
				 ClaveSAT,
                 ts_rversion
        from FARegFiscal
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		      and id_RegFiscal = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.id_RegFiscal#">
	</cfquery>

</cfif>

<script language="JavaScript1.2" src="../../js/utilesMonto.js"></script>

<cfoutput>

<form action="SQLRegFiscal.cfm" method="post" name="form1">
  <table width="45%" border="0" align="center" >
  <tr>
    <td align="right" nowrap>Código:&nbsp;</td>
    <td nowrap>
		<input name="codigo_RegFiscal" type="text"  value="<cfif isdefined("form.codigo_RegFiscal") and
		len(trim(form.codigo_RegFiscal ))>#trim(form.codigo_RegFiscal)#</cfif>">
    </td>	
  </tr>
  <tr>
    <td align="right" nowrap>Nombre Reg.Fiscal:&nbsp;</td>
    <td nowrap><input name="nombre_RegFiscal" type="text" value="<cfif isdefined("form.nombre_RegFiscal") and len(trim(form.nombre_RegFiscal))>#form.nombre_RegFiscal#</cfif>">
	<td align="right" nowrap></td>
	<td align="right" nowrap></td>
  </tr>
  <tr>
  	<td nowrap colspan="4">
		<cfif modo NEQ "ALTA">
			<cfset ts = "">
			<cfinvoke
				component="sif.Componentes.DButils"
				method="toTimeStamp"
				returnvariable="ts">
				<cfinvokeargument name="arTimeStamp" value="#rsRegFiscalFac.ts_rversion#"/>
			</cfinvoke>
		</cfif>
		<cfif modo NEQ "ALTA">
			<cfoutput>
				<input type="hidden" name="id_RegFiscal" value="#rsRegFiscalFac.id_RegFiscal#">
				<input type="hidden" name="ts_rversion" value="#ts#">
			</cfoutput>
		</cfif>
	</td>
  </tr>
	<tr>
		<td align="right">Clave SAT:&nbsp;</td>
		<td align="left">
			<cfset valuesArray = ArrayNew(1)>
			<cfif modo eq 'CAMBIO' and IsDefined('form.ID_REGFISCAL') and IsDefined('rsRegFiscalFac')>
				<cfquery name="rsCatalogo" datasource="#session.dsn#">
					select CSATcodigo,CSATdescripcion
					from CSATRegFiscal
					where CSATcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsRegFiscalFac.ClaveSAT#">
				</cfquery>
				<cfset ArrayAppend(valuesArray, '#trim(rsCatalogo.CSATcodigo)#')>
				<cfset ArrayAppend(valuesArray, '#trim(rsCatalogo.CSATdescripcion)#')>
			</cfif>
		  	<cf_conlis
				campos="CSATcodigo,CSATdescripcion"
				asignar="CSATcodigo,CSATdescripcion"
				size="8,40"
				desplegables="S,S"
				modificables="S,N"
				title="R&eacute;gimen Fiscal SAT"
				tabla="CSATRegFiscal a"
				columnas="CSATcodigo,CSATdescripcion"
				filtrar_por="CSATcodigo,CSATdescripcion"
				desplegar="CSATcodigo,CSATdescripcion"
				etiquetas="Clave,Descripcion"
				formatos="S,S"
				align="left,left"
				asignarFormatos="S,S"
				form="form1"
				showEmptyListMsg="true"
				EmptyListMsg=" --- No hay registros --- "
				valuesArray="#valuesArray#"
				alt="Clave,Descripcion"
				/>
				<!---
				traerInicial="True"
				traerFiltro=" 1=1 #filtroExtra#" --->

		</td>
	</tr>
  <tr>
	<td align="right" nowrap>&nbsp;</td>
	<td align="right" nowrap></td>
	<td align="right" nowrap></td>
	<td align="right" nowrap></td>
	</tr>
</table>
<table width="100%" border="0" cellspacing="0" cellpadding="0">
  <tr>
  	<td nowrap align="center">
<!--- 		Copiado del portlet de botones para poner funcion en el borrado --->
		<cf_templatecss>
		<cfoutput>
		<cfif modo EQ "ALTA">
			<input type="submit" name="Alta" value="#Translate('BotonAgregar','Agregar','/sif/Utiles/Generales.xml')#">
			<input type="reset" name="Limpiar" value="#Translate('BotonLimpiar','Limpiar','/sif/Utiles/Generales.xml')#">
		<cfelse>
			<input type="submit" name="Cambio" value="#Translate('BotonCambiar','Modificar','/sif/Utiles/Generales.xml')#">
			<input type="submit" name="Baja" value="#Translate('BotonBorrar','Eliminar','/sif/Utiles/Generales.xml')#">
			<input type="submit" name="Nuevo" value="#Translate('BotonNuevo','Nuevo','/sif/Utiles/Generales.xml')#" >
		</cfif>
		</cfoutput>
		<input name="txtEnterSI" type="text" size="1" maxlength="1" readonly="true" class="cajasinbordeb">
<!--- 		Copiado del portlet de botones para poner funcion en el borrado --->
	</td>
  </tr>
</table>
</form>
</cfoutput>

<script language="JavaScript1.2" type="text/javascript">
	qFormAPI.errorColor = "#FFFFCC";
	objForm = new qForm("form1");

	objForm.codigo_RegFiscal.required = true;
	objForm.nombre_RegFiscal.required = true;
</script>
