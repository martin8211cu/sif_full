<cfinvoke component="sif.Componentes.Translate" method="Translate" key="BTN_Filtrar" default="Filtrar" returnvariable="BTN_Filtrar" xmlfile ="/sif/generales.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_NumAnticipo" default="Num.<BR>Anticipo" returnvariable="LB_NumAnticipo" 
xmlfile ="ReimpresionAnt_lista.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_CentroFuncional" default="Centro<BR>Funcional" returnvariable="LB_CentroFuncional" 
xmlfile ="ReimpresionAnt_lista.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Empleado" default="Nombre Empleado" returnvariable="LB_Empleado" 
xmlfile ="ReimpresionAnt_lista.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_FechaPagoSolicitada" default="Fecha Pago<BR>Solicitada" 
returnvariable="LB_FechaPagoSolicitada" xmlfile ="ReimpresionAnt_lista.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Moneda" default="Moneda" returnvariable="LB_Moneda" 
xmlfile ="ReimpresionAnt_lista.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_TotalPagoSolicitado" default="Total Pago<BR>Solicitado" 
returnvariable="LB_TotalPagoSolicitado" xmlfile ="ReimpresionAnt_lista.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="Solicitante" default="Solicitante" returnvariable="LB_Solicitante" 
xmlfile ="ReimpresionAnt_lista.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_TipoPago" default="Tipo Pago" returnvariable="LB_TipoPago" 
xmlfile ="ReimpresionAnt_lista.xml"/>

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
		<form name="formFiltro" method="post" action="<cfoutput>ReimpresionAnt#LvarSAporEmpleadoCFM#.cfm</cfoutput>" style="margin: '0' ">
		<table class="areaFiltro" width="100%"  border="0" cellpadding="0" cellspacing="0">
			<tr>
<!---FILTRO DE CENTRO FUNCIONAL--->
				<td nowrap align="right">
					<strong><cf_translate key=LB_CentroFuncional>Centro Funcional</cf_translate>:</strong>
				</td>
				<td nowrap>	
					<cf_cboCFid form="formFiltro" todos="yes">
					<cfset form.CFid_F = session.Tesoreria.CFid>
				</td>
<!---FILTRO DE SOLICITANTE--->
				<td nowrap align="right">
					<strong><cf_translate key=LB_Solicitante>Solicitante</cf_translate>:</strong>
				</td>
				<td colspan="2">	
                	<cfif #LvarSAporEmpleadoSolicitante#>
                        <cfquery name="rsUsuario" datasource="#session.dsn#">
                            select u.Usucodigo, u.Usulogin
                                , dp.Pnombre #LvarCNCT# ' ' #LvarCNCT# dp.Papellido1 #LvarCNCT# ' ' #LvarCNCT# dp.Papellido2 as Usunombre
                              from Usuario u 
                                inner join DatosPersonales dp
                                   on dp.datos_personales = u.datos_personales
                             where Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
                        </cfquery>
                        <cfoutput>
                            &nbsp;#rsUsuario.Usunombre#
                        </cfoutput>				
					<cfelseif isdefined ('form.Usucodigo') and len(trim(form.Usucodigo)) gt 0>
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
					<strong><cf_translate key=LB_Empleado>Empleado</cf_translate>:</strong></td>
				<td nowrap>	
					<cfif isdefined('form.DEid') and len(trim(form.DEid)) and form.DEid NEQ "">					
						<cf_rhempleados form="formFiltro" tabindex="1" DEid="DEid" Usucodigo="Usucodigo2" idempleado="#form.DEid#">
					<cfelse>
						<cf_rhempleados form="formFiltro" tabindex="1" DEid="DEid" Usucodigo="Usucodigo2">
					</cfif>					
				</td>			
<!---FILTRO DE FECHA--->				
				<td nowrap align="right"><strong><cf_translate key=LB_Fecha>Fecha</cf_translate>:</strong></td>
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
								<strong>&nbsp;<cf_translate key=LB_Hasta>Hasta</cf_translate>:</strong>
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
				<td nowrap align="right"><strong><cf_translate key=LB_NumAnticipo>Num.Anticipo</cf_translate>:</strong></td>
				<td nowrap>
					<input type="text" name="numAnti" />
				</td>							
<!---FILTRO DE MONEDA--->				
				<td nowrap align="right">
					<strong><cf_translate key=LB_Moneda>Moneda</cf_translate></strong>
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
		<strong><cf_translate key=LB_FormaPago>Forma de Pago</cf_translate></strong>
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
						 <cfoutput><input name="btnFiltrar" type="submit" id="btnFiltrar" value="#BTN_Filtrar#" tabindex="2" /></cfoutput>
					 </div>
				</td>
			</tr>
		</table>
		
<cfquery datasource="#session.dsn#" name="lista">
		select 
			GEAid,
			GEAdescripcion,
			GEAfechaPagar,
			<!---Mensaje de rechazo--->
			(
			select 	sp.TESSPmsgRechazo
			from TESsolicitudPago sp
			where sp.TESSPid = sa.TESSPid) as mjs,
			<!---Centro Funcional--->
			GEAnumero,
			( 
				select rtrim(o.Oficodigo) #LvarCNCT# ':' #LvarCNCT# cf.CFcodigo
				from CFuncional cf 
				inner join Oficinas o on o.Ecodigo = cf.Ecodigo and o.Ocodigo = cf.Ocodigo 
				where cf.CFid = sa.CFid
			) as CFcodigo,
			<!---Empleado--->
			(
				select Em.DEnombre #LvarCNCT# ' ' #LvarCNCT# Em.DEapellido1 #LvarCNCT# ' ' #LvarCNCT# Em.DEapellido2

				from DatosEmpleado Em,TESbeneficiario te
				where sa.TESBid=te.TESBid and   Em.DEid=te.DEid  
			) as Empleado,			
			<!---Moneda--->
			(
				select Mo.Miso4217
				from Monedas Mo
				where sa.Mcodigo=Mo.Mcodigo
			)as Moneda,
			GEAtotalOri,
			<!---Estado--->
			case GEAestado
				when  0 then 'En Preparación'
				when  1 then 'En Aprobación'
				when  2 then 'Aprobada'
				when  3 then 'Rechazada'
				when  4 then 'Pagada'
				when  5 then 'Liquidada' 
				else 'Estado desconocido'
				end as estado,
			case 
				when CCHtipo  = 2 then 'Caja Especial'
				when GEAtipoP = 0 then 'Caja Chica'
				when GEAtipoP = 1 then 'Tesorería'
			end as pago,
			<!---Solicitante--->
			(
				select us.Usulogin
				from Usuario us
				where us.Usucodigo=sa.UsucodigoSolicitud
			) as usuario 			
			from GEanticipo sa
				left join CCHica ch on ch.CCHid = sa.CCHid
			<!---Filtros--->
			where sa.GEAtipo = <cfqueryparam cfsqltype="cf_sql_integer" value="6">
			and sa.Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			and GEAestado not in (0)
		<cfif isdefined('form.CFid_F') and len(trim(form.CFid_F)) and form.CFid_F NEQ '-1'>
			and sa.CFid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CFid_F#">
		</cfif>	
		<cfif isdefined('form.Usucodigo') and len(trim(form.Usucodigo)) and form.Usucodigo NEQ "">
			and sa.UsucodigoSolicitud=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Usucodigo#">
		</cfif>			
		<cfif #LvarSAporEmpleadoSolicitante#>
    		and sa.UsucodigoSolicitud=#session.Usucodigo#
    	</cfif>    

		<cfif isdefined('form.DEid') and len(trim(form.DEid)) and form.DEid NEQ "">	
			and sa.TESBid=
				(select TESBid
					from TESbeneficiario 
					where DEid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid#">)
		</cfif>	
		<cfif isdefined('form.McodigoOri_F') and len(trim(form.McodigoOri_F))>
			and sa.Mcodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.McodigoOri_F#">
		</cfif>	
		<cfif isdefined('form.numAnti') and len(trim(form.numAnti))>
			and GEAnumero = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.numAnti#">
		</cfif>
		<cfif isdefined('form.TESSPfechaPago_F') and len(trim(form.TESSPfechaPago_F))>
			and sa.GEAfechaPagar <= <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(form.TESSPfechaPago_F)#">
		</cfif>	
		<cfif isdefined('form.TESSPfechaPago_I') and len(trim(form.TESSPfechaPago_I))>
			and sa.GEAfechaPagar >= <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(form.TESSPfechaPago_I)#">
		</cfif>	
		<cfif isdefined ('form.FormaPago') and len(trim(form.FormaPago)) gt 0>
			<cfif FormaPago eq 0>
				and sa.GEAtipoP = 1
			</cfif>
			<cfif FormaPago gt 0>
				and sa.GEAtipoP= 0
				and sa.CCHid=#form.FormaPago#
			</cfif>
		</cfif>
			order by sa.GEAnumero 
</cfquery>
</form>
</td>
</tr>
<tr>
<td>
	<cfinvoke component="sif.Componentes.pListas" method="pListaQuery"
				query="#lista#"
				Cortes="#LvarCortes#"
				desplegar="GEAnumero,CFcodigo,Empleado,GEAfechaPagar,Moneda,GEAtotalOri,usuario,pago"
				etiquetas="#LB_NumAnticipo#,Ofi:#LB_CentroFuncional#,#LB_Empleado#,#LB_FechaPagoSolicitada#, #LB_Moneda#, #LB_TotalPagoSolicitado#,#LB_Solicitante#,#LB_TipoPago#"
				formatos="I,S,S,D,S,M,S,S"
				align="left,left,left,center,right,right,left,left"
				ira="ReimpresionAnt#LvarSAporEmpleadoCFM#.cfm"
				form_method="post"
				MaxRowsQuery="0"
				showEmptyListMsg="yes"
				keys="GEAid"	
				MaxRows="15"
				navegacion=""
				checkboxes="N"
				filtro_nuevo="#isdefined("form.btnFiltrar")#"
			/>		
</td>
</tr>
</table>
