<cfif Url.tipo EQ "I">
	<cfset titulo ="Impresi&oacute;n ">
</cfif>
<cfif Url.tipo EQ "R">
	<cfset titulo ="Reimpresi&oacute;n ">
</cfif>
<cfset filtro = "">
<cf_templateheader title="Impresión de Facturas">
	<cfinclude template="/sif/portlets/pNavegacionFA.cfm">
		<cf_web_portlet_start titulo="#titulo# de Facturas">

		<!--- Vienen los parametros para imprimir la factura --->
		<cfif isDefined("Url.imprimirPDF")>

			<!--- Busca el formato según el tipo de transacción que se le ha asignado --->
			<cfquery name="rsTipoFactura" datasource="#Session.DSN#">
				select a.CCTcodigo, rtrim(ltrim(b.FMT01COD)) as FMT01COD from ETransacciones a, TipoTransaccionCaja b
				where a.Ecodigo = #Session.Ecodigo#
				  and a.FCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Url.FCid#">
				  and a.ETnumero = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Url.ETnumero#">
				  and a.CCTcodigo = b.CCTcodigo
				  and a.Ecodigo = b.Ecodigo
				  and a.FCid = b.FCid
			</cfquery>

			<!--- Si la tipo de transacción de la factura tiene asignado un formato de impresión genera el reporte PDF en pantalla  --->
			<cfif rsTipoFactura.RecordCount GT 0>
				<cfset codigo = "/sif/reportes/#session.Ecodigo#_#rsTipoFactura.FMT01COD#.jasper" >
				<CF_JasperReport DATASOURCE="#session.DSN#" OUTPUT_FORMAT="pdf" JASPER_FILE="#codigo#">
					<CF_JasperParam name="Ecodigo"   value="#session.Ecodigo#">
					<CF_JasperParam name="FCid"   value="#Url.FCid#">
					<CF_JasperParam name="ETnumero"   value="#Url.ETnumero#">
				</CF_JasperReport>
			<cfelse>
				<script>alert('No hay formato de impresión para este tipo de factura.');</script>
			</cfif>

		</cfif>

		<cfif Url.tipo EQ "I">

			<!--- Guardan los valores que se filtraron con el fin de mostrarlos en los filtros --->
			<cfset fETnumero = "">
			<cfset fETnombredoc = "">
			<cfset fOdescripcion = "">
			<cfset fETfecha = "">
			<cfset fMnombre = "">

			<!-------------------------------------------------------------------------------------------
				OJO: hay que descomentar esta línea (/*and a.ETestado = 'C'*/) en el filtro de aquí abajo
			-------------------------------------------------------------------------------------------->
			  <cfset filtro = " a.Ecodigo = #Session.Ecodigo#
							  and a.ETimpresa = 0
							  /*and a.ETestado = 'C'*/
							  and a.Ecodigo = b.Ecodigo
							  and a.Ocodigo = b.Ocodigo
							  and a.Ecodigo = c.Ecodigo
							  and a.Mcodigo = c.Mcodigo  ">

			  <cfif isdefined('Form.btnFiltrar')>
				<cfif isdefined('Form.fETnumero') and len(trim(Form.fETnumero)) GT 0 >
				  <cfset filtro = filtro & " and a.ETnumero = " & Trim(Form.fETnumero)>
				  <cfset fETnumero = Trim(form.fETnumero)>
				</cfif>
				<cfif isdefined('Form.fETnombredoc') and len(trim(Form.fETnombredoc)) GT 0 >
				  <cfset filtro = filtro & " and upper(a.ETnombredoc) like '%#Ucase(Trim(Form.fETnombredoc))#%'">
				  <cfset fETnombredoc = Trim(form.fETnombredoc)>
				</cfif>
				<cfif isdefined('Form.fOdescripcion') and len(trim(Form.fOdescripcion)) GT 0 >
				  <cfset filtro = filtro & " and upper(b.Odescripcion) like '%#Ucase(Trim(Form.fOdescripcion))#%'">
				  <cfset fOdescripcion = Trim(form.fOdescripcion)>
				</cfif>
				<cfif isdefined('Form.fETfecha') and len(trim(Form.fETfecha)) GT 0 >
				  <cfset filtro = filtro & " and a.ETfecha >= convert(datetime,'#LSDateFormat(Form.fETfecha,'YYYYMMDD')#')">
				  <cfset fETfecha = Trim(form.fETfecha)>
				</cfif>
				<cfif isdefined('Form.fMnombre') and len(trim(Form.fMnombre)) GT 0 >
				  <cfset filtro = filtro & " and upper(c.Mnombre) like '%#Ucase(Trim(Form.fMnombre))#%'">
				  <cfset fMnombre = Trim(form.fMnombre)>
				</cfif>

			</cfif>

			<cfset filtro = filtro & " order by convert(int,a.ETnumero)">
			<cfset filtro = trim(filtro)>

	  <cfelseif Url.tipo EQ "R">

			<!--- Guardan los valores que se filtraron con el fin de mostrarlos en los filtros --->
			<cfset fETnumero = "">
			<cfset fETnombredoc = "">
			<cfset fOdescripcion = "">
			<cfset fTIfecha = "">
			<cfset fMnombre = "">

			  <cfset filtro = " x.Ecodigo = #Session.Ecodigo#
			  				and TItipo = 'I'
			  				and a.FCid = x.FCid
							and a.ETnumero = x.ETnumero
							and x.Ecodigo = c.Ecodigo
							and x.Mcodigo = c.Mcodigo
							and x.Ecodigo = b.Ecodigo
							and x.Ocodigo = b.Ocodigo ">

			  <cfif isdefined('Form.btnFiltrar')>
				<cfif isdefined('Form.fETnumero') and len(trim(Form.fETnumero)) GT 0 >
				  <cfset filtro = filtro & " and a.ETnumero = " & Trim(Form.fETnumero)>
				  <cfset fETnumero = Trim(form.fETnumero)>
				</cfif>
				<cfif isdefined('Form.fETnombredoc') and len(trim(Form.fETnombredoc)) GT 0 >
				  <cfset filtro = filtro & " and upper(x.ETnombredoc) like '%#Ucase(Trim(Form.fETnombredoc))#%'">
				  <cfset fETnombredoc = Trim(form.fETnombredoc)>
				</cfif>
				<cfif isdefined('Form.fOdescripcion') and len(trim(Form.fOdescripcion)) GT 0 >
				  <cfset filtro = filtro & " and upper(b.Odescripcion) like '%#Ucase(Trim(Form.fOdescripcion))#%'">
				  <cfset fOdescripcion = Trim(form.fOdescripcion)>
				</cfif>

				<cfif isdefined('Form.fTIfecha') and len(trim(Form.fTIfecha)) GT 0 >
				  <cfset filtro = filtro & " and a.TIfecha >= convert(datetime,'#LSDateFormat(Form.fTIfecha,'YYYYMMDD')#')">
				  <cfset fTIfecha = Trim(form.fTIfecha)>
				</cfif>

				<cfif isdefined('Form.fMnombre') and len(trim(Form.fMnombre)) GT 0 >
				  <cfset filtro = filtro & " and upper(c.Mnombre) like '%#Ucase(Trim(Form.fMnombre))#%'">
				  <cfset fMnombre = Trim(form.fMnombre)>
				</cfif>

			</cfif>
			<cfset filtro = trim(filtro)>

	  </cfif>
				<cfoutput>
                    <table border="0" cellspacing="0" cellpadding="0" class="areaFiltro" width="100%">
                      <form name="filtro" method="post" action="ImpresionFacturasFA.cfm?tipo=#Url.tipo#">
                        <tr valign="top">
                          <td width="1%"><strong>&nbsp;&nbsp;</strong></td>
                          <td width="12%"><strong>Transacci&oacute;n:
                              <input type="text" name="fETnumero" size="12" maxlength="12" value="#fETnumero#">
                          </strong></td>
                          <td width="33%"><strong>Descripción:<br>
                            <input type="text" name="fETnombredoc" size="40" maxlength="80" value="#fETnombredoc#">
                          </strong></td>
                          <td width="26%"><strong>Oficina:
                            <input type="text" name="fOdescripcion" size="40" maxlength="80" value="#fOdescripcion#">
                          </strong></td>
                          <td width="5%"><strong>Fecha:
						  <cfif Url.tipo EQ "I">
						  <cf_sifcalendario form="filtro" name="fETfecha" value="#fETfecha#"></strong>
						  <cfelseif Url.tipo EQ "R">
						  <cf_sifcalendario form="filtro" name="fTIfecha" value="#fTIfecha#"></strong>
						  </cfif>
						  </td>
                          <td width="17%"><strong>Moneda:
                            <input type="text" name="fMnombre" size="20" maxlength="20" value="#fMnombre#">
                          </strong></td>
						  <td width="6%" valign="bottom"><strong>
						    <input type="submit" name="btnFiltrar" value="Filtrar">
                          </strong></td>
					    </tr>
                      </form>
                    </table>
                  </cfoutput>

				<cfquery name="rsFacturas" datasource="#Session.DSN#">

				<!--- Facturas para Impresión--->

				<cfif Url.tipo EQ "I">
					select convert(varchar,a.FCid) as FCid,
						convert(varchar,a.ETnumero) as ETnumero,
						a.Ocodigo,
						a.SNcodigo,
						convert(varchar,a.Mcodigo) as Mcodigo,
						c.Mnombre,
						a.CCTcodigo,
						a.ETfecha,
						a.ETtotal,
						a.ETestado,
						a.ETnombredoc,
						a.ETobs,
						b.Odescripcion,
						a.ETdocumento,
						a.ETserie,
						convert(varchar,a.ETdocumento) + a.ETserie as Transaccion,
						convert(varchar,a.Usucodigo) as Usucodigo,
						a.Ulocalizacion
					from ETransacciones a, Oficinas b, Monedas c
					where #PreserveSingleQuotes(filtro)#

				<!--- Facturas para Reimpresión--->
				<cfelseif Url.tipo EQ "R">

					select convert(varchar,a.FCid) as FCid,
						convert(varchar,a.ETnumero) as ETnumero,
						a.TIfecha as TIfecha,
						convert(varchar,a.Usucodigo) as Usucodigo,
						a.Ulocalizacion,
						a.TItipo,
						x.ETdocumento,
						x.ETserie,
						convert(varchar,x.ETdocumento) + x.ETserie as Transaccion,
						a.ETdocumentoant,
						a.ETserieant,
						x.Ocodigo,
						x.SNcodigo,
						convert(varchar,x.Mcodigo) as Mcodigo,
						x.CCTcodigo,
						x.ETtotal,
						x.ETestado,
						x.ETnombredoc,
						x.ETobs,
						c.Mnombre,
						b.Odescripcion,
						x.ETnombredoc
					from TImpresas a, ETransacciones x, Oficinas b, Monedas c
					where #PreserveSingleQuotes(filtro)#
					order by convert(int,a.ETnumero)
				</cfif>

				</cfquery>

				<!--- Obtiene la descripcion del tipo de documento --->
				<cffunction name="ObtenerTipo" returntype="query">
					<cfargument name="codigo" type="string" required="true">
					<cfquery name="rs" datasource="#Session.DSN#">
						select CCTcodigo, CCTdescripcion from CCTransacciones
						where CCTcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#codigo#">
					</cfquery>
					<cfreturn #rs#>
				</cffunction>

				<form name="lista" method="post" action="SQLImpresionFacturasFA.cfm?tipo=<cfoutput>#Url.tipo#</cfoutput>">
				<table width="100%" border="0" cellpadding="0" cellspacing="0">
				  <tr class="tituloListas">
					<td width="2%">&nbsp;</td>
					<td width="8%"><div align="center"><strong>Transacci&oacute;n</strong></div></td>
					<td width="10%"><strong>Documento</strong></td>
					<td width="23%"><strong>Tipo</strong></td>
					<td width="19%"><strong>Descripci&oacute;n</strong></td>
					<td width="10%"><strong>Oficina</strong></td>
					<td width="7%"><strong>Fecha</strong></td>
					<td width="9%"><strong>Moneda</strong></td>
					<td width="12%"><div align="right"><strong>Total</strong></div></td>
				  </tr>

				  <cfif rsFacturas.RecordCount GT 0>

					  <cfoutput query="rsFacturas">

					  <cfif Url.tipo EQ "I">
						  <tr <cfif CurrentRow MOD 2>class="listaNon"<cfelse>class="listaPar"</cfif> onMouseOver="style.backgroundColor='##E4E8F3';" onMouseOut="style.backgroundColor='<cfif CurrentRow MOD 2>##FFFFFF<cfelse>##FAFAFA</cfif>';">
							<td nowrap><input type="radio" name="chk"
								value="#FCid#|#ETnumero#|#ETfecha#|#Usucodigo#|#Ulocalizacion#|#ETdocumento#|#ETserie#"
								<cfif CurrentRow EQ 1>checked</cfif>></td>
							<td nowrap >#ETnumero#</td>
							<td nowrap>#Transaccion#</td>
							<td nowrap>#CCTcodigo# - #ObtenerTipo(CCTcodigo).CCTdescripcion#</td>
							<td nowrap>#ETnombredoc#</td>
							<td nowrap>#Odescripcion#</td>
							<td nowrap>#LSDateFormat(ETfecha,'DD/MM/YYYY')#</td>
							<td nowrap>#Mnombre#</td>
							<td nowrap><div align="right">#LSCurrencyFormat(ETtotal,'none')#</div></td>
						  </tr>
					  </cfif>

					  <cfif Url.tipo EQ "R">
						  <tr <cfif CurrentRow MOD 2>class="listaNon"<cfelse>class="listaPar"</cfif> onMouseOver="style.backgroundColor='##E4E8F3';" onMouseOut="style.backgroundColor='<cfif CurrentRow MOD 2>##FFFFFF<cfelse>##FAFAFA</cfif>';">
							<td><input type="radio" name="chk"
								value="#FCid#|#ETnumero#|#TIfecha#|#Usucodigo#|#Ulocalizacion#|#TItipo#|#ETdocumento#|#ETserie#|#ETdocumentoant#|#ETserieant#"
								<cfif CurrentRow EQ 1>checked</cfif>></td>
							<td>#ETnumero#</td>
							<td>#Transaccion#</td>
							<td>#CCTcodigo# - #ObtenerTipo(CCTcodigo).CCTdescripcion#</td>
							<td>#ETnombredoc#</td>
							<td>#Odescripcion#</td>
							<td>#LSDateFormat(TIfecha,'DD/MM/YYYY')#</td>
							<td>#Mnombre#</td>
							<td><div align="right">#LSCurrencyFormat(ETtotal,'none')#</div></td>
						  </tr>
					  </cfif>

					  </cfoutput>

				  <cfelse>
				      <tr align="center"><td colspan="9">--- NO HAY DATOS ---</td></tr>
				  </cfif>
				  <tr>
					<td colspan="9">&nbsp;</td>
				  </tr>
				  <tr>
					<td colspan="9" align="center">
						<input type="submit" name="Aplicar" value="<cfif Url.tipo EQ "I">Imprimir<cfelseif Url.tipo EQ "R">Reimprimir</cfif>" >
						<input type="reset" name="Limpiar" value="Limpiar" >
					</td>
					</tr>
				</table>
				</form>
	<cf_web_portlet_end>
<cf_templatefooter>