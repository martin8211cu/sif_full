<cf_templateheader title="SIF - Quick Pass">
	<cf_web_portlet_start titulo="Traslado de Tags">
	<br>


				<cfif isdefined("url.filtro_QPTtrasDocumento") and len(trim(url.filtro_QPTtrasDocumento))>
					<cfset form.filtro_QPTtrasDocumento = url.filtro_QPTtrasDocumento>
				</cfif>
				<cfif isdefined("url.filtro_QPTtrasDescripcion") and len(trim(url.filtro_QPTtrasDescripcion))>
					<cfset form.filtro_QPTtrasDescripcion = url.filtro_QPTtrasDescripcion>
				</cfif>					
				<cfif isdefined("url.filtro_OficinaOri") and len(trim(url.filtro_OficinaOri))>
					<cfset form.filtro_OficinaOri = url.filtro_OficinaOri>
				</cfif>

				<cfif isdefined("url.filtro_OficinaDest") and len(trim(url.filtro_OficinaDest))>
					<cfset form.filtro_OficinaDest = url.filtro_OficinaDest>
				</cfif>

				<cfif isdefined("url._")>
					<cf_navegacion name = "filtro_QPTtrasDocumento" default = "">
					<cf_navegacion name = "filtro_QPTtrasDescripcion" default = "">
					<cf_navegacion name = "filtro_OficinaOri" default = "">
					<cf_navegacion name = "filtro_OficinaDest" default = "">
					
				<cfelse>
					<cf_navegacion name = "filtro_QPTtrasDocumento" default = "" session="">
					<cf_navegacion name = "filtro_QPTtrasDescripcion" default = "" session="">
					<cf_navegacion name = "filtro_OficinaOri" default = "" session="">
					<cf_navegacion name = "filtro_OficinaDest" default = "" session="">
				</cfif>		

	
	<table width="98%" align="center"  border="0" cellspacing="0" cellpadding="0">
		<tr>
			<td width="60%" valign="top">
				
				<!-- Aqui van los campos Llave Definidos para la tabla -->
				<cfset navegacion = "">
				<cfquery name="rsLista" datasource="#session.dsn#">
					select 
						e.QPTid,
						e.OcodigoOri, 
						e.OcodigoDest, 
						oo.Odescripcion as OficinaOri,
						od.Odescripcion as OficinaDest,
						e.QPTtrasDocumento, 
						e.QPTtrasDescripcion, 
						oo.Oficodigo, 
						od.Oficodigo, 
						BMFecha as Fecha
					from QPassTraslado e
						inner join Oficinas oo
						on oo.Ecodigo = e.Ecodigo
						and oo.Ocodigo = e.OcodigoOri
					
						inner join Oficinas od
						on od.Ecodigo = e.Ecodigo
						and od.Ocodigo = e.OcodigoDest
					where e.Ecodigo = #session.Ecodigo# 
					and e.QPTtrasEstado = 0
                    and exists(
                                select 1
                                from QPassUsuarioOficina f
                                where f.Usucodigo = #session.Usucodigo#
                                and  f.Ecodigo = #session.Ecodigo#
                                and f.Ecodigo = oo.Ecodigo
                                and f.Ocodigo = oo.Ocodigo
                            	)
					<cfif isdefined('form.filtro_QPTtrasDocumento')and len(trim(form.filtro_QPTtrasDocumento)) >
						and upper(e.QPTtrasDocumento) like upper('%#form.filtro_QPTtrasDocumento#%')
					</cfif>	
					<cfif isdefined('form.filtro_QPTtrasDescripcion')and len(trim(form.filtro_QPTtrasDescripcion)) >
						and upper(e.QPTtrasDescripcion) like upper('%#form.filtro_QPTtrasDescripcion#%')
					</cfif>	
					<cfif isdefined('form.filtro_OficinaOri')and len(trim(form.filtro_OficinaOri)) >
						and upper(oo.Odescripcion) like upper('%#form.filtro_OficinaOri#%')
					</cfif>	
					<cfif isdefined('form.filtro_OficinaDest')and len(trim(form.filtro_OficinaDest)) >
						and upper(od.Odescripcion) like upper('%#form.filtro_OficinaDest#%')
					</cfif>	
				</cfquery>	
				
				<cfoutput>
				<label for="chkTodos">Lista de Documentos</label>
				</cfoutput>

				<cfinvoke
					component="sif.Componentes.pListas"
					method="pListaQuery"
					query="#rsLista#"
					desplegar="QPTtrasDocumento, QPTtrasDescripcion, OficinaOri,OficinaDest"
					etiquetas="Documento, Descripci&oacute;n, Sucursal Origen, Sucursal Destino"
					formatos="S,S,S,S"
					align="left,left,right,right"
					ajustar="S"
					irA="TrasladoQPass.cfm"
					keys="QPTid"
					maxrows="50"
					pageindex="3"
					navegacion="#navegacion#" 				 
					showEmptyListMsg= "true"
					form_method="post"
					formname= "form2"
					usaAJAX = "no"
					mostrar_filtro ="true"
					/>
			</td>
			<td width="5%">&nbsp;</td>
			<td width="55%" valign="top">
				<cfinclude template="TrasladoQPass_form.cfm"> 
			</td>			
		</tr>
	</table>

	<br>
	<cf_web_portlet_end>
<cf_templatefooter>
	
<script language="javascript" type="text/javascript">
		function funcFiltrar(){
			document.form2.action='TrasladoQPass.cfm';
			document.form2.submit;
		}
</script>		
