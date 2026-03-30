<cfif isdefined("Url.PageNum_lista") and not isdefined("Form.PageNum_lista")>
	<cfset Form.PageNum_lista = Url.PageNum_lista>
</cfif>

<cfquery name="rsMensajes" datasource="#Session.DSN#">
	select a.Bestado, count(1) as cant
	from Buzon a
	where a.Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">
	and a.Ulocalizacion = <cfqueryparam cfsqltype="cf_sql_char" value="#Session.Ulocalizacion#">
	group by a.Bestado
</cfquery>
<cfquery name="rsCantMensajes" dbtype="query">
	select sum(cant) as cant from rsMensajes
</cfquery>
<cfquery name="rsMensajesNuevos" dbtype="query">
	select sum(cant) as cant from rsMensajes
	where Bestado = 0
</cfquery>

<cfset MaxLineas = 15>

<cfsavecontent variable="listaMsg">
	<cfinvoke 
	 component="sif.Componentes.pBUzon"
	 method="pListaBuzon"
	 returnvariable="TotalRegistros">
		<cfinvokeargument name="tabla" value="Buzon a"/>
		<cfinvokeargument name="columnas" value="0 as verLista, convert(varchar, a.Bcodigo) as Bcodigo, a.Borigen, substring(a.Btitulo,1,50) + (case when datalength(a.Btitulo) > 50 then ' ...' else '' end) as Btitulo, a.Bmensaje, convert(varchar, a.Bfecha, 103) + ' ' + substring(convert(varchar, a.Bfecha, 100), charindex(':', convert(varchar, a.Bfecha, 100))-2, 8) as Fecha, case Bestado when 0 then '/cfmx/sif/Imagenes/email/newmail.gif' when 1 then '/cfmx/sif/Imagenes/email/blank.gif' when 2 then '/cfmx/sif/Imagenes/email/blank.gif' when 3 then '/cfmx/sif/Imagenes/email/blank.gif' else '/cfmx/sif/Imagenes/email/blank.gif' end as Bestado"/>
		<cfinvokeargument name="desplegar" value="Borigen, Btitulo, Fecha, Bestado"/>
		<cfinvokeargument name="etiquetas" value="Origen, Asunto, Fecha, &nbsp;"/>
		<cfinvokeargument name="formatos" value="S, S, S, IMG"/>
		<cfinvokeargument name="filtro" value="a.Usucodigo = #Session.Usucodigo# and a.Ulocalizacion = '#Session.Ulocalizacion#' order by a.Bfecha desc, a.Borigen, a.Btitulo"/>
		<cfinvokeargument name="align" value="left, left, left, center"/>
		<cfinvokeargument name="ajustar" value="N"/>
		<cfinvokeargument name="irA" value="index.cfm"/>
		<cfinvokeargument name="checkboxes" value="S"/>
		<cfinvokeargument name="keys" value="Bcodigo"/>
		<cfinvokeargument name="checkAll" value="true"/>
		<cfinvokeargument name="showEmptyListMsg" value="true"/>
		<cfinvokeargument name="MaxRows" value="#MaxLineas#"/>
		<cfinvokeargument name="EmptyListMsg" value="--- No tiene ningún mensaje en el buzón ---"/>
		<cfinvokeargument name="Botones" value="Borrar"/>					
	</cfinvoke>
</cfsavecontent>


<cfif isdefined('TotalRegistros')>
	<cfset MaxPages = Ceiling(TotalRegistros / MaxLineas)>
<cfelse>
	<cfset MaxPages = 0>
</cfif>

<cfif not isdefined('tabChoice')>
	<cfset tabChoice = 3>
</cfif>

<style type="text/css">
.MensajesNuevos {
	padding: 3px;
	font-weight: bold;
	color: white;
	background-color: #6699CC;
}
</style>

<script language="JavaScript" type="text/javascript">
	function funcBorrar() {
		var anychecked = false;
		if (document.lista.chk) {
			if (document.lista.chk.value) {
				if (!document.lista.chk.disabled) anychecked = document.lista.chk.checked;
			} else {
				for (var counter = 0; counter < document.lista.chk.length; counter++) {
					if (!document.lista.chk[counter].disabled && document.lista.chk[counter].checked) {
						anychecked = true;
						break;
					}
				}
			}
			if (!anychecked) {
				alert("Debe seleccionar un mensaje");
				return false;
			} else {
				if (confirm("¿Está seguro de que desear eliminar los mensajes seleccionados?")) {
					document.lista.action = 'take-action.cfm';
					document.lista.submit();
				}else{
					return false;
				}
			}
		} else {
			alert("No tiene mensajes en el buzón");
			return false;
		}
		
		return true;
	}
</script>

<table width="98%" border="0" cellspacing="0" cellpadding="0" align="center">
  <tr>
    <td colspan="3">&nbsp;</td>
  </tr>
  <tr>
    <td class="MensajesNuevos">
		<b>Usted tiene <cfoutput><cfif rsMensajesNuevos.cant NEQ "">#rsMensajesNuevos.cant#<cfelse>0</cfif></cfoutput> mensaje(s) nuevo(s) de un total de <cfoutput><cfif rsCantMensajes.cant NEQ "">#rsCantMensajes.cant#<cfelse>0</cfif></cfoutput> mensaje(s)</b>
	</td>
    <td class="MensajesNuevos" align="right" style="padding-right: 10px; color: black;" nowrap>
		<cfoutput>
			<cfif MaxPages GT 1>
				<b>P&aacute;gina <cfif isdefined("Form.PageNum_lista")>#Form.PageNum_lista#<cfelse>1</cfif>/#MaxPages#</b>
			<cfelse>
				&nbsp;
			</cfif>
		</cfoutput>
	</td>
    <td width="5%" class="MensajesNuevos" align="right" nowrap>
		<cfoutput>
			<cfif MaxPages GT 1>
				<b>Ir a P&aacute;gina </b>
				<select name="callPage" onChange="javascript: location.href = '/cfmx/sif/framework/buzon/index.cfm?PageNum_lista='+this.value;">
				<cfloop from="1" to="#MaxPages#" index="i">
					<option value="#i#" <cfif isdefined("Form.PageNum_lista") and i eq Form.PageNum_lista>selected</cfif>>#i#</option>
				</cfloop>
				</select>
			<cfelse>
				&nbsp;
			</cfif>
		</cfoutput>
	</td>
  </tr>
  <tr>
    <td colspan="3">&nbsp;</td>
  </tr>
  <tr>
    <td colspan="3">
		<cfoutput>#listaMsg#</cfoutput>
	</td>
  </tr>
</table>
