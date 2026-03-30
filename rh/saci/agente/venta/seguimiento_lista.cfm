<cfif Len(session.saci.agente.id) is 0 or session.saci.agente.id is 0>
  <cfthrow message="Usted no está registrado como agente autorizado, por favor verifíquelo.">
</cfif>

<cfset CurrentPage = GetFileFromPath(GetTemplatePath())>
<cfsavecontent variable="pNavegacion">
	<cfinclude template="/home/menu/pNavegacion.cfm">
</cfsavecontent>

<cf_templateheader title="#nav__SPdescripcion#">
	<cfoutput>#pNavegacion#</cfoutput>

	<cf_web_portlet_start titulo="<cfoutput>#nav__SPdescripcion#</cfoutput>">
		<table width="100%" border="0" cellpadding="0" cellspacing="0">
		  <tr>
			<td>
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
				<cfif isdefined("url.filtro_CTcondicion") and len(trim(url.filtro_CTcondicion)) and url.filtro_CTcondicion NEQ '-1'>
					<cfset form.filtro_CTcondicion= url.filtro_CTcondicion>
				</cfif>
				<cfif isdefined("url.FILTRO_CUECUE") and len(trim(url.FILTRO_CUECUE)) and url.FILTRO_CUECUE GT 0>
					<cfset form.FILTRO_CUECUE= url.FILTRO_CUECUE>
				</cfif>
				<cfif isdefined("url.FILTRO_DUENO") and len(trim(url.FILTRO_DUENO))>
					<cfset form.FILTRO_DUENO= url.FILTRO_DUENO>
				</cfif>
				<cfif isdefined("url.FILTRO_PQNOMBRE") and len(trim(url.FILTRO_PQNOMBRE))>
					<cfset form.FILTRO_PQNOMBRE= url.FILTRO_PQNOMBRE>
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
				
				<!---Filtros y navegacion--->
				<cfset filtro = "">		<cfset nav= "">
				<cfset del= "','">
				<cfif isdefined("form.filtro_CTcondicion") and len(trim(form.filtro_CTcondicion)) and form.filtro_CTcondicion NEQ '-1'>
					<cfset CTcondicion= ListChangeDelims(form.filtro_CTcondicion,'#del#',',')>
					<cfset filtro = filtro & " and c.CTcondicion in ('#CTcondicion#')">
					<cfset nav= "filtro_CTcondicion=#form.filtro_CTcondicion#">
				</cfif>
				<cfif isdefined("form.FILTRO_CUECUE") and len(trim(form.FILTRO_CUECUE)) and form.FILTRO_CUECUE GT 0>
					<cfset filtro = filtro & " and a.CUECUE = #form.FILTRO_CUECUE#"><!---and upper(rtrim(<cf_dbfunction name='to_char' args='a.CUECUE' datasource='#session.DSN#'>))--->
					<cfset nav= nav & IIF(len(trim(nav)),DE('&'),DE('')) & "FILTRO_CUECUE=#form.FILTRO_CUECUE#">
				</cfif>
				<cfif isdefined("form.FILTRO_DUENO") and len(trim(form.FILTRO_DUENO))>
					<cfset filtro = filtro & " and upper(rtrim(ltrim((b.Pid || '-' || rtrim(rtrim(b.Pnombre) || ' ' || rtrim(b.Papellido) || ' ' || b.Papellido2))))) like '%#ucase(trim(form.FILTRO_DUENO))#%'">
					<cfset nav= nav & IIF(len(trim(nav)),DE('&'),DE('')) & "FILTRO_DUENO=#form.FILTRO_DUENO#">
				</cfif>
				<cfif isdefined("form.FILTRO_PQNOMBRE") and len(trim(form.FILTRO_PQNOMBRE))>
					<cfset filtro = filtro & " and upper(rtrim(ltrim(PQnombre))) like '%#ucase(trim(form.FILTRO_PQNOMBRE))#%'">
					<cfset nav= nav & IIF(len(trim(nav)),DE('&'),DE('')) & "FILTRO_PQNOMBRE=#form.FILTRO_PQNOMBRE#">
				</cfif>
				
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
				
				<cfset imgRojo = "<img src=''/cfmx/saci/images/rojo.png'' border=''0'' title=''Rechazada''>">
				<cfset imgAmarillo = "<img src=''/cfmx/saci/images/amarillo.png'' border=''0'' title=''En Revisi&oacute;n''>">					
				<cfset imgVerde = "<img src=''/cfmx/saci/images/verde.png'' border=''0'' title=''Aprobada''>">										
				<cfset imgBorrar = "<img src=''/cfmx/saci/images/Borrar01_S.gif'' border=''0'' title=''Ocultar Cuenta''>">

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
													and d.AGid = #session.saci.agente.id#
													and d.Habilitado = 1
												inner join ISBpersona e
													on  e.Pquien = d.Pquien
												inner join ISBpaquete p
													on p.Ecodigo=e.Ecodigo
														and p.PQcodigo=c.PQcodigo"/>
					<cfinvokeargument name="columnas" value="
						distinct 
						 a.CTid
						, a.CTapertura
						, p.PQnombre
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
						end as CTcondicion		
						, c.Vid
						, c.Contratoid
						, e.Pquien as Pquien_Vend
						, e.Pid || '-' || rtrim(rtrim(e.Pnombre) || ' ' || rtrim(e.Papellido) || ' ' || e.Papellido2) as vendedor
						, '<a href=''javascript: noConsul(""' || convert(varchar, c.Contratoid) || '"");''>#imgBorrar#</a>' as ocultar
						, '-1' as quitar
						#preservesinglequotes(campos_extra)#"/>
					<cfinvokeargument name="desplegar" value="CUECUE,PQnombre,dueno,CTcondicion,ocultar"/>
					<cfinvokeargument name="etiquetas" value="Núm.Cuenta,Paquete,Propietario,Estado,Ocultar"/>
					<cfinvokeargument name="formatos" value="I,S,S,S,U"/>
					<cfinvokeargument name="filtro" value="b.Ecodigo = #session.Ecodigo# 
															and c.CNconsultar = 1
															#filtro#
															order by vendedor,CTapertura desc"/>
					<cfinvokeargument name="align" value="left,left,left,center,center"/>
					<cfinvokeargument name="ajustar" value="N"/>
					<cfinvokeargument name="irA" value="seguimiento.cfm"/>
					<cfinvokeargument name="conexion" value="#Session.DSN#"/>
					<cfinvokeargument name="keys" value="CTid"/>						
					<cfinvokeargument name="formname" value="lista"/>
					<cfinvokeargument name="Cortes" value="vendedor"/>
					<cfinvokeargument name="MaxRows" value="20"/>
					<cfinvokeargument name="rsCTcondicion" value="#rsCTcondicion#"/>
					<cfinvokeargument name="mostrar_filtro" value="true"/>
					<cfinvokeargument name="filtrar_automatico" value="false"/>
					<cfinvokeargument name="ajustar" value="N">
					<cfinvokeargument name="navegacion" value="#nav#">
					<!---<cfinvokeargument name="filtrar_por" value="a.CUECUE,PQnombre,(b.Pid || '-' || rtrim(rtrim(b.Pnombre) || ' ' || rtrim(b.Papellido) || ' ' || b.Papellido2)),c.CTcondicion, '', ''"/>--->
				</cfinvoke>
			</td>
		  </tr>
		</table>
	<cf_web_portlet_end>
<cf_templatefooter>


<script language="javascript" type="text/javascript">
	function noConsul(llave){
		if (confirm("Desea ocultar la venta ?")) {
			document.lista.action = "seguimiento-apply.cfm";
			document.lista.QUITAR.value = llave;
			document.lista.submit();
			return false;
		}
	}
</script>
