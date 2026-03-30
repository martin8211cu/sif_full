<cf_dbfunction name="OP_concat"	returnvariable="_Cat">
<cfquery name="rsPeriodo" datasource="#session.dsn#">
	select <cf_dbfunction name="to_number" args="Pvalor" datasource="#session.dsn#"> as Pvalor
	from Parametros
	where Ecodigo = #session.Ecodigo#
		and Pcodigo = 50
		and Mcodigo = 'GN'
</cfquery>
<cfset rsPeriodos = QueryNew("Pvalor")>
<cfset temp = QueryAddRow(rsPeriodos,5)>
<cfset temp = QuerySetCell(rsPeriodos,"Pvalor",rsPeriodo.Pvalor-2,1)>
<cfset temp = QuerySetCell(rsPeriodos,"Pvalor",rsPeriodo.Pvalor-1,2)>
<cfset temp = QuerySetCell(rsPeriodos,"Pvalor",rsPeriodo.Pvalor+0,3)>
<cfset temp = QuerySetCell(rsPeriodos,"Pvalor",rsPeriodo.Pvalor+1,4)>
<cfset temp = QuerySetCell(rsPeriodos,"Pvalor",rsPeriodo.Pvalor+2,5)>

<cfquery name="rsQueryLista" datasource="#session.dsn#">
	select 
		afi.AFIperiodo, 
		afi.AFImes, 
		avg(afi.AFIindice) as IndiceProm,
		c.ACcodigo as ACcodigoClas,
		c.ACid as ACidClas,
		ct.ACcodigo as ACcodigoCat,
		c.ACcodigodesc  #_Cat# ' - ' #_Cat# c.ACdescripcion  as Clase, 
		ct.ACcodigodesc #_Cat# ' - ' #_Cat# ct.ACdescripcion as Categoria
	from AFIndices afi
		inner join AClasificacion c
		 on c.ACcodigo = afi.ACcodigo
		and c.ACid     = afi.ACid
		and c.Ecodigo  = afi.Ecodigo
		inner join ACategoria ct
		   on ct.Ecodigo = c.Ecodigo
			 and ct.ACcodigo = c.ACcodigo
	where afi.Ecodigo = #Session.Ecodigo#
	<cfif isdefined ("form.filter") and len(trim(form.filter))>
		and afi.AFIperiodo = #form.AFIperiodo#
		<cfif isdefined ("form.ACcodigoCat") and len(trim(form.ACcodigoCat))>
			and  afi.ACcodigo =  #form.ACcodigoCat#
		</cfif>
		<cfif isdefined ("form.ACidClas") and len(trim(form.ACidClas))>
			and  afi.ACid = #form.ACidClas#
		</cfif>
		<cfif isdefined ("form.ACidClas") and len(trim(form.ACidClas))>
			and  afi.ACid = #form.ACidClas#
		</cfif>
	</cfif>
	group by afi.AFIperiodo, afi.AFImes, c.ACcodigo, c.ACid, ct.ACcodigo, 
	c.ACcodigodesc  #_Cat# ' - ' #_Cat# c.ACdescripcion, 
	ct.ACcodigodesc #_Cat# ' - ' #_Cat# ct.ACdescripcion
	order by 7,8,1,2
</cfquery>  

<!--- Definición del Modo de la Forma --->
<cfif isdefined("form.AFIperiodo") and isdefined("form.AFImes")>
	<cfset modo = "CAMBIO">
<cfelse>
	<cfset modo = "ALTA">
</cfif>
<cfif isdefined("url.ACcodigoCat") and not isdefined("form.ACcodigoCat")>
	<cfset form.ACcodigoCat = url.ACcodigoCat>
</cfif>
<cfif isdefined("url.ACidClas") and not isdefined("form.ACidClas")>
	<cfset form.ACidClas = url.ACidClas>
</cfif>

<cfif isdefined("url.AFImes") and not isdefined("form.AFImes")>
	<cfset form.AFImes = url.AFImes>
</cfif>

<cfif isdefined("url.filter") and not isdefined("form.filter")>
	<cfset form.filter = url.filter>
</cfif>

<!--- Meses --->
<cfquery name="rsMeses" datasource="sifControl">
	select <cf_dbfunction name="to_number" datasource="sifControl" args="b.VSvalor"> as Pvalor, b.VSdesc as Pdescripcion
	from Idiomas a
		inner join VSidioma b 
		  on a.Iid = b.Iid	 
	where a.Icodigo = '#Session.Idioma#'
	and b.VSgrupo = 1
	order by <cf_dbfunction name="to_number" datasource="sifControl" args="b.VSvalor">
</cfquery>

<!---Form--->
<cfif modo neq "ALTA">
	<!--- Como existe 1 registro por cada periodo mes,
	 pero esta forma esta hecha para modificar todos a la vez,
	 se toma el primero para el control multiusuario.
	--->
	<cfquery name="rsAFIndices" datasource="#Session.DSN#" maxrows="1">
		select AFIperiodo, AFImes, AFIindice, ACcodigo, ACid, ts_rversion  
		from AFIndices
		where Ecodigo      = #Session.Ecodigo#
			and ACid       = #form.ACidClas#
			and ACcodigo   = #form.ACcodigoClas#
			and AFIperiodo = #form.AFIperiodo#
			and AFImes     = #form.AFImes#			
	</cfquery>
	
	<cfquery name="rsCategoriaClase" datasource="#session.dsn#">
		select 
				a.ACcodigo as ACcodigoCat, 
				a.ACcodigodesc as Categoria, 
				a.ACdescripcion as Categoriadesc,
			<cfif isdefined("form.ACidClas") and len(trim(form.ACidClas))> 
				  b.ACid as ACidClas 
				, b.ACcodigodesc as Clasificacion 
				, b.ACdescripcion as Clasificaciondesc
			<cfelse> 
				   '' as ACidClas
				, '' as Clasificacion
				, '' as Clasificaciondesc
			</cfif> 
		from AClasificacion b 
			inner join ACategoria a 
			   on a.ACcodigo = b.ACcodigo 
			  and a.Ecodigo = b.Ecodigo
		where b.Ecodigo = #session.Ecodigo#
		<cfif isdefined("form.ACidClas") and len(trim(form.ACidClas))>
			and b.ACid = #form.ACidClas#
		</cfif>
		<cfif isdefined("form.ACcodigoCat") and len(trim(form.ACcodigoCat))>
			and b.ACcodigo = #form.ACcodigoCat#
		</cfif>
	</cfquery>
</cfif>
<!---JavaScript--->
<script src="/cfmx/sif/js/utilesMonto.js"></script>

<!---Form--->
<cfoutput>
<form action="SQLAFIndices.cfm" method="post" name="form1">
	<input type="hidden" name="filter" id="filter" value="">
	
	<table width="100%"  border="0" cellspacing="0" cellpadding="3">
		<tr>
			<td colspan="5">
				<table width="100%" cellspacing="0" cellpadding="0" border="0">
					<tr>
						<td align="left" style="width:50%" nowrap><strong>Categor&iacute;a:&nbsp;</strong></td>
						<td align="left" style="width:50%" nowrap ><strong>Clase:&nbsp;</strong></td>
					</tr>
					<tr>
						<td align="left" nowrap colspan="2">
							<cfif (MODO neq 'ALTA')
									and (isdefined('rsAFIndices'))
									and (rsAFIndices.recordCount)>
								<cf_sifCatClase Modificable="false"	query="#rsCategoriaClase#" keyCat="ACcodigoCat" keyClas="ACidClas"  orientacion="H">
							<cfelse>
								<cf_sifCatClase keyCat="ACcodigoCat" keyClas="ACidClas"  orientacion="H">
							</cfif>
						</td>
					</tr>
				</table>
			</td>
		</tr>
		<tr>
			<td><strong>Periodo:</strong></td>
			<td><font color="red">*</font><strong>Mes:</strong></td>
			<td><font color="red">*</font><strong>&Iacute;ndice:</strong></td>
			<td>&nbsp;</td>
		</tr>
		<tr nowrap="nowrap">
			<td valign="top">
				<select name="AFIperiodo">
					<cfloop query="rsPeriodos">
					<option value="#Pvalor#" <cfif rsPeriodos.Pvalor eq form.AFIperiodo>selected</cfif>>#Pvalor#</option>
					</cfloop>
				</select>			
			</td>
			<td valign="top">
				<select name="AFImes">
					<cfloop query="rsMeses">
						<option value="#Pvalor#" <cfif modo neq "ALTA" and rsMeses.Pvalor eq form.AFImes>selected</cfif>>#Pdescripcion#</option>
					</cfloop>
					<!----<option value="1,2,3,4,5,6,7,8,9,10,11,12">--Todos--</option>---->
				</select>
			</td>
			<td valign="top">
				<input name="AFIindice" type="text" value="<cfif modo neq 'ALTA'>#rsAFIndices.AFIindice#</cfif>" size="14" maxlength="10" style="text-align: right;" onBlur="javascript:fm(this,8); "  onFocus="javascript:this.value=qf(this); this.select();"  onKeyUp="javascript:if(snumber(this,event,8)){ if(Key(event)=='13') {this.blur();}}">
			</td>
			<td nowrap="nowrap">
					<cf_botones modo=#modo# sufijo="Indice" include="Importar,Excepciones,Filtrar" exclude="Baja">
			</td>
		</tr>
	</table>
	<cfif modo NEQ "ALTA">
		<cfset ts = "">
		<cfinvoke component="sif.Componentes.DButils" method="toTimeStamp"returnvariable="ts">
			<cfinvokeargument name="arTimeStamp" value="#rsAFIndices.ts_rversion#"/>
		</cfinvoke>
		<input type="hidden" name="ts_rversion" value="#ts#">
		<input type="hidden" name="ACcodigo" value="#rsAFIndices.ACcodigo#">
		<input type="hidden" name="ACid" value="#rsAFIndices.ACid#">
	</cfif>
	<cfif modo eq "CAMBIO">
		<script language="JavaScript1.2" type="text/javascript">
				document.form1.AFIperiodo.disabled = true;
				document.form1.AFImes.disabled = true;
		</script>	
	</cfif>
</form>

</cfoutput>

<cf_qforms form="form1" >
<script language="JavaScript1.2" type="text/javascript">
	<!--//
	objForm.AFIperiodo.description="Período";
	objForm.AFImes.description="Mes";	
	objForm.AFIindice.description="Indice";
	
	function deshabilitarValidacion(){
		objForm.AFIperiodo.required = false;
		objForm.AFImes.required = false;
		objForm.AFIindice.required = false;
	}
	function habilitarValidacion(){
		objForm.AFIperiodo.required = true;
		objForm.AFImes.required = true;
		objForm.AFIindice.required = true;
	}
	habilitarValidacion();
	//objForm.AFIindice.obj.focus();

	function funcImportarIndice(){
		deshabilitarValidacion();
		document.form1.action = 'form_Importar_IndicesRevaluacion.cfm';
		document.form1.submit();
	}
	
	function funcFiltrarIndice(){
		document.form1.filter.value = "yes";
		deshabilitarValidacion();
		return true;
	}
	
	function funcEliminarIndice(){
		deshabilitarValidacion();
		return true;
	}
	
	function funcCambioIndice(){
		if(document.form1.AFIperiodo.disabled)
			document.form1.AFIperiodo.disabled = false;
		if(document.form1.AFImes.disabled)
			document.form1.AFImes.disabled = false;
		return true;
	}
	
	function funcExcepcionesIndice(){
		funcCambioIndice();
		deshabilitarValidacion();
		return true;
	}
	
	//-->	
</script>