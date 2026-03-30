<cf_web_portlet_start titulo="Portada del Expediente">

<!--- Registros que se tiene en la portada del Expediente --->
<cfquery name="rsPortada" datasource="#session.DSN#">
	select DEEPid, DEEPfecha, DEEPpatologia, DEEPtratamiento
	from DExpedienteEmpleadoP
	where DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid#">
</cfquery>

<cfinclude template="../expediente/consultas/consultas-frame-header.cfm">
<cfset Lvar_IncluyeFechaNac = true>
<cfset Lvar_IncluyeNumPatronal = true>


<form name="formPortadaExp" method="post" action="frame-expediente-portada-sql.cfm" >
	<cfoutput>
		<table width="100%" border="0" cellspacing="0" cellpadding="0">
		  <tr><td align="center" class="tituloAlterno"><cf_translate key="LB_TituloEncab">Registro de Datos</cf_translate></td></tr>
		  <tr><td>&nbsp;</td></tr>		  		

		<tr valign="top"><td><cfinclude template="/rh/portlets/pNavegacion.cfm"></td></tr>
	  	<tr valign="top"><td>&nbsp;</td></tr>

		<tr valign="top"> 
			<td align="center">
				<table width="98%"  border="0" cellspacing="0" cellpadding="0" align="center">
			  		<tr><td><cfinclude template="../expediente/consultas/frame-infoEmpleado.cfm"></td></tr>
				</table>
			</td>
	  	</tr>
		<tr><td> <hr></td>
		</tr>
		  <tr>
		    <td align="center">
				<table width="80%" border="0" cellpadding="3" cellspacing="0">
				  <tr>
					<td nowrap><strong><cf_translate key="LB_Fecha" XmlFile="/rh/generales.xml">Fecha</cf_translate></strong></td>
					<td nowrap><strong><cf_translate key="LB_Patologia" XmlFile="/rh/generales.xml">Patolog&iacute;a</cf_translate></strong></td>
					<td nowrap><strong><cf_translate key="LB_Descripcion" XmlFile="/rh/generales.xml">Descripci&oacute;n</cf_translate></strong></td>
				  </tr>
				  <tr>
  					<td>
							<cf_sifcalendario form="formPortadaExp" name="ECEfecha" value="#LSDateFormat(Now(),'DD/MM/YYYY')#" tabindex="1">
					</td>

					<td>
						<input name="patologia" type="text" id="patologia" size="80" maxlength="80" tabindex="1">
					</td>
					<td><input name="tratamiento" type="text" id="tratamiento" tabindex="1" size="80" maxlength="80" ></td>
				  </tr>
				  <tr>
					<td colspan="4">&nbsp;
						<input type="hidden" name="DEid" value="#Form.DEid#">
					</td>
				  </tr>	
				</table>
			</td>
	      </tr>
		  
		  
		<!-- ============================================================================================================ -->
		<!--  											Botones													          -->
		<!-- ============================================================================================================ -->		

		<!-- Caso 1: Alta de Encabezados -->
			  <tr>
				<td align="center" valign="baseline">
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
					
					<cfinvoke component="sif.Componentes.Translate"
								method="Translate"
								Key="BTN_Regresar"
								Default="Regresar"
								XmlFile="/rh/generales.xml"
								returnvariable="BTN_Regresar"/>
					
					<input type="submit" name="btnAgregar" class="btnGuardar" tabindex="1" value="#BTN_Agregar#" >
					<input type="reset"  name="btnLimpiar"  class="btnNormal" tabindex="1" value="#BTN_Limpiar#" >	
					<input type="button" name="btnRegresar" class="btnAnterior" value="#BTN_Regresar#" onClick="javascript: location.href='Expediente.cfm?DEid=#form.DEid#'">
					<input type="hidden" name="btnBorrar" value="0">
				</td>
			  </tr>		  
			  <td align="center" valign="baseline" colspan="6">&nbsp;</td>
			</tr>
	  	</table>
	</cfoutput>		
</form>


<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Patologia"
	Default="Patolog&iacute;a"
	XmlFile="/rh/generales.xml"
	returnvariable="LB_Patologia"/>

	<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Tratamiento"
	Default="Tratamiento"
	XmlFile="/rh/generales.xml"
	returnvariable="LB_Tratamiento"/>
	
	<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Fecha"
	Default="Fecha"
	XmlFile="/rh/generales.xml"
	returnvariable="LB_Fecha"/>

	<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_YaExiste"
	Default="Ya Existe un registro con el dato: "
	XmlFile="/rh/generales.xml"
	returnvariable="MSG_YaExiste"/>

	<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_EstaSeguroDeQueDeseaEliminar"
	Default="¿Está seguro que desea eliminar el registro?"
	XmlFile="/rh/generales.xml"
	returnvariable="MSG_EstaSeguroDeQueDeseaEliminar"/>

<script language="JavaScript" type="text/javascript">

	function del_linea(c) {
		if (confirm('<cfoutput>#MSG_EstaSeguroDeQueDeseaEliminar#</cfoutput>')) {
			document.formPortadaExp.btnBorrar.value = c;
			document.formPortadaExp.submit();
		}
	}
</script>	


<cfquery name="rsPortada" datasource="#session.dsn#">
	select DEEPid, DEEPfecha,
	DEEPpatologia,
	DEEPtratamiento	
	from DExpedienteEmpleadoP
	where DEid = #Form.DEid#
	order by DEEPfecha
</cfquery>

	<table border="0" width="100%" align="center" style="border-bottom:thin; border-bottom-color:#666666">
		<tr class="tituloListas" align="center">
			<td><b><cf_translate key="LB_Etiqueta">Fecha</cf_translate></b></td>
			<td><b><cf_translate key="LB_Patologia">Patología</cf_translate></b></td>
			<td><b><cf_translate key="LB_Tratamiento">Tratamiento</cf_translate></b></td>
			<td><b><cf_translate key="LB_Borrar">Borrar</cf_translate></b></td>
		</tr>
	
	<cfoutput query="rsPortada">
	
	<tr 
		<cfif rsPortada.CurrentRow MOD 2>style="backgroundColor:white"
		<cfelse>style="background-color:CCCCCC"
		</cfif> onMouseOver="style.backgroundColor='##E4E8F3';" onMouseOut="style.backgroundColor='<cfif CurrentRow MOD 2>##FFFFFF<cfelse>##CCCCCC</cfif>';" 
	>		
		<td width="10%" id="#rsPortada.CurrentRow#1">#LSDateFormat(rsPortada.DEEPfecha,'DD/MM/YYYY')#</td>
		<td width="40%" id="#rsPortada.CurrentRow#2">#rsPortada.DEEPpatologia#</td>
		<td width="45%" id="#rsPortada.CurrentRow#3">#rsPortada.DEEPtratamiento#</td>
		<td width="5%" id="#rsPortada.CurrentRow#4" align="center"><a href=javascript:del_linea('#rsPortada.DEEPid#');><img src=/cfmx/rh/imagenes/delete.small.png border=0></a></td>
		
	</tr>
	</cfoutput>	
	</table>

	
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_Descripcion"
	Default="Descripci&oacute;n"
	XmlFile="/rh/generales.xml"
	returnvariable="MSG_Descripcion"/>
	
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_Fecha"
	Default="Fecha"
	XmlFile="/rh/generales.xml"
	returnvariable="MSG_Fecha"/>
	
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_Valor"
	Default="Valor"
	XmlFile="/rh/generales.xml"
	returnvariable="MSG_Valor"/>
	

<script language="JavaScript1.2">document.formPortadaExp.patologia.focus();</script>


<cf_web_portlet_end>