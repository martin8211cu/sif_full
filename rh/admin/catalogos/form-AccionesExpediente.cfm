<!--- Consultas --->
<cfif ac_modo NEQ "ALTA">
	<!--- Form --->
	<cfquery name="rsForm" datasource="#session.DSN#">
		select a.RHTid, RHTcodigo, RHTdesc, a.ts_rversion
		from AccionesTipoExpediente a
				inner join RHTipoAccion b
					on a.RHTid=b.RHTid	
		where a.TEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.TEid#">
		  and a.EFEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.EFEid#">
		  and a.RHTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHTid#">
	</cfquery>
</cfif>

<script language="JavaScript1.2" type="text/javascript">
	function ac_validacion() {
		objForm3.RHTid.required = false;
	}
</script>

<form name="form3" method="post" action="SQLAccionesExpediente.cfm" onSubmit="if (this.botonSel.value != 'BajaAC' && this.botonSel.value != 'NuevoAC'){ document.form3.RHTcodigo.disabled = false; document.form3.RHTdesc.disabled = false; return true; }" >
<cfoutput>
	<table width="100%" border="0" cellspacing="1" cellpadding="1">	
	
	  <tr>
		<td valign="middle"><div align="right"><cf_translate key="LB_Accion" XmlFile="/rh/generales.xml">Acci&oacute;n</cf_translate>:</div></td>
		<td>
			<cfif ac_modo NEQ 'ALTA'>
				<cf_rhtipoaccion query="#rsForm#" form="form3" tabindex="1">
			<cfelse>
				<cf_rhtipoaccion form="form3" tabindex="1">
			</cfif>
		</td>
	  </tr>
		<input name="TEid" value="#Form.TEid#" type="hidden">
		<input name="EFEid" value="#Form.EFEid#" type="hidden">

		<!--- ts_rversion --->
		<cfset ts = "">	
		<cfif ac_modo neq "ALTA">
			<cfinvoke 
				component="sif.Componentes.DButils"
				method="toTimeStamp"
				returnvariable="ts">
				<cfinvokeargument name="arTimeStamp" value="#rsForm.ts_rversion#"/>
			</cfinvoke>
		</cfif>
		<input type="hidden" name="ts_rversion" value="<cfif ac_modo NEQ 'ALTA'><cfoutput>#ts#</cfoutput></cfif>">
	
		<!--- Portlet de botones --->
		<!-- ============================================================================================================ -->
		<!--  											Botones													          -->
		<!-- ============================================================================================================ -->		
		<tr><td><input type="hidden" name="botonSel" value=""></td></tr>
		<cfif ac_modo EQ 'ALTA'>
			<tr>
				<td align="center" valign="baseline" colspan="6">
					<cfinvoke component="sif.Componentes.Translate"
					method="Translate"
					Key="BTN_Agregar"
					Default="Agregar"
					XmlFile="/rh/generales.xml"
					returnvariable="BTN_Agregar"/>
				
					<cfinvoke component="sif.Componentes.Translate"
					method="Translate"
					Key="BTN_Limpiar"
					Default="Limpiar"
					XmlFile="/rh/generales.xml"
					returnvariable="BTN_Limpiar"/>
					<input type="submit" name="AltaAC" tabindex="1" value="#BTN_Agregar#" onClick="javascript: setBtn(this);" >
					<input type="reset"  name="LimpiarAC" tabindex="1"  value="#BTN_Limpiar#" >
				</td>	
			</tr>
		<cfelse>
			<tr>
				<td align="center" valign="baseline" colspan="6">
					<cfinvoke component="sif.Componentes.Translate"
					method="Translate"
					Key="BTN_Eliminar"
					Default="Eliminar"
					XmlFile="/rh/generales.xml"
					returnvariable="BTN_Eliminar"/>
					<cfinvoke component="sif.Componentes.Translate"
					method="Translate"
					Key="MSG_DeseaEliminarLaAccion"
					Default="Desea eliminar la Acción?"
					returnvariable="MSG_DeseaEliminarLaAccion"/>
					<cfinvoke component="sif.Componentes.Translate"
					method="Translate"
					Key="BTN_Nuevo"
					Default="Nuevo"
					XmlFile="/rh/generales.xml"
					returnvariable="BTN_Nuevo"/>

					<input type="submit" name="BajaAC"  value="#BTN_Eliminar#" tabindex="1" onClick="javascript: if (confirm('#MSG_DeseaEliminarLaAccion#')){ setBtn(this); ac_validacion(); return true; } else{ return false; } " >
					<input type="submit" name="NuevoAC"   value="#BTN_Nuevo#" tabindex="1" onClick="javascript: setBtn(this); validacion(false);" >
				</td>	
			</tr>
		</cfif>
	</table>

</cfoutput>
</form>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_Accion"
	Default="Acción"
	XmlFile="/rh/generales.xml"
	returnvariable="MSG_Accion"/>

<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_Formato"
	Default="Formato"
	XmlFile="/rh/generales.xml"
	returnvariable="MSG_Formato"/>	
<script language="JavaScript1.2" type="text/javascript">
	objForm3 = new qForm("form3");
<cfoutput>
	objForm3.RHTid.required = true;
	objForm3.RHTid.description="#MSG_Accion#";
	objForm3.EFEid.required = true;
	objForm3.EFEid.description="#MSG_Formato#";
</cfoutput>
	<cfif ac_modo neq 'ALTA'>
		document.form3.RHTcodigo.disabled = true;
		document.form3.RHTdesc.disabled = true;
	</cfif>

</script>
