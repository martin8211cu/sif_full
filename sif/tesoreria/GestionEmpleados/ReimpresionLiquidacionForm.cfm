<!---Este lo modifique yo--->

<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Titulo" default="Reimpresión Comprobación  de Viaticos por Comision a Empleados" returnvariable="LB_Titulo" xmlfile ="ReimpresionLiquidacionForm.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_ListaEmpleados" default="Lista Empleado" returnvariable="LB_ListaEmpleados" xmlfile ="ReimpresionLiquidacionForm.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Identificacion" default="Identificaci&oacute;n" returnvariable="LB_Identificacion" xmlfile ="ReimpresionLiquidacionForm.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Nombre" default="Nombre" returnvariable="LB_Nombre" 
xmlfile ="ReimpresionLiquidacionForm.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_ApellidoPaterno" default="Apellido Paterno" returnvariable="LB_ApellidoPaterno" 
xmlfile ="ReimpresionLiquidacionForm.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_ApellidoMaterno" default="Apellido Materno" returnvariable="LB_ApellidoMaterno" 
xmlfile ="ReimpresionLiquidacionForm.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="BTN_Filtrar" default="Filtrar" returnvariable="BTN_Filtrar" 
xmlfile ="/sif/generales.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_NumLiquidacion" default="Num.<BR>Liquidación" returnvariable="LB_NumLiquidacion" 
xmlfile ="ReimpresionLiquidacionForm.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Comision" default="Comision" returnvariable="LB_Comision" 
xmlfile ="ReimpresionLiquidacionForm.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_CentroFuncional" default="Centro<BR>Funcional" returnvariable="LB_CentroFuncional" 
xmlfile ="ReimpresionLiquidacionForm.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Nombre" default="Nombre Empleado" returnvariable="LB_Nombre" 
xmlfile ="ReimpresionLiquidacionForm.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_FechaLiquidacion" default="Fecha Liquidaci&oacute;n" returnvariable="LB_FechaLiquidacion"xmlfile ="ReimpresionLiquidacionForm.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Moneda" default="Moneda" returnvariable="LB_Moneda"
xmlfile ="ReimpresionLiquidacionForm.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Gastos" default="Gastos" returnvariable="LB_Gastos"
xmlfile ="ReimpresionLiquidacionForm.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Solicitante" default="Solicitante" returnvariable="LB_Solicitante"
xmlfile ="ReimpresionLiquidacionForm.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_TipoPago" default="Tipo Pago" returnvariable="LB_TipoPago"
xmlfile ="ReimpresionLiquidacionForm.xml"/>


<cf_templateheader title="#LB_Titulo#">
<cfinclude template="/sif/portlets/pNavegacion.cfm">
<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='#LB_Titulo#'>
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
		<form name="formFiltro" method="post" action="ReimpresionLiquidacionForm.cfm" style="margin: '0' ">
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
					<strong><cf_translate key=LB_Empleado>Empleado</cf_translate>:</strong></td>
				<td nowrap>	
						<cf_conlis title="#LB_ListaEmpleados#"
					campos = "DEid, DEidentificacion, DEnombreTodo" 
					desplegables = "N,S,S" 
					modificables = "N,S,N" 
					size = "0,15,34"
					asignar="DEid, DEidentificacion, DEnombreTodo"
					asignarformatos="S,S,S"
					tabla="DatosEmpleado"
					columnas="DEid, DEidentificacion, DEnombre +' '+ DEapellido1 +' '+ DEapellido2 as DEnombreTodo,DEnombre,DEapellido1,DEapellido2"
					filtro="Ecodigo = #Session.Ecodigo#"
					desplegar="DEidentificacion, DEnombre,DEapellido1,DEapellido2"
					etiquetas="#LB_Identificacion#,#LB_Nombre#,#LB_ApellidoPaterno#,#LB_ApellidoMaterno#"
					formatos="S,S,S,S"
					align="left,left,left,left"
					showEmptyListMsg="true"
					EmptyListMsg=""
					form="formFiltro"
					width="800"
					height="500"
					left="70"
					top="20"
					filtrar_por="DEidentificacion,DEnombre,DEapellido1,DEapellido2"
					index="1"			
					fparams="DEid"
					/>        
					<!---<cfif isdefined('form.DEid') and len(trim(form.DEid)) and form.DEid NEQ "">					
						<cf_rhempleados form="formFiltro" tabindex="1" DEid="DEid" Usucodigo="Usucodigo2" idempleado="#form.DEid#">
					<cfelse>
						<cf_rhempleados form="formFiltro" tabindex="1" DEid="DEid" Usucodigo="Usucodigo2">
					</cfif>	--->				
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
				<td nowrap align="right"><strong><cf_translate key=LB_NumLiquidacion>Num.Liquidación:</cf_translate></strong></td>
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
						<option value="">(<cf_translate key=LB_Todas>Todas las monedas</cf_translate>)</option>
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
				<option value="0"<cfif isdefined ('form.FormaPago') and len(trim(form.FormaPago)) gt 0 and form.FormaPago eq 0>selected="selected"</cfif>><cf_translate key=LB_Tesoreria>Tesoreria</cf_translate> </option>
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
			,ant.GECid
			from GEliquidacion ant left join GEcomision co on ant.GECid=co.GECid
			<!---Filtros--->
			where ant.GELtipo = <cfqueryparam cfsqltype="cf_sql_integer" value="7">
			and ant.Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			<!--- and ant.GECid > 0--->
			<!---and GELtotalGastos > 0--->
			<!---and GELestado in (4,5)--->
		<cfif isdefined('form.CFid_F') and len(trim(form.CFid_F)) and form.CFid_F NEQ '-1'>
			and ant.CFid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CFid_F#">
		</cfif>	
		<cfif isdefined('form.Usucodigo') and len(trim(form.Usucodigo)) and form.Usucodigo NEQ "">
			and ant.UsucodigoSolicitud=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Usucodigo#">
		</cfif>			
		
		<cfif isdefined('form.DEid') and len(trim(form.DEid)) and form.DEid NEQ "">	
			and ant.TESBid=
			(select top 1 TESBid
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
<!--- <cfthrow message="error GECid= #lista.GECid#"> --->
<cfif lista.GECid EQ ''>
	<cfset LvarformatoImp="ReimpresionLiq_form.cfm">
<cfelse>
	<cfset LvarformatoImp="LiquidacionImpresion_form.cfm">
</cfif>	
<!--- <cfthrow message="error archiuvo: #LvarformatoImp#"> --->
	<cfinvoke component="sif.Componentes.pListas" method="pListaQuery"
		query="#lista#"
		Cortes="#LvarCortes#"
		desplegar="GELnumero,GECnumero, CFcodigo,Empleado,GELfecha,Moneda,GELtotalGastos,usuario,pago"
		etiquetas="#LB_NumLiquidacion#,#LB_Comision#,Ofi:#LB_CentroFuncional#,#LB_Nombre#,#LB_FechaLiquidacion#,#LB_Moneda#,#LB_Gastos#, #LB_Solicitante#,
        #LB_TipoPago#"
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
