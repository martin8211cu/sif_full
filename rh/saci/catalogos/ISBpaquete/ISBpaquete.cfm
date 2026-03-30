<cfsavecontent variable="pNavegacion">
	<cfinclude template="/home/menu/pNavegacion.cfm">
</cfsavecontent>

<cf_templateheader title="#nav__SPdescripcion#">
	<cfoutput>#pNavegacion#</cfoutput>
	
	<cfif isdefined("url.tab") and Len(Trim(url.tab))>		
		<br />
		<cfinclude template="ISBpaquete-params.cfm">
		<cf_tabs width="100%">
			<cf_tab text="Registro de Paquetes" selected="#url.tab eq 1#">
				<div style="vertical-align:top;">
					<cfif url.tab eq 1>
						<cfinclude template="ISBpaquete-form.cfm">
					</cfif>
				</div>
			</cf_tab>
			<cfif  Not data.RecordCount is 0>
				<cf_tab text="Cambio de Paquete" selected="#url.tab eq 2#">
					<div style="vertical-align:top; ">
						<cfif url.tab eq 2>
							<cfinclude template="ISBpaqueteCambio-form.cfm">
						</cfif>
					</div>
				</cf_tab>
			</cfif>
		</cf_tabs>
		<br />
		
		<cfoutput>
			<script type="text/javascript" language="javascript">
				function funcLista() {
					var params = '';
	
					<!--- Variables de la lista --->
					if (document.form1.PageNum_listaroot != undefined && document.form1.PageNum_listaroot.value != '') {
						params = params + '&PageNum_listaroot=' + document.form1.PageNum_listaroot.value;
					}
					if (document.form1.Filtro_PQnombre != undefined && document.form1.Filtro_PQnombre.value != '') {
						params = params + '&Filtro_PQnombre=' + document.form1.Filtro_PQnombre.value;
						params = params + '&hFiltro_PQnombre=' + document.form1.Filtro_PQnombre.value;
					}
					if (document.form1.Filtro_PQdescripcion != undefined && document.form1.Filtro_PQdescripcion.value != '') {
						params = params + '&Filtro_PQdescripcion=' + document.form1.Filtro_PQdescripcion.value;
						params = params + '&hFiltro_PQdescripcion=' + document.form1.Filtro_PQdescripcion.value;
					}

					<cfoutput>
					location.href = '#CurrentPage#?tab='+params;
					</cfoutput>
					return false;
				}
				
				function tab_set_current (n) {
					var params = '';
					if (document.form1.PQcodigo != undefined && document.form1.PQcodigo.value != '') {
						params = params + '&PQcodigo=' + document.form1.PQcodigo.value;
					} else if (n != '1') {
						alert('Debe registrar o seleccionar un paquete antes de continuar');
						return false;
					}
					
					<!--- Variables de la lista --->
					if (document.form1.PageNum_listaroot != undefined && document.form1.PageNum_listaroot.value != '') {
						params = params + '&PageNum_listaroot=' + document.form1.PageNum_listaroot.value;
					}
					if (document.form1.Filtro_PQnombre != undefined && document.form1.Filtro_PQnombre.value != '') {
						params = params + '&Filtro_PQnombre=' + document.form1.Filtro_PQnombre.value;
						params = params + '&hFiltro_PQnombre=' + document.form1.Filtro_PQnombre.value;
					}
					if (document.form1.Filtro_PQdescripcion != undefined && document.form1.Filtro_PQdescripcion.value != '') {
						params = params + '&Filtro_PQdescripcion=' + document.form1.Filtro_PQdescripcion.value;
						params = params + '&hFiltro_PQdescripcion=' + document.form1.Filtro_PQdescripcion.value;
					}

					<cfoutput>
					location.href = '#CurrentPage#?tab='+escape(n)+params;
					</cfoutput>
				}
			</script>
		</cfoutput>	

	<cfelse>
	
		<cfinclude template="ISBpaquete-params.cfm">
		<cf_web_portlet_start titulo="Lista de Paquetes">
		
			<cfinvoke component="sif.Componentes.pListas" method="pLista"
				tabla="ISBpaquete"
				columnas="PQcodigo,PQnombre,PQdescripcion,PQinterfaz, '1' as tab"
				filtro="1=1 order by PQnombre,PQcodigo,PQdescripcion"
				desplegar="PQnombre,PQdescripcion"
				etiquetas="Nombre,Descripci&oacute;n"
				formatos="S,S"
				align="left,left"
				ira="ISBpaquete.cfm"
				form_method="get"
				formName="listaPaquetes"
				keys="PQcodigo"
				mostrar_filtro="yes"
				filtrar_automatico="yes"
				botones="Nuevo"
				navegacion=""
				PageIndex="root"
				maxrows="15"
			/>
			
		<cf_web_portlet_end>

		<cfoutput>
			<script language="JavaScript" type="text/javascript" >
				function funcNuevo() {
					location.href = "ISBpaquete.cfm?tab=1";
					return false;
				}
			</script>
		</cfoutput>
		
	</cfif>
	
<cf_templatefooter>
