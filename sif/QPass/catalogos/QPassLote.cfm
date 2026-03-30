<cf_templateheader title="Lote">
	<cf_web_portlet_start titulo="Mantenimiento de Lotes">
	<br>
	<table width="98%" align="center"  border="0" cellspacing="0" cellpadding="0">
		<tr>
			<td width="60%" valign="top">
				<!---  --->
				<cfif isDefined("Url.QPidLote") and not isDefined("form.QPidLote")>
				  <cfset form.QPidLote = Url.QPidLote>
				</cfif>		
				<cfif isDefined("Url.QPLcodigo") and not isDefined("form.QPLcodigo")>
				  <cfset form.QPLcodigo = Url.QPLcodigo>
				</cfif>
				<!--- Variables para Navegacin --->
				<cfif isdefined("url.FiltroQPLcodigo") and len(trim(url.FiltroQPLcodigo))>
					<cfset form.FiltroQPLcodigo = url.FiltroQPLcodigo>
				</cfif>					
				<cfif isdefined("url.FiltroQPLdescripcion") and len(trim(url.FiltroQPLdescripcion))>
					<cfset form.FiltroQPLdescripcion = url.FiltroQPLdescripcion>
				</cfif>
				
				<!-- Aqui van los campos Llave Definidos para la tabla -->
				<cfif isdefined("url._")>
					<cf_navegacion name = "FiltroQPLcodigo" default = "">
					<cf_navegacion name = "FiltroQPLdescripcion" default = "">
				<cfelse>
					<cf_navegacion name = "FiltroQPLcodigo" default = "" session="">
					<cf_navegacion name = "FiltroQPLdescripcion" default = "" session="">
				</cfif>			
						
				<cfquery name="rsLista" datasource="#session.dsn#">
					select a.QPidLote , a.QPLcodigo , a.QPLdescripcion , a.QPLfechaProduccion , a.QPLfechaFinVigencia , BMfecha ,BMUsucodigo 
					from QPassLote a
					where a.Ecodigo = #session.Ecodigo# 
					<cfif isdefined('form.FiltroQPLcodigo')and len(trim(form.FiltroQPLcodigo)) >
						and upper(a.QPLcodigo) like upper('%#form.FiltroQPLcodigo#%')
					</cfif>	
					<cfif isdefined('form.FiltroQPLdescripcion')and len(trim(form.FiltroQPLdescripcion)) >
						and upper(a.QPLdescripcion) like upper('%#form.FiltroQPLdescripcion#%')
					</cfif>	
				</cfquery>	
				
				<cfoutput>
					<form action="QPassLote_SQL.cfm" name="form2" method="post">
					<cfif isdefined("form.QPLcodigo") and len(trim(form.QPLcodigo))>
						<input type="hidden" name="QPLcodigo" value="#form.QPLcodigo#">
					</cfif>
					<table width="100%"  border="0" cellspacing="0" cellpadding="0" style="margin:0px;">
						<tr>
							<td class="titulolistas"><strong>C&oacute;digo</strong></td>
							<td class="titulolistas" colspan="2"><strong>Descripci&oacute;n</strong></td>
						</tr>
						<tr>
							<td class="titulolistas"><input type="text" name="FiltroQPLcodigo"  tabindex="1" value="<cfif isdefined('form.FiltroQPLcodigo')>#form.FiltroQPLcodigo#</cfif>"></td>
							<td class="titulolistas"><input type="text" name="FiltroQPLdescripcion" tabindex="1" value="<cfif isdefined('form.FiltroQPLdescripcion')>#form.FiltroQPLdescripcion#</cfif>"></td>
							<td class="titulolistas"><input name="btnFiltrar" type="submit" id="btnFiltrar" value="Filtrar" tabindex="2" onclick="funcFiltrar();" /></td>
						</tr>
						<tr><td colspan="4"><hr></td></tr>
					</table> 
						<input name="chkTodos" type="checkbox" value="" border="0" onClick="javascript:Marcar(this);" style="background:background-color ">
						<label for="chkTodos">Seleccionar Todos</label>
	
						<cfset LvarFuncion1 = "QPassLote">
						<script language="javascript" type="text/javascript">
							var popUpWin#LvarFuncion1#=null;
							function popUpWindow#LvarFuncion1#(URLStr, left, top, width, height)
							{
							  if(popUpWin#LvarFuncion1#)
							  {
								if(!popUpWin#LvarFuncion1#.closed) popUpWin#LvarFuncion1#.close();
							  }
							  popUpWin#LvarFuncion1# = open(URLStr, 'popUpWin#LvarFuncion1#', 'toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=yes,resizable=no,copyhistory=yes,width='+width+',height='+height+',left='+left+', top='+top+',screenX='+left+',screenY='+top+'');
							  if (! popUpWin#LvarFuncion1# && !document.popupblockerwarning) {
								alert('Aviso: Su bloqueador de ventanas emergentes (popup blocker) \nest evitando que se abra la ventana.\nPor favor revise las opciones de su navegador (browser), y \nacepte las ventanas emergentes de este sitio: ' + location.hostname);
								document.popupblockerwarning = 1;
							  }
							}
						</script>
							<fieldset><legend>Lista de Lotes (<a href="##" onClick="javascript:popUpWindow#LvarFuncion1#(('QPassLote-rpt.cfm'),50,50,600,400);">Imprimir</a> <a href="##" onClick="javascript:popUpWindow#LvarFuncion1#(('QPassLote-rpt.cfm'),50,50,600,400);"><img src="/cfmx/sif/imagenes/impresora.gif" border="0"></a>)</legend>
					</form>	
				</cfoutput>
					<cfif isdefined('form.FiltroQPLcodigo')and len(trim(form.FiltroQPLcodigo)) or isdefined('form.FiltroQPLdescripcion')and len(trim(form.FiltroQPLdescripcion)) >
						<cfset LvarDireccion = 'QPassLote.cfm'>
					<cfelse>
						<cfset LvarDireccion = 'QPassLote.cfm?_'>
					</cfif>
				
					<cfinvoke
						component="sif.Componentes.pListas"
						method="pListaQuery"
						returnvariable="rsLista"
						query="#rsLista#"
						desplegar="QPLcodigo, QPLdescripcion, QPLfechaFinVigencia"
						etiquetas="C&oacute;digo, Descripci&oacute;n, Vencimiento "
						formatos="S,S,D"
						align="left,left,right"
						ajustar="S"
						irA="#LvarDireccion#"
						keys="QPidLote"
						maxrows="10"
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
				<cfinclude template="QPassLote_form.cfm"> 
			</td>			
		</tr>
	</table>
	<br>
	<cf_web_portlet_end>
<cf_templatefooter>
	
<script language="javascript" type="text/javascript">
		function funcEliminar(){
			if (confirm("Est seguro de que desea Eliminar el Lote(s) seleccionado(s)?")) {
				document.form3.action = "QPassLote_SQL.cfm";
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
			document.form2.action='QPassLote.cfm';
			document.form2.submit;
		}
</script>		
