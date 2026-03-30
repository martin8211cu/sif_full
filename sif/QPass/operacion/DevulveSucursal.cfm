<cfif isdefined("url.QPEAPid")>
	<cflocation addtoken="no" url="TagDevulveSucursal.cfm?QPEAPid=#url.QPEAPid#">
</cfif>

<cf_templateheader title="SIF - Quick Pass">
	<cf_web_portlet_start titulo="Devolución Tag a Sucursal">
	<br>
	
		<cfif isdefined("url.filtro_QPTtrasDocumento") and len(trim(url.filtro_QPTtrasDocumento))>
			<cfset form.filtro_QPTtrasDocumento = url.filtro_QPTtrasDocumento>
		</cfif>
		<cfif isdefined("url.filtro_QPEAPDescripcion") and len(trim(url.filtro_QPEAPDescripcion))>
			<cfset form.filtro_QQPEAPDescripcion = url.filtro_QPEAPDescripcion>
		</cfif>					
		<cfif isdefined("url.filtro_Usulogin") and len(trim(url.filtro_Usulogin))>
			<cfset form.filtro_Usulogin = url.filtro_Usulogin>
		</cfif>

		<cfif isdefined("url.filtro_Promotor") and len(trim(url.filtro_Promotor))>
			<cfset form.filtro_Promotor = url.filtro_Promotor>
		</cfif>

		<cfif isdefined("url._")>
			<cf_navegacion name = "filtro_QPEAPDocumento" default = "">
			<cf_navegacion name = "filtro_QPEAPDescripcion" default = "">
			<cf_navegacion name = "filtro_Usulogin" default = "">
			<cf_navegacion name = "filtro_Promotor" default = "">
			
		<cfelse>
			<cf_navegacion name = "filtro_QPEAPDocumento" default = "" session="">
			<cf_navegacion name = "filtro_QPEAPDescripcion" default = "" session="">
			<cf_navegacion name = "filtro_Usulogin" default = "" session="">
			<cf_navegacion name = "filtro_Promotor" default = "" session="">
		</cfif>		
	
	
	<table width="98%" align="center"  border="0" cellspacing="0" cellpadding="0">
		<tr>
			<td width="100%" valign="top">
				
				<cfset navegacion = "">
                <cf_dbfunction name="op_concat" returnvariable="_CAT">
				<cfquery name="rsLista" datasource="#session.dsn#">
					select 
                        a.QPEAPid,
                        a.QPEAPDocumento,
                        a.QPEAPDescripcion,
                    	c.QPPcodigo #_CAT# ' ' #_CAT# QPPnombre as Promotor,
                        b.Usulogin
                    from QPEAsignaPromotor a
                    inner join Usuario b
                        on b.Usucodigo = a.Usucodigo
                    inner join QPPromotor c
                        on c.QPPid = a.QPPid
                    inner join DatosPersonales d
                    	on d.datos_personales = b.datos_personales
                    where  c.QPPestado = '1'
                    and a.QPEAPEstado = 1
                    and exists(
                                select 1
                                from QPassUsuarioOficina f
                                where f.Usucodigo = #session.Usucodigo#
                                and  f.Ecodigo = #session.Ecodigo#
                                and f.Ecodigo = c.Ecodigo
                                and f.Ocodigo = c.Ocodigo
                            	)
					<cfif isdefined('form.filtro_QPEAPDocumento')and len(trim(form.filtro_QPEAPDocumento)) >
						and upper(a.QPEAPDocumento) like upper('%#form.filtro_QPEAPDocumento#%')
					</cfif>	
					<cfif isdefined('form.filtro_QPEAPDescripcion')and len(trim(form.filtro_QPEAPDescripcion)) >
						and upper(a.QPEAPDescripcion) like upper('%#form.filtro_QPEAPDescripcion#%')
					</cfif>	
					<cfif isdefined('form.filtro_Usulogin')and len(trim(form.filtro_Usulogin)) >
						and upper(b.Usulogin) like upper('%#form.filtro_Usulogin#%')
					</cfif>	
					<cfif isdefined('form.filtro_Promotor')and len(trim(form.filtro_Promotor)) >
						and upper(c.QPPcodigo) like upper('%#form.filtro_Promotor#%') or  upper(c.QPPnombre) like upper('%#form.filtro_Promotor#%') 
					</cfif>	
										
				</cfquery>	
				
				<cfoutput>
				<label for="chkTodos">Lista de Documentos</label>
				</cfoutput>

				<cfinvoke
					component="sif.Componentes.pListas"
					method="pListaQuery"
					query="#rsLista#"
					desplegar="QPEAPDocumento, QPEAPDescripcion, Usulogin, Promotor"
					etiquetas="Documento, Descripci&oacute;n, Usuario Envió, Promotor Asignado"
					formatos="S,S,S,S"
					align="left,left,left,left"
					ajustar="S"
					irA="TagDevulveSucursal.cfm"
					keys="QPEAPid"
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
		</tr>
	</table>

	<br>
	<cf_web_portlet_end>
<cf_templatefooter>
	
<script language="javascript" type="text/javascript">
		function funcFiltrar(){
			document.form2.action='DevulveSucursal.cfm';
			document.form2.submit;
		}
</script>		
