<cfset checked   = "<img border=0 src=/cfmx/sif/imagenes/checked.gif>" >
<cfset unchecked = "<img border=0 src=/cfmx/sif/imagenes/unchecked.gif>" >

<cfif isDefined("url.ID_Evento") and not isDefined("form.ID_Evento")>
	<cfset form.ID_Evento = #Url.ID_Evento#>
</cfif>
	
<cfquery name="rsEncabezado" datasource="#session.dsn#">
    select 
        a.EVdescripcion
    from EEvento a
        where a.Ecodigo = #session.Ecodigo# 
        and  a.ID_Evento = #form.ID_Evento#
</cfquery>

<cf_templateheader title="Operaciones del Evento">
	<cf_web_portlet_start titulo="Operaciones del Eventos">
	<br>
	<table width="98%" align="center"  border="0" cellspacing="0" cellpadding="0">
		<tr>
			<td width="60%" valign="top">
                	
				<cfif isDefined("Url.ID_Operacion") and not isDefined("form.ID_Operacion")>
				  <cfset form.ID_Operacion = Url.ID_Operacion>
				</cfif>
                
				<cfif isDefined("Url.OperacionCodigo") and not isDefined("form.OperacionCodigo")>
				  <cfset form.OperacionCodigo = Url.OperacionCodigo>
				</cfif>
                
				<cfif isDefined("Url.Oorigen") and not isDefined("form.Oorigen")>
				  <cfset form.Oorigen = Url.Oorigen>
				</cfif>
                
				<cfif isDefined("Url.Transaccion") and not isDefined("form.Transaccion")>
				  <cfset form.Transaccion = Url.Transaccion>
				</cfif>
                
				<!--- Variables para Navegación --->
                
				<cfif isdefined("url.OperacionCodigo") and len(trim(url.FiltroOperacionCodigo))>
					<cfset form.FiltroOperacionCodigo = url.FiltroOperacionCodigo>
				</cfif>	
				<cfif isdefined("url.FiltroOorigen") and len(trim(url.FiltroOorigen))>
					<cfset form.FiltroOorigen = url.FiltroOorigen>
				</cfif>			
				<cfif isdefined("url.FiltroTransaccion") and len(trim(url.FiltroTransaccion))>
					<cfset form.FiltroTransaccion = url.FiltroTransaccion>
				</cfif>			
	
				<cfif isdefined("url._")>
					<cf_navegacion name = "FiltroOperacionCodigo" default = "">
					<cf_navegacion name = "FiltroOorigen" default = "">
                    <cf_navegacion name = "FiltroTransaccion" default = "">
				<cfelse>
					<cf_navegacion name = "FiltroOperacionCodigo" default = "" session="">
					<cf_navegacion name = "FiltroOorigen" default = "" session="">
                    <cf_navegacion name = "FiltroTransaccion" default = "" session="">
				</cfif>	

				<cfquery name="rsLista" datasource="#session.dsn#">
                    select 
                        a.ID_Evento,
                        a.ID_Operacion,
                        a.OperacionCodigo,
                        a.Oorigen,
                        cc.Cdescripcion as Cdescripcion,
                        a.Transaccion,
                        a.Complemento,
                        a.ComplementoActivo,
                        case when a.GeneraEvento = 0 then '#unchecked#' else '#checked#' end as GeneraEvento
                    from DEvento a
                    inner join ConceptoContable cc on cc.Oorigen=a.Oorigen and cc.Ecodigo=#session.Ecodigo#
					where a.ID_Evento = #form.ID_Evento# 
					<cfif isdefined('form.FiltroOperacionCodigo')and len(trim(form.FiltroOperacionCodigo)) >
						and upper(a.OperacionCodigo) like upper('%#form.FiltroOperacionCodigo#%')
					</cfif>	
					<cfif isdefined('form.FiltroOorigen')and len(trim(form.FiltroOorigen)) >
						and upper(a.Oorigen) like upper('%#form.FiltroOorigen#%')
					</cfif>	
					<cfif isdefined('form.FiltroTransaccion')and len(trim(form.FiltroTransaccion)) >
						and upper(a.Transaccion) like upper('%#form.FiltroTransaccion#%')
					</cfif>	
                    
				</cfquery>	
			<cfoutput>
				<form action="DEvento_SQL.cfm" name="form2" method="post">
                <input type="hidden" name="ID_Evento" value="#form.ID_Evento#" >
				<table width="100%"  border="0" cellspacing="0" cellpadding="0" style="margin:0px;">
                	<tr>
                    	<td class="titulolistas" colspan="4" align="left"><strong>#rsEncabezado.EVdescripcion#</strong></td>
                    </tr>
					<tr>
						<td class="titulolistas" colspan="1"><strong>Identificador</strong></td>
						<td class="titulolistas" colspan="1"><strong>Origen</strong></td>
                        <td class="titulolistas" colspan="1"><strong>Transacción</strong></td>
                        <td class="titulolistas" colspan="1">&nbsp;</td>
					</tr>
					<tr>
						<td class="titulolistas"><input type="text" name="FiltroOperacionCodigo"  tabindex="1" value="<cfif isdefined('form.FiltroOperacionCodigo')>#form.FiltroOperacionCodigo#</cfif>" size="5" maxlength="5"></td>
						<td class="titulolistas"><input type="text" name="FiltroOorigen"  tabindex="1" value="<cfif isdefined('form.FiltroOorigen')>#form.FiltroOorigen#</cfif>" size="20" maxlength="20"></td>
						<td class="titulolistas"><input type="text" name="FiltroTransaccion"  tabindex="1" value="<cfif isdefined('form.FiltroTransaccion')>#form.FiltroTransaccion#</cfif>" size="20" maxlength="20"></td>                        
						<td class="titulolistas"><input name="btnFiltrar" type="submit" id="btnFiltrar" value="Filtrar" tabindex="2" onclick="funcFiltrar();" /></td>
					</tr>
					<tr><td colspan="4"><hr></td></tr>
				</table> 
                
					<input name="chkTodos" type="checkbox" value="" border="0" onClick="javascript:Marcar(this);" style="background:background-color ">
					<label for="chkTodos">Seleccionar Todos</label>
                    
				</form>	
				
			</cfoutput>
            
			<cfif isdefined('form.FiltroOperacionCodigo')and len(trim(form.FiltroOperacionCodigo)) or 
            isdefined('form.FiltroOorigen')and len(trim(form.FiltroOorigen)) or 
            isdefined('form.FiltroTransaccion')and len(trim(form.FiltroTransaccion)) >
                <cfset LvarDireccion = 'ConfiguraEvento.cfm'>
            <cfelse>
                <cfset LvarDireccion = 'ConfiguraEvento.cfm?_'>
            </cfif>
				
				<cfinvoke
					component="sif.Componentes.pListas"
					method="pListaQuery"
					returnvariable="rsLista"
					query="#rsLista#"
					columnas="ID_Evento,ID_Operacion,OperacionCodigo,Oorigen,Transaccion,GeneraEvento,ComplementoActivo,Complemento"
					desplegar="OperacionCodigo,Oorigen,Transaccion,Complemento,GeneraEvento"
					etiquetas="Identificador,Origen,Transacción,Complemento,GeneraEvento"
					formatos="S,S,S,S,U"
					align="left,left,left,left,left"
					ajustar="S"
					keys="ID_Operacion"
					irA="#LvarDireccion#"
					maxrows="15"
					pageindex="3"
					navegacion="#navegacion#"  				 
					showEmptyListMsg= "true"
					checkboxes= "S"
					Botones ="Eliminar"
					form_method="post"
					formname= "form2_2"
					usaAJAX = "no"
					/>
					
					</td>
					<td width="5%">&nbsp;</td>
					<td width="55%" valign="top">
					<cfinclude template="ConfiguraDetEvento.cfm"> 
					</td>			
				</tr>
			</table>
		<br>
	<cf_web_portlet_end>
<cf_templatefooter>
<cfoutput>
<script language="javascript" type="text/javascript">
		function algunoMarcado(){
			var aplica = false;
			if (document.form2_2.chk) {
				if (document.form2_2.chk.value) {
					aplica = document.form2_2.chk.checked;
				} else {
					for (var i=0; i<document.form2_2.chk.length; i++) {
						if (document.form2_2.chk[i].checked) { 
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
				alert('Debe de seleccionar al menos un evento.');
				return false;			
			}	
			if (confirm("¿Está seguro de que desea Eliminar el Evento(s) seleccionado(s)?")) {
				
				document.form2_2.action = 'DEvento_SQL.cfm?ID_Evento=#form.ID_Evento#';
				
				return true;
			}
			return false;
		}
		
		function Marcar(c) {
			if (c.checked) {
				for (counter = 0; counter < document.form2_2.chk.length; counter++)
				{
					if ((!document.form2_2.chk[counter].checked) && (!document.form2_2.chk[counter].disabled))
						{  document.form2_2.chk[counter].checked = true;}
				};
				if ((counter==0)  && (!document.form2_2.chk.disabled)) {
					document.form2_2.chk.checked = true;
				}
			}
			else {
				for (var counter = 0; counter < document.form2_2.chk.length; counter++)
				{
					if ((document.form2_2.chk[counter].checked) && (!document.form2_2.chk[counter].disabled))
						{  document.form2_2.chk[counter].checked = false;}
				};
				if ((counter==0) && (!document.form2_2.chk.disabled)) {
					document.form2_2.chk.checked = false;
				}
			};
		}
		
		function funcFiltrar(){
			document.form2.action='ConfiguraEvento.cfm?ID_Evento=#form.ID_Evento#';
			
			document.form2.submit;
		}
</script>		
</cfoutput>