<!--- Diccionario Aid = Almacen, aAid = Artículo --->
<!--- Url To Form --->
<cfif isdefined("url.EAid") and len(trim(url.EAid)) and not isdefined("form.EAid")>
	<cfset form.EAid = url.EAid>
</cfif>
<!--- ListaDET--->
<cfif isdefined("form.LEAid") and len(form.LEAid)>
	<cfset form.EAid = form.LEAid>
	<cfset form.DALinea = form.LDALinea>
</cfif>
<!--- Modo --->
<cfset modo = "ALTA">
<cfset dmodo = "ALTA">
<cfif not isdefined("form.btnNuevo") 
	and not isdefined("form.Nuevo")
	and isdefined("form.EAid") 
	and len(form.EAid)>
	<cfset modo = "CAMBIO">
	<cfif not isdefined("form.btnNuevoDet") 
		and not isdefined("form.NuevoDet")
		and isdefined("form.DALinea") 
		and len(form.DALinea)>
		<cfset dmodo = "CAMBIO">
	</cfif>
</cfif>

<cfset Aplicar = "">
<!-- Consultas -->
<!-- 1. Form, FormDet, y algo mas -->
<cfif (modo neq 'ALTA')>
	<cfquery datasource="#session.DSN#" name="rsForm">
		select a.EAid, a.EAdescripcion, a.Aid, rtrim(a.EAdocumento) as EAdocumento, a.EAfecha, a.EAusuario, a.ts_rversion 
		from EAjustes a inner join Almacen b on a.Aid = b.Aid and b.Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer" >
		where EAid = <cfqueryparam value="#Form.EAid#" cfsqltype="cf_sql_numeric">
	</cfquery>
	<cfif rsForm.recordcount eq 0>
		<cflocation url="Ajustes-lista.cfm">
	</cfif>
	<cfinvoke 
		component="sif.Componentes.DButils"
		method="toTimeStamp"
		returnvariable="ts"
		arTimeStamp="#rsForm.ts_rversion#"/>
	<cfif (dmodo neq 'ALTA')>
		<cfquery datasource="#session.DSN#" name="rsFormDetalle">
			select a.DALinea, a.EAid, a.Aid as aAid, a.DAcantidad, a.DAcosto, a.DAtipo, b.Acodigo, b.Adescripcion, a.ts_rversion
			from DAjustes a inner join Articulos b on a.Aid = b.Aid
			where a.EAid = <cfqueryparam value="#Form.EAid#" cfsqltype="cf_sql_numeric">
			  and a.DALinea = <cfqueryparam value="#Form.DALinea#" cfsqltype="cf_sql_numeric">
		</cfquery>
        
		<cfquery name="rsExist" datasource="#session.DSN#">
            select Eexistencia
            from Existencias 
            where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#"> 
              and Alm_Aid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsForm.Aid#">
              and Aid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsFormDetalle.aAid#">
		</cfquery>
        
		<cfinvoke 
			component="sif.Componentes.DButils"
			method="toTimeStamp"
			returnvariable="tsdet"
			arTimeStamp="#rsFormDetalle.ts_rversion#"/>
	</cfif>
	<cfquery datasource="#session.DSN#" name="rsFormLineas">
		select 1 from DAjustes
		where EAid = <cfqueryparam value="#Form.EAid#" cfsqltype="cf_sql_numeric">
	</cfquery>
	<cfif rsFormLineas.recordcount>
		<cfset Aplicar = "Aplicar">
	</cfif>
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

<!--- 3. Documentos existentes --->
<cfquery datasource="#session.DSN#" name="rsDocumentos">
	select rtrim(EAdocumento) as EAdocumento
	from EAjustes
	<cfif (modo neq 'ALTA')><!--- Para excluir de validación de documento existente al actual en modo cambio --->
		where EAdocumento not in  ( 
			select EAdocumento 
			from EAjustes a inner join Almacen b on a.Aid = b.Aid and b.Ecodigo = <cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer" > 
			where EAid    = <cfqueryparam value="#Form.EAid#" cfsqltype="cf_sql_numeric">
		)
	</cfif>
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
<form name="ajustes" method="post" action="Ajustes-sql.cfm">
<cfoutput>
<cfif (modo neq 'ALTA')>
	<input type="hidden" name="EAid" value="#rsForm.EAid#">
	<input type="hidden" name="ts_rversion" value="#ts#">
	<cfif isdefined("form.pagenum") and len(trim(form.pagenum))>
		<input type="hidden" name="pagina" value="#form.pagenum#">
	<cfelseif isdefined("form.PageNum_lista") and len(trim(form.PageNum_lista))>
		<input type="hidden" name="pagina" value="#form.PageNum_lista#">
	<cfelseif isdefined("form.pagina") and len(trim(form.pagina))>
		<input type="hidden" name="pagina" value="#form.pagina#">
	<cfelse>
		<input type="hidden" name="pagina" value="1">
	</cfif>
	<cfif (dmodo neq 'ALTA')>
		<input type="hidden" name="DALinea" value="#rsFormDetalle.DALinea#">
		<input type="hidden" name="ts_rversiondet" value="#tsdet#">
	</cfif>
</cfif>
<table width="100%"  border="0" cellspacing="1" cellpadding="1">
	<tr><td class="subTitulo" align="center" colspan="6"><strong><font size="2">Encabezado de Ajustes</font></strong></td></tr>
	<tr><td colspan="6">&nbsp;</td></tr>
	<tr>
		<td align="right" nowrap><strong>Documento:&nbsp;</strong></td>
		<td> 
			<input type="text" name="EAdocumento" size="20" maxlength="20" value="<cfif (modo neq 'ALTA')>#rsForm.EAdocumento#</cfif>" onfocus="javascript:this.select();" tabindex="1">
		</td>
		<td align="right" nowrap><strong>Descripci&oacute;n:&nbsp;</strong></td>
		<td> 
			<input type="text" name="EAdescripcion" size="35" maxlength="80" value="<cfif (modo neq 'ALTA')>#rsForm.EAdescripcion#</cfif>" onfocus="javascript:this.select();" tabindex="1">
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
		<td align="right" nowrap><strong>Fecha:&nbsp;</strong></td>
		<td nowrap>
			<cfif (modo neq 'ALTA')>
				<cfset fecha = LSDateFormat(rsForm.EAfecha,'dd/mm/yyyy')>
			<cfelse>
				<cfset fecha = LSDateFormat(Now(),'dd/mm/yyyy')>
			</cfif>
			<cf_sifcalendario Conexion="#session.DSN#" form="ajustes" name="EAfecha" value="#fecha#" tabindex="1">
		</td>
		<td></td>
		<td></td>
		<td></td>
		<td></td>
	</tr>
	</table>
	
	<br>
	<cfif (modo neq 'ALTA')>
	<!--- <fieldset><legend>Artículos de Ajuste</legend> --->
	<table width="100%"  border="0" cellspacing="1" cellpadding="1">
	<tr><td class="subTitulo" align="center" colspan="2"><strong><font size="2">Art&iacute;culos de Ajuste</font></strong></td></tr>
	<tr><td colspan="2">&nbsp;</td></tr>
	<tr>
	<td width="50%" valign="top" align="center">
	<cfquery name="rsQuery" datasource="#session.dsn#">
		select a.DALinea as LDALinea, a.EAid as LEAid, a.Aid as LAid, a.DAcantidad as LDAcantidad, a.DAcosto as LDAcosto, b.Acodigo as LAcodigo, 
		case a.DAtipo when 1 then 'Salida' else 'Entrada' end as LDAtipo, b.Adescripcion as LAdescripcion
		from DAjustes a inner join Articulos b on a.Aid = b.Aid
		where a.EAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.EAid#">
		order by a.DAtipo
	</cfquery>
	<cfinvoke 
			component="sif.Componentes.pListas"
			method="pListaQuery"
			returnvariable="pListaRet">
		<cfinvokeargument name="query" value="#rsQuery#"/>
		<cfinvokeargument name="desplegar" value="LAcodigo, LAdescripcion, LDAcantidad, LDAcosto"/>
		<cfinvokeargument name="cortes" value="LDAtipo"/>
		<cfinvokeargument name="etiquetas" value="Código, Descripción, Cantidad, Costo"/>
		<cfinvokeargument name="formatos" value="S, S, M, M"/>
		<cfinvokeargument name="align" value="left, left, rigth, rigth"/>
		<cfinvokeargument name="ajustar" value="N"/>
		<cfinvokeargument name="irA" value="Ajustes.cfm"/>
		<cfinvokeargument name="showEmptyListMsg" value="true"/>
		<cfinvokeargument name="keys" value="LEAid,LDALinea"/>
		<cfinvokeargument name="navegacion" value="EAid=#form.EAid#"/>
		<cfinvokeargument name="incluyeform" value="false"/>
		<cfinvokeargument name="formname" value="ajustes"/>
	</cfinvoke>
	</td>
    <td width="50%" valign="top" align="center">
	<table width="100%"  border="0" cellspacing="1" cellpadding="1">
		<tr>
			<td  colspan="3" align="right"></td>
			<td  colspan="1" align="center">
				<cf_botones values="Costo Promedio" names="CostoPromedio" tabindex="1">
			</td>
		</tr>
		<tr>
			<td align="right"><strong>Art&iacute;culo:&nbsp;</strong></td>
			<td>
				<cfif (dmodo neq 'ALTA')>
					<cf_sifarticulos form="ajustes" id="aAid" query="#rsFormDetalle#" Almacen="Aid" tabindex="2">
				<cfelse>
					<cf_sifarticulos form="ajustes" id="aAid" Almacen="Aid" tabindex="2">
				</cfif>
			</td>
			<td align="right"><strong>Cantidad:&nbsp;</strong></td>
			<td>
				<input type="text" name="DAcantidad" value="<cfif (dmodo NEQ 'ALTA')>#LSNumberFormat(rsFormDetalle.DAcantidad,',9.00000')#<cfelse>0.00000</cfif>"  size="17" maxlength="15" style="text-align: right;" onblur="javascript:fm(this,5); "  onfocus="javascript:this.value=qf(this); this.select();"  onkeyup="javascript:if(snumber(this,event,5)){ if(Key(event)=='13') {this.blur();}}" tabindex="2">
			</td>
		</tr>
		<tr>
			<td align="right"><strong>Tipo:&nbsp;</strong></td>
			<td>
				<select name="DAtipo" tabindex="2">
					<option value="1" <cfif (dmodo NEQ 'ALTA') and (rsFormDetalle.DAtipo eq 1)>selected</cfif>>Salida</option>
					<option value="0" <cfif (dmodo NEQ 'ALTA') and (rsFormDetalle.DAtipo eq 0)>selected</cfif>>Entrada</option>
				</select>
			</td>
			<td align="right" nowrap="nowrap"><strong>Costo Total:&nbsp;</strong></td>
			<td>
				<input type="text" name="DAcosto" value="<cfif (dmodo NEQ 'ALTA')>#LSCurrencyFormat(rsFormDetalle.DAcosto,'none')#<cfelse>0.00000</cfif>"  size="17" maxlength="15" style="text-align: right;" onblur="javascript:fm(this,2); "  onfocus="javascript:this.value=qf(this); this.select();"  onkeyup="javascript:if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}" tabindex="2">
			</td>
		</tr>
		<tr>
			<td align="right"><strong>Existencias:&nbsp;</strong></td>
			<td>
				<input type="text" name="Existencias" readonly="readonly" disabled="disabled" value="<cfif (dmodo NEQ 'ALTA')>#rsExist.Eexistencia#<cfelse></cfif>"  size="9" maxlength="15" style="text-align: right;" tabindex="2">
			</td>
			<td align="right" nowrap="nowrap"><strong>&nbsp;</strong></td>
			<td>&nbsp;
            	
			</td>
		</tr>
	</table>
	</td>
	</tr>
	</table>
	<!--- </fieldset> --->
	<br>
	</cfif>
    <cfset Imprime = "Imprimir">

	<cf_botones modo="#modo#" mododet="#dmodo#" generoenc="M" nameenc="Ajuste" tabindex="3" include="#Aplicar#,#Imprime#">
	<br>
</cfoutput>
</form>
<iframe name="fr" id="fr" marginheight="0" marginwidth="0" frameborder="0" height="0" width="0" scrolling="auto" src="" ></iframe>
<cfoutput>
<script language="JavaScript" type="text/javascript">
	<!--//
	qFormAPI.errorColor = "##FFFFCC";
	objForm = new qForm("ajustes");

	function _Field_isDocNotExists(){
		<cfloop query="rsDocumentos">
			if ("#EAdocumento#"==this.value){
				this.error="El "+this.description+" ya existe.";
			}
		</cfloop>
	}
	_addValidator("isDocNotExists", _Field_isDocNotExists);
	

	function habilitarValidacion(){
		deshabilitarValidacion();
		objForm.EAdocumento.required = true;
		objForm.EAdocumento.description = "#JSStringFormat('Código Documento')#";
		objForm.EAdocumento.validateDocNotExists();
		objForm.EAdocumento.validate = true;
		objForm.EAdescripcion.required = true;
		objForm.EAdescripcion.description = "#JSStringFormat('Descripción Documento')#";	
		objForm.Aid.required = true;
		objForm.Aid.description = "#JSStringFormat('Almacén')#";
		objForm.EAfecha.required = true;
		objForm.EAfecha.description = "#JSStringFormat('Fecha')#";
		<cfset deshabilitarValidacionDet = "">
		<cfif (modo neq 'ALTA')>
			if (document.ajustes.botonSel.value=="AltaDet"||document.ajustes.botonSel.value=="CambioDet") {
				objForm.aAid.required = true;
				objForm.aAid.description = "#JSStringFormat('Artículo')#";
				objForm.DAcantidad.required = true;
				objForm.DAcantidad.description = "#JSStringFormat('Cantidad Artículo')#";
				objForm.DAtipo.required = true;
				objForm.DAtipo.description = "#JSStringFormat('Tipo Movimiento Artículo')#";
				objForm.DAcosto.required = true;
				objForm.DAcosto.description = "#JSStringFormat('Costo Artículo')#";
			}
			<cfset deshabilitarValidacionDet = ",aAid,DAcantidad,DAtipo,DAcosto">
		</cfif>
	}
	
	function deshabilitarValidacion(){
		objForm.required("EAdocumento,EAdescripcion,Aid,EAfecha#deshabilitarValidacionDet#",false);
	}
	
	habilitarValidacion();
	
	function funcCostoPromedio(){
		var todoscampos = true;
		
		if(document.ajustes.Aid.value == ""){
			alert ("Debe selecionar un almacén");
			document.ajustes.Aid.focus();
			todoscampos = false;
			return false;
		}
		
		if(document.ajustes.aAid.value == ""){
			alert ("Debe selecionar un artículo");
			document.ajustes.Acodigo.focus();
			todoscampos = false;
		}
		
		if(document.ajustes.DAcantidad.value == ""){
			alert ("Debe indicar la cantidad");
			document.ajustes.DAcantidad.focus();
			todoscampos = false;
			return false;
		}		

		if(todoscampos){

			var PARAMS = "?aAid="+document.ajustes.aAid.value 
						+ "&Aid="+document.ajustes.Aid.value 
						+ "&DAcantidad="+qf(document.ajustes.DAcantidad.value);
			var frame  = document.getElementById("fr");
			frame.src 	= "AjustesTraePromedio.cfm" + PARAMS;
		}
		return false
	}
	
	<cfif (modo neq 'ALTA')>
	function funcImprimir(){
		deshabilitarValidacion();
		var PARAM  = "ImprimeAjuste.cfm?EAid=<cfoutput>#Form.EAid#</cfoutput><!---	&DALinea=<cfoutput>#Form.DALinea#</cfoutput>--->" 
		open(PARAM,'','left=100,top=150,scrollbars=yes,resizable=yes,width=860,height=520')
		return false;
	} 
	</cfif>


	
	//-->
</script>
</cfoutput>