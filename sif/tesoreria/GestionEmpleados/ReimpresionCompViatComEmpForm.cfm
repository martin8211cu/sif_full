
<cf_templateheader title="Reimpresión Comprobación  de Viaticos por Comision a Empleados">
<cfinclude template="/sif/portlets/pNavegacion.cfm">
<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Reimpresión Comprobación  de Viaticos por Comision a Empleados'>
<cf_dbfunction name="op_concat" returnvariable="LvarCNCT">
<cfset LvarCortes = "">
<cfquery  name="rsCajaChica" datasource="#session.dsn#">
	select 
			CCHid,
			CCHdescripcion,
			CCHcodigo
	from CCHica
	where Ecodigo=#session.Ecodigo#
	and CCHestado='ACTIVA'
</cfquery>
<table width="100%" border="0" cellspacing="6">
	<tr>
		<td width="50%" valign="top">
		<form name="formFiltro" method="post" action="ImprComprobanteComision.cfm" style="margin: '0' ">
		<table class="areaFiltro" width="100%"  border="0" cellpadding="0" cellspacing="0">
			<tr>
<!---FILTRO DE CENTRO FUNCIONAL--->
				<td nowrap align="right">
					<strong>Centro Funcional:</strong>
				</td>
				<td nowrap>	
					<cf_cboCFid form="formFiltro" todos="yes">
					<cfset form.CFid_F = session.Tesoreria.CFid>
				</td>
<!---FILTRO DE SOLICITANTE--->
				<td nowrap align="right">
					<strong>Solicitante:</strong>
				</td>
				<td colspan="2">				
					<cfif isdefined ('form.Usucodigo') and len(trim(form.Usucodigo)) gt 0>
						<cfinclude template="../../Utiles/sifConcat.cfm">
							<cfquery name="rsSQL" datasource="#session.dsn#">
								select u.Usucodigo, u.Usulogin
								, dp.Pnombre #LvarCNCT# ' ' #LvarCNCT# dp.Papellido1 #LvarCNCT# ' ' #LvarCNCT# dp.Papellido2 as Usunombre
								from Usuario u 
								inner join DatosPersonales dp
								on dp.datos_personales = u.datos_personales
								where Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Usucodigo#">
							</cfquery>
						<cf_sifusuario conlis="true" size="20" form="formFiltro" query="#rsSQL#">	
					<cfelse>
						<cf_sifusuario conlis="true" size="20" form="formFiltro">
					</cfif>
				</td>
			</tr>										
			<tr>	
<!---FILTRO DE EMPLEADO--->
				<td nowrap align="right">
					<strong>Empleado:</strong></td>
				<td nowrap>	
					<cfif isdefined('form.DEid') and len(trim(form.DEid)) and form.DEid NEQ "">					
						<cf_rhempleados form="formFiltro" tabindex="1" DEid="DEid" Usucodigo="Usucodigo2" idempleado="#form.DEid#">
					<cfelse>
						<cf_rhempleados form="formFiltro" tabindex="1" DEid="DEid" Usucodigo="Usucodigo2">
					</cfif>					
				</td>			
<!---FILTRO DE FECHA--->				
				<td nowrap align="right"><strong>Fecha:</strong></td>
				<td colspan="2">
					<table cellpadding="0" cellspacing="0" border="0">
						<tr>
							<td nowrap valign="middle">
								<cfif isdefined ('form.TESSPfechaPago_I')>
									<cf_sifcalendario form="formFiltro" value="#form.TESSPfechaPago_I#" name="TESSPfechaPago_I" tabindex="1">											  					  	
								<cfelse>
									<cf_sifcalendario form="formFiltro" value="" name="TESSPfechaPago_I" tabindex="1">
								</cfif>
							</td>
							<td nowrap align="right" valign="middle">
								<strong>&nbsp;Hasta:</strong>
							</td>
							<td nowrap valign="middle">
								<cfif isdefined ('form.TESSPfechaPago_F')>
									<cf_sifcalendario form="formFiltro" value="#form.TESSPfechaPago_F#" name="TESSPfechaPago_F" tabindex="1">									 						
								<cfelse>
									<cf_sifcalendario form="formFiltro" value="" name="TESSPfechaPago_F" tabindex="1">
								</cfif>
							</td>						
						</tr>
					</table>
				</td>
			</tr>		
			<tr>
<!---FILTRO DE NU. ANTICIPO o LIQUIDACIÓN--->
				<td nowrap align="right"><strong><cfoutput>Num.Liquidación:</cfoutput></strong></td>
				<td nowrap>
					<input type="text" name="numAnti" />
				</td>							
<!---FILTRO DE MONEDA--->				
				<td nowrap align="right">
					<strong>Moneda</strong>
				</td>
				<td colspan="2">
					<cfquery name="rsMonedas" datasource="#session.DSN#">
						select Mcodigo, Mnombre
						  from Monedas m 
						  where m.Ecodigo = #session.Ecodigo#
					</cfquery>	
					<select name="McodigoOri_F" tabindex="1" onchange="this.form.submit();">
						<option value="">(Todas las monedas)</option>
						<cfoutput query="rsMonedas">
						<option value="#Mcodigo#" <cfif isdefined('form.McodigoOri_F') and len(trim(form.McodigoOri_F)) and form.McodigoOri_F EQ Mcodigo>selected</cfif>>#Mnombre#</option>
						</cfoutput>
					</select>	
				</td>
			</tr>

<!---FILTRO FORMA DE PAGO--->				
	<td nowrap align="right">
		<strong>Forma de Pago</strong>
	</td>
	<td colspan="2">
		<select name="FormaPago" id="FormaPago">
				<option value="">--</option>
				<option value="0"<cfif isdefined ('form.FormaPago') and len(trim(form.FormaPago)) gt 0 and form.FormaPago eq 0>selected="selected"</cfif>>Tesoreria </option>
				<cfif rsCajaChica.RecordCount>
					<cfoutput query="rsCajaChica" group="CCHid">
						<option value="#rsCajaChica.CCHid#"<cfif isdefined ('form.FormaPago') and len(trim(form.FormaPago)) gt 0 and form.FormaPago neq 0 and form.FormaPago eq rsCajaChica.CCHid>selected="selected"</cfif>>#rsCajaChica.CCHcodigo#-#rsCajaChica.CCHdescripcion#</option>
					</cfoutput>
				</cfif>                       
		</select>
	</td>
</tr>
<!---FILTRAR--->		
			<tr>
				<td ></td>
				<td >
				<div align="right">
						 <input name="btnFiltrar" type="submit" id="btnFiltrar" value="Filtrar" tabindex="2" />				   
					 </div>
				</td>
			</tr>
		</table>
		
<cfquery datasource="#session.dsn#" name="lista" maxrows="300">
		select 
			GELid,
			GELdescripcion,
			GELfecha,
			GELmsgRechazo, 
			<!---Centro Funcional--->
			GELnumero,
			GECnumero,
			( 
				select rtrim(o.Oficodigo) #LvarCNCT# ':' #LvarCNCT# cf.CFcodigo
				from CFuncional cf 
				inner join Oficinas o on o.Ecodigo = cf.Ecodigo and o.Ocodigo = cf.Ocodigo 
				where cf.CFid = ant.CFid
			) as CFcodigo,
			<!---Empleado--->
			(	
				select Em.DEnombre #LvarCNCT# ' ' #LvarCNCT# Em.DEapellido1 #LvarCNCT# ' ' #LvarCNCT# Em.DEapellido2
				from DatosEmpleado Em,TESbeneficiario te
				where ant.TESBid=te.TESBid and   Em.DEid=te.DEid  
			) as Empleado,			
			<!---Moneda--->
			(
				select Mo.Miso4217
				from Monedas Mo
				where ant.Mcodigo=Mo.Mcodigo
			)as Moneda,
			GELtotalGastos,
			case ant.GELtipoP
				when 0 then 'Caja Chica'
				when 1 then 'Tesorería'
				end as pago,
			<!---Solicitante--->
			(
				select us.Usulogin
				from Usuario us
				where us.Usucodigo=ant.UsucodigoSolicitud
			) as usuario 	
			from GEliquidacion ant left join GEcomision co on ant.GECid=co.GECid
			<!---Filtros--->
			where ant.GELtipo = <cfqueryparam cfsqltype="cf_sql_integer" value="7">
			and ant.Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			and ant.GECid > 0
			<!---and GELestado in (4,5)--->
		<cfif isdefined('form.CFid_F') and len(trim(form.CFid_F)) and form.CFid_F NEQ '-1'>
			and ant.CFid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CFid_F#">
		</cfif>	
		<cfif isdefined('form.Usucodigo') and len(trim(form.Usucodigo)) and form.Usucodigo NEQ "">
			and ant.UsucodigoSolicitud=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Usucodigo#">
		</cfif>			
		
		<cfif isdefined('form.DEid') and len(trim(form.DEid)) and form.DEid NEQ "">	
			and ant.TESBid=
			(select TESBid
					from TESbeneficiario 
					where DEid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid#">)
		</cfif>	
		<cfif isdefined('form.McodigoOri_F') and len(trim(form.McodigoOri_F))>
			and ant.Mcodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.McodigoOri_F#">
		</cfif>	
		<cfif isdefined('form.numAnti') and len(trim(form.numAnti))>
			and GELnumero = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.numAnti#">
		</cfif>
		
		<cfif isdefined('form.TESSPfechaPago_F') and len(trim(form.TESSPfechaPago_F))>
			and ant.GELfecha <= <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(form.TESSPfechaPago_F)#">
		</cfif>	
		<cfif isdefined('form.TESSPfechaPago_I') and len(trim(form.TESSPfechaPago_I))>
			and ant.GELfecha >= <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(form.TESSPfechaPago_I)#">
		</cfif>	
		<cfif isdefined ('form.FormaPago') and len(trim(form.FormaPago)) gt 0>
			<cfif FormaPago eq 0>
				and ant.GELtipoP = 1
			</cfif>
			<cfif FormaPago gt 0>
				and ant.GELtipoP= 0
				and ant.CCHid=#form.FormaPago#
			</cfif>
		</cfif>
			order by ant.GELnumero
	</cfquery>
</form>
</td>
</tr>
<tr>
<td>
<cfif lista.GECid EQ ''>
	<cfset LvarformatoImp="ReimpresionLiq.cfm">
<cfelse>
	<cfset LvarformatoImp="LiquidacionImpresion_form.cfm">
</cfif>	
	<cfinvoke component="sif.Componentes.pListas" method="pListaQuery"
		query="#lista#"
		Cortes="#LvarCortes#"
		desplegar="GELnumero,GECnumero, CFcodigo,Empleado,GELfecha,Moneda,GELtotalGastos,usuario,pago"
		etiquetas="Num.<BR>Liquidación,Comision,Ofi:Centro<BR>Funcional,Nombre Empleado,Fecha Liquidación, Moneda,   Gastos,  Solicitante,Tipo Pago "
		formatos="I,I,S,S,D,S,M,S,S,S"
		align="left,left,left,left,left,left,left,left,left,left"
		ira="#LvarformatoImp#"
		form_method="post"
		showEmptyListMsg="yes"
		keys="GELid"	
		MaxRows="18"
		navegacion=""
		filtro_nuevo="#isdefined("form.btnFiltrar")#"
	/>		
</td>
</tr>
</table>
