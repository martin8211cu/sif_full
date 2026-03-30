<cfif isdefined ('form.GELid')>
	<cfquery datasource="#session.dsn#" name="listaDet">
		select 
			a.GELid,
			a.GELGid,
			a.GELGnumeroDoc,
			a.Mcodigo,
			a.GELGtipoCambio,
			a.GELGmontoOri, 
			a.GELGtotalOri, 
			a.GELGtotal, 
			a.GELGdescripcion,
			a.GELGfecha,
			a.CFcuenta,
			m.Miso4217 as 	Mnombre,
			m.Mcodigo,
			c.GECdescripcion,
			c.GECconcepto,
			c.GECid, 
			1 as Det
		<cfif LvarSAporComision>
			, #form.GECid_comision# as GECid_comision
		</cfif>
		 from GEliquidacionGasto a,GEconceptoGasto c,CFuncional b, Monedas m
		where  a.GELid		= <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.GELid#">
			and c.GECid=a.GECid
			and   b.CFid 		= a.CFid
			and  a.Mcodigo= m.Mcodigo
	
	</cfquery>

	<!--- Moneda Local --->
	<cfquery name="rsMonedaLocal" datasource="#Session.DSN#">
		select m.Mcodigo, m.Miso4217
		  from Empresas e
			inner join Monedas m on m.Mcodigo = e.Mcodigo
		  where e.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#"> 	
	</cfquery>
	
	<cfif isdefined("LvarIncluyeForm") and LvarIncluyeForm>
		<cfset LvarIncluyeForm = "yes">
	<cfelse>
		<cfset LvarIncluyeForm = "no">
	</cfif>
	<cfif isdefined("LvarMnombreSP")>
		<cfset LvarMonedaTitulo = "Monto Solicitado">
	</cfif>
	<table width="80%" cellpadding="5" align="center" border="0">
		<tr>
			<td align="left" valign="top">
			<cfif isdefined('form.GELGid') and len(trim(form.GELGid)) OR isdefined("url.NuevoDet")>
				<cfinclude template="LiquidacionAnticiposDet_form.cfm">	
			<cfelse>
				<cfinvoke component="sif.Componentes.pListas" method="pListaQuery"
					query="#listaDet#"
					desplegar="GELGnumeroDoc,GELGfecha,GECconcepto,GECdescripcion,Mnombre,GELGmontoOri,GELGtotalOri,GELGtotal"
					etiquetas="Num.Doc,Fecha.Doc,C&oacute;digo Concepto,Descripci&oacute;n Concepto,Moneda,Monto<BR>Documentos,Monto<BR>Autorizado,Autorizado<BR>#rsMonedaLocal.Miso4217#"
					formatos="S,D,S,S,S,M,M,M"
					align="center,left,center,left,center,right,right,right"
					ira="LiquidacionAnticipos#LvarSAporEmpleadoSQL#.cfm?tab=2&tipo=#LvarSAporEmpleadoSQL#"
					form_method="post"	
					showEmptyListMsg="yes"
					keys="GELGid,GECid"
					showLink="yes"
					maxRows="5"
					formName="lista_gastos"
					PageIndex="4"
					UsaAjax="true"
					conexion="#session.dsn#"
				/>	
				<table width="100%" border="0">
				  <tr><td align="center">  
					<form name="formRedirec" method="post" action="<cfoutput>LiquidacionAnticipos_sql.cfm?tipo=#LvarSAporEmpleadoSQL#</cfoutput>" style="margin: '0' ">
						<input name="NuevoDet" type="submit" value="Nuevo" tabindex="2">
						<input name="GELid" type="hidden" value="<cfoutput>#form.GELid#</cfoutput>">
					</form>  
				  </td></tr>    
				 </table>
			</cfif>
			</td>
		</tr>
	</table>
	</cfif>
