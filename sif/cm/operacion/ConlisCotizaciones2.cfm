<cfparam name="lvarSolicitante" default="false">
<cfset LvarOBJ_PrecioU = createObject("Component","sif.Componentes.CM_PrecioU").init()>
<cfinclude template="../../Utiles/sifConcat.cfm">
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title>Lista de Cotizaciones</title>
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

	<cfset fnUrlToFormParam ("CMPid", "")>
	<cfset fnUrlToFormParam ("ECid", "")>
	<cfset fnUrlToFormParam ("f", "")>
	<cfset fnUrlToFormParam ("p1", "")>
	<cfif not lvarSolicitante><cfset fnUrlToFormParam ("p2", "")></cfif>
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
    <cfset fnUrlToFormParam ("Ecodigo", "#session.Ecodigo#")>
		
	<cfquery name="rsCriterios" datasource="#Session.DSN#">
		select b.CCdesc, a.CPpeso
		from CMCondicionesProceso a, CCriteriosCM b
		where a.CMPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CMPid#">
		and a.CCid = b.CCid
		order by a.CCid
	</cfquery>	
	<!---- Consultar la cotización sugerida por el sistema --->
	<cfquery name="rsSeleccionado" datasource="#Session.DSN#">
		select ECid
		from CMResultadoEval
		where CMPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CMPid#">
		and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.Ecodigo#">
		and ECid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.ECid#">
		and CMRseleccionado = 1
	</cfquery>
	
	<cfquery name="rsSugerida" datasource="#Session.DSN#">
		select distinct ECid
		from CMResultadoEval
		where CMPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CMPid#">
		and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.Ecodigo#">
		and CMRsugerido = 1
	</cfquery>

	<!---<cfif isdefined("Form.Asignar") and isdefined("Form.ECid") and Len(Trim(Form.ECid))>--->
	<cfif isdefined("Form.btnSeleccionar") and isdefined("Form.chk") and Len(Trim(Form.chk))>						
		<!--- <cfif isdefined("Form.btnSeleccionar") and isdefined("Form.chk") and Len(Trim(Form.chk))> --->
		<cfset DatosLinea = ListToArray(Form.chk, '|')>

		<!--- Resetear el bit de seleccionado en los registros del proceso de compra actual --->
		<cfquery name="updSeleccionados" datasource="#Session.DSN#">
			update CMResultadoEval set
				CMRseleccionado = 0,
				CMRjustificacion = null
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.Ecodigo#">
				and CMPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CMPid#">			
		</cfquery>

		<!--- Registrar los datos de la Cotización seleccionada --->
		<cfquery name="updResultadoEval" datasource="#Session.DSN#">
			update CMResultadoEval set
				CMRseleccionado = 1
			where 
				<!----ECid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.ECid#">----->
				<cfif rsSugerida.ECid NEQ DatosLinea[1]>					
					ECid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#DatosLinea[1]#">
				<cfelse>					
					ECid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsSugerida.ECid#">
				</cfif>
				and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.Ecodigo#">
				and CMPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CMPid#">
		</cfquery>
		<!--- Si se selecciona una cotización diferente a la sugerida --->
		<cfif rsSugerida.ECid NEQ DatosLinea[1]>
			<!--- Registrar los datos de la Cotización seleccionada --->
			<cfquery name="updResultadoEval" datasource="#Session.DSN#">
				update CMResultadoEval set
                	<cfif isdefined('Session.Compras.Comprador') and len(trim(Session.Compras.Comprador))>
					CMCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Compras.Comprador#">,
                    </cfif>
					CMRfechamod = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
					CMRjustificacion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.CMRjustificacion#">
				where ECid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#DatosLinea[1]#">
				and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.Ecodigo#">
				and CMPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CMPid#">
			</cfquery>
		</cfif>

		<!--- Datos de la Cotización Seleccionada --->
		<cfquery name="rsCotizacion" datasource="#Session.DSN#">
			select c.DSconsecutivo,
					c.DScant, c.DScantsurt,
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
				   a.NotaTotalLinea,
				   c.DScant - c.DScantsurt as cantidad				    
			from CMResultadoEval a
				inner join DCotizacionesCM b
					on a.DClinea = b.DClinea and a.ECid = b.ECid
			
				inner join DSolicitudCompraCM c
					on b.DSlinea = c.DSlinea
			
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
			
				<!--- where a.ECid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.ECid#"> --->					
			where a.ECid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#DatosLinea[1]#">
				and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.Ecodigo#">
				and a.CMPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CMPid#">
				order by a.ECfechacot
		</cfquery>			

		<script language="javascript" type="text/javascript">				
			<cfoutput>
				window.opener.document.#Form.f#.#Form.p1#.value = '#DatosLinea[1]#';
				<cfif not lvarSolicitante>
				window.opener.document.#Form.f#.#Form.p2#.value = '#DatosLinea[3]#';
				</cfif>
				window.opener.document.#Form.f#.#Form.p5#.value = '#DatosLinea[2]#';
				window.opener.document.#Form.f#.#Form.p8#.value = '#DatosLinea[4]#';
				window.opener.document.#Form.f#.#Form.p12#.value = '#DatosLinea[7]#';			
				<cfloop query="rsCotizacion">
					window.opener.document.#Form.f#.#Form.p3#_#rsCotizacion.DSlinea#.value = '#rsCotizacion.DSconsecutivo#';
					window.opener.document.#Form.f#.#Form.p4#_#rsCotizacion.DSlinea#.value = '#JSStringFormat(rsCotizacion.Descripcion)#';
					/*
					window.opener.document.#Form.f#.#Form.p6#_#rsCotizacion.DSlinea#.value = '#LSNumberFormat(rsCotizacion.DCcantidad, ',9.00')#';
                    window.opener.document.#Form.f#.#Form.p7#_#rsCotizacion.DSlinea#.value = '#LSNumberFormat(rsCotizacion.DCcantidad, ',9.00')#';
					*/
					window.opener.document.#Form.f#.#Form.p10#_#rsCotizacion.DSlinea#.value = '#LvarOBJ_PrecioU.enCF(rsCotizacion.DCpreciou)#';		
					window.opener.document.#Form.f#.#Form.p11#_#rsCotizacion.DSlinea#.value = '#LSNumberFormat(rsCotizacion.NotaTotalLinea, ',9.00')#';					
					<cfif rsCotizacion.DCcantidad LT rsCotizacion.cantidad>
						window.opener.document.#Form.f#.#Form.p6#_#rsCotizacion.DSlinea#.value = '#LSNumberFormat(rsCotizacion.DCcantidad, ',9.00')#';
						window.opener.document.#Form.f#.#Form.p7#_#rsCotizacion.DSlinea#.value = '#LSNumberFormat(rsCotizacion.DCcantidad, ',9.00')#';
					<cfelse>
						window.opener.document.#Form.f#.#Form.p6#_#rsCotizacion.DSlinea#.value = '#LSNumberFormat(rsCotizacion.cantidad, ',9.00')#';
						window.opener.document.#Form.f#.#Form.p7#_#rsCotizacion.DSlinea#.value = '#LSNumberFormat(rsCotizacion.cantidad, ',9.00')#';						
					</cfif>
				</cfloop>            
				window.close();
			</cfoutput>
		</script>
		<!----</cfif>--->
	</cfif>
	<cfif not isdefined("Form.btnSeleccionar")>		
	<!----<cfif not isdefined("Form.Asignar")>	--->
		<cftransaction>
			<cfquery name="rsLineasCotizacion" datasource="#Session.DSN#">
				select 	distinct a.ECid, 
						coalesce(b.SNnumero#_Cat#'-'#_Cat#b.SNnombre,' ') as SNnombre,
						coalesce(rtrim(a.ECnumero),' ') as ECnumero, 
					   a.ECfechacot, 
					   a.CMPid,
					   'Yes' as Asignar,
					   coalesce(a.NotaGlobal,0) as NotaGlobal,
					   coalesce(i.Mnombre,' ') as Mnombre,
					   i.Miso4217,
					   coalesce(c.ECtotal,0) as ECtotal
				from CMResultadoEval a
				
					inner join SNegocios b
					on b.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.Ecodigo#"> and a.SNcodigo = b.SNcodigo
					
					inner join Monedas i
					on i.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.Ecodigo#">
					and a.Mcodigo = i.Mcodigo
					
					inner join ECotizacionesCM c
					on a.ECid = c.ECid
					
				where a.CMPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CMPid#">
				and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.Ecodigo#">
				order by a.ECfechacot
			</cfquery>							
		</cftransaction>

		<script language="javascript" type="text/javascript">			
			<cfoutput>
			function funcAsignar() {
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
				if (linea != '<cfoutput>#rsSugerida.ECid#</cfoutput>' && document.form1.CMRjustificacion.value == '') {
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
				<td colspan="11" align="center"><strong>Lista de Cotizaciones</strong></td>
			  </tr>
			  <tr>
				<td colspan="11" align="center" class="areaFiltro">				<table width="100%"  border="0" cellspacing="0" cellpadding="0">
                  <tr>
                    <td width="50%" valign="top" style="border-right: 1px solid gray; ">
                      <table width="100%"  border="0" cellspacing="0" cellpadding="2">
                        <tr align="center">
                          <td colspan="2" style="border-bottom: 1px solid gray; "><strong>Proceso de Compra</strong></td>
                        </tr>                        
						 <cfquery name="rsProceso" datasource="#Session.DSN#">
								select CMPdescripcion, CMPfechapublica, CMPnumero 
								from CMProcesoCompra where CMPid =	<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CMPid#">
						  </cfquery>
						 <tr>
						  	<td align="right" class="fileLabel">N° Proceso: </td>
                          	<td>                           
           				    	#rsProceso.CMPnumero# 
						  	</td>
						  </tr>
						  <tr>
						  	<td align="right" class="fileLabel">Proceso: </td>
                         	 <td>                           
           				    	#rsProceso.CMPdescripcion# 
						  	</td>
                         </tr>
                        <tr>
                          <td width="30%" align="right" class="fileLabel">Fecha Pub.:</td>
                          <td>#LSDateFormat(rsProceso.CMPfechapublica,'dd/mm/yyyy')#</td>
                        </tr>
                    </table></td>
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
                    </table></td>
                  </tr>
                </table></td>
			  </tr>
			  <tr>
				<td colspan="11" style="border-left: 1px solid gray; border-right: 1px solid gray; " nowrap>
					<strong>Justificaci&oacute;n:</strong>&nbsp;<input type="text" name="CMRjustificacion" value="" style="width: 85%;">	
				</td>
			  </tr>
			  <tr bgcolor="##CCCCCC">
				<td style="border: 1px solid gray;">&nbsp;</td>
				<td width="3%" style="border-bottom: 1px solid gray; border-top: 1px solid gray; border-right: 1px solid gray;"><strong>No. Cotizaci&oacute;n </strong></td>
				<cfif not lvarSolicitante><td width="40%" style="border-bottom: 1px solid gray; border-top: 1px solid gray; border-right: 1px solid gray;"><strong>Proveedor</strong></td></cfif>
				<td width="5%" style="border-bottom: 1px solid gray; border-top: 1px solid gray; border-right: 1px solid gray;"><strong>Fecha</strong></td>
				<td width="5%" style="border-bottom: 1px solid gray; border-top: 1px solid gray; border-right: 1px solid gray;"><strong>Moneda</strong></td>
				<td width="10%" align="right" style="border-bottom: 1px solid gray; border-top: 1px solid gray; border-right: 1px solid gray;"><strong>Total</strong></td>
				<td width="10%" align="center" style="border-bottom: 1px solid gray; border-top: 1px solid gray; border-right: 1px solid gray;"><strong>Nota Global</strong></td>
			  </tr>
			  <cfloop query="rsLineasCotizacion">
			  <tr valign="middle">
				<td width="3%" style="border-bottom: 1px solid gray; border-right: 1px solid gray; border-left: 1px solid gray; ">
					<input name="chk" type="radio" value="#ECid#|#HTMLEditFormat(ECnumero)#|#HTMLEditFormat(SNnombre)#|#LSDateFormat(ECfechacot,'dd/mm/yyyy')#|#HTMLEditFormat(Mnombre)#|#LSNumberFormat(ECtotal, ',9.00')#|#LSNumberFormat(NotaGlobal, ',9.00')#" <cfif rsSeleccionado.ECid EQ rsLineasCotizacion.ECid> checked</cfif>>
				</td>
				<td width="3%" style="border-bottom: 1px solid gray; border-right: 1px solid gray;">#rsLineasCotizacion.ECnumero#</td>
				<cfif not lvarSolicitante><td width="40%" style="border-bottom: 1px solid gray; border-right: 1px solid gray; ">#rsLineasCotizacion.SNnombre#</td></cfif>
				<td width="5%" style="border-bottom: 1px solid gray; border-right: 1px solid gray; ">#LSDateFormat(rsLineasCotizacion.ECfechacot,'dd/mm/yyyy')#</td>
				<td width="5%" style="border-bottom: 1px solid gray; border-right: 1px solid gray; ">#rsLineasCotizacion.Miso4217#</td>
				<td width="10%" align="right" style="border-bottom: 1px solid gray; border-right: 1px solid gray; ">#LSCurrencyFormat(rsLineasCotizacion.ECtotal,'none')#</td>
				<td width="10%" align="center" style="border-bottom: 1px solid gray; border-right: 1px solid gray; ">#rsLineasCotizacion.NotaGlobal#</td>
			  </tr>
			  </cfloop>
			</table>
			<table width="100%" cellpadding="0" cellspacing="0">
			  <tr>
				<td>&nbsp;</td>
			  </tr>
			  <tr>
				<td align="center">
					<input type="submit" name="btnSeleccionar" value="Seleccionar" onClick="javascript: return funcAsignar();">
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
