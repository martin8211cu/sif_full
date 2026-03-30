<cf_templateheader title="Estado">
	<cf_web_portlet_start titulo="Mantenimiento de Estados">
	<br>
	<table width="98%" align="center"  border="0" cellspacing="0" cellpadding="0">
		<tr>
			<td width="60%" valign="top">
				<!---  --->
				<cfif isDefined("Url.QPidEstado") and not isDefined("form.QPidEstado")>
				  <cfset form.QPidEstado = Url.QPidEstado>
				</cfif>		
				<cfif isDefined("Url.QPEdescripcion") and not isDefined("form.QPEdescripcion")>
				  <cfset form.QPEdescripcion = Url.QPEdescripcion>
				</cfif>
				<!--- Variables para Navegación --->
				<cfif isdefined("url.FiltroQPEdescripcion") and len(trim(url.FiltroQPEdescripcion))>
					<cfset form.FiltroQPEdescripcion = url.FiltroQPEdescripcion>
				</cfif>			
				
				<cfif isdefined("url._")>
					<cf_navegacion name = "FiltroQPEdescripcion" default = "">
				<cfelse>
					<cf_navegacion name = "FiltroQPEdescripcion" default = "" session="">
				</cfif>					
				<cfquery name="rsLista" datasource="#session.dsn#">
					select 
						a.QPidEstado,
						a.Ecodigo ,
						a.QPEdescripcion ,
						case a.QPEdisponibleVenta when 1 then 'S' when 0 then 'N' else '' end as QPEdisponibleVenta,
						a.QEPvalorDefault ,
						a.ts_rversion 
					from QPassEstado a
						where a.Ecodigo = #session.Ecodigo# 
					<cfif isdefined('form.FiltroQPEdescripcion')and len(trim(form.FiltroQPEdescripcion)) >
						and upper(a.QPEdescripcion) like upper('%#form.FiltroQPEdescripcion#%')
					</cfif>	
				</cfquery>	
			<cfoutput>
				<form action="QPassEstado_SQL.cfm" name="form2" method="post">
				<table width="100%"  border="0" cellspacing="0" cellpadding="0" style="margin:0px;">
					<tr>
						<td class="titulolistas" colspan="2"><strong>Descripci&oacute;n</strong></td>
					</tr>
					<tr>
						<td class="titulolistas"><input type="text" name="FiltroQPEdescripcion"  tabindex="1" value="<cfif isdefined('form.FiltroQPEdescripcion')>#form.FiltroQPEdescripcion#</cfif>"></td>
						<td class="titulolistas"><input name="btnFiltrar" type="submit" id="btnFiltrar" value="Filtrar" tabindex="2" onclick="funcFiltrar();" /></td>
					</tr>
					<tr><td colspan="4"><hr></td></tr>
				</table> 
					<input name="chkTodos" type="checkbox" value="" border="0" onClick="javascript:Marcar(this);" style="background:background-color ">
					<label for="chkTodos">Seleccionar Todos</label>
				</form>	
			</cfoutput>
				<cfif isdefined('form.FiltroQPEdescripcion')and len(trim(form.FiltroQPEdescripcion))>
					<cfset LvarDireccion = 'QPassEstado.cfm'>
				<cfelse>
					<cfset LvarDireccion = 'QPassEstado.cfm?_'>
				</cfif>
				<cfinvoke
					component="sif.Componentes.pListas"
					method="pListaQuery"
					returnvariable="rsLista"
					query="#rsLista#"
					columnas="QPEdescripcion, case QPEdisponibleVenta when 1 then 'S' when 0 then 'N' end as QPEdisponibleVenta, case QEPvalorDefault when 1 then 'S' when 0 then 'N' end as QEPvalorDefault"
					desplegar="QPEdescripcion, QPEdisponibleVenta,QEPvalorDefault"
					etiquetas="Descripci&oacute;n, Disponible en venta, Valor por Omisi&oacute;n"
					formatos="S,U,U"
					align="left,left,left"
					ajustar="S"
					keys="QPidEstado"
					irA="#LvarDireccion#"
					maxrows="5"
					pageindex="3"
					navegacion="#navegacion#"  				 
					showEmptyListMsg= "true"
					checkboxes= "S"
					Botones ="Eliminar"
					form_method="post"
					formname= "form3"
					usaAJAX = "no"
					/>
					</td>
					<td width="5%">&nbsp;</td>
					<td width="55%" valign="top">
					<cfinclude template="QPassEstado_form.cfm"> 
					</td>			
				</tr>
			</table>
		<br>
	<cf_web_portlet_end>
<cf_templatefooter>
	
<script language="javascript" type="text/javascript">
		function funcEliminar(){
			if (confirm("¿Está seguro de que desea Eliminar el Estado(s) seleccionado(s)?")) {
				document.form3.action = "QPassEstado_SQL.cfm";
				return true;
			}
			return false;
		}
		function Marcar(c) {
			if (c.checked) {
				for (counter = 0; counter < document.form3.chk.length; counter++)
				{
					if ((!document.form3.chk[counter].checked) && (!document.form3.chk[counter].disabled))
						{  document.form3.chk[counter].checked = true;}
				}
				if ((counter==0)  && (!document.form3.chk.disabled)) {
					document.form3.chk.checked = true;
				}
			}
			else {
				for (var counter = 0; counter < document.form3.chk.length; counter++)
				{
					if ((document.form3.chk[counter].checked) && (!document.form3.chk[counter].disabled))
						{  document.form3.chk[counter].checked = false;}
				};
				if ((counter==0) && (!document.form3.chk.disabled)) {
					document.form3.chk.checked = false;
				}
			};
		}
		
		function funcFiltrar(){
			document.form2.action='QPassEstado.cfm';
			document.form2.submit;
		}
</script>		
