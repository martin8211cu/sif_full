<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_MontoSolicitado" Default="Monto Solicitado" returnvariable="LB_MontoSolicitado" xmlfile = "Tab2_Gastos.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_NumDoc" Default="N&uacute;m.Doc" returnvariable="LB_NumDoc" xmlfile = "Tab2_Gastos.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Fecha" Default="Fecha" returnvariable="LB_Fecha" xmlfile = "Tab2_Gastos.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Gastos" Default="Gasto" returnvariable="LB_Gastos" xmlfile = "Tab2_Gastos.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_MonedaDoc" Default="Moneda Doc" returnvariable="LB_MonedaDoc"
xmlfile = "Tab2_Gastos.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_AutorizadoDoc" Default="Autorizado<BR>Doc" returnvariable="LB_AutorizadoDoc"
xmlfile = "Tab2_Gastos.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_AutorizadoLiq" Default="Autorizado Liq." returnvariable="LB_AutorizadoLiq" xmlfile = "Tab2_Gastos.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="BTN_Nuevo" Default="Nuevo" returnvariable="BTN_Nuevo" xmlfile = "Tab2_Gastos.xml"/>



<cfif isdefined ('form.GELid')>
	<cf_dbfunction name="to_char_currency" args="(select sum(GELGmontoOri) from GEliquidacionGasto where GELid = a.GELid and GELGnumeroDoc=a.GELGnumeroDoc and GELGproveedor=a.GELGproveedor and coalesce(GELGproveedorId,'*') = coalesce(a.GELGproveedorId,'*'))" returnvariable="LvarTotalDocs">
	<cf_dbfunction name="to_char_currency" args="(select sum(GELGtotalOri) from GEliquidacionGasto where GELid = a.GELid and GELGnumeroDoc=a.GELGnumeroDoc and GELGproveedor=a.GELGproveedor and coalesce(GELGproveedorId,'*') = coalesce(a.GELGproveedorId,'*'))" returnvariable="LvarAutorizado">
	<cf_dbfunction name="concat" args="#LvarTotalDocs# + ' (Autorizado = ' + #LvarAutorizado# + ')'"  delimiters="+" returnvariable="LvarTotal">
	<cfset LvarTotal = "case when #LvarTotalDocs# <> #LvarAutorizado# then #LvarTotal# else #LvarTotalDocs# end">
	<cfquery datasource="#session.dsn#" name="listaDet">
		select
			a.GELGnumeroDoc, a.GELGproveedor,
			<cf_dbfunction name="concat" args="'Factura ' + a.GELGnumeroDoc + ' de ' + a.GELGproveedor + ' por ' + m.Miso4217 + ' ' + #preserveSingleQuotes(LvarTotal)#" delimiters="+"> as CORTE,
			a.GELid,
			a.GELGid,
			a.Mcodigo,
			a.GELGtipoCambio,
			case when a.GELGtotalOri <> a.GELGmontoOri then a.GELGmontoOri end as GELGmontoOri,
			a.GELGtotalOri,
			a.GELGtotal-isnull(a.GELGtotalRet,0) as GELGtotal,
			a.GELGdescripcion,
			a.GELGfecha,
			a.CFcuenta,
			m.Miso4217 as 	Mnombre,
			m.Mcodigo,
			coalesce(c.GECconcepto,i.Icodigo) as GECconcepto,
			coalesce((c.GECconcepto + ' - ' + c.GECdescripcion),i.Idescripcion) as GECdescripcion,
			c.GECid,
			a.Icodigo,
			GELGtotalOri-GELGnoDeducMonto as GELGDeducMonto, GELGnoDeducMonto, GELGnoDeducImpuesto,
			tce.GELTmontoOri,
			1 as Det,
            GELGreferencia
		<cfif LvarSAporComision>
			, #form.GECid_comision# as GECid_comision
		</cfif>
		,CASE WHEN rt.Documento IS NOT NULL
                THEN '<img border=''0'' src=''/cfmx/sif/imagenes/Description.gif''>'
                ELSE ''
			END CFDI
		 from GEliquidacionGasto a
			inner join CFuncional b
				on b.CFid 		= a.CFid
			inner join Monedas m
				on a.Mcodigo= m.Mcodigo
		 	left join GEliquidacionTCE tce
				on tce.GELGid = a.GELGid
		 	left join GEconceptoGasto c
				on c.GECid=a.GECid
		 	left join Impuestos i
				 on i.Ecodigo = a.Ecodigo
				and i.Icodigo = a.Icodigo
			left join (select distinct Documento,ID_Documento from  CERepoTMP
						where Origen = 'TSGS'
			) rt
				on rt.Documento = a.GELGnumeroDoc
				and rt.ID_Documento = a.GELid
		where  a.GELid		= <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.GELid#">
		order by a.GELGnumeroDoc, a.GELGproveedor, a.Icodigo, GELGid
	</cfquery>

	<cfquery dbtype="query" name="rsCortes">
		select
			GELGnumeroDoc, GELGproveedor, count(1) as cantidad
		 from listaDet
		 group by GELGnumeroDoc, GELGproveedor
		having count(1) > 1
	</cfquery>

	<!--- Moneda Local --->
	<cfquery name="rsLiquidacion" datasource="#Session.DSN#">
		select m.Mcodigo, m.Miso4217, a.GELtotalTCE, a.GELtotalGastos, a.GELtotalDocumentos
		  from GEliquidacion a
			inner join Monedas m on m.Mcodigo = a.Mcodigo
		  where a.GELid		= <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.GELid#">
	</cfquery>

	<cfif isdefined("LvarIncluyeForm") and LvarIncluyeForm>
		<cfset LvarIncluyeForm = "yes">
	<cfelse>
		<cfset LvarIncluyeForm = "no">
	</cfif>
	<cfif isdefined("LvarMnombreSP")>
		<cfset LvarMonedaTitulo = "#LB_MontoSolicitado#">
	</cfif>
	<table width="95%" cellpadding="2" align="center" border="0">
		<tr>
			<td align="left" valign="top">
			<cfif rsCortes.recordCount GT 0>
				<cfset LvarCortes = "CORTE">
			<cfelse>
				<cfset LvarCortes = "">
			</cfif>
			<cfif isdefined('form.GELGid') and len(trim(form.GELGid)) OR isdefined("url.NuevoDet") OR isdefined('url.GELGid') and isdefined('url.modoN')>
				<cfinclude template="Tab2_Gastos_form.cfm">
			<cfelse>
				<cfset LvarDesp = "">
				<cfset LvarEtiq = "">
				<cfif rsLiquidacion.GELtotalGastos NEQ rsLiquidacion.GELtotalDocumentos>
					<cfset LvarDesp = "#LvarDesp#,GELGmontoOri,GELGtotalOri">
					<cfset LvarEtiq = "#LvarEtiq#,Monto<BR>Doc,&nbsp;Autorizado<BR>Doc">
				<cfelse>
					<cfset LvarDesp = "#LvarDesp#,GELGtotalOri">
					<cfset LvarEtiq = "#LvarEtiq#,&nbsp;#LB_AutorizadoDoc#">
				</cfif>
				<cfif rsLiquidacion.GELtotalTCE GT 0>
					<cfset LvarDesp = "#LvarDesp#,GELTmontoOri">
					<cfset LvarEtiq = "#LvarEtiq#,&nbsp;con&nbsp;TCE<BR>Doc">
				</cfif>
				<cfquery name="rsSQL" datasource="#session.dsn#">
					select count(1) as cantidad
					  from GEliquidacionGasto
					 where GELid		 	= <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.GELid#">
					   and GELGnoDeducMonto > 0
				</cfquery>
				<cfif rsSQL.cantidad GT 0>
					<cfset LvarDesp = "#LvarDesp#,GELGDeducMonto,GELGnoDeducMonto,GELGnoDeducImpuesto,CFDI">
					<cfset LvarEtiq = "#LvarEtiq#,&nbsp;Deducible<BR>Doc,&nbsp;No&nbsp;Deduc<BR>Doc,&nbsp;Impuesto<BR>No&nbsp;Deduc">
				</cfif>
				<cfinvoke component="sif.Componentes.pListas" method="pListaQuery"
					query="#listaDet#"
					cortes = "#LvarCortes#"
					desplegar="CFDI,GELGnumeroDoc,GELGfecha,GECdescripcion,Mnombre#LvarDesp#,GELGtotal"
					etiquetas="  ,#LB_NumDoc#,#LB_Fecha#,#LB_Gastos#,#LB_MonedaDoc##LvarEtiq#,&nbsp;#LB_AutorizadoLiq#&nbsp;#rsLiquidacion.Miso4217#"
					formatos="S,S,D,S,S,M,M,M,M,M,M,M"
					align="right,center,left,center,right,right,right,right,right,right,right,center"
					ira="LiquidacionAnticipos#LvarSAporEmpleadoSQL#.cfm?tab=2&tipo=#LvarSAporEmpleadoSQL#"
					form_method="post"
					showEmptyListMsg="yes"
					keys="GELGid,GECid"
					showLink="yes"
					maxRows="15"
					formName="lista_gastos"
					PageIndex="22"
					UsaAjax="true"
					conexion="#session.dsn#"
				/>
				<table width="100%" border="0">
				  <tr><td align="center">
					<form name="formRedirec" method="post" action="<cfoutput>LiquidacionAnticipos_sql.cfm?tipo=#LvarSAporEmpleadoSQL#</cfoutput>" style="margin: '0' ">
						<input name="NuevoDet" type="submit" value="<cfoutput>#BTN_Nuevo#</cfoutput>" tabindex="2">
						<input name="GELid" type="hidden" value="<cfoutput>#form.GELid#</cfoutput>">
					</form>
				  </td></tr>
				 </table>
			</cfif>
			</td>
		</tr>
	</table>
	</cfif>
