<cfinvoke component="sif.Componentes.Translate" method="Translate" key="BTN_Filtrar" default="Filtrar" returnvariable="BTN_Filtrar" xmlfile ="/sif/generales.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_NumVale" default="Num. Vale" returnvariable="LB_NumVale" 
xmlfile ="ReimpresionVales_lista.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Estado" default="Estado" returnvariable="LB_Estado" 
xmlfile ="ReimpresionVales_lista.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Empleado" default="Empleado" returnvariable="LB_Empleado" 
xmlfile ="ReimpresionVales_lista.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Fecha" default="Fecha" returnvariable="LB_Fecha" xmlfile ="ReimpresionVales_lista.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_MontoOriginal" default=" Monto </br> Original" returnvariable="LB_MontoOriginal" 
xmlfile ="ReimpresionVales_lista.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_MontoAplicado" default="Monto</br>Aplicado" returnvariable="LB_MontoAplicado" 
xmlfile ="ReimpresionVales_lista.xml"/>

<cfparam name="rsCustodio.DEid" default="">
<cfif GvarPorResponsable>
    <cfquery name="rsCustodio" datasource="#session.dsn#">
        select llave as DEid
          from UsuarioReferencia
         where Usucodigo= #session.Usucodigo#
           and Ecodigo	= #session.EcodigoSDC#
           and STabla	= 'DatosEmpleado'
    </cfquery>
    <cfif rsCustodio.DEid EQ "">
        <cfthrow message="El Usuario '#session.usulogin#' no está registrado como Empleado">
    </cfif>
</cfif>

<table width="100%" border="0" cellspacing="6">
	<tr>
		<td width="50%" valign="top">
		<form name="formFiltro" method="post" action="<cfoutput>ReimpresionVales#LvarCFM#.cfm</cfoutput>" style="margin: '0' ">
		<table class="areaFiltro" width="100%"  border="0" cellpadding="0" cellspacing="0">
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
				<td nowrap align="right"><strong><cf_translate key=LB_NumVale>Num.Vale:</cf_translate></strong></td>
				<td nowrap>
					<input type="text" name="numVale" />
				</td>
				
				<td nowrap align="right"><strong><cf_translate key=LB_Estado>Estado:</cf_translate></strong></td>
				<td nowrap>
					<select name="estado">
						<option value="0">--</option>
						<option value="1"><cf_translate key=LB_Aplicado>Aplicado</cf_translate></option>
						<option value="2"><cf_translate key=LB_Cancelado>Cancelado</cf_translate></option>
						<option value="3"><cf_translate key=LB_PorLiquidar>Por Liquidar</cf_translate></option>
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
</form>
<table width="100%">
<!---QUERY DE SELECCIÓN--->
<cfquery name="rsSQL" datasource="#session.dsn#">
	select 
		v.CCHVid,        
		v.CCHVnumero,
		v.CCHVestado,
		v.GEAid,            
		(select TESBeneficiario from TESbeneficiario where TESBid=(select TESBid from GEanticipo where GEAid=v.GEAid)) as name,
		v.GELid,                 
		v.CCHVusucodigoGenera,
		v.CCHVfecha,
		v.CCHVmontonOrig,
		v.CCHVmontoAplicado,
		v.CCHVusucodigoAplica,
		v.CCHVfechaAplica, 
		v.CCHTid
		from CCHVales v
        <cfif GvarPorResponsable>
	        inner join GEanticipo p
    	   		on p. GEAid = v.GEAid         
    		inner join CCHica x               
        		on x.CCHid = p.CCHid
        </cfif>    
		where v.Ecodigo=#session.Ecodigo#
        
        <cfif GvarPorResponsable>
        	and x.CCHresponsable= #rsCustodio.DEid#  
        </cfif>
		<cfif isdefined ('form.numVale') and len(trim(form.numVale)) gt 0>
			and CCHVnumero=#form.numVale#
		</cfif>	
		<cfif isdefined('form.TESSPfechaPago_F') and len(trim(form.TESSPfechaPago_F))>
			and v.CCHVfecha <= <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(form.TESSPfechaPago_F)#">
		</cfif>	
		<cfif isdefined('form.TESSPfechaPago_I') and len(trim(form.TESSPfechaPago_I))>
			and v.CCHVfecha >= <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(form.TESSPfechaPago_I)#">
		</cfif>
		<!---
		<cfif isdefined('form.DEid') and len(trim(form.DEid)) and form.DEid NEQ "">	
			and v.TESBid=
			(select TESBid
					from TESbeneficiario 
					where DEid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid#">)
		</cfif>	--->
		<cfif isdefined ('form.estado') and len(trim(form.estado))	gt 0 and form.estado neq 0>
			<cfif form.estado EQ 1>
				and CCHVestado='APLICADO'
			</cfif>
			<cfif form.estado EQ 2>
				and CCHVestado='CANCELADO'
			</cfif>
			<cfif form.estado EQ 3>
				and CCHVestado='POR LIQUIDAR'
			</cfif>
		</cfif>
</cfquery>

<tr>
	<td>
		<cfinvoke component="sif.Componentes.pListas" method="pListaQuery"
			query="#rsSQL#"
			Cortes=""
			desplegar="CCHVnumero,CCHVestado,name,CCHVfecha,CCHVmontonOrig,CCHVmontoAplicado"
			etiquetas="#LB_NumVale#,#LB_Estado#,#LB_Empleado#,#LB_Fecha#,#LB_MontoOriginal#,#LB_MontoAplicado#"
			formatos="S,S,S,D,M,M"
			align="left,left,left,left,right,right"
			ira="ReimpresionVales#LvarCFM#.cfm"
			form_method="post"
			showEmptyListMsg="yes"
			keys="CCHVid"	
			MaxRows="18"
			navegacion=""
			filtro_nuevo="#isdefined("form.btnFiltrar")#"
		/>		
	</td>
</tr>
</table>
