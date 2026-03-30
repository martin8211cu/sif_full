<cfparam name="lvarSolicitante" default="false">
<cfset LvarOBJ_PrecioU = createObject("Component","sif.Componentes.CM_PrecioU").init()>
<cfinclude template="../../Utiles/sifConcat.cfm">
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title>Lista de Líneas de Cotización</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<script language="javascript" type="text/javascript" src="/cfmx/sif/js/utilesMonto.js"></script>
<cf_templatecss>
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

	<cfset fnUrlToFormParam ("DSlinea", "")>
	<cfset fnUrlToFormParam ("DClinea", "")>
	<cfset fnUrlToFormParam ("CMPid", "")>
	<cfset fnUrlToFormParam ("f", "")>
	<cfset fnUrlToFormParam ("p1", "")>
	<cfset fnUrlToFormParam ("p2", "")>
    <cfif not lvarSolicitante>
		<cfset fnUrlToFormParam ("p3", "")>
    </cfif>
	<cfset fnUrlToFormParam ("p4", "")>
	<cfset fnUrlToFormParam ("p5", "")>
	<cfset fnUrlToFormParam ("p6", "")>
	<cfset fnUrlToFormParam ("p7", "")>
	<cfset fnUrlToFormParam ("p8", "")>
	<cfset fnUrlToFormParam ("p9", "")>
	<cfset fnUrlToFormParam ("p10", "")>
	<cfset fnUrlToFormParam ("p11", "")>
	<cfset fnUrlToFormParam ("p12", "")>
	<cfset fnUrlToFormParam ("p13", "")>
    <cfset fnUrlToFormParam ("Ecodigo", "#session.Ecodigo#")>

	<cfquery name="rsSugerida" datasource="#Session.DSN#">
		select DClinea
		from CMResultadoEval
		where CMPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CMPid#">
		and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.Ecodigo#">
		and DSlinea = <cfqueryparam cfsqltype="cf_sql_integer" value="#Form.DSlinea#">
		and CMRsugerido = 1
	</cfquery>

	<cfquery name="rsSeleccionado" datasource="#Session.DSN#">
		select DClinea
		from CMResultadoEval
		where CMPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CMPid#">
		and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.Ecodigo#">
		and DSlinea = <cfqueryparam cfsqltype="cf_sql_integer" value="#Form.DSlinea#">
		and CMRseleccionado = 1
	</cfquery>

	<cfif isdefined("Form.btnSeleccionar") and isdefined("Form.chk") and Len(Trim(Form.chk))>
		<cfset DatosLinea = ListToArray(Form.chk, '|')>
		<!---<cf_dump var="#DatosLinea#">--->
		<!--- Resetear el bit de seleccionado en los registros del proceso de compra actual --->
		<cfquery name="updSeleccionados" datasource="#Session.DSN#">
			update CMResultadoEval set
				CMRseleccionado = 0,
				CMRjustificacion = null
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.Ecodigo#">
			and CMPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CMPid#">
			and DSlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.DSlinea#">
		</cfquery>
		<!--- Registrar los datos de la Cotización seleccionada --->
		<cfquery name="updResultadoEval" datasource="#Session.DSN#">
			update CMResultadoEval set
				CMRseleccionado = 1
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.Ecodigo#">
			and CMPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CMPid#">
			and DSlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.DSlinea#">
			and DClinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#DatosLinea[1]#">
		</cfquery>
		<!--- Si se selecciona una cotización diferente a la sugerida --->
		<cfif rsSugerida.DClinea NEQ DatosLinea[1]>
			<!--- Registrar los datos de la Cotización seleccionada --->
			<cfquery name="updResultadoEval" datasource="#Session.DSN#">
				update CMResultadoEval set
                	<cfif isdefined('Session.Compras.Comprador') and len(trim(Session.Compras.Comprador))>
					CMCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Compras.Comprador#">,
                    </cfif>
					CMRfechamod = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
					CMRjustificacion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.CMRjustificacion#">
				where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.Ecodigo#">
				and CMPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CMPid#">
				and DSlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.DSlinea#">
				and DClinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#DatosLinea[1]#">
			</cfquery>
		</cfif>
	
		<script language="javascript" type="text/javascript">
			<cfoutput>
			window.opener.document.#Form.f#.#Form.p1#_#Form.DSlinea#.value = '#DatosLinea[1]#';
			window.opener.document.#Form.f#.#Form.p2#_#Form.DSlinea#.value = '#DatosLinea[2]#';
			<cfif not lvarSolicitante>
			window.opener.document.#Form.f#.#Form.p3#_#Form.DSlinea#.value = '#DatosLinea[3]#';
			</cfif>
			window.opener.document.#Form.f#.#Form.p4#_#Form.DSlinea#.value = '#JSStringFormat(DatosLinea[4])#';
			window.opener.document.#Form.f#.#Form.p5#_#Form.DSlinea#.value = '#DatosLinea[5]#';
			window.opener.document.#Form.f#.#Form.p6#_#Form.DSlinea#.value = fm('#DatosLinea[6]#', 2);
			window.opener.document.#Form.f#.#Form.p7#_#Form.DSlinea#.value = '#DatosLinea[6]#';
			window.opener.document.#Form.f#.#Form.p9#_#Form.DSlinea#.value = '#DatosLinea[7]#';
			window.opener.document.#Form.f#.#Form.p10#_#Form.DSlinea#.value = '#DatosLinea[8]#';
			window.opener.document.#Form.f#.#Form.p11#_#Form.DSlinea#.value = '#DatosLinea[9]#';
			window.opener.document.#Form.f#.#Form.p12#_#Form.DSlinea#.value = '#DatosLinea[10]#';
			window.opener.document.#Form.f#.#Form.p13#_#Form.DSlinea#.value = '#DatosLinea[11]#';
			window.close();
			</cfoutput>
		</script>
	
	</cfif>

	<cfif not isdefined("Form.btnSeleccionar")>
		<cftransaction>
			<cfquery name="rsLineasCotizacion" datasource="#Session.DSN#">
				select coalesce(c.DSconsecutivo,0) as DSconsecutivo, 
					   coalesce(b.DClinea,0) as DClinea,
					   coalesce(d.SNnumero#_Cat#'-'#_Cat#d.SNnombre,' ') as SNnombre, 
					   case c.DStipo 	when 'A' then coalesce(ltrim(rtrim(e.Acodigo))#_Cat#'-'#_Cat#Adescripcion,' ')
					   					when 'S' then coalesce(ltrim(rtrim(f.Ccodigo))#_Cat#'-'#_Cat#Cdescripcion,' ')
					   					when 'F' then coalesce(g.ACdescripcion#_Cat#'/'#_Cat#h.ACdescripcion,' ') end as Descripcion,
					   coalesce(rtrim(a.ECnumero),' ') as ECnumero,
					   coalesce(b.DCcantidad,0) as DCcantidad,
					   a.ECfechacot,
					   #LvarOBJ_PrecioU.enSQL_AS("coalesce(a.DCpreciou,0)","DCpreciou")#,
					   i.Mnombre,
					   coalesce(i.Miso4217,' ') as Miso4217, 
					   a.NotaGlobal,
					   coalesce(a.NotaTotalLinea,0) as NotaTotalLinea,
					   a.NotaGarantia,
					   a.NotaPrecio,
					   a.NotaTiempoEnt,
					   a.NotaPlazoCred,
					   a.NotaTec,
					   y.CFdescripcion,
					   coalesce(c.Ucodigo,' ') as Ucodigo,
					   coalesce(x.ESnumero,0) as ESnumero,
					  <!---c.Ucodigo,---->
					   c.DScant - c.DScantsurt as cantidad
					   
				from CMResultadoEval a
					inner join DCotizacionesCM b
					on a.ECid = b.ECid and a.DSlinea = b.DSlinea
				
					inner join DSolicitudCompraCM c
						on b.DSlinea = c.DSlinea
				
					inner join ESolicitudCompraCM x
						on c.Ecodigo = x.Ecodigo and c.ESidsolicitud = x.ESidsolicitud
					
                    inner join CFuncional y
						on x.Ecodigo = y.Ecodigo and x.CFid = y.CFid
					inner join SNegocios d
						on d.Ecodigo = #form.Ecodigo# and a.SNcodigo = d.SNcodigo
					
					inner join Monedas i
						on i.Ecodigo = #form.Ecodigo# and a.Mcodigo = i.Mcodigo
				
					left outer join Articulos e
						on c.Aid = e.Aid
				
					left outer join Conceptos f
						on c.Cid = f.Cid
				
					left outer join ACategoria g
						on c.Ecodigo = g.Ecodigo and c.ACcodigo = g.ACcodigo
				
					left outer join AClasificacion h
						on c.Ecodigo = h.Ecodigo and c.ACcodigo = h.ACcodigo and c.ACid = h.ACid
				
				where a.CMPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CMPid#">
				and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.Ecodigo#">
				and a.DSlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.DSlinea#">
				order by a.ECfechacot
			</cfquery>
			
			<cfquery name="rsCriterios" datasource="#Session.DSN#">
				select b.CCdesc, a.CPpeso
				from CMCondicionesProceso a, CCriteriosCM b
				where a.CMPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CMPid#">
				and a.CCid = b.CCid
				order by a.CCid
			</cfquery>
			
		</cftransaction>
	
		<!---
		<script language="javascript" type="text/javascript">
			<cfoutput>
			function Asignar() {
				if (document.form1.chk.value) {
					var params = document.form1.chk.value.split('|');
				} else {
					for (var i = 0; i < document.form1.chk.length; i++) {
						if (document.form1.chk[i].checked) {
							var params = document.form1.chk[i].value.split('|');
							break;
						}
					}
				}
				
				var p1 = params[0];
				var p2 = params[1];
				var p3 = params[2];
				var p4 = params[3];
				var p5 = params[4];
				var p6 = params[5];
				var p9 = params[6];
				var p10 = params[7];
				var p11 = params[8];
				window.opener.document.#Form.f#.#Form.p1#_#Form.DSlinea#.value = p1;
				window.opener.document.#Form.f#.#Form.p2#_#Form.DSlinea#.value = p2;
				window.opener.document.#Form.f#.#Form.p3#_#Form.DSlinea#.value = p3;
				window.opener.document.#Form.f#.#Form.p4#_#Form.DSlinea#.value = p4;
				window.opener.document.#Form.f#.#Form.p5#_#Form.DSlinea#.value = p5;
				window.opener.document.#Form.f#.#Form.p6#_#Form.DSlinea#.value = fm(p6, 2);
				window.opener.document.#Form.f#.#Form.p7#_#Form.DSlinea#.value = p6;
				window.opener.document.#Form.f#.#Form.p9#_#Form.DSlinea#.value = p9;
				window.opener.document.#Form.f#.#Form.p10#_#Form.DSlinea#.value = p10;
				window.opener.document.#Form.f#.#Form.p11#_#Form.DSlinea#.value = p11;
				window.close();
			}
			</cfoutput>
		</script>
		--->
		
		<script language="javascript" type="text/javascript">
			<cfoutput>
			function Asignar() {
				if (document.form1.chk.value) {
					var params = document.form1.chk.value.split('|');
				} else {
					for (var i = 0; i < document.form1.chk.length; i++) {
						if (document.form1.chk[i].checked) {
							var params = document.form1.chk[i].value.split('|');
							break;
						}
					}
				}				
				var linea = params[0];				
				if (linea != '<cfoutput>#rsSugerida.DClinea#</cfoutput>' && document.form1.CMRjustificacion.value == '') {
					alert('Debe llenar la justificación para realizar el cambio');
					return false;
				}
			}			
			</cfoutput>
			function Cerrar(){
				window.close();
			}
		</script>
		
		<cfoutput>
		<form name="form1" method="post" action="#GetFileFromPath(GetTemplatePath())#">
			<cfloop collection="#Form#" item="i">
				<input type="hidden" name="#i#" value="#StructFind(Form, i)#">
			</cfloop>
			<table width="98%"  border="0" cellspacing="0" cellpadding="2" align="center">
			  <tr>
				<td colspan="14" align="center"><strong>Lista de Líneas de Cotización</strong></td>
			  </tr>
			  <tr>
				<td colspan="14" align="center" class="areaFiltro">
					<table width="98%"  border="0" cellspacing="0" cellpadding="0">
					  <tr>
						<td width="50%" valign="top" style="border-right: 1px solid gray; ">
							<table width="100%"  border="0" cellspacing="0" cellpadding="2">
							  <tr align="center">
								<td colspan="2" style="border-bottom: 1px solid gray; "><strong>Solicitud de Compra:&nbsp;#rsLineasCotizacion.ESnumero#</strong></td>
							  </tr>
							  <tr>
								<td align="right" class="fileLabel">Centro Funcional: </td>
								<td>#rsLineasCotizacion.CFdescripcion#</td>
							  </tr>
							  <tr>
								<td width="30%" align="right" class="fileLabel">L&iacute;nea de Solicitud:</td>
								<td>#rsLineasCotizacion.DSconsecutivo#</td>
							  </tr>
							  <tr>
								<td class="fileLabel" align="right">Item:</td>
								<td>#HTMLEditFormat(rsLineasCotizacion.Descripcion)#</td>
							  </tr>
							</table>		
						</td>
						<td valign="top">
							<table width="98%"  border="0" cellspacing="0" cellpadding="2">
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
				<td colspan="14" style="border-left: 1px solid gray; border-right: 1px solid gray; " nowrap>
					<strong>Justificaci&oacute;n:</strong>&nbsp;
					<input type="text" name="CMRjustificacion" value="" style="width: 85%;">
				</td>
			  </tr>
			  <tr bgcolor="##CCCCCC">
				<td rowspan="2" style="border: 1px solid gray;">&nbsp;</td>
				<td width="3%" rowspan="2" style="border-bottom: 1px solid gray; border-top: 1px solid gray; border-right: 1px solid gray;"><strong>N° Cotizaci&oacute;n </strong></td>
				<cfif not lvarSolicitante><td width="40%" rowspan="2" style="border-bottom: 1px solid gray; border-top: 1px solid gray; border-right: 1px solid gray;"><strong>Proveedor</strong></td></cfif>
				<td width="3%" rowspan="2" align="right" style="border-bottom: 1px solid gray; border-top: 1px solid gray; border-right: 1px solid gray;"><strong>Cantidad</strong></td>
				<td width="5%" rowspan="2" align="right" style="border-bottom: 1px solid gray; border-top: 1px solid gray; border-right: 1px solid gray;"><strong>Unidad</strong></td>				
				<td width="20%" rowspan="2" align="right" style="border-bottom: 1px solid gray; border-top: 1px solid gray; border-right: 1px solid gray;"><strong>Precio Unitario </strong></td>
				<td width="5%" rowspan="2" align="right" style="border-bottom: 1px solid gray; border-top: 1px solid gray; border-right: 1px solid gray;"><strong>Moneda</strong></td>
				<td width="10%" rowspan="2" align="center" style="border-bottom: 1px solid gray; border-top: 1px solid gray; border-right: 1px solid gray;"><strong>Nota L&iacute;nea</strong></td>
				<td width="30%" colspan="5" align="center" style="border-bottom: 1px solid gray; border-top: 1px solid gray; border-right: 1px solid gray;"><strong>Notas Criterio </strong></td>
			  </tr>
			  <tr bgcolor="##CCCCCC">
				<td width="5%" align="center" style="border-bottom: 1px solid gray; border-right: 1px solid gray; "><strong>Garant&iacute;a</strong></td>
				<td width="5%" align="center" style="border-bottom: 1px solid gray; border-right: 1px solid gray; "><strong>Precio</strong></td>
				<td width="5%" align="center" style="border-bottom: 1px solid gray; border-right: 1px solid gray; "><strong>Tiempo Entrega </strong></td>
				<td width="5%" align="center" style="border-bottom: 1px solid gray; border-right: 1px solid gray; "><strong>Plazo Cr&eacute;dito</strong></td>
				<td width="5%" align="center" style="border-bottom: 1px solid gray; border-right: 1px solid gray; "><strong>Nota T&eacute;cnica </strong></td>
			  </tr>
			  <cfloop query="rsLineasCotizacion">
			  <tr valign="middle">
				<td width="3%" style="border-bottom: 1px solid gray; border-right: 1px solid gray; border-left: 1px solid gray; ">
				<cfif rsLineasCotizacion.DCcantidad LT rsLineasCotizacion.cantidad <!---and  rsLineasCotizacion.DCcantidad GT 0---->>
					<cfset rsLineasCotizacion.DCcantidad = rsLineasCotizacion.DCcantidad>
				<cfelse>
					<cfset rsLineasCotizacion.DCcantidad = rsLineasCotizacion.cantidad>
				</cfif>
					<input name="chk" type="radio" value="#DClinea#|#DSconsecutivo#|#HTMLEditFormat(SNnombre)#|#HTMLEditFormat(Descripcion)#|#HTMLeditFormat(ECnumero)#|#DCcantidad#|#HTMLEditFormat(Miso4217)#|#LvarOBJ_PrecioU.enCF(DCpreciou)#|#LSNumberFormat(NotaTotalLinea, ',9.00')#|#ESnumero#|#HTMLEditFormat(Ucodigo)#" <cfif rsSeleccionado.DClinea EQ rsLineasCotizacion.DClinea> checked</cfif>>
				</td>
				<td  width="3%" style="border-bottom: 1px solid gray; border-right: 1px solid gray;">#rsLineasCotizacion.ECnumero#</td>
				<cfif not lvarSolicitante><td width="40%" style="border-bottom: 1px solid gray; border-right: 1px solid gray; ">#HTMLEditFormat(rsLineasCotizacion.SNnombre)#</td></cfif>			
				<td width="3%" align="right" style="border-bottom: 1px solid gray; border-right: 1px solid gray; ">#rsLineasCotizacion.DCcantidad#</td>
				<td width="5%" align="right" style="border-bottom: 1px solid gray; border-right: 1px solid gray; ">#rsLineasCotizacion.Ucodigo#</td>				
				<td width="20%" align="right" style="border-bottom: 1px solid gray; border-right: 1px solid gray; ">#LvarOBJ_PrecioU.enCF_RPT(rsLineasCotizacion.DCpreciou)#</td>
				<td width="5%" align="right" style="border-bottom: 1px solid gray; border-right: 1px solid gray; ">#rsLineasCotizacion.Miso4217#</td>
				<td width="10%" align="right" style="border-bottom: 1px solid gray; border-right: 1px solid gray; "><cfif Len(Trim(rsLineasCotizacion.NotaTotalLinea))>#LSNumberFormat(rsLineasCotizacion.NotaTotalLinea, '9.00')#<cfelse>N/A</cfif></td>
				<td width="5%" align="center" style="border-bottom: 1px solid gray; border-right: 1px solid gray; "><cfif Len(Trim(rsLineasCotizacion.NotaGarantia))>#LSNumberFormat(rsLineasCotizacion.NotaGarantia, '9.00')#<cfelse>N/A</cfif></td>
				<td width="5%" align="center" style="border-bottom: 1px solid gray; border-right: 1px solid gray; "><cfif Len(Trim(rsLineasCotizacion.NotaPrecio))>#LSNumberFormat(rsLineasCotizacion.NotaPrecio, '9.00')#<cfelse>N/A</cfif></td>
				<td width="5%" align="center" style="border-bottom: 1px solid gray; border-right: 1px solid gray; "><cfif Len(Trim(rsLineasCotizacion.NotaTiempoEnt))>#LSNumberFormat(rsLineasCotizacion.NotaTiempoEnt, '9.00')#<cfelse>N/A</cfif></td>
				<td width="5%" align="center" style="border-bottom: 1px solid gray; border-right: 1px solid gray; "><cfif Len(Trim(rsLineasCotizacion.NotaPlazoCred))>#LSNumberFormat(rsLineasCotizacion.NotaPlazoCred, '9.00')#<cfelse>N/A</cfif></td>
				<td width="5%" align="center" style="border-bottom: 1px solid gray; border-right: 1px solid gray; "><cfif Len(Trim(rsLineasCotizacion.NotaTec))>#LSNumberFormat(rsLineasCotizacion.NotaTec, '9.00')#<cfelse>N/A</cfif></td>
			  </tr>
			  </cfloop>
			</table>
			<table width="98%" cellpadding="0" cellspacing="0">
			  <tr>
				<td>&nbsp;</td>
			  </tr>
			  <tr>
				<td align="center">
					<input type="submit" name="btnSeleccionar" value="Seleccionar" onClick="javascript: return Asignar();">
					<input type="submit" name="btnCerrar" value="Cerrar" onClick="javascript: Cerrar();">					
				</td>
			  </tr>
			  <tr>
				<td>&nbsp;</td>
			  </tr>
			</table>
		</form>
		</cfoutput>
	</cfif>
	
</body>
</html>
