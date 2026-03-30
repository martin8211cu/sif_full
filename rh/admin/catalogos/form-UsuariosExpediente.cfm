<!--- Consultas --->
<cfif modo NEQ "ALTA">
	<!--- Form --->
	<cfquery name="rsForm" datasource="#session.DSN#">
		select TEid, Usucodigo, ts_rversion
		from UsuariosTipoExpediente
		where TEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.TEid#">
		  and Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Usucodigo#">
	</cfquery>
	
	<!--- Usuario --->
	<cfquery name="rsUsuario" datasource="asp">
		select 
		{fn concat(b.Pnombre,{fn concat(' ',{fn concat(b.Papellido1,{fn concat(' ', b.Papellido2)})})})}  as Nombre 
		from Usuario a, DatosPersonales b
		where a.Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsForm.Usucodigo#">
		  and a.Uestado = 1
		  and a.Utemporal = 0
		  and a.datos_personales = b.datos_personales
	</cfquery>

</cfif>

<script language="javascript" type="text/javascript" src="/cfmx/sif/js/qForms/qforms.js"></script>
<script language="JavaScript" type="text/javascript">
	var popUpWin=0; 
	
	function popUpWindow(URLStr, left, top, width, height)
	{
	  if(popUpWin) {
		if(!popUpWin.closed) popUpWin.close();
	  }
	  popUpWin = open(URLStr, 'popUpWin', 'toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbar=no,resizable=no,copyhistory=yes,width='+width+',height='+height+',left='+left+', top='+top+',screenX='+left+',screenY='+top+'');
	}
	
	function doConlisUsuarios() {
		popUpWindow("ConlisUsuarios.cfm?form=form4&id=Usucodigo&nombre=Nombre",300,200,600,400);
	}

	function us_validacion() {
		objForm4.Usucodigo.required = false;
	}
</script>

<form name="form4" method="post" action="SQLUsuariosExpediente.cfm" onSubmit="return validar()">
<cfoutput>
	<table width="100%" border="0" cellspacing="1" cellpadding="1">	
	
  <tr>
    <td width="12%" nowrap><div align="right"><cf_translate key="LB_Usuario" XmlFile="/rh/generales.xml">Usuario</cf_translate>:</div></td>
    <td width="31%">
		<input name="Nombre" id="Nombre" type="text" value="<cfif modo NEQ 'ALTA'>#rsUsuario.Nombre#</cfif>" tabindex="-1" readonly size="50" maxlength="180">
	</td>
	<td width="57%">
		<cfif modo eq 'ALTA'>
			<a href="##" tabindex="-1"><img src="/cfmx/rh/imagenes/Description.gif" alt="Lista de Usuarios" name="imagen" width="18" height="14" border="0" align="absmiddle" <cfif modo EQ 'ALTA'> onClick="javascript:doConlisUsuarios();" </cfif>></a>
		<cfelse>&nbsp;
		</cfif>			
		<input type="hidden" name="Usucodigo" value="<cfif modo NEQ 'ALTA'>#Form.Usucodigo#</cfif>">
	</td>
  </tr>

		<input name="TEid" value="#Form.TEid#" type="hidden">

		<!--- ts_rversion --->
		<cfset ts = "">	
		<cfif modo neq "ALTA">
			<cfinvoke 
				component="sif.Componentes.DButils"
				method="toTimeStamp"
				returnvariable="ts">
				<cfinvokeargument name="arTimeStamp" value="#rsForm.ts_rversion#"/>
			</cfinvoke>
		</cfif>
		<input type="hidden" name="ts_rversion" value="<cfif modo NEQ 'ALTA'><cfoutput>#ts#</cfoutput></cfif>">
	
		<!--- Portlet de botones --->
		<!-- ============================================================================================================ -->
		<!--  											Botones													          -->
		<!-- ============================================================================================================ -->		
		<tr><td colspan="3"><input type="hidden" name="botonSel" value=""></td></tr>
		<cfif modo EQ 'ALTA'>
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

                	<input type="submit" name="AltaUS" value="#BTN_Agregar#" tabindex="1" onclick=" javascript: document.form4.botonSel.value = 'AltaUS'">					
              		<input type="reset"  name="LimpiarUS"  value="#BTN_Limpiar#" tabindex="1"  onclick=" javascript: document.form4.botonSel.value = 'LimpiarUS'">			  
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
						Key="MGS_DeseaEliminarElUsuario"
						Default="Desea eliminar el Usuario? "
						returnvariable="MGS_DeseaEliminarElUsuario"/>
						<cfinvoke component="sif.Componentes.Translate"
						method="Translate"
						Key="BTN_Nuevo"
						Default="Nuevo"
						XmlFile="/rh/generales.xml"
						returnvariable="BTN_Nuevo"/>
				
					<input type="submit" name="BajaUS"  value="#BTN_Eliminar#" tabindex="1" onClick="javascript: if (confirm('#MGS_DeseaEliminarElUsuario#')){ us_validacion(); return true; } else{ return false; } " >
					<input type="submit" name="NuevoUS"   value="#BTN_Nuevo#" tabindex="1" onClick="javascript: us_validacion(false);" >
				</td>	
			</tr>
		</cfif>
	</table>

</cfoutput>
</form>

<script language="javascript" type="text/javascript">
	function validar(){
		var err='';
		
		if (document.form4.botonSel.value == 'AltaUS'){
			if (document.getElementById('Nombre').value == ''){
				err='Debe seleccionar un usuario';
			}
		}
		if (err != ''){
			alert(err);
			return false; 
		}
		else{
			return true; 
		}
		
	}
</script>
<cfinvoke component="sif.Componentes.Translate"
method="Translate"
Key="MSG_Usuario" 
Default="Usuario"
XmlFile="/rh/generales.xml"
returnvariable="MSG_Usuario"/>

<script language="JavaScript1.2" type="text/javascript">
	objForm4 = new qForm("form4");
<cfoutput>
	objForm4.Usucodigo.required = true;
	objForm4.Usucodigo.description="#MSG_Usuario#";
</cfoutput>
</script>