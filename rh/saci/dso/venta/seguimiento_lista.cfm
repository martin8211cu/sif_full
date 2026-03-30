<cfset CurrentPage = GetFileFromPath(GetTemplatePath())>

<cfsavecontent variable="pNavegacion">
	<cfinclude template="/home/menu/pNavegacion.cfm">
</cfsavecontent>

<cf_templateheader title="#nav__SPdescripcion#">
	<cfoutput>#pNavegacion#</cfoutput>
	<cf_web_portlet_start titulo="<cfoutput>#nav__SPdescripcion#</cfoutput>">
	
		<!--- VARIABLE DE PAGINA PARA CUANDO VIENE DEL CLICK EN LA LISTA --->
		<cfif isdefined("form.PageNum") and len(trim(form.PageNum))>
			<cfset form.Pagina = form.PageNum>
		</cfif>
		<!--- VARIABLE DE PAGINA PARA CUANDO VIENE DEL SQL--->
		<cfif isdefined("url.Pagina") and len(trim(url.Pagina))>
			<cfset form.Pagina = url.Pagina>
		</cfif>
		<!--- VARIABLE DE PAGINA PARA CUANDO VIENE DEL CLICK EN LA NAVEGACION--->
		<cfif isdefined("url.PageNum_Lista") and len(trim(url.PageNum_Lista))>
			<cfset form.Pagina = url.PageNum_Lista>
			<cfset form.CTid = 0>
		</cfif>
		<cfif isdefined("url.AGidp_Agente") and len(trim(url.AGidp_Agente))>
			<cfset form.AGidp_Agente = url.AGidp_Agente>
		</cfif>
		<cfif isdefined("url.filtro_CTcondicion") and len(trim(url.filtro_CTcondicion)) and url.filtro_CTcondicion NEQ '-1'>
			<cfset form.filtro_CTcondicion= url.filtro_CTcondicion>
		</cfif>
		<cfif isdefined("url.FILTRO_CUECUE") and len(trim(url.FILTRO_CUECUE)) and url.FILTRO_CUECUE GT 0>
			<cfset form.FILTRO_CUECUE= url.FILTRO_CUECUE>
		</cfif>
		<cfif isdefined("url.FILTRO_DUENO") and len(trim(url.FILTRO_DUENO))>
			<cfset form.FILTRO_DUENO= url.FILTRO_DUENO>
		</cfif>
		<cfif isdefined("url.FILTRO_VENDEDOR") and len(trim(url.FILTRO_VENDEDOR))>
			<cfset form.FILTRO_VENDEDOR= url.FILTRO_VENDEDOR>
		</cfif>		
		<!--- VARIABLE DE PAGINA PARA CUANDO VIENE DEL CLICK EN LA LISTA --->
		<cfif isdefined("form.PageNum") and len(trim(form.PageNum))>
			<cfset form.Pagina = form.PageNum>
		</cfif>
		<cfset campos_extra = '' >
		<cfif isdefined("form.Pagina")>
			<cfset campos_extra = ",'#form.Pagina#' as Pagina" >
		</cfif>				
		<!--- VALORES POR DEFECTO DE LAS VARIBLES REQUERIDAS PORQUE SIEMPRE SE USAN--->
		<cfparam name="form.Pagina" default="1">					
		
		<cfif len(trim(form.Pagina)) eq 0>
			<!--- CUANDO LE DAN CLICK AL FILTRAR EXISTE EL CAMPO PAGINA EN EL FORM PERO ESTÁ VACÍO PORQQUE EL CAMPO SE LLENA CUAND LE DAN CLICK A LA LISTA Y NO LE DIERON CLIK --->
			<cfset form.Pagina = 1>
		</cfif>	
		<cfparam name="form.AGidp_Agente" default="#session.saci.agente.id#">

	
		<cfset imgRojo = "<img src=''/cfmx/saci/images/rojo.png'' border=''0'' title=''Rechazada''>">
		<cfset imgAmarillo = "<img src=''/cfmx/saci/images/amarillo.png'' border=''0'' title=''En Revisi&oacute;n''>">					
		<cfset imgVerde = "<img src=''/cfmx/saci/images/verde.png'' border=''0'' title=''Aprobada''>">										
		<cfset imgBorrar = "<img src=''/cfmx/saci/images/Borrar01_S.gif'' border=''0'' title=''Ocultar Cuenta''>">	
		
		<cfset ffiltro = "">
		<cfset f_nuevo = false>		
		<cfset navegacion = "">
		<cfoutput>
			<cfif isdefined("form.AGidp_Agente") and len(trim(form.AGidp_Agente))>
				<cfset ffiltro = ffiltro & " and d.AGid = " & form.AGidp_Agente>
				<cfset navegacion = navegacion & "&AGidp_Agente=#trim(form.AGidp_Agente)#">
			</cfif>
	
 			<cfif isdefined('form.AGidp_Agente') and form.AGidp_Agente NEQ ''
				and isdefined('form.hAGidp_Agente') and form.hAGidp_Agente NEQ ''
				and form.AGidp_Agente NEQ form.hAGidp_Agente>
					<cfset f_nuevo = true>
			</cfif>
			
			<cfset del= "','">
			<cfif isdefined("form.filtro_CTcondicion") and len(trim(form.filtro_CTcondicion)) and form.filtro_CTcondicion NEQ '-1'>
				<cfset CTcondicion= ListChangeDelims(form.filtro_CTcondicion,'#del#',',')>
				<cfset ffiltro = ffiltro & " and c.CTcondicion in ('#CTcondicion#')">
				<cfset navegacion= navegacion & IIF(len(trim(navegacion)),DE('&'),DE('')) &"filtro_CTcondicion=#form.filtro_CTcondicion#">
			</cfif>
			<cfif isdefined("form.FILTRO_CUECUE") and len(trim(form.FILTRO_CUECUE)) and form.FILTRO_CUECUE GT 0>
				<cfset ffiltro = ffiltro & " and a.CUECUE = #form.FILTRO_CUECUE#"><!---and upper(rtrim(<cf_dbfunction name='to_char' args='a.CUECUE' datasource='#session.DSN#'>))--->
				<cfset navegacion= navegacion & IIF(len(trim(navegacion)),DE('&'),DE('')) & "FILTRO_CUECUE=#form.FILTRO_CUECUE#">
			</cfif>
			<cfif isdefined("form.FILTRO_DUENO") and len(trim(form.FILTRO_DUENO))>
				<cfset ffiltro = ffiltro & " and upper(rtrim(ltrim((b.Pid || '-' || rtrim(rtrim(b.Pnombre) || ' ' || rtrim(b.Papellido) || ' ' || b.Papellido2))))) like '%#ucase(trim(form.FILTRO_DUENO))#%'">
				<cfset navegacion= navegacion & IIF(len(trim(navegacion)),DE('&'),DE('')) & "FILTRO_DUENO=#form.FILTRO_DUENO#">
			</cfif>
			<cfif isdefined("form.FILTRO_VENDEDOR") and len(trim(form.FILTRO_VENDEDOR))>
				<cfset ffiltro = ffiltro & " and upper(rtrim(ltrim(e.Pid || '-' || e.Pnombre || ' ' || e.Papellido || ' ' || e.Papellido2))) like '%#ucase(trim(form.FILTRO_VENDEDOR))#%'">
				<cfset navegacion= navegacion & IIF(len(trim(navegacion)),DE('&'),DE('')) & "FILTRO_VENDEDOR=#form.FILTRO_VENDEDOR#">
			</cfif>
		</cfoutput>		

		<form name="listaSegui" action="seguimiento_apply.cfm" method="post" style="margin:0;">
			<table width="100%" border="0" cellpadding="0" cellspacing="0">
			  <tr>
				<td nowrap>
					<table width="100%"  border="0" cellspacing="0" cellpadding="0">
					  <tr>
						<td width="8%" align="right"><label>Agente:</label></td>
						<td width="92%">	
							<cfset llaveAgente = "">
							<cfif isdefined('form.AGidp_Agente') and form.AGidp_Agente NEQ ''>
								<cfset llaveAgente = form.AGidp_Agente>
							</cfif>
							
							<cf_agenteId form="listaSegui" sufijo="_Agente" id_agente="#llaveAgente#">
						</td>
					  </tr>
					</table>
					<hr>
				</td>
			  </tr>		
			  <tr>
				<td>
					<cfquery name="rsCTcondicion" datasource="#session.DSN#">
						select '-1' as value 
								, '--Todas--' as description, 0 as ord
						union 		
							Select '0' as value
								, 'En revisión' as description, 1 as ord
						union
							Select 	
								 '1,2,3,4' as value
								, 'Aprobada' as description	, 2 as ord							
						union
							Select
								 'X' as value
								, 'Rechazada' as description, 3 as ord
						order by ord
					</cfquery>
					
					<cfinvoke 
					 component="sif.Componentes.pListas"
					 method="pListaRH"
					 returnvariable="pListaRet">
						<cfinvokeargument name="tabla" value="
												ISBcuenta a
												inner join ISBpersona b
													on  b.Pquien = a.Pquien
												inner join ISBproducto c
													on  c.CTid = a.CTid
													and c.CTcondicion not in ('C')
												inner join ISBvendedor d
													on  d.Vid = c.Vid
												inner join ISBpersona e
													on  e.Pquien = d.Pquien"/>
						<cfinvokeargument name="columnas" value="
							distinct 
							 a.CTid
							 , c.Contratoid
							, (case a.CTtipoUso 
									when 'A' then '(Acceso Agente) ' 
									when 'F' then '(Facturacion Agente) ' 
								else '' 
								end) || (	case a.CUECUE 
												when 0 then 'Por Asignar' 
											else 
												convert(varchar,a.CUECUE) 
											end) as CUECUE 
							, b.Pquien
							, b.Pid || '-' || rtrim(rtrim(b.Pnombre) || ' ' || rtrim(b.Papellido) || ' ' || b.Papellido2) as dueno
							, 1 as paso
							, case c.CTcondicion
								when '0' then '#imgAmarillo#'
								when '1' then '#imgVerde#'
								when 'X' then  '#imgRojo#'
								when '2' then  '#imgVerde#' 
								when '3' then  '#imgVerde#'
								when '4' then  '#imgVerde#'								
							end CTcondicion							
							, c.Vid
							, e.Pquien as Pquien_Vend
							, e.Pid || '-' || rtrim(rtrim(e.Pnombre) || ' ' || rtrim(e.Papellido) || ' ' || e.Papellido2) as vendedor
							, '<a href=''##'' onclick=''javascript: noConsul(""' || convert(varchar, c.Contratoid) || '"");''>#imgBorrar#</a>' as ocultar
							, '-1' as quitar
							, ('Semana:' || convert(varchar,datepart(week,CTapertura)) || ' Ano: ' || convert(varchar,datepart(yy,CTapertura))) as semana
							#preservesinglequotes(campos_extra)#"/>
						<cfinvokeargument name="desplegar" value="CUECUE,dueno,vendedor,CTcondicion,ocultar"/>
						<cfinvokeargument name="etiquetas" value="Núm.Cuenta,Propietario,Vendedor,Estado, Ocultar"/>
						<cfinvokeargument name="formatos" value="I,S,S,S,U"/>
						<cfinvokeargument name="filtro" value="b.Ecodigo = #session.Ecodigo# 
																and c.CNconsultar = 1
																#ffiltro#
																order by a.CTapertura desc"/>
						<cfinvokeargument name="align" value="left,left,left,center,center"/>
						<cfinvokeargument name="ajustar" value="N"/>
						<cfinvokeargument name="irA" value="seguimientoDso.cfm"/>
						<cfinvokeargument name="conexion" value="#Session.DSN#"/>
						<cfinvokeargument name="keys" value="CTid"/>						
						<cfinvokeargument name="formname" value="listaSegui"/>
						<cfinvokeargument name="MaxRows" value="20"/>						
						<cfinvokeargument name="Cortes" value="semana"/>
						<cfinvokeargument name="mostrar_filtro" value="true"/>
						<cfinvokeargument name="filtrar_automatico" value="false"/>
						<!---<cfinvokeargument name="filtrar_por" value="a.CUECUE,(b.Pid || '-' || rtrim(rtrim(b.Pnombre) || ' ' || rtrim(b.Papellido) || ' ' || b.Papellido2)),(e.Pid || '-' || rtrim(rtrim(e.Pnombre) || ' ' || rtrim(e.Papellido) || ' ' || e.Papellido2)), '', ''"/>--->
						<cfinvokeargument name="incluyeForm" value="false"/>
						<cfinvokeargument name="filtro_nuevo" value="#f_nuevo#"/>
						<cfinvokeargument name="rsCTcondicion" value="#rsCTcondicion#"/>	
						<cfinvokeargument name="navegacion" value="#navegacion#"/>
					</cfinvoke>
				</td>
			  </tr>
			</table>
		</form>
	<cf_web_portlet_end> 
<cf_templatefooter>


<script language="javascript" type="text/javascript">
	function noConsul(llave){
		if (confirm("Desea ocultar la venta ?")) {
			document.listaSegui.action = "seguimiento-apply.cfm";			
			document.listaSegui.QUITAR.value = llave;
			document.forms["listaSegui"].nosubmit=true;
			document.listaSegui.submit();
		}else{
			document.forms["listaSegui"].nosubmit=true;
		}
		
		return false;		
	}
</script>