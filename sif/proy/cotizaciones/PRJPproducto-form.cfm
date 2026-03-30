<cfif isdefined("url.PRJPPid") and len(trim(url.PRJPPid)) and not isdefined("form.PRJPPid")>
	<cfset form.PRJPPid = url.PRJPPid>
</cfif>

<!--- ListaDET--->
<cfif isdefined("form.APRJPPid") and len(form.APRJPPid)>
	<cfset form.PRJPPid = form.APRJPPid>
	<cfset form.PRJRid = form.APRJRid>
</cfif>

<cfif isdefined("url.PRJRid") and len(url.PRJRid) and not isdefined("form.PRJRid")>
	<cfset form.PRJRid = url.PRJRid>
</cfif>

<cfif isdefined("url.Ucodigo") and len(url.Ucodigo) and not isdefined("form.Ucodigo")>
	<cfset form.Ucodigo = url.Ucodigo>
</cfif>

<cfset modo = "ALTA">
<cfset dmodo = "ALTA">

<cfif not isdefined("form.btnNuevo") 
  and not isdefined("form.Nuevo")
  and isdefined("form.PRJPPid") 
  and len(form.PRJPPid)>
	<cfset modo = "CAMBIO">
	
	<cfif not isdefined("form.btnNuevoDet") 
	  and not isdefined("form.NuevoDet")
	  and isdefined("form.PRJRid") 
	  and len(form.PRJRid)>
		<cfset dmodo = "CAMBIO">
	</cfif>
	
</cfif>

<cfset Aplicar = "">

<cfif (modo neq 'ALTA')>

	<cfquery datasource="#session.DSN#" name="rsForm">
		select a.PRJPPid, a.PRJPPcodigo, a.PRJPPdescripcion, a.PRJPPfechaIni, a.PRJPPfechaFin, 
			   a.PRJPPcostoDirecto, a.PRJPPporcentajeIndirecto, a.ts_rversion,			   
			   (a.PRJPPcostoDirecto * (a.PRJPPporcentajeIndirecto/100)) as Cindirecto,
			   ((a.PRJPPcostoDirecto * (a.PRJPPporcentajeIndirecto/100)) + a.PRJPPcostoDirecto) as Punit,
			   a.Ucodigo
		from PRJPproducto a
		where a.Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer" >
		  and a.PRJPPid = <cfqueryparam value="#Form.PRJPPid#" cfsqltype="cf_sql_numeric">
	</cfquery>
	
	<cfif rsForm.recordcount eq 0>
		<cflocation url="Productos-lista.cfm">
	</cfif>
	
	<cfinvoke 
		component="sif.Componentes.DButils"
		method="toTimeStamp"
		returnvariable="ts"
		arTimeStamp="#rsForm.ts_rversion#"/>	
	
	<cfparam name="form.Ucodigo" default="#rsForm.Ucodigo#">
	<cfquery datasource="#session.DSN#" name="rsUnidades">
	Select Ucodigo as Ucodigo1, Ucodigo, Udescripcion
	from Unidades
	where Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
	  and Ucodigo = <cfqueryparam value="#Form.Ucodigo#" cfsqltype="cf_sql_char">
	</cfquery>

	<cfif (dmodo neq 'ALTA')>
		<cfquery datasource="#session.DSN#" name="rsFormDetalle">
			select a.PRJRid as PRJRid1, a.PRJPIcostoUnitario, a.PRJPIcantidad, b.PRJRcodigo, 
			       b.PRJRdescripcion,   b.PRJtipoRecurso,  b.Ucodigo,   a.ts_rversion
			from PRJPproductoInsumos a, PRJRecurso b
			where a.PRJRid  = b.PRJRid
			  and a.Ecodigo = b.Ecodigo 
			  and a.PRJPPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.PRJPPid#">
			  and a.Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
			  and a.PRJRid  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.PRJRid#">
		</cfquery>
		<cfinvoke 
			component="sif.Componentes.DButils"
			method="toTimeStamp"
			returnvariable="tsdet"
			arTimeStamp="#rsFormDetalle.ts_rversion#"/>
	</cfif>
	
	<cfquery datasource="#session.DSN#" name="rsFormLineas">
		select 1 from PRJPproductoInsumos
		where PRJPPid = <cfqueryparam value="#Form.PRJPPid#" cfsqltype="cf_sql_numeric">
		  and Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
	</cfquery>
	<cfif rsFormLineas.recordcount>
		<cfset Aplicar = "Aplicar">
	</cfif>	
				
</cfif>

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

<form name="frmProductos" method="post" action="PRJPproductos-sql.cfm">
<cfoutput>
	<cfif (modo neq 'ALTA')>
		<input type="hidden" name="PRJPPid" value="#rsForm.PRJPPid#">
		<input type="hidden" name="ts_rversion" value="#ts#">
		
		<cfif isdefined("form.pagina") and len(trim(form.pagina))>
			<input type="hidden" name="pagina" value="#form.pagina#">
		<cfelse>
			<input type="hidden" name="pagina" value="1">
		</cfif>		

	</cfif>
	
<table width="100%"  border="0" cellspacing="1" cellpadding="1">
<tr>
	<td class="subTitulo" align="center" colspan="6">
		<font size="2">Encabezado de Productos</font>
	</td>
</tr>
<tr>
	<td colspan="6">&nbsp;</td>
</tr>
<tr>
	<td align="right" nowrap><strong>C&oacute;digo:&nbsp;</strong></td>
	<td> 
			<input type="text" name="PRJPPcodigo" size="20" maxlength="20" value="<cfif (modo neq 'ALTA')>#rsForm.PRJPPcodigo#</cfif>" onfocus="javascript:this.select();" tabindex="1">
	</td>
	<td align="right" nowrap><strong>Descripci&oacute;n:&nbsp;</strong></td>
	<td> 
			<input type="text" name="PRJPPdescripcion" size="35" maxlength="80" value="<cfif (modo neq 'ALTA')>#rsForm.PRJPPdescripcion#</cfif>" onfocus="javascript:this.select();" tabindex="1">
	</td>
</tr>
<tr>
	<td align="right" nowrap><strong>Fecha Inicial:&nbsp;</strong></td>
	<td nowrap>
		<cfif (modo neq 'ALTA')>
			<cfset fecha = LSDateFormat(rsForm.PRJPPfechaIni,'dd/mm/yyyy')>
		<cfelse>
			<cfset fecha = LSDateFormat(Now(),'dd/mm/yyyy')>
		</cfif>
		<cf_sifcalendario Conexion="#session.DSN#" form="frmProductos" name="PRJPPfechainicial" value="#fecha#" tabindex="1">	
	</td>
	<td align="right" nowrap><strong>Fecha Final:&nbsp;</strong></td>
	<td nowrap>
		<cfif (modo neq 'ALTA')>
			<cfset fecha = LSDateFormat(rsForm.PRJPPfechaFin,'dd/mm/yyyy')>
		<cfelse>
			<cfset fecha = LSDateFormat(Now(),'dd/mm/yyyy')>
		</cfif>
		<cf_sifcalendario Conexion="#session.DSN#" form="frmProductos" name="PRJPPfechafinal" value="#fecha#" tabindex="1">
	</td>
</tr>
<tr>
	<td align="right" nowrap><strong>Costo Directo:&nbsp;</strong></td>
	<td nowrap align="left">
		<cfif (modo NEQ 'ALTA')>#LSCurrencyFormat(rsForm.PRJPPcostoDirecto,'none')#<cfelse>0.00</cfif>
		<input type="hidden" name="PRJPPcostoDirecto" readonly value="<cfif (modo NEQ 'ALTA')>#LSCurrencyFormat(rsForm.PRJPPcostoDirecto,'none')#<cfelse>0.00</cfif>"  size="20" maxlength="15" style="text-align: right;" onblur="javascript:fm(this,2); "  onfocus="javascript:this.value=qf(this); this.select();"  onkeyup="javascript:if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}" tabindex="2">
	</td>
	<td align="right" nowrap><strong>Pordentaje indirecto:&nbsp;</strong></td>
	<td nowrap>
		<input type="text" name="PRJPPporcentajeind" value="<cfif (modo NEQ 'ALTA')>#LSNumberFormat(rsForm.PRJPPporcentajeindirecto,',0')#<cfelse>0</cfif>"  size="20" maxlength="3" style="text-align: right;" onblur="javascript:if((this.value < 0) || (this.value > 100)){this.value='0'; alert('El porcentaje debe estar en un rango entre 0 y 100');}"  onfocus="javascript:this.value=qf(this); this.select();"  onkeyup="javascript:if(snumber(this,event,5)){ if(Key(event)=='13') {this.blur();}}" tabindex="2">
	</td>
</tr>

	<tr>
		<td align="right" nowrap><strong>Precio Unitario:&nbsp;</strong></td>
		<td nowrap align="left">
			<cfif (modo NEQ 'ALTA')>#LSCurrencyFormat(rsForm.PUnit,'none')#<cfelse>0.00</cfif>
		</td>
		<td align="right" nowrap><strong>Unidad:&nbsp;</strong></td>
		<td nowrap>
			<cfif (modo neq 'ALTA')>							
				<cf_sifunidades form="frmProductos" id="Ucodigo1" query="#rsUnidades#" tabindex="2">
			<cfelse>
				<cf_sifunidades form="frmProductos" id="Ucodigo1" tabindex="2">
			</cfif>					
		</td>
	</tr>
	<!--- 
	<tr>
		<td align="right" nowrap><strong>Importe:&nbsp;</strong></td>
		<td nowrap align="left">
			<cfif (modo NEQ 'ALTA')>#LSCurrencyFormat(Importe,'none')#<cfelse>0.00</cfif>
		</td>
		<td align="right" nowrap>&nbsp;</td>
		<td nowrap>&nbsp;</td>
	</tr> --->
</table>
<br><br>

<!--- Inicio de pintado de la pantalla de detalle --->
<cfif (modo neq 'ALTA')>
	
	<table width="100%"  border="0" cellspacing="1" cellpadding="1">
	<tr><td class="subTitulo" align="center" colspan="3"><font size="2">Insumos de Productos</font></td></tr>
	<tr><td colspan="3">&nbsp;</td></tr>
	<tr>
		<td width="50%" valign="top" align="center">
			<!--- Selecciona las lineas de detalle --->
			<cfquery name="rsQuery" datasource="#session.dsn#">
				select a.PRJPPid as APRJPPid, b.PRJRid as APRJRid, a.PRJPIcostoUnitario, a.PRJPIcantidad, b.PRJRcodigo, b.PRJRdescripcion, 
					   b.PRJtipoRecurso, b.Ucodigo
				from PRJPproductoInsumos a, PRJRecurso b
				where a.PRJRid  = b.PRJRid
				  and a.Ecodigo = b.Ecodigo 
				  and a.PRJPPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.PRJPPid#">
				  and a.Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
			</cfquery>
		
			<cfif isdefined("dmodo") and dmodo eq 'CAMBIO'>
				<cfset form.APRJPPid = form.PRJPPid>
				<cfset form.APRJRid = form.PRJRid>
			</cfif>
		
			<cfinvoke 
					component="sif.Componentes.pListas"
					method="pListaQuery"
					returnvariable="pListaRet">
	
			<cfinvokeargument name="query" value="#rsQuery#"/>
			<cfinvokeargument name="desplegar" value="PRJRcodigo, PRJRdescripcion, PRJPIcantidad, Ucodigo, PRJPIcostoUnitario"/>
			<cfinvokeargument name="cortes" value="PRJtipoRecurso"/>
			<cfinvokeargument name="etiquetas" value="Código, Descripción, Cantidad, Unidad, Unitario"/>
			<cfinvokeargument name="formatos" value="S, S, M, S, M"/>
			<cfinvokeargument name="align" value="left, left, rigth, center, rigth"/>
			<cfinvokeargument name="ajustar" value="S"/>
			<cfinvokeargument name="irA" value="PRJPproducto.cfm"/>
			<cfinvokeargument name="showEmptyListMsg" value="true"/>
			<cfinvokeargument name="keys" value="APRJPPid, APRJRid"/>
			<cfinvokeargument name="navegacion" value="PRJPPid=#form.PRJPPid#"/>
			<cfinvokeargument name="incluyeform" value="false"/>
			<cfinvokeargument name="formname" value="frmProductos"/>
			</cfinvoke>	
		</td>
		<td width="10%" valign="top" align="center">&nbsp;</td>
		<td width="40%" valign="top" align="center">
	
			<table width="100%"  border="0" cellspacing="1" cellpadding="1">
				<tr>
					<!--- <td align="right"><strong>Recurso:&nbsp;</strong></td> --->
					<td colspan="2">
						<cfif (dmodo neq 'ALTA')>							
							<cf_sifrecursos form="frmProductos" id="PRJRid1" query="#rsFormDetalle#" dmodo="#dmodo#" modo="#modo#" tabindex="2">
						<cfelse>
							<cf_sifrecursos form="frmProductos" id="PRJRid1" tabindex="2">
						</cfif>	
					</td>
			</tr>
			<!--- 
			<tr>
					<td align="right"><strong>Cantidad:&nbsp;</strong></td>
					<td>
						<input type="text" name="PRJPIcantidad" value="<cfif (dmodo NEQ 'ALTA')>#LSNumberFormat(rsFormDetalle.PRJPIcantidad,',9.00000')#<cfelse>0.00000</cfif>"  size="20" maxlength="15" style="text-align: right;" onblur="javascript:fm(this,5); "  onfocus="javascript:this.value=qf(this); this.select();"  onkeyup="javascript:if(snumber(this,event,5)){ if(Key(event)=='13') {this.blur();}}" tabindex="2">
					</td>			
			</tr>				
			<tr>
					<td align="right"><strong>Costo Unitario:&nbsp;</strong></td>
					<td>						
						<input type="text" name="PRJPIcostoUnitario" value="<cfif (dmodo NEQ 'ALTA')>#LSNumberFormat(rsFormDetalle.PRJPIcostoUnitario,',9.00000')#<cfelse>0.00000</cfif>"  size="20" maxlength="15" style="text-align: right;" onblur="javascript:fm(this,2); "  onfocus="javascript:this.value=qf(this); this.select();"  onkeyup="javascript:if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}" tabindex="2">					 
					</td>			
			</tr>		
			--->
			</table>
	
		</td>
	</tr>
	</table>
	<br>
</cfif>
<cf_botones modo="#modo#" mododet="#dmodo#" generoenc="M" tabindex="3">
<br>
</cfoutput>
</form>

<iframe name="fr" id="fr" marginheight="0" marginwidth="0" frameborder="1" height="0" width="0" scrolling="auto" src="" ></iframe>
<cfoutput>
<!--- 
<script language="JavaScript" type="text/javascript">
	<!--//
	qFormAPI.errorColor = "##FFFFCC";
	objForm = new qForm("frmProductos");

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
	//-->
</script> --->
</cfoutput>