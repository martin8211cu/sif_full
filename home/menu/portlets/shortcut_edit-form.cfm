<cfif isdefined("url.id_shortcut") and not isdefined("form.id_shortcut") >
  <cfset form.id_shortcut = url.id_shortcut >
</cfif>
<cfparam name="form.id_shortcut" default="">

<cf_web_portlet titulo="Organizar favoritos">
<table width="785" cellpadding="2" cellspacing="0">
  <tr>
    <!--- LISTA --->
    <td width="364" align="center" valign="top">
	<cfquery name="rsLista" datasource="asp">
		select sh.id_shortcut, sh.descripcion_shortcut, s.SSdescripcion, m.SMdescripcion, p.SPdescripcion
		from SShortcut sh
			left join SSistemas s
				on s.SScodigo = sh.SScodigo
			left join SModulos m
				on  m.SScodigo = sh.SScodigo
				and m.SMcodigo = sh.SMcodigo
			left join SProcesos p
				on  p.SScodigo = sh.SScodigo
				and p.SMcodigo = sh.SMcodigo
				and p.SPcodigo = sh.SPcodigo
		where sh.Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
		order by sh.descripcion_shortcut
	</cfquery>
      <cfif rsLista.recordcount gt 0>
        <cfinvoke component="sif.Componentes.pListas" 
						  method="pListaQuery"
						  returnvariable="pListaRet"
					query="#rsLista#"
					desplegar="descripcion_shortcut"
					etiquetas="Acceso favorito"
					formatos="V"
					align="left"
					ajustar="N"
					funcion="editar_shortcut"
					fparams="id_shortcut,descripcion_shortcut,SSdescripcion,SMdescripcion,SPdescripcion"
					checkboxes="N"
					keys="id_shortcut"
					maxrows="0"></cfinvoke>
        <cfelse>
        <table width="80%" cellpadding="0" cellspacing="0">
          <tr>
            <td align="center">No tiene favoritos asociados. Si desea agregar uno, para cada p&aacute;gina que desee agregar vaya al men&uacute; de favoritos y accese la opci&oacute;n agregar a favoritos.</td>
          </tr>
        </table>
      </cfif>
    </td>
    <!--- MANTENIMIENTO --->
    <td width="407" valign="top">
	  <cfquery name="dataShortcut" datasource="asp">
			select id_shortcut, descripcion_shortcut, url_shortcut, SScodigo, SMcodigo, SPcodigo
			from SShortcut
			where Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
			  and id_shortcut = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_shortcut#" null="#Len(form.id_shortcut) Is 0#">
		</cfquery>
      <cfquery name="dataSistema" datasource="asp">
			select SSdescripcion 
			from SSistemas 
			where SScodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(dataShortcut.SScodigo)#">
		</cfquery>
      <cfquery name="dataModulo" datasource="asp">
			select SMdescripcion 
			from SModulos
			where SScodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(dataShortcut.SScodigo)#">
			and SMcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(dataShortcut.SMcodigo)#">
		</cfquery>
      <cfquery name="dataProceso" datasource="asp">
			select SPdescripcion 
			from SProcesos
			where SScodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(dataShortcut.SScodigo)#">
			and SMcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(dataShortcut.SMcodigo)#">
		</cfquery>
      <cfoutput>
        <form name="form1" method="post" action="shortcut_edit-sql.cfm" style=" margin:0;" onClick="javascript:return validar(this);">
            <input type="hidden" name="id_shortcut" value="#HTMLEditFormat( form.id_shortcut )#">
          <table border="0" cellpadding="0" cellspacing="0">
            <tr>
              <td colspan="2" class="subTitulo">Propiedades de acceso favorito </td>
            </tr>
            <tr>
              <td colspan="2">&nbsp;</td>
            </tr>
            <tr>
              <td colspan="2">Puede modificar la descripción que aparecerá en el menú de favoritos </td>
              </tr>
            <tr>
              <td width="88"><label>Descripci&oacute;n:&nbsp;</label></td>
              <td width="319">
			  <input type="text" name="descripcion_shortcut" size="50" maxlength="255" style="width:317px" onFocus="this.select();"
			  	 value="<cfif Len(form.id_shortcut)>#dataShortcut.descripcion_shortcut#</cfif>"></td>
            </tr>
            <tr>
              <td valign="top"><label>Acceso a:&nbsp;</label></td>
              <td><textarea cols="50" rows="6" style="width:317px" readonly="readonly" id="adonde_me_lleva" name="adonde_me_lleva"><cfif Len(form.id_shortcut)>#
							Trim(dataSistema.SSdescripcion)# &gt; #Trim(dataModulo.SMdescripcion)# &gt; #Trim(dataProceso.SPdescripcion)
							#</cfif></textarea></td>
            </tr>
            <tr>
              <td>&nbsp;</td>
              <td>&nbsp;</td>
            </tr>
            <tr>
              <td>&nbsp;</td>
              <td colspan="1" align="center"><input type="submit" name="Modificar" value="Modificar" class="btnGuardar">
                <input type="submit" name="Eliminar" value="Eliminar" class="btnEliminar" onClick="javascript:if(confirm('Desea eliminar el item de favoritos?')){return true;}else{return false;}">              </td>
            </tr>
          </table>
        </form>
      </cfoutput> </td>
  </tr>
</table>
<script language="javascript1.2" type="text/javascript">
	function validar(f) {
		if( f.id_shortcut.value == ''){
			alert('No ha seleccionado ningún favorito para trabajar.  Haga clic sobre un elemento de la lista para continuar');
		}
		if( f.descripcion_shortcut.value == '' ){
			alert('El campo Descripción es requerido.');
			return false;
		}
		return true;
	}
	function editar_shortcut(id_shortcut,descripcion_shortcut,SSdescripcion,SMdescripcion,SPdescripcion)
	{
		var f = document.forms.form1;
		f.id_shortcut.value          = id_shortcut;
		f.descripcion_shortcut.value = descripcion_shortcut;
		f.descripcion_shortcut.value = descripcion_shortcut;
		f.adonde_me_lleva.value      = SSdescripcion + ' > ' + SMdescripcion + ' > ' + SPdescripcion;
		f.descripcion_shortcut.focus();
	}
</script>

</cf_web_portlet>