<cffunction name="fnobtieneParametrosForm" access="private" output="no">
	<cfquery name="rsMeses" datasource="sifControl">
		select <cf_dbfunction args="b.VSvalor" name="to_number" datasource="sifControl"> as VSvalor, b.VSdesc 
		from Idiomas a, VSidioma b 
		where a.Icodigo = '#Session.Idioma#'
			and a.Iid = b.Iid
			and b.VSgrupo = 1
		order by <cf_dbfunction args="b.VSvalor" name="to_number" datasource="sifControl">
	</cfquery>
	
	<cfquery name="rsPer" datasource="#Session.DSN#">
		select distinct Eperiodo
		from EContablesImportacion
		where Ecodigo = #session.Ecodigo#
		order by Eperiodo desc
	</cfquery>
	
	<cfquery name="rsUsuarios" datasource="#Session.DSN#">
		select u.Usucodigo, min(u.Usulogin) as UsuloginDESC, count(1) as Cantidad
		  from EContablesImportacion e
			inner join Usuario u
				on u.Usucodigo = e.BMUsucodigo
		  where e.Ecodigo = #Session.Ecodigo#
			and u.CEcodigo = #session.CEcodigo#
		  group by u.Usucodigo
		  order by UsuloginDESC
	</cfquery>
	
	<cfquery name="rsLotes" datasource="#Session.DSN#">
		select  a.Cconcepto, Cdescripcion
		from ConceptoContableE a
		where a.Ecodigo = #Session.Ecodigo#
		and ( 
			select count(1) 
			from UsuarioConceptoContableE b 
			where a.Cconcepto = b.Cconcepto
			  and a.Ecodigo   = b.Ecodigo
			) = 0  
		UNION
		select a.Cconcepto, Cdescripcion 
		from UsuarioConceptoContableE b
			inner join ConceptoContableE a
			on a.Cconcepto = b.Cconcepto
			and a.Ecodigo = b.Ecodigo
		where b.Usucodigo  = #Session.Usucodigo#
		  and a.Ecodigo = #Session.Ecodigo#
	</cfquery>
	<cfif isdefined("Url.bfiltrar") and not isdefined("Form.bfiltrar")>
		<cfparam name="Form.bfiltrar" default="#Url.bfiltrar#">
	</cfif>
	<cfif isdefined("Url.lote") and not isdefined("Form.lote")>
		<cfparam name="Form.lote" default="#Url.lote#">
	</cfif>
	<cfif isdefined("Url.fechadesde") and not isdefined("Form.fechadesde")>
		<cfparam name="Form.fechadesde" default="#Url.fechadesde#">
	</cfif>
	<cfif isdefined("Url.descripcion") and not isdefined("Form.descripcion")>
		<cfparam name="Form.descripcion" default="#Url.descripcion#">
	</cfif>
	<cfif isdefined("Url.fechahasta") and not isdefined("Form.fechahasta")>
		<cfparam name="Form.fechahasta" default="#Url.fechahasta#">
	</cfif>
	<cfif isdefined("Url.periodo") and not isdefined("Form.periodo")>
		<cfparam name="Form.periodo" default="#Url.periodo#">
	</cfif>
	<cfif isdefined("Url.mes") and not isdefined("Form.mes")>
		<cfparam name="Form.mes" default="#Url.mes#">
	</cfif>
	<cfif isdefined("Url.descripcion") and not isdefined("Form.descripcion")>
		<cfparam name="Form.descripcion" default="#Url.descripcion#">
	</cfif>
	<cfif isdefined("Url.ver") and not isdefined("Form.ver")>
		<cfset form.ver = url.ver >
	</cfif>
	<cfif isdefined("url.Usucodigo") and not isdefined("form.Usucodigo")>
		<cfset form.Usucodigo = url.Usucodigo>	
	</cfif>
	<cfif isdefined("url.pageNum_lista") and len(trim(url.pageNum_lista)) and not isdefined("form.pageNum_lista")>
		<cfset form.pageNum_lista = url.pageNum_lista >
	</cfif>
	
	<cfparam name="form.ver" default="25">
	<cfif isdefined("form.ver") and len(trim(form.ver)) eq 0>
		<cfset form.ver = 25 >
	</cfif> 
	
	<cfif not isdefined("Form.fechadesde")>
		<cfset Form.fechadesde = LSDateFormat(CreateDate(year(now()), month(now()),1), 'dd/mm/yyyy')>
	</cfif>
	<cfif not isdefined("Form.fechahasta")>
		<cfset Form.fechahasta = LSDateFormat(Now(), 'dd/mm/yyyy')>
	</cfif>
	
	<cfset navegacion = "">
	<cfif isdefined("Form.bfiltrar")>
		<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "bfiltrar=" & Form.bfiltrar>
	</cfif>
	<cfif isdefined("Form.lote")>
		<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "lote=" & Form.lote>
	</cfif>
	<cfif isdefined("Form.fechadesde")>
		<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "fechadesde=" & Form.fechadesde>
	</cfif>
	<cfif isdefined("Form.descripcion")>
		<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "descripcion=" & Form.descripcion>
	</cfif>
	
	<cfif isdefined("Form.fechahasta")>
		<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "fechahasta=" & Form.fechahasta>
	</cfif>
	<cfif isdefined("Form.periodo") and Len(Trim(Form.periodo)) NEQ 0>
		<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "periodo=" & Form.periodo>
	</cfif>
	<cfif isdefined("Form.mes") and Len(Trim(Form.mes)) NEQ 0>
		<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "mes=" & Form.mes>
	</cfif>
	<cfif isdefined("Form.descripcion") and Len(Trim(Form.descripcion)) NEQ 0>
		<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "descripcion=" & Form.descripcion>
	</cfif>
	<cfif isdefined("Form.ver") and Len(Trim(Form.ver)) NEQ 0>
		<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "ver=" & Form.ver>
	</cfif>
	<cfif isdefined("Form.usucodigo") and Len(Trim(Form.usucodigo)) NEQ 0>
		<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "usucodigo=" & Form.usucodigo>
	</cfif>

	<cfquery name="rsLista" datasource="#Session.DSN#">
		select 
			a.ECIid, 
			a.Cconcepto, 
			( select b.Cdescripcion 
				from ConceptoContableE b
				where  b.Ecodigo = a.Ecodigo
				  and b.Cconcepto = a.Cconcepto
				) as Cdescripcion,
			a.Eperiodo, 
			a.Emes, 
			a.Efecha, 
			a.Edescripcion, 
			a.Edocbase, 
			a.Ereferencia, 
			a.BMfalta, 
			a.BMUsucodigo, 
			'' as balanceada, 
			0 as inactivada,
			(select coalesce(sum(c.Doriginal),0)
				from DContablesImportacion c
				where c.ECIid = a.ECIid
				and c.Dmovimiento = 'D'
				) as Debitos,
			(select coalesce(sum(c.Doriginal ),0)
				from DContablesImportacion c
				where c.ECIid = a.ECIid
				and c.Dmovimiento = 'C'
				) as Creditos
		from EContablesImportacion a
		where a.Ecodigo = #Session.Ecodigo#
		<cfif isdefined("form.descripcion") and len(trim(form.descripcion))>
			and upper(a.Edescripcion) like '%#ucase(form.descripcion)#%'
		</cfif>
		<cfif isdefined("form.lote") and isdefined("form.bfiltrar") and form.lote NEQ -1>
			and a.Cconcepto = #form.lote#
		</cfif>	
		<cfif isdefined("form.fechadesde") and len(trim(form.fechadesde)) and isdefined("form.fechahasta") and len(trim(form.fechahasta)) and isdefined("form.bfiltrar")>
			and a.Efecha between <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(form.fechadesde)#"> and <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(form.fechahasta)#">
		<cfelseif isdefined("form.fechadesde") and len(trim(form.fechadesde)) and isdefined("form.bfiltrar")>
			and a.Efecha >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(form.fechadesde)#">
		<cfelseif isdefined("form.fechahasta") and len(trim(form.fechahasta)) and isdefined("form.bfiltrar")>
			and a.Efecha <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(form.fechahasta)#">
		</cfif>
		<cfif isdefined("form.periodo") and len(trim(form.periodo)) and isdefined("form.bfiltrar") and form.periodo NEQ -1>
			and a.Eperiodo = #form.periodo#
		</cfif>	
		<cfif isdefined("form.mes") and len(trim(form.mes)) and form.mes NEQ -1 and isdefined("form.bfiltrar")>
			and a.Emes = #form.mes#
		</cfif>	
		<cfif isdefined("form.descripcion") and len(trim(form.descripcion)) and isdefined("form.bfiltrar")>
			and upper(a.Edescripcion) like '%#UCase(form.descripcion)#%'
		</cfif>	
		<cfif isdefined("Form.Usucodigo") and len(trim(form.usucodigo)) and form.Usucodigo NEQ -11>
			and a.BMUsucodigo = #form.Usucodigo#
		</cfif>
	</cfquery>
</cffunction>
<cfset fnobtieneParametrosForm()>
<!--- <script language="javascript1.2" type="text/javascript" src="/cfmx/sif/js/utilesMonto.js"></script> --->
<script language="javascript" type="text/javascript">
	function funcLimpiar(){
		document.filtros.reset();
		document.filtros.descripcion.value = "";
		document.filtros.fechadesde.value = "<cfoutput>#LSDateFormat(CreateDate(year(now()), month(now()),1), 'dd/mm/yyyy')#</cfoutput>";
		document.filtros.fechahasta.value = "<cfoutput>#LSDateFormat(now(),'dd/mm/yyyy')#</cfoutput>";
		document.filtros.periodo.value = " ";
		document.filtros.mes.value = "-1";
		document.filtros.ver.value = "25";
		return false;
	}
	function funcAplicar() {
		return true;
	}
	function funcNuevo() {
	 //PASA DIRECTO
	}
	function Marcar(c) {
		if (c.checked) {
			for (counter = 0; counter < document.form1.chk.length; counter++)
			{
				if ((!document.form1.chk[counter].checked) && (!document.form1.chk[counter].disabled))
					{  document.form1.chk[counter].checked = true;}
			}
			if ((counter==0)  && (!document.form1.chk.disabled)) {
				document.form1.chk.checked = true;
			}
		}
		else {
			for (var counter = 0; counter < document.form1.chk.length; counter++)
			{
				if ((document.form1.chk[counter].checked) && (!document.form1.chk[counter].disabled))
					{  document.form1.chk[counter].checked = false;}
			};
			if ((counter==0) && (!document.form1.chk.disabled)) {
				document.form1.chk.checked = false;
			}
		};
	}
</script>
<cf_templateheader title="Importaci&oacute;n de Documentos Contables">
	<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo="Importaci&oacute;n de Documentos Contables">
		<cfinclude template="../../portlets/pNavegacion.cfm">
		<cfoutput>
			<form method="post" name="filtros" action="#GetFileFromPath(GetTemplatePath())#" class="AreaFiltro" style="margin:0;">
			<table width="100%"  border="0" cellspacing="2" cellpadding="0">
				<tr>
					<td align="right"><strong>Lote:</strong>&nbsp;</td>
					<td>
						<select name="lote">
							<option value="-1">Todos</option>
							<cfloop query="rsLotes"> 
								<option value="#Cconcepto#"<cfif isdefined("form.lote") and form.lote eq Cconcepto>selected</cfif>>#Cdescripcion#</option>
							</cfloop> 
						</select>
					</td>
					<td align="right" nowrap><strong>Fecha Desde:&nbsp;</strong></td>
					<td align="left" nowrap>
						<cf_sifcalendario form="filtros" value="#LSDateFormat(form.fechadesde,'dd/mm/yyyy')#" name="fechadesde">
					</td>
					<td align="right" nowrap><strong>Fecha Hasta:&nbsp;</strong></td>
					<td align="left" nowrap>
						<cf_sifcalendario form="filtros" value="#LSDateFormat(form.fechahasta,'dd/mm/yyyy')#" name="fechahasta">
					</td>
				</tr>
				<tr>
					<td align="right" nowrap><strong>Periodo:&nbsp;</strong> </td>
					<td>
						<select name="periodo">
							<option value="-1">Todos</option>
							<cfloop query="rsPer">
								<option value="#Eperiodo#" <cfif isdefined("form.periodo") and form.periodo eq Eperiodo>selected</cfif>>#Eperiodo#</option>
							</cfloop>
						</select>
					</td>
					<td align="right" nowrap><strong>Mes:&nbsp;</strong> </td>
					<td align="left" nowrap>
						<select name="mes">
							<option value="-1">Todos</option>				  
							<cfloop query="rsMeses">
								<option value="#VSvalor#"<cfif isdefined("form.mes") and form.mes eq VSvalor> selected</cfif>>#VSdesc#</option>
							</cfloop>	
						</select>
					</td>
					<td align="right" nowrap><strong>Ver:&nbsp;</strong> </td>
					<td align="left" nowrap>
						<input tabindex="1" type="text" name="ver" style="text-align:right"size="10" maxlength="3" 
						onKeyUp="if(this,event,0){ if(Key(event)=='13') {this.blur();}}"
						onFocus="javascript:this.select();" 
						onBlur="javascript: if ((this.value) == ''){ this.value = 25; };" 
						value="<cfif isdefined("form.ver")>#form.ver#</cfif>">
					</td>
				</tr>
				<tr>
					<td align="right" nowrap><strong>Usuario:&nbsp;</strong> </td>
					<td>
						<select name="Usucodigo">
							<option value="-11">Todos</option>
							<cfloop query="rsUsuarios">
								<option value="#rsUsuarios.Usucodigo#" <cfif isdefined("form.Usucodigo") and form.Usucodigo eq rsUsuarios.Usucodigo>selected</cfif> >#rsUsuarios.UsuloginDESC#</option>
							</cfloop>
						</select>
					</td>
					<td align="right" nowrap><strong>Descripci&oacute;n:&nbsp;</strong> </td>
					<td colspan="3" align="left" nowrap>
						<input type="text" name="descripcion" size="75" maxlength="100" value="<cfif isdefined("form.descripcion")>#form.descripcion#</cfif>">
					</td>

				</tr>
				<tr>
					<cfif rsLista.recordcount GT 0>
						<td align="center" nowrap><input name="chkTodos" type="checkbox" value="" border="0" onClick="javascript:Marcar(this);"><strong>Seleccionar Todos</strong></td>
					<cfelse>
						<td>&nbsp;</td>
					</cfif>
					<td colspan="5" align="center"><input type="submit" name="bFiltrar" value="Filtrar">
						<input type="submit" name="bLimpiar" value="Limpiar" onclick=" return funcLimpiar();">
					</td>
				</tr>
			</table>
			</form>
		</cfoutput>
		<form name="form1" method="post" action="DocContablesImportacion.cfm" style="margin:0;">
			<cfoutput>
			<input name="PageNum_lista" type="hidden" value="<cfif isdefined("form.PageNum_lista") and len(trim(form.PageNum_lista))>#form.PageNum_lista#<cfelse>1</cfif>" tabindex="-1">
			<input name="lote" type="hidden" value="<cfif isdefined("form.lote") and len(trim(form.lote))>#form.lote#</cfif>" tabindex="-1">
			<input name="descripcion" type="hidden" value="<cfif isdefined("form.descripcion")and len(trim(form.descripcion))>#form.descripcion#</cfif>" tabindex="-1">
			<input name="periodo" type="hidden" value="<cfif isdefined("form.periodo")and len(trim(form.periodo))>#form.periodo#</cfif>" tabindex="-1">
			<input name="mes" type="hidden" value="<cfif isdefined("form.mes") and len(trim(form.mes))>#form.mes#</cfif>" tabindex="-1">
			<input name="ver" type="hidden" value="<cfif isdefined("form.ver") and len(trim(form.ver)) >#form.ver#</cfif>" tabindex="-1">
			<input name="Usucodigo" type="hidden" value="<cfif isdefined("form.Usucodigo") and len(trim(form.Usucodigo))>#form.Usucodigo#</cfif>" tabindex="-1">
			<input name="fechadesde" type="hidden" value="<cfif isdefined("form.fechadesde") and len(trim(form.fechadesde))>#form.fechadesde#</cfif>" tabindex="-1">
			<input name="fechahasta" type="hidden" value="<cfif isdefined("form.fechahasta") and len(trim(form.fechahasta))>#form.fechahasta#</cfif>" tabindex="-1">
			</cfoutput>
			<cfif isdefined("form.pageNum_lista") and len(trim(form.pageNum_lista)) eq 0 >
				<cfset form.pageNum_lista = 1 >
			</cfif>
			<cfset Lvarbotones = 'Nuevo, Aplicar'>
			<cfflush interval="128">
			<cfinvoke 
			 component="sif.Componentes.pListas"
			 method="pListaQuery"
			 returnvariable="pListaRet">
				<cfinvokeargument name="query" value="#rsLista#"/>
				<cfinvokeargument name="desplegar" value="Cdescripcion, Edescripcion, Efecha, Eperiodo, Emes, Debitos, Creditos, balanceada"/>
				<cfinvokeargument name="etiquetas" value="Lote, Descripci&oacute;n, Fecha, Periodo, Mes, Débitos, Créditos, &nbsp;"/>
				<cfinvokeargument name="formatos" value="V,V,D,V,V,M,M,V"/>
				<cfinvokeargument name="align" value="left, left, center, center, center, center, right, right"/>
				<cfinvokeargument name="ajustar" value="S"/>
				<cfinvokeargument name="irA" value="DocContablesImportacion.cfm"/>
				<cfinvokeargument name="checkboxes" value="S"/>
				<cfinvokeargument name="keys" value="ECIid"/>
				<cfinvokeargument name="maxRows" value="#form.ver#"/>
				<cfinvokeargument name="incluyeform" value="false"/>
				<cfinvokeargument name="navegacion" value="#navegacion#"/>
				<cfinvokeargument name="formname" value="form1"/>
				<cfinvokeargument name="botones" value="#Lvarbotones#"/>
				<cfinvokeargument name="inactivecol" value="inactivada"/>
			</cfinvoke>
		</form>	
	<cf_web_portlet_end>
<cf_templatefooter>
<cfset LvarCantidad = 1>
<cfif isdefined("url.ver") and len(trim(url.ver)) and isdefined("url.PageNum_lista") and len(trim(url.PageNum_lista))>
	<cfset LvarCantidad = (url.ver * (url.PageNum_lista-1)) + 1>
</cfif>
<script language="javascript1.1" type="text/javascript">
	var LvarDBs  = 0;
	var LvarCRs  = 0;
	var counter2 = 0;
	for (counter2 = 0; counter2 < document.form1.chk.length; counter2++)
	{
		LvarDBs = eval("window.document.form1.DEBITOS_" + (counter2+<cfoutput>#LvarCantidad#</cfoutput>));
		LvarCRs = eval("window.document.form1.CREDITOS_" + (counter2+<cfoutput>#LvarCantidad#</cfoutput>));
		window.document.form1.chk[counter2].disabled = LvarDBs.value != LvarCRs.value || LvarCRs.value == 0;
	}
</script>
