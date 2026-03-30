<cfparam name="form.pageNum_lista" default="1">
<cfparam name= "LvarMod" default="False">
<cfparam name= "LvarDespacho" default="true">

<cfif isdefined ('LvarUsuarioAprobador') and LvarUsuarioAprobador eq 'true'>
	<cfset LvarDirec2 = "RequisicionesAp-form.cfm">
<cfelseif isdefined ('LvarUsuarioDespachador') and LvarUsuarioDespachador eq 'true' >
	<cfset LvarDirec2 = "RequisicionesDesp-form.cfm">
<cfelse>
	<cfset LvarDirec2 = "Requisiciones.cfm">
</cfif>

<cf_dbfunction name="OP_concat"	returnvariable="_Cat">
<!---Control de Presupuesto en Compras de Artículos de Inventario--->
<cfquery name="rsPres" datasource="#session.DSN#">
	select Pvalor as valor
	from Parametros 
	where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#"> 
	  and Pcodigo=548
</cfquery>

<cfset Request.Debug = False>
<cfif isdefined("form.Nuevo")>
	<cfoutput><cflocation url="#LvarDirec2#"></cfoutput>
<cfelseif isdefined("form.btnNuevo")>
	<cfoutput><cflocation url="#LvarDirec2#"></cfoutput>
<cfelseif isdefined("form.NuevoDet")>
	<cfoutput><cflocation url="#LvarDirec2#?ERid=#form.ERid#&pageNum_lista=#form.pageNum_lista#"></cfoutput>
<cfelseif isdefined("form.btnNuevoDet")>
	<cfoutput><cflocation url="#LvarDirec2#?ERid=#form.ERid#&pageNum_lista=#form.pageNum_lista#"></cfoutput>
	
<cfelseif isdefined("form.Anular")>
	<cfquery datasource="#session.dsn#">
		update ERequisicion  
		set Estado = 4 <!---Anulado --->
		where ERid = <cfqueryparam value="#Form.ERid#" cfsqltype="cf_sql_numeric">
	</cfquery>

	<cfquery datasource="#session.dsn#">
		update DRequisicion  
		set DRcantidad = 0
		where ERid = <cfqueryparam value="#Form.ERid#" cfsqltype="cf_sql_numeric">
	</cfquery>
	<cflocation url="RequisicionesAP-lista.cfm?pageNum_lista=#form.pageNum_lista#&LvarAnular=true&LvarUsuarioAprobador=true">
	
<cfelseif isdefined("form.Actualizar_Despachador")>
	<cfquery datasource="#session.dsn#">
		update ERequisicion
		set UsucodigoD = #form.UsucodigoD#
		where ERid      = <cfqueryparam value="#Form.ERid#"    cfsqltype="cf_sql_numeric">
	</cfquery>
	<cflocation url="#LvarDirec2#?ERid=#form.ERid#&pageNum_lista=#form.pageNum_lista#&LvarUsuarioAprobador=#LvarUsuarioAprobador#&LvarUsuarioDespachador=#LvarUsuarioDespachador#">
	
<cfelseif isdefined("form.btnAplicar") or isdefined("form.Aplicar")>
	<cfif isdefined("form.chk")>
		<cfset lista = form.chk>
	<cfelseif isdefined("form.ERid")>
		<cfset Cambio()>
		<cfset lista = form.ERid>
	</cfif>
	<cfset arreglo = listtoarray(lista)>
	<cfloop from="1" to="#arraylen(arreglo)#" index="idx">
		<cfinvoke Component="sif.Componentes.IN_PosteoRequis"
			method="IN_PosteoRequis"
			ERid="#arreglo[idx]#"
			Debug = "#Request.Debug#"
			RollBack = "#Request.Debug#"/>
	</cfloop>
	<cflocation url="Requisiciones-lista.cfm?LvarUsuarioAprobador=#LvarUsuarioAprobador#&LvarUsuarioDespachador=#LvarUsuarioDespachador#">
	
<cfelseif isdefined("form.btnDespachado") or isdefined("form.Despachado")>
	<cfquery datasource="#session.dsn#">
		update ERequisicion
		set Estado  = 2 <!---Despachado--->
		where ERid  = <cfqueryparam value="#Form.ERid#"    cfsqltype="cf_sql_numeric">
	</cfquery>
	<cfinvoke Component="sif.Componentes.IN_PosteoRequis"
		method="IN_PosteoRequis"
		ERid="#Form.ERid#"
		Debug = "#Request.Debug#"
		RollBack = "#Request.Debug#"/>
	<cflocation url="RequisicionesDesp.cfm">
<cfelseif isdefined("form.btnAprobar") or isdefined("form.Aprobar")>
	<!---SACAR DE LA TRANSACCION EL MONTON DE QUERYS QUE NO SON INSERT, UPDATE, DELETE--->
	
	<cfquery name="rsUSUD" datasource="#session.DSN#">
		select UsucodigoD from  ERequisicion
			where ERid  = <cfqueryparam value="#Form.ERid#" cfsqltype="cf_sql_numeric">
	</cfquery>

	<cfif #rsUSUD.UsucodigoD# eq ''>
	
		<cfset LvarDespacho = false>
		<cflocation url="#LvarDirec2#?ERid=#form.ERid#&pageNum_lista=#form.pageNum_lista#&LvarUsuarioAprobador=#LvarUsuarioAprobador#&LvarUsuarioDespachador=#LvarUsuarioDespachador#&LvarDespacho=#LvarDespacho#">
	<cfelse>
	<cftransaction>
		<cfquery datasource="#session.dsn#">
			update ERequisicion
			set Estado     = 1, <!---Aprobado--->
				 UsucodigoD = #form.UsucodigoD#,
				 UsucodigoA = #session.Usucodigo#,
				 ERFechaA   = #now()#
			where ERid      = <cfqueryparam value="#Form.ERid#"    cfsqltype="cf_sql_numeric">
		</cfquery>
	</cftransaction>
		
<!---Envio de Correos Despachador--->
<!---Remitente--->
				<cfquery datasource="#session.dsn#" name="RemitenteD">
			select Coalesce(b.Pemail1, b.Pemail2, 'gestion@conavi.go.cr') correo, b.Pnombre #_Cat# ' ' #_Cat# b.Papellido1 #_Cat# ' ' #_Cat# b.Papellido2 as nombre
				from Usuario a 
					inner join DatosPersonales b
						on a.datos_personales = b.datos_personales
			where a.Usucodigo = #rsUSUD.UsucodigoD#
		</cfquery>

<!---Destinatario--->
			<cfquery datasource="#session.dsn#" name="DestinatarioD">
				select Coalesce(b.Pemail1, b.Pemail2, 'gestion@conavi.go.cr') correo, b.Pnombre #_Cat# ' ' #_Cat# b.Papellido1 #_Cat# ' ' #_Cat# b.Papellido2 as nombre, b.Psexo
					from Usuario a 
						inner join DatosPersonales b
							on a.datos_personales = b.datos_personales 
				where a.Usucodigo = #rsUSUD.UsucodigoD#
			</cfquery>			
			
			<cfif DestinatarioD.Psexo EQ 'F'>
				<cfset sexo = 'Sra/ita. '>
			<cfelse>
				<cfset sexo = 'Sr. '>
			</cfif>
			
			<cfquery datasource="#session.dsn#" name="rsForm">
				select 
					d.Pnombre #_Cat# ' ' #_Cat# d.Papellido1 #_Cat# ' ' #_Cat# d.Papellido2 as nombre,
					b.CFid,
					a.UsucodigoD,
					a.UsucodigoA,
					a.BMUsucodigo,
					cf.CFdescripcion  as centroFuncional,
					Ucodigo as unidaM,
					Acodigo as  codArticulo,
					ar.Adescripcion as articulo,
					al.Almcodigo as bodega,
					case a.Estado when 0 then 'Pendiente' when 1 then 'Aprobado' 
					when 2 then 'Despachado' end as Estado,
					a.ERdocumento as documento,
					a.ERFecha as fecha,
					t.TRdescripcion as tipo,
					al.Bdescripcion as almacen,
					b.DRlinea as linea,
					a.ERid, 
					a.ERdescripcion, 
					a.ERFecha, 
					b.DRcantidad as cantidad
				from ERequisicion a
				inner join DRequisicion b
					on a.ERid = b.ERid
		   	inner join Articulos ar 
				  on ar.Aid = b.Aid 
			   inner join CFuncional cf
				  on cf.CFid = b.CFid
				inner join Almacen al
				  on al.Aid = a.Aid
				inner join TRequisicion t
				  on t.TRcodigo = a.TRcodigo
				  and t.Ecodigo = a.Ecodigo
				left outer join Usuario u
					on  u.Usucodigo = a.BMUsucodigo 

				left outer join DatosPersonales d
					on d.datos_personales = u.datos_personales				  
				  
				where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#"> 
				 and a.ERid = <cfqueryparam value="#Form.ERid#"cfsqltype="cf_sql_numeric">
			</cfquery>
			
			<cfquery  name="CentroF" dbtype="query">
				select distinct CFid from rsForm
			</cfquery>
			
			<cfset LvarCF = #CentroF.CFid#>
			
<!---Envio de Correos a quien digito--->
<!---Remitente--->
		<cfquery datasource="#session.dsn#" name="Remitente">
			select Coalesce(b.Pemail1, b.Pemail2, 'gestion@conavi.go.cr') correo, b.Pnombre #_Cat# ' ' #_Cat# b.Papellido1 #_Cat# ' ' #_Cat# b.Papellido2 as nombre
				from Usuario a 
					inner join DatosPersonales b
						on a.datos_personales = b.datos_personales
			where a.Usucodigo = <cfif len(trim(#rsForm.BMUsucodigo#))>#rsForm.BMUsucodigo#<cfelse>#session.Usucodigo#</cfif>
		</cfquery>
<!---Destinatario--->
			<cfquery datasource="#session.dsn#" name="Destinatario">
				select Coalesce(b.Pemail1, b.Pemail2, 'gestion@soin.co.cr') correo, b.Pnombre #_Cat# ' ' #_Cat# b.Papellido1 #_Cat# ' ' #_Cat# b.Papellido2 as nombre, b.Psexo
					from Usuario a 
						inner join DatosPersonales b
							on a.datos_personales = b.datos_personales 
				where a.Usucodigo = <cfif len(trim(#rsForm.BMUsucodigo#))>#rsForm.BMUsucodigo#<cfelse>#session.Usucodigo#</cfif>
			</cfquery>
			
			<cfif Destinatario.Psexo EQ 'F'>
				<cfset sexo = 'Sra/ita. '>
			<cfelse>
				<cfset sexo = 'Sr. '>
			</cfif>

			
			<cfset texto = "
					<table border='0' cellspacing='0' style='border:2px solid ##999999;'>
						<tr bgcolor='##999999'><td colspan='7' height='8'></td></tr>
						<tr bgcolor='##003399'><td colspan='7' height='24'></td></tr>
						<tr bgcolor='##999999'><td colspan='7'> <strong>Consejo Nacional de Vialidad (CONAVI)</strong> </td></tr>
						<tr bgcolor='##999999'><td colspan='7'> <strong>#rsForm.almacen#</strong></td></tr>

						<tr><td width='20%'>&nbsp;</td>
						<td width='11%'>&nbsp;</td></tr>
						<tr><td>#sexo##Destinatario.nombre#:</td></tr>
						<tr><td colspan='7'><div align='justify'>Por este medio se le informa a la fecha #DateFormat(now(),'dd/mm/yyyy')# fué aprobada su requisición Número Documento: #rsForm.documento# con el siguiente detalle:.<br>
						</div></td></tr> 
						<tr><td colspan='7'>&nbsp;</td></tr>

						<tr><td colspan='7'><strong>Líneas de Detalle de Requisición</strong></td></tr>
						
						<tr><td align='center' valign='top' colspan='7'>&nbsp;</td></tr>
						<tr>
							<td width='11%'><strong>Línea</strong></td>
							<td width='11%'><strong>Bodega</strong></td>			
							<td width='11%'><strong>Artículo</strong></td>
							<td width='11%'><strong>Descripción</strong></td>
							<td width='11%'><strong>C.F</strong></td>
							<td width='11%'><strong>UM</strong></td>
							<td width='11%'><strong>Cantidad</strong></td>
						</tr>
						<tr><td align='center' valign='top' colspan='7'><hr /></td></tr>
						"
						>
					<cfloop query='rsForm'>
						<cfset texto = texto & "<tr>
							<td>#rsForm.linea#</span></td>
							<td>#rsForm.bodega#</span></td>			
							<td>#rsForm.codArticulo#</span></td>
							<td nowrap='nowrap'>#rsForm.articulo#</span></td>
							<td nowrap='nowrap'>#rsForm.centroFuncional#</span></td>
							<td>#rsForm.unidaM#</span></td>
							<td>#rsForm.cantidad#</span></td>
						</tr>
						<tr><td align='center' valign='top' colspan='7'>&nbsp;</td></tr>
						<tr><td colspan='7'><div align='justify'>Dicha Solicitud se encuentra lista para ser despachada.</div></td></tr> 
						">
					</cfloop>
						<cfset texto = texto & "<tr><td width='20%'>&nbsp;</td>
						<td width='11%'>&nbsp;</td></tr>
						<tr bgcolor='##999999'><td colspan='2'> <strong>Usuario que aprobó:#Remitente.nombre#</strong></td></tr>
				    </table>">
					
					
					<!---Destinatario--->
					<cfset textoD = "
					<table border='0' cellspacing='0' style='border:2px solid ##999999;'>
						<tr bgcolor='##999999'><td colspan='7' height='8'></td></tr>
						<tr bgcolor='##003399'><td colspan='7' height='24'></td></tr>
						<tr bgcolor='##999999'><td colspan='7'> <strong>Consejo Nacional de Vialidad (CONAVI)</strong> </td></tr>
						<tr bgcolor='##999999'><td colspan='7'> <strong>#rsForm.almacen#</strong></td></tr>

						<tr><td width='20%'>&nbsp;</td>
						<td width='11%'>&nbsp;</td></tr>
						<tr><td>#sexo##DestinatarioD.nombre#:</td></tr>
						<tr><td colspan='7'><div align='justify'>Por este medio se le informa a la fecha #DateFormat(now(),'dd/mm/yyyy')# fué aprobada su requisición Número Documento: #rsForm.documento# con el siguiente detalle:.<br>
						</div></td></tr> 
						<tr><td colspan='7'>&nbsp;</td></tr>

						<tr><td colspan='7'><strong>Líneas de Detalle de Requisición</strong></td></tr>
						
						<tr><td align='center' valign='top' colspan='7'>&nbsp;</td></tr>
						<tr>
							<td width='11%'><strong>Línea</strong></td>
							<td width='11%'><strong>Bodega</strong></td>			
							<td width='11%'><strong>Artículo</strong></td>
							<td width='11%'><strong>Descripción</strong></td>
							<td width='11%'><strong>C.F</strong></td>
							<td width='11%'><strong>UM</strong></td>
							<td width='11%'><strong>Cantidad</strong></td>
						</tr>
						<tr><td align='center' valign='top' colspan='7'><hr /></td></tr>
						"
						>
					<cfloop query='rsForm'>
						<cfset textoD = textoD & "<tr>
							<td>#rsForm.linea#</span></td>
							<td>#rsForm.bodega#</span></td>			
							<td>#rsForm.codArticulo#</span></td>
							<td nowrap='nowrap'>#rsForm.articulo#</span></td>
							<td nowrap='nowrap'>#rsForm.centroFuncional#</span></td>
							<td>#rsForm.unidaM#</span></td>
							<td>#rsForm.cantidad#</span></td>
						</tr>
						<tr><td align='center' valign='top' colspan='7'>&nbsp;</td></tr>
						<tr><td colspan='7'><div align='justify'>Dicha Solicitud se encuentra lista para ser despachada.</div></td></tr> 
						">
					</cfloop>
						<cfset textoD = textoD & "<tr><td width='20%'>&nbsp;</td>
						<td width='11%'>&nbsp;</td></tr>
						<tr bgcolor='##999999'><td colspan='2'> <strong>Usuario que aprobó:#RemitenteD.nombre#</strong></td></tr>
				    </table>">
					 
					 <cfif isdefined('rsForm.BMUsucodigo') and #rsForm.BMUsucodigo# neq ''>
					 	<cfset LvarBMUsucodigo = #rsForm.BMUsucodigo#>
					 <cfelse>
					 	<cfset LvarBMUsucodigo = #session.Usucodigo#>
					 </cfif>
				
					<cfinvoke component="sif.Componentes.Workflow.utils" method="jefe_cf" returnvariable="real_users">
						<cfinvokeargument name="centro_funcional" value="#LvarCF#">
					</cfinvoke>
					<!---Envio de Correos Jefe--->
<!---Remitente--->
				<cfquery datasource="#session.dsn#" name="RemitenteJF">
			select Coalesce(b.Pemail1, b.Pemail2, 'gestion@soin.co.cr') correo, b.Pnombre #_Cat# ' ' #_Cat# b.Papellido1 #_Cat# ' ' #_Cat# b.Papellido2 as nombre
				from Usuario a 
					inner join DatosPersonales b
						on a.datos_personales = b.datos_personales
			where a.Usucodigo = #real_users.Usucodigo#
		</cfquery>
		
<!---Destinatario--->
			<cfquery datasource="#session.dsn#" name="DestinatarioJF">
				select Coalesce(b.Pemail1, b.Pemail2, 'gestion@soin.co.cr') correo, b.Pnombre #_Cat# ' ' #_Cat# b.Papellido1 #_Cat# ' ' #_Cat# b.Papellido2 as nombre, b.Psexo
					from Usuario a 
						inner join DatosPersonales b
							on a.datos_personales = b.datos_personales 
				where a.Usucodigo = #real_users.Usucodigo#
			</cfquery>			
			
			<cfif DestinatarioJF.Psexo EQ 'F'>
				<cfset sexo = 'Sra/ita. '>
			<cfelse>
				<cfset sexo = 'Sr. '>
			</cfif>
			
					<!---Jefe--->
					<cfset textoJF = "
					<table border='0' cellspacing='0' style='border:2px solid ##999999;'>
						<tr bgcolor='##999999'><td colspan='7' height='8'></td></tr>
						<tr bgcolor='##003399'><td colspan='7' height='24'></td></tr>
						<tr bgcolor='##999999'><td colspan='7'> <strong>Consejo Nacional de Vialidad (CONAVI)</strong> </td></tr>
						<tr bgcolor='##999999'><td colspan='7'> <strong>#rsForm.almacen#</strong></td></tr>

						<tr><td width='20%'>&nbsp;</td>
						<td width='11%'>&nbsp;</td></tr>
						<tr><td>#sexo##DestinatarioJF.nombre#:</td></tr>
						<tr><td colspan='7'><div align='justify'>Por este medio se le informa a la fecha #DateFormat(now(),'dd/mm/yyyy')# fué aprobada su requisición Número Documento: #rsForm.documento# con el siguiente detalle:.<br>
						</div></td></tr> 
						<tr><td colspan='7'>&nbsp;</td></tr>

						<tr><td colspan='7'><strong>Líneas de Detalle de Requisición</strong></td></tr>
						
						<tr><td align='center' valign='top' colspan='7'>&nbsp;</td></tr>
						<tr>
							<td width='11%'><strong>Línea</strong></td>
							<td width='11%'><strong>Bodega</strong></td>			
							<td width='11%'><strong>Artículo</strong></td>
							<td width='11%'><strong>Descripción</strong></td>
							<td width='11%'><strong>C.F</strong></td>
							<td width='11%'><strong>UM</strong></td>
							<td width='11%'><strong>Cantidad</strong></td>
						</tr>
						<tr><td align='center' valign='top' colspan='7'><hr /></td></tr>
						"
						>
					<cfloop query='rsForm'>
						<cfset textoJF = textoJF & "<tr>
							<td>#rsForm.linea#</span></td>
							<td>#rsForm.bodega#</span></td>			
							<td>#rsForm.codArticulo#</span></td>
							<td nowrap='nowrap'>#rsForm.articulo#</span></td>
							<td nowrap='nowrap'>#rsForm.centroFuncional#</span></td>
							<td>#rsForm.unidaM#</span></td>
							<td>#rsForm.cantidad#</span></td>
						</tr>
						<tr><td align='center' valign='top' colspan='7'>&nbsp;</td></tr>
						<tr><td colspan='7'><div align='justify'>Dicha Solicitud se encuentra lista para ser despachada.</div></td></tr> 
						">
					</cfloop>
						<cfset textoJF = textoJF & "<tr><td width='20%'>&nbsp;</td>
						<td width='11%'>&nbsp;</td></tr>
						<tr bgcolor='##999999'><td colspan='2'> <strong>Usuario que aprobó:#RemitenteJF.nombre#</strong></td></tr>
				    </table>">			
					
				<!---al jefe del Centro Funcional del detalle de la requisición --->
					<cfif #real_users.Usucodigo# neq ''>
						<cfset InsertarEmail(RemitenteJF.correo,DestinatarioJF.correo,'Requisiciones de Inventario1',#textoJF#,#real_users.Usucodigo#,#session.dsn#)> 
					</cfif>
				
				<!---quien digitó la Requisición  --->
					<cfset InsertarEmail(Remitente.correo,Destinatario.correo,'Requisiciones de Inventario2',#texto#,#LvarBMUsucodigo#,#session.dsn#)>
				<!---Despachador --->
					<cfset InsertarEmail(RemitenteD.correo,DestinatarioD.correo,'Requisiciones de Inventario3',#textoD#,#rsUSUD.UsucodigoD#,#session.dsn#)> 
		<cflocation url="RequisicionesAp.cfm">
	</cfif>
<cfelseif isdefined("form.Alta")>
	<!----Obtiene el consecutivo----->
	<cfinvoke	component		= "sif.Componentes.OriRefNextVal"
				method			= "nextVal"
				returnvariable	= "LvarERdocumento"
			
				Ecodigo			= "#session.Ecodigo#"
				ORI				= "INRQ"
				REF				= "ERdocumento"
				datasource		= "#session.dsn#"
	/>
	<cfif isdefined("form.chkDevolucion") and isdefined("form.ERidref") and len(trim(form.ERidref))>
		<cftransaction>
		<cfquery name="rsEreq" datasource="#session.dsn#">
			select     '#ERdescripcion#' as ERdescripcion,   
						Ecodigo, 
						Aid, 
						'#form.ERdocumento#' as ERdocumento, 
						TRcodigo, 
						Dcodigo, 
						Ocodigo, 
						ERFecha, 
						ERtotal, 
						ERusuario, 
						EReferencia, 
						BMUsucodigo, 
						EcodigoRequi,
						#form.ERidref# as ERidref
				from HERequisicion
				where ERid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ERidref#">
		</cfquery>	
		<cfquery name="insertr" datasource="#session.dsn#">
			insert INTO ERequisicion(	ERdescripcion, 
										Ecodigo, 
										Aid, 
										ERdocumento, 
										TRcodigo, 
										Dcodigo, 
										Ocodigo, 
										ERFecha, 
										ERtotal, 
										ERusuario, 
										EReferencia, 
										BMUsucodigo, 
										EcodigoRequi,
										ERidref
									)
									VALUES(
										   <cf_jdbcQuery_param cfsqltype="cf_sql_varchar" len="80"  value="#rsEreq.ERdescripcion#-#LvarERdocumento#" voidNull>,
										   #session.Ecodigo#,
										   <cf_jdbcQuery_param cfsqltype="cf_sql_numeric" scale="0" value="#rsEreq.Aid#"           voidNull>,
										   <cf_jdbcQuery_param cfsqltype="cf_sql_varchar" len="20"  value="#LvarERdocumento#-#rsEreq.ERdocumento#"   voidNull>,
										   <cf_jdbcQuery_param cfsqltype="cf_sql_varchar" len="4"   value="#rsEreq.TRcodigo#"      voidNull>,
										   <cf_jdbcQuery_param cfsqltype="cf_sql_integer"           value="#rsEreq.Dcodigo#"       voidNull>,
										   <cf_jdbcQuery_param cfsqltype="cf_sql_integer"           value="#rsEreq.Ocodigo#"       voidNull>,
										   <cf_jdbcQuery_param cfsqltype="cf_sql_timestamp"         value="#rsEreq.ERFecha#"       voidNull>,
										   <cf_jdbcQuery_param cfsqltype="cf_sql_money"             value="#rsEreq.ERtotal#"       voidNull>,
										   <cf_jdbcQuery_param cfsqltype="cf_sql_varchar" len="30"  value="#rsEreq.ERusuario#"     voidNull>,
										   <cf_jdbcQuery_param cfsqltype="cf_sql_varchar" len="20"  value="#rsEreq.EReferencia#"   voidNull>,
										   #session.Usucodigo#,
										   <cf_jdbcQuery_param cfsqltype="cf_sql_integer"           value="#rsEreq.EcodigoRequi#"  voidNull>,
										   <cf_jdbcQuery_param cfsqltype="cf_sql_numeric" scale="0" value="#rsEreq.ERidref#"       voidNull>
									)
			<cf_dbidentity1 datasource="#session.dsn#">
		</cfquery>
		<cf_dbidentity2 name="insertr" datasource="#session.dsn#">
		<cfquery name="insert" datasource="#session.dsn#">
			insert into DRequisicion (ERid, Aid, DRcantidad, CFid, DRcosto, Kid, FPAEid,CFComplemento)
			select #insertr.identity#, Aid, case  when Kunidades < 0 then Kunidades*-1 else Kunidades end, CFid, 0.00 as DRcosto, Kid, FPAEid, CFComplemento
			from Kardex
			where ERid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ERidref#" >
		</cfquery>	
		</cftransaction>
		<cflocation url="#LvarDirec2#?ERid=#insertr.identity#">
	<cfelse>
		<cftransaction>
		<cfquery name="insertr" datasource="#session.dsn#">
			insert into ERequisicion ( Ecodigo, ERdescripcion, Aid, ERdocumento, Ocodigo, TRcodigo, ERFecha, ERtotal, ERusuario, Dcodigo<!--- , PRJAid  --->, EcodigoRequi, ERidref)
			values ( 
				 #Session.Ecodigo# ,
				<cf_jdbcQuery_param cfsqltype="cf_sql_varchar"   value="#Form.ERdescripcion#-#LvarERdocumento#"   voidNull>,
				<cfqueryparam value="#Form.Aid#" 			 cfsqltype="cf_sql_numeric">,
				<cfqueryparam value="#LvarERdocumento#-#Form.ERdocumento#"   cfsqltype="cf_sql_char">, 
				<cfqueryparam value="#Form.Ocodigo#"       cfsqltype="cf_sql_integer">,
				<cfqueryparam value="#Form.TRcodigo#"      cfsqltype="cf_sql_char">,
				<cfqueryparam value="#LSParsedateTime(form.ERfecha)#" cfsqltype="cf_sql_timestamp">,
				<cfqueryparam value="0"                    cfsqltype="cf_sql_money">,
				<cf_jdbcQuery_param cfsqltype="cf_sql_varchar"  value="#session.usuario#"   voidNull>,
				<cfqueryparam value="#Form.Dcodigo#"       cfsqltype="cf_sql_integer"><!--- ,
				<cfif isdefined("form.PRJAid") and len(trim(form.PRJAid))><cfqueryparam cfsqltype="cf_sql_numeric" value="#form.PRJAid#"><cfelse>null</cfif> --->			
				,  #Session.Ecodigo# 
				,<cfif isdefined("form.chkDevolucion") and isdefined("form.ERidref") and len(trim(form.ERidref))><cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ERidref#"><cfelse>null</cfif>
			)
			<cf_dbidentity1 datasource="#session.dsn#">
		</cfquery>
		<cf_dbidentity2 name="insertr" datasource="#session.dsn#">
		</cftransaction>
		<cflocation url="#LvarDirec2#?ERid=#insertr.identity#">
	</cfif>		

<cfelseif isdefined("form.Baja")>
	<cfset SolicitudCompra()>
	<cftransaction>
	<cfquery datasource="#session.dsn#">
		delete from DRequisicion
		where ERid = <cfqueryparam value="#Form.ERid#" cfsqltype="cf_sql_numeric">
	</cfquery>
	<cfquery datasource="#session.dsn#">
		delete from ERequisicion
		where Ecodigo =  #Session.Ecodigo# 
		  and ERid    = <cfqueryparam value="#Form.ERid#" cfsqltype="cf_sql_numeric">
	</cfquery>
	</cftransaction>
	<cflocation url="Requisiciones-lista.cfm?LvarUsuarioAprobador=#LvarUsuarioAprobador#&LvarUsuarioDespachador=#LvarUsuarioDespachador#">
<cfelseif isdefined("form.Cambio")>
	<cfset SolicitudCompra()>
	<cfset Cambio()>
	<cflocation url="#LvarDirec2#?ERid=#form.ERid#&pageNum_lista=#form.pageNum_lista#&LvarUsuarioAprobador=#LvarUsuarioAprobador#&LvarUsuarioDespachador=#LvarUsuarioDespachador#">
<cfelseif isdefined("form.AltaDet")>
	<!---======== Verificar si es intercompany =========== ---->
	<!---<cfquery name="rsEnc" datasource="#Session.DSN#">
		select * from ERequisicion where ERid = <cfqueryparam value="#Form.ERid#" cfsqltype="cf_sql_numeric">
	</cfquery>--->
	<cfset SolicitudCompra()>
    <cfparam name="form.ActividadId" default="">
    <cfparam name="form.Actividad"  default="">
    
	<cfquery datasource="#session.dsn#">
		insert into DRequisicion ( ERid, Aid, DRcantidad, CFid, DRcosto, FPAEid,CFComplemento)
		values ( 
			<cf_jdbcquery_param cfsqltype="cf_sql_numeric"	value="#Form.ERid#" >,
			<cf_jdbcquery_param cfsqltype="cf_sql_numeric" 	value="#Form.aAid#" >,
			<cf_jdbcquery_param cfsqltype="cf_sql_float" 	value="#Replace(Form.DRcantidad,',','','all')#" >,			
			<cf_jdbcquery_param cfsqltype="cf_sql_numeric" 	value="#Form.CFpk#" >, 
			0.00,
            <cf_jdbcquery_param cfsqltype="cf_sql_numeric" 	value="#form.ActividadId#" voidnull>,
            <cf_jdbcquery_param cfsqltype="cf_sql_varchar" 	value="#form.Actividad#" voidnull>
		)
	</cfquery>
	<cfset Cambio()>
	<cflocation url="#LvarDirec2#?ERid=#form.ERid#&pageNum_lista=#form.pageNum_lista#">
<cfelseif isdefined("form.CambioDet")>
	<cfset LvarMod = 'True'>
	<cfset SolicitudCompra()>
    
    <cfparam name="form.ActividadId" default="">
    <cfparam name="form.Actividad"  default="">
    
	<cfquery datasource="#session.dsn#">
		update DRequisicion
		set Aid    		  = <cf_jdbcquery_param cfsqltype="cf_sql_numeric"	value="#Form.aAid#">, 
			DRcantidad 	  = <cf_jdbcquery_param cfsqltype="cf_sql_float" 	value="#Replace(Form.DRcantidad,',','','all')#">,
			CFid 		  = <cf_jdbcquery_param cfsqltype="cf_sql_numeric" 	value="#Form.CFpk#">,
            FPAEid		  = <cf_jdbcquery_param cfsqltype="cf_sql_numeric" 	value="#form.ActividadId#" voidnull>,
            CFComplemento = <cf_jdbcquery_param cfsqltype="cf_sql_varchar" 	value="#form.Actividad#" voidnull>
		where ERid        = <cf_jdbcquery_param cfsqltype="cf_sql_numeric" 	value="#Form.ERid#">
		  and DRlinea     = <cf_jdbcquery_param cfsqltype="cf_sql_numeric"	value="#Form.DRlinea#">
	</cfquery>
	<cfset Cambio()>
	<cflocation url="#LvarDirec2#?ERid=#form.ERid#&DRlinea=#form.DRlinea#&pageNum_lista=#form.pageNum_lista#&LvarUsuarioAprobador=#LvarUsuarioAprobador#&LvarUsuarioDespachador=#LvarUsuarioDespachador#">

<cfelseif isdefined("form.BajaDet")>
	<cfset SolicitudCompra()>
	<cfquery datasource="#session.dsn#">
		delete from DRequisicion
		where ERid = <cfqueryparam value="#Form.ERid#" cfsqltype="cf_sql_numeric">
		  and DRlinea = <cfqueryparam value="#Form.DRlinea#" cfsqltype="cf_sql_numeric">
	</cfquery>
	<cfset Cambio()>
	<cflocation url="#LvarDirec2#?ERid=#form.ERid#&pageNum_lista=#form.pageNum_lista#&LvarUsuarioAprobador=#LvarUsuarioAprobador#&LvarUsuarioDespachador=#LvarUsuarioDespachador#">
</cfif>

<cffunction access="private" name="Cambio" returntype="boolean">
	<cf_dbtimestamp datasource="#session.dsn#"
		table="ERequisicion"
		redirect="#LvarDirec2#"
		timestamp="#form.ts_rversion#"
		field1="ERid" 
		type1="numeric" 
		value1="#form.ERid#"
		field2="Ecodigo" 
		type2="integer" 
		value2="#session.Ecodigo#">
	<cfquery datasource="#session.dsn#">
		update ERequisicion 
		set ERdescripcion =   <cf_jdbcquery_param cfsqltype="cf_sql_varchar" 	value="#form.ERdescripcion#" voidnull>,
			Dcodigo       = <cfqueryparam value="#Form.Dcodigo#"       cfsqltype="cf_sql_integer">,
			ERFecha       = <cfqueryparam value="#LSParsedateTime(form.ERfecha)#" cfsqltype="cf_sql_timestamp">,
			Aid           = <cfqueryparam value="#form.Aid#" cfsqltype="cf_sql_numeric">,
			TRcodigo      = <cfqueryparam value="#form.TRcodigo#" cfsqltype="cf_sql_char">,
			Ocodigo       = <cfqueryparam value="#form.Ocodigo#" cfsqltype="cf_sql_integer">,
			ERdocumento   = <cfqueryparam value="#Form.ERdocumento#" cfsqltype="cf_sql_char">,
			EcodigoRequi  =  #Session.Ecodigo# ,
			ERidref		  = <cfif isdefined("form.chkDevolucion") and isdefined("form.ERidref") and len(trim(form.ERidref))><cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ERidref#"><cfelse>null</cfif>
			<!--- ,
			PRJAid		  =	<cfif isdefined("form.PRJAid") and len(trim(form.PRJAid))><cfqueryparam cfsqltype="cf_sql_numeric" value="#form.PRJAid#"><cfelse>null</cfif> --->
		where Ecodigo   =  #Session.Ecodigo# 
		  and ERid      = <cfqueryparam value="#Form.ERid#" cfsqltype="cf_sql_numeric">
	</cfquery>
	<cfreturn true>
</cffunction>

<cffunction access="private" name="SolicitudCompra">
	<cfif #rsPres.valor# eq 1>
		<!--- se busca si es una línea de solicitud de compra y si no está cancelada o hay cantidad no surtida no se puede eliminar. --->
		<cfquery name="rsSQL" datasource="#session.dsn#">
			select count(1) as cantidad
			from DRequisicion r
				inner join DSolicitudCompraCM d 
					on d.DSlinea = r.DSlinea
				inner join ESolicitudCompraCM e 
					on e.ESidsolicitud = d.ESidsolicitud
			where ERid      = <cfqueryparam value="#Form.ERid#" cfsqltype="cf_sql_numeric">
			<cfif isdefined("form.DRlinea")>
			  and r.DRlinea = #form.DRlinea#
			</cfif>
			  and r.DSlinea = d.DSlinea
			  and NOT (e.ESestado = 50 OR e.ESestado = 60 OR d.DScant - d.DScantsurt <= 0)
		</cfquery>
		  
		<cfif rsSQL.cantidad GT 0 and #LvarMod# neq 'True'>
			 <cfthrow message="La Requisición fue generada desde Solicitudes de Compra. No se puede modificar. Si desea eliminarla debe cancelar la Solicitud de Compra.">
		</cfif>
	</cfif>
</cffunction>

<!--- Inserta correos en la cola de envio de correos --->
<cffunction name="InsertarEmail" access="public" 	returntype="numeric">
	<cfargument name="remitente" 		type="string" 	required="yes">
	<cfargument name="destinario" 	type="string" 	required="yes"><!--- correo --->
	<cfargument name="asunto" 			type="string" 	required="yes">
	<cfargument name="texto" 			type="string" 	required="yes">
	<cfargument name="usuario" 		type="numeric" required="no">
	<cfargument name="Conexion"   	type="string"  required="no">
	<!---<cfif NOT isdefined('Request.CantidadCorreo')>
		<cfset Request.CantidadCorreo = 1>
	<cfelse>
		<cfset Request.CantidadCorreo = Request.CantidadCorreo + 1>
	</cfif>
	<cfif Request.CantidadCorreo  GT 2>
	</cfif>--->
	<cfquery name="rsInserta" datasource="#session.dsn#">
		insert into SMTPQueue 
		(
		 SMTPremitente, 	
		 SMTPdestinatario, 	
		 SMTPasunto, 
		 SMTPtexto, 		
		 SMTPintentos, 		
		 SMTPcreado, 
 		 SMTPenviado, 	
		 SMTPhtml, 			
		 BMUsucodigo 
		) 
		values 
		( 
			<cfqueryparam 	cfsqltype="cf_sql_varchar" 	value="gestion@conavi.go.cr">, 
			<cfqueryparam 	cfsqltype="cf_sql_varchar" 	value="#arguments.destinario#">, 
			<cfqueryparam 	cfsqltype="cf_sql_varchar" 	value="#arguments.asunto#">,
			<cfqueryparam 	cfsqltype="cf_sql_varchar" 	value="#arguments.texto#">,
			0,	#now()#,	#now()#,	1,
			<cfqueryparam 	cfsqltype="cf_sql_numeric" 	value="#arguments.usuario#">
		)
		<cf_dbidentity1>
	</cfquery>
	<cf_dbidentity2 name="rsInserta">
	<cfreturn #rsInserta.identity#>
</cffunction>


