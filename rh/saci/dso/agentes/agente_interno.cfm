<cfsavecontent variable="pNavegacion">
	<cfinclude template="/home/menu/pNavegacion.cfm">
</cfsavecontent>

<cf_templateheader title="#nav__SPdescripcion#">
	<cfoutput>#pNavegacion#</cfoutput>
	
	<cfif isdefined("url.tab") and Len(Trim(url.tab))> 
		<br />
		<cfinclude template="agente-params.cfm">
	
			<cf_tabs width="100%">
			<cf_tab text="Registro de Agente" selected="#form.tab eq 1#">
				<div style="vertical-align:top;">
					<cfif form.tab eq 1>
						<cfinclude template="agente_registro.cfm">
					</cfif>
				</div>
			</cf_tab>
			
			<cf_tab text="Productos" selected="#form.tab eq 2#">
				<div style="vertical-align:top; ">
					<cfif form.tab eq 2>
						<cfinclude template="agente-productos.cfm">
					</cfif>
				</div>
			</cf_tab>
			<cf_tab text="Usuario SACI" selected="#form.tab eq 3#">
				<div style="height: 300; vertical-align:top; ">
					<cfif form.tab eq 3>
						<cfinclude template="agente-usuario.cfm">
					</cfif>
				</div>
			</cf_tab>
			<cf_tab text="Informaci&oacute;n de Servicios" selected="#form.tab eq 4#">
				<div style="vertical-align:top; ">
					<cfif form.tab eq 4>
						<cfinclude template="agente-InfoServicios.cfm">
					</cfif>
				</div>
			</cf_tab>				
			</cf_tabs>
			<br />
			
		<script type="text/javascript" language="javascript">
			function funcLista() {
				var params = '';

				<!--- Variables de la lista --->
				if (document.form1.PageNum_listaroot != undefined && document.form1.PageNum_listaroot.value != '') {
					params = params + '&PageNum_listaroot=' + document.form1.PageNum_listaroot.value;
				}
				if (document.form1.Filtro_Ppersoneria != undefined && document.form1.Filtro_Ppersoneria.value != '') {
					params = params + '&Filtro_Ppersoneria=' + document.form1.Filtro_Ppersoneria.value;
					params = params + '&hFiltro_Ppersoneria=' + document.form1.Filtro_Ppersoneria.value;
				}
				if (document.form1.Filtro_Pid != undefined && document.form1.Filtro_Pid.value != '') {
					params = params + '&Filtro_Pid=' + document.form1.Filtro_Pid.value;
					params = params + '&hFiltro_Pid=' + document.form1.Filtro_Pid.value;
				}
				if (document.form1.Filtro_nom_razon != undefined && document.form1.Filtro_nom_razon.value != '') {
					params = params + '&Filtro_nom_razon=' + document.form1.Filtro_nom_razon.value;
					params = params + '&hFiltro_nom_razon=' + document.form1.Filtro_nom_razon.value;
				}
				if (document.form1.Filtro_Habilitado != undefined && document.form1.Filtro_Habilitado.value != '') {
					params = params + '&Filtro_Habilitado=' + document.form1.Filtro_Habilitado.value;
					params = params + '&hFiltro_Habilitado=' + document.form1.Filtro_Habilitado.value;
				}
				
				<cfoutput>
				location.href = '#CurrentPage#?tab='+params;
				</cfoutput>
				return false;
			}

			function tab_set_current (n) {
				var params = '';
				var ag = '';
								
				if (document.form1.AGid != undefined && document.form1.AGid.value != '') {
					ag = document.form1.AGid.value;
					document.form1.ag.value = document.form1.AGid.value;
					params = params + '&ag=' + document.form1.ag.value;
					params = params + '&tipo=' + document.form1.tipo.value;
				} else if (n != '1') {
					alert('Debe registrar o seleccionar un agente antes de continuar');
					return false;
				}
				
				<!--- Se mantiene la cuenta y el paso solamente si es la misma persona con la que se ha estado trabajando --->


				if (ag != '' && ag == '<cfoutput>#Form.AGid#</cfoutput>') {					
					if (document.form1.CTid != undefined && document.form1.CTid.value != '') {
						params = params + '&cue=' + document.form1.CTid.value;
					} else if (document.form1.cue != undefined && document.form1.cue.value != '') {
						params = params + '&cue=' + document.form1.cue.value;
					}
					if (document.form1.paso != undefined && document.form1.paso.value != '') {
						params = params + '&paso=' + document.form1.paso.value;
					}
						//if (document.form1.tipo != undefined && document.form1.tipo.value != '') {
						//params = params + '&tipo=' + document.form1.tipo.value;
					//}

				}
				
				<!--- Variables de la lista --->
				if (document.form1.PageNum_listaroot != undefined && document.form1.PageNum_listaroot.value != '') {
					params = params + '&PageNum_listaroot=' + document.form1.PageNum_listaroot.value;
				}
				if (document.form1.Filtro_Ppersoneria != undefined && document.form1.Filtro_Ppersoneria.value != '') {
					params = params + '&Filtro_Ppersoneria=' + document.form1.Filtro_Ppersoneria.value;
					params = params + '&hFiltro_Ppersoneria=' + document.form1.Filtro_Ppersoneria.value;
				}
				if (document.form1.Filtro_Pid != undefined && document.form1.Filtro_Pid.value != '') {
					params = params + '&Filtro_Pid=' + document.form1.Filtro_Pid.value;
					params = params + '&hFiltro_Pid=' + document.form1.Filtro_Pid.value;
				}
				if (document.form1.Filtro_nom_razon != undefined && document.form1.Filtro_nom_razon.value != '') {
					params = params + '&Filtro_nom_razon=' + document.form1.Filtro_nom_razon.value;
					params = params + '&hFiltro_nom_razon=' + document.form1.Filtro_nom_razon.value;
				}
				if (document.form1.Filtro_Habilitado != undefined && document.form1.Filtro_Habilitado.value != '') {
					params = params + '&Filtro_Habilitado=' + document.form1.Filtro_Habilitado.value;
					params = params + '&hFiltro_Habilitado=' + document.form1.Filtro_Habilitado.value;
				}
				
				<cfoutput>
				location.href = '#CurrentPage#?tab='+escape(n)+params;
				</cfoutput>
			}
		</script>

	<cfelse>
		<cf_web_portlet_start titulo="Lista de Agentes">
			<cfinclude template="agente_interno_lista.cfm">
		<cf_web_portlet_end> 
	</cfif>
	
<cf_templatefooter>
