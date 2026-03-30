<!---------
	Creado por: Ana Villavicencio
	Fecha de creación: 17 de mayo del 2005
	Motivo:	Reporte de impresión de documentos conciliados.

	Modificado por Gustavo Fonseca H.
		Fecha: 8-2-2006.
		Motivo: Se incluye un iframe para que el tag de impresión no tenga que abrir otra ventana con la misma información.

	Modificado por: Ana Villavicencio
	Fecha: 27 de octubre del 2005
	Motivo: Agregar datos de banco, estado de cuenta  y descripcion del tipo de reporte a imprimir
----------->

<!----
		Modificado por Hector Garcia Beita
		Motivo: validador para la redirección en caso de ser invocada desde la 
		opcion de conciliacion bancaria de el modulo de tarjetas de
		credito empresariales mediante un include
--->

<cfset LvarIrARConciliApply="Conciliacion-Apply.cfm">
<cfset LvarIrARPresumConci="/sif/mb/Reportes/RPresumenConciliacion.cfm">
<cfset LvarCBesTCE=0><!---Filtro para los querys TCE o CuentasBancarias--->
<cfif isdefined("LvarTCERPresumenConci")>
	<cfset LvarIrARConciliApply="TCEConciliacion-Apply.cfm">
 	<cfset LvarIrARPresumConci="/sif/tce/Reportes/TCERPresumenConciliacion.cfm">
  	<cfset LvarCBesTCE=1><!---Filtro para los querys TCE o CuentasBancarias--->
</cfif>


<cfif isdefined('url.ECid')>
	<cfset form.ECid = url.ECid>
</cfif>
<cfif isdefined('url.Tipo')>
	<cfset form.Tipo = url.Tipo>
</cfif>


<cfset vparams ="">
<cfset vparams = vparams & "&ECid=" & form.ECid & "&Tipo=" & form.Tipo >

<cfparam name="PageNum_rsLibrosConciliados" default="1">
<cfparam name="PageNum_rsBancosConciliados" default="1">

<!---****************** Consultas Encabezado 				******************--->

<cfquery name="rsEncabezado" datasource="#Session.DSN#">
	select CBdescripcion, CBcodigo, Bdescripcion, a.ECdescripcion
	from ECuentaBancaria a 
		inner join CuentasBancos cb
			inner join Bancos b
			on b.Bid = cb.Bid
		on a.CBid = cb.CBid
	where a.ECid = #form.ECid#
		and cb.CBesTCE = #LvarCBesTCE#
</cfquery>


<cfquery name="rsEmpresa" datasource="#session.DSN#">
	select Edescripcion from Empresas
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
</cfquery>	
<!---****************** Consultas Detalle ******************--->
<cfquery name="rsLibrosConciliados" datasource="#Session.DSN#">
	select CDLfecha as FechaLibros, a.*, c.BTcodigo
	from CDLibros a
		inner join MLibros b
		on b.MLid = a.MLid
		inner join BTransacciones c
		on c.BTid = a.CDLidtrans
	where a.ECid = #Form.ECid#
	  and a.CDLconciliado = 'S'
	<cfif isdefined('form.Tipo') and Form.Tipo EQ 0>
	  and a.CDLmanual = 'S'
	</cfif>
	<cfif isdefined('form.Tipo') and Form.Tipo EQ 1>
	  and a.CDLmanual = 'N'
	</cfif>
	order by a.CDLgrupo desc, a.CDLmonto
</cfquery>
<cfquery name="rsBancosConciliados" datasource="#Session.DSN#">
	select CDBfechabanco as FechaBancos, a.* , b.BTEcodigo
	from CDBancos a
		inner join TransaccionesBanco b 
		on b.Bid = a.Bid 
	   and b.BTEcodigo = a.BTEcodigo
	where a.ECid = #Form.ECid#
	  and a.CDBconciliado = 'S'
	<cfif isdefined('form.Tipo') and Form.Tipo EQ 0>
	  and a.CDBmanual = 'S'
	</cfif>
	<cfif isdefined('form.Tipo') and Form.Tipo EQ 1>
	  and a.CDBmanual = 'N'
	</cfif>
	order by a.CDBgrupo desc, a.CDBmonto
</cfquery>

	<cfset cont1 = 0><cfset cont2 = 0><cfset tiraLibros = ""><cfset tiraBancos = "">
	<cfloop query="rsLibrosConciliados" startrow="1" endrow="#rsLibrosConciliados.RecordCount#">
			<cfset tiraLibros = tiraLibros & "#rsLibrosConciliados.BTcodigo#|#rsLibrosConciliados.ECid#|#rsLibrosConciliados.CDLgrupo#|#Replace(Replace(rsLibrosConciliados.CDLdocumento, "|", "1","All"), ",", " ", "All")#|#LSDateFormat(rsLibrosConciliados.FechaLibros, 'dd/mm/yyyy')#|#rsLibrosConciliados.CDLtipomov#|#rsLibrosConciliados.CDLmonto#|#rsLibrosConciliados.CDLgrupo#" & ",">
			<cfset cont1 = cont1 + 1>		
	</cfloop><cfloop query="rsBancosConciliados" startrow="1" endrow="#rsBancosConciliados.RecordCount#">
			<cfset tiraBancos = tiraBancos & "#rsBancosConciliados.BTEcodigo#|#rsBancosConciliados.ECid#|#rsBancosConciliados.CDBgrupo#|#Replace(Replace(rsBancosConciliados.CDBdocumento, "|", "1","All"), ",", " ", "All")#|#LSDateFormat(rsBancosConciliados.FechaBancos, 'dd/mm/yyyy')#|#rsBancosConciliados.CDBtipomov#|#rsBancosConciliados.CDBmonto#|#rsBancosConciliados.CDBgrupo#" & ",">			
			<cfset cont2 = cont2 + 1>
	</cfloop>
	<cfset myArrayLibros = ArrayNew(1)><cfset myArrayLibros = ""><cfset myArrayBancos = ArrayNew(1)><cfset myArrayBancos = "">
	<cfset myArrayLibros = ListtoArray(tiraLibros, ',')><cfset myArrayBancos = ListtoArray(tiraBancos, ',')>
	<cfset MaxRows_rsLibrosConciliados=16><cfset StartRow_rsLibrosConciliados=Min((PageNum_rsLibrosConciliados-1)*MaxRows_rsLibrosConciliados+1,Max(rsLibrosConciliados.RecordCount,1))><cfset EndRow_rsLibrosConciliados=Min(StartRow_rsLibrosConciliados+MaxRows_rsLibrosConciliados-1,rsLibrosConciliados.RecordCount)><cfset TotalPages_rsLibrosConciliados=Ceiling(rsLibrosConciliados.RecordCount/MaxRows_rsLibrosConciliados)><cfset MaxRows_rsBancosConciliados=16><cfset StartRow_rsBancosConciliados=Min((PageNum_rsBancosConciliados-1)*MaxRows_rsBancosConciliados+1,Max(rsBancosConciliados.RecordCount,1))><cfset EndRow_rsBancosConciliados=Min(StartRow_rsBancosConciliados+MaxRows_rsBancosConciliados-1,rsBancosConciliados.RecordCount)><cfset TotalPages_rsBancosConciliados=Ceiling(rsBancosConciliados.RecordCount/MaxRows_rsBancosConciliados)>
	
	<link href="/cfmx/plantillas/login02/sif_login02.css" rel="stylesheet" type="text/css">

		<cfif not isdefined("url.imprimir")>
			<cf_htmlReportsHeaders 
			title="" 
			filename="ResumenConsiliasion#session.usucodigo#.xls"
			irA="javascript:history.back();"
			download="yes"
			preview="no"
		>
		</cfif>
		<cfoutput>
		<table  width="100%"  align="center" border="0">
			<tr><td align="center"><font size="4"><strong>#rsEmpresa.Edescripcion#</strong></font></td></tr>
			<tr><td align="center"><font size="3"><strong>Resumen de Conciliaci&oacute;n Bancaria </strong></font></td></tr>
			<tr>
				<td align="center">
					<span style="font-size:12px">
						<strong>
							<cfif form.Tipo EQ 0>Documentos Conciliados Manualmente
							<cfelseif form.Tipo EQ 1>Documentos Conciliados Autom&aacute;ticamente
							<cfelseif form.Tipo EQ 2>Documentos Conciliados</cfif>
							
						</strong>
					</font>
				</td>
			</tr>
			<tr><td align="right"><strong>Fecha:&nbsp;#LSDateFormat(Now(),'dd/mm/yyyy')#</strong></font></td></tr>
			<tr>
				<td align="center">
					<table width="60%" align="center" cellpadding="0" cellspacing="0" border="0">
						<tr>
							<td align="right"><span style="font-size:12px"><strong>Banco:&nbsp;</strong></span></td>
							<td><span style="font-size:12px">#rsEncabezado.Bdescripcion#</span></td>
						</tr>
						<tr>
							<td align="right"><span style="font-size:12px"><strong>Cuenta:&nbsp;</strong></span></td>
							<td><span style="font-size:12px">#rsEncabezado.CBdescripcion#&nbsp;&nbsp;&nbsp;&nbsp;#rsEncabezado.CBcodigo#</span></td>
						</tr>
						<tr>
							<td align="right"><span style="font-size:12px"><strong>Estado de Cuenta:&nbsp;</strong></span></td>
							<td><span style="font-size:12px">#rsEncabezado.ECdescripcion#</span></td>
						</tr>
					</table>
				</td>
			</tr>
		</table>
		</cfoutput>
		<table width="100%" cellpadding="2" cellspacing="0">
			<tr>
				<td width="85%" valign="top">
				
						<!---redireccion Conciliacion-Apply.cfm o TCEConciliacion-Apply.cfm--->
						<form method="post" name="form1" action="<cfoutput>#LvarIrARConciliApply#</cfoutput>">
						  <input name="ECid" type="hidden" value="<cfif isDefined("Form.ECid") and Form.ECid NEQ ""><cfoutput>#Form.ECid#</cfoutput></cfif>">
						  <table width="100%" border="0" cellpadding="0" cellspacing="0">
							  <tr>
							    <td colspan="2">&nbsp;</td>
						    </tr>
							  <td class="tituloListas" align="center" valign="top">LIBROS</td>
							  <td class="tituloListas" align="center" > BANCOS</td>
							</tr>
							<tr> 
							  <td width="48%" align="center" valign="top"> 
							  	<table width="100%" border="0" cellspacing="0" cellpadding="0">
								 
								  <tr class="subTitulo"> 
								  	<td bgcolor="#E2E2E2"><strong>No. Agrupamiento</strong></td>
									<td bgcolor="#E2E2E2"><strong>Documento</strong></td>
									<td bgcolor="#E2E2E2"><strong>Tipo</strong></td>
									<td bgcolor="#E2E2E2"><strong>Fecha</strong></td>
									<td bgcolor="#E2E2E2"><div align="center"><strong>Monto</strong></div></td>
								  </tr>
								  <cfoutput> 
									<cfset cuantosRegLibros = "#ArrayLen(myArrayLibros)#">
									<cfset cuantosManualesLibros = 0>
									<cfset CountVar = 1>
									<cfloop condition = "CountVar LESS THAN OR EQUAL TO #cuantosRegLibros#">
									  <cfset valores = listtoArray(myArrayLibros[CountVar],"|")>
									  <tr <cfif CountVar MOD 2>class="listaNon"<cfelse>class="listaPar"</cfif>> 
									  	<td>&nbsp;#valores[8]#&nbsp;</td>
										<td>&nbsp;#valores[4]#</td>
										<td>#valores[1]#</td>
										<td><cfif Len(Trim(valores[5]))>#LSDateFormat(valores[5],'DD/MM/YYYY')#<cfelse>&nbsp;</cfif></td>
										<td><div align="right"><cfif Len(Trim(valores[7]))>#LSCurrencyFormat(valores[7],"none")#<cfelse>&nbsp;</cfif></div></td>
									  </tr>
									  <cfset CountVar = CountVar + 1>
									</cfloop>
								  </cfoutput> </table></td>
							  <td width="51%" valign="top"> 
							  <table width="100%" border="0" cellspacing="0" cellpadding="0">
								  <tr class="subTitulo"> 
								  	<td>&nbsp;</td>
									<td bgcolor="#E2E2E2"><strong>No. Agrupamiento</strong></td>
									<td bgcolor="#E2E2E2"><strong>Documento</strong></td>
									<td bgcolor="#E2E2E2"><strong>Tipo</strong></td>
									<td bgcolor="#E2E2E2"><strong>Fecha</strong></td>
									<td bgcolor="#E2E2E2"><div align="center"><strong>Monto</strong></div></td>
								  </tr>
								  <cfoutput> 
									<cfset cuantosRegBancos = "#ArrayLen(myArrayBancos)#">
									<cfset cuantosManualesBancos = 0>
									<cfset CountVar = 1>
									<cfloop condition = "CountVar LESS THAN OR EQUAL TO #cuantosRegBancos#">
									  <cfset valores = listtoArray(myArrayBancos[CountVar],"|")>
									  <tr <cfif CountVar MOD 2>class="listaNon"<cfelse>class="listaPar"</cfif>> 
									  	<td>&nbsp;</td>
										<td>&nbsp;#valores[8]#&nbsp;</td>
										<td>&nbsp;#valores[4]#</td>
										<td>#valores[1]#</td>
										<td><cfif Len(Trim(valores[5]))>#LSDateFormat(valores[5],'DD/MM/YYYY')#<cfelse>&nbsp;</cfif></td>
										<td><div align="right"><cfif Len(Trim(valores[7]))>#LSCurrencyFormat(valores[7],"none")#<cfelse>&nbsp;</cfif></div></td>
									  </tr>
									  <cfset CountVar = CountVar + 1>
									</cfloop>
								  </cfoutput>
								  </table>
								</td>
							</tr>
							<tr> 
							  <td colspan="2">&nbsp;</td>
							</tr>
						  </table>
						</form>
				</td>
			</tr>
		</table>
		<table width="100%" align="center">
			<cfif isdefined("url.imprimir")>
				<tr><td><h6>&nbsp;</h6></td></tr>
				<tr align="center"><td> --------------------------- Fin del Reporte --------------------------- </td></tr>
			</cfif>
		</table>