
<cf_templateheader title="Mantenimiento de Sobres de acceso">
	
<cf_web_portlet_start titulo="Mantenimiento de Sobres de acceso">
	<cfinclude template="ISBsobres-params.cfm">

	<cfquery name="rsSestado" datasource="#session.DSN#">
			select '-1' as value
				, '--Todas--' as description
		union 		
			Select '0' as value
				, 'Disponible' as description
		union
			Select 	
				 '1' as value
				, 'En uso' as description								
		union
			Select
				 '2' as value
				, 'Nulo' as description			
		order by value
	</cfquery>
	<cfquery name="rsSdonde" datasource="#session.DSN#">
			select '-1' as value
				, '--Todas--' as description
		union 		
			Select '0' as value
				, 'En la Empresa' as description
		union
			Select 	
				 '1' as value
				, 'Agente Autorizado' as description								
		union
			Select
				 '2' as value
				, 'Asignado al Cliente' as description			
		order by value
	</cfquery>	

	<cfset imgRojo = "<img src=''/cfmx/saci/images/rojo.png'' border=''0'' title=''Nulo''>">
	<cfset imgAmarillo = "<img src=''/cfmx/saci/images/amarillo.png'' border=''0'' title=''Inactivo''>">					
	<cfset imgVerde = "<img src=''/cfmx/saci/images/verde.png'' border=''0'' title=''Activo''>">										

	<cfinvoke component="sif.Componentes.pListas" method="pLista"
		tabla="ISBsobres so
				left outer join ISBlogin lo
					on lo.LGnumero=so.LGnumero
				left outer join ISBagente ag
					on ag.AGid=so.AGid
				left outer join ISBpersona per
					on per.Pquien=ag.Pquien"
		columnas="	so.Snumero
				, case so.Sestado
					when '0' then '#imgAmarillo#'
					when '1' then '#imgVerde#'
					when '2' then '#imgRojo#'
				end Sestado
				, case so.Sestado
					when '0' then 2
					when '1' then 1
					when '2' then 3
				end orden
				, case so.Sdonde
					when '0' then 'En la Empresa'
					when '1' then 'Agente Autorizado'
					when '2' then 'Asignado al Cliente'	
				end Sdonde
				, lo.LGlogin
				, (per.Pnombre || ' ' || per.Papellido || ' ' || per.Papellido2) as nombreAgente
				, '#pagina#' as PageNum"
		filtro=" so.Ecodigo=#session.Ecodigo# 
				order by orden,so.Snumero"
		desplegar="Snumero,Sdonde,LGlogin,nombreAgente,Sestado"
		rsSestado="#rsSestado#"		
		rsSdonde="#rsSdonde#"
		etiquetas="Número,Ubicación,Login,Agente,Estado"
		formatos="I,S,S,S,S"
		align="left,left,left,left,center"
		ira="ISBsobres-edit.cfm"
		form_method="post"
		showLink="true"
		keys="Snumero"
		botones="Asignar_por_lote"
		maxRows="20"
		MaxRowsQuery="250"
		mostrar_filtro="yes"
		filtrar_por="so.Snumero,so.Sdonde,lo.LGlogin,(per.Pnombre || ' ' || per.Papellido || ' ' || per.Papellido2),so.Sestado"
		filtrar_automatico="yes"
	/>
	
<cf_web_portlet_end>
<cf_templatefooter>

<cfoutput>
	<script language="javascript" type="text/javascript">
		function funcAsignar_por_lote(){
			var params = "";
			<cfif isdefined("form.Pagina") and len(trim(form.Pagina))>
				params = params + "&Pagina=#form.Pagina#";
			</cfif>
			<cfif isdefined("form.filtro_Snumero") and len(trim(form.filtro_Snumero))>
				params = params + "&filtro_Snumero=#form.filtro_Snumero#";		
			</cfif>
			<cfif isdefined("form.filtro_Sdonde") and len(trim(form.filtro_Sdonde))>
				params = params + "&filtro_Sdonde=#form.filtro_Sdonde#";				
			</cfif>
			<cfif isdefined("form.filtro_LGlogin") and len(trim(form.filtro_LGlogin))>
				params = params + "&filtro_LGlogin=#form.filtro_LGlogin#";
			</cfif>
			<cfif isdefined("form.filtro_nombreAgente") and len(trim(form.filtro_nombreAgente))>
				params = params + "&filtro_nombreAgente=#form.filtro_nombreAgente#";		
			</cfif>
			<cfif isdefined("form.filtro_Sestado") and len(trim(form.filtro_Sestado))>
				params = params + "&filtro_Sestado=#form.filtro_Sestado#";				
			</cfif>		
			location.href='ISBsobresMasivo.cfm?1=1' + params;
			return false;
		}
	</script>
</cfoutput>