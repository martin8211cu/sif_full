<cfset LvarOBJ_PrecioU = createObject("Component","sif.Componentes.CM_PrecioU").init()>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title>Lista de Cotizaciones</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<script language="javascript" type="text/javascript" src="/cfmx/sif/js/utilesMonto.js"></script>
</head>

<body style="margin:0;">
	<cfset navegacion = "">
	<cffunction name="fnUrlToFormParam">
		<cfargument name="LprmNombre"  type="string" required="yes">
		<cfargument name="LprmDefault" type="string" required="yes">
		
		<cfparam name="url[LprmNombre]" default="#LprmDefault#">
		<cfparam name="form[LprmNombre]" default="#url[LprmNombre]#">
		<cfif isdefined("navegacion") and Len(Trim(Form[LprmNombre]))>
			<cfset navegacion = navegacion & Iif(len(trim(navegacion)), DE("&"), DE("")) & "#LprmNombre#=" & Form[LprmNombre]>
		</cfif>
	</cffunction>	
	
	<cfset fnUrlToFormParam ("CMPid", "")>
	<cfset fnUrlToFormParam ("ECid", "")>
	<cfset fnUrlToFormParam ("f", "")>
	<cfset fnUrlToFormParam ("p1", "")>
	<cfset fnUrlToFormParam ("p2", "")>
	<cfset fnUrlToFormParam ("p3", "")>
	<cfset fnUrlToFormParam ("p4", "")>
	<cfset fnUrlToFormParam ("p5", "")>
	<cfset fnUrlToFormParam ("p6", "")>
	<cfset fnUrlToFormParam ("p7", "")>
	<cfset fnUrlToFormParam ("p8", "")>
	<cfset fnUrlToFormParam ("p9", "")>
	<cfset fnUrlToFormParam ("p10", "")>
	<cfset fnUrlToFormParam ("p11", "")>
	<cfset fnUrlToFormParam ("p12", "")>

	<cfinclude template="../../Utiles/sifConcat.cfm">
	<cfquery name="rsCriterios" datasource="#Session.DSN#">
		select b.CCdesc, a.CPpeso
		from CMCondicionesProceso a, CCriteriosCM b
		where a.CMPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CMPid#">
		and a.CCid = b.CCid
		order by a.CCid
	</cfquery>	
	<!---- Consultar la cotización sugerida por el sistema --->
	<cfquery name="rsSugerida" datasource="#Session.DSN#">
		select distinct ECid
		from CMResultadoEval
		where CMPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CMPid#">
		and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
		and CMRsugerido = 1
	</cfquery>

	<cfif isdefined("Form.Asignar") and isdefined("Form.ECid") and Len(Trim(Form.ECid))>
		<!--- Datos de la Cotización Seleccionada --->
		<cfquery name="rsCotizacion" datasource="#Session.DSN#">
			select c.DSconsecutivo, 
				   b.DClinea,
				   d.SNnombre, 
				   case c.DStipo when 'A' then Adescripcion
				   when 'S' then Cdescripcion
				   when 'F' then g.ACdescripcion#_Cat#'/'#_Cat#h.ACdescripcion end as Descripcion,
				   rtrim(a.ECnumero) as ECnumero, 
				   b.DCcantidad,
				   a.ECfechacot,
				   i.Mnombre,
				   a.ECid,
				   c.DSlinea,
				   #LvarOBJ_PrecioU.enSQL_AS("b.DCpreciou")#, 
				   a.NotaGlobal,
				   a.NotaTotalLinea				    
			from CMResultadoEval a
				inner join DCotizacionesCM b
				on b.Ecodigo = #Session.Ecodigo#
				and a.DClinea = b.DClinea
				and a.ECid = b.ECid
			
				inner join DSolicitudCompraCM c
				on b.Ecodigo = c.Ecodigo
				and b.DSlinea = c.DSlinea
			
				inner join SNegocios d
				on d.Ecodigo = #Session.Ecodigo#
				and a.SNcodigo = d.SNcodigo
				
				inner join Monedas i
				on i.Ecodigo = #Session.Ecodigo#
				and a.Mcodigo = i.Mcodigo
			
				left outer join Articulos e
				on c.Ecodigo = e.Ecodigo
				and c.Aid = e.Aid
			
				left outer join Conceptos f
				on c.Ecodigo = f.Ecodigo
				and c.Cid = f.Cid
			
				left outer join ACategoria g
				on c.Ecodigo = g.Ecodigo
				and c.ACcodigo = g.ACcodigo
			
				left outer join AClasificacion h
				on c.Ecodigo = h.Ecodigo
				and c.ACcodigo = h.ACcodigo
				and c.ACid = h.ACid
			
				where a.ECid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.ECid#">
				and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
				and a.CMPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CMPid#">
				order by a.ECfechacot
		</cfquery>			
						
		<!--- Resetear el bit de seleccionado en los registros del proceso de compra actual --->
		<cfquery name="updSeleccionados" datasource="#Session.DSN#">
			update CMResultadoEval set
				CMRseleccionado = 0
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
			and CMPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CMPid#">
		</cfquery>
		<!--- Registrar los datos de la Cotización seleccionada --->
		<cfquery name="updResultadoEval" datasource="#Session.DSN#">
			update CMResultadoEval set
				CMRseleccionado = 1
			where ECid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.ECid#">
			and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
			and CMPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CMPid#">
		</cfquery>
		<!--- Si se selecciona una cotización diferente a la sugerida --->
		<cfif rsSugerida.ECid NEQ Form.ECid>
			<!--- Registrar los datos de la Cotización seleccionada --->
			<cfquery name="updResultadoEval" datasource="#Session.DSN#">
				update CMResultadoEval set
					CMCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Compras.Comprador#">,
					CMRfechamod = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
					CMRjustificacion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.CMRjustificacion#">
				where ECid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.ECid#">
				and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
				and CMPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CMPid#">
			</cfquery>
		</cfif>
	
		<script language="javascript" type="text/javascript">
			<cfoutput>
			window.opener.document.#Form.f#.#Form.p1#.value = '#rsCotizacion.ECid#';
			window.opener.document.#Form.f#.#Form.p2#.value = '#rsCotizacion.SNnombre#';
			window.opener.document.#Form.f#.#Form.p5#.value = '#rsCotizacion.ECnumero#';
			window.opener.document.#Form.f#.#Form.p8#.value = '#LsDateFormat(rsCotizacion.ECfechacot, 'dd/mm/yyyy')#';
			window.opener.document.#Form.f#.#Form.p9#.value = '#rsCotizacion.Mnombre#';
			window.opener.document.#Form.f#.#Form.p12#.value = '#LSNumberFormat(rsCotizacion.NotaGlobal, ',9.00')#';
			<cfloop query="rsCotizacion">
			window.opener.document.#Form.f#.#Form.p3#_#rsCotizacion.DSlinea#.value = '#rsCotizacion.DSconsecutivo#';
			window.opener.document.#Form.f#.#Form.p4#_#rsCotizacion.DSlinea#.value = '#rsCotizacion.Descripcion#';
			window.opener.document.#Form.f#.#Form.p6#_#rsCotizacion.DSlinea#.value = '#LSNumberFormat(rsCotizacion.DCcantidad, ',9.00')#';
			window.opener.document.#Form.f#.#Form.p10#_#rsCotizacion.DSlinea#.value = '#LvarOBJ_PrecioU.enCF_RPT(rsCotizacion.DCpreciou)#';
			window.opener.document.#Form.f#.#Form.p11#_#rsCotizacion.DSlinea#.value = '#LSNumberFormat(rsCotizacion.NotaTotalLinea, ',9.00')#';
			</cfloop>
			window.close();
			</cfoutput>
		</script>
		
	</cfif>
	
	<cfif not isdefined("Form.Asignar")>
		
		<cfquery name="rsLineasCotizacion" datasource="#Session.DSN#">
			select distinct a.ECid, b.SNnumero#_Cat#'-'#_Cat#b.SNnombre as SNnombre, rtrim(a.ECnumero) as ECnumero, 
				   a.ECfechacot, 
				   a.CMPid,
				   '#Form.f#' as f,
				   '#Form.p1#' as p1,
				   '#Form.p2#' as p2,
				   '#Form.p3#' as p3,
				   '#Form.p4#' as p4,
				   '#Form.p5#' as p5,
				   '#Form.p6#' as p6,
				   '#Form.p7#' as p7,
				   '#Form.p8#' as p8,
				   '#Form.p9#' as p9,
				   '#Form.p10#' as p10,
				   '#Form.p11#' as p11,
				   '#Form.p12#' as p12,
				   'Yes' as Asignar,
				   a.NotaGlobal,
				   i.Mnombre,
				   c.ECtotal
			from CMResultadoEval a
			
				inner join SNegocios b
				on b.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
				and a.SNcodigo = b.SNcodigo
				
				inner join Monedas i
				on i.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
				and a.Mcodigo = i.Mcodigo
				
				inner join ECotizacionesCM c
				on a.ECid = c.ECid
				
			where a.CMPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CMPid#">
			and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
			order by a.ECfechacot
		</cfquery>

		<script language="javascript" type="text/javascript">
			function funcAsignar(Cot, ProcCompra) {
				if (Cot != '<cfoutput>#rsSugerida.ECid#</cfoutput>' && document.form1.CMRjustificacion.value == '') {
					alert('Debe llenar la justificación para realizar el cambio');
					return false;
				}
				document.form1.ECID.value = Cot;
				document.form1.CMPID.value = ProcCompra;
				document.form1.P1.value = document.form1.P1_1.value;
				document.form1.P2.value = document.form1.P2_1.value;
				document.form1.P3.value = document.form1.P3_1.value;
				document.form1.P4.value = document.form1.P4_1.value;
				document.form1.P5.value = document.form1.P5_1.value;
				document.form1.P6.value = document.form1.P6_1.value;
				document.form1.P7.value = document.form1.P7_1.value;
				document.form1.P8.value = document.form1.P8_1.value;
				document.form1.P9.value = document.form1.P9_1.value;
				document.form1.P10.value = document.form1.P10_1.value;
				document.form1.P11.value = document.form1.P11_1.value;
				document.form1.P12.value = document.form1.P12_1.value;
				document.form1.F.value = document.form1.F_1.value;
				document.form1.submit();
			}
		</script>
	
		<table width="98%" border="0" cellspacing="0" cellpadding="0" align="center">
		  <tr>
			<td align="center" class="TituloAlterno"><strong>Lista de Cotizaciones</strong></td>
		  </tr>
		  <tr>
			<td align="center">
				<cfoutput>
				<form name="form1" method="post" action="#GetFileFromPath(GetTemplatePath())#">
					<table width="100%"  border="0" cellspacing="0" cellpadding="0" align="center">					  
						<tr>
							<td  align="center" class="areaFiltro">
							<table width="100%"  border="0" cellspacing="0" cellpadding="0">
							  <tr>
								<td width="50%" valign="top" style="border-right: 1px solid gray; ">
									<table width="100%"  border="0" cellspacing="0" cellpadding="2">
									  <tr align="center">
										<td colspan="2" style="border-bottom: 1px solid gray; "><strong>Proceso de Compra</strong></td>
									  </tr>
									  <tr>
										<td align="right" class="fileLabel">Proceso: </td>
										<td>
											<cfquery name="rsProceso" datasource="#Session.DSN#">
												select CMPdescripcion, CMPfechapublica 
												from CMProcesoCompra
												where CMPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CMPid#">
											</cfquery>
											#rsProceso.CMPdescripcion#											
										</td>
									  </tr>
									  <tr>
										<td width="30%" align="right" class="fileLabel">Fecha Pub.:</td>
										<td>#LSDateFormat(rsProceso.CMPfechapublica,'dd/mm/yyyy')#</td>
									  </tr>									  
									</table>		
								</td>
								<td valign="top">
									<table width="100%"  border="0" cellspacing="0" cellpadding="2">
									  <tr align="center">
										<td colspan="2" style="border-bottom: 1px solid gray; "><strong>Criterios de Compra</strong></td>
									  </tr>
									  <cfloop query="rsCriterios">
									  <tr>
										<td width="30%" align="right" class="fileLabel">#rsCriterios.CCdesc#:</td>
										<td>#LSNumberFormat(rsCriterios.CPpeso, '9.00')#</td>
									  </tr>
									  </cfloop>
									</table>
								</td>
							  </tr>
							</table>
						</td>
					</tr>			
					  <tr>
						<td nowrap><strong>Justificaci&oacute;n:</strong>&nbsp;
							<input type="text" name="CMRjustificacion" style="width: 85%">
						</td>
					  </tr>
					  <tr>
						<td>
							<cfinvoke 
							 component="sif.Componentes.pListas"
							 method="pListaQuery"
							 returnvariable="pListaRet">
								<cfinvokeargument name="query" value="#rsLineasCotizacion#"/>
								<cfinvokeargument name="desplegar" value="ECnumero, SNnombre, ECfechacot, Mnombre, ECtotal, NotaGlobal"/><!---, NotaGarantia, NotaPrecio, NotaTiempoEnt, NotaPlazoCred, NotaGlobal"/>---->
								<cfinvokeargument name="etiquetas" value="Num. Cotizaci&oacute;n, Proveedor, Fecha Cotizaci&oacute;n, Moneda, Total, Nota Global"/><!---, Garant&iacute;a, Precio, Tiempo Ent., Plazo Cr&eacute;dito, Nota Global"/>--->
								<cfinvokeargument name="formatos" value="V, V, D, V, M, V"/><!---, N, V, V, V, M "/>--->
								<cfinvokeargument name="align" value="left, left, center, left, right, left"/><!---, left, left, left, left, right"/>--->
								<cfinvokeargument name="ajustar" value=""/>
								<cfinvokeargument name="irA" value="#GetFileFromPath(GetTemplatePath())#"/>
								<cfinvokeargument name="funcion" value="funcAsignar"/>
								<cfinvokeargument name="fparams" value="ECid, CMPid"/>
								<cfinvokeargument name="formName" value="form1"/>
								<cfinvokeargument name="incluyeForm" value="false"/>
								<cfinvokeargument name="MaxRows" value="20"/>
								<cfinvokeargument name="navegacion" value="#navegacion#"/>
								<cfinvokeargument name="showEmptyListMsg" value="true"/>
								<cfinvokeargument name="EmptyListMsg" value="--- No hay Cotizaciones ---"/>
							</cfinvoke>
						</td>
					  </tr>
					</table>
				</form>
				</cfoutput>
			</td>
		  </tr>
		</table>
	</cfif>

</body>
</html>
