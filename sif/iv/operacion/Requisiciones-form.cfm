<cf_dbfunction name="OP_concat"	returnvariable="_Cat">
<cfparam name="LvarUsuarioAprobador" 	default="false">
<cfparam name="LvarUsuarioDespachador" 	default="false">
<cfparam name="LvarDespacho" 			default="true">


<cfif isdefined("url.ERid") and len(url.ERid)>
	<cfset form = url>
</cfif>
<!--- ListaDET--->
<cfset navegacion ="">
<cfif isdefined("form.ERid") and len(form.ERid)>
	<cfset navegacion = navegacion & '&ERid=#form.ERid#'>
</cfif>

<cfif isdefined("form.LERid") and len(form.LERid)>
	<cfset form.ERid = form.LERid>
	<cfset navegacion = "">
	<cfset navegacion = navegacion & '&ERid=#form.LERid#'>
	<cfset form.DRlinea = form.LDRlinea>
</cfif>

<!---►►Control de Presupuesto en Compras de Artículos de Inventario◄◄--->
<cfquery name="rsPres" datasource="#session.DSN#">
	select Pvalor as valor
	from Parametros 
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#"> 
	  and Pcodigo = 548
</cfquery>

<!---►►Actividad Empresarial (N-No se usa AE, S-Se usa Actividad Empresarial)◄◄--->
<cfquery name="rsActividad" datasource="#session.DSN#">
  Select Coalesce(Pvalor,'N') as Pvalor 
  	from Parametros 
   where Pcodigo = 2200 
     and Mcodigo = 'CG'
     and Ecodigo = #session.Ecodigo# 
</cfquery>
<cfif not rsActividad.RecordCount>
	<cfset rsActividad.Pvalor = 'N'>
</cfif>

<!--- Modo --->
<cfset modo  = "ALTA">
<cfset dmodo = "ALTA">
<cfif not isdefined("form.btnNuevo") and not isdefined("form.Nuevo") and isdefined("form.ERid") and len(form.ERid)>
	<cfset modo = "CAMBIO">
	<cfif not isdefined("form.btnNuevoDet") and not isdefined("form.NuevoDet") and isdefined("form.DRlinea") and len(form.DRlinea)>
		<cfset dmodo = "CAMBIO">
	</cfif>
</cfif>
<cfset Aplicar = "">
<cfset Imprime = "">
<!-- Consultas -->
<!-- 1. Form, FormDet, y algo mas -->
<cfif (modo neq 'ALTA')>
		<cfquery name="rsVerificaS" datasource="#session.dsn#">
		select count(1) as cantidad from ERequisicion a 
		inner join DRequisicion b
			on b.ERid = a.ERid
		inner join DSolicitudCompraCM c
			on c.DSlinea = b.DSlinea
		where a.ERid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ERid#">
	</cfquery>
    
	<cfquery name="rsdatos" datasource="#session.DSN#">
		select count(1) as total
		from DRequisicion
		where ERid = <cfqueryparam value="#Form.ERid#" cfsqltype="cf_sql_numeric">
	</cfquery>

	<cfquery datasource="#session.DSN#" name="rsForm">
		select a.ERid, a.ERdescripcion, a.Aid, rtrim(a.ERdocumento) as ERdocumento, a.Ocodigo, rtrim(upper(a.TRcodigo)) as TRcodigo, a.ERFecha, a.ERtotal, a.ERusuario, a.Dcodigo, <!--- coalesce(PRJAid, -1) as PRJAid,  --->a.ts_rversion 
				, a.EcodigoRequi, a.Ecodigo, a.ERidref, (dR.Papellido1 #_Cat# ' ' #_Cat# dR.Papellido2 #_Cat# ' ' #_Cat# dR.Pnombre) as NombreCompletoR,uD.Usulogin, a.UsucodigoD,(dD.Papellido1 #_Cat# ' ' #_Cat# dD.Papellido2 #_Cat# ' ' #_Cat# dD.Pnombre) as NombreCompleto, a.Externo	
		
		from ERequisicion a
		left outer join Usuario uR
			on uR.Usucodigo = a.BMUsucodigo
		left outer join DatosPersonales dR
			on uR.datos_personales = dR.datos_personales	
			
		left outer join Usuario uD
			on uD.Usucodigo = a.UsucodigoD
		left outer join DatosPersonales dD
			on uD.datos_personales = dD.datos_personales	
			
		where Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer" >
		  and ERid = <cfqueryparam value="#Form.ERid#" cfsqltype="cf_sql_numeric">
	</cfquery>
	
	<cfif rsForm.recordcount eq 0>
		<cfif LvarUsuarioAprobador eq 'true'>
			<cflocation url="RequisicionesAp.cfm">
		<cfelseif LvarUsuarioDespachador eq 'true'>
			<cflocation url="RequisicionesDesp.cfm">
		<cfelse>
			<cflocation url="Requisiciones-lista.cfm">
		</cfif>
	</cfif>

	<cfquery datasource="#session.DSN#" name="rsFormOfi">
		select Ocodigo, Oficodigo, Odescripcion
		from Oficinas
		where Ecodigo = <cfqueryparam value="#rsForm.EcodigoRequi#" cfsqltype="cf_sql_integer" >
		and Ocodigo = <cfqueryparam value="#rsForm.Ocodigo#" cfsqltype="cf_sql_integer" >
	</cfquery>

	<cfquery datasource="#session.DSN#" name="rsFormDepto">
		select Dcodigo, Deptocodigo, Ddescripcion
		from Departamentos
		where Ecodigo = <cfqueryparam value="#rsForm.EcodigoRequi#" cfsqltype="cf_sql_integer" >
			and Dcodigo = <cfqueryparam value="#rsForm.Dcodigo#" cfsqltype="cf_sql_integer" >
	</cfquery>

	<cfinvoke component="sif.Componentes.DButils" method="toTimeStamp" returnvariable="ts"
		arTimeStamp="#rsForm.ts_rversion#"/>

	<cfif (dmodo neq 'ALTA')>
		<cfquery datasource="#session.DSN#" name="rsFormDetalle">
			select a.DRlinea, a.ERid, a.Aid as aAid, a.DRcantidad, a.DRcosto, b.Acodigo, b.Adescripcion, c.CFid, c.CFcodigo, c.CFdescripcion, a.ts_rversion, a.FPAEid, a.CFComplemento
			from DRequisicion a 
				inner join Articulos b 
                	on b.Aid = a.Aid
				left outer join CFuncional c 
                	on c.CFid = a.CFid
			where a.ERid    = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.ERid#">
			  and a.DRlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.DRlinea#">
		</cfquery>
		<cfinvoke 
			component="sif.Componentes.DButils"
			method="toTimeStamp"
			returnvariable="tsdet"
			arTimeStamp="#rsFormDetalle.ts_rversion#"/>
	</cfif>
	<cfquery datasource="#session.DSN#" name="rsFormLineas">
		select 1 from DRequisicion 
		where ERid = <cfqueryparam value="#Form.ERid#" cfsqltype="cf_sql_numeric">
	</cfquery>
	<cfif rsFormLineas.recordcount>
		<cfif LvarUsuarioAprobador eq 'true'>
			<cfset Aplicar = "Aprobar">
			<cfset Imprime = "Imprimir">
		<cfelseif LvarUsuarioDespachador eq 'true'>
			<cfset Aplicar = "Despachado">
			<cfset Imprime = "Imprimir">
		<cfelse>
			<cfset Aplicar = "Aplicar">
			<cfset Imprime = "Imprimir">
		</cfif>
	</cfif>
<cfelse>
	<cfquery datasource="#session.DSN#" name="rsFormOfi">
		select Ocodigo, Oficodigo, Odescripcion
		from Oficinas
		where Ecodigo = -1
		and Ocodigo = -1
	</cfquery>

	<cfquery datasource="#session.DSN#" name="rsFormDepto">
		select Dcodigo, Deptocodigo, Ddescripcion
		from Departamentos
		where Ecodigo = -1
		and Dcodigo = -1		
	</cfquery>
</cfif>

<cfset modificar_campos = true >
<cfif modo neq 'ALTA' and len(trim(rsForm.ERidref)) >
	<cfset modificar_campos = false >
</cfif>


<!-- 2. Combo Almacen -->
<cfquery datasource="#session.DSN#" name="rsAlmacen">
	select A.Aid, A.Bdescripcion
	from Almacen A
    	inner join AResponsables R
           on R.Aid = A.Aid
           and A.Ecodigo =  R.Ecodigo
	where A.Ecodigo = <cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer" > 
     and R.Usucodigo = <cfqueryparam value="#session.Usucodigo#" cfsqltype="cf_sql_integer" > 
	order by Bdescripcion
</cfquery>

<!-- 3. Combo Requisicion -->
<cfquery datasource="#session.DSN#" name="rsTRequisicion">
	select rtrim(upper(TRcodigo)) as TRcodigo, TRdescripcion 
	from TRequisicion 
	where Ecodigo = <cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer" >  
	order by TRdescripcion
</cfquery>

<!-- 4. Combo Oficina -->
<cfquery datasource="#session.DSN#" name="rsOficinas">
	select Ocodigo, Odescripcion 
	from Oficinas 
	where Ecodigo = <cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer" >  
	order by Odescripcion
</cfquery>

<!-- 5. Combo Departamento -->
<cfquery datasource="#session.DSN#" name="rsDepartamentos">
	select Dcodigo, Ddescripcion from Departamentos 
	where Ecodigo = <cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer" >  
	order by Ddescripcion
</cfquery>

<!--- 6. Documentos existentes --->
<cfquery datasource="#session.DSN#" name="rsDocumentos">
	select rtrim(ERdocumento) as ERdocumento
	from ERequisicion 
	<cfif (modo neq 'ALTA')><!--- Para excluir de validación de documento existente al actual en modo cambio --->
		where ERdocumento not in  ( 
			select ERdocumento 
			from ERequisicion
			where Ecodigo = <cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer" > 
			  and ERid    = <cfqueryparam value="#Form.ERid#" cfsqltype="cf_sql_numeric">
		)
	</cfif>
	union select rtrim(ERdocumento) as ERdocumento
	from HERequisicion 
</cfquery>

<!----7. Combo de empresas ----->
<cfquery name="rsEmpresas" datasource="#session.DSN#">
	select Ecodigo, Edescripcion
	from Empresas 
	where cliente_empresarial = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.CEcodigo#">
		and Ecodigo != <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
</cfquery>

<script language="JavaScript" type="text/JavaScript" src="../../js/qForms/qforms.js"></script>
<script language="JavaScript" type="text/JavaScript" src="../../js/utilesMonto.js"></script>
<script language="JavaScript" type="text/JavaScript">
	<!--//
	// specify the path where the "/qforms/" subfolder is located
	qFormAPI.setLibraryPath("../../js/qForms/");
	// loads all default libraries
	qFormAPI.include("*");
	//-->
</script>

<cfif LvarUsuarioAprobador eq 'true'>
	<cfset LvarDir = "RequisicionesAp-sql.cfm">
<cfelseif LvarUsuarioDespachador eq 'true' >
	<cfset LvarDir = "RequisicionesDesp-sql.cfm">
<cfelse>
	<cfset LvarDir = "Requisiciones-sql.cfm">
</cfif>
<style type="text/css">
.RequiExterna {
	color: #F00;
}
</style>


<form name="requisicion" method="post" action="<cfoutput>#LvarDir#</cfoutput>" onsubmit="javascript: return validar();">
<cfoutput> 
<cfif (modo neq 'ALTA')>
	<input type="hidden" name="ERid" value="#rsForm.ERid#">
	<input type="hidden" name="ts_rversion" value="#ts#">
	<input type="hidden" name="LvarUsuarioAprobador" value="#LvarUsuarioAprobador#">	
	<input type="hidden" name="LvarUsuarioDespachador" value="#LvarUsuarioDespachador#">				
				

	<cfif isdefined("url.pageNum_lista") and not isdefined("form.pageNum_lista")>
		<cfset form.pageNum_lista = url.pageNum_lista >
	</cfif>

	<cfif isdefined("form.pageNum_lista") and len(trim(form.pageNum_lista))>
		<input type="hidden" name="pageNum_lista" value="#form.pageNum_lista#">
	</cfif>	

	<cfif (dmodo neq 'ALTA')>
		<input type="hidden" name="DRlinea" value="#rsFormDetalle.DRlinea#">
		<input type="hidden" name="ts_rversiondet" value="#tsdet#">
	</cfif>

</cfif>
<table width="100%"  border="0" cellspacing="1" cellpadding="1">
	<input type="hidden" name="EcodigoRequicion" value="<cfif modo neq 'ALTA'>#rsForm.EcodigoRequi#</cfif>">
	<tr><td class="subTitulo" align="center" colspan="6"><strong><font size="2">Encabezado de Requisici&oacute;n</font></strong></td></tr>
	<tr><td colspan="6">&nbsp;</td></tr>
	<tr>
		<td align="right" nowrap><strong>Documento:&nbsp;</strong></td>
		<td> 
			<input type="text" name="ERdocumento" size="20" maxlength="20" value="<cfif (modo neq 'ALTA')>#rsForm.ERdocumento#</cfif>" onfocus="javascript:this.select();" tabindex="1">
		</td>
		<td align="right" nowrap><strong>Descripci&oacute;n:&nbsp;</strong></td>
		<td> 
			<input type="text" name="ERdescripcion" size="35" maxlength="60"  onKeyUp="return maximaLongitud(this,60)" value="<cfif (modo neq 'ALTA')>#rsForm.ERdescripcion#</cfif>" onfocus="javascript:this.select();" tabindex="1">
		</td>
		<td align="right" nowrap><strong>Almac&eacute;n:&nbsp;</strong></td>
		<td>
			<cfif (modo neq 'ALTA')>
				<input type="hidden" name="Aid" value="#rsform.Aid#">
				<cfquery name="rsMiAlm" dbtype="query">
					select * from rsAlmacen
					where Aid = #rsform.Aid#
				</cfquery>
				#rsMiAlm.Bdescripcion#
			<cfelse>
            	<cfif rsAlmacen.recordcount eq 0>
                	<script>
							alert("El usuario no tiene Almacenes asociados, debe de ir al Catalogo y asociarle el Almacén.")
					</script>
                <cfelse>
				<select name="Aid" tabindex="1">
					<cfloop query="rsAlmacen">					
						<option value="#rsAlmacen.Aid#">#rsAlmacen.Bdescripcion#</option>
					</cfloop>						
				</select>
                </cfif>
			</cfif>
		</td>
	</tr>
	<tr>
		<td align="right" nowrap><strong>Tipo:&nbsp;</strong></td>
		<td>
			<select name="TRcodigo" tabindex="1" <cfif not modificar_campos>disabled="disabled"</cfif> >
				<cfloop query="rsTRequisicion">
					<option value="#rsTRequisicion.TRcodigo#" <cfif (modo neq 'ALTA') and (rsForm.TRcodigo EQ rsTRequisicion.TRcodigo)>selected</cfif>>#rsTRequisicion.TRdescripcion#</option>
				</cfloop>						
			</select>
		</td>
		<td align="right" nowrap><strong>Oficina:&nbsp;</strong></td>
		<td>
			<cfif modo neq 'ALTA' and rsdatos.total gt 0>
				<cfquery name="rsOficinas" datasource="#session.DSN#">
					select Ocodigo, Oficodigo, Odescripcion
					from Oficinas 
					where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsForm.EcodigoRequi#">
					  and Ocodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsForm.Ocodigo#">
				</cfquery>
				<input type="hidden" name="Ocodigo" id="Ocodigo" value="#rsForm.Ocodigo#"  ><!----<cfif modo neq 'ALTA' and len(trim(rsForm.EcodigoRequi))>disabled</cfif>--->				
				#rsOficinas.Odescripcion#
			<cfelse>
				<cfset valuesArrayO = ArrayNew(1)>
				<cfset ArrayAppend(valuesArrayO, rsFormOfi.Ocodigo)>
				<cfset ArrayAppend(valuesArrayO, rsFormOfi.Oficodigo)>
				<cfset ArrayAppend(valuesArrayO, rsFormOfi.Odescripcion)>
			
				<cf_conlis
					campos="Ocodigo, Oficodigo, Odescripcion"
					desplegables="N,S,S"
					modificables="N,S,N"
					size="0,8,24"
					title="Lista de Oficinas"
					valuesArray="#valuesArrayO#"
					tabla="Oficinas"
					columnas="Ocodigo, Oficodigo, Odescripcion"
					filtro="Ecodigo=#session.Ecodigo# order by Oficodigo"
					desplegar="Oficodigo, Odescripcion"
					filtrar_por="Oficodigo, Odescripcion"
					etiquetas="Código, Descripción"
					formatos="S,S"
					align="left,left"
					asignar="Ocodigo, Oficodigo, Odescripcion"
					form="requisicion"
					asignarformatos="S, S, S"
					showEmptyListMsg="true"
					EmptyListMsg="-- No se encontraron Oficinas --"
					tabindex="1">
			</cfif>	
		</td>
		<td align="right" nowrap><strong>Departamento:&nbsp;</strong></td>
		<td>
			<cfif modo neq 'ALTA' and rsdatos.total gt 0>
				<cfquery name="rsDeptos" datasource="#session.DSN#">
					select Dcodigo, Deptocodigo, Ddescripcion
					from Departamentos
					where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsForm.EcodigoRequi#">
					  and Dcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsForm.Dcodigo#">
				</cfquery>
				<input type="hidden" name="Dcodigo" id="Dcodigo" value="#rsForm.Dcodigo#"  ><!----<cfif modo neq 'ALTA' and len(trim(rsForm.EcodigoRequi))>disabled</cfif>--->				
				#rsDeptos.Ddescripcion#
			<cfelse>

				<cfset valuesArrayD = ArrayNew(1)>
				<cfset ArrayAppend(valuesArrayD, rsFormDepto.Dcodigo)>
				<cfset ArrayAppend(valuesArrayD, rsFormDepto.Deptocodigo)>
				<cfset ArrayAppend(valuesArrayD, rsFormDepto.Ddescripcion)>
			
				<cf_conlis
					campos="Dcodigo, Deptocodigo, Ddescripcion"
					desplegables="N,S,S"
					modificables="N,S,N"
					size="0,8,24"
					title="Lista de Departamentos"
					valuesArray="#valuesArrayD#"
					tabla="Departamentos"
					columnas="Dcodigo, Deptocodigo, Ddescripcion"
					filtro="Ecodigo=#session.Ecodigo# order by Deptocodigo"
					desplegar="Deptocodigo, Ddescripcion"
					filtrar_por="Deptocodigo, Ddescripcion"
					etiquetas="Código, Descripción"
					formatos="S,S"
					align="left,left"
					asignar="Dcodigo, Deptocodigo, Ddescripcion"
					form="requisicion"
					asignarformatos="S, S, S"
					showEmptyListMsg="true"
					EmptyListMsg="-- No se encontraron Departamentos --"
					tabindex="1">
			</cfif>
		</td>
	</tr>
	<tr>
		<td align="right" nowrap><strong>Fecha:&nbsp;</strong></td>
		<td nowrap>
			<cfif (modo neq 'ALTA')>
				<cfset fecha = LSDateFormat(rsForm.ERfecha,'dd/mm/yyyy')>
			<cfelse>
				<cfset fecha = LSDateFormat(Now(),'dd/mm/yyyy')>
			</cfif>
			<cfif modificar_campos>
				<cf_sifcalendario Conexion="#session.DSN#" form="requisicion" name="ERfecha" value="#fecha#" tabindex="1">
			<cfelse>
				<input type="text" size="10" disabled="disabled" name="ERfecha" value="#fecha#" />
			</cfif>
		</td>
		<td></td>
		<td>
			<table width="100%" cellpadding="0" cellspacing="0">
				<tr>
					<td valign="middle"><input type="checkbox" onclick="javascript:referencia();"  <cfif modo neq 'ALTA' and len(trim(rsForm.ERidref))>checked="checked"</cfif> <cfif modo neq 'ALTA'>disabled="disabled"</cfif> name="chkDevolucion" value=""  /></td>
					<td valign="middle">Requisici&oacute;n de devoluci&oacute;n</td>
				</tr>			
			</table>
		</td>
		<td id="label_referencia"><strong>Referencia:&nbsp;</strong></td>
		<td id="input_referencia">
			<cfset readonly = false >
			<cfset valuesArrayR = ArrayNew(1)>
			<cfif modo neq 'ALTA' and len(trim(rsForm.ERidref)) >
				<cfquery name="rsERidref" datasource="#session.DSN#">
					select ERid as ERidref, ERdocumento as ERdocumentoref, ERdescripcion as ERdescripcionref
					from HERequisicion
					where ERid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsForm.ERidref#">
				</cfquery>

				<cfset ArrayAppend(valuesArrayR, rsERidref.ERidref )>
				<cfset ArrayAppend(valuesArrayR, rsERidref.ERdocumentoref )>
				<cfset ArrayAppend(valuesArrayR, rsERidref.ERdescripcionref )>
			<cfelse>
				<cfset ArrayAppend(valuesArrayR, '' )>
				<cfset ArrayAppend(valuesArrayR, '' )>
				<cfset ArrayAppend(valuesArrayR, '' )>
			</cfif>
			
			<cfif modo neq 'ALTA'>
				<cfset readonly = true >
			</cfif>

			<cf_conlis
				campos="ERidref, ERdocumentoref, ERdescripcionref"
				desplegables="N,S,S"
				modificables="N,S,N"
				size="0,8,24"
				title="Lista de Requisiciones"
				valuesArray="#valuesArrayR#"
				tabla="HERequisicion"
				columnas="ERid as ERidref, ERdocumento as ERdocumentoref, ERdescripcion as ERdescripcionref"
				filtro="Ecodigo=#session.Ecodigo# and ERidref is null order by ERdocumento"
				desplegar="ERdocumentoref, ERdescripcionref"
				filtrar_por="ERdocumento, ERdescripcion"
				etiquetas="Código, Descripción"
				formatos="S,S"
				align="left,left"
				asignar="ERidref, ERdocumentoref, ERdescripcionref"
				form="requisicion"
				asignarformatos="S, S, S"
				showEmptyListMsg="true"
				EmptyListMsg="-- No se encontraron Requisiciones --"
				tabindex="1"
				readonly="#readonly#">
		</td>
		
	</tr>
	
	<tr>
		<cfif (modo neq 'ALTA')>
		<td align="right" nowrap><strong>Solicitado por:&nbsp;</strong></td>
		<td>#rsForm.NombreCompletoR#</td>
		</cfif>
	</tr>
	
	
	<tr>	<cfif LvarUsuarioAprobador eq 'true'>
		<td align="right" nowrap><strong>Despachador:&nbsp;</strong></td>
		<td>
			<cfset valuesArray = ArrayNew(1)>
			<cfquery name="rsResponsables" datasource="#Session.DSN#">
				select ar.Aid, ar.Ulocalizacion, u.Usulogin,ar.Ecodigo, u.Usucodigo as UsucodigoD,
						(d.Papellido1 #_Cat# ' ' #_Cat# d.Papellido2 #_Cat# ' ' #_Cat# d.Pnombre) as NombreCompleto
				from Usuario u
					inner join DatosPersonales d
						on u.datos_personales = d.datos_personales
					inner join AResponsables ar
						on  u.Usucodigo = ar.Usucodigo
					inner join Almacen a
						on ar.Aid = a.Aid	
							and ar.Ocodigo = a.Ocodigo
							and ar.Ecodigo = a.Ecodigo
				where ar.Aid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsform.Aid#">
				order by d.Papellido1, d.Papellido2, d.Pnombre
			</cfquery>
				<cfset valuesArrayD = ArrayNew(1)>
				<cfset ArrayAppend(valuesArrayD, rsForm.UsucodigoD)>
				<cfset ArrayAppend(valuesArrayD, rsForm.Usulogin)>
				<cfset ArrayAppend(valuesArrayD, rsForm.NombreCompleto)>
				<cf_conlis
					campos="UsucodigoD,Usulogin,NombreCompleto"
					desplegables="N,S,S"
					modificables="N,S,N"
					size="0,10,24"
					title="Lista de Despachadores"
					valuesArray="#valuesArrayD#"
					tabla="Usuario u
					inner join DatosPersonales d
						on u.datos_personales = d.datos_personales
					inner join AResponsables ar
						on  u.Usucodigo = ar.Usucodigo
					inner join Almacen a
						on ar.Aid = a.Aid	
							and ar.Ocodigo = a.Ocodigo
							and ar.Ecodigo = a.Ecodigo"
					columnas="u.Usucodigo as UsucodigoD,Usulogin,(Papellido1 #_Cat# ' ' #_Cat# Papellido2 #_Cat# ' ' #_Cat# Pnombre) as NombreCompleto"
					filtro="ar.Ecodigo=#session.Ecodigo# and ar.Aid = #rsform.Aid#"
					desplegar="Usulogin,NombreCompleto"
					filtrar_por="Usulogin,(Papellido1 #_Cat# ' ' #_Cat# Papellido2 #_Cat# ' ' #_Cat# Pnombre)"
					etiquetas="UsucodigoD,Identificación, Nombre"
					formatos="S,S,S"
					align="left,left,left"
					asignar="UsucodigoD,Usulogin, NombreCompleto"
					form="requisicion"
					asignarformatos="S,S, S"
					showEmptyListMsg="true"
					EmptyListMsg="-- No se encontraron Departamentos --"
					tabindex="1">
		</td>
		
		<td>
			<cf_botones values="Actualizar_Despachador" names="Actualizar_Despachador">
		</td>
		</cfif>
	</tr>
    <tr>
   		<td colspan="6" align="center">
                <cfset excluir = ''>
                <cfif not modificar_campos>
                    <span class="RequiExterna">
                    <cfset excluir = 'AltaDet,NuevoDet'>
                    </span>
                </cfif>
                <cfif isdefined('rsForm') and rsForm.Externo EQ 1>
                  <span class="RequiExterna"> 
                 		La requisición proviene de un sistema externo, por lo que no puede ser modificada
                  </span>.
				</cfif>
            
                <cfif LvarUsuarioDespachador eq 'true'>
                    <cf_botones generoenc="F" nameenc="Requisición" tabindex="3" include="#Aplicar# , #Imprime#" exclude="Alta,Nuevo,Limpiar">
                <cfelseif LvarUsuarioAprobador eq 'true'>
                    <cf_botones modo="#modo#" mododet="#dmodo#" generoenc="F" nameenc="Requisición" tabindex="3" include="#Aplicar#,#Imprime#,Anular" exclude="#excluir#,NuevoDet,Baja,BajaDet,Nuevo,Cambio,Alta,AltaDet">
                <cfelse>
                	<cfif isdefined('rsForm') and rsForm.Externo EQ 1>
                    	<cf_botones modo="#modo#" mododet="#dmodo#" generoenc="F" nameenc="Requisición" tabindex="3" include="#Aplicar#,#Imprime#" exclude="#excluir#,NuevoDet,Baja,BajaDet,Nuevo,Cambio,Alta,AltaDet,CambioDet">
                    <cfelse>
                    	<cf_botones modo="#modo#" mododet="#dmodo#" generoenc="F" nameenc="Requisición" tabindex="3" include="#Aplicar#,#Imprime#" exclude="#excluir#">
               		</cfif>
                </cfif>
    		</td>
           </tr>
	</table>
	
    <!---►►Detalle de la Requisicion◄◄--->
	<cfif (modo neq 'ALTA')>
		<table width="100%"  border="0" cellspacing="1" cellpadding="1">
			<tr>
            	<td class="subTitulo" align="center" colspan="2">
                	<strong><font size="2">Art&iacute;culos de Requisición</font></strong>
                 </td>
            </tr>
			<tr><td colspan="2">&nbsp;</td></tr>
			<cfif LvarUsuarioDespachador neq 'true'>
			<tr>
   				<td width="50%" valign="top" align="center">
					<table width="100%"  border="0" cellspacing="1" cellpadding="1">
						<tr>
							<td align="right" nowrap><strong>Artículo:&nbsp;</strong></td>
							<td>
								<cfif (dmodo neq 'ALTA') and rsPres.valor eq 1 and #rsVerificaS.cantidad# gt 0> 
                                    <cf_sifarticulos form="requisicion" id="aAid" query="#rsFormDetalle#" Almacen="Aid" tabindex="2" readonly="true">
                                <cfelseif (dmodo neq 'ALTA')> 
                                    <cf_sifarticulos form="requisicion" id="aAid" query="#rsFormDetalle#" Almacen="Aid" tabindex="2">
                                <cfelse>
                                    <cf_sifarticulos form="requisicion" id="aAid" Almacen="Aid" tabindex="2">
                                </cfif>
								<cfif not  modificar_campos >
                                    <script language="javascript1.2" type="text/javascript">
                                        document.requisicion.Acodigo.disabled = true;
                                    </script>
                                </cfif>
							</td>
							<td align="right" nowrap><strong>Cantidad:&nbsp;</strong></td>
                            <td>
                                <input type="text" name="DRcantidad" value="<cfif (dmodo NEQ 'ALTA')>#LSNumberFormat(rsFormDetalle.DRcantidad,',9.00000')#<cfelse>0.00000</cfif>"  size="17" maxlength="15" style="text-align: right;" onblur="javascript:fm(this,5); "  onfocus="javascript:this.value=qf(this); this.select();"  onkeyup="javascript:if(snumber(this,event,5)){ if(Key(event)=='13') {this.blur();}}" tabindex="2">
                            </td>
						</tr>
						<tr>
							<td align="right" nowrap><strong>Centro Funcional:</strong></td>
							<td>				
								<cfset valuesArrayCF = ArrayNew(1)>
                                <cfif dmodo neq 'ALTA'>
                                    <cfquery name="rsCentro" datasource="#session.DSN#">
                                        select CFid as CFpk, CFcodigo, CFdescripcion
                                        from CFuncional
                                        where CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsFormDetalle.CFid#" >
                                    </cfquery>
                                    <cfset ArrayAppend(valuesArrayCF, rsCentro.CFpk)>
                                    <cfset ArrayAppend(valuesArrayCF, rsCentro.CFcodigo)>
                                    <cfset ArrayAppend(valuesArrayCF, rsCentro.CFdescripcion)>
                                <cfelse>
                                    <cfset ArrayAppend(valuesArrayCF, '')>
                                    <cfset ArrayAppend(valuesArrayCF, '')>
                                    <cfset ArrayAppend(valuesArrayCF, '')>
                                </cfif>
                            
                                <cfset modCF = true >
                                <cfif not  modificar_campos >
                                    <cfset modCF = false >
                                </cfif>
                                
                                <cfif dmodo neq 'ALTA' and rsPres.valor eq 1 and #rsVerificaS.cantidad# gt 0> 
                                    <cfset readonly = 'true'>
                                <cfelse>
                                    <cfset readonly = "#not modCF#">
                                </cfif>
				
								<cfif rsVerificaS.cantidad gt 0> 
                                        <input type="hidden" name="LvarSolicitud" value="True">				
                                <cfelse>
                                        <input type="hidden" name="LvarSolicitud" value="False">				
                                </cfif>

                                <cf_conlis
                                    campos="CFpk, CFcodigo, CFdescripcion"
                                    desplegables="N,S,S"
                                    modificables="N,S,N"
                                    size="0,8,32"
                                    title="Lista de Centros Funcionales"
                                    valuesArray="#valuesArrayCF#"
                                    tabla="CFuncional"
                                    columnas="CFid as CFpk, CFcodigo, CFdescripcion"
                                    filtro="Ecodigo=#session.Ecodigo# and Ocodigo=$Ocodigo,integer$ and Dcodigo=$Dcodigo,integer$ order by CFcodigo"
                                    desplegar="CFcodigo, CFdescripcion"
                                    filtrar_por="CFcodigo, CFdescripcion"
                                    etiquetas="Código, Descripción"
                                    formatos="S,S"
                                    align="left,left"
                                    asignar="CFpk, CFcodigo, CFdescripcion"
                                    form="requisicion"
                                    asignarformatos="S, S, S"
                                    showEmptyListMsg="true"
                                    EmptyListMsg="-- No se encontraron Centros Funcionales --"
                                    tabindex="1"
                                    readonly="#readonly#" >
							</td>
                            <td nowrap="nowrap" align="right"><strong>Costo Aprox.</strong></td>
                            <td nowrap="nowrap"> <input type="text" name="CostoAprox" id="CostoAprox" value="" class="cajasinborde" readonly></td>
						</tr>	
                        <cfif rsActividad.Pvalor eq 'S'>
                        	<cfparam name="rsFormDetalle.FPAEid" 		default="">
                            <cfparam name="rsFormDetalle.CFComplemento" default="">
                            <tr>
                                <td nowrap="nowrap" align="right"><strong>Act.Empresarial:</strong></td>
                                <td>                              
                                	<cf_ActividadEmpresa formname="requisicion"  idActividad="#rsFormDetalle.FPAEid#" valores="#rsFormDetalle.CFComplemento#" etiqueta="">
								</td>
                            </tr>
                        </cfif>
					</table>
				</td>
			</tr>
		</cfif>
			
    	   <tr>
		   	<td width="50%" valign="top" align="center">
                <cfquery name="rsQuery" datasource="#session.dsn#">
                    select 
                            cf.CFdescripcion,
                        a.DRlinea as LDRlinea,
                        a.ERid as LERid, 
                        a.Aid as LAid, 
                        a.DRcantidad as LDRcantidad, 
                        b.Acodigo as LAcodigo, 
                        b.Adescripcion as LAdescripcion,
                        Ext.Eexistencia as Disponible 
                   from DRequisicion a 
                      inner join Articulos b 
                        on a.Aid = b.Aid 
                         left outer join CFuncional cf on cf.CFid = a.CFid
                      left outer join Existencias Ext
                        on b.Aid= Ext.Aid            
                     where a.ERid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ERid#">
                       and Ext.Alm_Aid =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsform.Aid#">	
                </cfquery>
  
				<cfif LvarUsuarioAprobador eq 'true'>
                    <cfset LvarDirec = "RequisicionesAp-form.cfm">
                    <cfset LvarLink = "true">
                <cfelseif LvarUsuarioDespachador eq 'true' >
                    <cfset LvarDirec = "RequisicionesDesp-form.cfm">
                    <cfset LvarLink = "false">
                <cfelse>
                    <cfset LvarDirec = "Requisiciones.cfm">
                    <cfset LvarLink = "true">
                </cfif>

                <cfinvoke component="sif.Componentes.pListas" method="pListaQuery" returnvariable="pListaRet">
                    <cfinvokeargument name="query" 				value="#rsQuery#"/>
                    <cfinvokeargument name="desplegar" 			value="LAcodigo, LAdescripcion, LDRcantidad, Disponible,CFdescripcion"/>
                    <cfinvokeargument name="etiquetas" 			value="Código, Descripción, Cantidad,Stock en Bodega,Centro Funcional"/>
                    <cfinvokeargument name="formatos" 			value="S, S, F, F,S"/>
                    <cfinvokeargument name="align" 				value="left, left, rigth,rigth, left"/>
                    <cfinvokeargument name="ajustar" 			value="N"/>
                    <cfinvokeargument name="irA" 				value="#LvarDirec#"/>
                    <cfinvokeargument name="showEmptyListMsg" 	value="true"/>
                    <cfinvokeargument name="keys" 				value="LERid,LDRlinea"/>
                    <cfinvokeargument name="navegacion" 		value="#navegacion#"/>
                    <cfinvokeargument name="incluyeform" 		value="false"/>
                    <cfinvokeargument name="formname" 			value="requisicion"/>
                    <cfinvokeargument name="maxrows" 			value="35"/>
                    <cfinvokeargument name="showLink" 			value="#LvarLink#"/>
                </cfinvoke>
			</td>
		</tr>
   </table>
  </cfif>
</cfoutput>
</form>
<iframe name="fr" id="fr" marginheight="0" marginwidth="0" frameborder="0" height="0" width="0" scrolling="auto" src="" ></iframe>
<iframe name="frMontoDet" id="frMontoDet" marginheight="0" marginwidth="0" frameborder="0" height="0" width="0" scrolling="auto" src="" ></iframe>	
<cfoutput>
<script language="JavaScript" type="text/javascript">
	var popUpWin = 0;
	
	<cfif LvarUsuarioDespachador neq 'true'>
	function funcAcodigo(){
		var params ="";	
		<cfif isdefined('CostoAprox')>	
		if ( document.requisicion.CostoAprox.value == '' || document.requisicion.CostoAprox.value == 0 || document.requisicion.Aid.value != ''){
				params = "&Alm_Aid=" + document.requisicion.Aid.value + "&Aid=" + document.requisicion.aAid.value;
				document.getElementById("frMontoDet").src="/cfmx/sif/iv/operacion/CostoAprox_Query.cfm?form=requisicion"+params;
			}
			else{
					document.requisicion.CostoAprox.value = '0.00';
				}
		</cfif>
	}
	</cfif>
	
	function popUpWindow(URLStr, left, top, width, height){
		if(popUpWin){
			if(!popUpWin.closed) popUpWin.close();
		}
		popUpWin = open(URLStr, 'popUpWin2', 'toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbar=no,resizable=no,copyhistory=yes,width='+width+',height='+height+',left='+left+', top='+top+',screenX='+left+',screenY='+top+'');
	}
	
	<!--//
	qFormAPI.errorColor = "##FFFFFF";
	objForm = new qForm("requisicion");

	function _Field_isDocNotExists(){
		<cfloop query="rsDocumentos">
			if ("#ERdocumento#"==this.value){
				this.error="El "+this.description+" ya existe.";
			}
		</cfloop>
	}
	_addValidator("isDocNotExists", _Field_isDocNotExists);
	
	function habilitarValidacion(){
		deshabilitarValidacion();
		objForm.ERdocumento.required = true;
		objForm.ERdocumento.description = "#JSStringFormat('Documento')#";
		objForm.ERdocumento.validateDocNotExists();
		objForm.ERdocumento.validate = true;
		objForm.ERdescripcion.required = true;
		objForm.ERdescripcion.description = "#JSStringFormat('Descripción')#";	
		objForm.Aid.required = true;
		objForm.Aid.description = "#JSStringFormat('Almacén')#";
		objForm.TRcodigo.required = true;
		objForm.TRcodigo.description = "#JSStringFormat('Tipo de Requisición')#";
		objForm.Ocodigo.required = true;
		objForm.Ocodigo.description = "#JSStringFormat('Oficina')#";
		objForm.Dcodigo.required = true;
		objForm.Dcodigo.description = "#JSStringFormat('Departamento')#";
		objForm.ERfecha.required = true;
		objForm.ERfecha.description = "#JSStringFormat('Fecha')#";
		<cfset deshabilitarValidacionDet = "">
		<cfif (modo neq 'ALTA')>
			if (document.requisicion.botonSel.value=="AltaDet"||document.requisicion.botonSel.value=="CambioDet") {
				objForm.aAid.required = true;
				objForm.aAid.description = "#JSStringFormat('Artículo')#";
				<cfif LvarUsuarioDespachador neq 'true'>
				objForm.DRcantidad.required = true;
				objForm.DRcantidad.description = "#JSStringFormat('Cantidad Artículo')#";
				</cfif>
				objForm.CFpk.required = true;
				objForm.CFpk.description = "#JSStringFormat('Centro Funcional')#";
			}
			
			if (document.requisicion.botonSel.value=="Aprobar"){
				objForm.Usulogin.required = true;
				objForm.Usulogin.description = "#JSStringFormat('Despachadores')#";
				}
			<cfif LvarUsuarioAprobador eq 'false' and  LvarUsuarioDespachador neq 'true'>
				<cfset deshabilitarValidacionDet = ",aAid,DRcantidad,CFpk">
			<cfelseif LvarUsuarioDespachador neq 'true'>
				<cfset deshabilitarValidacionDet = ",aAid,DRcantidad,CFpk,Usulogin">
			</cfif>
			
		</cfif>
				
		devolucion();
	}

	
	function deshabilitarValidacion(){
		objForm.required("ERdocumento,ERdescripcion,Aid,TRcodigo,Ocodigo,Dcodigo,ERfecha,ERidref#deshabilitarValidacionDet#",false);
	}
	
	habilitarValidacion();
	//-->
	
	function doConlisCFuncional() {
		var params ="";
		params = "?ARBOL_POS=0&EcodigoRequi="+document.requisicion.EcodigoRequi.value;
		popUpWindow("ConlisCFuncionalRequisicion.cfm"+params,250,200,650,460);
		//window.onfocus=closePopup;
	}
	
	function TraeCFuncional(dato){
		var params ="";
		if (dato != "") {
			document.getElementById("fr").src="CfuncionalRequisicionquery.cfm?dato="+dato+"&EcodigoRequi="+document.requisicion.EcodigoRequi.value;
		}
		else{
			document.requisicion.CFidR.value   = "";
			document.requisicion.CFcodigoR.value = "";
			document.requisicion.CFdescripcionR.value = "";
		}
		return;
	}	
	
	function devolucion(){
		if ( document.requisicion.chkDevolucion.checked ){
			objForm.ERidref.required = true;
			objForm.ERidref.description = "#JSStringFormat('Referencia')#";
			objForm.Aid.required = false;
			objForm.TRcodigo.required = false;
			objForm.Ocodigo.required = false;
			objForm.Dcodigo.required = false;
			objForm.ERfecha.required = true;
			<cfif modo neq 'ALTA'>
				objForm.aAid.required = false;
				objForm.CFpk.required = false;
			</cfif>
						
		}
		else{
			objForm.ERidref.required = false;
		}
	}
	
	function validar(){
		document.requisicion.chkDevolucion.disabled = false; 
		document.requisicion.TRcodigo.disabled = false; 
		document.requisicion.ERfecha.disabled = false; 
		document.requisicion.ERidref.disabled = false; 
		return true;	
	}
	
	function funcAprobar(){
	<cfif LvarDespacho eq 'false'>
		alert('Debe Actualizar el Despachador seleccionado.');
		return false;
	</cfif>
		habilitarValidacion();
	}
	
	function referencia(){
		if (document.requisicion.chkDevolucion.checked){
			document.getElementById("label_referencia").style.visibility = 'visible';	
			document.getElementById("input_referencia").style.visibility = 'visible';	
		}
		else{
			document.getElementById("label_referencia").style.visibility = 'hidden';	
			document.getElementById("input_referencia").style.visibility = 'hidden';	
		}
	}
	referencia();
	<cfif LvarUsuarioDespachador neq 'true'>
		funcAcodigo();
	</cfif>
	<cfif (modo neq 'ALTA')>
	function funcImprimir(){
		deshabilitarValidacion();
		var PARAM  = "ImprimeRequisicion.cfm?ERid=<cfoutput>#Form.ERid#</cfoutput>	&Alm_aid=<cfoutput>#rsform.Aid#</cfoutput>" 
		open(PARAM,'','left=100,top=150,scrollbars=yes,resizable=yes,width=860,height=520')
		return false;
	} </cfif>
	
	function funcAnular(){
		if (!confirm ('¿Esta seguro que desea eliminar la Requisición?'))
			return false;					
			document.requisicion.action = 'Requisiciones-sql.cfm';
			document.requisicion.submit;			
	}
	
	function maximaLongitud(texto,maxlong) {
	var tecla, in_value, out_value;
		if (texto.value.length > maxlong) {
			in_value = texto.value;
			out_value = in_value.substring(0,maxlong);
			texto.value = out_value;
			return false;
		}
		return true;
	}
  
	
</script>
</cfoutput>