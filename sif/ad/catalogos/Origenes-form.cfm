<cfset modo = "ALTA">
<cfif isdefined("form.Oorigen") and len(trim(form.Oorigen))>
	<cfset modo = "CAMBIO">
</cfif>

<cfif modo neq 'ALTA'>
	<cfquery name="data" datasource="#session.DSN#">
		select Oorigen, Odescripcion, Otipo, ts_rversion
		from Origenes
		where Oorigen = <cfqueryparam cfsqltype="cf_sql_char" value="#trim(form.Oorigen)#">
		and Otipo = 'E'
	</cfquery>
</cfif>

<script language="JavaScript" type="text/javascript" src="/cfmx/sif/js/qForms/qforms.js"></script>
<script language="JavaScript" type="text/JavaScript">
	<!--//
		// specify the path where the "/qforms/" subfolder is located
		qFormAPI.setLibraryPath("/cfmx/sif/js/qForms/");
		// loads all default libraries
		qFormAPI.include("*");
	//-->
</script>

<table width="100%"  border="0" cellspacing="0" cellpadding="0">
  <tr> 
	<td valign="top" width="50%"> 
	  <cfinvoke 
		 component="sif.Componentes.pListas"
		 method="pListaRH"
		 returnvariable="pListaRet">
		<cfinvokeargument name="tabla" value="Origenes"/>
		<cfinvokeargument name="columnas" value="Oorigen, Odescripcion, Otipo"/>
		<cfinvokeargument name="desplegar" value="Oorigen, Odescripcion"/>
		<cfinvokeargument name="etiquetas" value="C&oacute;digo, Descripci&oacute;n del M&oacute;dulo Or&iacute;gen Externo"/>
		<cfinvokeargument name="formatos" value="v,v"/>
		<cfinvokeargument name="filtro" value="Otipo = 'E' order by Oorigen"/>
		<cfinvokeargument name="align" value="left, left"/>
		<cfinvokeargument name="ajustar" value="N,N"/>
		<cfinvokeargument name="checkboxes" value="N"/>
		<cfinvokeargument name="keys" value="Oorigen"/>
		<cfinvokeargument name="irA" value="Origenes.cfm"/>
         <cfinvokeargument name="mostrar_filtro" 	value="true"/>
		<cfinvokeargument name="filtrar_automatico" value="true"/> 
		<cfinvokeargument name="maxRows" value="20"/>
	  </cfinvoke>
	</td>
	<td valign="top">

		<cfoutput>
		<form name="form1" action="Origenes-SQL.cfm" method="post" onSubmit="form1.Oorigen.value=form1.Oorigen.value.toUpperCase();">
			<table width="100%" cellpadding="2" cellspacing="0">
				<tr>
					<td align="right"><strong>C&oacute;digo:&nbsp;</strong></td>
					<td><input type="text" name="Oorigen" size="7" maxlength="4"  value="<cfif modo neq 'ALTA'>#trim(data.Oorigen)#</cfif>"></td>
				</tr>
				<tr>
					<td align="right"><strong>Descripci&oacute;n:&nbsp;</strong></td>
					<td><input type="text" name="Odescripcion" size="60" maxlength="50" value="<cfif modo neq 'ALTA'>#trim(data.Odescripcion)#</cfif>" onfocus="this.select();"></td>
				</tr>
				
				<!--- Botones --->
				<tr><td colspan="2">&nbsp;</td></tr>
				<tr><td colspan="2" align="center">
				<cfif modo eq 'ALTA'>
					<input type="submit" name="Alta" value="Agregar" onClick="javascript: habilitarValidacion();">
					<input type="reset" name="Limpiar" value="Limpiar">
				<cfelse>
					<input type="submit" name="Cambio" value="Modificar" onClick="habilitarValidacion();">
					<input type="submit" name="Baja" value="Eliminar" onClick="if ( confirm('Desea eliminar el registro?') ){inhabilitarValidacion(); return true;} return false;">
					<input type="submit" name="Nuevo" value="Nuevo" onClick="inhabilitarValidacion();">
				</cfif>
				</td></tr>
				<tr><td colspan="2">&nbsp;</td></tr>
		
			</table>
			<cfif isdefined("Form.PageNum") and Len(Trim(Form.PageNum))>
				<input type="hidden" name="PageNum" value="#Form.PageNum#">
			</cfif>
			<cfif modo neq 'ALTA'>
				<cfinvoke component="sif.Componentes.DButils" method="toTimeStamp"returnvariable="ts">
					<cfinvokeargument name="arTimeStamp" value="#data.ts_rversion#"/>
				</cfinvoke>
				<input type="hidden" name="ts_rversion" value="#ts#">
				<input type="hidden" name="_Oorigen" value="#trim(data.Oorigen)#">
			</cfif>
		</form>
		</cfoutput>
	
	</td>
  </tr>
</table>


<script language="JavaScript" type="text/javascript">	

	function habilitarValidacion() {
		return true;
	}

	function inhabilitarValidacion() {
		return true;
	}

	qFormAPI.errorColor = "#FFFFCC";
	objForm = new qForm("form1");

	objForm.Oorigen.required = true;
	objForm.Oorigen.description = "Código";				
	objForm.Odescripcion.required = true;
	objForm.Odescripcion.description = "Descripción";	
</script>
