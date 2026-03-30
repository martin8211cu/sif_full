<cfset checked   = "<img border=0 src=/cfmx/sif/imagenes/checked.gif>" >
<cfset unchecked = "<img border=0 src=/cfmx/sif/imagenes/unchecked.gif>" >
<cf_templateheader title="Evento">
	<cf_web_portlet_start titulo="Formato de Control Evento">
	<br>
	<table width="98%" align="center"  border="0" cellspacing="0" cellpadding="0">
		<tr>
			<td width="60%" valign="top">
				<cfif isDefined("Url.ECcomodin") and not isDefined("form.ECcomodin")>
				  <cfset form.ECcomodin = Url.ECcomodin>
				</cfif>		
				<cfif isDefined("Url.ECReferencia") and not isDefined("form.ECReferencia")>
				  <cfset form.ECReferencia = Url.ECReferencia>
				</cfif>
                                
				<!--- Variables para Navegación --->
				<cfif isdefined("url.FiltroECcomodin") and len(trim(url.FiltroECcomodin))>
					<cfset form.FiltroECcomodin = url.FiltroECcomodin>
				</cfif>	
				<cfif isdefined("url.FiltroECReferencia") and len(trim(url.FiltroECReferencia))>
					<cfset form.FiltroECReferencia = url.FiltroECReferencia>
				</cfif>			
						
				<cfif isdefined("url._")>
					<cf_navegacion name = "FiltroECcomodin" default = "">
					<cf_navegacion name = "FiltroECReferencia" default = "">
				<cfelse>
					<cf_navegacion name = "FiltroECcomodin" default = "" session="">
					<cf_navegacion name = "FiltroECReferencia" default = "" session="">
				</cfif>	


				<cfquery name="rsLista" datasource="#Session.DSN#">
                select 
                    a.ECcomodin,
                    a.ECReferencia,
                    case                     
                    when a.ECReferencia=1 then 'Periodo'
                    when a.ECReferencia=2 then 'Mes'
                    when a.ECReferencia=3 then 'Consecutivo'
                    when a.ECReferencia=4 then 'Origen'
                    when a.ECReferencia=5 then 'Transacción'
                    when a.ECReferencia=6 then 'Complemento' 
                    when a.ECReferencia=7 then 'Otro' 
                    end as defECReferencia,
                    case when a.ECactivo = 0 then '#unchecked#' else '#checked#' end as ECactivo
				from ComodinEvento a
					where 1=1 
					<cfif isdefined('form.FiltroECcomodin') and len(trim(form.FiltroECcomodin)) >
						and upper(a.ECcomodin) like upper('%#form.FiltroECcomodin#%')
					</cfif>	
                    
					<cfif isdefined('form.FiltroECReferencia') and len(trim(form.FiltroECReferencia)) and trim(form.FiltroECReferencia) neq 0>
						and ECReferencia = #form.FiltroECReferencia#                       
					</cfif>	
                    
				</cfquery>	
			<cfoutput>
				<form action="Comodin_SQL.cfm" name="form2" method="post">
				<table width="100%"  border="0" cellspacing="0" cellpadding="0" style="margin:0px;">
					<tr>
						<td class="titulolistas" colspan="1"><strong>Formato</strong></td>
						<td class="titulolistas" colspan="2"><strong>Referencia</strong></td>
					</tr>
					<tr>
						<td class="titulolistas"><input type="text" name="FiltroECcomodin"  tabindex="1" value="<cfif isdefined('form.FiltroECcomodin')>#form.FiltroECcomodin#</cfif>" size="5" maxlength="5"></td>
                        
						<td class="titulolistas">
                            <select name="FiltroECReferencia"  tabindex="2" >
                              <option value="0" <cfif (isDefined("Form.FiltroECReferencia") AND "0" EQ #Form.FiltroECReferencia#)>selected</cfif>>Todos</option>
                              <option value="1" <cfif (isDefined("Form.FiltroECReferencia") AND "1" EQ #Form.FiltroECReferencia#)>selected</cfif>>Periodo</option>
                              <option value="2" <cfif (isDefined("Form.FiltroECReferencia") AND "2" EQ #Form.FiltroECReferencia#)>selected</cfif>>Mes</option>
                              <option value="3" <cfif (isDefined("Form.FiltroECReferencia") AND "3" EQ #Form.FiltroECReferencia#)>selected</cfif>>Consecutivo</option>
                              <option value="4" <cfif (isDefined("Form.FiltroECReferencia") AND "4" EQ #Form.FiltroECReferencia#)>selected</cfif>>Origen</option>
                              <option value="5" <cfif (isDefined("Form.FiltroECReferencia") AND "5" EQ #Form.FiltroECReferencia#)>selected</cfif>>Transacci&oacute;n</option>
                              <option value="6" <cfif (isDefined("Form.FiltroECReferencia") AND "6" EQ #Form.FiltroECReferencia#)>selected</cfif>>Complemento</option>
                              <option value="7" <cfif (isDefined("Form.FiltroECReferencia") AND "7" EQ #Form.FiltroECReferencia#)>selected</cfif>>Otro</option>
                            </select>
						</td>
						<td class="titulolistas"><input name="btnFiltrar" type="submit" id="btnFiltrar" value="Filtrar" tabindex="2" onclick="funcFiltrar();" /></td>
					</tr>
					<tr><td colspan="4"><hr></td></tr>
				</table> 
					<input name="chkTodos" type="checkbox" value="" border="0" onClick="javascript:Marcar(this);" style="background:background-color ">
					<label for="chkTodos">Seleccionar Todos</label>
				</form>	
				
			</cfoutput>
				<cfif isdefined('form.FiltroECcomodin')and len(trim(form.FiltroECcomodin)) or 
				isdefined('form.FiltroECReferencia')and len(trim(form.FiltroECReferencia)) >
					<cfset LvarDireccion = 'Comodin.cfm'>
				<cfelse>
					<cfset LvarDireccion = 'Comodin.cfm?_'>
				</cfif>
				
				<cfinvoke
					component="sif.Componentes.pListas"
					method="pListaQuery"
					returnvariable="rsLista"
					query="#rsLista#"
					columnas="ECcomodin,defECReferencia,ECReferencia,ECactivo"
					desplegar="ECcomodin,defECReferencia,ECactivo"
					etiquetas="Formato,Referencia,Activo"
					formatos="S,S,U"
					align="left,left,left"
					ajustar="S"
					keys="ECcomodin"
					irA="#LvarDireccion#"
					maxrows="15"
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
					<cfinclude template="Comodin_form.cfm"> 
					</td>			
				</tr>
			</table>
		<br>
	<cf_web_portlet_end>
<cf_templatefooter>
	
<script language="javascript" type="text/javascript">
		function algunoMarcado(){
			var aplica = false;
			if (document.form3.chk) {
				if (document.form3.chk.value) {
					aplica = document.form3.chk.checked;
				} else {
					for (var i=0; i<document.form3.chk.length; i++) {
						if (document.form3.chk[i].checked) { 
							aplica = true;
							break;
						}
					}
				}
			}
			return aplica;
		}

		function funcEliminar(){
			if (!algunoMarcado()) {
				alert('Debe de seleccionar al menos un comodín.');
				return false;			
			}	
			if (confirm("¿Está seguro de que desea Eliminar el Comodin(es) seleccionado(s)?")) {
				
				document.form3.action = "Comodin_SQL.cfm";
				
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
				};
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
			document.form2.action='Comodin.cfm';
			document.form2.submit;
		}
</script>		
