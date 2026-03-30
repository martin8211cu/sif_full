<!--- Encabezado--->
<cfif ef_modo neq 'ALTA'>
	<cfquery name="rsForm" datasource="#session.DSN#">
		select a.EFEid, a.EFEcodigo, a.EFEdescripcion, a.ts_rversion
		from EFormatosExpediente a 
			inner join TipoExpediente b
				on a.TEid=b.TEid
		where a.TEid  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.TEid#">
		  and a.EFEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.EFEid#">
		  and b.CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.CEcodigo#">
	</cfquery>
</cfif>

<script language="JavaScript1.2" type="text/javascript">

	function validacion(valor){
		objForm1.EFEcodigo.required      = valor;
		objForm1.EFEdescripcion.required = valor;
	}
	
</script>

<style type="text/css">
	.cuadro{
		border: 1px solid #999999;
	}
</style>

<form name="form1" method="post"  action="SQLEFormatosExpediente.cfm" >
	<table width="100%" cellpadding="0" cellspacing="0">

		<!--- Encabezado--->

		<tr>
			<td>&nbsp;</td>
			<td align="center">
				<cfoutput>
				<table border="0" width="60%" cellpadding="2" cellspacing="2" align="center">
					<tr>
						<td align="right"><cf_translate key="LB_Codigo" XmlFile="/rh/generales.xml">C&oacute;digo</cf_translate>:&nbsp;</td>
						<td>
							<input type="text" name="EFEcodigo" size="12" maxlength="10" tabindex="1"
								value="<cfif ef_modo neq 'ALTA'>#trim(rsForm.EFEcodigo)#</cfif>" onfocus="javascript:this.select();">
						</td>
					</tr>						

					<tr>
						<td align="right" nowrap><cf_translate key="LB_Descripcion" XmlFile="/rh/generales.xml">Descripci&oacute;n</cf_translate>:&nbsp;</td>
						<td>
							<input type="text" name="EFEdescripcion" size="60" maxlength="80" tabindex="1"
								value="<cfif ef_modo neq 'ALTA'>#trim(rsForm.EFEdescripcion)#</cfif>" onfocus="javascript:this.select();">
						</td>
					</tr>

					<cfset ts = "">	
					<cfif ef_modo neq "ALTA">
						<cfinvoke component="sif.Componentes.DButils" method="toTimeStamp" returnvariable="ts">
							<cfinvokeargument name="arTimeStamp" value="#rsForm.ts_rversion#"/>
						</cfinvoke>
					</cfif>
					<tr>
						<input type="hidden" name="TEid" value="#form.TEid#" >
						<input type="hidden" name="EFEid" value="<cfif ef_modo neq 'ALTA'>#form.EFEid#</cfif>" >
						<input type="hidden" name="ts_rversion" value="<cfif ef_modo NEQ 'ALTA'><cfoutput>#ts#</cfoutput></cfif>">
					</tr>
				</table>
				</cfoutput>
			</td>
		</tr>
		<!--- Encabezado --->			

		<!-- ============================================================================================================ -->
		<!--  											Botones													          -->
		<!-- ============================================================================================================ -->		
		<tr><td><input type="hidden" name="botonSel" value=""></td></tr>
		<cfif ef_modo EQ 'ALTA'>
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

					<cfoutput>			
						<input type="submit" name="AltaEF" tabindex="1" value="#BTN_Agregar#" onClick="javascript: setBtn(this);" >
						<input type="reset"  name="LimpiarEF" tabindex="1"  value="#BTN_Limpiar#" >
					</cfoutput>				
				</td>	
			</tr>
		<cfelse>
			<tr>
				<td align="center" valign="baseline" colspan="6">
					<cfinvoke component="sif.Componentes.Translate"
					method="Translate"
					Key="BTN_Modificar"
					Default="Modificar"
					XmlFile="/rh/generales.xml"
					returnvariable="BTN_Modificar"/>
					<cfinvoke component="sif.Componentes.Translate"
					method="Translate"
					Key="BTN_Eliminar"
					Default="Eliminar"
					XmlFile="/rh/generales.xml"
					returnvariable="BTN_Eliminar"/>
					<cfinvoke component="sif.Componentes.Translate"
					method="Translate"
					Key="MSG_DeseaEliminarElFormato"
					Default="Desea eliminar el Formato? "
					returnvariable="MSG_DeseaEliminarElFormato"/>
					<cfinvoke component="sif.Componentes.Translate"
					method="Translate"
					Key="BTN_Nuevo"
					Default="Nuevo"
					XmlFile="/rh/generales.xml"
					returnvariable="BTN_Nuevo"/>
					<cfoutput>
					<input type="submit" name="CambioEF" tabindex="1" value="#BTN_Modificar#" onClick="javascript: setBtn(this);">
					<input type="submit" name="BajaEF" tabindex="1"  value="#BTN_Eliminar#" onClick="javascript: if (confirm('#MSG_DeseaEliminarElFormato#')){ setBtn(this); validacion(false); return true; } else{ return false; } " >
					<input type="submit" name="NuevoEF" tabindex="1"   value="#BTN_Nuevo#" onClick="javascript: setBtn(this); validacion(false);" >
					</cfoutput>
				</td>	
			</tr>
		</cfif>
	</table>
</form>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_Descripcion"
	Default="Descripción"
	XmlFile="/rh/generales.xml"
	returnvariable="MSG_Descripcion"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_Codigo"
	Default="Código"
	XmlFile="/rh/generales.xml"
	returnvariable="MSG_Codigo"/>
<script language="JavaScript1.2" type="text/javascript">
	//instancias de qforms
	objForm1 = new qForm("form1");
<cfoutput>
	objForm1.EFEcodigo.required    = true;
	objForm1.EFEcodigo.description = '#MSG_Codigo#';

	objForm1.EFEdescripcion.required   = true;
	objForm1.EFEdescripcion.description = '#MSG_Descripcion#';
</cfoutput>	
</script>