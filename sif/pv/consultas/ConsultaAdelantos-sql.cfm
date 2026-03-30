<cfset CurrentPage=GetFileFromPath(GetTemplatePath())>
<cfset LvarMaxRegistros = 20000>
<cfset LvarMaxLineasPDF = 3000>
<cfif not isdefined("url.chkSaldos")>
	<cfset url.chkSaldos = 0>
</cfif>
<cf_navegacion name="CDCcodigo" session>
<cf_navegacion name="FAX14DOC" session>
<cf_navegacion name="FAX14FEC_ini" session>
<cf_navegacion name="FAX14FEC_fin" session>
<cf_navegacion name="chkSaldos" session>
<cf_navegacion name="FAM01CODD" session>
<cf_navegacion name="Ocodigo" session>
<cf_navegacion name="Formato" session>

<cfquery name="rsCantidad" datasource="#session.dsn#">
	select count(1) as Cantidad
	from FAX014 as B
		inner join FAX001 as A
		on  A.FAX01NTR = B.FAX01NTR

		inner join FAM001 as D     <!--- cajas --->
				inner join Oficinas as H <!--- Oficinas --->
				on H.Ocodigo = D.Ocodigo
				and H.Ecodigo = D.Ecodigo
		on D.FAM01COD = B.FAM01COD
		and D.Ecodigo = B.Ecodigo

	where B.Ecodigo = #session.Ecodigo#
	  and B.FAX14CLA in ('1','2')
	  and A.FAX01STA IN ('T', 'C') and A.FAX01TIP in ('9', '4') and A.FAX01TPG = 0
	  
	<!--- FILTRO DE CLIENTE --->
	<cfif isdefined("url.CDCcodigo") and len(trim(url.CDCcodigo))>
		and B.CDCcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.CDCcodigo#">
	</cfif>
	
	<cfif isdefined("url.FAX14DOC") and len(trim(url.FAX14DOC))>
		and B.FAX14DOC like '%#url.FAX14DOC#%'
	</cfif>

	<!--- FILTRO DE Fecha inicial --->
	<cfif isdefined("url.FAX14FEC_ini") and len(trim(url.FAX14FEC_ini))>
		and B.FAX14FEC >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(url.FAX14FEC_ini)#">
	</cfif>		

	<!--- FILTRO DE Fecha final --->
	<cfif isdefined("url.FAX14FEC_fin") and len(trim(url.FAX14FEC_fin))>
		and B.FAX14FEC <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#DateAdd('s', -1, DateAdd('d', 1, LSParseDateTime(url.FAX14FEC_fin)))#">
	</cfif>	
	
	<cfif isdefined("url.chkSaldos") and len(trim(url.chkSaldos)) and url.chkSaldos neq 0>
		and B.FAX14MON - B.FAX14MAP > 0.00
	</cfif>
	
	<!--- FILTRO DE CAJA --->
	<cfif isdefined("url.FAM01CODD") and len(trim(url.FAM01CODD))>
		and D.FAM01CODD = <cfqueryparam cfsqltype="cf_sql_char" value="#url.FAM01CODD#">
	</cfif>
	<!--- FILTRO DE OFICINA --->
	<cfif isdefined("url.Ocodigo") and len(trim(url.Ocodigo))>
		and D.Ocodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.Ocodigo#">
	</cfif>
</cfquery>

<cfif rsCantidad.Cantidad GT LvarMaxRegistros or rsCantidad.Cantidad EQ 0>
	<cfsavecontent variable="pNavegacion">
	<cfinclude template="/sif/portlets/pNavegacion.cfm">
	</cfsavecontent>

	<cfif rsCantidad.Cantidad GT LvarMaxRegistros>
		<cf_templateheader title="#nav__SPdescripcion#">
				<cf_web_portlet_start titulo="<cfoutput>#nav__SPdescripcion#</cfoutput>"> 
					<cfoutput>#pNavegacion#</cfoutput>
					<table width="100%" border="0" cellspacing="0" cellpadding="0">
					  <tr>
						<td>&nbsp;</td>
					  </tr>
					  <tr>
						<td align="center"><strong>La cantidad de registros generada sobrepasa el l&iacute;mite fijado para este reporte. Debe agregar más filtros a la consulta.</strong></td>
					  </tr>
					  <tr>
						<td>&nbsp;</td>
					  </tr>
					  <tr>
						<td align="center">
							<input type="button" class="btnAnterior" value="Regresar" onclick="javascript: location.href = 'ConsultaAdelantos.cfm';"/>
						</td>
					  </tr>
					  <tr>
						<td>&nbsp;</td>
					  </tr>
					</table>
				<cf_web_portlet_end>
		<cf_templatefooter>
	<cfelseif rsCantidad.Cantidad EQ 0>
		<cf_templateheader title="#nav__SPdescripcion#">
			<cf_web_portlet_start titulo="<cfoutput>#nav__SPdescripcion#</cfoutput>"> 
				<cfoutput>#pNavegacion#</cfoutput>
				<table width="100%" border="0" cellspacing="0" cellpadding="0">
				  <tr>
					<td>&nbsp;</td>
				  </tr>
				  <tr>
					<td align="center"><strong>La consulta no gener&oacute; registros.</strong></td>
				  </tr>
				  <tr>
					<td>&nbsp;</td>
				  </tr>
				  <tr>
					<td align="center">
						<input type="button" class="btnAnterior" value="Regresar" onclick="javascript: location.href = 'ConsultaAdelantos.cfm';"/>
					</td>
				  </tr>
				  <tr>
					<td>&nbsp;</td>
				  </tr>
				</table>
			<cf_web_portlet_end>
		<cf_templatefooter>
	</cfif>
	<cfabort>
</cfif>

<!--- DETERMINA EL TIPO DE FORMATO EN QUE SE RELAIZARA EL REPORTE --->
<cfset formatos = "tabular">
<cfif isdefined("url.Formato") and len(trim(url.Formato)) and url.Formato EQ 'flashpaper'>
	<cfset formatos = "flashpaper">
<cfelseif isdefined("url.Formato") and len(trim(url.Formato)) and url.Formato EQ 'pdf'>
	<cfset formatos = "pdf">
<cfelseif isdefined("url.Formato") and len(trim(url.Formato)) and url.Formato EQ 'HTML'>
	<cfset formatos = "html">
</cfif>

<cfif rsCantidad.Cantidad GT LvarMaxLineasPDF and (formatos NEQ "html" and formatos NEQ "tabular")>
	<cfset formatos = "tabular">
</cfif>

<cfset fnGeneraQuery(formatos)>

<cfif formatos NEQ "html" and formatos NEQ "tabular">
	<!--- INVOCA EL REPORTE --->
	<cfreport format="#formato#" template= "ConsultaAdelantosCliente.cfr" query="rsReporte">
		<cfreportparam name="Ecodigo" value="#session.Ecodigo#">
		<cfreportparam name="Edescripcion" value="#session.Enombre#">
	</cfreport>
	<cfabort>
</cfif>

<!--- Pintar el reporte en una tabla del sistema --->
<cfif formatos EQ 'html'>
	<cfinclude template="ConsultaAdelantos_HTML.cfm">
</cfif>
<cfif formatos EQ "tabular">
	<cfinclude template="ConsultaAdelantos_Tabular.cfm">
</cfif>

<cffunction name="fnGeneraQuery" access="private" output="no">
	<cfargument name="TipoFormato" type="string" required="yes">

	<cfinclude template="../../Utiles/sifConcat.cfm">
	<cfquery name="rsReporte" datasource="#session.DSN#" maxrows="#LvarMaxRegistros + 1#">
		select 
			<cfif Arguments.TipoFormato EQ "tabular">
				E.CDCidentificacion as Cedula, ltrim(rtrim(E.CDCnombre)) as Cliente,
			<cfelse>
				ltrim(rtrim(E.CDCidentificacion)) #_Cat# ' - ' #_Cat# ltrim(rtrim(E.CDCnombre)) as Cliente,
				ltrim(rtrim(E.CDCidentificacion)) #_Cat# ' - ' #_Cat# ltrim(rtrim(E.CDCnombre)) #_Cat# ' ' #_Cat# rtrim(G.Miso4217) as agrupador,
				B.CDCcodigo as CodigoClienteInterno,
				B.FAX01NTR as NoTransaccion,
				B.FAX14CON as Consecutivo,
			</cfif>
			rtrim(G.Miso4217) as CodigoMoneda,
			B.FAX14DOC as Documento,
			rtrim(B.FAX14TDC) #_Cat# rtrim(' ' #_Cat# K.CodInterno) as TipoDoc,
			B.FAX14FEC 			 as FechaFactura,
			rtrim(H.Oficodigo) 	 as Oficina, 
			rtrim(D.FAM01CODD) 	 as CodigoCaja, 
			B.FAX14MON			 as TotalLinea,
			B.FAX14MAP			 as Aplicado,
			B.FAX14MON - B.FAX14MAP as Saldo
		from FAX014 as B <!--- Adelantos --->
	
			inner join FAX001 as A
				on  A.FAX01NTR = B.FAX01NTR
	
			inner join ClientesDetallistasCorp as E <!---  clientes --->
				on E.CDCcodigo = B.CDCcodigo
		
			inner join Monedas as G <!--- monedas --->
				on G.Mcodigo = B.Mcodigo
			
			inner join FAM001 as D     <!--- cajas --->
					inner join Oficinas as H <!--- Oficinas --->
					on H.Ocodigo = D.Ocodigo
					and H.Ecodigo = D.Ecodigo
			on D.FAM01COD = B.FAM01COD
			and D.Ecodigo = B.Ecodigo
		
			left outer join FATiposAdelanto K
				on K.IdTipoAd = B.IdTipoAd
		
		where B.Ecodigo = #session.Ecodigo#
		  and B.FAX14CLA in ('1','2')
		  and A.FAX01STA IN ('T', 'C') and A.FAX01TIP in ('9', '4') and A.FAX01TPG = 0

		<!--- FILTRO DE CLIENTE --->
		<cfif isdefined("url.CDCcodigo") and len(trim(url.CDCcodigo))>
			and B.CDCcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.CDCcodigo#">
		</cfif>

		<cfif isdefined("url.FAX14DOC") and len(trim(url.FAX14DOC))>
			and B.FAX14DOC like '%#url.FAX14DOC#%'
		</cfif>
	
		<!--- FILTRO DE Fecha inicial --->
		<cfif isdefined("url.FAX14FEC_ini") and len(trim(url.FAX14FEC_ini))>
			and B.FAX14FEC >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(url.FAX14FEC_ini)#">
		</cfif>		
	
		<!--- FILTRO DE Fecha final --->
		<cfif isdefined("url.FAX14FEC_fin") and len(trim(url.FAX14FEC_fin))>
			and B.FAX14FEC <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#DateAdd('s', -1, DateAdd('d', 1, LSParseDateTime(url.FAX14FEC_fin)))#">
		</cfif>	
		
		<cfif isdefined("url.chkSaldos") and len(trim(url.chkSaldos)) and url.chkSaldos neq 0>
			and B.FAX14MON - B.FAX14MAP > 0.00
		</cfif>

		<!--- FILTRO DE CAJA --->
		<cfif isdefined("url.FAM01CODD") and len(trim(url.FAM01CODD))>
			and D.FAM01CODD = <cfqueryparam cfsqltype="cf_sql_char" value="#url.FAM01CODD#">
		</cfif>
		<!--- FILTRO DE OFICINA --->
		<cfif isdefined("url.Ocodigo") and len(trim(url.Ocodigo))>
			and D.Ocodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.Ocodigo#">
		</cfif>

		<cfif Arguments.TipoFormato EQ "tabular">
			order by D.FAM01CODD, B.FAX14FEC, B.FAX14DOC
		<cfelse>
			order by ltrim(rtrim(E.CDCidentificacion)) #_Cat# ' - ' #_Cat# ltrim(rtrim(E.CDCnombre)) #_Cat# ' ' #_Cat# rtrim(G.Miso4217), D.FAM01CODD, B.FAX14FEC, B.FAX14DOC
		</cfif>
	</cfquery>
</cffunction>