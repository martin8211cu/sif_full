<cfinclude template="../../Utiles/sifConcat.cfm">

<cfquery name="rsUsuarios" datasource="#Session.dsn#">
	select a.FPSUid, a.Usucodigo, a.FPSUestimar, a.CFid,
		b.Usulogin, c.Pnombre #_Cat# ' ' #_Cat# c.Papellido1 #_Cat# ' ' #_Cat# c.Papellido2 as Usunombre,
		'<input name="imageFieldC" type="image" src="/cfmx/sif/imagenes/Borrar01_S.gif" width="16" height="16" border="0" onclick="javascript:eliminarConcepto();">' as borrar
	  from FPSeguridadUsuario a
		inner join Usuario b
			inner join DatosPersonales c 
			on 	b.datos_personales = c.datos_personales
		on b.Usucodigo = a.Usucodigo
	 where a.Ecodigo = #Session.Ecodigo#
	 	and a.CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CFid#">
</cfquery>
<table width="100%"  border="0" cellspacing="0" cellpadding="0">
	<tr>
    	<td class="subtitulo">Lista de Usuarios Autorizados</td>
  	</tr>
</table>
<table width="100%"  border="0" cellspacing="0" cellpadding="0">
  	<tr>
		<td class="titulolistas">&nbsp;</td>
		<td class="titulolistas">Usuario&nbsp;</td>
		<td class="titulolistas">&nbsp;</td>
  	</tr>
	<form action="SeguridadUsuario-SQL.cfm" method="post" name="formPermisosUsuarios">
		<input type="hidden" id="CFid" name="CFid" value="<cfoutput>#form.CFid#</cfoutput>">
		<input type="hidden" id="CurrentPage" name="CurrentPage" value="<cfoutput>#CurrentPage#</cfoutput>">
		<cfif isdefined('SEG.ADM') and SEG.ADM eq 'true'>
			<input type="hidden" id="ADM" name="ADM" value="true">
		</cfif>
		<tr>
			<td>&nbsp;</td>
			<td><cf_sifusuario name="Usucodigo" form="formPermisosUsuarios">&nbsp;</td>
			<td align="center">
				<input name="ALTA" type="submit" value="&nbsp;+&nbsp;" title="Agregar el Usuario únicamente en este Centro Funcional">&nbsp;</td>
		</tr>
 	 </form>

  <cfif rsUsuarios.recordcount>
		<cfinvoke component="sif.Componentes.pListas" method="pListaQuery" 
			query="#rsUsuarios#" 
			conexion="#session.dsn#"
			desplegar="Usunombre,borrar"
			etiquetas="Usuario,"
			formatos="S,US"
			mostrar_filtro="false"
			align="left,left"
			checkboxes="N"
			formName="listaUsuarios"
			ira="#CurrentPage#"
			keys="FPSUid">
		</cfinvoke>
  <cfelse>
	  <tr><td align="center" colspan="4"><strong>-- No se encontr&oacute; ning&uacute;n resultado --</strong></td></tr>
  </cfif>
</table>
</div>
<cf_qforms form="formPermisosUsuarios" objForm="objForm2"/>
<script language="javascript" type="text/javascript">
<!--//
	objForm2.Usucodigo.description = "Usuario";
	objForm2.required("Usucodigo",true);
//-->
	
	<cfif isdefined('form.CFid') and len(trim(form.CFid)) and not CFcorrecto>
		document.formPermisosUsuarios.ALTA.disabled = "disabled";
	</cfif>
	
	function eliminarConcepto(){
		if (confirm('¿Desea Eliminar el Registro?')){
			document.listaUsuarios.action = "SeguridadUsuario-SQL.cfm?BAJA=true&CurrentPage=<cfoutput>#CurrentPage#</cfoutput>";
		}
	}

</script>