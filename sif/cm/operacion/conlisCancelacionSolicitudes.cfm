<cfif isdefined("url.fESnumero") and not isdefined("form.fESnumero")>
	<cfset form.fESnumero = url.fESnumero>
</cfif>
<cfif isdefined("url.fESobservacion") and not isdefined("form.fESobservacion")>
	<cfset form.fESobservacion = url.fESobservacion >
</cfif>
<cfif isdefined("url.fESfecha") and not isdefined("form.fESfecha")>
	<cfset form.fESfecha = url.fESfecha >
</cfif>
<cfif isdefined("url.fCMSnombre") and not isdefined("form.fCMSnombre")>
	<cfset form.fCMSnombre = url.fCMSnombre >
</cfif>
<cfif isdefined("url.formulario") and not isdefined("form.formulario")>
	<cfset form.formulario= url.formulario >
</cfif>
<cfif isdefined("url.admin") and not isdefined("form.admin")>
	<cfset form.admin= url.admin >
</cfif>

<script language="JavaScript" type="text/javascript">
	//La funcion recibe el ESnumero y ESobservacion
	function Asignar(id,descripcion){
		if (window.opener != null) {
			window.opener.document.<cfoutput>#form.formulario#</cfoutput>.fESnumero.value = id;
			window.opener.document.<cfoutput>#form.formulario#</cfoutput>.fESobservacion.value = descripcion;
			window.close();
		}
	}
</script>

<!---  Se asignan las variables que vienen por URL a FORM  ----->
<cfif isdefined("url.fESnumero") and not isdefined("form.fESnumero")>
	<cfparam name="form.fESnumero" default="#url.fESnumero#">
</cfif>
<cfif isdefined("url.fESobservacion") and not isdefined("Form.fESobservacion")>
	<cfparam name="form.fESobservacion" default="#url.fESobservacion#">
</cfif>
<cfif isdefined("url.fESfecha") and not isdefined("form.fESfecha")>
	<cfparam name="form.fESfecha" default="#url.fESfecha#">
</cfif>
<cfif isdefined("url.fCMSnombre") and not isdefined("Form.fCMSnombre")>
	<cfparam name="form.fCMSnombre" default="#url.fCMSnombre#">
</cfif>

<!---- Se establecen las variables de navegacion y filtros ----->
<cfset filtro = "">
<cfset navegacion = "">
<cfif isdefined("form.fESnumero") and Len(Trim(form.fESnumero)) NEQ 0>
	<cfset filtro = filtro & " and a.ESnumero >= " & #form.fESnumero# >
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "fESnumero=" & Form.fESnumero>
</cfif>
<cfif isdefined("form.fESobservacion") and Len(Trim(form.fESobservacion)) NEQ 0>
	<cfset filtro = filtro & " and upper(a.ESobservacion) like '%" & #UCase(form.fESobservacion)# & "%'">
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "fESobservacion=" & form.fESobservacion>
</cfif>
<cfif isdefined("form.fESfecha") and Len(Trim(form.fESfecha)) NEQ 0>
	<cfset filtro = filtro & " and a.ESfecha >= " & #LSParseDateTime(form.fESfecha)# >
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "fESfecha=" & form.fESfecha>
</cfif>
<cfif isdefined("form.fCMSnombre") and Len(Trim(form.fCMSnombre)) NEQ 0>
	<cfset filtro = filtro & " and upper(c.CMSnombre) like '%" & #UCase(form.fCMSnombre)# & "%'">
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "fCMSnombre=" & form.fCMSnombre>
</cfif>

<html>
<head>
<title></title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<cf_templatecss>
</head>
<body>

	<script language="javascript1.2" type="text/javascript" src="../../js/utilesMonto.js"></script>
	<cfoutput>
		<form name="fSolicitud" method="post" style="margin: 0">
			<table width="98%" border="0" cellpadding="2" cellspacing="0" class="areaFiltro">
				<tr>
					<td width="1%" align="right"><strong>N&uacute;mero</strong></td>
					<td> 
						<input name="fESnumero" type="text" id="name" size="10" maxlength="10" value="<cfif isdefined("form.fESnumero")>#form.fESnumero#</cfif>" onFocus="javascript:this.select();" >
					</td>
					<td width="1%" align="right"><strong>Descripción</strong></td>
					<td> 
						<input name="fESobservacion" type="text" id="name" size="34" maxlength="34" value="<cfif isdefined("form.fESobservacion")>#form.fESobservacion#</cfif>" onFocus="javascript:this.select();" >
					</td>
					<td width="1%" align="right"><strong>Fecha</strong></td>
					<td>
						<cfif isdefined("form.fESfecha")>
							<cf_sifcalendario conexion="#session.DSN#" form="fSolicitud" name="fESfecha" value="#form.fESfecha#">
						<cfelse>
							<cf_sifcalendario conexion="#session.DSN#" form="fSolicitud" name="fESfecha" value="">
						</cfif>
					</td>
					<td width="1%" align="right"><strong>Solicitante</strong></td>
					<td> 
						<input name="fCMSnombre" type="text" id="name" size="34" maxlength="34" value="<cfif isdefined("form.fCMSnombre")>#form.fCMSnombre#</cfif>" onFocus="javascript:this.select();" >
					</td>
					<td align="center">
						<input name="btnFiltrar" type="submit" id="btnFiltrar" value="Filtrar">
					</td>
				</tr>
			</table>
		</form>
	</cfoutput>
	
	<cfquery name="rsSolicitudes" datasource="#session.DSN#">
		select 	distinct a.ESidsolicitud, 
				a.Ecodigo, 
				a.ESnumero,
				a.ESobservacion, 
				a.ESfecha,
				c.CMSnombre
		from ESolicitudCompraCM a
			inner join DSolicitudCompraCM b
				on b.ESidsolicitud = a.ESidsolicitud
				and b.Ecodigo = a.Ecodigo
			left outer join CMSolicitantes c			
				on c.CMSid = a.CMSid
		where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
        <!---►►Solo puede Cancelar las solicitudes que el Usuario elaboro, si no es solicitante la consulta no muestra nada
			   UPDATE: Si el usuario es administrador, podra cancelar las solicitudes de otros usuario◄◄--->
        <cfif not isdefined("form.admin")>
			<cfif isdefined("session.compras.solicitante") and len(trim(session.compras.solicitante)) NEQ 0>
                and a.CMSid=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.compras.solicitante#">
            <cfelse>
                and 1 = 2
            </cfif>
        </cfif>
			and a.ESestado in (20,25,40)
			and a.ESidsolicitud not in (select DOrdenCM.ESidsolicitud 
										from DOrdenCM inner join EOrdenCM on DOrdenCM.EOidorden = EOrdenCM.EOidorden 
										where DOrdenCM.ESidsolicitud = a.ESidsolicitud 	and EOrdenCM.EOestado < 10)
			and a.ESidsolicitud not in (select CMLineasProceso.ESidsolicitud 
										from CMLineasProceso inner join CMProcesoCompra on CMProcesoCompra.CMPid = CMLineasProceso.CMPid 
										and (CMProcesoCompra.CMPestado < 50 OR 
                                        	 CMProcesoCompra.CMPestado = 79 OR <!---► 79 En Espera de ser aprobadas por el solicitante--->
                                             CMProcesoCompra.CMPestado = 81 OR <!---► 81 Aprobadas por el solicitante--->
                                        	 CMProcesoCompra.CMPestado = 83    <!---► 83 Canceladas por el solicitante--->
                                            )
                                        )
			and (b.DScant - b.DScantsurt) > 0
			#preservesinglequotes(filtro)#	
		order by a.ESnumero
	</cfquery>
	
	<cfinvoke component="sif.Componentes.pListas" method="pListaQuery" returnvariable="pListaRet"> 
			<cfinvokeargument name="query" 				value="#rsSolicitudes#"/> 
			<cfinvokeargument name="desplegar" 			value="ESnumero, ESobservacion, ESfecha, CMSnombre"/> 
			<cfinvokeargument name="etiquetas" 			value="Solicitud, Descripción, Fecha, Nombre"/> 
			<cfinvokeargument name="formatos" 			value="V,V,D,V"/> 
			<cfinvokeargument name="align" 				value="left,left,left,left"/> 
			<cfinvokeargument name="ajustar" 			value="N"/> 
			<cfinvokeargument name="checkboxes" 		value="N"/> 
			<cfinvokeargument name="irA" 				value="conlisTSolicitudesSolicitante.cfm"/> 
			<cfinvokeargument name="formname" 			value="listaSol"/> 
			<cfinvokeargument name="maxrows" 			value="15"/> 				
			<cfinvokeargument name="funcion" 			value="Asignar"/>
			<cfinvokeargument name="fparams" 			value="ESnumero, ESobservacion"/>
			<cfinvokeargument name="navegacion" 		value="#navegacion#"/>
			<cfinvokeargument name="showEmptyListMsg" 	value="yes"/>
	</cfinvoke> 

</body>
</html>