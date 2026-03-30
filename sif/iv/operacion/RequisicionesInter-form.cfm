<!--- 
	Modificado por Gustavo Fonseca H.
		Fecha: 28-3-2006.
		Motivo: se corrige la navegación.
 --->

<!--- Diccionario Aid = Almacen, aAid = Artículo --->
<!--- Url To Form --->

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
<!--- Modo --->
<cfset modo = "ALTA">
<cfset dmodo = "ALTA">
<cfif not isdefined("form.btnNuevo") 
	and not isdefined("form.Nuevo")
	and isdefined("form.ERid") 
	and len(form.ERid)>
	<cfset modo = "CAMBIO">
	<cfif not isdefined("form.btnNuevoDet") 
		and not isdefined("form.NuevoDet")
		and isdefined("form.DRlinea") 
		and len(form.DRlinea)>
		<cfset dmodo = "CAMBIO">
	</cfif>
</cfif>
<cfset Aplicar = "">
<!-- Consultas -->
<!-- 1. Form, FormDet, y algo mas -->
<cfif (modo neq 'ALTA')>

	<cfquery name="rsdatos" datasource="#session.DSN#">
		select count(1) as total
		from DRequisicion
		where ERid = <cfqueryparam value="#Form.ERid#" cfsqltype="cf_sql_numeric">
	</cfquery>

	<cfquery datasource="#session.DSN#" name="rsForm">
		select ERid, ERdescripcion, Aid, rtrim(ERdocumento) as ERdocumento, Ocodigo, rtrim(upper(TRcodigo)) as TRcodigo, ERFecha, ERtotal, ERusuario, Dcodigo, <!--- coalesce(PRJAid, -1) as PRJAid,  --->ts_rversion 
				, EcodigoRequi, Ecodigo, ERidref
		from ERequisicion
		where Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer" >
		  and ERid = <cfqueryparam value="#Form.ERid#" cfsqltype="cf_sql_numeric">
	</cfquery>

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

	<cfif rsForm.recordcount eq 0>
		<cflocation url="RequisicionesInter-lista.cfm">
	</cfif>
	<cfinvoke 
		component="sif.Componentes.DButils"
		method="toTimeStamp"
		returnvariable="ts"
		arTimeStamp="#rsForm.ts_rversion#"/>
	<!--- DEMO INI --->
	<!---
	<cfset vPRJAid = -1 >
	<cfif len(trim(rsForm.PRJAid))>
		<cfset vPRJAid = rsForm.PRJAid >
	</cfif>
	<cfquery name="rsActividad" datasource="#session.DSN#">
		select PRJid, PRJAid, PRJAcodigo, PRJAdescripcion
		from PRJActividad
		where PRJAid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#vPRJAid#">
	</cfquery>
	<cfset vPRJid = -1 >
	<cfif rsActividad.RecordCount gt 0 and len(trim(rsActividad.PRJid))>
		<cfset vPRJid = rsActividad.PRJid >
	</cfif>
	<cfquery name="rsProyecto" datasource="#session.DSN#">
		select PRJid, PRJcodigo, PRJdescripcion
		from PRJproyecto
		where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		  and PRJid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#vPRJid#">
	</cfquery>
	--->
	<!--- DEMO FIN --->
	<!--- Ya está validado en el Aplicar
	<cfquery name="rsAplicar" datasource="#session.DSN#">
		select 1 
		from ERequisicion a inner join CTipoRequisicion b on a.Ecodigo = b.Ecodigo and a.Dcodigo = b.Dcodigo and a.TRcodigo = b.TRcodigo
		where a.Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer" >
		  and a.ERid = <cfqueryparam value="#Form.ERid#" cfsqltype="cf_sql_numeric">
	</cfquery>--->
	<cfif (dmodo neq 'ALTA')>
		<cfquery datasource="#session.DSN#" name="rsFormDetalle">
			select a.DRlinea, a.ERid, a.Aid as aAid, a.DRcantidad, a.DRcosto, b.Acodigo, b.Adescripcion, c.CFid, c.CFcodigo, c.CFdescripcion, a.ts_rversion
			from DRequisicion a 
				inner join Articulos b on b.Aid = a.Aid
				left outer join CFuncional c on c.CFid = a.CFid
			where a.ERid = <cfqueryparam value="#Form.ERid#" cfsqltype="cf_sql_numeric">
			  and a.DRlinea = <cfqueryparam value="#Form.DRlinea#" cfsqltype="cf_sql_numeric">
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
		<cfset Aplicar = "Aplicar">
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

<!--- ====== DEVOUCION ====== --->
<cfset modificar_campos = true >
<cfif modo neq 'ALTA' and len(trim(rsForm.ERidref)) >
	<cfset modificar_campos = false >
</cfif>
<!--- ====== DEVOUCION ====== --->

<!-- 2. Combo Almacen -->
<cfquery datasource="#session.DSN#" name="rsAlmacen">
	select Aid, Bdescripcion
	from Almacen 
	where Ecodigo = <cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer" > 
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
<!--- Ini DEMO

	var popUpWin=0;
	function popUpWindow(URLStr, left, top, width, height){
	  if(popUpWin) {
		if(!popUpWin.closed) popUpWin.close();
	  }
	  popUpWin = open(URLStr, 'popUpWin', 'toolbar=no,location=no,directories=no,status=no,menub ar=no,scrollbar=no,resizable=no,copyhistory=yes,width='+width+',height='+height+',left='+left+', top='+top+',screenX='+left+',screenY='+top+'');
	}
	function doConlis() {
		popUpWindow("ConlisArticulos.cfm?form=requisicion&id=aAid&desc=Adescripcion&cant=cant&cantTemp=cantTemp&AlmIni=" + document.requisicion.Aid.value ,250,200,650,350);
	}

	function doConlisProyecto() {
		var f = document.form1;
		popUpWindow("ConlisProyectos.cfm?formulario=requisicion&id=PRJid&codigo=PRJcodigo&desc=PRJdescripcion",250,200,650,400);
	}
	function TraeProyecto(dato) {
		var params ="";
		params = "&formulario=requisicion&id=PRJid&codigo=PRJcodigo&desc=PRJdescripcion";
		if (trim(dato) != "") {
			document.getElementById("fr").src="/cfmx/sif/iv/operacion/proyectoquery.cfm?dato="+dato+"&form=form1"+params;
		}
		else{
			document.requisicion.PRJid.value = "";
			document.requisicion.PRJcodigo.value = "";
			document.requisicion.PRJdescripcion.value = "";
			document.requisicion.PRJAid.value = "";
			document.requisicion.PRJAcodigo.value = "";
			document.requisicion.PRJAdescripcion.value = "";

		}
		return;
	}	
	function doConlisActividad() {
		if ( trim(document.requisicion.PRJid.value) != '' ){
			var f = document.form1;
			popUpWindow("ConlisActividades.cfm?formulario=requisicion&proyecto="+document.requisicion.PRJid.value+"&id=PRJAid&codigo=PRJAcodigo&desc=PRJAdescripcion",250,200,650,400);
		}	
		else{
			alert('Debe seleccionar el proyecto.');
		}
	}
	function TraeActividad(dato) {
		if ( trim(document.requisicion.PRJid.value) != '' ){
			if (trim(dato) != "") {
				var params ="";
				params = "&proyecto="+document.requisicion.PRJid.value+"&formulario=requisicion&id=PRJAid&codigo=PRJAcodigo&desc=PRJAdescripcion";
				document.getElementById("fr").src="/cfmx/sif/iv/operacion/actividadquery.cfm?dato="+dato+"&form=form1"+params;
			}
			else{
				document.requisicion.PRJAid.value = "";
				document.requisicion.PRJAcodigo.value = "";
				document.requisicion.PRJAdescripcion.value = "";
			}
		}	
		else{
			alert('Debe seleccionar el proyecto.');
		}
		return;
	}	
	
--->
<form name="requisicion" method="post" action="RequisicionesInter-sql.cfm" onsubmit="javascript: return validar();">
<cfoutput>
<cfif (modo neq 'ALTA')>
	<input type="hidden" name="ERid" value="#rsForm.ERid#">
	<input type="hidden" name="ts_rversion" value="#ts#">

	<cfif isdefined("form.pageNum_lista") and len(trim(form.pageNum_lista))>
		<input type="hidden" name="pageNum_lista" value="#form.pageNum_lista#">
	</cfif>	

<!---
	<cfelseif isdefined("form.PageNum_lista") and len(trim(form.PageNum_lista))>
		<input type="hidden" name="pagina" value="#form.PageNum_lista#">
	<cfelseif isdefined("form.pagina") and len(trim(form.pagina))>
		<input type="hidden" name="pagina" value="#form.pagina#">
	<cfelse>
		<input type="hidden" name="pagina" value="1">
	</cfif>
	--->
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
			<input type="text" name="ERdescripcion" size="35" maxlength="80" value="<cfif (modo neq 'ALTA')>#rsForm.ERdescripcion#</cfif>" onfocus="javascript:this.select();" tabindex="1">
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
				<select name="Aid" tabindex="1">
					<cfloop query="rsAlmacen">					
						<option value="#rsAlmacen.Aid#">#rsAlmacen.Bdescripcion#</option>
					</cfloop>						
				</select>
			</cfif>
		</td>
	</tr>
	<tr>
		<td align="right" nowrap><strong>Empresa:&nbsp;</strong></td>

		<td>
			<cfif modo neq 'ALTA' and rsdatos.total gt 0>
				<cfquery name="rsEmpresas" datasource="#session.DSN#">
					select Ecodigo, Edescripcion
					from Empresas 
					where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsForm.EcodigoRequi#">
				</cfquery>
				<input type="hidden" name="EcodigoRequi" id="EcodigoRequi" value="#rsForm.EcodigoRequi#"  ><!----<cfif modo neq 'ALTA' and len(trim(rsForm.EcodigoRequi))>disabled</cfif>--->				
				#rsEmpresas.Edescripcion#
			<cfelse>
				<select name="EcodigoRequi" id="EcodigoRequi" <cfif modo neq 'ALTA'>onchange="javascript:cambiar_empresa();"</cfif>  ><!----<cfif modo neq 'ALTA' and len(trim(rsForm.EcodigoRequi))>disabled</cfif>--->				
					<cfloop query="rsEmpresas">
						<option value="#rsEmpresas.Ecodigo#" <cfif modo neq 'ALTA' and rsEmpresas.Ecodigo EQ rsForm.EcodigoRequi>selected</cfif>>#HTMLEditFormat(rsEmpresas.Edescripcion)#</option>
					</cfloop>
				</select>
			</cfif>			
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
					filtro="Ecodigo=$EcodigoRequi,integer$ order by Oficodigo"
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
					filtro="Ecodigo=$EcodigoRequi,integer$ order by Deptocodigo"
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
		<td align="right" nowrap><strong>Tipo:&nbsp;</strong></td>
		<td>
			<select name="TRcodigo" tabindex="1" <cfif not modificar_campos>disabled="disabled"</cfif>>
				<cfloop query="rsTRequisicion">
					<option value="#rsTRequisicion.TRcodigo#" <cfif (modo neq 'ALTA') and (rsForm.TRcodigo EQ rsTRequisicion.TRcodigo)>selected</cfif>>#rsTRequisicion.TRdescripcion#</option>
				</cfloop>						
			</select>
		
		</td>
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
		<!---==========---->
		<td align="right"></td>
		<td align="left" nowrap><input type="hidden" name="Intercompany" value="1" ></td>
		<td></td>
		<!---==========---->				
		<td></td>
		<!--- DEMO INI --->
		<!---
		<td align="right"><strong>Proyecto:&nbsp;</strong></td>
		<td>
			<input 	name="PRJcodigo" type="text" size="15" maxlength="15" onblur="javascript:TraeProyecto(this.value);" value="<cfif (modo neq 'ALTA')>#rsProyecto.PRJcodigo#</cfif>" onFocus="this.select();">
			<input 	name="PRJdescripcion" type="text" size="30" maxlength="40" readonly value="<cfif (modo neq 'ALTA')>#rsProyecto.PRJdescripcion#</cfif>">
			<img id="imgArticulo" src="../../imagenes/Description.gif" alt="Lista" name="imagen" width="18" height="14" border="0" align="absmiddle" onClick="javascript:doConlisProyecto();">
			<input name="PRJid" type="hidden" value="<cfif (modo neq "ALTA")>#rsProyecto.PRJid#</cfif>"> 
		</td>
		<td align="right"><strong>Actividad:&nbsp;</strong></td>
		<td>
			<input name="PRJAcodigo" type="text" size="15" maxlength="15" onblur="javascript:TraeActividad(this.value);" value="<cfif (modo neq 'ALTA')>#rsActividad.PRJAcodigo#</cfif>" onFocus="this.select();">
			<input name="PRJAdescripcion" type="text"  size="30" maxlength="40" readonly value="<cfif (modo neq 'ALTA')>#rsActividad.PRJAdescripcion#</cfif>">
			<img id="imgArticulo" src="../../imagenes/Description.gif" alt="Lista" name="imagen" width="18" height="14" border="0" align="absmiddle" onClick="javascript:doConlisActividad();">
			<input name="PRJAid" type="hidden" value="<cfif (modo neq "ALTA")>#rsActividad.PRJAid#</cfif>"> 
		</td>
		--->
		<!--- DEMO FIN --->
	</tr>
	
	<!--- ========== DEVOLUCION ========== --->
	<tr>
		<td></td>
		<td>
			<table width="100%" cellpadding="0" cellspacing="0">
				<tr>
					<td valign="middle"><input type="checkbox" onclick="javascript:referencia();" <cfif modo neq 'ALTA' and len(trim(rsForm.ERidref))>checked="checked"</cfif> <cfif modo neq 'ALTA'>disabled="disabled"</cfif> name="chkDevolucion" value=""  /></td>
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
	<!--- ========== DEVOLUCION ========== --->	
	
	</table>
	
	<br>
	<cfif (modo neq 'ALTA')>
	<!--- <fieldset><legend>Artículos de la Requisición</legend> --->
	<table width="100%"  border="0" cellspacing="1" cellpadding="1">
	<tr><td class="subTitulo" align="center" colspan="2"><strong><font size="2">Art&iacute;culos de Requisici&oacute;n</font></strong></td></tr>
	<tr><td colspan="2">&nbsp;</td></tr>
	<tr>
	<td width="50%" valign="top" align="center">
	<cfquery name="rsQuery" datasource="#session.dsn#">
		select a.DRlinea as LDRlinea, a.ERid as LERid, a.Aid as LAid, a.DRcantidad as LDRcantidad, b.Acodigo as LAcodigo, b.Adescripcion as LAdescripcion
		from DRequisicion a inner join Articulos b on a.Aid = b.Aid
		where a.ERid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ERid#">
	</cfquery>
	<cfinvoke 
			component="sif.Componentes.pListas"
			method="pListaQuery"
			returnvariable="pListaRet">
		<cfinvokeargument name="query" value="#rsQuery#"/>
		<cfinvokeargument name="desplegar" value="LAcodigo, LAdescripcion, LDRcantidad"/>
		<cfinvokeargument name="etiquetas" value="Código, Descripción, Cantidad"/>
		<cfinvokeargument name="formatos" value="S, S, F"/>
		<cfinvokeargument name="align" value="left, left, rigth"/>
		<cfinvokeargument name="ajustar" value="N"/>
		<cfinvokeargument name="irA" value="RequisicionesInter.cfm"/>
		<cfinvokeargument name="showEmptyListMsg" value="true"/>
		<cfinvokeargument name="keys" value="LERid,LDRlinea"/>
		<cfinvokeargument name="navegacion" value="#navegacion#"/>
		<cfinvokeargument name="incluyeform" value="false"/>
		<cfinvokeargument name="formname" value="requisicion"/>
		<cfinvokeargument name="maxrows" value="35"/>
	</cfinvoke>
	</td>
    <td width="50%" valign="top" align="center">
	<table width="100%"  border="0" cellspacing="1" cellpadding="1">
		<tr>
			<td align="right" nowrap><strong>Art&iacute;culo:&nbsp;</strong></td>
			<td>
				<cfif (dmodo neq 'ALTA')>
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
			<td id="TDCfuncional" >
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
				<cf_conlis
					campos="CFpk, CFcodigo, CFdescripcion"
					desplegables="N,S,S"
					modificables="N,S,N"
					size="0,8,32"
					title="Lista de Centros Funcionales"
					valuesArray="#valuesArrayCF#"
					tabla="CFuncional"
					columnas="CFid as CFpk, CFcodigo, CFdescripcion"
					filtro="Ecodigo=$EcodigoRequi,integer$ and Ocodigo=$Ocodigo,integer$ and Dcodigo=$Dcodigo,integer$ order by CFcodigo"
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
					readonly="#not modCF#" >
			</td>
			<td nowrap="nowrap"><strong>Costo Aprox.:</strong></td>
			<td nowrap="nowrap"> <input type="text" name="CostoAprox" id="CostoAprox" value="" class="cajasinborde" readonly></td>
		</tr>
	</table>
	</td>
	</tr>
	</table>
	<!--- </fieldset> --->
	<br>
	</cfif>
	<cfset Imprime = "Imprimir">
	<cfset excluir = ''>
	<cfif not modificar_campos>
		<cfset excluir = 'AltaDet,NuevoDet'>
	</cfif>

	<cf_botones modo="#modo#" mododet="#dmodo#" generoenc="F" nameenc="Requisición" tabindex="3" include="#Aplicar#,#Imprime#" exclude="#excluir#">
	<br>
</cfoutput>
</form>
<iframe name="fr" id="fr" marginheight="0" marginwidth="0" frameborder="1" height="0" width="0" scrolling="auto" src="" ></iframe>
<iframe name="frMontoDet" id="frMontoDet" marginheight="0" marginwidth="0" frameborder="0" height="0" width="0" scrolling="auto" src="" ></iframe>	
<cfoutput>
<script language="JavaScript" type="text/javascript">
	var popUpWin = 0;
	
	function funcAcodigo(){
		var params ="";		
		if ( document.requisicion.CostoAprox.value == '' || document.requisicion.CostoAprox.value == 0 || document.requisicion.Aid.value != ''){
				params = "&Alm_Aid=" + document.requisicion.Aid.value + "&Aid=" + document.requisicion.aAid.value;
				document.getElementById("frMontoDet").src="/cfmx/sif/iv/operacion/CostoAprox_Query.cfm?form=requisicion"+params;
			}
			else{
					document.requisicion.CostoAprox.value = '0.00';
				}


	}


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
		objForm.ERdocumento.description = "#JSStringFormat('Código Documento')#";
		objForm.ERdocumento.validateDocNotExists();
		objForm.ERdocumento.validate = true;
		objForm.ERdescripcion.required = true;
		objForm.ERdescripcion.description = "#JSStringFormat('Descripción Documento')#";	
		objForm.Aid.required = true;
		objForm.Aid.description = "#JSStringFormat('Almacén')#";
		objForm.EcodigoRequi.required = true;
		objForm.EcodigoRequi.description = "#JSStringFormat('Empresa')#";
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
				objForm.DRcantidad.required = true;
				objForm.DRcantidad.description = "#JSStringFormat('Cantidad Artículo')#";
				<cfif modo neq 'ALTA' >
					objForm.CFpk.required = true;
					objForm.CFpk.description = "#JSStringFormat('Centro Funcional')#";
				</cfif>
			}
			<cfset deshabilitarValidacionDet = ",aAid,DRcantidad,CFpk">
		</cfif>
		devolucion();
	}
	
	function deshabilitarValidacion(){
		objForm.required("ERdocumento,ERdescripcion,Aid,EcodigoRequi,TRcodigo,Ocodigo,Dcodigo,ERfecha,ERidref#deshabilitarValidacionDet#",false);
	}
	
	habilitarValidacion();
	//-->
	
	
	function doConlisCFuncional() {
		var params ="";
		params = "?ARBOL_POS=0&EcodigoRequi="+document.requisicion.EcodigoRequi.value+"&Ocodigo=" + document.requisicion.Ocodigo.value+"&Dcodigo=" + document.requisicion.Dcodigo.value;
		popUpWindow("ConlisCFuncionalRequisicion.cfm"+params,250,200,650,460);
		//window.onfocus=closePopup;
	}
	
	function TraeCFuncional(dato){
		var params ="";
		if (dato != "") {
			document.getElementById("fr").src="CfuncionalRequisicionquery.cfm?dato="+dato+"&EcodigoRequi="+document.requisicion.EcodigoRequi.value+"&Ocodigo=" + document.requisicion.Ocodigo.value+"&Dcodigo=" + document.requisicion.Dcodigo.value;
		}
		else{
			document.requisicion.CFpk.value   = "";
			document.requisicion.CFcodigo.value = "";
			document.requisicion.CFdescripcion.value = "";
		}
		return;
	}

	function cambiar_empresa(){
		document.requisicion.Ocodigo.value = '';
		document.requisicion.Oficodigo.value = '';
		document.requisicion.Odescripcion.value = '';
		document.requisicion.Dcodigo.value = '';
		document.requisicion.Deptocodigo.value = '';
		document.requisicion.Ddescripcion.value = '';
		document.requisicion.CFpk.value = '';
		document.requisicion.CFcodigo.value = '';
		document.requisicion.CFdescripcion.value = '';
	}

	function devolucion(){
		if ( document.requisicion.chkDevolucion.checked ){
			objForm.ERidref.required = true;
			objForm.ERidref.description = "#JSStringFormat('Referencia')#";
			objForm.Aid.required = false;
			objForm.TRcodigo.required = false;
			objForm.Ocodigo.required = false;
			objForm.Dcodigo.required = false;
			objForm.ERfecha.required = false;
			<cfif modo neq 'ALTA'>
				objForm.aAid.required = false;
				objForm.CFpk.required = false;
			</cfif>
						
		}
		else{
			objForm.ERidref.required = false;
		}
	}
	
	
	<cfif (modo neq 'ALTA')>
	function funcImprimir(){
		deshabilitarValidacion();
		var PARAM  = "ImprimeRequisicion.cfm?ERid=<cfoutput>#Form.ERid#</cfoutput>	&Alm_aid=<cfoutput>#rsform.Aid#</cfoutput>&Intercompany=true" 
		open(PARAM,'','left=100,top=150,scrollbars=yes,resizable=yes,width=860,height=520')
		return false;
	} 
	</cfif>

	
	
	function validar(){
		document.requisicion.chkDevolucion.disabled = false; 
		document.requisicion.TRcodigo.disabled = false; 
		document.requisicion.ERfecha.disabled = false; 
		document.requisicion.ERidref.disabled = false; 
		return true;	
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
	funcAcodigo();
</script>
<!---
	function funcMuestraEmpresas(pobj_check){
		var tdLabel = document.getElementById("TDLabelEmpresa");
		var tdCombo = document.getElementById("TDComboEmpresa");
		<cfif modo neq 'ALTA'>
			var tdCfuncional = document.getElementById("TDCfuncional");
			var tdCF = document.getElementById("TDCF");		
		</cfif>
		if (pobj_check.checked){
			tdLabel.style.display = '';
			tdCombo.style.display = '';
			<cfif modo neq 'ALTA'>
				tdCfuncional.style.display = '';
				tdCF.style.display = 'none';
			</cfif>
		}
		else{
			tdLabel.style.display = 'none';
			tdCombo.style.display = 'none';
			<cfif modo neq 'ALTA'>
				tdCfuncional.style.display = 'none';
				tdCF.style.display = '';
			</cfif>		
		}		
	}

--->
</cfoutput>