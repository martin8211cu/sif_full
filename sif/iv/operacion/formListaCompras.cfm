<style type="text/css">
	a.label:link { color: #FFFFFF; font-weight: bold; text-decoration: none; }
	a.label:visited { color: #FFFFFF; text-decoration: none; }
	a.label:hover { color: #FFFFFF; text-decoration: underline; }
	a.label:active { color: #FFFFFF; text-decoration: underline; }
	
	.listaTitulo {  background-color: #CDCDCD; vertical-align: middle; text-indent: 10px}
	.listaAlmacen {  background-color: #F4F4F4; vertical-align: middle; text-indent: 20px}
	
	.lNon {  text-indent: 30px; vertical-align: middle}
	.lPar {  background-color: #FAFAFA; vertical-align: middle; text-indent: 30px}
	.letra {  color: #FF0000; }
}
</style>

<script language="JavaScript1.2" src="../../js/utilesMonto.js"></script>
<script language="JavaScript1.2" type="text/javascript">

	function limpiar(){
		document.lista.fAlm_Aid.value       = "";
		document.lista.fESnumero.value      = "";
		document.lista.fDSdescripcion.value = "";
		document.lista.fESfecha.value       = "";
	}

	function filtrar( ){
		document.lista.action = '';
		//document.lista.fDScant.value = qf(document.lista.fDScant)
		document.lista.submit();
	}
	
	function orden( campo ){
		var orden = 'desc'	
		if ( campo == document.lista.campo.value ){
			orden = ( document.lista.orden.value == 'asc' ) ? 'desc' : 'asc';
		}
		else{
			document.lista.campo.value = campo;	
			orden = 'asc';
		}
		document.lista.orden.value = orden;
		document.lista.action = "";
		document.lista.submit();
	}
	
	function procesar(valor){
		var linea = eval('document.lista.DSlinea_' + valor + '.value');
		document.lista.DSlinea.value = linea;
		document.lista.submit();						
	}
</script>

<cffunction name="existencia" access="public" returntype="numeric">
	<!--- RESULTADO --->
	<!---  Devuelve los datos necesarios para insertar en encabezados y detalles --->
	<cfargument name="Aid"     type="numeric" required="true" default="">
	<cfargument name="Alm_Aid" type="String" required="false" default="">

	<cfquery name="rsExistencia" datasource="#session.DSN#">
		select coalesce(sum(Eexistencia), 0) as existencia
		from Existencias a
			inner join Articulos b
				on a.Aid     = b.Aid
		       and a.Ecodigo = b.Ecodigo
			inner join Almacen c
				on a.Alm_Aid = c.Aid
		       and a.Ecodigo = c.Ecodigo
		where a.Ecodigo= #session.Ecodigo# 
		  and a.Aid=#Aid#
		<cfif isdefined("Alm_Aid") and len(trim(Alm_Aid)) gt 0 >
			and a.Alm_Aid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Alm_Aid#">
		</cfif>
	</cfquery>

	<cfreturn #rsExistencia.existencia#>
</cffunction>

<!---  Creacion del filtro --->
<cfset filtro = "">

<cfif isdefined("form.fESnumero") AND #form.fESnumero# NEQ '' >
	<cfset filtro = filtro & " and a.ESnumero = " & #form.fESnumero#  >
</cfif>

<cfif isdefined("form.fAlm_Aid") AND #form.fAlm_Aid# NEQ '' >
	<cfset filtro = filtro & " and b.Alm_Aid = " & form.fAlm_Aid  >
</cfif>

<cfif isdefined("form.fDSdescripcion") AND #form.fDSdescripcion# NEQ '' >
	<cfset filtro = filtro & " and upper(b.DSdescripcion) like upper('%" & form.fDSdescripcion & "%')" >
</cfif>

<cfif isdefined("form.fDScant") AND #form.fDScant# NEQ '' >
	<cfset filtro = filtro & " and b.DScant = " & #form.fDScant#  >
</cfif>
<cfif isdefined("form.fESfecha") AND #form.fESfecha# NEQ '' >
    <cf_dbfunction name="to_date"	args="'#form.fESfecha#'" returnvariable="fESfecha">
	<cfset filtro = filtro & " and a.ESfecha = #PreserveSingleQuotes(fESfecha)#" >
</cfif>

<!---  Creacion del Orden --->
<cfif isdefined("form.orden") and isdefined("form.campo") and #len(trim(form.orden))# gt 0 and #len(trim(form.campo))# gt 0 >
	<cfset order = " order by #form.campo# " & "#form.orden# " >
</cfif>

<!--- datos para la lista. Apartir de esta consulta se generan queries de quieries para pintar la lista --->
<cfquery name="rsfAlmacen" datasource="#session.DSN#">
	select 
	distinct b.Alm_Aid, 
	c.Bdescripcion
	from ESolicitudCompraCM a
		inner join DSolicitudCompraCM b
		    on a.ESidsolicitud=b.ESidsolicitud
		inner join Almacen c
			on b.Alm_Aid=c.Aid
	  	   and b.Ecodigo=c.Ecodigo
	where 
	  a.Ecodigo= #session.Ecodigo# 
	  and a.CMTScodigo='A' <!---b.CMTScodigo--->
	  order by c.Bdescripcion asc
</cfquery>

<cfinvoke component="sif.Componentes.solicitudes_compra" method="solicitud_compra" returnvariable="rsLista">
	<cfinvokeargument name="Ecodigo" value="#session.Ecodigo#"/>
	<cfinvokeargument name="Alm_Aid" value="#rsfAlmacen.Alm_Aid#"/>
	<cfinvokeargument name="debug"   value="N"/>							
</cfinvoke>

<!--- Combo de Almacen. Se hizo esta consulta aparte, pues si algo viene en el filtro, tira menos almacenes, segun el filtro --->

<table width="100%"  border="0" cellpadding="0" cellspacing="0" >
	<tr> 
		<td colspan="2"><cfinclude template="../../portlets/pNavegacionIV.cfm"></td>
	</tr>

	<tr>
		<td>
			<form style="margin: 0" action="SQLProcesarLineas.cfm" method="post" name="lista">
				<table width="100%" border="0" cellspacing="0">
					<tr>
						<td colspan="6">
							<table class="areaFiltro" width="100%">
								<tr>
									<td nowrap>Almac&eacute;n:</td>
									<td nowrap>Solicitud:</td>
									<td nowrap>Art&iacute;culo:</td>
									<td nowrap>Fecha:</td>
								</tr>	
								<tr>
									<td nowrap>
										<select name="fAlm_Aid">
											<option value=""></option>
											<cfoutput query="rsfAlmacen">
												<cfif isdefined("form.fAlm_Aid") and len(trim("form.fAlm_Aid")) gt 0 and  rsfAlmacen.Alm_Aid eq form.fAlm_Aid >
													<option value="#rsfAlmacen.Alm_Aid#" selected>#rsfAlmacen.Bdescripcion#</option>
												<cfelse>
													<option value="#rsfAlmacen.Alm_Aid#">#rsfAlmacen.Bdescripcion#</option>
												</cfif>	
											</cfoutput>
										</select>
									</td>
									
									<cfoutput>
									<td nowrap bordercolor="##EAEAEA"><input type="text" name="fESnumero"  value="<cfif isdefined("form.fESnumero") and len(trim("form.fESnumero")) gt 0 >#form.fESnumero#</cfif>" size="10" maxlength="10" style="text-align: right;" onblur="javascript:fm(this,0); "  onfocus="javascript:this.value=qf(this); this.select();"  onkeyup="javascript:if(snumber(this,event,0)){ if(Key(event)=='13') {this.blur();}}" ></td>
									<td nowrap><input type="text" name="fDSdescripcion"  value="<cfif isdefined("form.fDSdescripcion") and len(trim("form.fDSdescripcion")) gt 0 >#form.fDSdescripcion#</cfif>" size="40" maxlength="80"></td>

									<cfif isdefined("form.fESfecha") and len(trim("form.fESfecha")) gt 0 >
										<cfset fecha = form.fESfecha >
									<cfelse>
										<cfset fecha = "" >
									</cfif>
									<td nowrap><cf_sifcalendario Conexion="#session.DSN#" form="lista" name="fESfecha" value="#fecha#" ></td>
									<td nowrap>
										<input type="button" name="btnLimpiar" value="Limpiar" onClick="javascript:limpiar();">
										<input type="submit" name="btnFiltrar" value="Filtrar" onClick="javascript:filtrar();">
									</td>
									</cfoutput>
								</tr>
							</table>
						</td>	
					</tr>	
					<tr>
						<td class="tituloListas" width="1%">&nbsp;</td>
						<td class="tituloListas">Art&iacute;culo</td>
						<td class="tituloListas">Cant. Solicitada</td>
						<td class="tituloListas">Cant. Almac&eacute;n</td>						
						<td class="tituloListas">Cant. Inventario</td>
						<td class="tituloListas">Fecha</td>
					</tr>

					<!--- Corte por Solicitud--->
					<cfquery name="rsSolicitud" dbtype="query">
						select distinct ESolicitud, ESobservacion
						from rsLista
						order by ESnumero
					</cfquery>
					
					<cfoutput>
						<cfloop query="rsSolicitud">	
							<cfset solicitud = #rsSolicitud.ESolicitud# >

							<cfquery name="rsNSolicitud" dbtype="query">
								select ESnumero from rsLista where ESolicitud = '#trim(solicitud)#'
							</cfquery>
							
							<tr>
								<td class="listaTitulo"><b>N&uacute;mero:&nbsp;#rsNSolicitud.ESnumero#</b></td>
								<td colspan="5" class="listaTitulo"><b>- #rsSolicitud.ESobservacion#</b></td>
							</tr>
						
							<!--- Cortes por Almacen --->	
							<cfquery name="rsAlmacen" dbtype="query">
								select distinct Alm_Aid, Bdescripcion
								from rsLista
								where ESolicitud='#trim(solicitud)#'
								order by Bdescripcion
							</cfquery>
							
							<cfloop query="rsAlmacen">
								<tr>
									<td colspan="6" class="listaAlmacen"><b>#rsAlmacen.Bdescripcion#</b></td>
								</tr>

								<cfquery name="rsLineas" dbtype="query">
									select  ESolicitud, DSlinea, ESnumero, DSdescripcion, Alm_Aid, Aid, DScant, ESfecha
									from rsLista
									where ESolicitud = '#trim(solicitud)#'
									  and Alm_Aid = '#trim(rsAlmacen.Alm_Aid)#'
									order by ESnumero
								</cfquery>

								<cfloop query="rsLineas">
									<cfset global  = existencia(rsLineas.Aid, '') >
									<cfset almacen = existencia(rsLineas.Aid, rsLineas.Alm_Aid) >
								
									<tr class=<cfif rsLineas.CurrentRow MOD 2>"lNon"<cfelse>"lPar"</cfif> onmouseover="style.backgroundColor='##E4E8F3';" onmouseout="style.backgroundColor='<cfif rsLineas.CurrentRow MOD 2>##FFFFFF<cfelse>##FAFAFA</cfif>';">
										<td><input type="checkbox" name="chk" value="#rsLineas.DSlinea#|#rsLineas.DScant#"></td>
										<td nowrap <cfif global lt rsLineas.DScant>class="letra"</cfif> >#Mid(rsLineas.DSdescripcion, 1, 50)#<cfif len(rsLineas.DSdescripcion) gt 50 >...</cfif></td>
										<td <cfif global lt rsLineas.DScant >class="letra"</cfif> >#LSCurrencyFormat(rsLineas.DScant, 'none')#</td>
										<td <cfif global lt rsLineas.DScant >class="letra"</cfif> >#LSCurrencyFormat(almacen, 'none')#</td>
										<td <cfif global lt rsLineas.DScant >class="letra"</cfif> >#LSCurrencyFormat(global, 'none')#</td>
										<td <cfif global lt rsLineas.DScant >class="letra"</cfif> >#rsLineas.ESfecha#</td>
									</tr>
								</cfloop> <!--- rsSolicitudes --->
							</cfloop> <!--- rsAlmacen--->
						</cfloop> <!--- rsSolicitud--->
					</cfoutput>
					<tr>
						<td colspan="6" nowrap align="center">
						  <input type="submit" name="btnAplicar" value="Procesar" onClick="javascript: if ( confirm('Desea aplicar las líneas seleccionadas?') ){ return true; }else{ return false; }" >
						</td>
					</tr>
					<tr><td colspan="6"><input type="hidden" name="DSlinea" value=""></td></tr>
					<tr><td colspan="6"><input name="campo" type="hidden" value="<cfif isdefined("form.campo")><cfoutput>#form.campo#</cfoutput><cfelse>ESnumero</cfif>"></td></tr>
					<tr><td colspan="6"><input name="orden" type="hidden" value="<cfif isdefined("form.orden")><cfoutput>#form.orden#</cfoutput><cfelse>asc</cfif>"></td></tr>
			  </table>
			</form>
		</td>
	</tr>
</table>