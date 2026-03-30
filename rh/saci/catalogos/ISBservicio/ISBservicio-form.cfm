<!----Guardar--->
<cfif isdefined("Form.Guardar")>
	<cfinclude template="ISBservicio-apply.cfm">
</cfif>

<cfquery name="rsDatos" datasource="#session.DSN#">
	select	a.TScodigo,a.TSnombre, a.TSdescripcion
			,b.PQinterfaz as ci,b.SVcantidad as cc,b.Habilitado as ch
			<cfif isdefined("form.PQinterfaz")and len(trim(form.PQinterfaz)) and form.PQinterfaz EQ 1>
				,'Interfaz' as etiqueta
			<cfelse>
				,'Cantidad' as etiqueta
			</cfif>
	from 	ISBservicioTipo a
			left outer join ISBservicio b
				on b.TScodigo=a.TScodigo 
				and b.PQcodigo = <cfqueryparam value="#form.PQcodigo#" cfsqltype="cf_sql_char">
	where	a.Ecodigo= <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			and a.Habilitado=1
</cfquery>

<cfoutput>
<form name="lista2" method="post" action="ISBservicio.cfm" style="margin:0">
	<!----id de la lista principal que se envia por el form para no perder el valor--->
	<input type="hidden" name="PQcodigo" value="<cfif isdefined("Form.PQcodigo")>#Form.PQcodigo#</cfif>">
	<!----pagina de la lista principal que se envia por el form para no perder el valor--->
	<input type="hidden" name="pagina" value="#form.pagina#">
	<!----Filtros de la lista principal que se envia por el form para no perder el valor--->
	<input type="hidden" name="Filtro_PQnombre" value="#form.Filtro_PQnombre#">
	<input type="hidden" name="Filtro_PQdescripcion" value="#form.Filtro_PQdescripcion#">
	<!---Otras variables usadas anterioimente.--->
	<input name="PQnombre" type="hidden" id="PQnombre" value="<cfif isdefined("Form.PQnombre")>#Form.PQnombre#</cfif>">
	<input name="Cual_Grupo" type="hidden" id="Cual_Grupo" value="">
	<table width="100%" border="0"  cellpadding="2" cellspacing="0">
		<tr align="center"><td class="subTitulo" colspan="4">
			<strong>Paquete:&nbsp;#Form.PQnombre#</strong><br>
		</td></tr>
		
		<tr>
			<td class="subTitulo" align="center">Habilitar</td>
			<td class="subTitulo" align="left">Nombre</td>
			<td class="subTitulo" align="left">Descripci&oacute;n</td>
			<td class="subTitulo" align="left" width="25%">#rsDatos.etiqueta#</td>
		</tr>
		<cfif rsDatos.recordCount>
			<cfloop query="rsDatos">
				<tr><td align="center"><input name="Chk" type="checkbox" value="#rsDatos.TScodigo#" <cfif rsDatos.ch EQ 1> checked</cfif> tabindex="1"/></td>
				<td align="left">#rsDatos.TSnombre#</td>
				<td align="left">#rsDatos.TSdescripcion#</td>
				<cfif isdefined("form.PQinterfaz")and len(trim(form.PQinterfaz)) and form.PQinterfaz EQ 1>
				<td align="left"><input title="Interfaz" name="I_#TScodigo#" type="text" style="width:150" value="#rsDatos.ci#"/></td>										   <!---campos de PQinterfaz--->
				<cfelse>
				<td align="left"><input title="Cantidad" name="C_#TScodigo#" type="text" style="width:50" value="#rsDatos.cc#"onchange="javascript: validaNumerico(this)"></td><!---campos de SVcantidad--->
				</cfif>
				</tr>
			</cfloop>
		</cfif>
		<tr><td colspan="4">
			<cf_botones names="Guardar,Regresar" values="Guardar,Regresar" tabindex="1">
		</td></tr>
	</table>
</form>

	<script language="javascript" type="text/javascript">
		<!---Regresa a la lista principal--->
		function funcRegresar(){
			location.href = "ISBservicio-lista.cfm?PQcodigo=#form.PQcodigo#&Pagina=#Form.Pagina#&Filtro_PQnombre=#Form.Filtro_PQnombre#&Filtro_PQdescripcion=#Form.Filtro_PQdescripcion#&HFiltro_PQnombre=#Form.Filtro_PQnombre#&HFiltro_PQdescripcion=#Form.Filtro_PQdescripcion#";
			return false;
		}
		function validaNumerico(campo)
		{
			var mens = "Debe digitar un valor numérico."
			if(isNaN(campo.value))
			{	
				alert(mens);
				campo.value="";
			}
		}
		if (document.lista2.chk != null) {
			if (document.lista2.chk.value != null) {// solo para uno
				if (document.lista2.chk.checked) document.lista2.chk.checked = true; else document.lista2.chk.checked = false;
					var a = document.lista2.chk.value.split("|");
					var servicio = a[0];
					document.lista2.Cual_Grupo.value += servicio ;
			} else {
				for (var counter = 0; counter < document.lista2.chk.length; counter++) {
					var a = document.lista2.chk[counter].value.split("|");
					var servicio = a[0];
					document.lista2.Cual_Grupo.value += servicio + ",";
				}
				if (document.lista2.Cual_Grupo.value != "") {
					document.lista2.Cual_Grupo.value = document.lista2.Cual_Grupo.value.substring(0,document.lista2.Cual_Grupo.value.length-1);
				}
			}
		}
	</script>
</cfoutput>